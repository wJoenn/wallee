import type { Config } from "tailwindcss"
import type { PluginAPI } from "tailwindcss/types/config"

const defaultVariant = ({ addVariant }: PluginAPI) => { addVariant("default", "html :where(&)") }

export default {
  plugins: [defaultVariant],
  theme: {
    extend: {
      backgroundColor: {
        DEFAULT: "#121212",
        negative: "#351216",
        primary: "#121212",
        secondary: "#303030"
      },

      borderColor: {
        DEFAULT: "#303030"
      },

      colors: {
        danger: "#bf051c",
        nuxt: "#00db80"
      },

      textColor: {
        DEFAULT: "#ffffff",

        contrasted: "#121212",
        primary: "#ffffff",
        secondary: "#ffffff80"
      }
    }
  }
} satisfies Omit<Config, "content">
