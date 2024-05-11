<template>
  <BaseField :errors :label :name>
    <BaseInput
      :id="name"
      v-model:value="value"
      :disabled
      :is-invalid="errors.length > 0"
      :name
      :placeholder
      type="number"
    />
  </BaseField>
</template>

<script setup lang="ts">
  const props = defineProps<{
    disabled?: boolean
    label: string
    name: string
    placeholder?: string
  }>()

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const { errors, value } = useField<number>(props.name)
</script>
