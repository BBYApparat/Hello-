<script setup>
	import HeaderSection from "./components/HeaderSection.vue";
	import MainSection from "./components/MainSection.vue";
	import nuiEvents from "./utils/nui-events";

	import { onMounted } from "vue";
	import { useMenuData } from "@/stores/data.js";
	import { storeToRefs } from "pinia";
	import { fetchNui } from "./utils";

	const menuData = useMenuData();
	const { open } = storeToRefs(menuData);

	onMounted(() => {
		console.log("Garage mounted");
		nuiEvents();
	});

	window.addEventListener("keydown", function (e) {
		if (e.key === "Escape") {
			menuData.setMenu(0);
			fetchNui("closeMenu");
		}
	});
</script>

<template>
	<Transition name="opacity" tag="div">
		<div class="container" v-show="open">
			<div class="garageBox">
				<Transition name="list" tag="div">
					<HeaderSection v-if="open" />
				</Transition>
				<Transition name="list2" tag="div">
					<MainSection v-if="open" />
				</Transition>
			</div>
		</div>
	</Transition>
</template>

<style scoped>
	.list-move,
	.list-enter-active,
	.list-leave-active {
		transition: all 0.25s ease;
	}

	.list-enter-from,
	.list-leave-to {
		opacity: 0;
		transform: translateY(-30px);
	}

	.list2-move,
	.list2-enter-active,
	.list2-leave-active {
		transition: all 0.25s ease;
	}

	.list2-enter-from,
	.list2-leave-to {
		opacity: 0;
		transform: translateY(30px);
	}

	.opacity-move,
	.opacity-enter-active,
	.opacity-leave-active {
		transition: all 0.25s ease;
	}

	.opacity-enter-from,
	.opacity-leave-to {
		opacity: 0;
	}
</style>
