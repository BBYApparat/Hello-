<script setup>
	import { useMenuData } from "@/stores/data.js";
	import { storeToRefs } from "pinia";

	const menuData = useMenuData();
	const { vehicles, selectedVehicle, garageType } = storeToRefs(menuData);

	const selectVehicle = (vehicle) => {
		menuData.setSelectedVehicle(vehicle);
	};
</script>

<template>
	<div class="garageRightBox">
		<template
			v-for="(vehicle, i) in vehicles"
			:key="i">
			<div
				:class="[
					'ingarageBox',
					{ deactive: vehicle.state != 1 && garageType != 'impound' },
				]">
				<div class="ingarageTitleBox">
					<div class="car-image">
						<img
							:src="`car${
								vehicle.state != 1 && garageType != 'impound'
									? ''
									: '-available'
							}.png`"
							class="car" />
					</div>

					<div class="ingarageMenu">
						<div class="ingarageMenuBox">
							<div class="ingarageMenuImg">
								<img
									:src="`Frame${
										vehicle.state != 1 &&
										garageType != 'impound'
											? '1'
											: ''
									}.png`" />
							</div>
						</div>
						<div class="ingarageTitle">
							<p>
								{{
									vehicle.state != 1
										? garageType != "impound"
											? "Away"
											: "Impounded"
										: "In Garage"
								}}
							</p>
						</div>
					</div>

					<div class="inGarageTitleMenu">
						<div class="mitsubishiTitle">
							<p>
								{{ vehicle.brandName }} {{ vehicle.modelName }}
							</p>
						</div>
						<div class="sharedTitle">
							<p>
								{{
									vehicle.state != 1
										? garageType != "impound"
											? "Your vehicle is not here but you can order a tow truck."
											: "You vehicls has been impounded. You have to pay to take it."
										: "Your vehicle is waiting for you boss."
								}}
							</p>
						</div>
					</div>

					<div
						class="inSelectBtn"
						v-if="vehicle.state != 1 && garageType != 'impound'">
						<p>
							{{
								selectedVehicle.plate === vehicle.plate
									? "Selected"
									: "Select"
							}}
						</p>
					</div>
					<div
						class="inSelectBtn"
						v-else
						@click="selectVehicle(vehicle)">
						<p>
							{{
								selectedVehicle.plate === vehicle.plate
									? "Selected"
									: "Select"
							}}
						</p>
					</div>
				</div>

				<div class="inGarageLine">
					<img
						:src="`${
							vehicle.state != 1 && garageType != 'impound'
								? 'redline'
								: 'greenline'
						}.png`" />
					<img
						:src="`${
							vehicle.state != 1 && garageType != 'impound'
								? 'redline'
								: 'greenline'
						}.png`" />
				</div>
			</div>
		</template>
	</div>
</template>
