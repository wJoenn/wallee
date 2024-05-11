export type * from "./errors.d.ts"

export type Transaction = {
  description?: string
  id: number
  value: number
}

export type User = {
  email: string
  id: number
}
