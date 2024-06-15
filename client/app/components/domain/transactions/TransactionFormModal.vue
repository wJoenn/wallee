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
        :disabled="!!accountId"
        :label="t('labels.account')"
        :loading="status === 'pending'"
        name="account_id"
        :options="accountOptions"
        :placeholder="t('placeholders.account')"
        select-by="id"
      />

      <DateField :label="t('globals.forms.labels.date')" name="transacted_at" optional />

      <LongTextField
        :label="t('globals.forms.labels.description')"
        name="description"
        optional
        :placeholder="t('globals.forms.placeholders.description')"
      />

      <BaseButton :loading="loading || status === 'pending'" type="submit">
        {{ t("globals.actions.submit") }}
      </BaseButton>
    </BaseForm>

    <BaseButton @click="emit('close')">{{ t("globals.actions.close") }}</BaseButton>
  </BaseModal>
</template>

<script setup lang="ts">
  import type { Timestamp } from "~~/types"
  import type { Transaction } from "~~/types/api"

  import dayjs from "~~/libs/dayjs.ts"

  type TransactionForm = {
    account_id?: number
    description?: string
    transacted_at?: Timestamp
    value: number
  }

  const emit = defineEmits<{
    (event: "close"): void
    (event: "create" | "update", payload: { accountId?: number, transaction: Transaction }): void
  }>()

  const props = defineProps<{
    accountId?: number
    transaction?: Transaction
  }>()

  const { t } = useI18n()
  const { data: accounts, status } = useWalleeApi(api => api.accounts.index())

  const validationSchema = useZodSchema(({ object, optional, price, requiredNumber, string, timestamp }) => object({
    account_id: requiredNumber(),
    description: optional(string()),
    transacted_at: timestamp(),
    value: price()
  }))

  const loading = ref(false)

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const transactionModifier = ref(props.transaction && props.transaction.value > 0 ? 1 : -1)

  const accountOptions = computed(() => (
    accounts.value?.map(account => ({ ...account, key: account.id, label: account.name })) ?? []
  ))

  const initialValues = computed(() => {
    if (props.transaction) {
      const { account_id, description, transacted_at, value } = props.transaction
      return {
        account_id,
        description,
        transacted_at: dayjs(transacted_at).format("YYYY-MM-DD"),
        value: Math.abs(value / 100)
      }
    }

    return { account_id: props.accountId }
  })

  const handleSubmit = async (values: TransactionForm) => {
    loading.value = true
    values.value *= transactionModifier.value * 100
    const accountId = accounts.value!.find(accountOption => accountOption.id === values.account_id)?.id

    if (props.transaction) {
      if (values.transacted_at === dayjs(props.transaction.transacted_at).format("YYYY-MM-DD")) {
        values.transacted_at = props.transaction.transacted_at
      } else {
        values.transacted_at = toTimestamp(values.transacted_at)
      }

      const { _data } = await walleeApi.transactions.update(props.transaction.id, values)
      emit("update", { accountId, transaction: _data! })
    } else {
      values.transacted_at = toTimestamp(values.transacted_at)

      const { _data } = await walleeApi.transactions.create(values)
      emit("create", { accountId, transaction: _data! })
    }

    emit("close")
  }

  const toTimestamp = (dateString?: string) => {
    if (dateString) {
      const [year, month, date] = dateString.split("-")
      return dayjs().year(+year!).month(+month! - 1).date(+date!).toString()
    }
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
      account: Account
      paid: Paid
      received: Received
    placeholders:
      account: My account
    validations:
      value:
        other_than_0: The value must be positive
</i18n>
