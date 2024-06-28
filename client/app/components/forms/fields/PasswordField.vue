<template>
  <BaseField class="password-field" :errors :label :name>
    <BaseInput
      :id="name"
      ref="input"
      v-model:value="value"
      :disabled
      :is-invalid="errors.length > 0"
      :name
      :placeholder
      :type
    >
      <template #caption>
        <Icon
          :name="type === 'text' ? 'ion:eye-off' : 'ion:eye'"
          @click="handleToggle"
        />
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

  const input = ref<ComponentExposed<GlobalComponents["BaseInput"]>>()
  const type = ref<"password" | "text">("password")

  const placeholder = computed(() => type.value === "text" ? t("placeholder") : t("placeholder").replaceAll(/./g, "●"))

  const handleToggle = () => {
    type.value = type.value === "text" ? "password" : "text"
    input.value!.focus()
  }
</script>

<i18n lang="yaml">
  en:
    placeholder: password
</i18n>
