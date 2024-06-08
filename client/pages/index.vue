<template>
  <div v-if="transactions" id="index" ref="presentingElement">
    <div class="header">
      <div>
        <h1>{{ t("title") }}</h1>
        <BaseButton @click="signOut">{{ t("globals.actions.signOut") }}</BaseButton>
      </div>

      <p>
        {{ t("total", { amount: toEuro(transactions?.reduce((sum, transaction) => sum + transaction.value, 0)) }) }}
      </p>
    </div>

    <nav class="transactions">
      <div v-for="transaction in sortedTransactions" :key="transaction.id">
        <NuxtLink :to="localePath(`/transactions/${transaction.id}`)">
          <div>
            <p>{{ toEuro(transaction.value) }}</p>
            <span>{{ transaction.description }}</span>
          </div>
        </NuxtLink>

        <Icon name="ion:trash-bin" @click.stop="handleDelete(transaction.id)" />
      </div>
    </nav>

    <BaseButton @click="show = true">{{ t("newTransaction") }}</BaseButton>
  </div>

  <TransactionFormModal :show @close="show = false" @create="handleCreate" />
</template>

<script setup lang="ts">
  import type { Transaction } from "~/types/api"

  const { t } = useI18n()
  const localePath = useLocalePath()
  const { signOut } = useUserStore()

  const { data: transactions } = await useWalleeApi(async api => {
    const { _data } = await api.transactions.index()
    return _data!
  })

  const presentingElement = ref<HTMLDivElement>()
  const show = ref(false)

  const sortedTransactions = computed(() => {
    if (!transactions.value) { return [] }

    return [...transactions.value].sort((a, b) => {
      if (new Date(a.transacted_at) > new Date(b.transacted_at)) { return -1 }
      if (new Date(a.transacted_at) < new Date(b.transacted_at)) { return 1 }
      return 0
    })
  })

  const handleCreate = (transaction: Transaction) => {
    transactions.value?.push(transaction)
    show.value = false
  }

  const handleDelete = async (id: number) => {
    await walleeApi.transactions.destroy(id)

    const transactionIndex = transactions.value!.findIndex(transaction => transaction.id === id)
    if (transactionIndex !== -1) {
      transactions.value!.splice(transactionIndex, 1)
    }
  }

  const toEuro = (value?: number) => `${((value ?? 0) / 100).toFixed(2)} €`
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

    .transactions {
      display: flex;
      flex-direction: column;
      overflow-y: scroll;

      > div {
        align-items: center;
        display: flex;
        justify-content: space-between;

        a {
          border-bottom: 1px solid var(--color-secondary);
          flex-grow: 1;
          padding: 0.5rem 0;

          &:last-child {
            border: none;
          }
        }
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    newTransaction: New transaction
    title: Transactions
    total: "Total: {amount}"
</i18n>
