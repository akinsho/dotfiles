import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { Review } from '../types'
import { cruxPages, GITHUB_QUERY, parseCruxTable, parseGithub } from './providers'
import type { Lists } from './providers'

const PANE = 'reviews'
const COLUMNS = 48
const LOOK = { title: 'Reviews', backgroundColor: 'transparent' } as const

// Each review takes four lines, each section a header of three and a gap, and
// the frame two.
function height(lists: Lists): number {
  const sections = [lists.waiting, lists.mine].filter(list => list.length > 0)

  return sections.reduce((rows, list) => rows + 4 + list.length * 4, 3)
}
const reviews = atom({ plugin: 'reviews', key: 'reviews' } as const, null, {
  shape: 'reviews-1',
})

type Provider = 'github' | 'crux'
type Settings = { provider: string; user: string }

let source: Provider | undefined
let isFetching = false
let isDismissed = false
let seen = new Set<string>()

async function onPath($: EngineInterface, command: string): Promise<boolean> {
  const ran = await $.process
    .run(['sh', '-c', `command -v ${command}`])
    .catch(() => undefined)

  return ran?.exitCode === 0
}

async function pick($: EngineInterface, provider: string): Promise<Provider | undefined> {
  if (provider === 'github' || provider === 'crux') return provider
  if (provider !== 'auto') return undefined
  if (await onPath($, 'cr')) return 'crux'
  if (await onPath($, 'gh')) return 'github'

  return undefined
}

async function fetchGithub($: EngineInterface): Promise<Lists> {
  const ran = await $.process.run(['gh', 'api', 'graphql', '-f', `query=${GITHUB_QUERY}`])
  if (ran.exitCode !== 0) throw new Error(ran.stderr.trim() || 'gh failed')

  return parseGithub(ran.stdout, await $.clock.now())
}

async function fetchCrux($: EngineInterface, user: string): Promise<Lists> {
  const base = 'https://code.amazon.com/reviews'
  const result = await $.mcp.call('builder-mcp', 'ReadInternalWebsites', {
    inputs: [`${base}/from-user/${user}`, `${base}/to-user/${user}`],
  })
  const text = result.content
    .map(block => ('text' in block && typeof block.text === 'string' ? block.text : ''))
    .join('')
  if (result.isError) throw new Error(text.slice(0, 200) || 'builder-mcp failed')
  const [mine = '', waiting = ''] = cruxPages(text)

  return { mine: parseCruxTable(mine), waiting: parseCruxTable(waiting) }
}

// Opens the pane when there is something to show and closes it when there is
// not. A pane the person closed stays closed until a new review waits on them.
async function place($: EngineInterface, lists: Lists) {
  const waiting = lists.waiting.map(review => review.id)
  if (waiting.some(id => !seen.has(id))) isDismissed = false
  seen = new Set(waiting)

  if (lists.mine.length + lists.waiting.length === 0) {
    await $.ui.close({ id: PANE })
  } else if (!isDismissed) {
    await $.ui.open({ id: PANE, ...LOOK, rows: height(lists), columns: COLUMNS })
  }
}

async function refresh($: EngineInterface, settings: Settings) {
  if (isFetching || !source) return
  isFetching = true
  try {
    const user = settings.user || (await $.env.get('USER')) || ''
    const lists = source === 'crux' ? await fetchCrux($, user) : await fetchGithub($)
    const fetchedAt = await $.clock.now()
    await update($, reviews, () => ({ ...lists, fetchedAt }))
    await place($, lists)
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error)
    const fetchedAt = await $.clock.now()
    await update($, reviews, last => ({
      mine: last?.mine ?? [],
      waiting: last?.waiting ?? [],
      fetchedAt,
      error: message.split('\n')[0],
    }))
  } finally {
    isFetching = false
  }
}

async function openUrl($: EngineInterface, url: string) {
  const ran = await $.process.run(['open', url]).catch(() => undefined)
  if (ran?.exitCode !== 0) await $.process.run(['xdg-open', url])
}

export const register: Register = (on, options) => {
  const minutes = Math.max(1, Number(options.refreshMinutes ?? 5))
  const settings: Settings = {
    provider: String(options.provider ?? 'auto'),
    user: String(options.user ?? ''),
  }

  on('session.start', async ($, e, next) => {
    const started = await next(e)
    source = await pick($, settings.provider)
    if (!source) return started

    await $.command.register({
      name: 'reviews',
      description: 'Show your open reviews and the ones waiting on you',
    })
    void refresh($, settings)
    $.clock.every(minutes * 60_000, () => void refresh($, settings))

    return started
  })

  on('command.run', { command: 'reviews' }, async $ => {
    isDismissed = false
    await refresh($, settings)
    const state = await read($, reviews)
    if (state?.error) return { text: `Could not read ${source} reviews: ${state.error}` }
    if (!state || state.mine.length + state.waiting.length === 0) {
      return { text: 'No open reviews, and none waiting on you.' }
    }
    await $.ui.open({ id: PANE, ...LOOK, focus: true, rows: height(state), columns: COLUMNS })

    return { text: 'Reviews pane opened.' }
  })

  on('ui.close', { id: PANE }, async ($, e, next) => {
    if (e.origin.kind === 'person') isDismissed = true

    return next(e)
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Button, Text } = $.ui.resolve(e)
    const state = await read($, reviews)

    const row = (review: Review) => (
      <Box key={review.id} flexDirection="column">
        <Button key={`open-${review.id}`} plain onPress={() => void openUrl($, review.url)}>
          <Text bold underline wrap="truncate-end">
            {review.title}
          </Text>
        </Button>
        <Text dimColor wrap="wrap">
          {review.id} {review.repo ? `· ${review.repo} ` : ''}· {review.status}
          {review.approvedBy.length > 0 ? ` · ✓ ${review.approvedBy.join(', ')}` : ''}
          {review.updated ? ` · ${review.updated}` : ''}
        </Text>
        <Box marginBottom={1}>
          <Button
            key={`ask-${review.id}`}
            label="address"
            dimColor
            onPress={() =>
              void $.prompt.fill({
                text: `Address the open review comments on ${review.url}`,
                mode: 'replace',
              })
            }
          />
        </Box>
      </Box>
    )

    const rule = '─'.repeat(Math.max(8, e.props.bodyColumns - 4))
    const section = (title: string, list: Review[]) =>
      list.length > 0 && (
        <Box flexDirection="column" marginBottom={1}>
          <Text color="claude">{rule}</Text>
          <Text bold color="claude">
            {title.toUpperCase()} <Text dimColor>{list.length}</Text>
          </Text>
          <Text color="claude">{rule}</Text>
          {list.map(row)}
        </Box>
      )

    return (
      <Box flexDirection="column" borderStyle="single" borderColor="subtle" paddingX={1}>
        {state?.error && (
          <Text dimColor wrap="truncate-end">
            Last refresh failed: {state.error}
          </Text>
        )}
        {section('Waiting on you', state?.waiting ?? [])}
        {section('Yours', state?.mine ?? [])}
        <Button key="refresh" label="refresh" hotkey="r" dimColor onPress={() => void refresh($, settings)} />
      </Box>
    )
  })
}
