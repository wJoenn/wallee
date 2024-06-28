<template>
  <section class="flex flex-col gap-4">
    <h2 class="flex font-medium gap-4 items-center text-xl">
      <span>{{ t(category) }}</span>

      <template v-if="!isMain">
        <Icon v-if="loading" name="svg-spinners:ring-resize" />
        <Icon v-else name="ion:add-circle-outline" @click="$emit('add')" />
      </template>
    </h2>

    <nav v-if="loading" class="default:grid-cols-2 gap-4 grid" :class="{ 'grid-cols-1': isMain }">
      <BaseSkeleton v-for="i in (isMain ? 1 : 4)" :key="i" class="border p-4 rounded shadow-black shadow-md">
        <BaseSkeleton class="bg h-4 w-[10ch]" />

        <div :class="{ 'flex flex-col items-end': isMain }">
          <BaseSkeleton class="bg default:h-4 w-[8ch]" :class="{ 'h-5': isMain }" />
          <BaseSkeleton v-if="isMain" class="bg h-3 w-[20ch]" />
        </div>
      </BaseSkeleton>
    </nav>

    <nav v-else class="default:grid-cols-2 gap-4 grid" :class="{ 'grid-cols-1': isMain }">
      <NuxtLink
        v-for="account in computedAccount"
        :key="account.id"
        class="bg border p-4 rounded shadow-black shadow-md"
        :to="localePath(`/accounts/${account.id}`)"
      >
        <span>{{ account.name }}</span>

        <div :class="{ 'flex flex-col items-end': isMain }">
          <p :class="{ 'text-xl': isMain }">{{ toEuro(account.balance) }}</p>

          <span v-if="isMain" class="text-secondary text-sm">
            {{ t("dues", { dues: toEuro(account.balance + dues) }) }}
          </span>
        </div>
      </NuxtLink>
    </nav>
  </section>
</template>

<script setup lang="ts">
  import type { Account } from "~~/types/api"

  defineEmits<{
    (event: "add"): void
  }>()

  const props = defineProps<{
    accounts?: Account[]
    category: "budget" | "main" | "saving"
    loading?: boolean
  }>()

  const { t } = useI18n()
  const localePath = useLocalePath()

  const computedAccount = computed(() => props.accounts?.filter(account => account.category === props.category))
  const isMain = computed(() => props.category === "main")

  const dues = computed(() => {
    if (!props.accounts || props.category !== "main") { return 0 }

    return props.accounts.reduce((sum, account) => {
      if (account.category === "main" || account.balance > 0) { return sum }
      return sum + account.balance
    }, 0)
  })
</script>

<i18n lang="yaml">
  en:
    budget: Budgets
    dues: "Due amounts included {dues}"
    main: Main account
    saving: Savings
</i18n>
