<template>
  <div id="budgets-id">
    <pre>{{ budget }}</pre>
    <TransactionList :transactions="budget!.transactions" />
    <BaseButton @click="show = true">{{ t("newTransaction") }}</BaseButton>
    <NuxtLink :to="localePath('/')">{{ t("globals.actions.home") }}</NuxtLink>

    <TransactionFormModal :budget-id="budget!.id" :show @close="show = false" @create="handleCreate" />
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
  const router = useLocaleRouter()
  const { params: { id } } = useRoute() as Route
  const { data: budget, error } = await useWalleeApi(api => api.budgets.show(id), { deep: true })

  if (error.value) {
    await router.replace(localePath("/"))
    // TODO: add failure notification
  }

  const show = ref(false)

  const handleCreate = ({ transaction }: { transaction: Transaction }) => {
    budget.value!.balance += transaction.value
    budget.value!.transactions.push(transaction)
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
