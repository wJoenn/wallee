<template>
  <BaseField class="password-field" :errors :label :name>
    <BaseInput
      :id="name"
      v-model:value="value"
      :disabled
      :is-invalid="errors.length > 0"
      :name
      :placeholder
      :type
    >
      <template #caption>
        <IonIcon :icon @click="type = type === 'text' ? 'password' : 'text'" />
      </template>
    </BaseInput>
  </BaseField>
</template>

<script setup lang="ts">
  const props = defineProps<{
    disabled?: boolean
    label: string
    name: string
  }>()

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const { errors, value } = useField<string>(props.name)
  const { t } = useI18n()

  const type = ref<"password" | "text">("password")

  const icon = computed(() => type.value === "text" ? ioniconsEyeOff : ioniconsEye)
  const placeholder = computed(() => type.value === "text" ? t("placeholder") : t("placeholder").replaceAll(/./g, "●"))
</script>

<style>
  .password-field .base-input ion-icon {
    height: 1.25rem;
    width: 1.25rem;
  }
</style>

<i18n lang="yaml">
  en:
    placeholder: password
</i18n>
