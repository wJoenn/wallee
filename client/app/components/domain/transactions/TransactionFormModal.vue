<template>
  <BaseModal :show>
    <div class="transaction-modifier">
      <label>{{ t("globals.forms.labels.direction") }}</label>

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

    <BaseForm :action="handleSubmit" :initial-values :validation-schema>
      <NumberField :label="t('globals.forms.labels.value')" name="value" placeholder="100.00" />
      <DateField :label="t('globals.forms.labels.date')" name="transacted_at" optional />

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
  import type { Timestamp } from "~~/types"
  import type { Transaction } from "~~/types/api"

  import dayjs from "~~/libs/dayjs.ts"

  type TransactionForm = {
    description?: string
    transacted_at?: Timestamp
    value: number
  }

  const emit = defineEmits<{
    (event: "close"): void
    (event: "create" | "update", payload: Transaction): void
  }>()

  const props = defineProps<{
    show: boolean
    transaction?: Transaction
  }>()

  const { t } = useI18n()

  const validationSchema = useZodSchema(({ object, optional, price, string, timestamp }) => object({
    description: optional(string()),
    transacted_at: timestamp(),
    value: price()
  }))

  const transactionModifier = ref(-1)

  const initialValues = computed(() => {
    if (!props.transaction) { return {} }

    const { description, transacted_at, value } = props.transaction
    return {
      description,
      transacted_at: dayjs(transacted_at).format("YYYY-MM-DD"),
      value: Math.abs(value / 100)
    }
  })

  const handleSubmit = async (values: TransactionForm) => {
    values.value *= transactionModifier.value * 100

    if (props.transaction) {
      const { _data } = await walleeApi.transactions.update(props.transaction.id, values)
      emit("update", _data!)
    } else {
      const { _data } = await walleeApi.transactions.create(values)
      emit("create", _data!)
    }
  }

  watch(() => props.transaction, () => {
    if (props.transaction && props.transaction.value > 0) {
      transactionModifier.value = 1
    } else {
      transactionModifier.value = -1
    }
  }, { immediate: true })
</script>

<style>
  .base-modal {
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
</style>

<i18n lang="yaml">
  en:
    labels:
      paid: Paid
      received: Received
    validations:
      value:
        other_than_0: The value must be positive
</i18n>
