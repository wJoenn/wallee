<template>
  <component :is="as" class="base-skeleton">
    <slot />
  </component>
</template>

<script setup lang="ts">
  const props = withDefaults(defineProps<{
    secondary?: boolean
    as?: string
  }>(), {
    as: "div"
  })

  defineSlots<{
    default: never
  }>()

  const css = computed(() => ({
    backgroundColor: `var(--${props.secondary ? "color-secondary" : "background-primary"})`
  }))
</script>

<style scoped>
  @keyframes pulse {
    0%, 100% {
      opacity: 1;
    }

    50% {
      opacity: 0.5;
    }
  }

  .base-skeleton {
    animation: pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite;
    background-color: v-bind("css.backgroundColor") !important;
    border-radius: 0.25rem;
    display: block;
    margin: 1px 0;
  }
</style>
