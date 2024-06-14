<template>
  <div id="accounts-id">
    <div class="header">
      <div>
        <p>{{ account!.name }}</p>
        <h1>{{ toEuro(account!.balance) }}</h1>
      </div>

      <NuxtLink :to="localePath('/')">{{ t("globals.actions.home") }}</NuxtLink>
    </div>

    <div>
      <h2>{{ t("transactions") }}</h2>
      <TransactionList :transactions="account!.transactions" />

      <div class="footer">
        <BaseButton @click="show = true">{{ t("newTransaction") }}</BaseButton>
      </div>
    </div>

    <TransactionFormModal v-if="show" :account-id="account!.id" @close="show = false" @create="handleCreate" />
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
  const { data: account, error } = await useWalleeApi(api => api.accounts.show(id), { deep: true })

  if (error.value) {
    await router.replace(localePath("/"))
    // TODO: add failure notification
  }

  const show = ref(false)

  const handleCreate = ({ transaction }: { transaction: Transaction }) => {
    account.value!.balance += transaction.value
    account.value!.transactions.push(transaction)
    show.value = false
  }
</script>

<style scoped>
  #accounts-id {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    padding: 2rem 2rem 0;

    .header {
      display: flex;
      justify-content: space-between;
    }

    .footer {
      background-color: var(--background-primary);
      bottom: 0;
      left: 0;
      padding: 2rem 0;
      position: sticky;
      right: 0;

      button {
        width: 100%
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    newTransaction: New transaction
    transactions: Transactions
</i18n>
