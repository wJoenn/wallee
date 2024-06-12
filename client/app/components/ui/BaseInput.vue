<template>
  <div class="base-input" :class="{ disabled }">
    <input
      :id
      ref="input"
      v-model="value"
      :class="{ focused, invalid: isInvalid }"
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

  watch(() => props.focused, () => {
    if (props.focused) { input.value?.focus() }
  })
</script>

<style scoped>
  .base-input {
    align-items: center;
    background-color: var(--background-primary);
    border: 1px solid var(--color-secondary);
    border-radius: 0.25rem;
    display: flex;
    gap: 0.5rem;
    justify-content: space-between;
    padding: 0.75rem 1rem;
    transition: all 0.3s ease;

    &:has(input:focus), &:has(input.focused) {
      border: 1px solid var(--color-primary);
    }

    &:has(input.invalid) {
      background-color: var(--background-negative);
      border: 1px solid var(--text-negative);
    }

    &.disabled {
      background-color: var(--color-secondary);
      color: #ffffff80;
    }

    input {
      background-color: transparent;
      border: none;
      flex-grow: 1;

      &:focus {
        outline: none;
      }
    }
  }
</style>
