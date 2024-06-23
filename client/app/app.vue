<template>
  <NuxtPwaManifest />

  <NuxtPage v-if="isMobile" />

  <div v-else id="desktop" class="flex flex-col gap-4 h-screen items-center justify-center">
    <h1 class="text-3xl">{{ t("notOnDesktop") }}</h1>
    <p class="max-w-3xl">{{ t("mobileOnly") }}</p>
    <p class="max-w-3xl">{{ t("pwa") }}</p>
  </div>
</template>

<script setup lang="ts">
  const { t } = useI18n()

  const isMobile = ref(true)

  onBeforeMount(() => {
    isMobile.value = window.innerWidth < 768
  })
</script>

<i18n lang="yaml">
  en:
    mobileOnly: Our app is designed exclusively for mobile devices to provide the best user experience on the go. Please open this page on your smartphone to use the app.
    notOnDesktop: Not available on Desktop or Tablets
    pwa: You can also download it as a Progressive Web App (PWA) for quick and easy access directly from your smartphone's home screen.
</i18n>
