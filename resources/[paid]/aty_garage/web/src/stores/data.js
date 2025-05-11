import { fetchNui } from '@/utils';
import { defineStore } from 'pinia'

export const useMenuData = defineStore('menuData', {
    state: () => {
      return { 
        open: false,
        location: "",
        selectedVehicle: {},
        vehicles: [],
        garageType: ""
      }
    },

    actions: {
      setMenu(open) {
        this.open = open

        if (!open) {
          setTimeout(() => {
            this.location = ""
            this.selectedVehicle = {}
            this.vehicles = []
          }, 250);
        }
      },

      setVehicles(vehicles) {
        this.vehicles = vehicles
      },

      setSelectedVehicle(vehicle) {
        this.selectedVehicle = vehicle
      },

      setLocation(location, type) {
        this.location = location
        this.garageType = type
      },

      spawnVehicle() {
        fetchNui('spawnVehicle', ({vehicle: this.selectedVehicle, garage: this.garageType}))
        this.setMenu(false)
      }
    }
})