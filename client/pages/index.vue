<template>
  <IonPage>
    <div id="index">
      <div class="header">
        <div>
          <h1>Transactions</h1>
          <BaseButton @click="signOut">Sign out</BaseButton>
        </div>

        <p>Total: {{ toEuro(transactions?.reduce((sum, transaction) => sum + transaction.value, 0)) }}</p>
      </div>

      <ul class="transactions">
        <li v-for="transaction in sortedTransactions" :key="transaction.id">
          <p>{{ toEuro(transaction.value) }}</p>
          <span>{{ transaction.description }}</span>
        </li>
      </ul>

      <BaseForm :action="handleSubmit" :validation-schema>
        <NumberField :label="t('labels.value')" name="value" :placeholder="t('placeholders.value')" />
        <DateField :label="t('labels.transacted_at')" name="transacted_at" />

        <LongTextField
          :label="t('labels.description')"
          name="description"
          :placeholder="t('placeholders.description')"
        />

        <BaseButton type="submit">Submit</BaseButton>
      </BaseForm>
    </div>
  </IonPage>
</template>

<script setup lang="ts">
  import type { RecursiveRecord } from "~/types"
  import { number as zodNumber, object as zodObject, string as zodString } from "zod"

  const api = useApi()
  const { t } = useI18n()
  const { signOut } = useUserStore()

  const { data: transactions } = useAsyncData(async () => {
    const { _data } = await api.transactions.index()
    return _data!
  })

  const validationSchema = zodObject({
    description: zodString().optional(),
    transacted_at: zodString().optional(),
    value: zodNumber({
      invalid_type_error: t("validations.value.required"),
      required_error: t("validations.value.required")
    }).refine(value => value !== 0, t("validations.value.other_than_0"))
  })

  const sortedTransactions = computed(() => {
    if (!transactions.value) { return [] }

    return [...transactions.value].sort((a, b) => {
      if (new Date(a.transacted_at) > new Date(b.transacted_at)) { return -1 }
      if (new Date(a.transacted_at) < new Date(b.transacted_at)) { return 1 }
      return 0
    })
  })

  const handleSubmit = async (values: RecursiveRecord) => {
    const { _data } = await api.transactions.create(values)
    transactions.value?.push(_data!)
  }

  const toEuro = (value?: number) => `${((value ?? 0) / 100).toFixed(2)} €`
</script>

<style scoped>
  #index {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    min-height: 1px;
    padding: 2rem;

    .header > div {
      align-items: center;
      display: flex;
      justify-content: space-between;

      h1 {
        margin: 0;
      }
    }

    .transactions {
      display: flex;
      flex-direction: column;
      overflow-y: scroll;

      li {
        border-bottom: 1px solid var(--color-secondary);
        padding: 0.5rem 0;

        &:last-child {
          border: none;
        }
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    labels:
      description: Description
      transacted_at: Date
      value: Value
    placeholders:
      description: description...
      value: "100"
    validations:
      value:
        other_than_0: The value cannot be 0
        required: This field is required
</i18n>
