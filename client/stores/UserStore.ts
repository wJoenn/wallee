import type { FetchResponse } from "ofetch"
import type { RecursiveRecord } from "~/types"
import type { User, UserErrors } from "~/types/api"

import { FetchError } from "ofetch"

export const useUserStore = defineStore("UserStore", () => {
  const api = useApi()

  const user = ref<User>()

  const isSignedIn = computed(() => !!user.value)

  const signIn = async (body: RecursiveRecord) => _post(api.users.signIn, body)
  const signUp = async (body: RecursiveRecord) => _post(api.users.signUp, body)

  const signInWithToken = async () => {
    if (!isSignedIn.value && localStorage.getItem("bearerToken")?.startsWith("Bearer")) {
      try {
        const { _data } = await api.users.signInWithToken()
        user.value = _data
        return { data: _data!, status: "success" as const }
      } catch (error) {
        return _handleError(error)
      }
    }
  }

  const _handleError = (error: unknown) => {
    if (error instanceof FetchError) {
      switch (error.statusCode) {
      case 401:
        user.value = undefined
        localStorage.removeItem("bearerToken")
        return { status: "unauthorized" as const }
      case 422:
        return { data: error.data as UserErrors, status: "unprocessable_entity" as const }
      default:
        throw error
      }
    }

    throw error
  }

  const _post = async (post: (body: RecursiveRecord) => Promise<FetchResponse<User>>, body: RecursiveRecord) => {
    try {
      const { _data, headers } = await post(body)
      localStorage.bearerToken = headers.get("Authorization")
      user.value = _data

      return { data: _data!, status: "success" as const }
    } catch (error) {
      return _handleError(error)
    }
  }

  return { isSignedIn, signIn, signInWithToken, signUp, user }
})
