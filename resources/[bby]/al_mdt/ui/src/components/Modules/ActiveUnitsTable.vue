<template>
    <div class="container-fluid">
        <ChangeStatusModal :parentElId="'dashboard'" :player="modalData.ChangePlayerStatus.player"
            :show="modalData.ChangePlayerStatus.show" />

        <div class="container col-xxl-10 col-xl-11 table-con unitsTable">
            <ul class="nav nav-pills mb-3 justify-content-center" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation" v-if="perms.units.police.show">
                    <button class="nav-link" id="dash-active-police-tab" data-bs-toggle="pill"
                        data-bs-target="#dash-active-police" type="button" role="tab" aria-controls="dash-active-police"
                        aria-selected="true" :class="{
                            active: playerJob === 'police'
                        }">
                        {{ $store.getters.GetTranslation('activeunitstable', 'police') }}
                    </button>
                </li>
                <li class="nav-item" role="presentation" v-if="perms.units.ems.show">
                    <button class="nav-link" id="dash-active-ems-tab" data-bs-toggle="pill"
                        data-bs-target="#dash-active-ems" type="button" role="tab" aria-controls="dash-active-ems"
                        aria-selected="false" :class="{
                            active: playerJob === 'ems'
                        }">
                        {{ $store.getters.GetTranslation('activeunitstable', 'ems') }}
                    </button>
                </li>
                <li class="nav-item" role="presentation" v-if="perms.units.roadside.show">
                    <button class="nav-link" id="dash-active-roadside-tab" data-bs-toggle="pill"
                        data-bs-target="#dash-active-roadside" type="button" role="tab"
                        aria-controls="dash-active-roadside" aria-selected="false" :class="{
                            active: playerJob === 'roadside'
                        }">
                        {{ $store.getters.GetTranslation('activeunitstable', 'roadside') }}
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="pills-tabContent">
                <!-- Police List -->
                <div class="tab-pane fade" id="dash-active-police" role="tabpanel"
                    aria-labelledby="dash-active-police-tab" v-if="perms.units.police.show" :class="{
                        show: playerJob === 'police',
                        active: playerJob === 'police'
                    }">
                    <table class="table text-center">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 10%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_call') }}
                                </th>
                                <th scope="col" style="width: 40%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_name') }}
                                </th>
                                <th scope="col" style="width: 30%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_status') }}
                                </th>
                                <th scope="col" style="width: 20%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_act') }}
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr v-for="player in $store.getters.GetOnDutyPlayersFromJob('police')"
                                :key="player.identifier">
                                <td scope="row">{{ player.callsign }}</td>
                                <td>{{ player.name }}</td>
                                <td>
                                    <span :class="`status-${player.status}`">
                                        {{ GetStatusLabel(player.status) }}
                                    </span>
                                </td>
                                <td>
                                    <div class="row justify-content-center">
                                        <div class="col-3" v-if="!player.self && perms.units.police.gps">
                                            <button @click="SetWaypoint(player.identifier)" type="button"
                                                class="btn btn-sm orange-btn" data-bs-toggle="tooltip"
                                                data-bs-placement="top"
                                                :title="$store.getters.GetTranslation('activeunitstable', 'tooltip_1')">
                                                <i class="fas fa-map-marker-alt"></i>
                                            </button>
                                        </div>

                                        <div class="col-3" v-if="!player.self && perms.units.police.copyStatus">
                                            <button @click="CopyStatus(player.status)" type="button"
                                                class="btn btn-sm orange-btn" data-bs-toggle="tooltip"
                                                data-bs-placement="top"
                                                :title="$store.getters.GetTranslation('activeunitstable', 'tooltip_2')">
                                                <i class="fas fa-clone"></i>
                                            </button>
                                        </div>

                                        <div class="col-3" v-if="perms.units.police.changeStatus">
                                            <button @click="OpenStatusModal(player)" type="button"
                                                class="btn btn-sm orange-btn" data-bs-toggle="tooltip"
                                                data-bs-placement="top"
                                                :title="$store.getters.GetTranslation('activeunitstable', 'tooltip_3')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <template v-if="$store.getters.GetOnDutyPlayersFromJob('police').length <= 0">
                        <div class="h6 text-center">
                            {{ $store.getters.GetTranslation('activeunitstable', 'no_units') }}
                        </div>
                    </template>
                </div>

                <!-- EMS List -->
                <div class="tab-pane fade" id="dash-active-ems" role="tabpanel" aria-labelledby="dash-active-ems-tab"
                    v-if="perms.units.ems.show" :class="{
                        show: playerJob === 'ems',
                        active: playerJob === 'ems'
                    }">
                    <table class="table text-center">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 10%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_call') }}
                                </th>
                                <th scope="col" style="width: 40%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_name') }}
                                </th>
                                <th scope="col" style="width: 30%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_status') }}
                                </th>
                                <th scope="col" style="width: 20%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_act') }}
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr v-for="player in $store.getters.GetOnDutyPlayersFromJob('ems')"
                                :key="player.identifier">
                                <td scope="row">{{ player.callsign }}</td>
                                <td>{{ player.name }}</td>
                                <td>
                                    <span :class="`status-${player.status}`">
                                        {{ GetStatusLabel(player.status) }}
                                    </span>
                                </td>
                                <td>
                                    <div class="row justify-content-center">
                                        <div class="col-3" v-if="!player.self && perms.units.ems.gps">
                                            <button @click="SetWaypoint(player.identifier)" type="button"
                                                class="btn btn-sm orange-btn" data-bs-toggle="tooltip"
                                                data-bs-placement="top"
                                                :title="$store.getters.GetTranslation('activeunitstable', 'tooltip_1')">
                                                <i class="fas fa-map-marker-alt"></i>
                                            </button>
                                        </div>

                                        <div class="col-3" v-if="!player.self && perms.units.ems.copyStatus">
                                            <button @click="CopyStatus(player.status)" type="button"
                                                class="btn btn-sm orange-btn" data-bs-toggle="tooltip"
                                                data-bs-placement="top"
                                                :title="$store.getters.GetTranslation('activeunitstable', 'tooltip_2')">
                                                <i class="fas fa-clone"></i>
                                            </button>
                                        </div>

                                        <div class="col-3" v-if="perms.units.ems.changeStatus">
                                            <button @click="OpenStatusModal(player)" type="button"
                                                class="btn btn-sm orange-btn" data-bs-toggle="tooltip"
                                                data-bs-placement="top"
                                                :title="$store.getters.GetTranslation('activeunitstable', 'tooltip_3')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <template v-if="$store.getters.GetOnDutyPlayersFromJob('ems').length <= 0">
                        <div class="h6 text-center">
                            {{ $store.getters.GetTranslation('activeunitstable', 'no_units') }}
                        </div>
                    </template>
                </div>

                <!-- Roadside List -->
                <div class="tab-pane fade" id="dash-active-roadside" role="tabpanel"
                    aria-labelledby="dash-active-roadside-tab" v-if="perms.units.roadside.show" :class="{
                        show: playerJob === 'roadside',
                        active: playerJob === 'roadside'
                    }">
                    <table class="table text-center">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 10%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_call') }}
                                </th>
                                <th scope="col" style="width: 40%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_name') }}
                                </th>
                                <th scope="col" style="width: 30%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_status') }}
                                </th>
                                <th scope="col" style="width: 20%">
                                    {{ $store.getters.GetTranslation('activeunitstable', 'col_act') }}
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr v-for="player in $store.getters.GetOnDutyPlayersFromJob('roadside')"
                                :key="player.identifier">
                                <td scope="row">{{ player.callsign }}</td>
                                <td>{{ player.name }}</td>
                                <td>
                                    <span :class="`status-${player.status}`">
                                        {{ GetStatusLabel(player.status) }}
                                    </span>
                                </td>
                                <td>
                                    <div class="row justify-content-center">
                                        <div class="col-3" v-if="!player.self && perms.units.roadside.gps">
                                            <button @click="SetWaypoint(player.identifier)" type="button"
                                                class="btn btn-sm orange-btn" data-bs-toggle="tooltip"
                                                data-bs-placement="top"
                                                :title="$store.getters.GetTranslation('activeunitstable', 'tooltip_1')">
                                                <i class="fas fa-map-marker-alt"></i>
                                            </button>
                                        </div>

                                        <div class="col-3" v-if="!player.self && perms.units.roadside.copyStatus">
                                            <button @click="CopyStatus(player.status)" type="button"
                                                class="btn btn-sm orange-btn" data-bs-toggle="tooltip"
                                                data-bs-placement="top"
                                                :title="$store.getters.GetTranslation('activeunitstable', 'tooltip_2')">
                                                <i class="fas fa-clone"></i>
                                            </button>
                                        </div>

                                        <div class="col-3" v-if="perms.units.roadside.changeStatus">
                                            <button @click="OpenStatusModal(player)" type="button"
                                                class="btn btn-sm orange-btn" data-bs-toggle="tooltip"
                                                data-bs-placement="top"
                                                :title="$store.getters.GetTranslation('activeunitstable', 'tooltip_3')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <template v-if="$store.getters.GetOnDutyPlayersFromJob('roadside').length <= 0">
                        <div class="h6 text-center">
                            {{ $store.getters.GetTranslation('activeunitstable', 'no_units') }}
                        </div>
                    </template>
                </div>

            </div>
        </div>
    </div>
</template>

<script>
import ChangeStatusModal from '@/components/Modals/General/ChangeStatus'
import api from "@/api/main"

export default {
    name: "ActiveUnitsTableModule",
    components: {
        ChangeStatusModal,
    },
    data() {
        return {
            modalData: {
                ChangePlayerStatus: {
                    player: false,
                    show: false,
                },
            },

            playerJob: false,

            perms: {
                units: {
                    police: {
                        show: false,
                        gps: false,
                        copyStatus: false,
                        changeStatus: false,
                    },
                    ems: {
                        show: false,
                        gps: false,
                        copyStatus: false,
                        changeStatus: false,
                    },
                    roadside: {
                        show: false,
                        gps: false,
                        copyStatus: false,
                        changeStatus: false,
                    },
                },
            }
        }
    },
    mounted() {
        this.CheckPerms()
    },
    methods: {
        CheckPerms() {
            const playerJob = this.$store.getters.GetSelf().job
            this.playerJob = playerJob
            var currentPerm = {}

            // Police
            this.perms.units.police.gps = this.$store.getters.HasPerm(playerJob, 'gps', 'police')
            this.perms.units.police.copyStatus = this.$store.getters.HasPerm(playerJob, 'copyStatus', 'police')
            this.perms.units.police.changeStatus = this.$store.getters.HasPerm(playerJob, 'changeStatus', 'police')
            currentPerm = this.perms.units.police

            if (currentPerm.gps || currentPerm.changeStatus || currentPerm.copyStatus) {
                this.perms.units.police.show = true
            }

            // EMS
            this.perms.units.ems.gps = this.$store.getters.HasPerm(playerJob, 'gps', 'ems')
            this.perms.units.ems.copyStatus = this.$store.getters.HasPerm(playerJob, 'copyStatus', 'ems')
            this.perms.units.ems.changeStatus = this.$store.getters.HasPerm(playerJob, 'changeStatus', 'ems')
            currentPerm = this.perms.units.ems

            if (currentPerm.gps || currentPerm.changeStatus || currentPerm.copyStatus) {
                this.perms.units.ems.show = true
            }

            // Roadside
            this.perms.units.roadside.gps = this.$store.getters.HasPerm(playerJob, 'gps', 'roadside')
            this.perms.units.roadside.copyStatus = this.$store.getters.HasPerm(playerJob, 'copyStatus', 'roadside')
            this.perms.units.roadside.changeStatus = this.$store.getters.HasPerm(playerJob, 'changeStatus', 'roadside')
            currentPerm = this.perms.units.roadside

            if (currentPerm.gps || currentPerm.changeStatus || currentPerm.copyStatus) {
                this.perms.units.roadside.show = true
            }
        },
        OpenStatusModal(player) {
            this.modalData.ChangePlayerStatus.player = player;
            this.modalData.ChangePlayerStatus.show = true;

            setTimeout(() => {
                this.modalData.ChangePlayerStatus.show = false;
            }, 200);
        },
        CopyStatus(status) {
            this.$store.dispatch("CopyPlayerStatus", status);

            this.SendNotification(
                this.$store.getters.GetTranslation('activeunitstable', 'sts_changed'),
                `${this.$store.getters.GetTranslation('activeunitstable', 'sts_changed_msg')} ${this.GetStatusLabel(status)}`,
                5000,
                "success",
                false,
                false
            );
        },
        SetWaypoint(playerIdentifier) {
            api.users.SetGPS(playerIdentifier)

            this.SendNotification(
                this.$store.getters.GetTranslation('activeunitstable', 'nav_set'),
                this.$store.getters.GetTranslation('activeunitstable', 'nav_set_msg'),
                5000,
                "success",
                false,
                false,
            );
        },
    },
};
</script>

<style lang="scss" scoped>
$primaryColorLight: #2a2c34;
$primaryColorLightHover: #383a44;
$textColor: #ececec;
$textColorHover: #bfbfbf;

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

$yellowColor: #d39736;
$yellowFadedColor: #f5b041b7;
$yellowColorHover: #d39634;

$blueColor: #2e86c1;
$blueFadedColor: #2e86c1a6;
$blueColorHover: #2170a5;

$greyColor: #839192;
$greyFadedColor: #8391929d;
$greyColorHover: #707b7c;

.unitsTable {
    background-color: $primaryColorLight;
    border-radius: 5px;

    .table {
        color: $textColor;
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

.table-con {
    border: 10px $primaryColorLightHover solid;
    border-radius: 5px;
    background-color: $primaryColorLightHover;
}

// Unavailable
.status-0 {
    background-color: $greyColor;
    box-shadow: 0 0 10px $greyFadedColor;
    padding: 4px 6px;
    border-radius: 5px;
}

// Available
.status-1 {
    background-color: $greenColor;
    box-shadow: 0 0 10px $greenFadedColor;
    padding: 4px 6px;
    border-radius: 5px;
}

// Busy
.status-2 {
    background-color: $yellowColor;
    box-shadow: 0 0 10px $yellowFadedColor;
    padding: 4px 6px;
    border-radius: 5px;
}

// On Call
.status-3 {
    background-color: $blueColor;
    box-shadow: 0 0 10px $blueFadedColor;
    padding: 4px 6px;
    border-radius: 5px;
}

// In Transport
.status-4 {
    background-color: $purpleColor;
    box-shadow: 0 0 10px $purpleFadedColor;
    padding: 4px 6px;
    border-radius: 5px;
}

// Panic
.status-5 {
    background-color: $redColor;
    box-shadow: 0 0 10px $redFadedColor;
    padding: 4px 6px;
    border-radius: 5px;
    animation: blinkPanic 1s ease infinite;
}

@keyframes blinkPanic {
    0% {
        box-shadow: 0 0 10px rgba(255, 255, 255, 0);
        background-color: rgba(255, 255, 255, 0);
    }
    50% {
        box-shadow: 0 0 10px $redFadedColor;
        background-color: $redColor;
    }
    100% {
        box-shadow: 0 0 10px rgba(255, 255, 255, 0);
        background-color: rgba(255, 255, 169, 0);
    }
}
</style>
