<template>
  <BaseDropdown ref="dropdown" v-on-click-outside="handleClickOutside" class="select-field">
    <template #trigger>
      <BaseField :errors :label :loading :name :optional>
        <BaseInput
          :id="name"
          v-model:value="search"
          :disabled
          :focused
          :is-invalid="errors.length > 0"
          :name
          :placeholder
          type="text"
          @focus="handleFocus"
        >
          <template #caption>
            <Icon
              class="duration-300 transition-transform"
              :class="{ 'rotate-180': focused }"
              name="ion:chevron-down"
              @click="handleToggle"
            />
          </template>
        </BaseInput>
      </BaseField>
    </template>

    <template #content>
      <ul>
        <li
          v-for="option in filteredOptions"
          :key="option.label"
          class="p-4"
          :class="{ 'bg-secondary': selectedOption?.[selectBy] === option[selectBy] }"
          @click="handleSelected(option)"
        >
          {{ option.label }}
        </li>

        <li v-if="filteredOptions.length === 0">{{ t("notFound") }}</li>
      </ul>
    </template>
  </BaseDropdown>
</template>

<script setup lang="ts" generic="T extends { key: number | string, label: string } & RecursiveRecord">
  import type { RecursiveRecord } from "~~/types"

  const props = defineProps<{
    disabled?: boolean
    label: string
    loading?: boolean
    name: string
    options: T[]
    optional?: boolean
    placeholder?: string
    selectBy: keyof T
  }>()

  const watcher = defineModel<unknown>("watcher")

  const { t } = useI18n()

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const { errors, value } = useField(props.name)

  const dropdown = ref<ComponentExposed<GlobalComponents["BaseDropdown"]>>()
  const search = ref<string>()
  const selectedOption = ref<T>()
  const focused = ref(false)

  const filteredOptions = computed(() => {
    if (!search.value) { return props.options }

    return props.options.filter(option => (
      option.label.toLocaleLowerCase().includes(search.value!.toLocaleLowerCase())
    ))
  })

  const handleClickOutside = () => {
    focused.value = false
    search.value = selectedOption.value?.label
  }

  const handleFocus = () => {
    focused.value = true
    search.value = ""
    dropdown.value!.enable()
  }

  const handleSelected = (option: T) => {
    if (option[props.selectBy] === selectedOption.value?.[props.selectBy]) {
      selectedOption.value = undefined
      value.value = undefined
      search.value = undefined
    } else {
      selectedOption.value = option
      value.value = option[props.selectBy]
      search.value = option.label
    }

    focused.value = false
    dropdown.value!.disable()
  }

  const handleToggle = () => {
    if (props.disabled) { return }

    dropdown.value!.toggle()
    focused.value = !focused.value

    if (!focused.value) { search.value = selectedOption.value?.label }
  }

  const setDefaultValue = () => {
    if (value.value) {
      selectedOption.value = props.options.find(option => option[props.selectBy] === value.value)
      search.value = selectedOption.value?.label
    }
  }

  watch(value, () => {
    watcher.value = value.value
    setDefaultValue()
  }, { immediate: true })

  watch(() => props.options, setDefaultValue, { immediate: true })
</script>

<i18n lang="yaml">
  en:
    notFound: No found option
</i18n>
