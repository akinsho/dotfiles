import { expect, test } from 'claude-code/testing'

import { formatStatus, parseRevParse } from '../hooks/format'

const PORCELAIN = [
  '# branch.oid 087d0d23aa',
  '# branch.head main',
  '# branch.upstream origin/main',
  '# branch.ab +2 -1',
  '1 .M N... 100644 100644 100644 a b .config/zsh/.zshenv',
  '? .config/claude/rules/git-worktrees.md',
].join('\n')

test('the main checkout shows repo, branch, changes and divergence', async () => {
  const rev = parseRevParse('/Users/me/dotfiles\n.git\n.git\n', '/Users/me/dotfiles')!
  expect(formatStatus(rev, PORCELAIN)).toBe('\uf401 dotfiles  \uf418 main  ±2  \uf4312  \uf4331')
})

test('a linked worktree names the main repo and the worktree', async () => {
  const rev = parseRevParse(
    '/Users/me/dotfiles/.claude/worktrees/review-pane\n/Users/me/dotfiles/.git/worktrees/review-pane\n/Users/me/dotfiles/.git\n',
    '/Users/me/dotfiles/.claude/worktrees/review-pane',
  )!
  expect(formatStatus(rev, '# branch.oid abc1234def\n# branch.head review-pane\n')).toBe(
    '\uf401 dotfiles  \uf418 review-pane  \uf414 review-pane',
  )
})

test('a detached head shows the short commit', async () => {
  const rev = parseRevParse('/r\n.git\n.git\n', '/r')!
  expect(formatStatus(rev, '# branch.oid abc1234def\n# branch.head (detached)\n')).toBe('\uf401 r  \uf418 abc1234')
})
