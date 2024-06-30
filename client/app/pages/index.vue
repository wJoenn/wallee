<template>
  <div class="flex flex-col gap-8 h-full">
    <div class="flex items-center justify-between">
      <h1 class="font-semibold text-3xl">{{ t("title") }}</h1>
      <BaseButton @click="signOut">{{ t("globals.actions.signOut") }}</BaseButton>
    </div>

    <div class="flex flex-col flex-grow gap-8">
      <AccountList :accounts category="main" :loading="status === 'pending'" />

      <AccountList
        :accounts
        category="budget"
        :loading="status === 'pending'"
        @add="newAccountCategory = 'budget'; showAccountForm = true"
      />

      <AccountList
        :accounts
        category="saving"
        :loading="status === 'pending'"
        @add="newAccountCategory = 'saving'; showAccountForm = true"
      />
    </div>

    <div class="-m-8 bg bottom-0 inset-x-0 p-8 sticky">
      <BaseButton class="w-full" @click="showTransactionForm = true">{{ t("newTransaction") }}</BaseButton>
    </div>

    <AccountFormModal
      v-if="showAccountForm"
      :category="newAccountCategory"
      @close="showAccountForm = false"
      @create="handleCreateAccount"
    />

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
  const { signOut } = useUserStore()
  const { data: accounts, status } = useWalleeApi(walleeApi.accounts.index, {
    order: ["name"]
  }, { deep: true })

  const newAccountCategory = ref<"budget" | "saving">("budget")

  const showAccountForm = ref(false)
  const showTransactionForm = ref(false)

  const handleCreateTransaction = ({ accountId, transaction }: { accountId?: number, transaction: Transaction }) => {
    const account = accounts.value!.find(accountOption => accountOption.id === accountId)!
    account.balance += transaction.value
  }

  const handleCreateAccount = (account: Account) => {
    accounts.value!.push(account)
  }
</script>

<i18n lang="yaml">
  en:
    newAccount: New account
    newTransaction: New transaction
    sections:
      budgets: Budgets
      mainAccount: Main account
      savings: Savings
    title: Home page
    total: "Total: {amount}"
</i18n>
