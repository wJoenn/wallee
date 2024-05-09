import type { RecursiveRecord } from "~/types"
import type { User, UserErrors } from "~/types/api"

import { FetchError } from "ofetch"

type UserResponse = {
  data: User
  status: "success"
} | {
  data: UserErrors
  status: "error"
}

export const useUserStore = defineStore("UserStore", () => {
  const api = useApi()

  const user = ref<User>()

  const isSignedIn = computed(() => !!user.value)

  const signUp = async (body: RecursiveRecord): Promise<UserResponse> => {
    try {
      const { _data, headers } = await api.users.sign_up(body)
      localStorage.bearerToken = headers.get("Authorization")
      user.value = _data

      return { data: _data!, status: "success" }
    } catch (error) {
      if (error instanceof FetchError) {
        if (error.statusCode === 422) {
          return { data: error.data as UserErrors, status: "error" }
        }

        throw error
      } else {
        throw error
      }
    }
  }

  return { isSignedIn, signUp, user }
})
