<template>
    <div id="database-view-reports" class="container mt-3 p-3">
        <SelectOfficer @select-officer="SelectOfficer" :parentElId="'database-view-reports'"
            :show="modalData.SelectOfficer.show" />

        <div id="recent-reports-con" class="fade show">
            <div class="row justify-content-md-center mb-4">
                <div class="col-4 h3 text-center">{{ $store.getters.GetTranslation('view', 'title') }}</div>
            </div>

            <div class="row justify-content-center">
                <div class="col-5">
                    <div class="row justify-content-md-center mb-2">
                        <div class="col h5 text-center">{{ $store.getters.GetTranslation('view', 'self_submit') }}</div>
                    </div>

                    <div class="mdtTable p-2">
                        <table class="table text-center">
                            <thead>
                                <tr>
                                    <th scope="col" style="width: 10%">
                                        {{ $store.getters.GetTranslation('view', 'col_id') }}
                                    </th>
                                    <th scope="col" style="width: 15%">
                                        {{ $store.getters.GetTranslation('view', 'col_type') }}
                                    </th>
                                    <th scope="col" style="width: 65%">
                                        {{ $store.getters.GetTranslation('view', 'col_des') }}
                                    </th>
                                    <th scope="col" style="width: 20%">
                                        {{ $store.getters.GetTranslation('view', 'col_act') }}
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <template v-for="report in selfRecentReports" :key="report.id">
                                    <tr>
                                        <th>{{ FormatNumber(report.id) }}</th>
                                        <td>
                                            <template v-if="report.type == 'Arrest'">
                                                {{ $store.getters.GetTranslation('view', 'type_arrest') }}
                                            </template>

                                            <template v-else-if="report.type == 'Incident'">
                                                {{ $store.getters.GetTranslation('view', 'type_incident') }}
                                            </template>
                                        </td>
                                        <td>
                                            {{ FormatStringLength(report.description, 40) }}
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm blue-btn"
                                                @click="ViewReport(report.id)">
                                                {{ $store.getters.GetTranslation('view', 'view') }}
                                            </button>
                                        </td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>

                        <template v-if="selfRecentReports.length <= 0 && !loading">
                            <div class="h6 text-center">
                                {{ $store.getters.GetTranslation('view', 'no_results') }}
                            </div>
                        </template>
                    </div>
                </div>
            </div>

            <div class="row justify-content-center mt-4">
                <div class="col-10">
                    <div class="row justify-content-md-center mb-2">
                        <div class="col h5 text-center">{{ $store.getters.GetTranslation('view', 'title_2') }}</div>
                    </div>

                    <div class="mdtTable p-2">
                        <div class="row justify-content-md-center">
                            <div class="col h6 text-center">{{ $store.getters.GetTranslation('view', 'filter') }}
                            </div>
                        </div>

                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-3 text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('view', 'search_id') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('view', 'ph_search_id')"
                                    v-model="inputFields.id" />
                            </div>

                            <div class="col-3 text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('view', 'search_name') }}
                                </label>
                                <div class="input-group">
                                    <button class="btn blue-btn btn-sm" type="button" @click="ShowOfficerSelect()">
                                        {{ $store.getters.GetTranslation('view', 'select') }}
                                    </button>
                                    <input type="text" class="form-control"
                                        :placeholder="$store.getters.GetTranslation('view', 'ph_search_name')"
                                        :value="inputFields.name" readonly />
                                </div>
                            </div>

                            <div class="col-3 text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('view', 'search_type') }}
                                </label>
                                <div class="input-group">
                                    <button class="btn blue-btn btn-sm dropdown-toggle" type="button"
                                        id="searchTypeDropdown" data-bs-toggle="dropdown" aria-expanded="false"
                                        @click="ToggleDropdown('searchTypeDropdown')">
                                        {{ $store.getters.GetTranslation('view', 'select') }}
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a class="dropdown-item" href="#" @click="inputFields.type = ''">
                                                {{ $store.getters.GetTranslation('view', 'type_none') }}
                                            </a>
                                            <a class="dropdown-item" href="#" @click="inputFields.type = 'Incident'">
                                                {{ $store.getters.GetTranslation('view', 'type_incident') }}
                                            </a>
                                            <a class="dropdown-item" href="#" @click="inputFields.type = 'Arrest'">
                                                {{ $store.getters.GetTranslation('view', 'type_arrest') }}
                                            </a>
                                        </li>
                                    </ul>
                                    <input type="text" class="form-control"
                                        :placeholder="$store.getters.GetTranslation('view', 'ph_search_type')"
                                        :value="inputFields.type" readonly />
                                </div>
                            </div>

                            <div class="row justify-content-center mt-3 mb-4">
                                <div class="col text-center">
                                    <button class="btn btn-sm green-btn me-2" type="button" @click="SearchRefresh()">
                                        {{ $store.getters.GetTranslation('view', 'search') }}
                                    </button>

                                    <button class="btn btn-sm red-btn" type="button" @click="ClearAndRefresh()">
                                        {{ $store.getters.GetTranslation('view', 'clear') }}
                                    </button>
                                </div>
                            </div>
                        </div>

                        <table class="table text-center">
                            <thead>
                                <tr>
                                    <th scope="col" style="width: 10%">
                                        {{ $store.getters.GetTranslation('view', 'col_id') }}
                                    </th>
                                    <th scope="col" style="width: 10%">
                                        {{ $store.getters.GetTranslation('view', 'col_type') }}
                                    </th>
                                    <th scope="col" style="width: 30%">
                                        {{ $store.getters.GetTranslation('view', 'col_des') }}
                                    </th>
                                    <th scope="col" style="width: 20%">
                                        {{ $store.getters.GetTranslation('view', 'col_sub') }}
                                    </th>
                                    <th scope="col" style="width: 20%">
                                        {{ $store.getters.GetTranslation('view', 'col_date') }}
                                    </th>
                                    <th scope="col" style="width: 10%">
                                        {{ $store.getters.GetTranslation('view', 'col_act') }}
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <template v-for="report in pagination.reports.list" :key="report.id">
                                    <tr>
                                        <th>{{ FormatNumber(report.id) }}</th>
                                        <td>
                                            <template v-if="report.type == 'Arrest'">
                                                {{ $store.getters.GetTranslation('view', 'type_arrest') }}
                                            </template>

                                            <template v-else-if="report.type == 'Incident'">
                                                {{ $store.getters.GetTranslation('view', 'type_incident') }}
                                            </template>
                                        </td>
                                        <td>
                                            {{ FormatStringLength(report.description, 80) }}
                                        </td>
                                        <td>
                                            {{ report.submittedBy }}
                                        </td>
                                        <td>
                                            {{ FormatDate(report.date, true) }}
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm blue-btn"
                                                @click="ViewReport(report.id)">
                                                {{ $store.getters.GetTranslation('view', 'view') }}
                                            </button>
                                        </td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <div class="row" v-if="pagination.reports.list.length > 0">
                            <div class="col">
                                <nav aria-label="Page navigation example">
                                    <ul class="pagination justify-content-center">
                                        <!-- First -->
                                        <li class="page-item"
                                            :class="{ disabled: pagination.reports.currentPage === 1 }">
                                            <a class="page-link" href="#" @click="RefreshPage(1)">
                                                <i class="fas fa-angle-double-left"></i>
                                            </a>
                                        </li>

                                        <!-- Pages -->
                                        <template
                                            v-for="page in Pagination(pagination.reports.currentPage, pagination.reports.totalPages)"
                                            :key="page">
                                            <li class="page-item"
                                                :class="{ active: pagination.reports.currentPage === page }">
                                                <a class="page-link" href="#" @click="RefreshPage(page)">
                                                    {{ page }}
                                                </a>
                                            </li>
                                        </template>

                                        <!-- Last -->
                                        <li class="page-item"
                                            :class="{ disabled: pagination.reports.currentPage === pagination.reports.totalPages }">
                                            <a class="page-link" href="#"
                                                @click="RefreshPage(pagination.reports.totalPages)">
                                                <i class="fas fa-angle-double-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>

                        <template v-if="pagination.reports.list.length <= 0 && !loading">
                            <div class="h6 text-center">
                                {{ $store.getters.GetTranslation('view', 'no_results') }}
                            </div>
                        </template>
                    </div>
                </div>
            </div>
        </div>

        <template v-if="ViewReportModule.show">
            <ViewReport @go-back="GoBackReport" :parentElId="'database-view-reports'" :record="ViewReportModule.data" />
        </template>
    </div>
</template>

<script>
import api from '@/api/main'
import ViewReport from "@/components/Modules/Profiles/ViewReport";
import SelectOfficer from "@/components/Modals/General/SelectOfficer";

import { Dropdown } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "Database-Reports",
    components: {
        ViewReport,
        SelectOfficer,
    },
    data() {
        return {
            loading: false,

            selfRecentReports: [],

            inputFields: {
                name: '',
                type: '',
                id: ''
            },

            filter: {
                submittedBy: false,
                type: false,
                id: false
            },

            ViewReportModule: {
                show: false,
                data: false,
            },

            pagination: {
                reports: {
                    list: [],
                    currentPage: 1,
                    totalPages: false,
                },
            },

            modalData: {
                SelectOfficer: {
                    show: false,
                },
            },
        };
    },
    mounted() {
        this.FetchReports()
    },
    methods: {
        async FetchReports() {
            this.loading = true
            this.ToggleLoadingScreen(true)
            let start = Date.now()

            this.selfRecentReports = await api.reports.FetchRecentReports()
            let resp = await api.reports.FetchAllReports(1, true)
            this.pagination.reports.list = resp.pageData
            this.pagination.reports.totalPages = resp.totalPages
            this.pagination.reports.currentPage = 1

            if (Date.now() - start > 1500) {
                this.ToggleLoadingScreen(false)
            } else {
                setTimeout(() => {
                    this.ToggleLoadingScreen(false)
                }, 750)
            }
            this.loading = false
        },

        async RefreshPage(page) {
            if ( page !== this.pagination.reports.currentPage ) {
                this.ToggleLoadingScreen(true)
                let start = Date.now()
                let useFilter = false

                if ( this.filter.id || this.filter.type || this.filter.submittedBy ) {
                    useFilter = true
                }

                let resp = await api.reports.FetchAllReports(page, false, useFilter ? this.filter : false)
                this.pagination.reports.list = resp.pageData
                this.pagination.reports.currentPage = page

                if (Date.now() - start > 3000) {
                    this.ToggleLoadingScreen(false)
                } else {
                    setTimeout(() => {
                        this.ToggleLoadingScreen(false)
                    }, 500)
                }
            }
        },

        ShowOfficerSelect() {
            if (!this.modalData.SelectOfficer.show) {
                this.modalData.SelectOfficer.show = true;

                setTimeout(() => {
                    this.modalData.SelectOfficer.show = false;
                }, 200);
            }
        },

        SelectOfficer(player) {
            if ( player ) {
                this.inputFields.name = player.name
                this.filter.submittedBy = player.identifier
            } else {
                this.inputFields.name = ''
                this.filter.submittedBy = false
            }
        },

        async FetchAllReports(useFilter) {
            this.ToggleLoadingScreen(true)
            let start = Date.now()

            let resp = await api.reports.FetchAllReports(1, true, useFilter ? this.filter : false)
            this.pagination.reports.list = resp.pageData
            this.pagination.reports.totalPages = resp.totalPages
            this.pagination.reports.currentPage = 1

            if (Date.now() - start > 3000) {
                this.ToggleLoadingScreen(false)
            } else {
                setTimeout(() => {
                    this.ToggleLoadingScreen(false)
                }, 500)
            }
        },

        ClearAndRefresh() {
            if ( this.filter.id || this.filter.type || this.filter.submittedBy ) {
                this.inputFields.id = ''
                this.inputFields.type = ''
                this.inputFields.name = ''

                this.filter.id = false
                this.filter.type = false
                this.filter.submittedBy = false

                this.FetchAllReports(false)
            }
        },

        async SearchRefresh() {
            this.filter.id   = this.inputFields.id.length > 0 ? this.inputFields.id : false
            this.filter.type = this.inputFields.type.length > 0 ? this.inputFields.type : false

            if ( this.filter.id || this.filter.type || this.filter.submittedBy ) {
                this.FetchAllReports(true)
            } else {
                this.SendNotification(
                    this.$store.getters.GetTranslation('view', 'error_1'),
                    this.$store.getters.GetTranslation('view', 'error_1_msg'),
                    5000,
                    'error',
                    false,
                    true
                );
            }
        },

        async ViewReport(id) {
            if (!this.ViewReportModule.show) {
                const apiResp = await api.reports.FetchReport(id);

                if ( apiResp ) {
                    this.ViewReportModule.data = apiResp
                    this.ViewReportModule.show = true;

                    setTimeout(() => {
                        this.TransitionEl('recent-reports-con', 'view-report')
                    }, 10)
                } else {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('view', 'error_2'),
                        this.$store.getters.GetTranslation('view', 'error_2_msg'),
                        7500,
                        'error',
                        false,
                        true
                    );
                }

            }
        },

        GoBackReport(refresh) {
            if (this.ViewReportModule.show) {
                setTimeout(() => {
                    this.ViewReportModule.show = false;
                    this.ViewReportModule.data = false;

                    if ( refresh ) {
                        this.selfRecentReports = []
                        this.this.pagination.reports = {
                            list: [],
                            currentPage: 1,
                            totalPages: false,
                        }

                        this.FetchReports()
                    }
                }, 200)

                setTimeout(() => {
                    this.TransitionEl('view-report', 'recent-reports-con')
                }, 10)
            }
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

        ToggleDropdown(id) {
            var dropdownEl = document.getElementById(id);
            var dropdownInstance = Dropdown.getOrCreateInstance(dropdownEl);
            dropdownInstance.toggle();
        },
    },
};
</script>

<style lang="scss" scoped>
$primaryColor: #1d1f25;
$primaryColorLight: #2a2c34;
$primaryColorLightHover: #383a44;
$primaryColorLightAlt: #424450;
$secondaryColor: #e37926;
$secondaryColorHover: #b46020;
$textColor: #ececec;
$textColorHover: #bfbfbf;
$formPlaceholderText: #bfbfbf7c;

#database-view-reports {
    background-color: $primaryColorLight;
    border-radius: 5px;
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
}

.mdt-form {
    input,
    .form-control,
    .form-select {
        color: $textColor !important;
        border-color: $primaryColorLight !important;
        background-color: $primaryColorLightAlt !important;
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
