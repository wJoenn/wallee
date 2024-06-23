<template>
  <BaseField :errors :label :name :optional>
    <textarea
      :id="name"
      v-model="value"
      class="bg border duration-300 focus:border-nuxt focus:outline-none px-4 py-3 rounded transition-colors"
      :class="{ 'bg-danger border-danger focus:border-danger': errors.length > 0 }"
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
