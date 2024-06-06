export const useLocaleRouter = () => {
  const localePath = useLocalePath()
  const router = useRouter()

  const localeRouter = {
    push: (path: string) => { router.push(localePath(path)) },
    replace: (path: string) => { router.replace(localePath(path)) }
  }

  return localeRouter
}
