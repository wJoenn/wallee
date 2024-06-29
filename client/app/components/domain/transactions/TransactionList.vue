<template>
  <div class="-mt-8">
    <div class="bg py-8 sticky top-0">
      <h2 class="flex font-medium gap-4 items-center mb-4 text-xl">
        <span>{{ t("transactions") }}</span>
        <Icon v-if="loading" name="svg-spinners:ring-resize" />
        <Icon v-else name="ion:add-circle-outline" @click="$emit('add')" />
      </h2>

      <div class="bg-secondary grid grid-cols-2 rounded">
        <button
          class="border-none default:bg-transparent duration-300 m-1 p-1 rounded text-xs transition-colors"
          :class="{ bg: active === 'executed' }"
          @click="active = 'executed'"
        >
          {{ t("executed") }}
        </button>

        <button
          class="border-none default:bg-transparent duration-300 m-1 p-1 rounded text-xs transition-colors"
          :class="{ bg: active === 'planned' }"
          @click="active = 'planned'"
        >
          {{ t("planned") }}
        </button>
      </div>
    </div>

    <nav>
      <template v-if="loading">
        <a v-for="i in 10" :key="i" class="border-b flex flex-grow gap-4 justify-between last:border-none py-2">
          <div class="flex flex-col items-center">
            <BaseSkeleton class="h-4 w-[2ch]" />
            <BaseSkeleton class="h-4 w-[3ch]" />
          </div>

          <div class="flex flex-col items-end">
            <BaseSkeleton class="h-5 w-[8ch]" />
            <BaseSkeleton class="h-4 w-[15ch]" />
          </div>
        </a>
      </template>

      <template v-else>
        <NuxtLink
          v-for="transaction in sortedTransactions"
          :key="transaction.id"
          class="border-b flex flex-grow gap-4 justify-between last:border-none py-2"
          :to="localePath(`/transactions/${transaction.id}`)"
        >
          <div class="flex flex-col items-center">
            <p>{{ dayjs(transaction.transacted_at).format("DD") }}</p>
            <p>{{ dayjs(transaction.transacted_at).format("MMM") }}</p>
          </div>

          <div class="flex flex-col text-end">
            <p class="font-semibold text-xl">{{ toEuro(transaction.value) }}</p>
            <span>{{ transaction.description }}</span>
          </div>
        </NuxtLink>
      </template>
    </nav>
  </div>
</template>

<script setup lang="ts">
  import type { Transaction } from "~~/types/api"

  import dayjs from "~~/libs/dayjs.ts"

  defineEmits<{
    (event: "add"): void
  }>()

  const props = defineProps<{
    loading?: boolean
    transactions?: Transaction[]
  }>()

  const { t } = useI18n()
  const localePath = useLocalePath()

  const active = defineModel<"executed" | "planned">("active")

  const sortedTransactions = computed(() => {
    if (!props.transactions) { return }

    return [...props.transactions].sort((a, b) => {
      const order = active.value === "executed" ? -1 : 1

      if (dayjs(a.transacted_at).isAfter(dayjs(b.transacted_at))) { return order }
      if (dayjs(a.transacted_at).isBefore(dayjs(b.transacted_at))) { return -order }
      return 0
    })
  })
</script>

<i18n lang="yaml">
  en:
    executed: Executed
    planned: Planned
    transactions: Transactions
</i18n>
