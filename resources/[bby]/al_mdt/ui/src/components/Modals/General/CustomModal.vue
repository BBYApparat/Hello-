<template>
    <Transition name="tmodal">
        <div v-if="show" class="modal-mask">
            <div class="modal" tabindex="-1" style="display: block;">
                <div class="modal-dialog modal-dialog-centered" :class="{
                    'modal-sm': modal_sm,
                    'modal-lg': modal_lg,
                    'modal-xl': modal_xl,
                    'modal-fullscreen': modal_fullscreen,
                }">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <!-- Header slot -->
                                <slot name="header" />
                            </h5>
                        </div>

                        <div class="modal-body">
                            <div class="container">
                                <!-- Body slot -->
                                <slot name="body" />
                            </div>
                        </div>

                        <div class="modal-footer">
                            <!-- Footer slot -->
                            <slot name="footer" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-backdrop show"></div>
        </div>
    </Transition>
</template>

<script>
export default {
    name: "CustomModal",
    props: ["show", "modal_sm", "modal_lg", "modal_xl", "modal_fullscreen"]
};
</script>

<style lang="scss">
.modal-mask {
    transition: opacity 0.15s linear;

    .modal-dialog {
        transition: transform .3s ease-out;
        translate: none;
    }
}

.tmodal-enter-from {
    opacity: 0;

    .modal-dialog {
        transform: translate(0, -50px);
    }
}

.tmodal-leave-to {
    opacity: 0;

    .modal-dialog {
        transform: translate(0, -50px);
    }
}
</style>