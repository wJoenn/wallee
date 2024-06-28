import type { ComputedRef } from "vue"

import { literal, number, object, string, type ZodSchema } from "zod"
import dayjs from "~~/libs/dayjs.ts"

const datestring = () => {
  const { $i18n: { t } } = useNuxtApp()

  return string().optional().refine(value => (
    !value || dayjs(value, "YYYY-MM-DD", true).isValid()
  ), {
    message: t("globals.forms.validations.dateFormat")
  })
}

const optional = (schema: ZodSchema, condition = true) => condition ? schema.optional().or(literal(null)) : schema

const price = () => {
  const { $i18n: { t } } = useNuxtApp()

  return number({
    invalid_type_error: t("globals.forms.validations.required"),
    required_error: t("globals.forms.validations.required")
  }).positive(t("globals.forms.validations.otherThan0"))
    .multipleOf(0.01, t("globals.forms.validations.maxDecimals"))
}

const requiredNumber = (message?: string) => {
  const { $i18n: { t } } = useNuxtApp()

  const computedMessage = message ?? t("globals.forms.validations.required")

  return number({
    invalid_type_error: computedMessage,
    required_error: computedMessage
  })
}

const requiredString = (message?: string) => {
  const { $i18n: { t } } = useNuxtApp()

  const computedMessage = message ?? t("globals.forms.validations.required")

  return string({
    invalid_type_error: computedMessage,
    required_error: computedMessage
  }).min(1, computedMessage)
}

const zodSchema = {
  datestring,
  number,
  object,
  optional,
  price,
  requiredNumber,
  requiredString,
  string
}

export const useZodSchema = <T extends ComputedRef<ZodSchema> | ZodSchema>(call: (zod: typeof zodSchema) => T) => (
  call(zodSchema)
)
