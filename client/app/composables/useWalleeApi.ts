import type { FetchResponse } from "ofetch"
import type { AsyncDataOptions } from "#app"
import type { BaseModel, RecursiveRecord } from "~~/types"
import type { Account, Transaction, User } from "~~/types/api"

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type Fetch<T> = (...args: any[]) => Promise<FetchResponse<T>>

type Options = {
  body?: RecursiveRecord
  headers?: Record<string, string>
  method?: "DELETE" | "GET" | "PATCH" | "POST"
  params?: Partial<Record<keyof Params, number | string | undefined>>
}

export type Params<T extends BaseModel = BaseModel> = {
  limit?: number
  order?: (Extract<keyof T, string> | [Extract<keyof T, string>, "asc" | "desc"])[]
  where?: [Extract<keyof T, string>, "<" | "=" | ">", string][]
}

const _fetchApi = <T extends BaseModel | BaseModel[]>(path: string, options?: Options) => {
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

const _stringifyParams = <T extends BaseModel>(params: Params<T> = {}) => ({
  ...params,
  order: params.order && JSON.stringify(params.order.map(order => typeof order === "string" ? [order, "asc"] : order)),
  where: params.where && JSON.stringify(params.where)
})

export const walleeApi = {
  accounts: {
    create: (body: RecursiveRecord) => _fetchApi<Account>("/accounts", { body, method: "POST" }),
    destroy: (id: number | string) => _fetchApi<never>(`/accounts/${id}`, { method: "DELETE" }),
    index: (params?: Params<Account>) => _fetchApi<Account[]>("/accounts", {
      params: _stringifyParams<Account>(params)
    }),
    show: (id: number | string) => _fetchApi<Account>(`/accounts/${id}`),
    update: (id: number | string, body: RecursiveRecord) => _fetchApi<Account>(`/accounts/${id}`, {
      body,
      method: "PATCH"
    })
  },
  transactions: {
    create: (body: RecursiveRecord) => _fetchApi<Transaction>("/transactions", { body, method: "POST" }),
    destroy: (id: number | string) => _fetchApi<never>(`/transactions/${id}`, { method: "DELETE" }),
    index: (params?: Params<Transaction>) => _fetchApi<Transaction[]>("/transactions", {
      params: _stringifyParams<Transaction>(params)
    }),
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

export const useWalleeApi = <T extends BaseModel | BaseModel[], F extends Fetch<T>>(
  fetch: F & Fetch<T>,
  maybeRefParams: MaybeRef<Parameters<F>[0]>,
  options?: AsyncDataOptions<T>
) => useLazyAsyncData(crypto.randomUUID(), async () => {
    const params = unref(maybeRefParams)
    const { _data } = await fetch(params)
    return _data!
  }, options)
