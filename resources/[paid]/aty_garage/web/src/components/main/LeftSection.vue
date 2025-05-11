<script setup>
	import { useMenuData } from "@/stores/data.js";
	import { storeToRefs } from "pinia";

	const menuData = useMenuData();
	const { selectedVehicle, location } = storeToRefs(menuData);

	const convertValue = (value, oldMin, oldMax, newMin, newMax) => {
		const oldRange = oldMax - oldMin;
		const newRange = newMax - newMin;
		const newValue = ((value - oldMin) * newRange) / oldRange + newMin;
		return newValue;
	};

	const getMileAgeHtml = () => {
		const mileAge = selectedVehicle.value?.mileage || 0;
		const mileAgeStr = mileAge.toString().padStart(7, "0");
		return mileAgeStr
			.split("")
			.map((num) => {
				return `<div class="milleageBoxTwo"><p>${num}</p></div>`;
			})
			.join("");
	};
</script>

<template>
	<div class="garageLeftBox">
		<div class="carNameBox">
			<div class="carNameTitleBox">
				<div class="carNameTitle"><p>Car name</p></div>
				<div class="carNamemitsubishiTitle">
					<p>{{ selectedVehicle.brandName || "" }}</p>
					<div class="carNameEvolutionTitle">
						<p>{{ selectedVehicle.modelName || "" }}</p>
					</div>
				</div>
			</div>
			<svg
				width="53"
				height="35"
				viewBox="0 0 53 35"
				fill="none"
				xmlns="http://www.w3.org/2000/svg">
				<path
					fill-rule="evenodd"
					clip-rule="evenodd"
					d="M15.8347 0.217137C14.2059 0.657646 13.6778 1.03628 10.7941 3.83146C8.24985 6.29745 8.16834 6.36558 8.16617 6.02889C8.16347 5.61749 7.86468 4.91948 7.58381 4.66813C6.80323 3.96991 4.6331 4.00466 3.14267 4.73929C1.73427 5.43344 1.65722 6.7942 2.95584 8.03914C3.51707 8.5772 3.95857 8.85755 4.65578 9.1185L5.13043 9.29608L3.61162 10.8275C1.9849 12.4679 1.3925 13.292 0.771312 14.7792C0.0480042 16.5109 0.0518361 16.4775 0.0123773 21.5182C-0.0178641 25.373 0.00150284 26.1844 0.135932 26.7131C0.34379 27.5304 0.742521 28.3692 1.21354 28.9797L1.59197 29.4702L1.64469 31.1917C1.69264 32.7563 1.72071 32.9593 1.9527 33.4186C2.25262 34.0123 2.74384 34.4749 3.3991 34.7803C3.83605 34.9839 4.04795 35 6.30425 35C8.56055 35 8.77244 34.9839 9.20939 34.7803C10.284 34.2794 10.8555 33.4346 10.9417 32.2196L10.9926 31.5047H26.4997H42.0068L42.0577 32.2196C42.1439 33.4346 42.7154 34.2794 43.79 34.7803C44.227 34.9839 44.4389 35 46.6952 35C48.9515 35 49.1634 34.9839 49.6003 34.7803C50.2556 34.4749 50.7468 34.0123 51.0467 33.4186C51.2787 32.9593 51.3068 32.7563 51.3547 31.1917L51.4074 29.4702L51.7859 28.9797C52.2608 28.3641 52.6341 27.5748 52.853 26.7229C53.0006 26.1483 53.0181 25.4688 52.987 21.5061C52.9476 16.4789 52.9512 16.5105 52.2281 14.7792C51.6069 13.292 51.0145 12.4679 49.3878 10.8275L47.869 9.29608L48.3436 9.1185C49.0409 8.85755 49.4824 8.5772 50.0436 8.03914C50.9818 7.13965 51.2137 6.21043 50.6964 5.42311C49.8954 4.20363 46.4807 3.71543 45.4156 4.66813C45.1347 4.91948 44.8359 5.61749 44.8333 6.02889C44.8311 6.36558 44.7496 6.29745 42.2054 3.83146C39.3023 1.0175 38.7889 0.652012 37.1216 0.212025C36.3159 -0.000508386 36.1022 -0.00478674 26.4543 0.00147344C16.9348 0.00752496 16.5835 0.0147243 15.8347 0.217137ZM37.4119 3.38604C38.098 3.74893 38.6046 4.19799 41.2964 6.82915L44.3919 9.85491L35.4458 9.88162C30.5254 9.89622 22.4753 9.89622 17.5566 9.88162L8.61357 9.85491L11.712 6.82915C13.4162 5.16498 15.0287 3.6736 15.2955 3.5149C16.3243 2.90307 15.8391 2.92728 26.6678 2.94887L36.6229 2.9687L37.4119 3.38604ZM6.14579 14.6012C8.13893 15.292 11.1467 17.3904 11.6946 18.4723C12.0258 19.1264 11.9579 19.4914 11.4464 19.8082C10.7005 20.27 8.01879 20.5238 5.57928 20.3635C4.52694 20.2944 4.19087 20.2311 3.78313 20.0254C2.06548 19.1588 1.67648 16.8036 3.00027 15.2847C3.73684 14.4396 4.93106 14.1801 6.14579 14.6012ZM49.1297 14.6388C50.58 15.3192 51.2146 17.2106 50.492 18.6985C50.3336 19.0249 50.0137 19.456 49.7812 19.6564C49.0509 20.2862 48.6171 20.3689 46.0304 20.3718C43.8793 20.3742 43.0549 20.3044 42.0662 20.0363C41.5334 19.8918 41.1026 19.4917 41.1026 19.1417C41.1026 18.2036 42.7725 16.6676 45.2169 15.3573C47.0941 14.3511 48.1162 14.1634 49.1297 14.6388ZM38.617 18.5478C38.617 19.0303 38.4113 20.0412 38.1884 20.6537C37.7778 21.7828 37.0879 22.64 36.2867 23.0166L35.7689 23.2601H26.4997H17.2305L16.7127 23.0166C15.9115 22.64 15.2216 21.7828 14.811 20.6537C14.5881 20.0412 14.3824 19.0303 14.3824 18.5478V18.254H26.4997H38.617V18.5478ZM11.5213 26.314L13.3465 28.4268L10.0066 28.4599C6.77092 28.492 6.64519 28.4858 5.97667 28.2582C4.47112 27.7458 3.55932 26.7839 3.57444 25.7242C3.5789 25.4203 3.67656 24.97 3.79815 24.693L4.01419 24.2012H6.85512H9.69605L11.5213 26.314ZM49.2013 24.693C49.3231 24.9706 49.4192 25.4138 49.4217 25.7103C49.4313 26.8291 48.658 27.6609 47.0577 28.2533C46.4575 28.4754 46.3207 28.4823 43.0475 28.4551L39.6587 28.4268L41.4833 26.314L43.3079 24.2012H46.1466H48.9852L49.2013 24.693ZM37.5582 25.9008C37.4528 26.8427 36.7559 27.7743 35.8361 28.2026C35.3554 28.4265 35.3411 28.4268 26.4997 28.4268C17.6583 28.4268 17.6441 28.4265 17.1633 28.2026C16.2435 27.7743 15.5466 26.8427 15.4412 25.9008L15.3912 25.4532H26.4997H37.6083L37.5582 25.9008Z"
					fill="url(#paint0_radial_1_426)"
					fill-opacity="0.15" />
				<defs>
					<radialGradient
						id="paint0_radial_1_426"
						cx="0"
						cy="0"
						r="1"
						gradientUnits="userSpaceOnUse"
						gradientTransform="translate(26.5 17.5) rotate(45.0934) scale(37.5379 43.8838)">
						<stop stop-color="white" />
						<stop offset="1" stop-color="white" stop-opacity="0" />
					</radialGradient>
				</defs>
			</svg>
		</div>
		<div class="vehicleDamageBox">
			<div class="vehicleDamageMenu">
				<div class="vehicleDamageTitle">
					<p>Vehicle Damage Level</p>
				</div>
				<div class="damageBoxes">
					<template v-for="i in 10" :key="i">
						<div
							:class="
								(selectedVehicle?.mods
									? selectedVehicle?.mods.engineHealth / 100
									: selectedVehicle?.vehicle.engineHealth / 100) < i
									? `damageBoxOne`
									: 'damageBox'
							"></div>
					</template>
				</div>
			</div>
			<div class="vehicleDamageMenuOne">
				<p>
					{{
						selectedVehicle?.mods
							? Math.floor(selectedVehicle?.mods.engineHealth / 10)
							: Math.floor(selectedVehicle?.vehicle.engineHealth / 10)
					}}/100%
				</p>
			</div>
		</div>
		<div class="vehiclelitersBox">
			<div class="vehiclelitersTitleBox">
				<div class="vehiclelitersTitle">
					<p>Gasoline<br />Level</p>
				</div>
				<div class="litersTitle">
					{{
						selectedVehicle?.mods
							? Math.floor(selectedVehicle?.mods.fuelLevel)
							: Math.floor(selectedVehicle?.vehicle.fuelLevel)
					}}
					Liters
				</div>
			</div>
			<div class="fuel-bar-wrapper">
				<svg class="first">
					<circle
						r="calc(2.5rem + 5px)"
						cx="calc(2.5rem + 10px)"
						cy="calc(2.5rem + 10px)"
						:style="
							'stroke-dashoffset: ' +
							convertValue(
								selectedVehicle?.mods
									? selectedVehicle?.mods.fuelLevel
									: selectedVehicle?.vehicle.fuelLevel,
								0,
								100,
								8.85,
								0
							) +
							'rem'
						"></circle>
				</svg>

				<svg class="second">
					<circle
						r="calc(3.5rem + 2.5px)"
						cx="calc(3.5rem + 5px)"
						cy="calc(3.5rem + 5px)"></circle>
				</svg>

				<div class="icon"><img src="@/assets/img/fuel.png" /></div>
			</div>
		</div>
		<div class="milleageBox">
			<div class="milleageTitle"><p>Milleage</p></div>
			<div class="milleageBoxOne" v-html="getMileAgeHtml()"></div>
		</div>
		<div class="carNameBox">
			<div class="carNameTitleBox">
				<div class="carNameTitle"><p>Car position</p></div>
				<div class="carNamemitsubishiTitle">
					<p class="location">
						{{ location?.split(" ")[0] || "Not Available" }}
					</p>
					<div class="carNameEvolutionTitle">
						<p>{{ location?.split(" ")[1] || "" }}</p>
					</div>
				</div>
			</div>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width="3.0208vw"
				height="2.7083vw"
				viewBox="0 0 58 52"
				fill="none">
				<path
					fill-rule="evenodd"
					clip-rule="evenodd"
					d="M27.472 0.102814C24.7048 0.455302 21.7312 2.0653 19.995 4.15103C17.2389 7.46201 16.5064 11.1657 17.5751 16.3864C18.1724 19.304 19.7913 23.3684 21.7837 26.9521C23.6609 30.3286 27.2251 35.4836 28.0836 36.0637C28.6055 36.4164 29.3962 36.4169 29.9171 36.065C30.7834 35.4795 34.3263 30.3562 36.2188 26.9521C38.7721 22.3595 40.3416 17.9587 40.7921 14.1284C40.9749 12.5736 40.8737 10.2612 40.5722 9.10483C39.658 5.59733 37.4475 2.85274 34.2686 1.27808C32.0314 0.169722 29.8745 -0.203213 27.472 0.102814ZM30.1952 7.07385C31.4683 7.39726 32.4555 8.09462 33.18 9.18253C34.1552 10.6471 34.2941 12.5248 33.545 14.1158C32.2704 16.8231 28.9384 17.8229 26.3816 16.2654C23.9568 14.7883 23.2445 11.5524 24.8225 9.18253C26.0194 7.38522 28.1415 6.55233 30.1952 7.07385ZM8.32831 21.3623C8.07842 21.5038 7.78379 21.7959 7.67142 22.0135C7.47794 22.3883 3.06096 38.4513 3.06096 38.7802C3.06096 38.9118 4.8855 38.9365 14.6258 38.9365H26.1905L25.4289 38.1129C22.3567 34.7912 17.9187 27.4478 16.0245 22.5517L15.4647 21.105L12.1231 21.1053C8.86331 21.1057 8.77031 21.1119 8.32831 21.3623ZM41.978 22.5517C40.0829 27.4501 35.6459 34.7911 32.5708 38.116L31.8062 38.9427L33.4893 38.9111L35.1723 38.8797L41.2608 30.4736C44.6094 25.8502 47.506 21.8503 47.6975 21.5847L48.0457 21.1019L45.2918 21.1034L42.5378 21.105L41.978 22.5517ZM40.3348 37.416C34.6512 45.2677 29.9746 51.7612 29.9421 51.846C29.8927 51.9751 32.0424 52 43.2379 52H56.5927L57.0897 51.7444C57.6647 51.4487 58 50.9068 58 50.273C58 49.9327 50.829 23.3014 50.7035 23.1755C50.6842 23.1561 46.0182 29.5642 40.3348 37.416ZM1.03739 46.0646C0.465456 48.1733 -0.00135636 50.0782 2.96115e-06 50.2979C0.00385436 50.9102 0.346515 51.4533 0.912784 51.7444L1.40984 52H13.5419H25.6739L29.1075 47.2579C30.996 44.6498 32.5658 42.4517 32.5957 42.3733C32.6393 42.2594 29.5774 42.2308 17.3638 42.2308H2.07727L1.03739 46.0646Z"
					fill="url(#paint0_radial_3602_3862)"
					fill-opacity="0.15" />
				<defs>
					<radialGradient
						id="paint0_radial_3602_3862"
						cx="0"
						cy="0"
						r="1"
						gradientUnits="userSpaceOnUse"
						gradientTransform="translate(29 26) rotate(53.7147) scale(49.0026 54.6567)">
						<stop stop-color="white" />
						<stop offset="1" stop-color="white" stop-opacity="0" />
					</radialGradient>
				</defs>
			</svg>
		</div>
		<div class="selectBtnBox" @click="menuData.spawnVehicle()">
			<p>Spawn Vehicle</p>
		</div>
	</div>
</template>
