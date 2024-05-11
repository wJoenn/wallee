<template>
  <IonPage>
    <div>
      <h1>Hello world</h1>
      <BaseButton @click="signOut">Sign out</BaseButton>
    </div>
  </IonPage>
</template>

<script setup lang="ts">
  const { signOut } = useUserStore()
</script>
