<template>
  <BaseField :errors :label :name>
    <BaseInput
      :id="name"
      :disabled
      inputmode="decimal"
      :is-invalid="errors.length > 0"
      :name
      :placeholder
      step="any"
      type="text"
      :value="value ? String(value) : ''"
      @update:value="handleValueUpdate"
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

  const handleValueUpdate = (newValue: string) => {
    if (!newValue) {
      // @ts-expect-error: value is Ref<number> but I want to reset the value
      value.value = undefined
      return
    }

    const toNumber = Number(newValue.replace(",", "."))
    if (!isNaN(toNumber)) { value.value = toNumber }
  }
</script>
