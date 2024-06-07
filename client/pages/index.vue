<template>
  <div id="index" ref="presentingElement">
    <div class="header">
      <div>
        <h1>Transactions</h1>
        <BaseButton @click="signOut">Sign out</BaseButton>
      </div>

      <p>Total: {{ toEuro(transactions?.reduce((sum, transaction) => sum + transaction.value, 0)) }}</p>
    </div>

    <ul class="transactions">
      <li v-for="transaction in sortedTransactions" :key="transaction.id">
        <p>{{ toEuro(transaction.value) }}</p>
        <span>{{ transaction.description }}</span>
      </li>
    </ul>

    <BaseButton @click="show = true">New Transaction</BaseButton>
  </div>

  <TransactionFormModal :show @close="show = false" @create="handleCreate" />
</template>

<script setup lang="ts">
  import type { Transaction } from "~/types/api"

  const api = useApi()
  const { signOut } = useUserStore()

  const { data: transactions } = useAsyncData(async () => {
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

      li {
        border-bottom: 1px solid var(--color-secondary);
        padding: 0.5rem 0;

        &:last-child {
          border: none;
        }
      }
    }
  }
</style>
