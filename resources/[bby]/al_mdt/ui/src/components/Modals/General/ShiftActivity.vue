<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="shiftLogLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="shiftLogLabel">
                        {{ $store.getters.GetTranslation('shiftactivity', 'title') }}
                        <span v-if="user">{{ `: ${user.name}` }}</span>
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="container col-xxl-9 col-xl-11 table-con activityTable">
                            <!-- Navigation -->
                            <ul class="nav nav-pills justify-content-center" id="user-activity-pills-tab"
                                role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="user-activity-statistics-tab"
                                        data-bs-toggle="pill" data-bs-target="#user-activity-statistics" type="button"
                                        role="tab" aria-controls="user-activity-statistics" aria-selected="true">
                                        {{ $store.getters.GetTranslation('shiftactivity', 'statistics') }}
                                    </button>
                                </li>

                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="user-activity-log-tab" data-bs-toggle="pill"
                                        data-bs-target="#user-activity-log" type="button" role="tab"
                                        aria-controls="user-activity-log" aria-selected="false">
                                        {{ $store.getters.GetTranslation('shiftactivity', 'shift_log') }}
                                    </button>
                                </li>
                            </ul>

                            <div class="tab-content" id="user-activity-pills-tabContent">
                                <div class="tab-pane fade show active" id="user-activity-statistics" role="tabpanel"
                                    aria-labelledby="user-activity-statistics-tab">
                                    <div class="row justify-content-center mt-2">
                                        <div class="row justify-content-center mdt-form text-center">
                                            <div class="col-3">
                                                <label class="col-form-label">
                                                    {{ $store.getters.GetTranslation('shiftactivity', '24hrs') }}
                                                </label>
                                                <input class="form-control text-center" type="text"
                                                    :value="GetElapsedTime(activity.day)" readonly />
                                            </div>

                                            <div class="col-3">
                                                <label class="col-form-label">
                                                    {{ $store.getters.GetTranslation('shiftactivity', '7days') }}
                                                </label>
                                                <input class="form-control text-center" type="text"
                                                    :value="GetElapsedTime(activity.week)" readonly />
                                            </div>

                                            <div class="col-3">
                                                <label class="col-form-label">
                                                    {{ $store.getters.GetTranslation('shiftactivity', 'total') }}
                                                </label>
                                                <input class="form-control text-center" type="text"
                                                    :value="GetElapsedTime(activity.total)" readonly />
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="tab-pane fade" id="user-activity-log" role="tabpanel"
                                    aria-labelledby="user-activity-log-tab">
                                    <div class="row justify-content-center">
                                        <div class="col-9">
                                            <table class="table text-center">
                                                <thead>
                                                    <tr>
                                                        <th scope="col" style="width: 10%">
                                                            {{ $store.getters.GetTranslation('shiftactivity', 'col_1')
                                                            }}
                                                        </th>
                                                        <th scope="col" style="width: 35%">
                                                            {{ $store.getters.GetTranslation('shiftactivity', 'col_2')
                                                            }}
                                                        </th>
                                                        <th scope="col" style="width: 35%">
                                                            {{ $store.getters.GetTranslation('shiftactivity', 'col_3')
                                                            }}
                                                        </th>
                                                        <th scope="col" style="width: 20%">
                                                            {{ $store.getters.GetTranslation('shiftactivity', 'col_4')
                                                            }}
                                                        </th>
                                                    </tr>
                                                </thead>

                                                <tbody>
                                                    <tr v-for="data in activityLog.list" :key="data.id">
                                                        <th scope="row">{{ FormatNumber(data.id) }}</th>
                                                        <td>{{ FormatDate(data.start, true) }}</td>
                                                        <td>{{ FormatDate(data.end, true) }}</td>
                                                        <th>{{ GetElapsedTime(data.duration) }}</th>
                                                    </tr>
                                                </tbody>
                                            </table>

                                            <template v-if="activityLog.totalPages === false">
                                                <div class="d-flex justify-content-center">
                                                    <div class="spinner-border m-auto"
                                                        style="width: 1.25rem; height: 1.25rem" role="status">
                                                        <span class="visually-hidden">Loading...</span>
                                                    </div>
                                                </div>
                                            </template>

                                            <template
                                                v-if="activityLog.list.length <= 0 && ( activityLog.totalPages !== false && activityLog.totalPages <= 0 ) && !loading">
                                                <div class="h6 text-center">
                                                    {{ $store.getters.GetTranslation('shiftactivity', 'no_results') }}
                                                </div>
                                            </template>

                                            <div class="row"
                                                v-if="activityLog.list.length > 0 && activityLog.totalPages !== false">
                                                <div class="col">
                                                    <nav aria-label="Page navigation example">
                                                        <ul class="pagination justify-content-center">
                                                            <li class="page-item"
                                                                :class="{ disabled: activityLog.currentPage === 1 }">
                                                                <a class="page-link" href="#"
                                                                    @click="RefreshActivityLogPage(1)">
                                                                    <i class="fas fa-angle-double-left"></i>
                                                                </a>
                                                            </li>

                                                            <!-- Pages -->
                                                            <template
                                                                v-for="page in Pagination(activityLog.currentPage, activityLog.totalPages)"
                                                                :key="page">
                                                                <li class="page-item"
                                                                    :class="{ active: activityLog.currentPage === page }">
                                                                    <a class="page-link" href="#"
                                                                        @click="RefreshActivityLogPage(page)">
                                                                        {{ page }}
                                                                    </a>
                                                                </li>
                                                            </template>

                                                            <li class="page-item"
                                                                :class="{ disabled: activityLog.currentPage === activityLog.totalPages }">
                                                                <a class="page-link" href="#"
                                                                    @click="RefreshActivityLogPage(activityLog.totalPages)">
                                                                    <i class="fas fa-angle-double-right"></i>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </nav>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn red-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('shiftactivity', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";
import api from '@/api/main'

export default {
    name: "ViewShiftActivity",
    data() {
        return {
            modalId: 'view-shift-log',

            activity: {
                day: 0,
                week: 0,
                total: 0,
            },

            activityLog: {
                list: [],
                currentPage: 1,
                totalPages: false,
            },

            beingShown: false,
            loading: false,
        };
    },
    props: ["parentElId", "show", "user"],
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
        async Init() {
            var shiftLog = document.getElementById('user-activity-log-tab')
            if (shiftLog.classList.contains('active')) {
                var shiftLogPill = document.getElementById('user-activity-log')
                shiftLog.classList.remove('active')
                shiftLogPill.classList.remove('active')
                shiftLogPill.classList.remove('show')

                var statistics = document.getElementById('user-activity-statistics-tab')
                var statisticsPill = document.getElementById('user-activity-statistics')
                statistics.classList.add('active')
                statisticsPill.classList.add('active')
                statisticsPill.classList.add('show')

            }

            this.loading = true
            // Self activity
            this.activity = await this.FetchStatistics() // Statistics

            let activityLogResp = await this.FetchActivityLog(1, true) // Log
            this.activityLog.list = activityLogResp.pageData
            this.activityLog.totalPages = activityLogResp.totalPages
            this.loading = false
        },

        async FetchStatistics() {
            const userActivity = await api.users.GetActivityStatistics(this.user.identifier)
            const currentDate = Date.now()
            let lastDay = currentDate - 86400000 // 24 Hours
            let lastWeek = currentDate - 604800000 // 1 Week
            let activity = {
                day: 0,
                week: 0,
                total: 0,
            }

            userActivity.forEach(val => {
                if ( val.start > lastDay ) {
                    activity.day += val.duration
                }

                if ( val.start > lastWeek ) {
                    activity.week += val.duration
                }

                activity.total += val.duration
            });

            return activity
        },
        async FetchActivityLog(page, getTotalPages) {
            var resp = await api.users.GetActivityLog(this.user.identifier, page, getTotalPages)
            this.activityLogPage = page
            return resp
        },
        async RefreshActivityLogPage(page) {
            if ( page !== this.activityLog.currentPage && !this.loading ) {
                this.loading = true

                let resp = await this.FetchActivityLog(page, false)
                this.activityLog.list = resp.pageData
                this.activityLog.currentPage = page
                this.loading = false
            }
        },

        ResetSession() {
            this.activity = {
                day: 0,
                week: 0,
                total: 0,
            }

            this.activityLog = {
                list: [],
                currentPage: 1,
                totalPages: false,
            }
        },

        ShowModal() {
            if (!this.beingShown) {
                // Append modal to body
                var modalEl = document.getElementById(this.modalId);
                document.body.appendChild(modalEl);

                var modalInstance = Modal.getOrCreateInstance(modalEl);
                modalInstance.show();

                this.Init()

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

                    this.ResetSession()
                }, 175);

                this.$store.commit('SetModalClosed')
                this.beingShown = false;
            }
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
$redColor: #9f1600;
$redColorHover: #7e1100;
$greenColor: #007b1d;
$greenColorHover: #006317;

// Form specific
$formBackground: #2d3138;
$formPlaceholderText: #bfbfbf7c;

.table {
    color: $textColor;
    background-color: $primaryColorLightHover;
}

.table-con {
    border: 10px $primaryColorLightHover solid;
    border-radius: 5px;
    background-color: $primaryColorLightHover;
}

.activityTable {
    background-color: $primaryColorLight;
    border-radius: 5px;
}

.table-con {
    border: 10px $primaryColorLightHover solid;
    border-radius: 5px;
    background-color: $primaryColorLightHover;
}

.mdt-form {
    input,
    .form-control,
    .form-select {
        color: $textColor !important;
        border-color: $primaryColorLight !important;
        background-color: $formBackground !important;
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