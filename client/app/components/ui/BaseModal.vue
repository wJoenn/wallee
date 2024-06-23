<template>
  <Teleport to="#teleports">
    <div class="base-modal bg fixed inset-0 overflow-x-hidden overflow-y-auto p-8 w-screen" v-bind="$attrs">
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
