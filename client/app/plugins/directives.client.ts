import { vMaska } from "maska/vue"
import { vOnClickOutside } from "@vueuse/components"

export default defineNuxtPlugin(nuxtApp => {
  nuxtApp.vueApp.directive("maska", vMaska)
  nuxtApp.vueApp.directive("on-click-outside", vOnClickOutside)
})
