<template>
  <BaseModal class="space-y-8">
    <BaseForm :action="handleSubmit" :initial-values :validation-schema>
      <div class="flex flex-col gap-4">
        <label class="font-semibold">{{ t("globals.forms.labels.direction") }}</label>

        <div class="gap-4 grid grid-cols-2">
          <BaseButton mode="input" :selected="transactionModifier === -1" @click="transactionModifier = -1">
            <Icon name="ion:arrow-up" />
            <span>{{ t("labels.paid") }}</span>
          </BaseButton>

          <BaseButton mode="input" :selected="transactionModifier === 1" @click="transactionModifier = 1">
            <Icon name="ion:arrow-down" />
            <span>{{ t("labels.received") }}</span>
          </BaseButton>
        </div>
      </div>

      <NumberField :label="t('globals.forms.labels.value')" name="value" placeholder="100.00" />

      <SelectField
        v-model:watcher="selectedAccountId"
        :label="t('labels.account')"
        :loading="status === 'pending'"
        name="account_id"
        :options="accountOptions.filter(account => account.id !== fromAccountId)"
        :placeholder="t('placeholders.account')"
        select-by="id"
      />

      <template v-if="!transaction">
        <div class="flex items-center justify-between">
          <p>{{ t(`toppingUp?.${transactionModifier}`) }}</p>

          <div
            class="default:bg-secondary duration-300 flex justify-center p-1 rounded-full transition-colors w-12"
            :class="{ 'bg-nuxt': toppingUp }"
            @click="toppingUp = !toppingUp"
          >
            <div
              class="bg-white default:-translate-x-1/2 duration-300 rounded-full size-5 transition-transform"
              :class="{ 'translate-x-1/2': toppingUp }"
            />
          </div>
        </div>

        <span class="-mt-6 text-secondary text-xs">{{ t("topUpExplanation") }}</span>

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

  const createTopUpTransaction = async (values: TransactionForm) => {
    if (values.from_account_id) {
      const toppedUpAccount = accounts.value!.find(account => account.id === values.account_id)!

      const topUpTransaction = {
        ...values,
        account_id: toppedUpAccount.id,
        description: t(`topUpDescription.${transactionModifier.value}`, { account: toppedUpAccount.name }),
        value: values.value * -1
      }

      await walleeApi.transactions.create(topUpTransaction)
    }
  }

  const handleSubmit = async (values: TransactionForm) => {
    loading.value = true

    values.value = Math.round(values.value * transactionModifier.value * 100)
    const accountId = accounts.value!.find(accountOption => accountOption.id === values.account_id)?.id

    if (props.transaction) {
      if (dayjs(values.transacted_at).isSame(dayjs(props.transaction.transacted_at), "date")) {
        values.transacted_at = props.transaction.transacted_at
      } else {
        values.transacted_at = toTimestamp(values.transacted_at)
      }

      const { _data } = await walleeApi.transactions.update(props.transaction.id, values)
      emit("update", { accountId, transaction: _data! })
    } else {
      values.transacted_at = toTimestamp(values.transacted_at)

      const { _data } = await walleeApi.transactions.create(values)
      await createTopUpTransaction(values)
      emit("create", { accountId, transaction: _data! })
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
