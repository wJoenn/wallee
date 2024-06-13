<template>
  <BaseModal>
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
  import type { Account } from "~~/types/api"

  type AccountForm = {
    description?: string
    name: string
  }

  const emit = defineEmits<{
    (event: "close"): void
    (event: "create", payload: Account): void
  }>()

  const { t } = useI18n()

  const validationSchema = useZodSchema(({ object, optional, requiredString, string }) => object({
    description: optional(string()),
    name: requiredString()
  }))

  const handleSubmit = async (values: AccountForm) => {
    const { _data } = await walleeApi.accounts.create(values)
    emit("create", _data!)
    emit("close")
  }
</script>

<i18n lang="yaml">
  en:
    placeholders:
      name: My account
</i18n>
