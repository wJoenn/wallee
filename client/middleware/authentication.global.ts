type Route = {
  fullPath: string
}

const WHITELIST = [
  "/users/sign_in",
  "/users/sign_up",
]

// eslint-disable-next-line complexity
export default defineNuxtRouteMiddleware(async (to: Route) => {
  const whitelisted = WHITELIST.some(path => to.fullPath.includes(path))

  const localePath = useLocalePath()
  const userStore = useUserStore()

  if (!userStore.isSignedIn) { await userStore.signInWithToken() }
  // eslint-disable-next-line @typescript-eslint/no-unsafe-return
  if (userStore.isSignedIn && whitelisted) { return navigateTo(localePath("/")) }
  // eslint-disable-next-line @typescript-eslint/no-unsafe-return
  if (!userStore.isSignedIn && !whitelisted) { return navigateTo(localePath("/users/sign_in"), { redirectCode: 301 }) }
})
