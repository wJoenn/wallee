<template>
  <BaseField :errors :label :name>
    <BaseInput
      :id="name"
      v-model:value="value"
      :disabled
      :is-invalid="errors.length > 0"
      :name
      :placeholder
      type="date"
    />
  </BaseField>
</template>

<script setup lang="ts">
  import type { Timestamp } from "~/types"

  const props = defineProps<{
    disabled?: boolean
    label: string
    name: string
    placeholder?: string
  }>()

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const { errors, value } = useField<Timestamp>(props.name)
</script>

<style scoped>
  .long-text-field {
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
