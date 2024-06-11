<template>
  <form class="base-form" @submit.prevent="submit">
    <slot />
  </form>
</template>

<script setup lang="ts">
  import type { ZodSchema } from "zod"
  import type { RecursiveRecord } from "~~/types"

  const props = defineProps<{
    initialValues?: RecursiveRecord
    validationSchema: ZodSchema
    action(values: RecursiveRecord): void
  }>()

  defineSlots<{
    default: never
  }>()

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const { handleSubmit, setFieldError } = useForm({
    initialValues: props.initialValues,
    validationSchema: computed(() => toTypedSchema(props.validationSchema))
  })

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const submit = handleSubmit(props.action)

  defineExpose({ setFieldError })
</script>

<style scoped>
  .base-form {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    width: 100%;
  }
</style>
