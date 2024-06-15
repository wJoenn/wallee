<template>
  <div class="base-field">
    <label v-if="label" :for="name">
      <span>{{ label }}</span>
      <span v-if="optional" class="optional">({{ t("optional") }})</span>
    </label>

    <BaseSkeleton v-if="loading" container style="height: 45px;" />
    <slot v-else />

    <BaseError :errors />
  </div>
</template>

<script setup lang="ts">
  defineProps<{
    errors?: string[]
    label?: string
    loading?: boolean
    name?: string
    optional?: boolean
  }>()

  defineSlots<{
    default: never
  }>()

  const { t } = useI18n()
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

      .optional {
        font-weight: 400;
        margin-left: 0.5rem;
        opacity: 0.5;
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    optional: Optional
</i18n>
