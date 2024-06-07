<template>
  <div id="users-sign-in">
    <BaseForm ref="form" :action="handleSubmit" :validation-schema>
      <TextField :label="t('globals.forms.labels.email')" name="email" placeholder="user@example.com" />
      <PasswordField :label="t('globals.forms.labels.password')" name="password" />
      <BaseButton type="submit">{{ t("globals.actions.submit") }}</BaseButton>
    </BaseForm>

    <p>
      {{ t("noAccount") }}
      <NuxtLink class="link" :to="localePath('/users/sign_up')">{{ t("globals.actions.signUp") }}</NuxtLink>
    </p>
  </div>
</template>

<script setup lang="ts">
  import type { RecursiveRecord } from "~/types"
  import { object as zodObject, string as zodString } from "zod"

  import BaseForm from "~/components/forms/BaseForm.vue"

  const { t } = useI18n()
  const localePath = useLocalePath()
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

  const form = ref<InstanceType<typeof BaseForm>>()

  const handleSubmit = async (values: RecursiveRecord) => {
    const { status } = await signIn(values)

    if (status === "unauthorized") {
      ["email", "password"].forEach(path => {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
        form.value?.setFieldError(path, t("validations.user.invalid_email_or_password"))
      })
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
    noAccount: Don't have an account yet ?
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
