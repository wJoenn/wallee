<template>
  <IonPage>
    <div id="index" ref="presentingElement">
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

      <BaseButton @click="isOpen = true">New Transaction</BaseButton>
    </div>

    <BaseModal class="modal" :is-open :presenting-element>
      <div class="transaction-modifier">
        <label>{{ t("labels.transactionModifier") }}</label>

        <div>
          <button :class="{ selected: transactionModifier === -1 }" @click="transactionModifier = -1">
            <Icon name="ion:arrow-up" />
            <span>{{ t("labels.paid") }}</span>
          </button>

          <button :class="{ selected: transactionModifier === 1 }" @click="transactionModifier = 1">
            <Icon name="ion:arrow-down" />
            <span>{{ t("labels.received") }}</span>
          </button>
        </div>
      </div>

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

      <BaseButton @click="isOpen = false">Close</BaseButton>
    </BaseModal>
  </IonPage>
</template>

<script setup lang="ts">
  import type { Timestamp } from "~/types"
  import { number as zodNumber, object as zodObject, string as zodString } from "zod"

  type TransactionForm = {
    description?: string
    transacted_at?: Timestamp
    value: number
  }

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
    }).positive(t("validations.value.other_than_0"))
  })

  const transactionModifier = ref(-1)
  const isOpen = ref(false)
  const presentingElement = ref<HTMLDivElement>()

  const sortedTransactions = computed(() => {
    if (!transactions.value) { return [] }

    return [...transactions.value].sort((a, b) => {
      if (new Date(a.transacted_at) > new Date(b.transacted_at)) { return -1 }
      if (new Date(a.transacted_at) < new Date(b.transacted_at)) { return 1 }
      return 0
    })
  })

  const handleSubmit = async (values: TransactionForm) => {
    values.value *= transactionModifier.value
    const { _data } = await api.transactions.create(values)
    transactions.value?.push(_data!)
    isOpen.value = false
  }

  const toEuro = (value?: number) => `${((value ?? 0) / 100).toFixed(2)} €`
</script>

<style scoped>
  .modal {
    form {
      margin-bottom: 2rem;
    }

    .transaction-modifier {
      display: flex;
      flex-direction: column;
      gap: 1rem;
      margin-bottom: 2rem;

      div {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;

        button {
          align-items: center;
          background-color: transparent;
          border: 1px solid var(--color-secondary);
          border-radius: 0.25rem;
          display: flex;
          gap: 0.5rem;
          justify-content: center;
          padding: 0.75rem 1rem;
          transition: border-color 0.3s ease;

          &.selected {
            border-color: var(--color-primary);
          }
        }
      }

      label {
        font-weight: 600;
      }
    }
  }

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
      paid: Paid
      received: Received
      transacted_at: Date
      transactionModifier: Direction
      value: Value
    placeholders:
      description: description...
      value: "100"
    validations:
      value:
        other_than_0: The value must be positive
        required: This field is required
</i18n>
