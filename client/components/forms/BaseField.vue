<template>
  <div class="base-field">
    <label v-if="label" :for="name">{{ label }}</label>
    <slot />

    <TransitionGroupSlideY :from="1">
      <p v-for="error in errors" :key="error" class="error">
        <IonIcon :icon="ioniconsAlertCircleOutline" />
        {{ error }}
      </p>
    </TransitionGroupSlideY>
  </div>
</template>

<script setup lang="ts">
  defineProps<{
    errors?: string[]
    label?: string
    name?: string
  }>()

  defineSlots<{
    default: never
  }>()
</script>

<style>
  .base-field {
    display: flex;
    flex-direction: column;
    gap: 1rem;

    input:-webkit-autofill {
      transition: background-color 9999s 0s, color 9999s 0s;
    }

    label {
      font-weight: 600;
    }

    .error {
      align-items: center;
      color: var(--text-negative);
      display: flex;
      font-size: 0.8rem;
      gap: 0.5rem;
    }
  }
</style>
