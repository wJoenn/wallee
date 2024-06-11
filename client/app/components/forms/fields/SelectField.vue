<template>
  <BaseDropdown ref="dropdown" v-on-click-outside="handleClickOutside" class="select-field">
    <template #trigger>
      <BaseField :errors :label :name :optional>
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
            <Icon :class="{ focused }" name="ion:chevron-down" @click="handleToggle" />
          </template>
        </BaseInput>
      </BaseField>
    </template>

    <template #content>
      <ul class="options">
        <li
          v-for="option in filteredOptions"
          :key="option.label"
          :class="{ selected: selectedOption?.[selectBy] === option[selectBy] }"
          @mouseenter="handleSelected(option)"
        >
          {{ option.label }}
        </li>

        <li v-if="filteredOptions.length === 0">{{ t("notFound") }}</li>
      </ul>
    </template>
  </BaseDropdown>
</template>

<script setup lang="ts" generic="T extends { key: number, label: string } & RecursiveRecord">
  import type { RecursiveRecord } from "~~/types"

  import BaseDropdown from "~/components/ui/BaseDropdown.vue"

  const props = defineProps<{
    disabled?: boolean
    label: string
    name: string
    options: T[]
    optional?: boolean
    placeholder?: string
    selectBy: keyof T
  }>()

  const { t } = useI18n()

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const { errors, value } = useField(props.name)

  const dropdown = ref<InstanceType<typeof BaseDropdown>>()
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
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
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
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
    dropdown.value!.disable()
  }

  const handleToggle = () => {
    focused.value = !focused.value
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
    dropdown.value!.toggle()
  }
</script>

<style scoped>
  .select-field {
    svg {
      transition: transform 0.3s ease;

      &.focused {
        transform: rotate(180deg);
      }
    }

    .options li {
      padding: 1rem;

      &.selected {
        background-color: var(--color-secondary);
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    notfound: No found option
</i18n>
