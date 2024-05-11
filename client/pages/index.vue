<template>
  <IonPage>
    <div>
      <h1>Transactions</h1>
      <p>Total: {{ transactions?.reduce((sum, transaction) => sum + transaction.value, 0) }}</p>

      <ul>
        <li v-for="transaction in transactions" :key="transaction.id">
          <p>{{ transaction.value }}</p>
          <span>{{ transaction.description }}</span>
        </li>
      </ul>

      <BaseButton @click="signOut">Sign out</BaseButton>
    </div>
  </IonPage>
</template>

<script setup lang="ts">
  const api = useApi()
  const { signOut } = useUserStore()

  const { data: transactions } = useAsyncData(async () => {
    const { _data } = await api.transactions.index()
    return _data!
  })
</script>
