import type { RecursiveRecord } from "~/types"
import type { Transaction, User } from "~/types/api"

type Options = {
  body?: RecursiveRecord
  headers?: Record<string, string>
  method?: "DELETE" | "GET" | "POST"
}

const API_URL = "http://localhost:8080"

export const useApi = () => {
  const _defaultOptions = (): Options => ({
    headers: {
      "Authorization": localStorage.getItem("bearerToken") ?? "",
      "Content-type": "application/json"
    },
    method: "GET"
  })

  const _fetchApi = <T = unknown>(path: string, options?: Options) => $fetch.raw<T>(`${API_URL}${path}`, {
    ..._defaultOptions(),
    ...options
  })

  return {
    transactions: {
      index: () => _fetchApi<Transaction[]>("/transactions")
    },
    users: {
      signIn: (body: RecursiveRecord) => _fetchApi<User>("/users/sign_in", { body: { user: body }, method: "POST" }),
      signInWithToken: () => _fetchApi<User>("/users/current"),
      signOut: () => _fetchApi<never>("/users/sign_out", { method: "DELETE" }),
      signUp: (body: RecursiveRecord) => _fetchApi<User>("/users", { body: { user: body }, method: "POST" })
    }
  }
}
