<template>
    <div id="view-report" class="container-fluid fade" v-if="record">
        <AffirmationModal @affirmation-cb="DeleteEntry" :parentElId="'view-report'" :show="modalData.Affirmation.show"
            :bodyText="modalData.Affirmation.data" :id="'delete-report-affirmation'" />

        <div class="row justify-content-md-center mb-3">
            <div class="col h4 text-center">
                <template v-if="record.type.toLowerCase() == 'incident'">
                    {{ $store.getters.GetTranslation('viewreport', 'title_1') }}
                </template>

                <template v-else-if="record.type.toLowerCase() == 'arrest'">
                    {{ $store.getters.GetTranslation('viewreport', 'title_2') }}
                </template>
            </div>
        </div>

        <div class="row justify-content-md-center mdt-form">
            <div class="col-4 col-xxl-3 h6 text-center">
                <div class="form-control fw-bold">
                    {{
                    `${$store.getters.GetTranslation('viewreport', 'col_ref')} ${FormatNumber(record.id)}`
                    }}
                </div>
            </div>

            <div class="col-4 col-xxl-3 h6 text-center">
                <div class="form-control fw-bold">
                    {{
                    `${$store.getters.GetTranslation('viewreport', 'col_date')} ${FormatDate(record.date,
                    true)}`
                    }}
                </div>
            </div>

            <div class="col-4 col-xxl-3 h6 text-center">
                <div class="form-control fw-bold">
                    {{
                    `${$store.getters.GetTranslation('viewreport', 'col_sub')} ${record.input.submittedBy}`
                    }}
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-10">
                <div class="mdt-profiles-container pt-1 pb-3">
                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('viewreport', 'col_name') }}
                            </label>
                            <input class="form-control" type="text" :value="record.input.subjectName" readonly />
                        </div>

                        <template v-if="record.input.incidentResult.length > 0">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewreport', 'col_inres') }}
                                </label>
                                <input class="form-control" type="text" :value="record.input.incidentResult" readonly />
                            </div>
                        </template>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label class="col-form-label">
                                <template v-if="record.type.toLowerCase() == 'incident'">
                                    {{ $store.getters.GetTranslation('viewreport', 'col_location_1') }}
                                </template>
                                <template v-else-if="record.type.toLowerCase() == 'arrest'">
                                    {{ $store.getters.GetTranslation('viewreport', 'col_location_2') }}
                                </template>
                            </label>
                            <input class="form-control" type="text" :value="record.input.location" readonly />
                        </div>

                        <div class="col-5">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('viewreport', 'col_des') }}
                            </label>
                            <input class="form-control" type="text" :value="record.input.briefDescription" readonly />
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-10">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('viewreport', 'col_leo') }}
                            </label>
                            <input class="form-control" type="text"
                                :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                :value="record.input.lawEnforcementInvolved" readonly />
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-3">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('viewreport', 'col_people') }}
                            </label>
                            <textarea class="form-control" rows="3"
                                :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                :value="record.input.individualsInvolved" readonly />
                        </div>

                        <div class="col-4">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('viewreport', 'col_vehicles') }}
                            </label>
                            <textarea class="form-control" rows="3"
                                :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                :value="record.input.vehicleInvolved" readonly />
                        </div>

                        <div class="col-3">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('viewreport', 'col_evidence') }}
                            </label>
                            <textarea class="form-control" rows="3"
                                :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                :value="record.input.evidence" readonly />
                        </div>
                    </div>

                    <template v-if="record.input.charges.length > 0">
                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-10">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewreport', 'col_charges') }}
                                </label>
                                <textarea class="form-control" rows="4"
                                    :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                    :value="record.input.charges" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2" v-if="record.data.total.fines > 0">
                            <div class="col-3">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewreport', 'col_fines') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                    :value="record.input.totalFines" readonly />
                            </div>

                            <div class="col-2">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewreport', 'col_due') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                    :value="record.input.dueDate" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewreport', 'col_finereduc') }}
                                </label>
                                <input class="form-control" :class="{'fw-bold': record.input.fineReduction.length > 0}"
                                    type="text" :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                    :value="record.input.fineReduction" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2" v-if="record.data.total.jail > 0">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewreport', 'col_jail') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                    :value="record.input.totalJail" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewreport', 'col_jailreduc') }}
                                </label>
                                <input class="form-control" :class="{'fw-bold': record.input.jailReduction.length > 0}"
                                    type="text" :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                    :value="record.input.jailReduction" readonly />
                            </div>
                        </div>
                    </template>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-10">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('viewreport', 'col_details') }}
                            </label>
                            <textarea class="form-control" rows="6"
                                :placeholder="$store.getters.GetTranslation('viewreport', 'none')"
                                :value="record.input.details" readonly />
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-10 pb-3">
                            <label class="col-form-label">
                                {{ $store.getters.GetTranslation('viewreport', 'col_imgs') }}
                            </label>
                            <div class="row attached-images p-3" style="border-radius: 3px; min-height: 100px;">
                                <template v-if="record.data.submittedImages.length == 0">
                                    <div class="row justify-content-md-center align-items-center mdt-form">
                                        <div class="col h6 text-center fw-bold">
                                            {{ $store.getters.GetTranslation('viewreport', 'no_imgs') }}
                                        </div>
                                    </div>

                                </template>

                                <template v-for="(data, index) in record.data.submittedImages"
                                    :key="index + '_attached_image'">
                                    <div class="col-6 col-xxl-4">
                                        <div class="card m-2" style="max-width: 18rem">
                                            <div class="card-header">
                                                <i class="fas fa-image me-1"></i>
                                                {{ FormatStringLength(data.name, 25) }}
                                            </div>

                                            <div class="card-body text-center">
                                                <div class="row d-flex align-items-center justify-content-md-center"
                                                    style="height: 100%;">
                                                    <Image :parentEl="parentElId" :img="data.img"
                                                        :id="`${index}_view_report`" :options="{
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
        </div>

        <div class="row justify-content-md-center text-center">
            <div class="col-4">
                <button type="button" class="btn grey-btn me-3" @click="GoBack()">
                    <i class="fas fa-caret-left"></i>
                    {{ $store.getters.GetTranslation('viewreport', 'back') }}
                </button>

                <template v-if="perms.edit">
                    <button type="button" class="btn blue-btn me-3" @click="StartEditing()">
                        {{ $store.getters.GetTranslation('viewreport', 'edit') }}
                    </button>
                </template>

                <template v-if="record.type.toLowerCase() == 'arrest'">
                    <button type="button" class="btn green-btn me-3" @click="OpenReportStash()">
                        <i class="fas fa-box"></i>
                        Report Stash
                    </button>
                </template>

                <template v-if="perms.delete">
                    <button type="button" class="btn red-btn" @click="ConfirmDeleteEntry()">
                        {{ $store.getters.GetTranslation('viewreport', 'delete') }}
                    </button>
                </template>
            </div>
        </div>
    </div>

    <template v-if="editing">
        <EditReport @stop-editing="StopEditing()" :parentElId="parentElId" :record="record" />
    </template>
</template>

<script>
import Image from "../Image";
import EditReport from "../Profiles/EditReport";
import AffirmationModal from "@/components/Modals/General/Affirmation";
import api from '@/api/main'

export default {
    name: "ViewReport",
    emits: ['go-back', 'go-back-refresh'],
    components: {
        Image,
        EditReport,
        AffirmationModal
    },
    props: ["parentElId", "record"],
    data() {
        return {
            editing: false,

            modalData: {
                Affirmation: {
                    data: '',
                    show: false,
                },
            },

            perms: {
                edit: false,
                delete: false,
            }
        }
    },
    mounted() {
        this.modalData.Affirmation.data = this.$store.getters.GetTranslation('viewreport', 'warning');
        this.CheckPerms();
    },
    methods: {
        CheckPerms() {
            let player = this.$store.getters.GetSelf()

            if (player) {
                const playerJob = player.job

                this.perms.edit = this.$store.getters.HasPerm(playerJob, 'reports', 'edit')
                this.perms.delete = this.$store.getters.HasPerm(playerJob, 'reports', 'delete')
            }
        },

        GoBack() {
            this.$emit('go-back')
        },

        ConfirmDeleteEntry() {
            this.modalData.Affirmation.show = true;

            setTimeout(() => {
                this.modalData.Affirmation.show = false;
            }, 200);
        },

        DeleteEntry(resp) {
            if ( resp ) {
                api.reports.DeleteRecordEntry(this.record.id)

                setTimeout(() => {
                    this.$emit('go-back', true)
                }, 200)
            }
        },

        StartEditing() {
            this.editing = true;

            setTimeout(() => {
                this.TransitionEl('view-report', 'edit-report')

                this.SendNotification(
                    this.$store.getters.GetTranslation('viewreport', 'editing'),
                    this.$store.getters.GetTranslation('viewreport', 'editing_msg'),
                    15000,
                    'alert',
                    true,
                    true
                );
            }, 10);
        },

        StopEditing() {
            this.TransitionEl('edit-report', 'view-report')

            setTimeout(() => {
                this.editing = true;
            }, 200);
        },

        OpenReportStash() {
            // Create unique stash ID based on report ID
            const stashId = `report_stash_${this.record.id}`;
            
            // Call server to create/open the stash
            api.reports.OpenReportStash(this.record.id, stashId);
            
            this.SendNotification(
                'Report Stash',
                `Opening stash for report ${this.FormatNumber(this.record.id)}`,
                3000,
                'success'
            );
        },

        TransitionEl(incoming, outgoing) {
            var incomingEl = document.getElementById(incoming);
            var outgoingEl = document.getElementById(outgoing);

            incomingEl.classList.remove("show");
            outgoingEl.style.display = 'none';
            setTimeout(() => {
                incomingEl.style.display = 'none';
                outgoingEl.style.display = 'block';

                setTimeout(() => {
                    outgoingEl.classList.add("show");

                    this.RefreshBS();
                }, 10);
            }, 150);
        },
    }
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
