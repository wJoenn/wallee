import type { Timestamp } from "../index"

export type * from "./errors.d.ts"

export type Budget = {
  balance: number
  description?: string
  id: number
  name: string
}

export type Transaction = {
  budget_id?: number
  description?: string
  id: number
  transacted_at: Timestamp
  value: number
}

export type User = {
  email: string
  id: number
}
