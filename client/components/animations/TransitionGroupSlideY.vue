<template>
  <TransitionGroup name="slide-y" tag="div">
    <slot />
  </TransitionGroup>
</template>

<script setup lang="ts">
  const props = defineProps<{
    from: number
  }>()

  defineSlots<{
    default: never
  }>()

  const css = computed(() => ({
    transform: `translateY(calc(0.25rem * ${props.from}))`
  }))
</script>

<style>
  .slide-y-enter-from,
  .slide-y-leave-to {
    opacity: 0;
    transform: v-bind("css.transform");
  }

  .slide-y-enter-active,
  .slide-y-leave-active,
  .slide-y-move {
    transition: all 0.3s ease;
  }

  .slide-y-leave-active {
    position: absolute;
  }
</style>
