<template>
  <TransitionSlideY group>
    <p v-for="error in errors" :key="error" class="flex gap-2 items-center text-danger text-sm">
      <Icon name="ion:alert-circle-outline" />
      {{ error }}
    </p>
  </TransitionSlideY>
</template>

<script setup lang="ts">
  defineProps<{
    errors?: string[]
  }>()
</script>
