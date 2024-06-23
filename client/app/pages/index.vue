<template>
  <div class="flex flex-col gap-8 h-full">
    <div class="flex items-center justify-between">
      <h1 class="font-semibold text-3xl">{{ t("title") }}</h1>
      <BaseButton @click="signOut">{{ t("globals.actions.signOut") }}</BaseButton>
    </div>

    <div class="flex flex-col flex-grow gap-8">
      <section class="flex flex-col gap-4">
        <h2 class="flex font-medium gap-4 items-center text-xl">{{ t("sections.mainAccount") }}</h2>

        <BaseSkeleton v-if="status === 'pending'" class="border p-4 rounded shadow-black shadow-md">
          <BaseSkeleton class="bg h-4 w-[10ch]" />

          <div class="flex flex-col items-end">
            <BaseSkeleton class="bg h-5 w-[8ch]" />
            <BaseSkeleton class="bg h-3 w-[20ch]" />
          </div>
        </BaseSkeleton>

        <NuxtLink
          v-else-if="mainAccount"
          class="bg border p-4 rounded shadow-black shadow-md"
          :to="localePath(`/accounts/${mainAccount.id}`)"
        >
          <span>{{ mainAccount!.name }}</span>

          <div class="flex flex-col items-end">
            <p class="text-xl">{{ toEuro(mainAccount!.balance) }}</p>

            <span v-if="dueAmounts" class="text-secondary text-sm">
              Due amounts included: {{ toEuro(mainAccount!.balance + dueAmounts) }}
            </span>
          </div>
        </NuxtLink>
      </section>

      <section class="flex flex-col gap-4">
        <h2 class="flex font-medium gap-4 items-center text-xl">
          <span>{{ t("sections.budgets") }}</span>
          <Icon v-if="status === 'pending'" name="svg-spinners:ring-resize" />
          <Icon v-else name="ion:add-circle-outline" @click="newAccountCategory = 'budget'; showAccountForm = true" />
        </h2>

        <nav v-if="status === 'pending'" class="gap-4 grid grid-cols-2">
          <BaseSkeleton v-for="i in 4" :key="i" class="border p-4 rounded shadow-black shadow-md">
            <BaseSkeleton class="bg h-4 w-[10ch]" />
            <BaseSkeleton class="bg h-5 w-[8ch]" />
          </BaseSkeleton>
        </nav>

        <nav v-else class="gap-4 grid grid-cols-2">
          <NuxtLink
            v-for="account in budgetAccounts"
            :key="account.id"
            class="bg border p-4 rounded shadow-black shadow-md"
            :to="localePath(`/accounts/${account.id}`)"
          >
            <span>{{ account.name }}</span>
            <p>{{ toEuro(account.balance) }}</p>
          </NuxtLink>
        </nav>
      </section>

      <section class="flex flex-col gap-4 mb-1">
        <h2 class="flex font-medium gap-4 items-center text-xl">
          <span>{{ t("sections.savings") }}</span>
          <Icon v-if="status === 'pending'" name="svg-spinners:ring-resize" />
          <Icon v-else name="ion:add-circle-outline" @click="newAccountCategory = 'saving'; showAccountForm = true" />
        </h2>

        <nav v-if="status === 'pending'" class="gap-4 grid grid-cols-2">
          <BaseSkeleton v-for="i in 2" :key="i" class="border p-4 rounded shadow-black shadow-md">
            <BaseSkeleton class="bg h-4 w-[10ch]" />
            <BaseSkeleton class="bg h-5 w-[8ch]" />
          </BaseSkeleton>
        </nav>

        <nav v-else class="gap-4 grid grid-cols-2">
          <NuxtLink
            v-for="account in savingAccounts"
            :key="account.id"
            class="bg border p-4 rounded shadow-black shadow-md"
            :to="localePath(`/accounts/${account.id}`)"
          >
            <span>{{ account.name }}</span>
            <p>{{ toEuro(account.balance) }}</p>
          </NuxtLink>
        </nav>
      </section>
    </div>

    <div class="-m-8 bg bottom-0 inset-x-0 p-8 sticky">
      <BaseButton class="w-full" @click="showTransactionForm = true">{{ t("newTransaction") }}</BaseButton>
    </div>

    <AccountFormModal
      v-if="showAccountForm"
      :category="newAccountCategory"
      @close="showAccountForm = false"
      @create="handleCreateAccount"
    />

    <TransactionFormModal
      v-if="showTransactionForm"
      @close="showTransactionForm = false"
      @create="handleCreateTransaction"
    />
  </div>
</template>

<script setup lang="ts">
  import type { Account, Transaction } from "~~/types/api"

  const { t } = useI18n()
  const localePath = useLocalePath()
  const { signOut } = useUserStore()
  const { data: accounts, status } = useWalleeApi(api => api.accounts.index(), { deep: true })

  const newAccountCategory = ref<"budget" | "saving">("budget")

  const showAccountForm = ref(false)
  const showTransactionForm = ref(false)

  const budgetAccounts = computed(() => accounts.value?.filter(account => account.category === "budget"))
  const mainAccount = computed(() => accounts.value?.find(account => account.category === "main"))
  const savingAccounts = computed(() => accounts.value?.filter(account => account.category === "saving"))

  const dueAmounts = computed(() => (
    budgetAccounts.value?.reduce((sum, account) => account.balance < 0 ? sum + account.balance : sum, 0)
  ))

  const handleCreateTransaction = ({ accountId, transaction }: { accountId?: number, transaction: Transaction }) => {
    const account = accounts.value!.find(accountOption => accountOption.id === accountId)!
    account.balance += transaction.value
  }

  const handleCreateAccount = (account: Account) => {
    accounts.value!.push(account)
  }
</script>

<i18n lang="yaml">
  en:
    newAccount: New account
    newTransaction: New transaction
    sections:
      budgets: Budgets
      mainAccount: Main account
      savings: Savings
    title: Home page
    total: "Total: {amount}"
</i18n>
