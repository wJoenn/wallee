<template>
  <NuxtPwaManifest />

  <NuxtPage v-if="isMobile" />

  <div v-else id="desktop">
    <h1>{{ t("notOnDesktop") }}</h1>
    <p>{{ t("mobileOnly") }}</p>
    <p>{{ t("pwa") }}</p>
  </div>
</template>

<script setup lang="ts">
  const { t } = useI18n()

  const isMobile = ref(true)

  onBeforeMount(() => {
    isMobile.value = window.innerWidth < 768
  })
</script>

<style>
  body {
    &:has(.base-modal) {
      overflow: hidden;
    }

    #desktop {
      align-items: center;
      display: flex;
      flex-direction: column;
      height: 100vh;
      gap: 1rem;
      justify-content: center;

      p {
        width: 700px;
      }
    }
  }
</style>

<i18n lang="yaml">
  en:
    mobileOnly: Our app is designed exclusively for mobile devices to provide the best user experience on the go. Please open this page on your smartphone to use the app.
    notOnDesktop: Not available on Desktop or Tablets
    pwa: You can also download it as a Progressive Web App (PWA) for quick and easy access directly from your smartphone's home screen.
</i18n>
