import type { FetchResponse } from "ofetch"
import type { AsyncDataOptions } from "#app"
import type { RecursiveRecord } from "~~/types"
import type { Account, Transaction, User } from "~~/types/api"

type ID = number | string

type Options = {
  body?: RecursiveRecord
  headers?: Record<string, string>
  method?: "DELETE" | "GET" | "PATCH" | "POST"
  params?: Record<keyof Params, string | undefined>
}

type Params<T extends RecursiveRecord = RecursiveRecord> = {
  filters?: [Extract<keyof T, string>, "<" | "=" | ">", string][]
  order?: (Extract<keyof T, string> | [Extract<keyof T, string>, "asc" | "desc"])[]
}

const _fetchApi = <T>(path: string, options?: Options) => {
  const { public: { apiUrl } } = useRuntimeConfig()

  return $fetch.raw<T>(`${apiUrl}${path}`, {
    headers: {
      "Authorization": localStorage.getItem("bearerToken") ?? "",
      "Content-type": "application/json"
    },
    method: "GET",
    ...options
  })
}

const _stringifyParams = <T extends RecursiveRecord>(params: Params<T> = {}) => ({
  filters: params.filters && JSON.stringify(params.filters),
  order: params.order && JSON.stringify(params.order.map(order => typeof order === "string" ? [order, "asc"] : order))
})

export const walleeApi = {
  accounts: {
    create: (body: RecursiveRecord) => _fetchApi<Account>("/accounts", { body, method: "POST" }),
    destroy: (id: ID) => _fetchApi<never>(`/accounts/${id}`, { method: "DELETE" }),
    index: (params?: Params<Account>) => _fetchApi<Account[]>("/accounts", {
      params: _stringifyParams<Account>(params)
    }),
    show: (id: ID) => _fetchApi<Account>(`/accounts/${id}`),
    update: (id: ID, body: RecursiveRecord) => _fetchApi<Account>(`/accounts/${id}`, {
      body,
      method: "PATCH"
    })
  },
  transactions: {
    create: (body: RecursiveRecord) => _fetchApi<Transaction>("/transactions", { body, method: "POST" }),
    destroy: (id: ID) => _fetchApi<never>(`/transactions/${id}`, { method: "DELETE" }),
    index: (params?: Params<Transaction>) => _fetchApi<Transaction[]>("/transactions", {
      params: _stringifyParams<Transaction>(params)
    }),
    show: (id: ID) => _fetchApi<Transaction>(`/transactions/${id}`),
    update: (id: ID, body: RecursiveRecord) => _fetchApi<Transaction>(`/transactions/${id}`, {
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

export const useWalleeApi = <T>(
  call: (api: typeof walleeApi) => Promise<FetchResponse<T>>,
  options?: AsyncDataOptions<T>
) => useLazyAsyncData(crypto.randomUUID(), async () => {
    const { _data } = await call(walleeApi)
    return _data!
  }, options)
