<template>
  <button class="base-button" :class="{ loading }" :disabled="loading" :type>
    <Icon v-if="loading" name="svg-spinners:ring-resize" />
    <slot v-else />
  </button>
</template>

<script setup lang="ts">
  const props = withDefaults(defineProps<{
    loading?: boolean
    mode?: "danger" | "primary"
    type?: "button" | "submit"
  }>(), {
    mode: "primary",
    type: "button"
  })

  defineSlots<{
    default: never
  }>()

  const css = computed(() => ({
    backgroundColor: `var(--color-${props.mode})`,
    color: `var(${props.mode === "primary" ? "--background-primary" : "--text-primary"})`
  }))
</script>

<style scoped>
  .base-button {
    background-color: v-bind("css.backgroundColor");
    border: none;
    border-radius: 0.25rem;
    color: v-bind("css.color");
    padding: 0.75rem 1rem;
    transition: opacity 0.3s ease;

    &.loading {
      opacity: 0.5;
    }
  }
</style>
