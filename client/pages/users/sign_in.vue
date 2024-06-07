<template>
  <div id="users-sign-in">
    <BaseForm :action="handleSubmit" :validation-schema>
      <BaseError v-if="unauthorizedError" :errors="[unauthorizedError]" />
      <TextField :label="t('labels.email')" name="email" placeholder="user@example.com" />
      <PasswordField :label="t('labels.password')" name="password" />
      <BaseButton type="submit">Submit</BaseButton>
    </BaseForm>

    <p>{{ t("noAccount") }} <span class="link" @click="router.push('/users/sign_up')">{{ t("signUp") }}</span></p>
  </div>
</template>

<script setup lang="ts">
  import type { RecursiveRecord } from "~/types"
  import { object as zodObject, string as zodString } from "zod"

  const { t } = useI18n()
  const router = useLocaleRouter()
  const { signIn } = useUserStore()

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
      .refine(password => password.length === 0 || password.length >= 6, t("validations.password.tooSmall"))
  })

  const unauthorizedError = ref<string>()

  const handleSubmit = async (values: RecursiveRecord) => {
    unauthorizedError.value = undefined
    const { status } = await signIn(values)

    if (status === "unauthorized") {
      unauthorizedError.value = t("validations.user.invalid_email_or_password")
    } else {
      await router.replace("/")
    }
  }
</script>

<style scoped>
  #users-sign-in {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    padding: 2rem;

    .link {
      color: var(--color-primary);
    }
  }
</style>

<i18n lang="yaml">
  en:
    labels:
      email: Email
      password: Password
      passwordConfirmation: Password confirmation
    noAccount: Don't have an account yet ?
    signUp: Sign up
    validations:
      email:
        required: An email is required
        taken: The email is already taken
        valid: The email is invalid
      password:
        required: A password is required
        tooSmall: The password needs to be at least 6 characters long
      user:
        invalid_email_or_password: Invalid email or password
</i18n>
