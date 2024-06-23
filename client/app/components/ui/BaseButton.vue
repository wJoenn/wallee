<template>
  <button
    class="duration-300 px-4 py-3 rounded transition-opacity"
    :class="[css[mode], { 'opacity-50': loading }]"
    :disabled="loading"
    :type
  >
    <Icon v-if="loading" name="svg-spinners:ring-resize" />
    <slot v-else />
  </button>
</template>

<script setup lang="ts">
  withDefaults(defineProps<{
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
    danger: "bg-danger",
    primary: "bg-nuxt text-contrasted"
  }))
</script>
