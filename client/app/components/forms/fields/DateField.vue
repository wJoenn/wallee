<template>
  <BaseDropdown ref="dropdown" v-on-click-outside="() => { focused = false }">
    <template #trigger>
      <BaseField :errors :label :name :optional>
        <BaseInput
          :id="name"
          v-model:value="value"
          v-maska="'####-##-##'"
          :disabled
          :focused
          inputmode="numeric"
          :is-invalid="errors.length > 0"
          :name
          :placeholder="dayjs().format('YYYY-MM-DD')"
          type="text"
          @focus="handleFocus"
        >
          <template #caption>
            <Icon name="ion:calendar" @click="handleToggle" />
          </template>
        </BaseInput>
      </BaseField>
    </template>

    <template #content>
      <DatePicker v-model:date="value" @selected="handleSelected" />
    </template>
  </BaseDropdown>
</template>

<script setup lang="ts">
  import type { DateString } from "~~/types"

  import dayjs from "dayjs"

  const props = defineProps<{
    disabled?: boolean
    label: string
    name: string
    optional?: boolean
  }>()

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const { errors, value } = useField<DateString>(props.name)

  const dropdown = ref<ComponentExposed<GlobalComponents["BaseDropdown"]>>()
  const focused = ref(false)

  const handleFocus = () => {
    focused.value = true
    dropdown.value!.enable()
  }

  const handleSelected = () => {
    focused.value = false
    dropdown.value!.disable()
  }

  const handleToggle = () => {
    if (props.disabled) { return }

    focused.value = !focused.value
    dropdown.value!.toggle()
  }
</script>
