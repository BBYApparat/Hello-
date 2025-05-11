<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="editBoloInfoLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editBoloInfoLabel">{{ title }}</h5>

                    <h6 v-if="boloInfo.info != undefined && boloInfo.info.id">
                        {{ `${$store.getters.GetTranslation('editbolo', 'ref_num')} ${FormatNumber(boloInfo.info.id)}`
                        }}
                    </h6>
                </div>

                <div class="modal-body">
                    <!-- Vehicle -->
                    <div class="container" v-if="type == 'vehicle'">
                        <div class="row justify-content-center mdt-form">
                            <div class="col-5">
                                <label for="mdt-boloform-vehicle-model" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_veh') }}
                                </label>
                                <input id="mdt-boloform-vehicle-model" class="form-control" type="text"
                                    aria-label="Vehicle model" v-model="formData.vehicle.model" />
                            </div>

                            <div class="col-5">
                                <label for="mdt-boloform-vehicle-plate" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_plate') }}
                                </label>
                                <input id="mdt-boloform-vehicle-plate" class="form-control" type="text"
                                    aria-label="License plate" v-model="formData.vehicle.plate" />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label for="mdt-boloform-vehicle-color" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_color') }}
                                </label>
                                <input id="mdt-boloform-vehicle-color" class="form-control" type="text"
                                    aria-label="Vehicle color" v-model="formData.vehicle.color" />
                            </div>

                            <div class="col-5">
                                <label for="mdt-boloform-vehicle-lastseen" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_lastseen') }}
                                </label>
                                <input id="mdt-boloform-vehicle-lastseen" class="form-control" type="text"
                                    aria-label="Last seen" v-model="formData.vehicle.lastSeen" />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label for="mdt-boloform-vehicle-details" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_vehdes') }}
                                </label>
                                <textarea class="form-control" id="mdt-boloform-vehicle-details" rows="3"
                                    v-model="formData.vehicle.description"></textarea>
                            </div>

                            <div class="col-5">
                                <label for="mdt-boloform-vehicle-reason" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_reason') }}
                                </label>
                                <textarea class="form-control" id="mdt-boloform-vehicle-reason" rows="3"
                                    v-model="formData.vehicle.reason"></textarea>
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-10">
                                <label for="mdt-boloform-vehicle-notes" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_notes') }}
                                </label>
                                <textarea class="form-control" id="mdt-boloform-vehicle-notes" rows="4"
                                    v-model="formData.vehicle.notes"></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- People -->
                    <div class="container" v-if="type == 'person'">
                        <div class="row justify-content-center mdt-form">
                            <div class="col-5">
                                <label for="mdt-boloform-person-name" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_name') }}
                                </label>
                                <input id="mdt-boloform-person-name" class="form-control" type="text" aria-label="Name"
                                    v-model="formData.person.name" />
                            </div>

                            <div class="col-5">
                                <label for="mdt-boloform-person-lastseen" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_lastseen') }}
                                </label>
                                <input id="mdt-boloform-person-lastseen" class="form-control" type="text"
                                    aria-label="Last seen" v-model="formData.person.lastSeen" />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label for="mdt-boloform-person-details" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_des') }}
                                </label>
                                <textarea class="form-control" id="mdt-boloform-person-details" rows="3"
                                    v-model="formData.person.description"></textarea>
                            </div>

                            <div class="col-5">
                                <label for="mdt-boloform-person-reason" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_reason') }}
                                </label>
                                <textarea class="form-control" id="mdt-boloform-person-reason" rows="3"
                                    v-model="formData.person.reason"></textarea>
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-10">
                                <label for="mdt-boloform-person-notes" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_notes') }}
                                </label>
                                <textarea class="form-control" id="mdt-boloform-person-notes" rows="4"
                                    v-model="formData.person.notes"></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Warrant -->
                    <div class="container" v-if="type == 'warrant'">
                        <div class="row justify-content-center mdt-form">
                            <div class="col-5">
                                <label for="mdt-boloform-person-name" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_name') }}
                                </label>
                                <input id="mdt-boloform-person-name" class="form-control" type="text" aria-label="Name"
                                    v-model="formData.warrant.name" />
                            </div>

                            <div class="col-5">
                                <label for="mdt-boloform-person-lastseen" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_lastseen') }}
                                </label>
                                <input id="mdt-boloform-person-lastseen" class="form-control" type="text"
                                    aria-label="Last seen" v-model="formData.warrant.lastSeen" />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label for="mdt-boloform-person-details" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_des') }}
                                </label>
                                <textarea class="form-control" id="mdt-boloform-person-details" rows="3"
                                    v-model="formData.warrant.description"></textarea>

                            </div>

                            <div class="col-5">
                                <label for="mdt-boloform-person-reason" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_reason') }}
                                </label>
                                <textarea class="form-control" id="mdt-boloform-person-reason" rows="3"
                                    v-model="formData.warrant.reason"></textarea>
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-10">
                                <label for="mdt-boloform-person-notes" class="col-form-label">
                                    {{ $store.getters.GetTranslation('editbolo', 'col_notes') }}
                                </label>
                                <textarea class="form-control" id="mdt-boloform-person-notes" rows="4"
                                    v-model="formData.warrant.notes"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn red-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('editbolo', 'discard') }}
                    </button>
                    <button type="button" class="btn green-btn" @click="OnClick('save')">
                        {{ $store.getters.GetTranslation('editbolo', 'save') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "EditBoloModal",
    data() {
        return {
            modalId: "EditBolo" + "Modal",
            beingShown: false,
            boloInfo: new Object(), // Object containing the specified bolo information
            formData: {
                vehicle: {
                    model: "",
                    plate: "",
                    color: "",
                    description: "",
                    lastSeen: "",
                    reason: "",
                    notes: "",
                },
                person: {
                    name: "",
                    description: "",
                    lastSeen: "",
                    reason: "",
                    notes: "",
                },
                warrant: {
                    name: "",
                    description: "",
                    lastSeen: "",
                    reason: "",
                    notes: "",
                },
            },
            type: "", // 'vehicle' or 'person' or 'warrant;
            title: "", // Title of the modal
        };
    },
    props: ["parentElId", "show", "boloData"],
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
        Init() {
            this.type = this.boloData.type;
            this.UpdateTitle();

            if (this.type == "vehicle") {
                this.boloInfo = this.$store.getters.GetSpecificPersonBolo(this.boloData.id)
            } else if (this.type == "person") {
                this.boloInfo = this.$store.getters.GetSpecificVehicleBolo(this.boloData.id)
            } else if (this.type == "warrant") {
                this.boloInfo = this.$store.getters.GetSpecificWarrant(this.boloData.id)
            }

            this.UpdateFields();
        },
        UpdateTitle() {
            if (this.type == "vehicle") {
                this.title = this.$store.getters.GetTranslation('editbolo', 'title_1');
            } else if (this.type == "person") {
                this.title = this.$store.getters.GetTranslation('editbolo', 'title_2');
            } else if (this.type == "warrant") {
                this.title = this.$store.getters.GetTranslation('editbolo', 'title_3');
            } else {
                this.title = this.$store.getters.GetTranslation('editbolo', 'title_4');
            }
        },
        UpdateFields() {
            if ( this.type == "vehicle" || this.type == "person" || this.type == "warrant" ) {
                this.formData[this.type] = this.boloInfo;
            }
        },
        OnClick(status) {
            if (status == "save") {
                if ( this.type === 'person' ) {
                    this.$store.dispatch('UpdatePersonBolo', this.formData[this.type])
                } else if ( this.type === 'vehicle' ) {
                    this.$store.dispatch('UpdateVehicleBolo', this.formData[this.type])
                } else if ( this.type === 'warrant' ) {
                    this.$store.dispatch('UpdateWarrant', this.formData[this.type])
                }

                this.SendNotification(
                    this.$store.getters.GetTranslation('editbolo', 'saved'),
                    this.$store.getters.GetTranslation('editbolo', 'saved_msg'),
                    5000,
                    'success',
                    false,
                );

                this.CloseModal();
            }
        },

        ShowModal() {
            if (!this.beingShown) {
                // Append modal to body
                var modalEl = document.getElementById(this.modalId);
                document.body.appendChild(modalEl);
                this.Init();

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
                this.type = "";
                var parentEl = document.getElementById(this.parentElId);
                parentEl.appendChild(modalEl);
            }, 175);

            this.$store.commit('SetModalClosed')
            this.beingShown = false;
        },
    },
};
</script>

<style lang="scss" scoped>
$primaryColor: #1d1f25;
$primaryColorLight: #2a2c34;
$primaryColorLightHover: #383a44;
$secondaryColor: #e37926;
$secondaryColorHover: #b46020;
$secondaryDarkColor: #a5571b;
$secondaryDarkColorHover: #854513;
$textColor: #ececec;
$textColorHover: #bfbfbf;

// Form specific
$formPlaceholderText: #bfbfbf7c;

// Colors
$redColor: #9f1600;
$redFadedColor: #9f1500ab;
$redColorHover: #7e1100;

$greenColor: #007b1d;
$greenFadedColor: #007b1db6;
$greenColorHover: #006317;

$purpleColor: #884ea0;
$purpleFadedColor: #874ea0a9;
$purpleColorHover: #71368a;

$tealColor: #16a085;
$tealFadedColor: #16a084a8;
$tealColorHover: #107a65;

$yellowColor: #d39736;
$yellowFadedColor: #f5b041b7;
$yellowColorHover: #d39634;

$blueColor: #2e86c1;
$blueFadedColor: #2e86c1a6;
$blueColorHover: #2170a5;

$greyColor: #839192;
$greyFadedColor: #8391929d;
$greyColorHover: #707b7c;

$light-greenColor: #41a068;
$light-greenFadedColor: #41a068b4;
$light-greenColorHover: #31794f;

.dropdown-menu {
    background-color: $primaryColorLightHover;

    .dropdown-header,
    .dropdown-item {
        color: $textColor;
    }

    .dropdown-item {
        &:hover {
            background-color: $primaryColorLight;
        }
    }
}

.mdt-form {
    input,
    .form-control {
        color: $textColor !important;
        border-color: $primaryColorLight !important;
        background-color: $primaryColorLightHover !important;
    }

    ::placeholder {
        color: $formPlaceholderText;
    }

    .form-control:focus {
        border-color: $greyColor !important;
        box-shadow: 0 0 0 0.1rem $greyFadedColor;
    }
}
</style>
