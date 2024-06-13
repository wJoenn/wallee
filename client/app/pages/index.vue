<template>
  <div id="index" ref="presentingElement">
    <div class="header">
      <div>
        <h1>{{ t("title") }}</h1>
        <BaseButton @click="signOut">{{ t("globals.actions.signOut") }}</BaseButton>
      </div>

      <p>
        {{ t("total", { amount: toEuro(transactions?.reduce((sum, transaction) => sum + transaction.value, 0)) }) }}
      </p>
    </div>

    <div class="actions">
      <BaseButton @click="showTransactionForm = true">{{ t("newTransaction") }}</BaseButton>
      <BaseButton @click="showAccountForm = true">{{ t("newAccount") }}</BaseButton>
    </div>

    <h2>{{ t("sections.accounts") }}</h2>

    <nav class="accounts">
      <NuxtLink v-for="account in accounts" :key="account.id" :to="localePath(`/accounts/${account.id}`)">
        <span>{{ account.name }}</span>
        <p>{{ toEuro(account.balance) }}</p>
      </NuxtLink>
    </nav>

    <h2>{{ t("sections.transactions") }}</h2>

    <TransactionList :transactions />

    <AccountFormModal v-if="showAccountForm" @close="showAccountForm = false" @create="handleCreateAccount" />

    <TransactionFormModal
      v-if="showTransactionForm"
      @close="showTransactionForm = false"
      @create="handleCreateTransaction"
    />
  </div>
</template>

<script setup lang="ts">
  import type { Account, Transaction } from "~~/types/api"

  const { t } = useI18n()
  const localePath = useLocalePath()
  const { signOut } = useUserStore()
  const { data: accounts } = await useWalleeApi(api => api.accounts.index(), { deep: true })
  const { data: transactions } = await useWalleeApi(api => api.transactions.index(), { deep: true })

  const presentingElement = ref<HTMLDivElement>()
  const showAccountForm = ref(false)
  const showTransactionForm = ref(false)

  const handleCreateTransaction = ({ budgetId, transaction }: { budgetId?: number, transaction: Transaction }) => {
    transactions.value!.push(transaction)

    const account = accounts.value!.find(accountOption => accountOption.id === accountId)
    if (account) { account.balance += transaction.value }

    showTransactionForm.value = false
  }

  const handleCreateAccount = (account: Account) => {
    accounts.value!.push(account)
  }
</script>

<style>
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

    .actions {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 1rem;
    }

    .accounts {
      display: grid;
      gap: 1rem;
      grid-template-columns: repeat(2, minmax(0, 1fr));

      a {
        background-color: var(--background-primary);
        border: 1px solid var(--color-secondary);
        border-radius: 0.25rem;
        box-shadow: 0 0 10px black;
        padding: 1rem;
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    newAccount: New account
    newTransaction: New transaction
    sections:
      accounts: Accounts
      transactions: Transactions
    title: Home page
    total: "Total: {amount}"
</i18n>
