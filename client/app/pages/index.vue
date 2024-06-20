<template>
  <div id="index">
    <div class="header">
      <h1>{{ t("title") }}</h1>
      <BaseButton @click="signOut">{{ t("globals.actions.signOut") }}</BaseButton>
    </div>

    <div class="main">
      <section>
        <h2>{{ t("sections.mainAccount") }}</h2>

        <BaseSkeleton v-if="status === 'pending'" class="account">
          <BaseSkeleton as="span" primary style="height: 1rem; width: 10ch;" />

          <div>
            <BaseSkeleton as="p" primary style="height: 1.2rem; width: 8ch;" />
            <BaseSkeleton as="span" primary style="height: 0.8rem; width: 20ch;" />
          </div>
        </BaseSkeleton>

        <NuxtLink v-else-if="mainAccount" class="account" :to="localePath(`/accounts/${mainAccount.id}`)">
          <span>{{ mainAccount!.name }}</span>

          <div>
            <p>{{ toEuro(mainAccount!.balance) }}</p>
            <span v-if="dueAmounts">Due amounts included: {{ toEuro(mainAccount!.balance + dueAmounts) }}</span>
          </div>
        </NuxtLink>
      </section>

      <section>
        <h2>
          <span>{{ t("sections.budgets") }}</span>
          <Icon v-if="status === 'pending'" name="svg-spinners:ring-resize" />
          <Icon v-else name="ion:add-circle-outline" @click="newAccountCategory = 'budget'; showAccountForm = true" />
        </h2>

        <nav v-if="status === 'pending'" class="accounts">
          <BaseSkeleton v-for="i in 4" :key="i" class="account">
            <BaseSkeleton as="span" primary style="height: 1rem; width: 10ch;" />
            <BaseSkeleton as="p" primary style="height: 1.2rem; width: 8ch;" />
          </BaseSkeleton>
        </nav>

        <nav v-else class="accounts">
          <NuxtLink
            v-for="account in budgetAccounts"
            :key="account.id"
            class="account"
            :to="localePath(`/accounts/${account.id}`)"
          >
            <span>{{ account.name }}</span>
            <p>{{ toEuro(account.balance) }}</p>
          </NuxtLink>
        </nav>
      </section>

      <section>
        <h2>
          <span>{{ t("sections.savings") }}</span>
          <Icon v-if="status === 'pending'" name="svg-spinners:ring-resize" />
          <Icon v-else name="ion:add-circle-outline" @click="newAccountCategory = 'saving'; showAccountForm = true" />
        </h2>

        <nav v-if="status === 'pending'" class="accounts">
          <BaseSkeleton v-for="i in 2" :key="i" class="account">
            <BaseSkeleton as="span" primary style="height: 1rem; width: 10ch;" />
            <BaseSkeleton as="p" primary style="height: 1.2rem; width: 8ch;" />
          </BaseSkeleton>
        </nav>

        <nav v-else class="accounts">
          <NuxtLink
            v-for="account in savingAccounts"
            :key="account.id"
            class="account"
            :to="localePath(`/accounts/${account.id}`)"
          >
            <span>{{ account.name }}</span>
            <p>{{ toEuro(account.balance) }}</p>
          </NuxtLink>
        </nav>
      </section>
    </div>

    <div class="footer">
      <BaseButton @click="showTransactionForm = true">{{ t("newTransaction") }}</BaseButton>
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

<style>
  #index {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    min-height: 100vh;
    min-height: 100svh;
    padding: 2rem 2rem 0;

    .header {
      align-items: center;
      display: flex;
      justify-content: space-between;

      h1 {
        margin: 0;
      }
    }

    .main {
      display: flex;
      flex-direction: column;
      flex-grow: 1;
      gap: 2rem;

      section {
        display: flex;
        flex-direction: column;
        gap: 1rem;

        h2 {
          align-items: center;
          display: flex;
          gap: 1rem;
        }

        .account {
          background-color: var(--background-primary);
          border: 1px solid var(--color-secondary);
          border-radius: 0.25rem;
          box-shadow: 0 0 10px black;
          padding: 1rem;

          div {
            align-items: flex-end;
            display: flex;
            flex-direction: column;

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
  }
</style>

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
