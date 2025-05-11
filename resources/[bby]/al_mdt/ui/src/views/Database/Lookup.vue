<template>
    <div id="database-lookup" class="container mt-3 p-3 fade show">
        <!-- Modals -->
        <SearchCharacterModal @found-character="SetCharData" :parentElId="'database-lookup'"
            :show="modalData.SearchChar.show" :id="'database-lookup-search-char'" :detailed="true" />

        <SearchPlateModal @found-vehicle="SetVehData" :parentElId="'database-lookup'"
            :show="modalData.SearchPlate.show" />

        <!-- Main Start -->
        <template v-if="!showingProfile.veh && !showingProfile.char">
            <div id="lookup-main" class="fade">
                <div class="row justify-content-md-center mb-4">
                    <div class="col-4 h3 text-center">{{ $store.getters.GetTranslation('lookup', 'title') }}</div>
                </div>

                <div class="container-fluid">
                    <div class="row justify-content-md-center mb-2">
                        <div class="col-4 h4 text-center">{{ $store.getters.GetTranslation('lookup', 'title_2') }}</div>
                    </div>

                    <div class="container col-xxl-7 col-xl-8 table-con boloTable">
                        <ul class="nav nav-pills mb-3 justify-content-center" id="pills-tab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="db-lookup-main-tab" data-bs-toggle="pill"
                                    data-bs-target="#db-lookup-main" type="button" role="tab"
                                    aria-controls="db-lookup-civ" aria-selected="true">
                                    {{ $store.getters.GetTranslation('lookup', 'title_3') }}
                                </button>
                            </li>
                        </ul>

                        <div class="tab-content" id="pills-tabContent">
                            <div class="tab-pane fade active show" id="db-lookup-main" role="tabpanel"
                                aria-labelledby="db-lookup-main-tab">
                                <div class="row justify-content-md-center">
                                    <div class="col">
                                        <div class="mt-3 mb-2 text-center">
                                            <button type="button" class="btn btn-sm blue-btn me-5"
                                                @click="SearchForCharacter()">
                                                {{ $store.getters.GetTranslation('lookup', 'civ_search') }}
                                            </button>

                                            <button type="button" class="btn btn-sm blue-btn" @click="SearchPlate()">
                                                {{ $store.getters.GetTranslation('lookup', 'plate_search') }}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </template>

        <template v-if="showingProfile.char">
            <ViewCharProfile @go-back="Return()" @switch-veh-profile="SwitchToVehProfile" :parentEl="'database-lookup'"
                :charData="moduleData.char.data" :charName="moduleData.char.name" />
        </template>

        <template v-if="showingProfile.veh">
            <ViewVehProfile @go-back="Return()" @switch-char-profile="SwitchToCharProfile" :parentEl="'database-lookup'"
                :vehData="moduleData.veh" />
        </template>
    </div>
</template>

<script>
// Modals
import SearchCharacterModal from "@/components/Modals/General/SearchChar";
import SearchPlateModal from "@/components/Modals/General/SearchPlate";
import ViewCharProfile from "@/components/Modules/Profiles/ViewCharProfile";
import ViewVehProfile from "@/components/Modules/Profiles/ViewVehProfile";

export default {
    name: "Database",
    components: {
        SearchCharacterModal,
        SearchPlateModal,
        ViewCharProfile,
        ViewVehProfile,
    },
    data() {
        return {
            showingProfile: {
                char: false,
                veh: false,
            },
            modalData: {
                SearchChar: {
                    show: false,
                },
                SearchPlate: {
                    show: false,
                },
            },
            moduleData: {
                char: {
                    data: {},
                    name: "",
                },
                veh: {},
            },
        };
    },
    mounted() {
        this.ShowMain()
    },
    methods: {
        Return() {
            this.ResetSession()

            setTimeout(() => {
                this.ShowMain()
            }, 150)
        },
        ResetSession() {
            this.showingProfile = {
                char: false,
                veh: false,
            }

            this.modalData = {
                SearchChar: {
                    show: false,
                },
                SearchPlate: {
                    show: false,
                },
            }

            this.moduleData = {
                char: {
                    data: {},
                    name: "",
                },
                veh: {},
            }
        },
        SetCharData(data, fullName) {
            this.HideMain()

            setTimeout(() => {
                this.moduleData.char.name = fullName;
                this.moduleData.char.data = data;
                this.showingProfile.char = true;
            }, 160)
        },
        SwitchToVehProfile(data) {
            this.ResetSession()

            this.moduleData.veh = data;
            this.showingProfile.veh = true;
        },
        SwitchToCharProfile(data, fullName) {
            this.ResetSession()

            this.moduleData.char.name = fullName;
            this.moduleData.char.data = data;
            this.showingProfile.char = true;
        },
        SetVehData(data) {
            this.HideMain()

            setTimeout(() => {
                this.moduleData.veh = data;
                this.showingProfile.veh = true;
            }, 160)
        },
        SearchForCharacter() {
            if (!this.modalData.SearchChar.show) {
                this.modalData.SearchChar.show = true;

                setTimeout(() => {
                    this.modalData.SearchChar.show = false;
                }, 200);
            }
        },
        SearchPlate() {
            if (!this.modalData.SearchPlate.show) {
                this.modalData.SearchPlate.show = true;

                setTimeout(() => {
                    this.modalData.SearchPlate.show = false;
                }, 200);
            }
        },

        ShowMain() {
            var page = document.getElementById('lookup-main');

            if (page !== undefined) {
                if (!page.classList.contains('show')) {
                    page.classList.add("show");
                }
            }
        },

        HideMain() {
            var page = document.getElementById('lookup-main');

            if (page !== undefined) {
                if (page.classList.contains('show')) {
                    page.classList.remove("show");
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

// Form specific
$formBackground: #4d515e;
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

#database-lookup {
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

    .list-group-item {
        background-color: $primaryColorLightHover;
        color: $textColor;

        &:hover {
            background-color: #383a44af;
            color: $textColorHover;
        }
    }

    .mdt-form {
        input,
        .form-control {
            color: $textColor !important;
            border-color: $primaryColorLight !important;
            background-color: $formBackground !important;
        }

        ::placeholder {
            color: $formPlaceholderText;
        }

        .form-control:focus {
            border-color: $greyColor !important;
            box-shadow: 0 0 0 0.1rem $greyFadedColor;
        }
    }
}
</style>
