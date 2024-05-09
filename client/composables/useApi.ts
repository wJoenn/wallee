import type { RecursiveRecord } from "~/types"
import type { User } from "~/types/api"

type Options = {
  body: RecursiveRecord
  method: "POST"
}

const API_URL = "http://localhost:8080"

export const useApi = () => {
  const _fetchApi = <T = unknown>(path: string, options: Options) => $fetch.raw<T>(`${API_URL}${path}`, options)

  return {
    users: {
      sign_up: (body: RecursiveRecord) => _fetchApi<User>("/users", { body: { user: body }, method: "POST" })
    }
  }
}
