// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  ssr: false,

  future: {
    compatibilityVersion: 4
  },

  app: {
    head: {
      link: [
        { href: "/icons/apple-touch-icon.png", rel: "apple-touch-icon" },
        { href: "/favicon.ico", rel: "icon" }
      ],
      meta: [
        { content: "Bank account manager", name: "description" },
        { content: "#121212", name: "theme-color" }
      ],
      title: "Wallee"
    }
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

  runtimeConfig: {
    public: {
      apiUrl: ""
    }
  },

  typescript: {
    tsConfig: {
      compilerOptions: {
        allowImportingTsExtensions: true
      }
    }
  },

  modules: [
    "nuxt-icon",
    "@nuxt/eslint",
    "@nuxt/image",
    "@nuxtjs/i18n",
    "@pinia/nuxt",
    "@vee-validate/nuxt",
    "@vite-pwa/nuxt"
  ],

  devtools: {
    enabled: true
  },

  eslint: {
    config: {
      standalone: false
    }
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

  pwa: {
    devOptions: {
      enabled: true,
      type: "module"
    },
    manifest: {
      background_color: "#121212",
      description: "Bank account manager",
      icons: [
        {
          purpose: "any",
          sizes: "16x16",
          src: "icons/favicon-16x16.png",
          type: "image/png"
        },
        {
          purpose: "any",
          sizes: "32x32",
          src: "icons/favicon-32x32.png",
          type: "image/png"
        },
        {
          purpose: "any",
          sizes: "192x192",
          src: "icons/pwa-192x192.png",
          type: "image/png"
        },
        {
          purpose: "any",
          sizes: "512x512",
          src: "icons/pwa-512x512.png",
          type: "image/png"
        },
        {
          purpose: "maskable",
          sizes: "192x192",
          src: "icons/pwa-maskable-192x192.png",
          type: "image/png"
        },
        {
          purpose: "maskable",
          sizes: "512x512",
          src: "icons/pwa-maskable-512x512.png",
          type: "image/png"
        }
      ],
      name: "Wallee",
      short_name: "Wallee",
      theme_color: "#121212"
    }
  },

  veeValidate: {
    componentNames: {
      Form: "VeeForm"
    }
  }
})
