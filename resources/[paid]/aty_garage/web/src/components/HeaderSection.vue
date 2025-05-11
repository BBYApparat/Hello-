<script setup>
  import { useMenuData } from "@/stores/data.js"
  import { storeToRefs } from "pinia"

  const menuData = useMenuData()
  const { location, vehicles } = storeToRefs(menuData)

  const getVehiclesInGarage = () => {
    return vehicles.value.filter((vehicle) => vehicle.state == 1)
  }

  const getVehiclesOutsideGarage = () => {
    return vehicles.value.filter((vehicle) => vehicle.state != 1)
  }
</script>

<template>
  <div class="left-section">
    <div class="garageTopBox">
      <div class="garageTitleBox">
        <div class="garageTitle"><p>GARAGE</p></div>
        <div class="garageFamiliaTitle"><p>{{ (location)?.split(" ")[0] || "Not Available" }}</p></div>
      </div>
      <div class="garageCarsBox">
        <div class="carsBox"><img src="@/assets/img/wheel.png"></div>
        <div class="carsTitleBox">
          <div class="carsTitle"><p>Cars total</p></div>
          <div class="carsNumberTitle"><p>{{ vehicles?.length || 0 }}</p></div>
        </div>
      </div>
      <div class="garageCarsBox">
        <div class="carsBox"><img src="@/assets/img/in-garage.png"></div>
        <div class="carsTitleBox">
          <div class="carsTitle"><p>Cars in Garage</p></div>
          <div class="carsNumberTitle"><p>{{ getVehiclesInGarage(vehicle)?.length || 0 }}</p></div>
        </div>
      </div>
      <div class="garageCarsBox">
        <div class="carsBox"><img src="@/assets/img/garage.png"></div>
        <div class="carsTitleBox">
          <div class="carsTitle"><p>Cars outside</p></div>
          <div class="carsNumberTitle"><p>{{ getVehiclesOutsideGarage(vehicle)?.length || 0 }}</p></div>
        </div>
      </div>
    </div>
  </div>
</template>