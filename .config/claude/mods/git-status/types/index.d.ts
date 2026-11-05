export type Line = string | undefined

declare module 'claude-code' {
  interface PluginState {
    'git-status': { line: Line }
  }
}
