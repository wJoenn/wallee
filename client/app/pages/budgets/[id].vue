<template>
  <div id="budgets-id">
    <pre>{{ budget }}</pre>
    <TransactionList :transactions="filteredTransactions" />
    <BaseButton @click="show = true">{{ t("newTransaction") }}</BaseButton>
    <NuxtLink :to="localePath('/')">{{ t("globals.actions.home") }}</NuxtLink>

    <TransactionFormModal v-if="budget" :budget-id="budget.id" :show @close="show = false" @create="handleCreate" />
  </div>
</template>

<script setup lang="ts">
  import type { RouteLocationNormalizedLoaded } from "vue-router"
  import type { Transaction } from "~~/types/api"

  type Route = RouteLocationNormalizedLoaded & {
    params: {
      id: string
    }
  }

  const { t } = useI18n()
  const localePath = useLocalePath()
  const { params: { id } } = useRoute() as Route

  const { data: budget } = await useWalleeApi(async api => {
    const { _data } = await api.budgets.show(id)
    return _data!
  })

  const { data: transactions } = await useWalleeApi(async api => {
    const { _data } = await api.transactions.index()
    return _data!
  }, { deep: true })

  const show = ref(false)

  const filteredTransactions = computed(() => transactions.value?.filter(transaction => (
    transaction.budget_id === budget.value!.id
  )))

  const handleCreate = ({ transaction }: { transaction: Transaction }) => {
    budget.value!.balance += transaction.value
    show.value = false
  }
</script>

<style scoped>
  #budgets-id {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    padding: 2rem;
  }
</style>

<i18n lang="yaml">
  en:
    newTransaction: New transaction
</i18n>
