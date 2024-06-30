<template>
  <div class="flex flex-col gap-8 h-full">
    <div class="flex justify-between">
      <div v-if="accountStatus === 'pending'">
        <BaseSkeleton class="h-4 w-[10ch]" />
        <BaseSkeleton class="h-8 w-[15ch]" />
        <BaseSkeleton class="h-3 w-[25ch]" />
      </div>

      <div v-else-if="account">
        <p class="flex gap-2 items-center" @click="showAccountForm = true">
          {{ account.name }}
          <Icon name="ion:settings-sharp" />
        </p>

        <h1 class="font-semibold text-3xl">{{ toEuro(account.balance) }}</h1>
        <span v-if="account.category === 'budget'" class="text-secondary text-xs">
          {{ t("averageMonthlySpendings", { amount: toEuro(averageMonthlySpending) }) }}
        </span>
      </div>

      <NuxtLink :to="localePath('/')">{{ t("globals.actions.home") }}</NuxtLink>
    </div>

    <p v-if="account?.description" class="whitespace-pre-line">{{ account.description }}</p>

    <TransactionList
      v-model:active="active"
      class="flex-grow"
      :loading="transactionStatus === 'pending'"
      :transactions
      @add="showTransactionForm = true"
    />

    <AccountFormModal v-if="showAccountForm" :account @close="showAccountForm = false" @update="handleAccountUpdate" />

    <TransactionFormModal
      v-if="showTransactionForm"
      :account-id="account!.id"
      @close="showTransactionForm = false"
      @create="handleTransactionCreate"
    />
  </div>
</template>

<script setup lang="ts">
  import type { RouteLocationNormalizedLoaded } from "vue-router"
  import type { Account, Transaction } from "~~/types/api"
  import type { Params } from "~/composables/useWalleeApi.ts"

  import dayjs from "~~/libs/dayjs.ts"

  type Route = RouteLocationNormalizedLoaded & {
    params: {
      id: string
    }
  }

  const TRANSACTION_QUERY = {
    executed: {
      operator: "<",
      order: "asc",
      value: dayjs().add(1, "day").startOf("day").toISOString()
    },
    planned: {
      operator: ">",
      order: "desc",
      value: dayjs().endOf("day").toISOString()
    }
  } as const

  const { t } = useI18n()
  const localePath = useLocalePath()
  const router = useLocaleRouter()
  const { params: { id } } = useRoute() as Route
  const { data: account, status: accountStatus } = useWalleeApi(api => api.accounts.show, id, { deep: true })

  const { data: transactions, refresh, status: transactionStatus } = useWalleeApi(
    api => api.transactions.index,
    computed<Params<Transaction>>(() => ({
      order: [["transacted_at", TRANSACTION_QUERY[active.value].order]],
      where: [
        ["account_id", "=", id],
        ["transacted_at", TRANSACTION_QUERY[active.value].operator, TRANSACTION_QUERY[active.value].value]
      ]
    })),
    { deep: true }
  )

  const active = ref<"executed" | "planned">("executed")
  const showAccountForm = ref(false)
  const showTransactionForm = ref(false)

  const averageMonthlySpending = computed(() => {
    if (!account.value) { return 0 }

    const transactionDates = account.value.executed_transactions.map(transaction => dayjs(transaction.transacted_at))
    const max = dayjs().subtract(1, "month").endOf("month")
    let min = dayjs.min(...transactionDates)
    if (!min || max.isBefore(min)) { return 0 }

    const twelveMonthsAgo = dayjs().subtract(1, "year")
    min = dayjs.max(twelveMonthsAgo, min)!.startOf("month")
    const diff = Math.ceil(max.diff(min, "month")) + 1

    const spendings = account.value.executed_transactions.reduce((sum, transaction) => {
      const date = dayjs(transaction.transacted_at)
      if (transaction.value > 0 || date.isAfter(max) || date.isBefore(min)) { return sum }
      return sum + transaction.value
    }, 0)

    return Math.abs(Math.round(spendings / diff))
  })

  const handleAccountUpdate = ({ category, description, name }: Account) => {
    account.value = { ...account.value!, category, description, name }
  }

  const handleTransactionCreate = ({ transaction }: { transaction: Transaction }) => {
    const isExecuted = dayjs().add(1, "day").startOf("day").isAfter(dayjs(transaction.transacted_at))

    if (isExecuted && active.value === "executed") {
      account.value!.balance += transaction.value
      transactions.value!.push(transaction)
    } else if (!isExecuted && active.value === "planned") {
      transactions.value!.push(transaction)
    }
  }

  watch(accountStatus, async () => {
    if (accountStatus.value === "error") {
      await router.replace(localePath("/"))
      // TODO: add failure notification
    }
  }, { immediate: true })

  watch(active, async () => { await refresh() })
</script>

<i18n lang="yaml">
  en:
    averageMonthlySpendings: "Average monthly spendings: {amount}"
    deleteAccount: Delete account
    newTransaction: New transaction
</i18n>
