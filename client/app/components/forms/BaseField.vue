<template>
  <div class="flex flex-col gap-4">
    <label v-if="label" class="font-semibold" :for="name">
      <span>{{ label }}</span>
      <span v-if="optional" class="font-normal ml-2 text-secondary">({{ t("optional") }})</span>
    </label>

    <BaseSkeleton v-if="loading" class="h-[45px]" />
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
  input:-webkit-autofill {
    transition: background-color 9999s 0s, color 9999s 0s;
  }
</style>

<i18n lang="yaml">
  en:
    optional: Optional
</i18n>
