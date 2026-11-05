// Nerd Font glyphs: oct-repo, oct-git_branch, oct-file_submodule,
// oct-arrow_up and oct-arrow_down.
const REPO = '\uf401'
const BRANCH = '\uf418'
const WORKTREE = '\uf414'
const AHEAD = '\uf431'
const BEHIND = '\uf433'

export type RevParse = { toplevel: string; gitDir: string; commonDir: string }

const base = (path: string) => path.replace(/\/+$/, '').split('/').pop() ?? path

function parent(path: string) {
  return path.replace(/\/+$/, '').split('/').slice(0, -1).join('/')
}

// `git rev-parse --show-toplevel --git-dir --git-common-dir`, one per line,
// the two git dirs relative to the cwd when inside the main checkout.
export function parseRevParse(stdout: string, cwd: string): RevParse | undefined {
  const [toplevel, gitDir, commonDir] = stdout.trim().split('\n')
  if (!toplevel || !gitDir || !commonDir) return undefined
  const absolute = (path: string) => (path.startsWith('/') ? path : `${cwd}/${path}`)

  return { toplevel, gitDir: absolute(gitDir), commonDir: absolute(commonDir) }
}

// `git status --porcelain=v2 --branch`.
export function formatStatus(rev: RevParse, porcelain: string): string {
  const lines = porcelain.split('\n').filter(Boolean)
  const header = (name: string) =>
    lines.find(line => line.startsWith(`# branch.${name} `))?.slice(`# branch.${name} `.length)
  const head = header('head')
  const branch = head === '(detached)' ? (header('oid')?.slice(0, 7) ?? 'detached') : head
  const [ahead = 0, behind = 0] = (header('ab') ?? '')
    .split(' ')
    .map(count => Math.abs(Number(count)) || 0)
  const changed = lines.filter(line => !line.startsWith('#')).length

  const isWorktree = rev.gitDir !== rev.commonDir
  const repo = isWorktree ? base(parent(rev.commonDir)) : base(rev.toplevel)
  const parts = [`${REPO} ${repo}`, `${BRANCH} ${branch ?? '?'}`]
  if (isWorktree) parts.push(`${WORKTREE} ${base(rev.toplevel)}`)
  if (changed > 0) parts.push(`±${changed}`)
  if (ahead > 0) parts.push(`${AHEAD}${ahead}`)
  if (behind > 0) parts.push(`${BEHIND}${behind}`)

  return parts.join('  ')
}
