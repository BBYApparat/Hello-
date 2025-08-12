<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="toggleDutyLabel" aria-hidden="true">
        <div class=" modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable ">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="toggleDutyLabel">{{ title }}</h5>
                </div>

                <div class="modal-body">
                    <template v-if="!$store.getters.IsOnDuty()">
                        <div class="container-fluid">
                            <div class="row justify-content-md-center">
                                <div class="h6 text-center">
                                    {{ $store.getters.GetTranslation('dutytoggle', 'setcall') }}
                                </div>
                            </div>

                            <div class="row justify-content-md-center mdt-form">
                                <div class="col-3 text-center">
                                    <input class="form-control" type="text" placeholder="A-1"
                                        v-model="inputFields.callsign"
                                        :class="{ 'is-invalid': validationFeedback.length > 0 }" />
                                    <div class="invalid-feedback mt-2">
                                        {{ validationFeedback }}
                                    </div>
                                </div>
                            </div>

                            <div class="mt-3 mb-2 text-center">
                                <button type="button" class="btn green-btn" @click="Confirm(true)">
                                    {{ $store.getters.GetTranslation('dutytoggle', 'clockin') }}
                                </button>
                            </div>
                        </div>
                    </template>

                    <template v-else-if="$store.getters.IsOnDuty()">
                        <div class="container-fluid">
                            <div class="row justify-content-md-center">
                                <div class="h6 text-center">
                                    {{ $store.getters.GetTranslation('dutytoggle', 'clockoutconfirm') }}
                                </div>
                            </div>

                            <div class="row justify-content-md-center mdt-form">
                                <div class="col-4 text-center">
                                    <label class="col-form-label" style="font-size: 0.9rem">
                                        {{ $store.getters.GetTranslation('dutytoggle', 'elapsedtime') }}
                                    </label>
                                    <input class="form-control text-center" type="text" v-model="elapsedTime"
                                        readonly />
                                </div>
                            </div>

                            <div class="mt-3 mb-2 text-center">
                                <button type="button" class="btn red-btn" @click="Confirm(false)">
                                    {{ $store.getters.GetTranslation('dutytoggle', 'clockout') }}
                                </button>
                            </div>
                        </div>
                    </template>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('dutytoggle', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "DutyToggle",
    data() {
        return {
            modalId: "dutyToggle" + "Modal",
            title: "",
            beingShown: false,
            inputFields: {
                callsign: "",
            },
            validationFeedback: "",
            elapsedTime: '',
        };
    },
    props: ["parentElId", "show"],
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
        Confirm(state) {
            if ( state ) {
                if ( this.inputFields.callsign.length > 0 ) {
                    this.$store.dispatch('SetOnDuty', this.inputFields.callsign)
                    this.SendNotification(
                        this.$store.getters.GetTranslation('dutytoggle', 'clockedin'),
                        this.$store.getters.GetTranslation('dutytoggle', 'clockedin_msg'),
                        4000,
                        'success',
                        false
                    );

                    this.CloseModal();
                } else {
                    this.validationFeedback = this.$store.getters.GetTranslation('dutytoggle', 'callreq')
                }
            } else {
                this.SendNotification(
                    this.$store.getters.GetTranslation('dutytoggle', 'clockedout'),
                    this.$store.getters.GetTranslation('dutytoggle', 'clockedout_msg'),
                    4000,
                    'success',
                    false
                );

                this.$store.dispatch('SetOffDuty')
                this.CloseModal();
            }
        },
        ShowModal() {
            if (!this.beingShown) {
                // Append modal to body
                var modalEl = document.getElementById(this.modalId);
                document.body.appendChild(modalEl);

                var modalInstance = Modal.getOrCreateInstance(modalEl);
                modalInstance.show();

                this.inputFields.callsign = this.$store.getters.GetSelf().callsign;
                this.title = this.$store.getters.IsOnDuty() ? this.$store.getters.GetTranslation('dutytoggle', 'title_1') : this.$store.getters.GetTranslation('dutytoggle', 'title_2')
                this.elapsedTime = this.$store.getters.IsOnDuty() ? this.$store.getters.GetElapsedTimeOnDuty() : ''

                this.$store.commit('SetModalOpen')
                this.beingShown = true;
            }
        },
        CloseModal() {
            if (!this.isLoading) {
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
            }
        },
    },
};
</script>
