import type { DirectiveBinding } from "vue"

export default defineNuxtPlugin(nuxtApp => {
  let handleClickOutside: (event: MouseEvent) => void

  nuxtApp.vueApp.directive("on-click-outside", {
    mounted(el: HTMLElement, binding: DirectiveBinding<() => void>) {
      handleClickOutside = (event: MouseEvent) => {
        const target = event.target as HTMLElement
        if (!el.contains(target)) {
          binding.value()
        }
      }

      window.addEventListener("click", handleClickOutside)
    },

    beforeUnmount() {
      window.removeEventListener("click", handleClickOutside)
    }
  })
})
