<template>
  <div class="flex flex-col gap-8">
    <BaseForm ref="form" :action="handleSubmit" :validation-schema>
      <TextField :label="t('globals.forms.labels.email')" name="email" placeholder="user@example.com" />
      <PasswordField :label="t('globals.forms.labels.password')" name="password" />
      <BaseButton :loading type="submit">{{ t("globals.actions.submit") }}</BaseButton>
    </BaseForm>

    <p>
      {{ t("noAccount") }}
      <NuxtLink class="text-nuxt" :to="localePath('/users/sign_up')">{{ t("globals.actions.signUp") }}</NuxtLink>
    </p>
  </div>
</template>

<script setup lang="ts">
  import type { RecursiveRecord } from "~~/types"

  const { t } = useI18n()
  const localePath = useLocalePath()
  const router = useLocaleRouter()
  const { signIn } = useUserStore()

  const validationSchema = useZodSchema(({ object, requiredString }) => object({
    email: requiredString(t("validations.email.valid")).email(t("validations.email.valid")),
    password: requiredString().min(6, t("validations.password.tooSmall"))
  }))

  const form = ref<ComponentExposed<GlobalComponents["BaseForm"]>>()
  const loading = ref(false)

  const handleSubmit = async (values: RecursiveRecord) => {
    loading.value = true
    const { status } = await signIn(values)

    if (status === "unauthorized") {
      ["email", "password"].forEach(path => {
        form.value?.setFieldError(path, t("validations.user.invalid_email_or_password"))
      })

      loading.value = false
    } else {
      await router.replace("/")
    }
  }
</script>

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
