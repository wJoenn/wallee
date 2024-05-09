import type { RecursiveRecord } from "~/types"
import type { User } from "~/types/api"

type Options = {
  body?: RecursiveRecord
  headers?: Record<string, string>
  method?: "GET" | "POST"
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
    users: {
      signInWithToken: () => _fetchApi<User>("/users/current"),
      signUp: (body: RecursiveRecord) => _fetchApi<User>("/users", { body: { user: body }, method: "POST" })
    }
  }
}
