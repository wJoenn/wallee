<template>
  <BaseModal>
    <BaseForm :action="handleSubmit" :initial-values :validation-schema>
      <TextField :label="t('globals.forms.labels.name')" name="name" :placeholder="t('placeholders.name')" />

      <SelectField
        :disabled="!!category || account?.category === 'main'"
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
    (event: "create" | "update", payload: Account): void
  }>()

  const props = defineProps<{
    account?: Account
    category?: "budget" | "saving"
  }>()

  const { t } = useI18n()

  const validationSchema = useZodSchema(({ object, optional, requiredString, string }) => object({
    category: requiredString(),
    description: optional(string()),
    name: requiredString()
  }))

  const loading = ref(false)

  const categoryOptions = computed(() => [
    { key: crypto.randomUUID(), label: t("labels.categories.budget"), value: "budget" },
    { key: crypto.randomUUID(), label: t("labels.categories.main"), value: "main" },
    { key: crypto.randomUUID(), label: t("labels.categories.saving"), value: "saving" }
  ].filter(option => props.account?.category === "main" || option.value !== "main"))

  const initialValues = computed(() => {
    if (props.account) { return props.account }

    return { category: props.category }
  })

  const handleSubmit = async (values: AccountForm) => {
    loading.value = true

    if (props.account) {
      const { _data } = await walleeApi.accounts.update(props.account.id, values)
      emit("update", _data!)
    } else {
      const { _data } = await walleeApi.accounts.create(values)
      emit("create", _data!)
    }

    emit("close")
  }
</script>

<i18n lang="yaml">
  en:
    labels:
      categories:
        budget: Budget
        main: Main
        saving: Saving
      category: Category
    placeholders:
      name: My account
</i18n>
