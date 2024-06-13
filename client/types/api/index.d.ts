import type { Timestamp } from "../index"

export type * from "./errors.d.ts"

export type Account = {
  balance: number
  description?: string
  id: number
  name: string

  transactions: Transaction[]
}

export type Transaction = {
  account_id: number
  description?: string
  id: number
  transacted_at: Timestamp
  value: number
}

export type User = {
  email: string
  id: number
}
