import { literal, number, object, string, type ZodSchema } from "zod"
import dayjs from "~~/libs/dayjs.ts"

const optional = (schema: ZodSchema) => schema.optional().or(literal(null))

const password = () => {
  const { t } = useI18n()

  return requiredString().refine(value => value.length === 0 || value.length >= 6, t("validations.password.tooSmall"))
}

const price = () => {
  const { t } = useI18n()

  return number({
    invalid_type_error: t("globals.forms.validations.required"),
    required_error: t("globals.forms.validations.required")
  }).positive(t("validations.value.other_than_0"))
    .multipleOf(0.01, t("globals.forms.validations.maxDecimals"))
}

const requiredNumber = (message?: string) => {
  const { t } = useI18n()

  const computedMessage = message ?? t("globals.forms.validations.required")

  return number({
    invalid_type_error: computedMessage,
    required_error: computedMessage
  })
}

const requiredString = (message?: string) => {
  const { t } = useI18n()

  const computedMessage = message ?? t("globals.forms.validations.required")

  return string({
    invalid_type_error: computedMessage,
    required_error: computedMessage
  }).min(1, computedMessage)
}

const datestring = () => {
  const { t } = useI18n()

  return string().optional().refine(value => (
    !value || dayjs(value, "YYYY-MM-DD", true).isValid()
  ), {
    message: t("globals.forms.validations.dateFormat")
  })
}

const zodSchema = {
  datestring,
  number,
  object,
  optional,
  password,
  price,
  requiredNumber,
  requiredString,
  string
}

export const useZodSchema = <T extends ZodSchema>(call: (schema: typeof zodSchema) => T) => call(zodSchema)
