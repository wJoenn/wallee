<template>
  <input
    :id
    v-model="value"
    class="base-input"
    :class="{ invalid: isInvalid }"
    :disabled
    :name
    :placeholder
    :type
  >
</template>

<script setup lang="ts" generic="T extends InputType">
  import type { InputType, InputValue } from "./types"

  defineProps<{
    id: string
    isInvalid: boolean
    disabled?: boolean
    name: string
    placeholder?: string
    type: T
  }>()

  const value = defineModel<InputValue<T> | undefined>("value")
</script>

<style scoped>
  .base-input {
    background-color: var(--background-primary);
    border: 1px solid var(--color-secondary);
    border-radius: 0.25rem;
    padding: 0.75rem 1rem;
    transition: all 0.3s ease;

    &:focus {
      border: 1px solid var(--color-primary);
      outline: none;
    }

    &.invalid {
      background-color: var(--background-negative);
      border: 1px solid var(--text-negative);

      &:focus {
        border: 1px solid var(--text-negative);
      }
    }
  }
</style>
