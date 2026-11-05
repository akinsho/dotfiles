export type Review = {
  id: string
  title: string
  repo: string
  url: string
  status: string
  approvedBy: string[]
  updated: string
}

export type Reviews = {
  mine: Review[]
  waiting: Review[]
  fetchedAt: number
  error?: string
}

declare module 'claude-code' {
  interface PluginState {
    reviews: { reviews: Shaped<Reviews | null> }
  }
}
