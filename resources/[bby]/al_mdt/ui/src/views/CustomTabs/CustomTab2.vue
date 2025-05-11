<template>
    <div class="customtab container mt-3 p-2">
        <iframe :src="$store.state.config.CustomTabs[1].link" frameborder="0" class="custom-content"></iframe>
    </div>
</template>

<script>
export default {
    name: "CustomTab2",
};
</script>

<style lang="scss" scoped>
$primaryColorLight: #2a2c34;

.customtab {
    background-color: $primaryColorLight;
    border-radius: 5px;
}

.custom-content {
    border-style: none;
    border-radius: 5px;
    width: 100%;
    height: 65vh;
}
</style>
