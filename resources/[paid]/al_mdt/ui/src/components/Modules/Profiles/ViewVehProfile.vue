<template>
    <div id="view-veh-profile" class="container-fluid fade">
        <!-- Modals -->
        <AddImage @submit-image="SetPhotoId" :parentElId="'view-veh-profile'" :show="modalData.AddImage.show" />

        <AffirmationModal @affirmation-cb="DeleteImage" :parentElId="'view-veh-profile'"
            :show="modalData.Affirmation.show" :bodyText="modalData.Affirmation.data" />

        <div class="row justify-content-md-center mb-4">
            <div class="col h3 text-center">
                {{ `${$store.getters.GetTranslation('viewvehprofile', 'title')} ${webVehData.plate }` }}
            </div>
        </div>

        <div class="row justify-content-md-center">
            <div class="col-4">
                <!-- Photo Identification -->
                <div class="col-9 mdt-photo-id-frame m-auto">
                    <div class="row p-2">
                        <div class="col text-center" style="position: relative">
                            <template v-if="webVehData.photoIdImg.length > 1">
                                <Image :parentEl="'view-veh-profile'" :img="webVehData.photoIdImg"
                                    :id="'veh_profile_photo'" :border="true" :options="{
                                        maxImgHeight: '25vh',
                                        canExpand: true,
                                    }" />
                            </template>

                            <template v-else>
                                <div class=" row d-flex align-items-center mdt-profiles-no-picture m-auto ">
                                    <div class="container-fluid">
                                        <div class="row justify-content-md-center mb-2">
                                            <div class="h6 text-center">
                                                {{ $store.getters.GetTranslation('viewvehprofile', 'no_photo') }}
                                            </div>
                                        </div>

                                        <template v-if="perms.editPhoto">
                                            <button class="btn blue-btn btn-sm" type="button" @click="SetImageModal()">
                                                {{ $store.getters.GetTranslation('viewvehprofile', 'add_photo') }}
                                            </button>
                                        </template>
                                    </div>
                                </div>
                            </template>
                        </div>
                    </div>

                    <div class=" row justify-content-md-center mdt-photo-id-lower p-2 pb-3 m-auto ">
                        <span class="h6 text-center align-middle" style="margin: 0">
                            {{ $store.getters.GetTranslation('viewvehprofile', 'photo') }}
                            <template v-if="webVehData.photoIdImg && !showPhotoOptions && perms.editPhoto">
                                <a href="#">
                                    <i class="fas fa-angle-down mdt-color-text ms-1"
                                        @click="showPhotoOptions = true"></i>
                                </a>
                            </template>

                            <template v-if="webVehData.photoIdImg && showPhotoOptions && perms.editPhoto">
                                <a href="#">
                                    <i class="fas fa-angle-up mdt-color-text ms-1"
                                        @click="showPhotoOptions = false"></i>
                                </a>
                            </template>
                        </span>

                        <template v-if="webVehData.photoIdImg && showPhotoOptions && perms.editPhoto">
                            <span class="text-center mt-2">
                                <button type="button" class="btn btn-sm blue-btn me-3" data-bs-toggle="tooltip"
                                    data-bs-placement="top"
                                    :title="$store.getters.GetTranslation('viewvehprofile', 'tooltip_1')"
                                    @click="SetImageModal()">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'replace') }}
                                </button>

                                <button type="button" class="btn btn-sm red-btn" data-bs-toggle="tooltip"
                                    data-bs-placement="top"
                                    :title="$store.getters.GetTranslation('viewvehprofile', 'tooltip_2')"
                                    @click="DeleteImageConfirmation()">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'delete') }}
                                </button>
                            </span>
                        </template>
                    </div>
                </div>

                <!-- Notes -->
                <div class="row justify-content-md-center mt-4">
                    <div class="col pt-1 pb-3">
                        <div class="row justify-content-center mdt-form">
                            <div class="row justify-content-md-center">
                                <div class="col h5 text-center">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'notes') }}
                                    <template v-if="editing.notes">
                                        <button type="button" class="btn btn-sm green-btn ms-1" @click="SaveNotes()">
                                            {{ $store.getters.GetTranslation('viewvehprofile', 'save') }}
                                        </button>
                                    </template>
                                </div>
                            </div>

                            <div class="col-11 text-center">
                                <textarea class="form-control"
                                    :placeholder="$store.getters.GetTranslation('viewvehprofile', 'ph_notes')" rows="10"
                                    v-model="webVehData.notes" @input="onNotesChange()"
                                    :disabled="!perms.editNotes"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- General Data -->
            <div class="col-7">
                <div class="col pt-3 pb-3">
                    <div class="row justify-content-md-center">
                        <div class="col-4 h5 text-center">
                            {{ $store.getters.GetTranslation('viewvehprofile', 'owner_info') }}
                            <button type="button" class="btn btn-sm blue-btn ms-1" @click="SwitchToCharProfile()"
                                data-bs-toggle="tooltip" data-bs-placement="top"
                                :title="$store.getters.GetTranslation('viewvehprofile', 'tooltip_3')">
                                <i class="fas fa-external-link-alt"></i>
                            </button>
                        </div>
                    </div>

                    <div class="mdt-profiles-container pt-1 pb-3">
                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_fname') }}
                                </label>
                                <input class="form-control" type="text" v-model="webVehData.firstName" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_lname') }}
                                </label>
                                <input class="form-control" type="text" v-model="webVehData.lastName" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_gender') }}
                                </label>
                                <input class="form-control" type="text" v-model="webVehData.gender" readonly />
                            </div>
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_dob') }}
                                </label>
                                <input class="form-control" type="text" v-model="webVehData.dob" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_war') }}
                                </label>
                                <input class="form-control"
                                    :class="{ alertStatus: webVehData.warrantStatus == $store.getters.GetTranslation('viewvehprofile', 'active_bolo'), 'fw-bold': webVehData.warrantStatus == $store.getters.GetTranslation('viewvehprofile', 'active_bolo'), }"
                                    type="text" v-model="webVehData.warrantStatus" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_bolo') }}
                                </label>
                                <input class="form-control"
                                    :class="{ alertStatus: webVehData.boloStatus == $store.getters.GetTranslation('viewvehprofile', 'active_bolo'), 'fw-bold': webVehData.boloStatus == $store.getters.GetTranslation('viewvehprofile', 'active_bolo'), }"
                                    type="text" v-model="webVehData.boloStatus" readonly />
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-md-center mt-4">
                        <div class="col-6 h5 text-center">
                            {{ $store.getters.GetTranslation('viewvehprofile', 'veh_info') }}
                            <template v-if="!editing.vehInfo && perms.editInfo">
                                <button type="button" class="btn btn-sm blue-btn ms-2" @click="editing.vehInfo = true">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'edit') }}
                                </button>
                            </template>

                            <template v-if="editing.vehInfo">
                                <button type="button" class="btn btn-sm green-btn ms-2" @click="SaveVehInfo()">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'save') }}
                                </button>
                            </template>
                        </div>
                    </div>

                    <div class="mdt-profiles-container pt-2 pb-2">
                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_plate') }}
                                </label>
                                <input class="form-control" type="text" v-model="webVehData.plate" readonly />
                            </div>
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_bolo') }}
                                </label>
                                <input class="form-control"
                                    :class="{ alertStatus: webVehData.vehboloStatus == $store.getters.GetTranslation('viewvehprofile', 'active_bolo'), 'fw-bold': webVehData.vehboloStatus == $store.getters.GetTranslation('viewvehprofile', 'active_bolo'), }"
                                    type="text" v-model="webVehData.vehboloStatus" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_model') }}
                                </label>
                                <input class="form-control" :class="{ 'mdt-can-edit': editing.vehInfo }"
                                    :placeholder="$store.getters.GetTranslation('viewvehprofile', 'ph_none')"
                                    type="text" v-model="webVehData.model" :readonly="!editing.vehInfo" />
                            </div>
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewvehprofile', 'col_color') }}
                                </label>
                                <input class="form-control" :class="{ 'mdt-can-edit': editing.vehInfo }"
                                    :placeholder="$store.getters.GetTranslation('viewvehprofile', 'ph_none')"
                                    type="text" v-model="webVehData.color" :readonly="!editing.vehInfo" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row justify-content-md-center mt-4">
            <div class="col h3 text-center">
                <button type="button" class="btn grey-btn" @click="GoBack()">
                    <i class="fas fa-caret-left"></i>
                    {{ $store.getters.GetTranslation('viewvehprofile', 'back') }}
                </button>
            </div>
        </div>
    </div>
</template>

<script>
import AddImage from "../../Modals/Images/AddImage";
import AffirmationModal from "../../Modals/General/Affirmation";
import Image from "../../Modules/Image"

import api from '@/api/main'

export default {
    name: "ViewCharModule",
    emits: ['go-back'],
    components: {
        AddImage,
        AffirmationModal,
        Image,
    },
    props: ["parentEl", "vehData"],
    data() {
        return {
            modalData: {
                Affirmation: {
                    show: false,
                    data: "",
                },
                AddImage: {
                    show: false,
                },
            },

            showPhotoOptions: false,

            webVehData: { // Data used in the front end
                // Vehicle Photo
                photoIdImg: "",

                // Owner
                firstName: "",
                lastName: "",
                dob: "",
                gender: "",
                warrantStatus: "",
                boloStatus: "",

                // Vehicle
                plate: "",
                model: "",
                color: "",
                notes: "",
                vehboloStatus: "",
            },

            editing: {
                vehInfo: false,
                notes: false
            },

            perms: {
                editPhoto: false,
                editNotes: false,
                editInfo: false,
            }
        };
    },
    mounted() {
        this.SetupData();
        this.RefreshBS();

        this.modalData.Affirmation.data = this.$store.getters.GetTranslation('viewvehprofile', 'delete_img');
        this.CheckPerms();
    },
    methods: {
        CheckPerms() {
            let player = this.$store.getters.GetSelf()

            if (player) {
                const playerJob = player.job

                this.perms.editPhoto = this.$store.getters.HasPerm(playerJob, 'vehProfile', 'editPhoto')
                this.perms.editNotes = this.$store.getters.HasPerm(playerJob, 'vehProfile', 'editNotes')
                this.perms.editInfo = this.$store.getters.HasPerm(playerJob, 'vehProfile', 'editVehicleInfo')
            }
        },

        GoBack() {
            this.HidePage()
            setTimeout(() => { this.$emit('go-back') }, 160)
        },

        SwitchToCharProfile() {
            this.ToggleLoadingScreen(true)
            this.HidePage()

            setTimeout(async () => {
                const result = await api.characters.GetDetailedProfile(this.vehData.ownerIdentifier);
                this.$emit('switch-char-profile', result, `${this.vehData.owner.firstName} ${this.vehData.owner.lastName}`)
            }, 160)
        },

        SaveVehInfo() {
            this.editing.vehInfo = false

            api.vehicles.UpdateProfile(this.vehData.plate, this.webVehData.model, this.webVehData.color, false, false)

            this.SendNotification(
                this.$store.getters.GetTranslation('viewvehprofile', 'saved'),
                this.$store.getters.GetTranslation('viewvehprofile', 'saved_msg'),
                5000,
                'success',
                false,
                false
            );
        },

        onNotesChange() {
            if ( !this.editing.notes ) {
                this.editing.notes = true
            }
        },

        SaveNotes() {
            this.editing.notes = false

            api.vehicles.UpdateProfile(this.vehData.plate, false, false, false, this.webVehData.notes)

            this.SendNotification(
                this.$store.getters.GetTranslation('viewvehprofile', 'saved'),
                this.$store.getters.GetTranslation('viewvehprofile', 'saved_msg'),
                5000,
                'success',
                false,
                false
            );
        },

        DeleteImage() {
            this.webVehData.photoIdImg = "";

            setTimeout(() => {
                this.RefreshBS();
            }, 100);
        },
        DeleteImageConfirmation() {
            if (!this.modalData.Affirmation.show) {
                this.modalData.Affirmation.show = true;

                setTimeout(() => {
                    this.modalData.Affirmation.show = false;
                }, 200);
            }
        },
        SetImageModal() {
            if (!this.modalData.AddImage.show) {
                this.modalData.AddImage.show = true;

                setTimeout(() => {
                    this.modalData.AddImage.show = false;
                }, 200);
            }
        },
        SetPhotoId(data) {
            this.webVehData.photoIdImg = data.img;

            api.vehicles.UpdateProfile(this.vehData.plate, false, false, data.img, false)

            this.SendNotification(
                this.$store.getters.GetTranslation('viewvehprofile', 'submitted'),
                this.$store.getters.GetTranslation('viewvehprofile', 'submitted_msg'),
                5000,
                'success',
                false,
                false
            );
        },
        SetupData() {
            this.webVehData = {
                photoIdImg: this.vehData.photoId,

                // Owner
                firstName: this.vehData.owner.firstName,
                lastName: this.vehData.owner.lastName,
                gender: this.vehData.owner.sex,
                dob: this.vehData.owner.dob,
                warrantStatus: this.$store.getters.HasActiveWarrant(this.vehData.ownerIdentifier) ? this.$store.getters.GetTranslation('viewvehprofile', 'active_bolo') : this.$store.getters.GetTranslation('viewvehprofile', 'no_bolo'),
                boloStatus: this.$store.getters.HasActiveBolo(this.vehData.ownerIdentifier) ? this.$store.getters.GetTranslation('viewvehprofile', 'active_bolo') : this.$store.getters.GetTranslation('viewvehprofile', 'no_bolo'),

                // Vehicle
                plate: this.vehData.plate,
                model: this.vehData.model,
                color: this.vehData.color,
                notes: this.vehData.notes,
                vehboloStatus: this.$store.getters.HasActiveVehBolo(this.vehData.plate) ? this.$store.getters.GetTranslation('viewvehprofile', 'active_bolo') : this.$store.getters.GetTranslation('viewvehprofile', 'no_bolo'),
            };

            setTimeout(() => {
                this.ShowPage()
                this.ToggleLoadingScreen(false)
            }, 1500)
        },

        ShowPage() {
            var page = document.getElementById('view-veh-profile');
            page.classList.add("show");
        },

        HidePage() {
            var page = document.getElementById('view-veh-profile');
            page.classList.remove("show");
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
//$formBackground: #0000002a;
$formBackground: #2d3138;
$formPlaceholderText: #0504047c;

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

.mdt-profiles-no-picture {
    height: 25vh;
    background-color: rgba(0, 0, 0, 0.425);
    width: 100%;
}

.mdt-profiles-container {
    background-color: $primaryColorLightHover;
    border-radius: 5px;

    input,
    textarea {
        background-color: $formBackground !important;
    }

    .mdtTable {
        background-color: $formBackground;

        .table {
            color: $textColor;
            background-color: $formBackground !important;
        }
    }
}

.alertStatus {
    color: $textColor !important;
    box-shadow: 0 0 10px $redFadedColor;
    padding: 4px 6px;
    border-radius: 5px;
    animation: blinkAlert 1s ease infinite;
}

.mdt-photo-id-frame {
    background-color: $primaryColorLightHover;
    border-radius: 5px;

    .mdt-photo-id-lower {
        width: 100%;
        background-color: $primaryColorLightHover;
    }
}

.mdt-can-edit {
    color: $textColor !important;
}

.mdtTable {
    background-color: $primaryColorLightHover;
    border-radius: 5px;

    .table {
        color: $textColor;
        background-color: $primaryColorLightHover;
    }

    .table-con {
        border: 10px $primaryColorLightHover solid;
        border-radius: 5px;
        background-color: $primaryColorLightHover;
    }

    .list-group-item {
        background-color: $primaryColorLightHover;
        color: $textColor;

        &:hover {
            background-color: #383a44af;
            color: $textColorHover;
        }
    }
}

@keyframes blinkAlert {
    0% {
        box-shadow: 0 0 10px rgba(255, 255, 255, 0);
        background-color: rgba(255, 255, 255, 0);
    }
    50% {
        box-shadow: 0 0 10px $redColor;
    }
    100% {
        box-shadow: 0 0 10px rgba(255, 255, 255, 0);
        background-color: rgba(255, 255, 169, 0);
    }
}
</style>
