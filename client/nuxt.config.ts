// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  ssr: false,

  future: {
    compatibilityVersion: 4
  },

  components: [
    {
      path: "~/components",
      pathPrefix: false
    }
  ],

  css: [
    "~/assets/stylesheets/index.css"
  ],

  typescript: {
    tsConfig: {
      compilerOptions: {
        allowImportingTsExtensions: true
      }
    }
  },

  modules: [
    "nuxt-icon",
    "@nuxt/image",
    "@nuxtjs/i18n",
    "@pinia/nuxt",
    "@vee-validate/nuxt"
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
