<template>
  <IonPage>
    <div id="users-sign-up">
      <BaseForm ref="form" :action="handleSubmit" :validation-schema>
        <TextField :label="t('labels.email')" name="email" placeholder="user@example.com" />
        <PasswordField :label="t('labels.password')" name="password" />
        <PasswordField :label="t('labels.passwordConfirmation')" name="password_confirmation" />
        <BaseButton type="submit">Submit</BaseButton>
      </BaseForm>
    </div>
  </IonPage>
</template>

<script setup lang="ts">
  import type { RecursiveRecord } from "~/types"
  import { object as zodObject, string as zodString } from "zod"
  import { useIonRouter } from "@ionic/vue"

  import BaseForm from "~/components/forms/BaseForm.vue"

  const { t } = useI18n()
  const router = useIonRouter()
  const { signUp } = useUserStore()

  const validationSchema = zodObject({
    email: zodString({
      invalid_type_error: t("validations.email.required"),
      required_error: t("validations.email.required")
    }).min(1, t("validations.email.required"))
      .email(t("validations.email.valid")),
    password: zodString({
      invalid_type_error: t("validations.password.required"),
      required_error: t("validations.password.required")
    }).min(1, t("validations.password.required"))
      .refine(password => password.length === 0 || password.length >= 6, t("validations.password.tooSmall")),
    password_confirmation: zodString({
      invalid_type_error: t("validations.password.required"),
      required_error: t("validations.password.required")
    }).min(1, t("validations.password.required"))
  }).refine(({ password, password_confirmation }) => password === password_confirmation, {
    message: t("validations.password_confirmation.confirmation"),
    path: ["password_confirmation"]
  })

  const form = ref<InstanceType<typeof BaseForm>>()

  const handleSubmit = async (values: RecursiveRecord) => {
    const { data, status } = await signUp(values)
    if (status === "error") {
      Object.entries(data.errors).forEach(([path, errors]) => {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
        errors.forEach(error => { form.value?.setFieldError(path, t(`validations.${path}.${error}`)) })
      })
    } else {
      router.push("/")
    }
  }
</script>

<style scoped>
  #users-sign-up {
    padding: 2rem;
  }
</style>

<i18n lang="yaml">
  en:
    labels:
      email: Email
      password: Password
      passwordConfirmation: Password confirmation
    validations:
      email:
        required: An email is required
        taken: The email is already taken
        valid: The email is invalid
      password:
        required: A password is required
        tooSmall: The password needs to be at least 6 characters long
      password_confirmation:
        confirmation: The password confirmation needs to match the password
</i18n>
