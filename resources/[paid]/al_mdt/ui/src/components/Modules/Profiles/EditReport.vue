<template>
    <div class="container-fluid">
        <!-- Modals -->
        <SearchCharacterModal @found-character="SetCharData" :parentElId="parentElId"
            :id="`${parentElId}-edit-report-search-char`" :show="modalData.SearchChar.show" />

        <CriminalCode @update-charges="UpdateCharges" :parentElId="parentElId" :show="modalData.CriminalCode.show"
            :restoredData="{
                list: reportData.data.criminalCharges,
                metaData: reportData.data.criminalChargesMetadata,
            }" />

        <AddImage @submit-image="AddImage" :parentElId="parentElId" :show="modalData.AddImage.show" :options="{
            label: true,
        }" />

        <AffirmationModal @affirmation-cb="DeleteImage" :parentElId="parentElId" :show="modalData.Affirmation.show"
            :bodyText="modalData.Affirmation.data" />

        <SelectPoliceModal @update-selected="UpdateSelectedPolice" :parentElId="parentElId"
            :show="modalData.SelectPolice.show" :restoredData="reportData.data.lawEnforcement" />

        <div class="container-fluid fade" id="edit-report" v-if="reportData">
            <div class="row justify-content-md-center mb-3">
                <div class="col h4 text-center">
                    <template v-if="reportData.type.toLowerCase() == 'incident'">
                        {{ $store.getters.GetTranslation('editreport', 'title_1') }}
                    </template>

                    <template v-else-if="reportData.type.toLowerCase() == 'arrest'">
                        {{ $store.getters.GetTranslation('editreport', 'title_2') }}
                    </template>
                </div>
            </div>

            <div class="row justify-content-md-center mdt-form">
                <div class="col-4 col-xxl-3 h6 text-center">
                    <div class="form-control fw-bold">
                        {{
                        `${$store.getters.GetTranslation('editreport', 'col_ref')} ${FormatNumber(reportData.id)}`
                        }}
                    </div>
                </div>

                <div class="col-4 col-xxl-3 h6 text-center">
                    <div class="form-control fw-bold">
                        {{
                        `${$store.getters.GetTranslation('editreport', 'col_date')} ${FormatDate(reportData.date,
                        true)}`
                        }}
                    </div>
                </div>

                <div class="col-4 col-xxl-3 h6 text-center">
                    <div class="form-control fw-bold">
                        {{
                        `${$store.getters.GetTranslation('editreport', 'col_sub')} ${record.input.submittedBy}`
                        }}
                    </div>
                </div>
            </div>

            <div class="row justify-content-center">
                <div class="col-10">
                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_name') }}
                                <span class="mdt_required" title="Required">*</span>
                            </label>

                            <div class="input-group">
                                <button class="btn btn-sm blue-btn" type="button" @click="SearchForCharacter()">
                                    {{ $store.getters.GetTranslation('editreport', 'select') }}
                                </button>
                                <input type="text" class="form-control"
                                    :placeholder="$store.getters.GetTranslation('editreport', 'ph_name')"
                                    v-model="reportData.input.subjectName" readonly />
                            </div>
                        </div>

                        <div class="col-5" v-if="reportData.type.toLowerCase() === 'incident'">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_inres') }}
                                <span class="mdt_required" title="Required">*</span>
                            </label>

                            <div class="input-group">
                                <button class="btn blue-btn btn-sm dropdown-toggle" type="button"
                                    id="incidentResultDropdown" data-bs-toggle="dropdown" aria-expanded="false"
                                    @click="ToggleDropdown('incidentResultDropdown')">
                                    {{ $store.getters.GetTranslation('editreport', 'select') }}
                                </button>
                                <ul class="dropdown-menu">
                                    <li v-for="type in $store.state.config.incidentResultTypes"
                                        :key="type + '_incidentType'">
                                        <a class="dropdown-item" href="#" @click="UpdateIncidentResult(type)">
                                            {{ type }}
                                        </a>
                                    </li>
                                </ul>
                                <input type="text" class="form-control"
                                    :placeholder="$store.getters.GetTranslation('editreport', 'ph_inres')"
                                    aria-label="Incident result" v-model="reportData.input.incidentResult" readonly />
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label class="col-form-label">
                                <template v-if="reportData.type.toLowerCase() == 'incident'">
                                    {{ $store.getters.GetTranslation('editreport', 'col_location_1') }}
                                </template>
                                <template v-else-if="reportData.type.toLowerCase() == 'arrest'">
                                    {{ $store.getters.GetTranslation('editreport', 'col_location_2') }}
                                </template>
                                <span class="mdt_required" title="Required">*</span>
                            </label>
                            <input class="form-control" type="text"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_location')"
                                aria-label="Location of incident" v-model="reportData.input.location" />
                        </div>

                        <div class="col-5">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_des') }}
                                <span class="mdt_required" title="Required">*</span>
                            </label>
                            <input class="form-control" type="text"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_des')"
                                aria-label="Brief description" v-model="reportData.input.briefDescription" />
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-10">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_leo') }}
                            </label>
                            <div class="input-group">
                                <button class="btn blue-btn btn-sm" type="button" @click="SelectPolice()">
                                    {{ $store.getters.GetTranslation('editreport', 'select') }}
                                </button>

                                <input type="text" class="form-control"
                                    :placeholder="$store.getters.GetTranslation('editreport', 'ph_leo')"
                                    aria-label="Law enforcement involved"
                                    v-model="reportData.input.lawEnforcementInvolved" />
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-3">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_people') }}
                            </label>
                            <textarea class="form-control"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_people')" rows="3"
                                v-model="reportData.input.individualsInvolved"></textarea>
                        </div>

                        <div class="col-4">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_vehicles') }}
                            </label>
                            <textarea class="form-control"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_vehicles')" rows="3"
                                v-model="reportData.input.vehicleInvolved"></textarea>
                        </div>

                        <div class="col-3">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_evidence') }}
                            </label>
                            <textarea class="form-control"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_evidence')" rows="3"
                                v-model="reportData.input.evidence"></textarea>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-10">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_charges') }}
                                <button class="btn blue-btn btn-sm ms-1" type="button" @click="ShowCriminalCode()">
                                    {{ $store.getters.GetTranslation('editreport', 'select') }}
                                </button>
                            </label>
                            <textarea class="form-control"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_charges')" rows="4"
                                v-model="reportData.input.charges" readonly></textarea>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col text-center" style="font-size: 0.8rem">
                            <i class="fas fa-info-circle"></i>
                            {{ $store.getters.GetTranslation('editreport', 'warning') }}
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2" v-if="reportData.data.total.fines > 0">
                        <div class="col-3">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_fines') }}
                            </label>
                            <input class="form-control" type="text" v-model="reportData.input.totalFines" readonly />
                        </div>

                        <div class="col-2">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_due') }}
                            </label>
                            <input class="form-control" type="text"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_due')"
                                v-model="reportData.input.dueDate" readonly />
                        </div>

                        <div class="col-5">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_finereduc') }}
                            </label>
                            <input type="text" class="form-control"
                                :class="{ 'fw-bold': reportData.input.fineReduction.length > 0 }"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_finereduc')"
                                v-model="reportData.input.fineReduction" readonly />
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2" v-if="reportData.data.total.jail > 0">
                        <div class="col-5">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_jail') }}
                            </label>
                            <input class="form-control" type="text" v-model="reportData.input.totalJail" readonly />
                        </div>

                        <div class="col-5">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_jailreduc') }}
                            </label>
                            <input type="text" class="form-control"
                                :class="{ 'fw-bold': reportData.input.jailReduction.length > 0, }"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_jailreduc')"
                                v-model="reportData.input.jailReduction" readonly />
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-10">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_details') }}
                            </label>
                            <textarea class="form-control"
                                :placeholder="$store.getters.GetTranslation('editreport', 'ph_details')" rows="6"
                                v-model="reportData.input.details"></textarea>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-11 pb-3">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('editreport', 'col_imgs') }}
                            </label>
                            <div class="row attached-images p-3" style="border-radius: 3px">
                                <div class="col-6 col-xxl-4">
                                    <div class="card m-2" style="max-width: 18rem">
                                        <div class="card-header">
                                            <i class="fas fa-images me-1"></i>
                                            {{ $store.getters.GetTranslation('editreport', 'attchimg') }}
                                        </div>

                                        <div class="card-body text-center attach-image">
                                            <i class="fas fa-plus mdt-icon-lg"></i>

                                            <div id="mdt-add-image" class="container-fluid">
                                                <div class="row justify-content-md-center mb-2">
                                                    <div class="h6 text-center">
                                                        {{ $store.getters.GetTranslation('editreport', 'img_info') }}
                                                    </div>
                                                </div>

                                                <button class="btn blue-btn btn-sm" type="button"
                                                    @click="ShowAddImageModal()">
                                                    {{ $store.getters.GetTranslation('editreport', 'add') }}
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <template v-for="(data, index) in reportData.data.submittedImages"
                                    :key="index + '_attached_image'">
                                    <div class="col-6 col-xxl-4">
                                        <div class="card m-2" style="max-width: 18rem">
                                            <div class="card-header">
                                                <i class="fas fa-image me-1"></i>
                                                {{ FormatStringLength(data.name, 25) }}

                                                <span class="float-end mdt-color-red">
                                                    <i class="fas fa-times-circle"
                                                        @click="DeleteImageConfirmation(index)"></i>
                                                </span>
                                            </div>

                                            <div class="card-body text-center">
                                                <div class="row d-flex align-items-center justify-content-md-center"
                                                    style="height: 100%;">
                                                    <Image :parentEl="parentElId" :img="data.img"
                                                        :id="`${index}_edit_report`" :options="{
                                                            maxImgHeight: '150px',
                                                            canExpand: true,
                                                        }" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </template>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row justify-content-center mdt-form mt-3">
                <div class="col-4 text-center">
                    <button type="button" class="btn red-btn me-3" @click="StopEditing()">
                        {{ $store.getters.GetTranslation('editreport', 'discard') }}
                    </button>

                    <button type="button" class="btn green-btn" @click="SaveChanges()">
                        {{ $store.getters.GetTranslation('editreport', 'save') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
// Modals
import SearchCharacterModal from "../../Modals/General/SearchChar";
import CriminalCode from "../../Modals/Reports/CriminalCode";
import AddImage from "../../Modals/Images/AddImage";
import AffirmationModal from "../../Modals/General/Affirmation";
import SelectPoliceModal from "../../Modals/Reports/SelectPolice";
import Image from "../Image";

import { Dropdown } from "bootstrap/dist/js/bootstrap.esm.min.js";
import api from '@/api/main'

export default {
    name: "Edit-Report-Form",
    components: {
        SearchCharacterModal,
        CriminalCode,
        AddImage,
        AffirmationModal,
        Image,
        SelectPoliceModal,
    },
    emits: ['stop-editing'],
    props: ["parentElId", "record"],
    data() {
        return {
            reportData: {
                type: "",

                date: "",

                input: {
                    briefDescription: "",
                    lawEnforcementInvolved: "",
                    individualsInvolved: "",
                    vehicleInvolved: "",
                    location: "",
                    subjectName: "",
                    incidentResult: "",
                    details: "",
                    charges: "",
                    evidence: "",

                    totalFines: "",
                    fineReduction: "",
                    totalJail: "",
                    jailReduction: "",
                    dueDate: "",
                },

                // Data
                data: {
                    criminalCharges: [],

                    submittedImages: [],

                    charData: {},

                    dueDate: 0,

                    total: {
                        fines: 0,
                        fineReduction: 0,
                        jail: 0,
                        jailReduction: 0,
                    },

                    lawEnforcement: [],
                },
            },

            fineReductions: [
                { label: "10%", reduce: 0.1 },
                { label: "20%", reduce: 0.2 },
                { label: "30%", reduce: 0.3 },
                { label: "40%", reduce: 0.4 },
                { label: "50%", reduce: 0.5 },
                { label: "60%", reduce: 0.6 },
                { label: "70%", reduce: 0.7 },
                { label: "80%", reduce: 0.8 },
                { label: "90%", reduce: 0.9 },
                { label: "100%", reduce: 1 },
            ],

            selectedImage: false,

            modalData: {
                SearchChar: {
                    show: false,
                },
                CriminalCode: {
                    show: false,
                },
                AddImage: {
                    show: false,
                },
                Affirmation: {
                    show: false,
                    data: "",
                },
                SelectPolice: {
                    show: false
                }
            },
        };
    },
    mounted() {
        this.Init()
        this.modalData.Affirmation.data = this.$store.getters.GetTranslation('editreport', 'img_del')
    },
    methods: {
        Init() {
            this.reportData = Object.assign({}, this.record);
        },

        StopEditing() {
            this.$emit('stop-editing')
        },
        SaveChanges() {
            this.reportData.description = this.reportData.input.briefDescription
            api.reports.UpdateRecordEntry(this.reportData)

            this.StopEditing()

            this.SendNotification(
                this.$store.getters.GetTranslation('editreport', 'saved'),
                this.$store.getters.GetTranslation('editreport', 'saved_msg'),
                7500,
                'success',
                false
            );
        },

        UpdateCharges(charges, str) {
            if (charges) {
                this.reportData.data.criminalCharges = charges;

                this.reportData.input.charges = str;
            } else {
                this.reportData.data.criminalCharges = [];
                this.reportData.input.charges = "";
            }
        },
        SetCharData(data, fullName) {
            this.reportData.data.charData = {
                identifier: data.identifier,
                name: fullName
            };
            this.reportData.input.subjectName = fullName;
        },
        ToggleDropdown(id) {
            var dropdownEl = document.getElementById(id);
            var dropdownInstance = Dropdown.getOrCreateInstance(dropdownEl);
            dropdownInstance.toggle();
        },

        // Incident result dropdown //
        UpdateIncidentResult(type) {
            this.reportData.input.incidentResult = type;
        },

        // Search suspect modal //
        SearchForCharacter() {
            if (!this.modalData.SearchChar.show) {
                this.modalData.SearchChar.show = true;

                setTimeout(() => {
                    this.modalData.SearchChar.show = false;
                }, 200);
            }
        },

        // Images //
        DeleteImage() {
            if (typeof this.selectedImage == "number") {
                this.reportData.data.submittedImages.splice(this.selectedImage, 1);
                this.selectedImage = false;
            }
        },
        DeleteImageConfirmation(index) {
            if (!this.modalData.Affirmation.show) {
                this.selectedImage = index;
                this.modalData.Affirmation.show = true;

                setTimeout(() => {
                    this.modalData.Affirmation.show = false;
                }, 200);
            }
        },
        AddImage(img) {
            this.reportData.data.submittedImages.push(img);
        },
        ShowAddImageModal() {
            if (!this.modalData.AddImage.show) {
                this.modalData.AddImage.show = true;

                setTimeout(() => {
                    this.modalData.AddImage.show = false;
                }, 200);
            }
        },

        ShowCriminalCode() {
            if (!this.modalData.CriminalCode.show) {
                this.modalData.CriminalCode.show = true;

                setTimeout(() => {
                    this.modalData.CriminalCode.show = false;
                }, 200);
            }
        },

        SelectPolice() {
            if (!this.modalData.SelectPolice.show) {
                this.modalData.SelectPolice.show = true;

                setTimeout(() => {
                    this.modalData.SelectPolice.show = false;
                }, 200);
            }
        },
        UpdateSelectedPolice(arry, str) {
            this.reportData.data.lawEnforcement = arry
            this.reportData.input.lawEnforcementInvolved = str
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
$formBackground: #2d3138;
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

#mdt-database-createReport {
    display: none;
}

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

.card {
    color: $textColor;
    background-color: $formBackground;
    border: 3px $formBackground solid;

    .card-body {
        width: 100%;
        height: 180px;
    }

    .card-text {
        font-size: 0.9rem !important;
    }
}

.attached-images {
    color: $textColor;
    background-color: $primaryColorLightHover;
}

.attach-image {
    background-color: rgba(0, 0, 0, 0.5);
    transition: all 0.2s ease-in-out;

    &:hover .mdt-icon-lg {
        opacity: 0;
    }

    &:hover .attach-image {
        background-color: rgba(0, 0, 0, 0.75);
    }

    &:hover #mdt-add-image {
        opacity: 1;
    }
}

.mdt-icon-lg {
    transition: all 0.2s ease-in-out;

    position: relative;
    color: $textColorHover;
    font-size: 5rem;
    top: 50%;
    transform: translateY(-50%);
}

#mdt-add-image {
    width: 100%;
    transition: all 0.2s ease-in-out;
    top: 50%;
    transform: translateY(-50%);
    opacity: 0;
}

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
    .form-control,
    .form-select {
        color: $textColor !important;
        border-color: $primaryColorLight !important;
        background-color: $primaryColorLightHover !important;
    }

    ::placeholder {
        color: $formPlaceholderText;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: $secondaryColor !important;
        box-shadow: 0 0 0 0.1rem $secondaryColorHover;
    }
}
</style>
