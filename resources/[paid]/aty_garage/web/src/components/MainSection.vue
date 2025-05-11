<script setup>
import LeftSection from './main/LeftSection.vue'
import RightSection from './main/RightSection.vue'

import { useMenuData } from "@/stores/data.js"
import { storeToRefs } from "pinia"

const menuData = useMenuData()
const { selectedVehicle } = storeToRefs(menuData)
</script>

<template>
  <div class="left-section">
    <TransitionGroup name="fade" tag="div" class="garageBottomBox">
      <LeftSection v-if="selectedVehicle?.mods || selectedVehicle?.vehicle"/>
      <RightSection />
    </TransitionGroup>
  </div>
</template>

<style scoped>
.fade-move, /* apply transition to moving elements */
.fade-enter-active,
.fade-leave-active {
  transition: all 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateX(30px);
}

/* ensure leaving items are taken out of layout flow so that moving
   animations can be calculated correctly. */
.fade-leave-active {
  position: absolute;
}
</style>