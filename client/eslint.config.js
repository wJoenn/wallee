import { nuxt } from "eslint-config-joenn"

export default [
  ...nuxt,
  {
    files: ["server/**/*.ts"],
    rules: {
      "import/extensions": "off"
    }
  }
]
