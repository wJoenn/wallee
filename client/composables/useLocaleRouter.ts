import { useIonRouter } from "@ionic/vue"

export const useLocaleRouter = () => {
  const localePath = useLocalePath()
  const router = useIonRouter()

  const localeRouter = {
    push: (path: string) => router.push(localePath(path)),
    replace: (path: string) => router.replace(localePath(path))
  }

  return localeRouter
}
