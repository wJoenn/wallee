<template>
  <nav class="transaction-list">
    <NuxtLink
      v-for="transaction in sortedTransactions"
      :key="transaction.id"
      :to="localePath(`/transactions/${transaction.id}`)"
    >
      <div>
        <p>{{ toEuro(transaction.value) }}</p>
        <span>{{ transaction.description }}</span>
      </div>
    </NuxtLink>
  </nav>
</template>

<script setup lang="ts">
  import type { Transaction } from "~~/types/api"

  import dayjs from "~~/libs/dayjs.ts"

  const props = defineProps<{
    transactions?: Transaction[]
  }>()

  const localePath = useLocalePath()

  const sortedTransactions = computed(() => {
    if (!props.transactions) { return }

    return [...props.transactions].sort((a, b) => {
      if (dayjs(a.transacted_at).isAfter(dayjs(b.transacted_at))) { return -1 }
      if (dayjs(a.transacted_at).isBefore(dayjs(b.transacted_at))) { return 1 }
      return 0
    })
  })
</script>

<style scoped>
  .transaction-list {
    display: flex;
    flex-direction: column;
    overflow-y: scroll;

    a {
      border-bottom: 1px solid var(--color-secondary);
      flex-grow: 1;
      padding: 0.5rem 0;

      &:last-child {
        border: none;
      }
    }
  }
</style>
