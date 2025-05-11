import { useMenuData } from "@/stores/data";

export default function () {
	const menuData = useMenuData();

	window.addEventListener("message", ({ data }) => {
		switch (data.action) {
			case "openGarage":
				menuData.setMenu(true);
				menuData.setVehicles(data.garage.vehicles);
				menuData.setLocation(data.garage.garage, data.garage.garageType);
				break;

			default:
				break;
		}
	});
}
