<template>
  <div class="date-picker">
    <div class="actions">
      <Icon name="ion:play-back" @click="monthIndex--" />
      <div>{{ month.format("MMMM") }}</div>
      <Icon name="ion:play-forward" @click="monthIndex++" />
    </div>

    <ul class="days">
      <li v-for="day in ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']" :key="day">{{ day }}</li>

      <li
        v-for="(day, index) in days"
        :key="index"
        :class="{ disabled: day.disabled, selected: date && date === day.value }"
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

<style scoped>
  .date-picker {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    padding: 1rem;

    .actions {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      justify-items: center;
    }

    .days {
      display: grid;
      gap: 0.5rem;
      grid-template-columns: repeat(7, minmax(0, 1fr));

      li {
        border: 1px solid transparent;
        text-align: center;
        transition: border-color 0.3s ease;

        &.disabled {
          color: gray;
        }

        &.selected {
          border-color: var(--color-primary);
        }
      }
    }
  }
</style>
