<template>
  <div id="transactions-id">
    <pre>{{ transaction }}</pre>
    <BaseButton @click="show = true">{{ t("editTransaction") }}</BaseButton>
    <BaseButton @click="handleDelete">{{ t("deleteTransaction") }}</BaseButton>
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
  const { data: transaction, error } = await useWalleeApi(api => api.transactions.show(id))

  if (error.value) {
    await router.replace(localePath("/"))
    // TODO: add failure notification
  }

  const show = ref(false)

  const handleDelete = async () => {
    await walleeApi.transactions.destroy(transaction.value!.id)
    await router.replace(localePath("/"))
  }

  const handleUpdate = ({ transaction: updatedTransaction }: { transaction: Transaction }) => {
    transaction.value = updatedTransaction
    show.value = false
  }
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
