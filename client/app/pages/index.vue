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
      <BaseButton @click="showBudgetForm = true">{{ t("newBudget") }}</BaseButton>
    </div>

    <h2>{{ t("sections.budgets") }}</h2>

    <nav class="budgets">
      <NuxtLink v-for="budget in budgets" :key="budget.id" :to="localePath(`/budgets/${budget.id}`)">
        <span>{{ budget.name }}</span>
        <p>{{ toEuro(budget.balance) }}</p>
      </NuxtLink>
    </nav>

    <h2>{{ t("sections.transactions") }}</h2>

    <TransactionList :transactions />

    <BudgetFormModal v-if="showBudgetForm" @close="showBudgetForm = false" @create="handleCreateBudget" />

    <TransactionFormModal
      v-if="showTransactionForm"
      @close="showTransactionForm = false"
      @create="handleCreateTransaction"
    />
  </div>
</template>

<script setup lang="ts">
  import type { Budget, Transaction } from "~~/types/api"

  const { t } = useI18n()
  const localePath = useLocalePath()
  const { signOut } = useUserStore()
  const { data: budgets } = await useWalleeApi(api => api.budgets.index(), { deep: true })
  const { data: transactions } = await useWalleeApi(api => api.transactions.index(), { deep: true })

  const presentingElement = ref<HTMLDivElement>()
  const showBudgetForm = ref(false)
  const showTransactionForm = ref(false)

  const handleCreateTransaction = ({ budgetId, transaction }: { budgetId?: number, transaction: Transaction }) => {
    transactions.value!.push(transaction)

    const budget = budgets.value!.find(budgetOption => budgetOption.id === budgetId)
    if (budget) { budget.balance += transaction.value }

    showTransactionForm.value = false
  }

  const handleCreateBudget = (budget: Budget) => {
    budgets.value!.push(budget)
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

    .budgets {
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
    newBudget: New budget
    newTransaction: New transaction
    sections:
      budgets: Budgets
      transactions: Transactions
    title: Home page
    total: "Total: {amount}"
</i18n>
