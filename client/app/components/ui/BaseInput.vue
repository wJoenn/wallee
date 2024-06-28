<template>
  <div
    class="border duration-300 flex focus-within:border-nuxt gap-2 items-center justify-between px-4 py-3 rounded transition-colors"
    :class="{ 'bg-secondary text-secondary': disabled, 'border-nuxt': focused, '!bg-negative !border-danger': isInvalid }"
  >
    <input
      :id
      ref="input"
      v-model="value"
      class="bg-transparent flex-grow focus:outline-none"
      :disabled
      :name
      :placeholder
      :type
      v-bind="$attrs"
    >

    <slot name="caption" />
  </div>
</template>

<script setup lang="ts" generic="T extends keyof InputValue">
  import type { InputValue } from "./types"

  const props = defineProps<{
    id: string
    isInvalid: boolean
    disabled?: boolean
    focused?: boolean
    name: string
    placeholder?: string
    type: T
  }>()

  defineOptions({
    inheritAttrs: false
  })

  defineSlots<{
    caption: never
  }>()

  const value = defineModel<InputValue[T]>("value")

  const input = ref<HTMLInputElement>()

  const focus = () => {
    input.value?.focus()
  }

  watch(() => props.focused, () => { if (props.focused) { focus() } })

  defineExpose({ focus })
</script>
