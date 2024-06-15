<template>
  <div id="transactions-id">
    <pre>{{ transaction }}</pre>
    <BaseButton :loading="status === 'pending'" @click="show = true">{{ t("editTransaction") }}</BaseButton>
    <BaseButton :loading="status === 'pending'" @click="handleDelete">{{ t("deleteTransaction") }}</BaseButton>
    <NuxtLink :to="localePath('/')">{{ t("globals.actions.home") }}</NuxtLink>

    <TransactionFormModal v-if="show" :transaction @close="show = false" @update="handleUpdate" />
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

  const show = ref(false)

  const handleDelete = async () => {
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
    gap: 2rem;
    padding: 2rem;
  }
</style>

<i18n lang="yaml">
  en:
    deleteTransaction: Delete transaction
    editTransaction: Edit transaction
</i18n>
