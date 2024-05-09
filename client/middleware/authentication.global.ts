type Route = {
  fullPath: string
}

const WHITELIST = [
  "/users/sign_up"
]

// eslint-disable-next-line complexity
export default defineNuxtRouteMiddleware(async (to: Route) => {
  const localePath = useLocalePath()
  const userStore = useUserStore()

  if (!userStore.isSignedIn) { await userStore.signInWithToken() }

  if (userStore.isSignedIn && WHITELIST.includes(to.fullPath)) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-return
    return navigateTo(localePath("/"))
  }

  if (!userStore.isSignedIn && !WHITELIST.includes(to.fullPath)) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-return
    return navigateTo(localePath("/users/sign_up"), { redirectCode: 301 })
  }
})
