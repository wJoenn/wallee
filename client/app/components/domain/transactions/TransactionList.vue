<template>
  <nav class="transaction-list">
    <NuxtLink
      v-for="transaction in sortedTransactions"
      :key="transaction.id"
      :to="localePath(`/transactions/${transaction.id}`)"
    >
      <div class="date">
        <p>{{ dayjs(transaction.transacted_at).format("DD") }}</p>
        <p>{{ dayjs(transaction.transacted_at).format("MMM") }}</p>
      </div>

      <div class="amount">
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
      display: flex;
      flex-grow: 1;
      gap: 1rem;
      justify-content: space-between;
      padding: 0.5rem 0;

      &:last-child {
        border: none;
      }

      .amount {
        text-align: end;

        p {
          font-size: 1.2rem;
          font-weight: 600;
        }
      }

      .date {
        text-align: center;
      }
    }
  }
</style>