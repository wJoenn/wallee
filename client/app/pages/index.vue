<template>
  <div id="index">
    <div class="header">
      <h1>{{ t("title") }}</h1>
      <BaseButton @click="signOut">{{ t("globals.actions.signOut") }}</BaseButton>
    </div>

    <h2>{{ t("sections.mainAccount") }}</h2>

    <NuxtLink v-if="mainAccount" class="account" :to="localePath(`/accounts/${mainAccount.id}`)">
      <span>{{ mainAccount!.name }}</span>

      <div>
        <p>{{ toEuro(mainAccount!.balance) }}</p>
        <span v-if="dueAmounts">Due amounts included: {{ toEuro(mainAccount!.balance + dueAmounts) }}</span>
      </div>
    </NuxtLink>

    <h2>
      <span>{{ t("sections.accounts") }}</span>
      <Icon name="ion:add-circle-outline" @click="showAccountForm = true" />
    </h2>

    <nav class="accounts">
      <NuxtLink
        v-for="account in secondaryAccounts"
        :key="account.id"
        class="account"
        :to="localePath(`/accounts/${account.id}`)"
      >
        <span>{{ account.name }}</span>
        <p>{{ toEuro(account.balance) }}</p>
      </NuxtLink>
    </nav>

    <div class="footer">
      <BaseButton @click="showTransactionForm = true">{{ t("newTransaction") }}</BaseButton>
    </div>

    <AccountFormModal v-if="showAccountForm" @close="showAccountForm = false" @create="handleCreateAccount" />

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
  const { data: accounts } = useWalleeApi(api => api.accounts.index(), { deep: true })

  const showAccountForm = ref(false)
  const showTransactionForm = ref(false)

  const dueAmounts = computed(() => (
    secondaryAccounts.value?.reduce((sum, account) => account.balance < 0 ? sum + account.balance : sum, 0)
  ))

  const mainAccount = computed(() => accounts.value?.find(account => account.main))
  const secondaryAccounts = computed(() => accounts.value?.filter(account => !account.main))

  const handleCreateTransaction = ({ accountId, transaction }: { accountId?: number, transaction: Transaction }) => {
    const account = accounts.value!.find(accountOption => accountOption.id === accountId)!
    account.balance += transaction.value

    showTransactionForm.value = false
  }

  const handleCreateAccount = (account: Omit<Account, "transactions">) => {
    accounts.value!.push(account)
  }
</script>

<style>
  #index {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    min-height: 1px;
    padding: 2rem 2rem 0;

    .header {
      align-items: center;
      display: flex;
      justify-content: space-between;

      h1 {
        margin: 0;
      }
    }

    h2 {
      align-items: center;
      display: flex;
      gap: 1rem;
    }

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

    .account {
      background-color: var(--background-primary);
      border: 1px solid var(--color-secondary);
      border-radius: 0.25rem;
      box-shadow: 0 0 10px black;
      padding: 1rem;

      div {
        text-align: end;

        p {
          font-size: 1.2rem;
        }

        span {
          color: #ffffff80;
          font-size: 0.8rem;
        }
      }
    }

    .accounts {
      display: grid;
      gap: 1rem;
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }
  }
</style>

<i18n lang="yaml">
  en:
    newAccount: New account
    newTransaction: New transaction
    sections:
      accounts: Accounts
      mainAccount: Main account
    title: Home page
    total: "Total: {amount}"
</i18n>
