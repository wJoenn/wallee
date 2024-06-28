<template>
  <div class="flex flex-col gap-4 p-4">
    <div class="grid grid-cols-3 justify-items-center">
      <Icon name="ion:play-back" @click="monthIndex--" />
      <div>{{ month.format("MMMM") }}</div>
      <Icon name="ion:play-forward" @click="monthIndex++" />
    </div>

    <ul class="gap-2 grid grid-cols-7">
      <li v-for="day in ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']" :key="day" class="text-center">{{ day }}</li>

      <li
        v-for="(day, index) in days"
        :key="index"
        class="border default:border-transparent duration-300 rounded text-center transition-colors"
        :class="{
          'bg-secondary': day.value && dayjs(day.value).isSame(dayjs(), 'date'),
          'border-nuxt': date && date === day.value,
          'text-secondary': day.disabled
        }"
        @click="set(day)"
      >
        {{ day.label }}
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
  import type { DateString } from "~~/types"

  import dayjs from "~~/libs/dayjs.ts"

  type DayOption = {
    disabled?: boolean
    label: number
    value?: DateString
  }

  const emit = defineEmits<{
    (event: "selected"): void
  }>()

  const date = defineModel<DateString>("date")

  const monthIndex = ref(dayjs().month())

  const month = computed(() => dayjs().month(monthIndex.value))

  const days = computed(() => {
    const currentMonthDays = times(month.value.daysInMonth(), (_, index) => ({
      label: index + 1,
      value: dateStringAt(index + 1)
    }))

    const firstDayOfCurrentMonth = month.value.startOf("month").day() || 7
    const lastDayOfPreviousMonth = dayjs().month(monthIndex.value - 1).endOf("month").date()
    const pastMonthDays = times(firstDayOfCurrentMonth - 1, (_, index) => ({
      disabled: true,
      label: lastDayOfPreviousMonth - (firstDayOfCurrentMonth - 1) + (index + 1)
    }))

    const visibleDays = [...pastMonthDays, ...currentMonthDays]

    let nextMonthDays: typeof visibleDays = []
    const nextMonthVisibleDays = visibleDays.length % 7
    if (nextMonthVisibleDays !== 0) {
      nextMonthDays = times(7 - nextMonthVisibleDays, (_, index) => ({
        disabled: true,
        label: index + 1
      }))
    }

    return [...visibleDays, ...nextMonthDays]
  })

  const set = (day: DayOption) => {
    if (!day.disabled) {
      date.value = day.value
      emit("selected")
    }
  }

  const times = (n: number, call: (_: null, index: number) => DayOption) => (
    new Array(n).fill(null).map(call)
  )

  const dateStringAt = (day: number): DateString => month.value.date(day).format("YYYY-MM-DD")

  watch(date, () => {
    if (date.value && dayjs(date.value, "YYYY-MM-DD", true).isValid()) {
      const currentYear = dayjs().year()
      const newYear = dayjs(date.value).year()
      const yearDiff = newYear - currentYear

      monthIndex.value = dayjs(date.value).month() + (yearDiff * 12)
    }
  })
</script>
