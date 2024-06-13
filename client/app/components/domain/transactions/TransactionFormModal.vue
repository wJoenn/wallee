<template>
  <BaseModal>
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

      <SelectField
        :disabled="!!budgetId"
        :label="t('labels.budget')"
        name="budget_id"
        optional
        :options="budgetOptions"
        :placeholder="t('placeholders.budget')"
        select-by="id"
      />

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
    budget_id?: number
    description?: string
    transacted_at?: Timestamp
    value: number
  }

  const emit = defineEmits<{
    (event: "close"): void
    (event: "create" | "update", payload: { budgetId?: number, transaction: Transaction }): void
  }>()

  const props = defineProps<{
    budgetId?: number
    transaction?: Transaction
  }>()

  const { t } = useI18n()
  const { data: budgets } = await useWalleeApi(api => api.budgets.index())

  const validationSchema = useZodSchema(({ number, object, optional, price, string, timestamp }) => object({
    budget_id: optional(number()),
    description: optional(string()),
    transacted_at: timestamp(),
    value: price()
  }))

  const transactionModifier = ref(-1)

  const budgetOptions = computed(() => (
    budgets.value!.map(budget => ({ ...budget, key: budget.id, label: budget.name }))
  ))

  const initialValues = computed(() => {
    if (props.transaction) {
      const { budget_id, description, transacted_at, value } = props.transaction
      return {
        budget_id,
        description,
        transacted_at: dayjs(transacted_at).format("YYYY-MM-DD"),
        value: Math.abs(value / 100)
      }
    }

    return { budget_id: props.budgetId }
  })

  const handleSubmit = async (values: TransactionForm) => {
    values.value *= transactionModifier.value * 100
    const budgetId = budgets.value!.find(budgetOption => budgetOption.id === values.budget_id)?.id

    if (props.transaction) {
      if (values.transacted_at === dayjs(props.transaction.transacted_at).format("YYYY-MM-DD")) {
        values.transacted_at = props.transaction.transacted_at
      } else {
        values.transacted_at = toTimestamp(values.transacted_at)
      }

      const { _data } = await walleeApi.transactions.update(props.transaction.id, values)
      emit("update", { budgetId, transaction: _data! })
    } else {
      values.transacted_at = toTimestamp(values.transacted_at)

      const { _data } = await walleeApi.transactions.create(values)
      emit("create", { budgetId, transaction: _data! })
    }
  }

  const toTimestamp = (dateString?: string) => {
    if (dateString) {
      const [year, month, date] = dateString.split("-")
      return dayjs().year(+year!).month(+month!).date(+date!).toString()
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
      budget: Budget
      paid: Paid
      received: Received
    placeholders:
      budget: My budget
    validations:
      value:
        other_than_0: The value must be positive
</i18n>
