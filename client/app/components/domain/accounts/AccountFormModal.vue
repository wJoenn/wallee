<template>
  <BaseModal class="account-form-modal">
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
      <BaseButton @click="emit('close')">{{ t("globals.actions.close") }}</BaseButton>
    </BaseForm>

    <BaseButton v-if="account && account.category !== 'main'" :loading mode="danger" @click="show = true">
      {{ t("delete.action") }}
    </BaseButton>

    <TransitionSlideY>
      <div v-if="show" class="delete-confirmation" @click.self="show = false">
        <div>
          <div @click="show = false" />
          <h2>{{ t("delete.sure?") }}</h2>
          <p>{{ t("delete.consequence") }}</p>
          <BaseButton mode="danger" @click="handleAccountDelete">{{ t("globals.actions.confirm") }}</BaseButton>
        </div>
      </div>
    </TransitionSlideY>
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
  const router = useLocaleRouter()

  const validationSchema = useZodSchema(({ object, optional, requiredString, string }) => object({
    category: requiredString(),
    description: optional(string()),
    name: requiredString()
  }))

  const loading = ref(false)
  const show = ref(false)

  const categoryOptions = computed(() => [
    { key: crypto.randomUUID(), label: t("labels.categories.budget"), value: "budget" },
    { key: crypto.randomUUID(), label: t("labels.categories.main"), value: "main" },
    { key: crypto.randomUUID(), label: t("labels.categories.saving"), value: "saving" }
  ].filter(option => props.account?.category === "main" || option.value !== "main"))

  const initialValues = computed(() => {
    if (props.account) { return props.account }

    return { category: props.category }
  })

  const handleAccountDelete = async () => {
    loading.value = true
    await walleeApi.accounts.destroy(props.account!.id)
    await router.replace("/")
  }

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

<style>
  .account-form-modal {
    display: flex;
    flex-direction: column;
    justify-content: space-between;

    .delete-confirmation {
      align-items: flex-end;
      backdrop-filter: blur(2px);
      background-color: #00000080;
      display: flex;
      inset: 0;
      position: fixed;

      > div {
        background-color: var(--background-primary);
        border-radius: 0.25rem;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.8);
        display: flex;
        flex-direction: column;
        gap: 1rem;
        margin: 1rem;
        padding: 1rem;
        text-align: center;

        > div {
          align-self: center;
          background-color: #ffffff;
          height: 0.25rem;
          width: 2rem;
        }
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    delete:
      action: Delete account
      consequence: Deleting your account will reassign all of its transactions to your main account.
      sure?: Are you sure ?
    labels:
      categories:
        budget: Budget
        main: Main
        saving: Saving
      category: Category
    placeholders:
      name: My account
</i18n>
