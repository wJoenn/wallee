<template>
  <BaseDropdown ref="dropdown" v-on-click-outside="() => { focused = false }">
    <template #trigger>
      <BaseField :errors :label :name :optional>
        <BaseInput
          :id="name"
          v-model:value="value"
          :disabled
          :focused
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
  import type { Timestamp } from "~~/types"

  import dayjs from "dayjs"

  import BaseDropdown from "~/components/ui/BaseDropdown.vue"

  const props = defineProps<{
    disabled?: boolean
    label: string
    name: string
    optional?: boolean
  }>()

  // eslint-disable-next-line vue/no-setup-props-reactivity-loss
  const { errors, value } = useField<Timestamp>(props.name)

  const dropdown = ref<InstanceType<typeof BaseDropdown>>()
  const focused = ref(false)

  const handleFocus = () => {
    focused.value = true
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
    dropdown.value!.enable()
  }

  const handleSelected = () => {
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
