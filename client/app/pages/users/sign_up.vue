<template>
  <div class="flex flex-col gap-8">
    <BaseForm ref="form" :action="handleSubmit" :validation-schema>
      <TextField :label="t('globals.forms.labels.email')" name="email" placeholder="user@example.com" />
      <PasswordField :label="t('globals.forms.labels.password')" name="password" />
      <PasswordField :label="t('globals.forms.labels.passwordConfirmation')" name="password_confirmation" />
      <BaseButton :loading type="submit">{{ t("globals.actions.submit") }}</BaseButton>
    </BaseForm>

    <p>
      {{ t("haveAccount") }}
      <NuxtLink class="text-nuxt" :to="localePath('/users/sign_in')">{{ t("globals.actions.signIn") }}</NuxtLink>
    </p>
  </div>
</template>

<script setup lang="ts">
  import type { RecursiveRecord } from "~~/types"

  import BaseForm from "~/components/forms/BaseForm.vue"

  const { t } = useI18n()
  const localePath = useLocalePath()
  const router = useLocaleRouter()
  const { signUp } = useUserStore()

  const validationSchema = useZodSchema(({ object, password, requiredString }) => object({
    email: requiredString(t("validations.email.valid")).email(t("validations.email.valid")),
    password: password(),
    password_confirmation: requiredString()
  }).refine(schema => schema.password === schema.password_confirmation, {
    message: t("validations.password_confirmation.confirmation"),
    path: ["password_confirmation"]
  }))

  const form = ref<InstanceType<typeof BaseForm>>()
  const loading = ref(false)

  const handleSubmit = async (values: RecursiveRecord) => {
    loading.value = true
    const { data, status } = await signUp(values)

    if (status === "unprocessable_entity") {
      Object.entries(data.errors).forEach(([path, errors]) => {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
        errors.forEach(error => { form.value?.setFieldError(path, t(`validations.${path}.${error}`)) })
      })

      loading.value = false
    } else {
      await router.replace("/")
    }
  }
</script>

<i18n lang="yaml">
  en:
    haveAccount: Already have an account ?
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
