<template>
  <BaseModal>
    <BaseForm :action="handleSubmit" :initial-values :validation-schema>
      <TextField :label="t('globals.forms.labels.name')" name="name" :placeholder="t('placeholders.name')" />

      <SelectField
        disabled
        :label="t('labels.category')"
        name="category"
        :options="categoryOptions"
        select-by="value"
      />

      <LongTextField
        :label="t('globals.forms.labels.description')"
        name="description"
        optional
        :placeholder="t('globals.forms.placeholders.description')"
      />

      <BaseButton :loading type="submit">{{ t("globals.actions.submit") }}</BaseButton>
    </BaseForm>

    <BaseButton @click="emit('close')">{{ t("globals.actions.close") }}</BaseButton>
  </BaseModal>
</template>

<script setup lang="ts">
  import type { Account } from "~~/types/api"

  type AccountForm = {
    category: "budget" | "saving"
    description?: string
    name: string
  }

  const emit = defineEmits<{
    (event: "close"): void
    (event: "create", payload: Omit<Account, "transactions">): void
  }>()

  const props = defineProps<{
    category: "budget" | "saving"
  }>()

  const { t } = useI18n()

  const validationSchema = useZodSchema(({ object, optional, requiredString, string }) => object({
    category: requiredString(),
    description: optional(string()),
    name: requiredString()
  }))

  const categoryOptions = [
    { key: crypto.randomUUID(), label: t("labels.categories.budget"), value: "budget" },
    { key: crypto.randomUUID(), label: t("labels.categories.saving"), value: "saving" }
  ]

  const loading = ref(false)

  const initialValues = computed(() => ({
    category: props.category
  }))

  const handleSubmit = async (values: AccountForm) => {
    loading.value = true
    const { _data } = await walleeApi.accounts.create(values)
    emit("create", _data!)
    emit("close")
  }
</script>

<i18n lang="yaml">
  en:
    labels:
      categories:
        budget: Budget
        saving: Saving
      category: Category
    placeholders:
      name: My account
</i18n>
