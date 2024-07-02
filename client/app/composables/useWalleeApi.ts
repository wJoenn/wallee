import type { FetchResponse } from "ofetch"
import type { AsyncDataOptions } from "#app"
import type { BaseModel, RecursiveRecord } from "~~/types"
import type { Account, Transaction, User } from "~~/types/api"

type Element<T> = T extends unknown[] ? T[number] : T

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type Fetch<T> = (...args: any[]) => Promise<FetchResponse<T>>

type Options<T extends BaseModel> = {
  body?: RecursiveRecord
  headers?: Record<string, string>
  method?: "DELETE" | "GET" | "PATCH" | "POST"
  params?: Params<T>
}

export type Params<T extends BaseModel = BaseModel> = {
  limit?: number
  order?: (keyof T | [keyof T, "asc" | "desc"])[]
  select: (keyof T)[]
  where?: [keyof T, "<" | "=" | ">", string][]
}

const _fetchApi = <T extends BaseModel | BaseModel[]>(path: string, options?: Options<Element<T>>) => {
  const { public: { apiUrl } } = useRuntimeConfig()

  return $fetch.raw<T>(`${apiUrl}${path}`, {
    headers: {
      "Authorization": localStorage.getItem("bearerToken") ?? "",
      "Content-type": "application/json"
    },
    method: "GET",
    ...options,
    params: _stringifyParams(options?.params)
  })
}

const _parseParamsOrder = <T extends BaseModel>(params: Params<T>) => (
  params.order?.map(order => Array.isArray(order) ? order : [order, "asc"] as const)
)

const _stringifyParams = <T extends BaseModel>(params?: Params<T>) => {
  if (params) {
    return {
      ...params,
      order: params.order && JSON.stringify(_parseParamsOrder(params)),
      select: JSON.stringify(params.select),
      where: params.where && JSON.stringify(params.where)
    }
  }
}

export const walleeApi = {
  accounts: {
    create: (body: RecursiveRecord) => _fetchApi<Account>("/accounts", { body, method: "POST" }),
    destroy: (id: number | string) => _fetchApi<never>(`/accounts/${id}`, { method: "DELETE" }),
    index: (params: Params<Account>) => _fetchApi<Account[]>("/accounts", { params }),
    show: (id: number | string) => _fetchApi<Account>(`/accounts/${id}`),
    update: (id: number | string, body: RecursiveRecord) => _fetchApi<Account>(`/accounts/${id}`, {
      body,
      method: "PATCH"
    })
  },
  transactions: {
    create: (body: RecursiveRecord) => _fetchApi<Transaction>("/transactions", { body, method: "POST" }),
    destroy: (id: number | string) => _fetchApi<never>(`/transactions/${id}`, { method: "DELETE" }),
    index: (params: Params<Transaction>) => _fetchApi<Transaction[]>("/transactions", { params }),
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
  options?: AsyncDataOptions<T> & { infiniteScroll?: T extends unknown[] ? true : never }
) => {
  const hasInfiniteScroll = !!options?.infiniteScroll

  const { data, refresh: _refresh, status } = useLazyAsyncData(crypto.randomUUID(), async () => {
    const params = unref(maybeRefParams)
    const { _data } = await fetch(params)
    return _data!
  }, options)

  const endOfLine = ref(false)
  const fetching = ref(false)
  const scrolling = ref(false)

  const lastElement = computed(() => {
    if (data.value) {
      if (Array.isArray(data.value)) { return (data.value as Element<T>[]).at(-1) }
      return data.value as Element<T>
    }
  })

  const refresh = async () => {
    if (hasInfiniteScroll) {
      window.removeEventListener("scroll", _handleScroll)
      window.scrollTo({ top: 0 })
      endOfLine.value = false
    }

    await _refresh()
  }

  const _handleScroll = async () => {
    if (scrolling.value || endOfLine.value) { return }

    scrolling.value = true
    const isWithinBound = document.body.scrollHeight - window.scrollY < 1500
    if (isWithinBound) { await _next() }

    setTimeout(() => { scrolling.value = false }, 300)
  }

  // eslint-disable-next-line complexity
  const _next = async () => {
    if (fetching.value) { return }

    fetching.value = true
    const params = unref(maybeRefParams) as Params<Element<T>>
    const { limit, where } = params
    const [key, direction] = _parseParamsOrder(params)?.[0] ?? ["id", "asc"] as const

    const nextParams = {
      ...params,
      where: [
        ...(where ?? []),
        [key, direction === "asc" ? ">" : "<", lastElement.value?.[key]]
      ]
    }

    const res = await fetch(nextParams)
    const { _data } = res as unknown as FetchResponse<Element<T>[]>
    endOfLine.value = _data!.length < limit!;
    (data.value as Element<T>[]).push(..._data!)

    fetching.value = false
  }

  onBeforeUnmount(() => { window.removeEventListener("scroll", _handleScroll) })

  watch(data, () => {
    const isArray = Array.isArray(data.value)

    if (isArray && hasInfiniteScroll) {
      const hasLimit = !!unref<Params<Element<T>>>(maybeRefParams).limit

      if (hasLimit) {
        window.addEventListener("scroll", _handleScroll)
      }
    }
  })

  return { data, refresh, status }
}
