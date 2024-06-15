<template>
  <div id="accounts-id">
    <div class="header">
      <div v-if="status === 'pending'">
        <BaseSkeleton style="height: 1rem; width: 10ch;" />
        <BaseSkeleton style="height: 2rem; width: 15ch;" />
      </div>

      <div v-else-if="account">
        <p>{{ account.name }}</p>
        <h1>{{ toEuro(account.balance) }}</h1>
      </div>

      <NuxtLink :to="localePath('/')">{{ t("globals.actions.home") }}</NuxtLink>
    </div>

    <div class="main">
      <h2>{{ t("transactions") }}</h2>
      <TransactionList :loading="status === 'pending'" :transactions="account?.transactions" />
    </div>

    <div class="footer">
      <BaseButton :loading="status === 'pending'" @click="show = true">{{ t("newTransaction") }}</BaseButton>
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
  const { data: account, status } = useWalleeApi(api => api.accounts.show(id), { deep: true })

  const show = ref(false)

  const handleCreate = ({ transaction }: { transaction: Transaction }) => {
    account.value!.balance += transaction.value
    account.value!.transactions.push(transaction)
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
    }

    .main {
      flex-grow: 1;
    }
  }
</style>

<i18n lang="yaml">
  en:
    newTransaction: New transaction
    transactions: Transactions
</i18n>
