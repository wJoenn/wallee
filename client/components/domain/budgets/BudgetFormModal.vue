<template>
  <BaseModal :show>
    <BaseForm :action="handleSubmit" :validation-schema>
      <TextField :label="t('globals.forms.labels.name')" name="name" :placeholder="t('placeholders.name')" />

      <LongTextField
        :label="t('globals.forms.labels.description')"
        name="description"
        optional
        :placeholder="t('globals.forms.placeholders.description')"
      />

      <BaseButton type="submit">{{ t("globals.actions.submit") }}</BaseButton>
    </BaseForm>
    <BaseButton @click="emit('close')">{{ t("globals.actions.close") }}</BaseButton>
  </BaseModal>
</template>

<script setup lang="ts">
  import type { Budget } from "~/types/api"

  type BudgetForm = {
    description?: string
    name: string
  }

  const emit = defineEmits<{
    (event: "close"): void
    (event: "create", payload: Budget): void
  }>()

  defineProps<{
    show: boolean
  }>()

  const { t } = useI18n()

  const validationSchema = useZodSchema(({ object, optional, requiredString, string }) => object({
    description: optional(string()),
    name: requiredString()
  }))

  const handleSubmit = async (values: BudgetForm) => {
    const { _data } = await walleeApi.budgets.create(values)
    emit("create", _data!)
    emit("close")
  }
</script>

<i18n lang="yaml">
  en:
    placeholders:
      name: My budget
</i18n>
