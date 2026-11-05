import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import { formatStatus, parseRevParse } from './format'

const line = atom({ plugin: 'git-status', key: 'line' } as const, undefined)

async function describe($: EngineInterface): Promise<string | undefined> {
  const cwd = await $.session.cwd()
  const rev = await $.process.run(
    ['git', 'rev-parse', '--show-toplevel', '--git-dir', '--git-common-dir'],
    { cwd },
  )
  const parsed = rev.exitCode === 0 ? parseRevParse(rev.stdout, cwd) : undefined
  if (!parsed) return undefined
  const status = await $.process.run(
    ['git', '--no-optional-locks', 'status', '--porcelain=v2', '--branch'],
    { cwd },
  )

  return status.exitCode === 0 ? formatStatus(parsed, status.stdout) : undefined
}

async function show($: EngineInterface) {
  const text = await describe($).catch(() => undefined)
  await update($, line, () => text)
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const started = await next(e)
    $.ui.status(undefined)
    void show($)
    $.clock.every(20_000, () => void show($))

    return started
  })

  on('turn.complete', async ($, e, next) => {
    const done = await next(e)
    void show($)

    return done
  })

  on('ui.render', { component: 'PromptHint' }, async ($, e, next) => {
    const text = await read($, line)

    return text ? next({ ...e, props: { ...e.props, tail: text } }) : next(e)
  })
}
