<template>
  <Teleport to="#teleports">
    <div v-if="show" class="base-modal">
      <slot />
    </div>
  </Teleport>
</template>

<script setup lang="ts">
  defineProps<{
    show: boolean
  }>()

  defineSlots<{
    default: never
  }>()
</script>

<style scoped>
  .base-modal {
    background: var(--background-primary);
    inset: 0;
    padding: 2rem;
    position: fixed;
  }
</style>
