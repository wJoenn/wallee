<template>
  <div id="accounts-id">
    <div class="header">
      <div v-if="status === 'pending'">
        <BaseSkeleton style="height: 1rem; width: 10ch;" />
        <BaseSkeleton style="height: 2rem; width: 15ch;" />
        <BaseSkeleton style="height: 0.8rem; width: 25ch" />
      </div>

      <div v-else-if="account">
        <p @click="showAccountForm = true">
          {{ account.name }}
          <Icon name="ion:settings-sharp" />
        </p>

        <h1>{{ toEuro(account.balance) }}</h1>
        <span v-if="account.category === 'budget'">
          Average monthly spendings: {{ toEuro(averageMonthlySpending) }}
        </span>
      </div>

      <NuxtLink :to="localePath('/')">{{ t("globals.actions.home") }}</NuxtLink>
    </div>

    <div class="main">
      <TransactionList :loading="status === 'pending'" :transactions="account?.transactions" />
    </div>

    <div class="footer">
      <BaseButton :loading="status === 'pending'" @click="showTransactionForm = true">
        {{ t("newTransaction") }}
      </BaseButton>
    </div>

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

  import dayjs from "~~/libs/dayjs.ts"

  type Route = RouteLocationNormalizedLoaded & {
    params: {
      id: string
    }
  }

  const { t } = useI18n()
  const localePath = useLocalePath()
  const router = useLocaleRouter()
  const { params: { id } } = useRoute() as Route
  const { data: account, status } = useWalleeApi(api => api.accounts.show(id), { deep: true })

  const showAccountForm = ref(false)
  const showTransactionForm = ref(false)

  const averageMonthlySpending = computed(() => {
    if (!account.value) { return 0 }

    const transactionDates = account.value.transactions.executed.map(transaction => dayjs(transaction.transacted_at))
    const max = dayjs().subtract(1, "month").endOf("month")
    let min = dayjs.min(...transactionDates)
    if (!min || max.isBefore(min)) { return 0 }

    const twelveMonthsAgo = dayjs().subtract(1, "year")
    min = dayjs.max(twelveMonthsAgo, min)!.startOf("month")
    const diff = Math.ceil(max.diff(min, "month")) + 1

    const spendings = account.value.transactions.executed.reduce((sum, transaction) => {
      const date = dayjs(transaction.transacted_at)
      if (transaction.value > 0 || date.isAfter(max) || date.isBefore(min)) { return sum }
      return sum + transaction.value
    }, 0)

    return Math.round(spendings / diff)
  })

  const handleAccountUpdate = ({ category, description, name }: Account) => {
    account.value = { ...account.value!, category, description, name }
  }

  const handleTransactionCreate = ({ transaction }: { transaction: Transaction }) => {
    account.value!.balance += transaction.value

    if (dayjs().add(1, "day").startOf("day").isAfter(dayjs(transaction.transacted_at))) {
      account.value!.transactions.executed.push(transaction)
    } else {
      account.value!.transactions.planned.push(transaction)
    }
  }

  watch(status, async () => {
    if (status.value === "error") {
      await router.replace(localePath("/"))
      // TODO: add failure notification
    }
  }, { immediate: true })
</script>

<style scoped>
  #accounts-id {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    min-height: 100svh;
    gap: 2rem;
    padding: 2rem 2rem 0;

    .footer {
      background-color: var(--background-primary);
      bottom: 0;
      left: 0;
      margin-top: -2rem;
      padding: 2rem 0;
      position: sticky;
      right: 0;

      button {
        width: 100%
      }
    }

    .header {
      display: flex;
      justify-content: space-between;

      p {
        align-items: center;
        display: flex;
        gap: 0.5rem;
      }

      span {
        color: #ffffff80;
        font-size: 0.8rem;
      }
    }

    .main {
      flex-grow: 1;
    }
  }
</style>

<i18n lang="yaml">
  en:
    newTransaction: New transaction
</i18n>
