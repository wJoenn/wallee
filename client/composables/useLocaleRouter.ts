import { useIonRouter } from "@ionic/vue"

export const useLocaleRouter = () => {
  const localePath = useLocalePath()
  const router = useIonRouter()

  const localeRouter = {
    replace: (path: string) => router.replace(localePath(path))
  }

  return localeRouter
}
