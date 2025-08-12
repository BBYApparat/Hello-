<template>
    <Transition name="tmodal">
        <div v-if="show" class="modal-mask">
            <div class="modal" tabindex="-1" style="display: block;">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <!-- Header slot with default header -->
                                <slot name="header">
                                    {{ $store.getters.GetTranslation('confirmation', 'title') }}
                                </slot>
                            </h5>
                        </div>

                        <div class="modal-body">
                            <div class="container">
                                <!-- Body slot -->
                                <slot name="body" />
                            </div>
                        </div>

                        <div class="modal-footer">
                            <!-- Footer slot with default footer -->
                            <slot name="footer">
                                <button type="button" class="btn red-btn me-2" @click="OnClick(false)">
                                    {{ $store.getters.GetTranslation('confirmation', 'no') }}
                                </button>

                                <button type="button" class="btn green-btn" @click="OnClick(true)">
                                    {{ $store.getters.GetTranslation('confirmation', 'yes') }}
                                </button>
                            </slot>
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
    name: "ConfirmationModal",
    props: ["show"],
    methods: {
        OnClick(status) {
            this.$emit('cb', status);
            this.$emit('close');
        },
    },
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