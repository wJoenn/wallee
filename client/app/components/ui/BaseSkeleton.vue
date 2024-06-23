<template>
  <div class="animate-pulse block default:bg-secondary my-[2px] rounded">
    <slot />
  </div>
</template>

<script setup lang="ts">
  defineSlots<{
    default: never
  }>()
</script>
