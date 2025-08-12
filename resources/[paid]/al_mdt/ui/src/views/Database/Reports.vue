<template>
    <div id="database-reports" class="container fade show mt-3 p-3">
        <!-- Main Start -->
        <div class="row justify-content-md-center mb-4">
            <div class="col-4 h3 text-center">{{ $store.getters.GetTranslation('reports', 'title') }}</div>
        </div>

        <div class="container-fluid fade show" id="mdt-database-main">
            <div class="row justify-content-md-center mb-2">
                <div class="col-4 h4 text-center">{{ $store.getters.GetTranslation('reports', 'title_2') }}</div>
            </div>

            <div class="container col-xxl-7 col-xl-8 table-con boloTable">
                <ul class="nav nav-pills mb-3 justify-content-center" id="pills-tab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="db-report-create-tab" data-bs-toggle="pill"
                            data-bs-target="#db-report-create" type="button" role="tab" aria-controls="db-report-create"
                            aria-selected="true">
                            {{ $store.getters.GetTranslation('reports', 'title_3') }}
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="pills-tabContent">
                    <div class="tab-pane fade active show" id="db-report-create" role="tabpanel"
                        aria-labelledby="db-report-create-tab">
                        <div class="row justify-content-md-center">
                            <div class="col">
                                <div class="mt-3 mb-2 text-center">
                                    <button type="button" class="btn btn-sm blue-btn me-5"
                                        @click="OpenReportCreation(1)">
                                        {{ $store.getters.GetTranslation('reports', 'incident') }}
                                    </button>

                                    <button type="button" class="btn btn-sm blue-btn" @click="OpenReportCreation(2)">
                                        {{ $store.getters.GetTranslation('reports', 'arrest') }}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- If creating an incident report -->
        <template v-if="reportType !== 0">
            <ReportForm @transitionEl="TransitionEl" :parentName="'Database-Reports'" :reportType="reportType"
                :restoredData="restoredData" :type="reportType" />
        </template>

    </div>
</template>

<script>
// Modals
import ReportForm from "../../components/Modules/Reports/CreateReport";

export default {
    name: "Database-Reports",
    components: {
        ReportForm,
    },
    data() {
        return {
            restoredData: false,

            reportType: 0, // 0 = main menu | 1 = incident | 2 = arrest
        };
    },
    mounted() {
        this.RestoreData();
    },
    methods: {
        RestoreData() {
            let result = this.$store.getters.GetComponentData(this.$options.name);

            if (result) {
                this.restoredData = result.reportData; // Restore report data
                this.reportType = result.reportType; // Restore form
                this.TransitionEl('mdt-database-main', 'mdt-database-createReport');

                setTimeout(() => {
                    this.$store.commit('RemoveComponentData', { index: this.$options.name })

                    this.restoredData = false;
                }, 100);
            }
        },

        OpenReportCreation(type) {
            this.reportType = type;

            setTimeout(() => {
                this.TransitionEl('mdt-database-main', 'mdt-database-createReport');
            }, 10)
        },


        TransitionEl(incoming, outgoing) {
            setTimeout(() => {
                var incomingEl = document.getElementById(incoming);
                var outgoingEl = document.getElementById(outgoing);

                incomingEl.classList.remove("show");
                outgoingEl.style.display = 'none';
                setTimeout(() => {
                    incomingEl.style.display = 'none';
                    outgoingEl.style.display = 'block';

                    if ( this.reportType !== 0 && outgoing === 'mdt-database-main' ) {
                        this.reportType = 0
                    }

                    setTimeout(() => {
                        outgoingEl.classList.add("show");

                        this.RefreshBS();
                    }, 10);
                }, 150);
            }, 10);
        },
    },
};
</script>

<style lang="scss" scoped>
$primaryColor: #1d1f25;
$primaryColorLight: #2a2c34;
$primaryColorLightHover: #383a44;
$textColor: #ececec;
$textColorHover: #bfbfbf;

#database-reports {
    background-color: $primaryColorLight;
    border-radius: 5px;
}

.table-con {
    border: 10px $primaryColorLightHover solid;
    border-radius: 5px;
    background-color: $primaryColorLightHover;
}
</style>
