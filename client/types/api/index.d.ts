import type { Timestamp } from "../index"

export type * from "./errors.d.ts"

export type Transaction = {
  description?: string
  id: number
  transacted_at: Timestamp
  value: number
}

export type User = {
  email: string
  id: number
}
