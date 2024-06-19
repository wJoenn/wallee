<template>
  <div class="transaction-list">
    <div class="header">
      <h2>
        <span>{{ t("transactions") }}</span>
        <Icon v-if="loading" name="svg-spinners:ring-resize" />
        <Icon v-else name="ion:add-circle-outline" @click="$emit('add')" />
      </h2>

      <div class="switch">
        <button :class="{ active: activeList === 'executed' }" @click="activeList = 'executed'">Executed</button>
        <button :class="{ active: activeList === 'planned' }" @click="activeList = 'planned'">Planned</button>
      </div>
    </div>

    <nav>
      <template v-if="loading">
        <a v-for="i in 10" :key="i">
          <div class="date">
            <BaseSkeleton as="p" style="height: 1rem; width: 2ch;" />
            <BaseSkeleton as="p" style="height: 1rem; width: 3ch;" />
          </div>

          <div class="amount">
            <BaseSkeleton as="p" style="height: 1.2rem; width: 8ch;" />
            <BaseSkeleton as="span" style="height: 1rem; width: 15ch;" />
          </div>
        </a>
      </template>

      <template v-else>
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
      </template>
    </nav>
  </div>
</template>

<script setup lang="ts">
  import type { Account } from "~~/types/api"

  import dayjs from "~~/libs/dayjs.ts"

  defineEmits<{
    (event: "add"): void
  }>()

  const props = defineProps<{
    loading?: boolean
    transactions?: Account["transactions"]
  }>()

  const { t } = useI18n()
  const localePath = useLocalePath()

  const activeList = ref<"executed" | "planned">("executed")

  const sortedTransactions = computed(() => {
    if (!props.transactions) { return }

    return [...props.transactions[activeList.value]].sort((a, b) => {
      const order = activeList.value === "executed" ? -1 : 1
      if (dayjs(a.transacted_at).isAfter(dayjs(b.transacted_at))) { return order }
      if (dayjs(a.transacted_at).isBefore(dayjs(b.transacted_at))) { return -order }
      return 0
    })
  })
</script>

<style scoped>
  .transaction-list {
    margin-top: -1rem;

    nav {
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
          align-items: flex-end;
          display: flex;
          flex-direction: column;
          text-align: end;

          p {
            font-size: 1.2rem;
            font-weight: 600;
          }
        }

        .date {
          align-items: center;
          display: flex;
          flex-direction: column;
        }
      }
    }

    .header {
      background-color: var(--background-primary);
      padding: 1rem 0;
      position: sticky;
      top: 0;

      h2 {
        align-items: center;
        display: flex;
        gap: 1rem;
      }

      .switch {
        background-color: var(--color-secondary);
        border-radius: 0.25rem;
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        margin: 1rem 0;

        button {
          background-color: transparent;
          border: none;
          border-radius: 0.25rem;
          font-size: 0.8rem;
          margin: 0.25rem;
          padding: 0.25rem;
          transition: background-color 0.3s ease;

          &.active {
            background-color: var(--background-primary);
          }
        }
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    transactions: Transactions
</i18n>
