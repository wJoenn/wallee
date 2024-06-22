<template>
  <div id="transactions-id">
    <div class="info">
      <pre>{{ transaction }}</pre>

      <BaseButton :loading="status === 'pending'" @click="showTransactionForm = true">
        {{ t("editTransaction") }}
      </BaseButton>

      <BaseButton @click="router.back">{{ t("globals.actions.back") }}</BaseButton>
    </div>

    <BaseButton :loading="status === 'pending'" @click="showDeleteConfirmation = true">
      {{ t("deleteTransaction") }}
    </BaseButton>

    <DeleteConfirmation
      :loading="status === 'pending'"
      :show="showDeleteConfirmation"
      @close="showDeleteConfirmation = false"
      @confirm="handleDelete"
    />

    <TransactionFormModal
      v-if="showTransactionForm"
      :transaction
      @close="showTransactionForm = false"
      @update="handleUpdate"
    />
  </div>
</template>

<script setup lang="ts">
  import type { RouteLocationNormalizedLoaded } from "vue-router"
  import type { Transaction } from "~~/types/api"

  type Route = RouteLocationNormalizedLoaded & {
    params: {
      id: string
    }
  }

  const { t } = useI18n()
  const localePath = useLocalePath()
  const router = useLocaleRouter()
  const { params: { id } } = useRoute() as Route
  const { data: transaction, status } = useWalleeApi(api => api.transactions.show(id))

  const showTransactionForm = ref(false)
  const showDeleteConfirmation = ref(false)

  const handleDelete = async () => {
    status.value = "pending"
    await walleeApi.transactions.destroy(transaction.value!.id)
    await router.replace(localePath("/"))
  }

  const handleUpdate = ({ transaction: updatedTransaction }: { transaction: Transaction }) => {
    transaction.value = updatedTransaction
  }

  watch(status, async () => {
    if (status.value === "error") {
      await router.replace(localePath("/"))
      // TODO: add failure notification
    }
  }, { immediate: true })
</script>

<style scoped>
  #transactions-id {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    gap: 4rem;
    min-height: 100vh;
    min-height: 100svh;
    padding: 2rem;

    .info {
      display: flex;
      flex-direction: column;
      gap: 2rem;
    }
  }
</style>

<i18n lang="yaml">
  en:
    deleteTransaction: Delete transaction
    editTransaction: Edit transaction
</i18n>
