<template>
  <div class="base-input">
    <input
      :id
      v-model="value"
      :class="{ invalid: isInvalid }"
      :disabled
      :name
      :placeholder
      :type
    >

    <slot name="caption" />
  </div>
</template>

<script setup lang="ts" generic="T extends keyof InputValue">
  import type { InputValue } from "./types"

  defineProps<{
    id: string
    isInvalid: boolean
    disabled?: boolean
    name: string
    placeholder?: string
    type: T
  }>()

  defineSlots<{
    caption: never
  }>()

  const value = defineModel<InputValue[T] | undefined>("value")
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

    &:has(input:focus) {
      border: 1px solid var(--color-primary);
    }

    &:has(input.invalid) {
      background-color: var(--background-negative);
      border: 1px solid var(--text-negative);
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
