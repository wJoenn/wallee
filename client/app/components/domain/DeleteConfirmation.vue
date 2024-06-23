<template>
  <TransitionSlideY>
    <div v-if="show" class="backdrop-blur-sm bg-[#00000080] fixed flex inset-0 items-end" @click.self="$emit('close')">
      <div class="bg flex flex-col gap-4 m-4 p-4 rounded shadow-black shadow-md text-center w-full">
        <div class="bg-white h-1 rounded-full self-center w-8" @click="$emit('close')" />
        <h2>{{ t("sure?") }}</h2>

        <p>
          <slot />
        </p>

        <BaseButton :loading mode="danger" @click="$emit('confirm')">{{ t("globals.actions.confirm") }}</BaseButton>
      </div>
    </div>
  </TransitionSlideY>
</template>

<script setup lang="ts">
  defineEmits<{
    (event: "close" | "confirm"): void
  }>()

  defineProps<{
    loading: boolean
    show: boolean
  }>()

  defineSlots<{
    default: never
  }>()

  const { t } = useI18n()
</script>

<i18n lang="yaml">
  en:
    sure?: Are you sure ?
</i18n>
