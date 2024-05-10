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

  const _handleError = (error: unknown) => {
    if (error instanceof FetchError) {
      if (error.statusCode === 401) {
        return { data: error.data as UserErrors | undefined, status: "unauthorized" as const }
      }

      if (error.statusCode === 422) {
        return { data: error.data as UserErrors, status: "unprocessable_entity" as const }
      }

      throw error
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

  return { isSignedIn, signIn, signUp, user }
})
