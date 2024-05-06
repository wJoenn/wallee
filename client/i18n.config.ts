import en from "~/assets/locales/en.ts"

export default defineI18nConfig(() => ({
  fallbackWarn: false,
  legacy: false,
  messages: {
    en
  },
  missingWarn: false
}))
