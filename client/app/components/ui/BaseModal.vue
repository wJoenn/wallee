<template>
  <Teleport to="#teleports">
    <div class="base-modal">
      <slot />
    </div>
  </Teleport>
</template>

<script setup lang="ts">
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
