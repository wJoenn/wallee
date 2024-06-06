<template>
  <IonModal :is-open :presenting-element>
    <div class="base-modal">
      <slot />
    </div>
  </IonModal>
</template>

<script setup lang="ts">
  defineProps<{
    isOpen: boolean
    presentingElement?: HTMLElement
  }>()

  defineSlots<{
    default: never
  }>()
</script>

<style scoped>
  .base-modal {
    background: var(--background-primary);
    color: var(--text-primary);
    height: 100%;
    padding: 2rem;
  }
</style>
