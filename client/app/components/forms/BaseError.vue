<template>
  <TransitionSlideY group>
    <p v-for="error in errors" :key="error" class="base-error">
      <Icon name="ion:alert-circle-outline" />
      {{ error }}
    </p>
  </TransitionSlideY>
</template>

<script setup lang="ts">
  defineProps<{
    errors?: string[]
  }>()
</script>

<style scoped>
  .base-error {
    align-items: center;
    color: var(--text-negative);
    display: flex;
    font-size: 0.8rem;
    gap: 0.5rem;
  }
</style>
