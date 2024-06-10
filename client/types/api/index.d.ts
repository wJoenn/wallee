import type { Timestamp } from "../index"

export type * from "./errors.d.ts"

export type Budget = {
  description?: string
  id: number
  name: string

  transactions: Transaction[]
}

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
