import type { RecursiveRecord } from "~/types"
import type { User, UserErrors } from "~/types/api"

import { FetchError, type FetchResponse } from "ofetch"

export const useUserStore = defineStore("UserStore", () => {
  const router = useLocaleRouter()

  const user = ref<User>()

  const isSignedIn = computed(() => !!user.value)

  const signIn = async (body: RecursiveRecord) => _post(walleeApi.users.signIn, body)
  const signUp = async (body: RecursiveRecord) => _post(walleeApi.users.signUp, body)

  const signInWithToken = async () => {
    if (!isSignedIn.value && localStorage.getItem("bearerToken")?.startsWith("Bearer")) {
      try {
        const { _data } = await walleeApi.users.signInWithToken()
        user.value = _data
        return { data: _data!, status: "success" as const }
      } catch (error) {
        return _handleError(error)
      }
    }
  }

  const signOut = async () => {
    await walleeApi.users.signOut()
    _reset()
    await router.replace("/users/sign_in")
  }

  const _handleError = (error: unknown) => {
    if (error instanceof FetchError) {
      switch (error.statusCode) {
      case 401:
        _reset()
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

  const _reset = () => {
    user.value = undefined
    localStorage.removeItem("bearerToken")
  }

  return { isSignedIn, signIn, signInWithToken, signOut, signUp, user }
})
