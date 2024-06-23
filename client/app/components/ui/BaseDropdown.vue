<template>
  <div v-on-click-outside="disable" class="relative">
    <slot name="trigger" />

    <TransitionSlideY :translate="2">
      <div v-if="show" class="absolute bg border rounded shadow-black shadow-md w-full z-10">
        <slot name="content" />
      </div>
    </TransitionSlideY>
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
