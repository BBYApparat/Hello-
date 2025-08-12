<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="changeStatusLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="changeStatusLabel">
                        {{ `${$store.getters.GetTranslation('changestatus',
                        'changeplayerstatus')} ${FormatStringLength(player.name, 20)}` }}
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="container">
                        <div class="row mb-2">
                            <div class="h6 text-center">
                                {{ $store.getters.GetTranslation('changestatus', 'title') }}
                            </div>
                        </div>

                        <div class="row mb-3 justify-content-center">
                            <div class="col">
                                <span style="display: table; margin: 0 auto">
                                    <button type="button" class="btn grey-btn" @click="OnClick(0)"
                                        data-bs-dismiss="modal">
                                        {{ $store.getters.GetTranslation('changestatus', 'unavail') }}
                                    </button>
                                </span>
                            </div>

                            <div class="col">
                                <span style="display: table; margin: 0 auto">
                                    <button type="button" class="btn green-btn" @click="OnClick(1)"
                                        data-bs-dismiss="modal">
                                        {{ $store.getters.GetTranslation('changestatus', 'avail') }}
                                    </button>
                                </span>
                            </div>

                            <div class="col">
                                <span style="display: table; margin: 0 auto">
                                    <button type="button" class="btn yellow-btn" @click="OnClick(2)"
                                        data-bs-dismiss="modal">
                                        {{ $store.getters.GetTranslation('changestatus', 'busy') }}
                                    </button>
                                </span>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col">
                                <span style="display: table; margin: 0 auto">
                                    <button type="button" class="btn blue-btn" @click="OnClick(3)"
                                        data-bs-dismiss="modal">
                                        {{ $store.getters.GetTranslation('changestatus', 'oncall') }}
                                    </button>
                                </span>
                            </div>

                            <div class="col">
                                <span style="display: table; margin: 0 auto">
                                    <button type="button" class="btn purple-btn" @click="OnClick(4)"
                                        data-bs-dismiss="modal">
                                        {{ $store.getters.GetTranslation('changestatus', 'intran') }}
                                    </button>
                                </span>
                            </div>

                            <div class="col">
                                <span style="display: table; margin: 0 auto">
                                    <button type="button" class="btn red-btn" @click="OnClick(5)"
                                        data-bs-dismiss="modal">
                                        {{ $store.getters.GetTranslation('changestatus', 'panic') }}
                                    </button>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn red-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('changestatus', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "ChangeStatusModal",
    data() {
        return {
            modalId: "changeStatus" + "Modal",
            beingShown: false,
        };
    },
    props: ["player", "parentElId", "show", "id"],
    mounted() {
        if (this.id !== undefined) {
            this.modalId = this.id
        }

        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
        ShowModal() {
            if (!this.beingShown) {
                // Append modal to body
                var modalEl = document.getElementById(this.modalId);
                document.body.appendChild(modalEl);

                var modalInstance = Modal.getOrCreateInstance(modalEl);
                modalInstance.show();

                this.$store.commit('SetModalOpen')
                this.beingShown = true;
            }
        },
        CloseModal() {
            // Append modal to original parent
            var modalEl = document.getElementById(this.modalId);
            var modalInstance = Modal.getInstance(modalEl);
            modalInstance.hide();

            setTimeout(() => {
                var parentEl = document.getElementById(this.parentElId);
                parentEl.appendChild(modalEl);
            }, 175);

            this.$store.commit('SetModalClosed')
            this.beingShown = false;
        },
        OnClick(status) {
            this.CloseModal();
            this.$store.dispatch("SetPlayerStatus", {
                identifier: this.player.identifier,
                status: status
            });
        },
    },
};
</script>
