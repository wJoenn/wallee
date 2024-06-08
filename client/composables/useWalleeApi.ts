import type { RecursiveRecord } from "~/types"
import type { Transaction, User } from "~/types/api"

type Options = {
  body?: RecursiveRecord
  headers?: Record<string, string>
  method?: "DELETE" | "GET" | "PATCH" | "POST"
}

const API_URL = "http://localhost:8080"

const _defaultOptions = (): Options => ({
  headers: {
    "Authorization": localStorage.getItem("bearerToken") ?? "",
    "Content-type": "application/json"
  },
  method: "GET"
})

const _fetchApi = <T>(path: string, options?: Options) => $fetch.raw<T>(`${API_URL}${path}`, {
  ..._defaultOptions(),
  ...options
})

export const walleeApi = {
  transactions: {
    create: (body: RecursiveRecord) => _fetchApi<Transaction>("/transactions", { body, method: "POST" }),
    index: () => _fetchApi<Transaction[]>("/transactions"),
    show: (id: number | string) => _fetchApi<Transaction>(`/transactions/${id}`),
    update: (id: number | string, body: RecursiveRecord) => _fetchApi<Transaction>(`/transactions/${id}`, {
      body,
      method: "PATCH"
    })
  },
  users: {
    signIn: (body: RecursiveRecord) => _fetchApi<User>("/users/sign_in", { body: { user: body }, method: "POST" }),
    signInWithToken: () => _fetchApi<User>("/users/current"),
    signOut: () => _fetchApi<never>("/users/sign_out", { method: "DELETE" }),
    signUp: (body: RecursiveRecord) => _fetchApi<User>("/users", { body: { user: body }, method: "POST" })
  }
}

export const useWalleeApi = <T>(call: (api: typeof walleeApi) => Promise<T>) => (
  useAsyncData(crypto.randomUUID(), () => call(walleeApi))
)