<template>
  <TransitionSlideY>
    <div v-if="show" class="delete-confirmation" @click.self="$emit('close')">
      <div>
        <div @click="$emit('close')" />
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

<style scoped>
  .delete-confirmation {
    align-items: flex-end;
    backdrop-filter: blur(2px);
    background-color: #00000080;
    display: flex;
    inset: 0;
    position: fixed;

    > div {
      background-color: var(--background-primary);
      border-radius: 0.25rem;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.8);
      display: flex;
      flex-direction: column;
      gap: 1rem;
      margin: 1rem;
      padding: 1rem;
      text-align: center;
      width: 100%;

      > div {
        align-self: center;
        background-color: #ffffff;
        height: 0.25rem;
        width: 2rem;
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    sure?: Are you sure ?
</i18n>
