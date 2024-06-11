<template>
  <div>
    <NuxtLink :to="localePath('/')">{{ t("globals.actions.home") }}</NuxtLink>
    <pre>{{ transaction }}</pre>
    <BaseButton @click="show = true">{{ t("editTransaction") }}</BaseButton>
  </div>

  <TransactionFormModal v-if="transaction" :show :transaction @close="show = false" @update="handleUpdate" />
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
  const { params: { id } } = useRoute() as Route

  const { data: transaction } = await useWalleeApi(async api => {
    const { _data } = await api.transactions.show(id)
    return _data!
  })

  const show = ref(false)

  const handleUpdate = (updatedTransaction: Transaction) => {
    transaction.value = updatedTransaction
    show.value = false
  }
</script>

<i18n lang="yaml">
  en:
    editTransaction: Edit transaction
</i18n>
