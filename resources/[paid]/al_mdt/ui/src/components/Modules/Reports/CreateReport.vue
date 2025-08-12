<template>
    <div class="container-fluid fade" id="mdt-database-createReport">
        <!-- Modals -->
        <SearchCharacterModal @found-character="SetCharData" :parentElId="'mdt-database-createReport'"
            :id="'mdt-database-create-report-search-char'" :show="modalData.SearchChar.show" />

        <CriminalCode @update-charges="UpdateCharges" :parentElId="'mdt-database-createReport'"
            :show="modalData.CriminalCode.show" :restoredData="restoredCriminalCharges" />

        <AddImage @submit-image="AddImage" :parentElId="'mdt-database-createReport'" :show="modalData.AddImage.show"
            :options="{
                label: true,
            }" />

        <AffirmationModal @affirmation-cb="DeleteImage" :parentElId="'mdt-database-createReport'"
            :show="modalData.Affirmation.show" :bodyText="modalData.Affirmation.data" />

        <SelectPoliceModal @update-selected="UpdateSelectedPolice" :parentElId="'mdt-database-createReport'"
            :show="modalData.SelectPolice.show" :restoredData="restoredPolice" />

        <div class="row justify-content-md-center mb-2">
            <div class="col-4 h4 text-center">
                <template v-if="reportData.type.toLowerCase() == 'incident'">
                    {{ $store.getters.GetTranslation('createreport', 'title_1') }}
                </template>

                <template v-else-if="reportData.type.toLowerCase() == 'arrest'">
                    {{ $store.getters.GetTranslation('createreport', 'title_2') }}
                </template>
            </div>
        </div>

        <div class="row justify-content-center mdt-form mt-2">
            <div class="col-5">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_name') }}
                    <span class="mdt_required" title="Required">*</span>
                </label>

                <div class="input-group">
                    <button class="btn btn-sm blue-btn" type="button" @click="SearchForCharacter()">
                        {{ $store.getters.GetTranslation('createreport', 'select') }}
                    </button>
                    <input type="text" class="form-control"
                        :placeholder="$store.getters.GetTranslation('createreport', 'ph_name')"
                        v-model="reportData.input.subjectName" readonly />
                </div>
            </div>

            <div class="col-5" v-if="type === 1">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_inres') }}
                    <span class="mdt_required" title="Required">*</span>
                </label>

                <div class="input-group">
                    <button class="btn blue-btn btn-sm dropdown-toggle" type="button" id="incidentResultDropdown"
                        data-bs-toggle="dropdown" aria-expanded="false"
                        @click="ToggleDropdown('incidentResultDropdown')">
                        {{ $store.getters.GetTranslation('createreport', 'select') }}
                    </button>
                    <ul class="dropdown-menu">
                        <li v-for="type in $store.state.config.incidentResultTypes" :key="type + '_incidentType'">
                            <a class="dropdown-item" href="#" @click="UpdateIncidentResult(type)">
                                {{ type }}
                            </a>
                        </li>
                    </ul>
                    <input type="text" class="form-control"
                        :placeholder="$store.getters.GetTranslation('createreport', 'ph_inres')"
                        aria-label="Incident result" v-model="reportData.input.incidentResult" readonly />
                </div>
            </div>
        </div>

        <div class="row justify-content-center mdt-form mt-2">
            <div class="col-5">
                <label class="col-form-label">
                    <template v-if="reportData.type.toLowerCase() == 'incident'">
                        {{ $store.getters.GetTranslation('createreport', 'col_location_1') }}
                    </template>
                    <template v-else-if="reportData.type.toLowerCase() == 'arrest'">
                        {{ $store.getters.GetTranslation('createreport', 'col_location_2') }}
                    </template>
                    <span class="mdt_required" title="Required">*</span>
                </label>
                <input class="form-control" type="text"
                    :placeholder="$store.getters.GetTranslation('createreport', 'ph_location')"
                    aria-label="Location of incident" v-model="reportData.input.location" />
            </div>

            <div class="col-5">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_des') }}
                    <span class="mdt_required" title="Required">*</span>
                </label>
                <input class="form-control" type="text"
                    :placeholder="$store.getters.GetTranslation('createreport', 'ph_des')"
                    aria-label="Brief description" v-model="reportData.input.briefDescription" />
            </div>
        </div>

        <div class="row justify-content-center mdt-form mt-2">
            <div class="col-10">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_leo') }}
                </label>
                <div class="input-group">
                    <button class="btn blue-btn btn-sm" type="button" @click="SelectPolice()">
                        {{ $store.getters.GetTranslation('createreport', 'select') }}
                    </button>

                    <input type="text" class="form-control"
                        :placeholder="$store.getters.GetTranslation('createreport', 'ph_leo')"
                        aria-label="Law enforcement involved" v-model="reportData.input.lawEnforcementInvolved" />
                </div>
            </div>
        </div>

        <div class="row justify-content-center mdt-form mt-2">
            <div class="col-3">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_people') }}
                </label>
                <textarea class="form-control" :placeholder="$store.getters.GetTranslation('createreport', 'ph_people')"
                    rows="3" v-model="reportData.input.individualsInvolved"></textarea>
            </div>

            <div class="col-4">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_vehicles') }}
                </label>
                <textarea class="form-control"
                    :placeholder="$store.getters.GetTranslation('createreport', 'ph_vehicles')" rows="3"
                    v-model="reportData.input.vehicleInvolved"></textarea>
            </div>

            <div class="col-3">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_evidence') }}
                </label>
                <textarea class="form-control"
                    :placeholder="$store.getters.GetTranslation('createreport', 'ph_evidence')" rows="3"
                    v-model="reportData.input.evidence"></textarea>
            </div>
        </div>

        <div class="row justify-content-center mdt-form mt-2">
            <div class="col-10">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_charges') }}
                    <button class="btn blue-btn btn-sm ms-1" type="button" @click="ShowCriminalCode()">
                        {{ $store.getters.GetTranslation('createreport', 'select') }}
                    </button>
                </label>
                <textarea class="form-control"
                    :placeholder="$store.getters.GetTranslation('createreport', 'ph_charges')" rows="4"
                    v-model="reportData.input.charges" readonly></textarea>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col text-center" style="font-size: 0.8rem">
                <i class="fas fa-info-circle"></i>
                {{ $store.getters.GetTranslation('createreport', 'warning') }}
            </div>
        </div>

        <div class="row justify-content-center mdt-form mt-2" v-if="reportData.data.total.fines > 0">
            <div class="col-3">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_fines') }}
                </label>
                <input class="form-control" type="text" v-model="reportData.input.totalFines"
                    @focus="TogglePunishmentInputEdit('fine', true)" @blur="TogglePunishmentInputEdit('fine', false)" />
            </div>

            <div class="col-2">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_due') }}
                    <span class="mdt_required" title="Required">*</span>
                </label>
                <input class="form-control" type="text"
                    :placeholder="$store.getters.GetTranslation('createreport', 'ph_due')"
                    v-model="reportData.input.dueDate" />
            </div>

            <div class="col-5">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_finereduc') }}
                </label>
                <div class="input-group">
                    <button class="btn blue-btn btn-sm dropdown-toggle" type="button" id="fineReductiontDropdown"
                        data-bs-toggle="dropdown" aria-expanded="false"
                        @click="ToggleDropdown('fineReductiontDropdown')">
                        {{ $store.getters.GetTranslation('createreport', 'select') }}
                    </button>
                    <ul class="dropdown-menu">
                        <template v-if="reportData.data.criminalCharges.length > 0">
                            <a class="dropdown-item" href="#"
                                @click=" UpdateReduction('fine', reportData.data.total.fines) ">{{
                                `${$store.getters.GetTranslation('createreport',
                                'fine_reduc_none')}${FormatNumber(reportData.data.total.fines)}` }}</a>

                            <template v-for="data in fineReductions" :key="`${data.reduce.toString()}_fine_reductions`">
                                <a class="dropdown-item" href="#"
                                    @click="UpdateReduction('fine', parseInt(reportData.data.total.fines * (1 - data.reduce), 10))">
                                    {{ `${data.label} ${$store.getters.GetTranslation('createreport',
                                    'fine_reduc')}${FormatNumber(parseInt(reportData.data.total.fines *
                                    (1 - data.reduce),10))}` }}
                                </a>
                            </template>
                        </template>

                        <template v-else>
                            <li class="dropdown-item">
                                {{ $store.getters.GetTranslation('createreport', 'no_finereduc') }}
                            </li>
                        </template>
                    </ul>

                    <input type="text" class="form-control"
                        :class="{ 'fw-bold': reportData.input.fineReduction.length > 0 }"
                        :placeholder="$store.getters.GetTranslation('createreport', 'ph_optional')"
                        aria-label="Law enforcement involved" v-model="reportData.input.fineReduction" readonly />
                </div>
            </div>
        </div>

        <div class="row justify-content-center mdt-form mt-2" v-if="reportData.data.total.jail > 0">
            <div class="col-5">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_jail') }}
                </label>
                <input class="form-control" type="text" v-model="reportData.input.totalJail"
                    @focus="TogglePunishmentInputEdit('jail', true)" @blur="TogglePunishmentInputEdit('jail', false)" />

                <template v-if="$store.state.config.General.JailButton">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="jailCheck"
                            v-model="jailButton.toggle">
                        <label class="form-check-label" for="jailCheck">
                            {{ $store.getters.GetTranslation('createreport', 'jail_btn') }}
                        </label>
                    </div>
                </template>
            </div>

            <div class="col-5">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_jailreduc') }}
                </label>
                <div class="input-group">
                    <button class="btn blue-btn btn-sm dropdown-toggle" type="button" id="jailReductionDropdown"
                        data-bs-toggle="dropdown" aria-expanded="false"
                        @click="ToggleDropdown('jailReductionDropdown')">
                        {{ $store.getters.GetTranslation('createreport', 'select') }}
                    </button>
                    <ul class="dropdown-menu">
                        <template v-if="reportData.data.criminalCharges.length > 0">
                            <a class="dropdown-item" href="#"
                                @click=" UpdateReduction('jail', reportData.data.total.jail) ">
                                {{ `${$store.getters.GetTranslation('createreport', 'jail_reduc_none') } ${FormatNumber(
                                reportData.data.total.jail)} ${$store.getters.GetTranslation('createreport',
                                'jail_reduc_format')}` }}
                            </a>

                            <template v-for="data in fineReductions" :key="`${data.reduce.toString()}_jail_reductions`">
                                <a class="dropdown-item" href="#"
                                    @click=" UpdateReduction('jail', parseInt( reportData.data.total.jail * (1 - data.reduce), 10 ))">
                                    {{ `${data.label} ${$store.getters.GetTranslation('createreport', 'jail_reduc') }
                                    ${FormatNumber(parseInt(reportData.data.total.jail *
                                    (1 - data.reduce), 10))} ${$store.getters.GetTranslation('createreport',
                                    'jail_reduc_format')}` }}
                                </a>
                            </template>
                        </template>

                        <template v-else>
                            <li class="dropdown-item">
                                {{ $store.getters.GetTranslation('createreport', 'no_jailreduc') }}
                            </li>
                        </template>
                    </ul>
                    <input type="text" class="form-control"
                        :class="{ 'fw-bold': reportData.input.jailReduction.length > 0, }"
                        :placeholder="$store.getters.GetTranslation('createreport', 'ph_optional')"
                        aria-label="Law enforcement involved" v-model="reportData.input.jailReduction" readonly />
                </div>
            </div>
        </div>

        <template v-if="$store.state.config.General.JailButton && reportData.data.total.jail > 0">
            <div class="row justify-content-center mdt-form mt-2"
                v-if="jailButton.toggle && $store.state.config.General.JailReason">
                <div class="col-10">
                    <label class="col-form-label">
                        {{ $store.getters.GetTranslation('createreport', 'col_jailreason') }}
                        <span class="mdt_required" title="Required">*</span>
                    </label>
                    <input type="text" class="form-control"
                        :placeholder="$store.getters.GetTranslation('createreport', 'ph_jailreason')"
                        aria-label="Jail reason" v-model="jailButton.reason" />
                </div>
            </div>
        </template>

        <div class="row justify-content-center mdt-form mt-2">
            <div class="col-10">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_details') }}
                </label>
                <textarea class="form-control"
                    :placeholder="$store.getters.GetTranslation('createreport', 'ph_details')" rows="6"
                    v-model="reportData.input.details"></textarea>
            </div>
        </div>

        <div class="row justify-content-center mdt-form mt-2">
            <div class="col-10 pb-3">
                <label class="col-form-label">
                    {{ $store.getters.GetTranslation('createreport', 'col_imgs') }}
                </label>
                <div class="row attached-images p-3" style="border-radius: 3px">
                    <div class="col-6 col-xxl-4">
                        <div class="card m-2" style="max-width: 18rem">
                            <div class="card-header">
                                <i class="fas fa-images me-1"></i>
                                {{ $store.getters.GetTranslation('createreport', 'attch_img') }}
                            </div>

                            <div class="card-body text-center attach-image">
                                <i class="fas fa-plus mdt-icon-lg"></i>

                                <div id="mdt-add-image" class="container-fluid">
                                    <div class="row justify-content-md-center mb-2">
                                        <div class="h6 text-center">
                                            {{ $store.getters.GetTranslation('createreport', 'img_info') }}
                                        </div>
                                    </div>

                                    <button class="btn blue-btn btn-sm" type="button" @click="ShowAddImageModal()">
                                        {{ $store.getters.GetTranslation('createreport', 'add') }}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <template v-for="(data, index) in reportData.data.submittedImages" :key="index + '_attached_image'">
                        <div class="col-6 col-xxl-4">
                            <div class="card m-2" style="max-width: 18rem">
                                <div class="card-header">
                                    <i class="fas fa-image me-1"></i>
                                    {{ FormatStringLength(data.name, 25) }}

                                    <span class="float-end mdt-color-red">
                                        <i class="fas fa-times-circle" @click="DeleteImageConfirmation(index)"></i>
                                    </span>
                                </div>

                                <div class="card-body text-center">
                                    <div class="row d-flex align-items-center justify-content-md-center"
                                        style="height: 100%;">
                                        <Image :parentEl="'mdt-database-createReport'" :img="data.img"
                                            :id="`${index}_img`" :options="{
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

        <div class="row justify-content-center mdt-form mt-3">
            <div class="col-4 text-center">
                <button type="button" class="btn red-btn me-3" @click="Transition()">
                    {{ $store.getters.GetTranslation('createreport', 'discard') }}
                </button>
                <button type="button" class="btn green-btn me-3" @click="SubmitEntry()">Submit</button>
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

import api from '@/api/main'

import { Dropdown } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "Report-Form",
    emits: ["transitionEl"],
    components: {
        SearchCharacterModal,
        CriminalCode,
        AddImage,
        AffirmationModal,
        Image,
        SelectPoliceModal,
    },
    props: ["parentName", "reportType", "restoredData", "type"],
    data() {
        return {
            jailButton: {
                toggle: false,
                reason: '',
            },

            reportData: {
                type: "",

                input: {
                    submittedBy: "",

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
                    criminalChargesMetadata: {},

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

            restoredCriminalCharges: false,

            restoredPolice: false,

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
                    show: false,
                },
            },
        };
    },
    mounted() {
        this.reportData.type = this.type === 1 ? 'incident' : 'arrest'
        this.modalData.Affirmation.data = this.$store.getters.GetTranslation('createreport', 'img_del')
        this.jailButton.toggle = this.$store.state.config.General.JailButtonActiveDefault

        // Custom event listener for chaning tabs
        var app = document.getElementById("app");
        app.addEventListener("changingTab", this.saveData);

        // Restore data
        if (this.restoredData) {
            this.reportData = this.restoredData;

            // Restore criminal charges (Modal data)
            this.restoredCriminalCharges = {
                list: this.reportData.data.criminalCharges,
                metaData: this.reportData.data.criminalChargesMetadata,
            }

            this.restoredPolice = this.reportData.data.lawEnforcement
        }
    },
    unmounted() {
        // If unmounted (meaning exiting form) remove save data listener
        var app = document.getElementById("app");
        app.removeEventListener("changingTab", this.saveData);
    },
    methods: {
        SubmitEntry() {
            if (this.ValidateRequiredFields()) {
                const currentDate = Date.now()
                const self = this.$store.getters.GetSelf()
                this.reportData.data.dueDate = (Date.now() + (parseInt(this.reportData.input.dueDate) * 86400000))

                this.reportData.input.submittedBy = self.callsign.length > 0 ? `${self.callsign} - ${self.name}` : self.name
                let entry = {
                    type: this.reportData.type.charAt(0).toUpperCase() + this.reportData.type.slice(1), // Capitalize first letter
                    date: currentDate,
                    description: this.reportData.input.briefDescription,
                    input: this.reportData.input,
                    data: this.reportData.data,
                    submittedBy: self.identifier
                }

                api.reports.AddRecordEntry({
                    identifier: this.reportData.data.charData.identifier,
                    entry: entry,
                })

                if (this.jailButton.toggle) {
                    var jailTime = 0

                    if ( this.reportData.data.total.jail > 0 ) {
                        if (this.reportData.input.jailReduction.length > 0 ) {
                            jailTime = this.reportData.data.total.jailReduction;
                        } else {
                            jailTime = this.reportData.data.total.jail;
                        }

                        api.reports.JailPlayer(
                            this.reportData.data.charData.identifier, // Identifier
                            this.$store.state.config.General.JailReason ? this.jailButton.reason : false, // Jail reason
                            jailTime, // Jail time
                        )
                    }
                }

                this.SendNotification(
                    this.$store.getters.GetTranslation('createreport', 'submitted'),
                    this.$store.getters.GetTranslation('createreport', 'submitted_msg'),
                    7500,
                    'success',
                    false,
                    false
                );

                this.Transition()
            }
        },
        ValidateRequiredFields() {
            if (
                this.reportData.input.subjectName.length > 0 && // Name
                (this.type === 1 && this.reportData.input.incidentResult.length || this.type !== 1) > 0 && // Incident result
                this.reportData.input.location.length > 0 && // Location
                this.reportData.input.briefDescription.length > 0 && // Description
                (
                    this.reportData.data.total.fines === 0 ||
                    (
                        this.reportData.data.total.fines > 0 &&
                        this.reportData.input.dueDate.length > 0 &&
                        (this.reportData.input.dueDate.match(/^[0-9]+$/) != null) // Checks if the str is just numbers
                    )
                ) && // Fine due date
                (this.jailButton.toggle && this.$store.state.config.General.JailReason && this.jailButton.reason.length > 0 || !this.jailButton.toggle || !this.$store.state.config.General.JailReason) // Jail button
            ) {
                return true
            } else {
                if (
                    this.reportData.data.total.fines > 0 &&
                    this.reportData.input.dueDate.length > 0 &&
                    (this.reportData.input.dueDate.match(/^[0-9]+$/) == null)
                ) {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('createreport', 'error_5'),
                        this.$store.getters.GetTranslation('createreport', 'error_5_msg'),
                        7500,
                        'error',
                        false,
                        true
                    );
                } else if (this.jailButton.toggle && this.$store.state.config.General.JailReason && this.jailButton.reason.length === 0) {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('createreport', 'error_4'),
                        this.$store.getters.GetTranslation('createreport', 'error_4_msg'),
                        7500,
                        'error',
                        false,
                        true
                    );
                } else {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('createreport', 'error_3'),
                        this.$store.getters.GetTranslation('createreport', 'error_3_msg'),
                        7500,
                        'error',
                        false,
                        true
                    );
                }
                return false
            }
        },
        UpdateReduction(type, total) {
            if (type == "fine") {
                if (total == this.reportData.data.total.fines) {
                    this.reportData.input.fineReduction = "";
                } else {
                    this.reportData.data.total.fineReduction = total;
                    this.reportData.input.fineReduction = `${this.$store.getters.GetTranslation('createreport', 'fine_reduction') }${this.FormatNumber(total)}`;
                }
            } else if (type == "jail") {
                if (total == this.reportData.data.total.jail) {
                    this.reportData.input.jailReduction = "";
                } else {
                    this.reportData.data.total.jailReduction = total;
                    this.reportData.input.jailReduction = `${this.$store.getters.GetTranslation('createreport', 'jail_reduction_1')} ${total.toString()} ${this.$store.getters.GetTranslation('createreport', 'jail_reduction_2') }`;
                }
            }
        },
        UpdateFineTotal() {
            let fines = 0;
            let jail = 0;

            this.reportData.data.criminalCharges.forEach((val) => {
                fines += val.data.punishment.fine * val.data.count;
                jail += val.data.punishment.time * val.data.count;
            });

            this.reportData.data.total.fines = fines;
            this.reportData.data.total.jail = jail;

            this.reportData.input.totalFines = `${this.$store.getters.GetTranslation('createreport', 'fine_money')}${this.FormatNumber(this.reportData.data.total.fines)}`;
            this.reportData.input.totalJail = `${this.reportData.data.total.jail.toString()} ${this.$store.getters.GetTranslation('createreport', 'jail_reduction_2')}`;
        },
        UpdateCharges(charges, str, selectedChargesData) {
            if (charges) {
                this.reportData.data.criminalCharges = charges;
                this.reportData.data.criminalChargesMetadata = selectedChargesData;

                if ( this.restoredCriminalCharges ) {
                    this.restoredCriminalCharges = false;
                }

                this.reportData.input.charges = str;
            } else {
                this.reportData.data.criminalCharges = [];
                this.reportData.input.charges = "";
            }

            this.UpdateFineTotal();
        },
        TogglePunishmentInputEdit(type, state) {
            if ( state ) {
                if ( type === 'fine' ) {
                    const newInput = this.reportData.data.total.fines.toString()
                    this.reportData.input.totalFines = newInput
                } else if ( type === 'jail' ) {
                    const newInput =  this.reportData.data.total.jail.toString()
                    this.reportData.input.totalJail = newInput
                }
            } else {
                if ( type === 'fine' ) {
                    const newInput = this.reportData.input.totalFines

                    if (newInput > 0) {
                        this.reportData.data.total.fines = parseInt(newInput) // New fine amount
                    } else {
                        this.SendNotification(
                            this.$store.getters.GetTranslation('createreport', 'error_2'),
                            this.$store.getters.GetTranslation('createreport', 'error_2_msg'),
                            7500,
                            'error',
                            false,
                            true
                        );
                    }

                    this.reportData.input.totalFines = `${this.$store.getters.GetTranslation('createreport', 'fine_money') }${this.FormatNumber(this.reportData.data.total.fines)}`;
                } else if ( type === 'jail' ) {
                    const newInput = this.reportData.input.totalJail

                    if (newInput > 0) {
                        this.reportData.data.total.jail = parseInt(newInput) // Update jail time
                    } else {
                        this.SendNotification(
                            this.$store.getters.GetTranslation('createreport', 'error_1'),
                            this.$store.getters.GetTranslation('createreport', 'error_1_msg'),
                            7500,
                            'error',
                            false,
                            true
                        );
                    }

                    this.reportData.input.totalJail = `${this.reportData.data.total.jail.toString()} ${this.$store.getters.GetTranslation('createreport', 'jail_reduction_2') }`;
                }
            }
        },

        saveData() {
            // Data to be saved
            this.$store.commit('SaveComponentData', {
                index: this.parentName,
                data: {
                    reportData: this.reportData,
                    reportType: this.reportType,
                }
            })
            document.getElementById("app").removeEventListener("changingTab", this.saveData); // Remove this listener from triggering in other tabs
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
            if ( this.restoredPolice ) {
                this.restoredPolice = false;
            }

            this.reportData.data.lawEnforcement = arry
            this.reportData.input.lawEnforcementInvolved = str
        },

        Transition() {
            this.$emit("transitionEl", 'mdt-database-createReport', 'mdt-database-main');
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
