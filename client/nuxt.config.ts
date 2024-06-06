// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  ssr: false,

  components: [
    {
      path: "~/components",
      pathPrefix: false
    }
  ],

  css: [
    "~/assets/stylesheets/index.css"
  ],

  experimental: {
    typedPages: true
  },

  typescript: {
    tsConfig: {
      compilerOptions: {
        allowImportingTsExtensions: true,
        moduleDetection: "force"
      }
    }
  },

  modules: [
    "nuxt-icon",
    "@nuxt/image",
    "@nuxtjs/i18n",
    "@pinia/nuxt",
    "@vee-validate/nuxt",
    "@vueuse/nuxt"
  ],

  devtools: {
    enabled: true
  },

  image: {
    dir: "assets/images",
    quality: 80
  },

  i18n: {
    customRoutes: "config",
    defaultLocale: "en",
    locales: ["en"]
  },

  veeValidate: {
    componentNames: {
      Form: "VeeForm"
    }
  }
})
