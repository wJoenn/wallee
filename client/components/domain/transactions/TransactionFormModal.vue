<template>
  <BaseModal :show>
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

    <BaseButton @click="emit('close')">Close</BaseButton>
  </BaseModal>
</template>

<script setup lang="ts">
  import type { Timestamp } from "~/types"
  import type { Transaction } from "~/types/api"

  import { number as zodNumber, object as zodObject, string as zodString } from "zod"

  type TransactionForm = {
    description?: string
    transacted_at?: Timestamp
    value: number
  }

  const emit = defineEmits<{
    (event: "close"): void
    (event: "create", payload: Transaction): void
  }>()

  defineProps<{
    show: boolean
  }>()

  const api = useApi()
  const { t } = useI18n()

  const validationSchema = zodObject({
    description: zodString().optional(),
    transacted_at: zodString().optional(),
    value: zodNumber({
      invalid_type_error: t("validations.value.required"),
      required_error: t("validations.value.required")
    }).positive(t("validations.value.other_than_0"))
  })

  const transactionModifier = ref(-1)

  const handleSubmit = async (values: TransactionForm) => {
    values.value *= transactionModifier.value
    const { _data } = await api.transactions.create(values)
    emit("create", _data!)
  }
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
