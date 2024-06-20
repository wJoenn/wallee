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
        v-model:watcher="selectedAccountId"
        :disabled="!!accountId"
        :label="t('labels.account')"
        :loading="status === 'pending'"
        name="account_id"
        :options="accountOptions.filter(account => account.id !== fromAccountId)"
        :placeholder="t('placeholders.account')"
        select-by="id"
      />

      <template v-if="!transaction">
        <div class="toggle">
          <p>{{ t(`toppingUp?.${transactionModifier}`) }}</p>

          <div class="trigger" @click="toppingUp = !toppingUp">
            <div :class="{ enabled: toppingUp }" />
          </div>
        </div>

        <span class="toggle-description">{{ t("topUpExplanation") }}</span>

        <SelectField
          v-if="toppingUp"
          v-model:watcher="fromAccountId"
          :label="t(`labels.topUp.${transactionModifier}`)"
          :loading="status === 'pending'"
          name="from_account_id"
          :options="accountOptions.filter(account => account.id !== selectedAccountId)"
          :placeholder="t('placeholders.account')"
          select-by="id"
        />
      </template>

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
  import type { DateString, Timestamp } from "~~/types"
  import type { Transaction } from "~~/types/api"

  import dayjs from "~~/libs/dayjs.ts"

  type TransactionForm = {
    account_id: number
    description?: string
    from_account_id?: number
    transacted_at?: DateString
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

  const validationSchema = useZodSchema(zod => computed(() => zod.object({
    account_id: zod.requiredNumber(),
    description: zod.optional(zod.string()),
    from_account_id: zod.optional(zod.requiredNumber(), !toppingUp.value),
    transacted_at: zod.datestring(),
    value: zod.price()
  })))

  const fromAccountId = ref<number>()
  const loading = ref(false)
  const selectedAccountId = ref<number>()
  const toppingUp = ref(false)

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
    values.value = Math.round(values.value * transactionModifier.value * 100)
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

      if (values.from_account_id) {
        const toppedUpAccount = accounts.value!.find(account => account.id === values.account_id)!

        const topUpTransaction = {
          ...values,
          account_id: values.from_account_id,
          description: t(`topUpDescription.${transactionModifier.value}`, { account: toppedUpAccount.name }),
          value: values.value * -1
        }

        await walleeApi.transactions.create(topUpTransaction)
      }
    }

    emit("close")
  }

  const toTimestamp = (dateString?: DateString): Timestamp | undefined => {
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

    form {
      .toggle {
        align-items: center;
        display: flex;
        justify-content: space-between;

        .trigger {
          background-color: var(--color-secondary);
          border-radius: 9999px;
          display: flex;
          justify-content: center;
          padding: 0.25rem;
          transition: background-color 0.3s ease;
          width: 3rem;

          &:has(div.enabled) {
            background-color: var(--color-primary);
          }

          div {
            background-color: white;
            border-radius: 50%;
            height: 1.2rem;
            transform: translateX(-50%);
            transition: transform 0.3s ease;
            width: 1.2rem;

            &.enabled {
            transform: translateX(50%);
          }
          }
        }
      }

      .toggle-description {
        color: #ffffff80;
        font-size: 0.8rem;
        margin-top: -1.5rem;
      }
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
      topUp:
        "1": From
        "-1": To
      paid: Paid
      received: Received
    placeholders:
      account: My account
    toppingUp?:
      "1": Transferring from another account ?
      "-1": Transferring to another account ?
    topUpDescription:
      "1": "top up to {account}"
      "-1": "top up from {account}"
    topUpExplanation: By enabling this toggle the corresponding transfer will be automatically created in the selected account
</i18n>
