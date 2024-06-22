<template>
  <BaseField :errors :label :name :optional>
    <textarea
      :id="name"
      v-model="value"
      class="long-text-field"
      :class="{ invalid: errors.length > 0 }"
      :disabled
      :name
      :placeholder
      rows="5"
    />
  </BaseField>
</template>

<script setup lang="ts">
  const props = defineProps<{
    disabled?: boolean
    label: string
    name: string
    optional?: boolean
    placeholder?: string
  }>()

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const { errors, value } = useField<string>(props.name)
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
