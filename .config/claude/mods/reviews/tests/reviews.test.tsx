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

test('an empty dashboard opens no pane', { options: { provider: 'crux', user: 'akinzo' } }, async ($, on) => {
  const clock = mock.clock(on)
  mock.env(on, {})
  const opened: string[] = []
  on('command.register', () => ({ value: { command: 'reviews' } }))
  on('ui.open', (_, e) => {
    opened.push(e.id)
    return { value: { isPlaced: true } }
  })
  on('ui.close', () => ({ value: undefined }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('mcp.call', () => ({ value: { content: [{ type: 'text', text: '' }], isError: false } }))

  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await clock.settle()

  expect(opened).toEqual([])
})
