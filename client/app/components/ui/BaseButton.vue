<template>
  <button
    class="duration-300 flex gap-2 items-center justify-center px-4 py-3 rounded transition-all"
    :class="[css[mode], { 'border-nuxt': selected, 'opacity-50': loading }]"
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
    mode?: "danger" | "input" | "primary"
    selected?: boolean
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
    input: "bg border",
    primary: "bg-nuxt text-contrasted"
  }))
</script>
