<template>
  <component :is="component" name="slide-y" tag="div">
    <slot />
  </component>
</template>

<script setup lang="ts">
  // eslint-disable-next-line import/named
  import { Transition, TransitionGroup } from "vue"

  const props = withDefaults(defineProps<{
    from?: number
    group?: boolean
  }>(), {
    from: 1
  })

  defineSlots<{
    default: never
  }>()

  const component = computed(() => props.group ? TransitionGroup : Transition)

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
