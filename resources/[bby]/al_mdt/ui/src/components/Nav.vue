<template>
    <div id="nav" class="container-fluid">
        <!-- Modals -->
        <ViewNotifications :parentElId="'nav'" :show="modalData.ViewNotifications.show" />

        <DutyToggle :parentElId="'nav'" :show="modalData.DutyToggle.show" />

        <Settings :parentElId="'nav'" :show="modalData.Settings.show" />

        <ChangeStatusModal :parentElId="'nav'" :player="modalData.ChangePlayerStatus.player"
            :show="modalData.ChangePlayerStatus.show" :id="'nav-status-change'" />

        <nav class="navbar navbar-expand-lg navbar-dark">
            <div class="container-fluid">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <span class="navbar-brand">{{ $store.state.config.General.Title }}</span>

                    <ul class="navbar-nav ms-4">
                        <!-- Dashboard Tab -->
                        <li class="nav-item">
                            <a class="nav-link" :class="$router.currentRoute.value.name == 'Dashboard' && 'active'"
                                aria-current="page" @click="changeTab('dashboard')" href="#">
                                {{ $store.getters.GetTranslation('nav', 'nav_item_1') }}
                            </a>
                        </li>

                        <!-- Bolos Tab -->
                        <li class="nav-item" v-if="perms.bolo">
                            <a class="nav-link" :class="$router.currentRoute.value.name == 'Bolos' && 'active'"
                                @click="changeTab('bolos')" href="#">
                                {{ $store.getters.GetTranslation('nav', 'nav_item_2') }}
                            </a>
                        </li>

                        <!-- Warrants Tab -->
                        <li class="nav-item" v-if="perms.warrant">
                            <a class="nav-link" :class="$router.currentRoute.value.name == 'Warrants' && 'active'"
                                @click="changeTab('warrants')" href="#">
                                {{ $store.getters.GetTranslation('nav', 'nav_item_3') }}
                            </a>
                        </li>

                        <!-- Database dropdown -->
                        <li class="nav-item dropdown" v-if="perms.dbSearch || perms.createReport">
                            <a class="nav-link dropdown-toggle"
                                :class=" ($router.currentRoute.value.name == 'QuickSearch' || $router.currentRoute.value.name == 'CreateReport' || $router.currentRoute.value.name == 'ViewReports') && 'active'"
                                href="#" id="navbarDropdown" @click="ToggleDropdown('navbarDropdown', true)"
                                @mouseleave="UpdateMouseState('listEl', false)"
                                @mouseenter="UpdateMouseState('listEl', true)">
                                {{ $store.getters.GetTranslation('nav', 'nav_item_4') }}
                            </a>

                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown"
                                @mouseleave="UpdateMouseState('dropEl', false)"
                                @mouseenter="UpdateMouseState('dropEl', true)">
                                <li v-if="perms.dbSearch">
                                    <a class="dropdown-item" href="#" @click="NavbarClick('database/lookup')">
                                        {{ $store.getters.GetTranslation('nav', 'nav_item_4_1') }}
                                    </a>
                                </li>
                                <li>
                                    <hr class="dropdown-divider" />
                                </li>
                                <li v-if="perms.createReport">
                                    <a class="dropdown-item" href="#" @click="NavbarClick('database/create-report')">
                                        {{ $store.getters.GetTranslation('nav', 'nav_item_4_2') }}
                                    </a>
                                </li>
                                <li v-if="perms.viewReport">
                                    <a class="dropdown-item" href="#" @click="NavbarClick('database/view-report')">
                                        {{ $store.getters.GetTranslation('nav', 'nav_item_4_3') }}
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <!-- Activity Tab -->
                        <li class="nav-item" v-if="perms.activity">
                            <a class="nav-link" :class="$router.currentRoute.value.name == 'Activity' && 'active'"
                                @click="changeTab('activity')" href="#">
                                {{ $store.getters.GetTranslation('nav', 'nav_item_5') }}
                            </a>
                        </li>

                        <!-- Custom Tab 1 -->
                        <template v-if="perms.custom1 && $store.state.config.CustomTabs[0].enabled">
                            <li class="nav-item">
                                <a class="nav-link" :class="$router.currentRoute.value.name == 'CustomTab1' && 'active'"
                                    @click="changeTab('custom1')" href="#">
                                    {{ $store.state.config.CustomTabs[0].label }}
                                </a>
                            </li>
                        </template>

                        <!-- Custom Tab 2 -->
                        <template v-if="perms.custom2 && $store.state.config.CustomTabs[1].enabled">
                            <li class="nav-item">
                                <a class="nav-link" :class="$router.currentRoute.value.name == 'CustomTab2' && 'active'"
                                    @click="changeTab('custom2')" href="#">
                                    {{ $store.state.config.CustomTabs[1].label }}
                                </a>
                            </li>
                        </template>

                        <!-- Custom Tab 3 -->
                        <template v-if="perms.custom3 && $store.state.config.CustomTabs[2].enabled">
                            <li class="nav-item">
                                <a class="nav-link" :class="$router.currentRoute.value.name == 'CustomTab3' && 'active'"
                                    @click="changeTab('custom3')" href="#">
                                    {{ $store.state.config.CustomTabs[2].label }}
                                </a>
                            </li>
                        </template>
                    </ul>
                </div>

                <!-- Profile dropdown -->
                <div class="dropdown" v-if="$store.getters.GetSelf()">
                    <a class="btn blue-btn btn-sm dropdown-toggle me-3 position-relative" href="#" role="button"
                        id="profileDropdown" data-bs-toggle="dropdown" data-bs-auto-close="outside"
                        aria-expanded="false" @click="ToggleDropdown('profileDropdown')">
                        {{ $store.getters.GetSelf().name }}

                        <!-- Alert notification -->
                        <span
                            class="position-absolute top-0 start-100 translate-middle bg-danger border border-light rounded-circle"
                            style="padding: 5px" v-if="$store.state.notifications.storedFeed.length > 0"></span>
                    </a>

                    <ul class="dropdown-menu" aria-labelledby="profileDropdown">
                        <template v-if="$store.state.notifications.storedFeed.length > 0">
                            <li id="notify-feed-li" class="text-center">
                                <button type="button" class="btn btn-sm blue-btn position-relative"
                                    @click="ViewNotifications()">
                                    {{ $store.getters.GetTranslation('nav', 'nav_item_6_1') }}

                                    <span class=" badge bg-danger position-absolute top-0 start-100 translate-middle ">
                                        {{ $store.state.notifications.storedFeed.length }}
                                        <!-- Number of notifications -->
                                    </span>
                                </button>

                                <button type="button" class="ms-3 btn btn-sm red-btn" @click="ClearNotifications()">
                                    <i class="fas fa-trash-alt mdt-color-text"></i>
                                </button>
                            </li>
                            <li>
                                <hr class="dropdown-divider" />
                            </li>
                        </template>

                        <template v-if="perms.clockin">
                            <li class="dropdown-item dropdown-btn-item text-center" v-if="!$store.getters.IsOnDuty()">
                                <button type="button" class="btn btn-sm green-btn" @click="DutyModal()">
                                    {{ $store.getters.GetTranslation('nav', 'nav_item_6_2') }}
                                </button>
                            </li>

                            <template v-if="$store.getters.IsOnDuty()">
                                <li class="dropdown-item dropdown-btn-item text-center fw-bold"
                                    style="font-size: 0.9rem">
                                    {{ `${$store.getters.GetTranslation('nav', 'nav_item_6_4')} ${elapsedTime}` }}
                                    <br>
                                    <button type="button" class="mt-2 mb-1 btn btn-sm red-btn" @click="DutyModal()">
                                        {{ $store.getters.GetTranslation('nav', 'nav_item_6_3') }}
                                    </button>
                                </li>

                                <li class="dropdown-item dropdown-btn-item text-center">
                                    <button type="button" class="btn btn-sm blue-btn" @click="ChangeStatus()">
                                        {{ $store.getters.GetTranslation('nav', 'nav_item_6_5') }}
                                    </button>
                                </li>
                            </template>

                            <li>
                                <hr class="dropdown-divider" />
                            </li>
                        </template>

                        <li class="dropdown-item dropdown-btn-item text-center">
                            <button type="button" class="btn btn-sm grey-btn" @click="SettingsModal()">
                                {{ $store.getters.GetTranslation('nav', 'nav_item_6_6') }}
                            </button>
                        </li>

                        <li>
                            <hr class="dropdown-divider" />
                        </li>

                        <li class="dropdown-item dropdown-btn-item text-center">
                            <button type="button" class="btn btn-sm red-btn" @click="Logout()">
                                {{ $store.getters.GetTranslation('nav', 'nav_item_6_7') }}
                            </button>
                        </li>
                    </ul>
                </div>

                <!-- Close button -->
                <button type="button" id="closeMDT" class="btn btn-sm red-btn me-1" @click="Close()">
                    {{ $store.getters.GetTranslation('nav', 'nav_close') }}
                </button>
            </div>
        </nav>
    </div>
</template>

<script>
import api from "@/api/main"
import { Dropdown } from "bootstrap/dist/js/bootstrap.esm.min.js";

import ViewNotifications from "@/components/Modals/Notifications/ViewNotifications"
import DutyToggle from "@/components/Modals/General/DutyToggle"
import Settings from "@/components/Modals/General/Settings"
import ChangeStatusModal from '@/components/Modals/General/ChangeStatus'

export default {
    name: "Nav",
    components: {
        ViewNotifications,
        DutyToggle,
        Settings,
        ChangeStatusModal
    },
    data() {
        return {
            mouseEvents: {
                onDropdownListEl: false,
                onDropdownEl: false,
            },
            modalData: {
                ViewNotifications: {
                    show: false,
                },
                DutyToggle: {
                    show: false,
                },
                Settings: {
                    show: false,
                },
                ChangePlayerStatus: {
                    show: false,
                    player: false,
                }
            },
            elapsedTime: '',

            perms: {
                bolo: false,
                warrant: false,
                dbSearch: false,
                createReport: false,
                viewReport: false,
                activity: false,
                custom1: false,
                custom2: false,
                custom3: false,
                clockin: false,
            }
        };
    },
    mounted() {
        setTimeout(() => {
            if ( !this.$store.getters.IsLoggedIn() && this.$router.currentRoute.value.name !== 'Login' ) {
                this.changeTab('')

                this.SendNotification(
                    this.$store.getters.GetTranslation('nav', 'error_1'),
                    this.$store.getters.GetTranslation('nav', 'error_1_msg'),
                    10000,
                    'error',
                    false,
                    true
                );
            } else {
                this.RefreshBS();
            }

            this.CheckPerms()
        }, 500);
    },
    methods: {
        CheckPerms() {
            let player = this.$store.getters.GetSelf()

            if (player) {
                const playerJob = player.job

                this.perms.bolo = this.$store.getters.HasPerm(playerJob, 'bolos', 'tab')
                this.perms.warrant = this.$store.getters.HasPerm(playerJob, 'warrants', 'tab')
                this.perms.dbSearch = this.$store.getters.HasPerm(playerJob, 'dbSearch')
                this.perms.createReport = this.$store.getters.HasPerm(playerJob, 'createReport')
                this.perms.viewReport = this.$store.getters.HasPerm(playerJob, 'viewReport')
                this.perms.activity = this.$store.getters.HasPerm(playerJob, 'activity')
                this.perms.custom1 = this.$store.getters.HasPerm(playerJob, 'customTab1')
                this.perms.custom2 = this.$store.getters.HasPerm(playerJob, 'customTab2')
                this.perms.custom3 = this.$store.getters.HasPerm(playerJob, 'customTab3')
                this.perms.clockin = this.$store.getters.HasPerm(playerJob, 'clockin')
            }
        },

        Close() {
            api.general.ToggleVisibility()
        },
        NavbarClick(tab) {
            this.ToggleDropdown('navbarDropdown')

            this.changeTab(tab)
        },
        Logout() {
            if (!this.$store.getters.IsOnDuty()) {
                api.general.Logout()
                this.changeTab('')

                this.SendNotification(
                    this.$store.getters.GetTranslation('nav', 'logged_out'),
                    this.$store.getters.GetTranslation('nav', 'logged_out_msg'),
                    5000,
                    'success',
                    false,
                    false
                );
            } else {
                this.ToggleDropdown("profileDropdown");

                this.SendNotification(
                    this.$store.getters.GetTranslation('nav', 'error_2'),
                    this.$store.getters.GetTranslation('nav', 'error_2_msg'),
                    5000,
                    'error',
                    false,
                    true
                );
            }
        },

        ChangeStatus() {
            this.ToggleDropdown("profileDropdown");
            this.modalData.ChangePlayerStatus.show = true;
            this.modalData.ChangePlayerStatus.player = this.$store.getters.GetSelf();

            setTimeout(() => {
                this.modalData.ChangePlayerStatus.show = false;
            }, 200);
        },

        SettingsModal() {
            this.ToggleDropdown("profileDropdown");
            this.modalData.Settings.show = true;

            setTimeout(() => {
                this.modalData.Settings.show = false;
            }, 200);
        },

        DutyModal() {
            this.ToggleDropdown("profileDropdown");
            this.modalData.DutyToggle.show = true;

            setTimeout(() => {
                this.modalData.DutyToggle.show = false;
            }, 200);
        },

        ClearNotifications() {
            this.ToggleDropdown("profileDropdown");

            this.$store.commit('ClearStoredNotifications')

            this.SendNotification(
                this.$store.getters.GetTranslation('nav', 'clear_notif'),
                this.$store.getters.GetTranslation('nav', 'clear_notif_msg'),
                4000,
                'success',
                false
            );
        },
        ViewNotifications() {
            this.ToggleDropdown("profileDropdown");

            this.modalData.ViewNotifications.show = true;

            setTimeout(() => {
                this.modalData.ViewNotifications.show = false;
            }, 200);
        },

        ToggleDropdown(id, useMouseThread) {
            var dropdownEl = document.getElementById(id);
            var dropdownInstance = Dropdown.getOrCreateInstance(dropdownEl);

            if ( id === 'profileDropdown' && this.$store.getters.IsOnDuty() ) {
                this.elapsedTime = this.$store.getters.GetElapsedTimeOnDuty();
            }

            if (dropdownEl.classList.contains("show")) {
                dropdownInstance.hide();
            } else {
                dropdownInstance.show();

                if (useMouseThread) {
                    var mouseThread = setInterval(() => {
                        if ( dropdownEl.classList.contains("show") ) {
                            if ( !this.mouseEvents.onDropdownListEl && !this.mouseEvents.onDropdownEl ) {
                                dropdownInstance.hide();
                                clearInterval(mouseThread);
                            }
                        } else {
                            clearInterval(mouseThread);
                        }
                    }, 100);
                }
            }
        },
        UpdateMouseState(type, status) {
            if (type == "listEl") {
                this.mouseEvents.onDropdownListEl = status;
            } else if (type == "dropEl") {
                this.mouseEvents.onDropdownEl = status;
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

#nav {
    animation: fadeIn ease 0.2s;
    animation-iteration-count: 1;
    animation-fill-mode: forwards;
}

@keyframes fadeIn {
    0% {
        opacity: 0;
    }
    100% {
        opacity: 1;
    }
}

#notify-feed-li {
    #notify-feed-clear {
        display: none;
    }

    &:hover {
        #notify-feed-clear {
            display: inline;
        }
    }
}

.active {
    background-color: $primaryColorLightHover;
    border-radius: 5px;

    &:hover {
        color: $textColorHover !important;
        background-color: #383a449a;
    }
}

.dropdown-btn-item {
    &:hover {
        background-color: $primaryColorLightHover !important;
    }
}

.navbar {
    background-color: $primaryColorLight;
    border-radius: 5px;
}

.navbar-brand {
    font-weight: 500;
}

#closeMDT {
    color: $textColor;
    float: right;
    transition: 0.5s;

    &:hover {
        color: $textColorHover;
    }
}
</style>
