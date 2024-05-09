import type { RecursiveRecord } from "~/types"
import type { User, UserErrors } from "~/types/api"

import { FetchError } from "ofetch"

export const useUserStore = defineStore("UserStore", () => {
  const api = useApi()

  const user = ref<User>()

  const isSignedIn = computed(() => !!user.value)

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

  const signUp = async (body: RecursiveRecord) => {
    try {
      const { _data, headers } = await api.users.signUp(body)
      localStorage.bearerToken = headers.get("Authorization")!
      user.value = _data

      return { data: _data!, status: "success" as const }
    } catch (error) {
      return _handleError(error)
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

  return { isSignedIn, signInWithToken, signUp, user }
})
