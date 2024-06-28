import { nuxt } from "eslint-config-joenn"
import withNuxt from "./.nuxt/eslint.config.mjs"

export default withNuxt([
  ...nuxt,
  {
    files: ["**/*.vue"],
    rules: {
      "@typescript-eslint/no-unsafe-call": "off",
      "@typescript-eslint/no-unsafe-member-access": "off"
    }
  }
])
