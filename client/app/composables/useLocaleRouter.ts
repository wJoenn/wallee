export const useLocaleRouter = () => {
  const localePath = useLocalePath()
  const router = useRouter()

  const localeRouter = {
    push: async (path: string) => { await router.push(localePath(path)) },
    replace: async (path: string) => { await router.replace(localePath(path)) }
  }

  return localeRouter
}
