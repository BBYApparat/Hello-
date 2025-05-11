<template>
    <div id="activity" class="container mt-3 p-3">
        <ViewActivity :parentElId="'activity'" :show="modalData.ViewActivity.show"
            :user="modalData.ViewActivity.user" />
        <!-- Main start -->
        <div class="row justify-content-center mb-4">
            <div class="col h3 text-center">{{ $store.getters.GetTranslation('activity', 'title') }}</div>
        </div>

        <!-- Self activity -->
        <div class="row">
            <div class="row justify-content-center">
                <div class="col h5 text-center">{{ $store.getters.GetTranslation('activity', 'your_act') }}</div>
            </div>

            <div class="container col-xxl-9 col-11 table-con activityTable">
                <!-- Navigation -->
                <ul class="nav nav-pills justify-content-center" id="self-activity-pills-tab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="activity-self-statistics-tab" data-bs-toggle="pill"
                            data-bs-target="#activity-self-statistics" type="button" role="tab"
                            aria-controls="activity-self-statistics" aria-selected="true">
                            {{ $store.getters.GetTranslation('activity', 'statistics') }}
                        </button>
                    </li>

                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="activity-self-log-tab" data-bs-toggle="pill"
                            data-bs-target="#activity-self-log" type="button" role="tab"
                            aria-controls="activity-self-log" aria-selected="false">
                            {{ $store.getters.GetTranslation('activity', 'shift_log') }}
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="self-activity-pills-tabContent">
                    <div class="tab-pane fade show active" id="activity-self-statistics" role="tabpanel"
                        aria-labelledby="activity-self-statistics-tab">
                        <div class="row justify-content-center mt-2">
                            <div class="row justify-content-center mdt-form text-center">
                                <div class="col-3">
                                    <label class="col-form-label">{{$store.getters.GetTranslation('activity', '24hrs')
                                    }}</label>
                                    <input class="form-control text-center" type="text"
                                        :value="GetElapsedTime(activity.day)" readonly />
                                </div>

                                <div class="col-3">
                                    <label class="col-form-label">{{$store.getters.GetTranslation('activity', '7days')
                                    }}</label>
                                    <input class="form-control text-center" type="text"
                                        :value="GetElapsedTime(activity.week)" readonly />
                                </div>

                                <div class="col-3">
                                    <label class="col-form-label">{{ $store.getters.GetTranslation('activity', 'total')
                                    }}</label>
                                    <input class="form-control text-center" type="text"
                                        :value="GetElapsedTime(activity.total)" readonly />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="activity-self-log" role="tabpanel"
                        aria-labelledby="activity-self-log-tab">
                        <div class="row justify-content-center">
                            <div class="col-xxl-9 col-10">
                                <table class="table text-center">
                                    <thead>
                                        <tr>
                                            <th scope="col" style="width: 10%">{{
                                            $store.getters.GetTranslation('activity', 'col_1') }}</th>
                                            <th scope="col" style="width: 35%">{{
                                            $store.getters.GetTranslation('activity', 'col_2') }}</th>
                                            <th scope="col" style="width: 35%">{{
                                            $store.getters.GetTranslation('activity', 'col_3') }}</th>
                                            <th scope="col" style="width: 20%">{{
                                            $store.getters.GetTranslation('activity', 'col_4') }}</th>
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

                                <template v-if="activityLog.list.length <= 0">
                                    <div class="h6 text-center">
                                        {{ $store.getters.GetTranslation('activity', 'no_results') }}
                                    </div>
                                </template>

                                <div class="row" v-if="activityLog.list.length > 0">
                                    <div class="col">
                                        <nav aria-label="Page navigation example">
                                            <ul class="pagination justify-content-center">
                                                <li class="page-item"
                                                    :class="{ disabled: activityLog.currentPage === 1 }">
                                                    <a class="page-link" href="#" @click="RefreshActivityLogPage(1)">
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

        <!-- Units activity -->
        <div class="row mt-4">
            <div class="row justify-content-center">
                <div class="col h5 text-center">{{ $store.getters.GetTranslation('activity', 'other_act') }}</div>
            </div>

            <div class="container col-xxl-9 col-xl-11 table-con activityTable">
                <!-- Navigation -->
                <ul class="nav nav-pills justify-content-center" id="job-activity-pills-tab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="activity-job-statistics-tab" data-bs-toggle="pill"
                            data-bs-target="#activity-job-statistics" type="button" role="tab"
                            aria-controls="activity-job-statistics" aria-selected="true">
                            {{ $store.getters.GetTranslation('activity', 'statistics') }}
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="job-activity-pills-tabContent">
                    <div class="tab-pane fade show active" id="activity-job-statistics" role="tabpanel"
                        aria-labelledby="activity-job-statistics-tab">
                        <div class="row justify-content-center">
                            <div class="col-9">
                                <table class="table text-center">
                                    <thead>
                                        <tr>
                                            <th scope="col" style="width: 35%">{{
                                            $store.getters.GetTranslation('activity', 'user') }}</th>
                                            <th scope="col" style="width: 25%">{{
                                            $store.getters.GetTranslation('activity', '24hrs') }}</th>
                                            <th scope="col" style="width: 25%">{{
                                            $store.getters.GetTranslation('activity', '7days') }}</th>
                                            <th scope="col" style="width: 15%">{{
                                            $store.getters.GetTranslation('activity', 'actions') }}</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr v-for="user in usersActivtyLog.users" :key="user.identifier">
                                            <th scope="row">{{ user.callsign.length > 0 ? `${user.callsign} -
                                            ${user.name}` : user.name }}</th>
                                            <td :class="{ 'no-activity': user.activity.day <= 0 }">
                                                {{ user.activity.day > 0 ? GetElapsedTime(user.activity.day) :
                                                $store.getters.GetTranslation('activity', 'none') }}
                                            </td>
                                            <td :class="{ 'no-activity': user.activity.week <= 0 }">
                                                {{ user.activity.week > 0 ? GetElapsedTime(user.activity.week) :
                                                $store.getters.GetTranslation('activity', 'none')
                                                }}
                                            </td>
                                            <td class="text-center">
                                                <button @click="ShowShiftActivity(user)" type="button"
                                                    class="btn btn-sm blue-btn">
                                                    {{ $store.getters.GetTranslation('activity', 'more') }}
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <!-- Pagination -->
                                <div class="row" v-if="usersActivtyLog.users.length > 0">
                                    <div class="col">
                                        <nav aria-label="Page navigation example">
                                            <ul class="pagination justify-content-center">
                                                <!-- First -->
                                                <li class="page-item"
                                                    :class="{ disabled: usersActivtyLog.currentPage === 1 }">
                                                    <a class="page-link" href="#" @click="RefreshJobActivityPage(1)">
                                                        <i class="fas fa-angle-double-left"></i>
                                                    </a>
                                                </li>

                                                <!-- Pages -->
                                                <template
                                                    v-for="page in Pagination(usersActivtyLog.currentPage, usersActivtyLog.totalPages)"
                                                    :key="page">
                                                    <li class="page-item"
                                                        :class="{ active: usersActivtyLog.currentPage === page }">
                                                        <a class="page-link" href="#"
                                                            @click="RefreshJobActivityPage(page)">
                                                            {{ page }}
                                                        </a>
                                                    </li>
                                                </template>

                                                <!-- Last -->
                                                <li class="page-item"
                                                    :class="{ disabled: usersActivtyLog.currentPage === usersActivtyLog.totalPages }">
                                                    <a class="page-link" href="#"
                                                        @click="RefreshJobActivityPage(usersActivtyLog.totalPages)">
                                                        <i class="fas fa-angle-double-right"></i>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>

                                <template v-else-if="usersActivtyLog.totalPages === false">
                                    <div class="d-flex justify-content-center">
                                        <div class="spinner-border m-auto" style="width: 1.25rem; height: 1.25rem"
                                            role="status">
                                            <span class="visually-hidden">Loading...</span>
                                        </div>
                                    </div>
                                </template>

                                <template v-else>
                                    <div class="h6 text-center">
                                        {{ $store.getters.GetTranslation('activity', 'no_results') }}
                                    </div>
                                </template>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import api from '@/api/main'
import ViewActivity from '@/components/Modals/General/ShiftActivity'

export default {
    name: "ShiftActivity",
    components: {
        ViewActivity,
    },
    data() {
        return {
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

            usersActivtyLog: {
                users: [],
                currentPage: 1,
                totalPages: false,
            },

            modalData: {
                ViewActivity: {
                    show: false,
                    user: false,
                },
            },
        };
    },
    mounted() {
        this.Init()
    },
    methods: {
        async Init() {
            this.ToggleLoadingScreen(true)
            let start = Date.now()

            // Self activity
            this.activity = await this.FetchSelfStatistics() // Statistics

            let activityLogResp = await this.FetchSelfActivityLog(1, true) // Log
            this.activityLog.list = activityLogResp.pageData
            this.activityLog.totalPages = activityLogResp.totalPages

            // Job activity
            let jobActivityResp = await this.FetchJobActivity(1, true) // Users statistics from job
            this.usersActivtyLog.users = jobActivityResp.users
            this.usersActivtyLog.totalPages = jobActivityResp.totalPages

            if (Date.now() - start > 1500) {
                this.ToggleLoadingScreen(false)
            } else {
                setTimeout(() => {
                    this.ToggleLoadingScreen(false)
                }, 750)
            }
        },

        ShowShiftActivity(user) {
            this.modalData.ViewActivity.show = true;
            this.modalData.ViewActivity.user = user;

            setTimeout(() => {
                this.modalData.ViewActivity.show = false;
            }, 200);
        },

        // Self activity
        async FetchSelfStatistics() {
            const selfActivity = await api.users.GetActivityStatistics(this.$store.getters.GetSelf().identifier)
            const currentDate = Date.now()
            let lastDay = currentDate - 86400000 // 24 Hours
            let lastWeek = currentDate - 604800000 // 1 Week
            let activity = {
                day: 0,
                week: 0,
                total: 0,
            }

            selfActivity.forEach(val => {
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
        async FetchSelfActivityLog(page, getTotalPages) {
            var resp = await api.users.GetActivityLog(this.$store.getters.GetSelf().identifier, page, getTotalPages)
            this.activityLogPage = page
            return resp
        },
        async RefreshActivityLogPage(page) {
            if ( page !== this.activityLog.currentPage ) {
                this.ToggleLoadingScreen(true)
                let start = Date.now()

                let resp = await this.FetchSelfActivityLog(page, false)
                this.activityLog.list = resp.pageData
                this.activityLog.currentPage = page

                if (Date.now() - start > 3000) {
                    this.ToggleLoadingScreen(false)
                } else {
                    setTimeout(() => {
                        this.ToggleLoadingScreen(false)
                    }, 500)
                }
            }
        },

        // Job activity
        async FetchJobActivity(page, getTotalUsers) {
            let resp = await api.users.GetJobActivity(page, getTotalUsers)
            let usersJobActivity = resp.users

            let lastDay = Date.now() - 86400000 // 24 Hours
            usersJobActivity.forEach(val => { // Sort through every user
                let shiftActivity = val.log
                val.activity = {
                    day: 0,
                    week: 0,
                }

                shiftActivity.forEach(v => { // Sort through every users activity and compile it down
                    if ( v.start > lastDay ) {
                        val.activity.day += v.duration
                    }

                    val.activity.week += v.duration
                });
                val.log = undefined
                delete(val.log)
            });
            return resp
        },
        async RefreshJobActivityPage(page) {
            if ( page !== this.usersActivtyLog.currentPage ) {
                this.ToggleLoadingScreen(true)
                let start = Date.now()

                let resp = await this.FetchJobActivity(page, false)
                this.usersActivtyLog.users = resp.users
                this.usersActivtyLog.currentPage = page

                if (Date.now() - start > 3000) {
                    this.ToggleLoadingScreen(false)
                } else {
                    setTimeout(() => {
                        this.ToggleLoadingScreen(false)
                    }, 500)
                }
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

#activity {
    background-color: $primaryColorLight;
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

    .no-activity {
        color: $formPlaceholderText;
    }
}
</style>