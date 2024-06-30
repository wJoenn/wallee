import type { BaseModel, Timestamp } from "../index"

export type * from "./errors.d.ts"

export type Account = BaseModel & {
  balance: number
  category: "budget" | "main" | "saving"
  description?: string
  name: string

  executed_transactions: Transaction[]
  planned_transactions: Transaction[]
}

export type Transaction = BaseModel & {
  account_id: number
  description?: string
  transacted_at: Timestamp
  value: number
}

export type User = BaseModel & {
  email: string
}
