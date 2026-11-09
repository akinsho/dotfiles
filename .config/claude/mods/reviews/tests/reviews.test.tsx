import type { On } from 'claude-code'
import { expect, mock, test } from 'claude-code/testing'

import { cruxPages, parseCruxTable, parseGithub } from '../hooks/providers'

const FROM_USER =
  '|ID|Revision|Summary|Approved by|Status|Last touched|\n|---|---|---|---|---|---|\n' +
  '|[CR-316925363][5]|[1][6]|[\\[RufusOrchestrator + 1 other\\] feat\\(qis\\): Add the QIS][5]|__ paulheo|OPEN|6 days ago2026-10-30 15:25:25 PDT|\n' +
  '[5]: /reviews/CR-316925363'
const TO_USER =
  '|Author|ID|Revision|Summary|Approved by|Status|Last touched|\n|---|---|---|---|---|---|---|\n' +
  '|[admj][1]|[CR-319168028][2]|[2][3]|[\\[MShopRufusExperience\\] fix: open links][2]||OPEN|about 15 hours ago2026-11-04 13:07:52 PST|'
const MCP_TEXT =
  JSON.stringify({ content: { status: 'success', content: FROM_USER } }) +
  JSON.stringify({ content: { status: 'success', content: TO_USER } })

const PANE = {
  plugin: 'reviews',
  component: 'Pane',
  requestId: 'reviews',
  props: {
    title: 'Reviews',
    isFocused: false,
    bodyColumns: 60,
    placement: 'dock',
    scroll: { offset: 0, bodyRows: 30 },
    view: {},
  },
} as const

test('a CRUX dashboard row reads as a review', async () => {
  const [mine = '', waiting = ''] = cruxPages(MCP_TEXT)
  expect(parseCruxTable(mine)).toEqual([
    {
      id: 'CR-316925363',
      title: 'feat(qis): Add the QIS',
      repo: 'RufusOrchestrator + 1 other',
      url: 'https://code.amazon.com/reviews/CR-316925363',
      status: 'OPEN',
      approvedBy: ['paulheo'],
      updated: '6 days ago',
    },
  ])
  expect(parseCruxTable(waiting)[0]?.id).toBe('CR-319168028')
  expect(parseCruxTable(waiting)[0]?.approvedBy).toEqual([])
})

test('a page builder-mcp could not read fails the fetch', async () => {
  const failed = JSON.stringify({ content: { input: 'x', error: 'Max retry attempts (2) exceeded' } })
  expect(() => cruxPages(failed)).toThrow('Max retry attempts')
})

test('a GitHub search result reads as a review', async () => {
  const pr = {
    number: 7,
    title: 'Add a thing',
    url: 'https://github.com/a/b/pull/7',
    updatedAt: '2026-11-05T10:00:00Z',
    isDraft: false,
    reviewDecision: 'APPROVED',
    repository: { nameWithOwner: 'a/b' },
    latestReviews: { nodes: [{ state: 'APPROVED', author: { login: 'sam' } }] },
  }
  const now = Date.parse('2026-11-05T12:00:00Z')
  const lists = parseGithub(
    JSON.stringify({ data: { mine: { nodes: [pr] }, waiting: { nodes: [] } } }),
    now,
  )
  expect(lists.mine[0]).toEqual({
    id: '#7',
    title: 'Add a thing',
    repo: 'a/b',
    url: pr.url,
    status: 'APPROVED',
    approvedBy: ['sam'],
    updated: '2h',
  })
  expect(lists.waiting).toEqual([])
})

test('the crux pane lists both sections', { options: { provider: 'crux', user: 'akinzo' } }, async ($, on) => {
  const clock = mock.clock(on)
  mock.env(on, {})
  mock.store(on)
  on('ui.status', () => ({ value: undefined }))
  on('ui.toast', () => ({ value: undefined }))
  on('command.register', () => ({ value: { command: 'reviews' } }))
  on('ui.open', () => ({ value: { isPlaced: true } }))
  on('ui.close', () => ({ value: undefined }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('mcp.call', () => ({
    value: { content: [{ type: 'text', text: MCP_TEXT }], isError: false },
  }))

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.settle()

  const ui = await $.ui.mount({ ...PANE, surface: 'terminal' })
  expect((await ui.find({ type: 'Text', text: /Add the QIS/ }))?.text).toBe('feat(qis): Add the QIS')
  expect(await ui.find({ type: 'Text', text: /open links/ })).toBeTruthy()
  await ui.unmount()
})

const BAND = {
  plugin: 'reviews',
  component: 'AbovePrompt',
  props: { hasSurvey: false, isWorking: false, maxRows: 10, bodyColumns: 80, scroll: { offset: 0, bodyRows: 10 }, view: {} },
} as const

function crux(on: On, text: string) {
  const opened: string[] = []
  const toasts: string[] = []
  const statuses: (string | undefined)[] = []
  on('command.register', () => ({ value: { command: 'reviews' } }))
  on('ui.open', (_, e) => {
    opened.push(e.id)
    return { value: { isPlaced: true } }
  })
  on('ui.close', () => ({ value: undefined }))
  on('ui.toast', (_, e) => {
    toasts.push(e.text)
    return { value: undefined }
  })
  on('ui.status', (_, e) => {
    statuses.push(e.text)
    return { value: undefined }
  })
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('mcp.call', () => ({ value: { content: [{ type: 'text', text }], isError: false } }))

  return { opened, toasts, statuses }
}

test('reviews show as a status and a band, and the pane waits for /reviews', { options: { provider: 'crux', user: 'akinzo' } }, async ($, on) => {
  const clock = mock.clock(on)
  mock.env(on, {})
  mock.store(on)
  const seen = crux(on, MCP_TEXT)

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.settle()

  expect(seen.opened).toEqual([])
  expect(seen.statuses.at(-1)).toBe('reviews: 1 waiting on you · 1 yours')
  const band = await $.ui.mount({ ...BAND, surface: 'terminal' })
  expect(await band.find({ type: 'Text', text: /1 review waiting on you/ })).toBeTruthy()
  await band.unmount()

  await $.command.run({ command: 'reviews', args: '' })
  expect(seen.opened).toEqual(['reviews'])
})

test('a review waiting on you is toasted once, whichever session saw it first', { options: { provider: 'crux', user: 'akinzo', refreshMinutes: 1 } }, async ($, on) => {
  const clock = mock.clock(on)
  mock.env(on, {})
  mock.store(on, { toasted: [] })
  const seen = crux(on, MCP_TEXT)

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.settle()
  await clock.advance(60_000)

  expect(seen.toasts).toEqual(['Review waiting on you: fix: open links'])
})

test('a review another session already toasted is not toasted again', { options: { provider: 'crux', user: 'akinzo' } }, async ($, on) => {
  const clock = mock.clock(on)
  mock.env(on, {})
  mock.store(on, { toasted: ['CR-319168028'] })
  const seen = crux(on, MCP_TEXT)

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.settle()

  expect(seen.toasts).toEqual([])
})

test('an empty dashboard clears the status and draws no band', { options: { provider: 'crux', user: 'akinzo' } }, async ($, on) => {
  const clock = mock.clock(on)
  mock.env(on, {})
  mock.store(on)
  const seen = crux(on, '')
  on('ui.render', ($, e) => {
    const { Text } = $.ui.resolve(e)
    return <Text>engine</Text>
  })

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.settle()

  expect(seen.opened).toEqual([])
  expect(seen.statuses.at(-1)).toBeUndefined()
  const band = await $.ui.mount({ ...BAND, surface: 'terminal' })
  expect(await band.find({ type: 'Text', text: /waiting on you/ })).toBeFalsy()
  await band.unmount()
})

test('failed fetches back off, then stop until a refresh by hand', { options: { provider: 'crux', user: 'akinzo', refreshMinutes: 1 } }, async ($, on) => {
  const clock = mock.clock(on)
  mock.env(on, {})
  let calls = 0
  on('command.register', () => ({ value: { command: 'reviews' } }))
  on('ui.open', () => ({ value: { isPlaced: true } }))
  on('ui.close', () => ({ value: undefined }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('mcp.call', () => {
    calls += 1
    return { value: { content: [{ type: 'text', text: 'HTTP error! status: 401' }], isError: true } }
  })

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.settle()
  expect(calls).toBe(1)

  // Retries wait 2, 4, 8 and 16 minutes; the fifth failure stops the pane.
  for (const minutes of [2, 4, 8, 16]) {
    await clock.advance(minutes * 60_000 - 1)
    const before = calls
    await clock.advance(1)
    expect(calls).toBe(before + 1)
  }
  expect(calls).toBe(5)
  await clock.advance(24 * 60 * 60_000)
  expect(calls).toBe(5)

  await $.command.run({ command: 'reviews', args: '' })
  expect(calls).toBe(6)
})

test('a successful fetch keeps the regular interval', { options: { provider: 'crux', user: 'akinzo', refreshMinutes: 1 } }, async ($, on) => {
  const clock = mock.clock(on)
  mock.env(on, {})
  mock.store(on)
  on('ui.status', () => ({ value: undefined }))
  on('ui.toast', () => ({ value: undefined }))
  let calls = 0
  on('command.register', () => ({ value: { command: 'reviews' } }))
  on('ui.open', () => ({ value: { isPlaced: true } }))
  on('ui.close', () => ({ value: undefined }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('mcp.call', () => {
    calls += 1
    return { value: { content: [{ type: 'text', text: MCP_TEXT }], isError: false } }
  })

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.settle()
  await clock.advance(3 * 60_000)
  expect(calls).toBe(4)
})
