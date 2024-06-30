<template>
  <div class="flex flex-col h-full justify-between">
    <div class="flex flex-col gap-8 overflow-hidden">
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
  const { data: transaction, status } = useWalleeApi(walleeApi.transactions.show, id)

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

<i18n lang="yaml">
  en:
    deleteTransaction: Delete transaction
    editTransaction: Edit transaction
</i18n>
