<template>
  <div v-on-click-outside="disable" class="base-dropdown">
    <slot name="trigger" />

    <Transition name="slide-y">
      <div v-if="show" class="content">
        <slot name="content" />
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
  defineSlots<{
    content: never
    trigger: never
  }>()

  const show = ref(false)

  const disable = () => { show.value = false }
  const enable = () => { show.value = true }
  const toggle = () => { show.value = !show.value }

  defineExpose({ disable, enable, show, toggle })
</script>

<style scoped>
  .base-dropdown {
    position: relative;

    .content {
      background-color: var(--background-primary);
      border: 1px solid var(--color-secondary);
      border-radius: 0.25rem;
      box-shadow: 0 0 10px black;
      padding: 1rem;
      position: absolute;
      width: 100%;
    }
  }

  .slide-y-enter-from,
  .slide-y-leave-to {
    opacity: 0;
    transform: translateY(20px);
  }

  .slide-y-enter-active,
  .slide-y-leave-active {
    transition: all 0.3s ease;
  }
</style>
