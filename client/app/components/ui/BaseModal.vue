<template>
  <Teleport to="#teleports">
    <div class="base-modal" v-bind="$attrs">
      <slot />
    </div>
  </Teleport>
</template>

<script setup lang="ts">
  defineSlots<{
    default: never
  }>()

  defineOptions({
    inheritAttrs: false
  })
</script>

<style scoped>
  .base-modal {
    background: var(--background-primary);
    inset: 0;
    overflow-y: scroll;
    padding: 2rem;
    position: fixed;
  }
</style>
