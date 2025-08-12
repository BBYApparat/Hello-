<template>
    <div class="container-fluid">
        <!-- Modals -->
        <ViewBoloModal @edit-bolo="EditBolo" @delete-bolo="DeleteBoloConfirmation" :parentElId="parentElId"
            :show="modalData.ViewBoloInfo.show" :data="modalData.ViewBoloInfo.data" />

        <AffirmationModal @affirmation-cb="DeleteBolo" :parentElId="parentElId" :show="modalData.Affirmation.show"
            :bodyText="modalData.Affirmation.data" />

        <EditBoloModal :parentElId="parentElId" :show="modalData.EditBoloInfo.show"
            :boloData="modalData.EditBoloInfo.data" />

        <div class="container col-xxl-10 col-xl-11 table-con boloTable">
            <!-- Navigation -->
            <ul class="nav nav-pills justify-content-center" id="pills-tab" role="tablist">
                <li v-if="OptionAllowed('vehicle')" class="nav-item" role="presentation">
                    <button class="nav-link" :class="{ active: OptionAllowed('vehicle') }" id="dash-bolo-vehicle-tab"
                        data-bs-toggle="pill" data-bs-target="#dash-bolo-vehicle" type="button" role="tab"
                        aria-controls="dash-bolo-vehicle" aria-selected="true">
                        {{ $store.getters.GetTranslation('bolotable', 'voi') }}
                    </button>
                </li>

                <li v-if="OptionAllowed('people')" class="nav-item" role="presentation">
                    <button class="nav-link" :class="{ active: OptionAllowed('people') && !OptionAllowed('vehicle') }"
                        id="dash-bolo-people-tab" data-bs-toggle="pill" data-bs-target="#dash-bolo-people" type="button"
                        role="tab" aria-controls="dash-bolo-people" aria-selected="false">
                        {{ $store.getters.GetTranslation('bolotable', 'poi') }}
                    </button>
                </li>

                <li v-if="OptionAllowed('warrants')" class="nav-item" role="presentation">
                    <button class="nav-link"
                        :class="{ active: OptionAllowed('warrants') && !OptionAllowed('people') && !OptionAllowed('vehicle') }"
                        id="dash-warrant-tab" data-bs-toggle="pill" data-bs-target="#dash-warrant" type="button"
                        role="tab" aria-controls="dash-warrant" aria-selected="false">
                        {{ $store.getters.GetTranslation('bolotable', 'war') }}
                    </button>
                </li>
            </ul>

            <!-- Vehicles -->
            <div class="tab-content" id="pills-tabContent">
                <div v-if="OptionAllowed('vehicle')" class="tab-pane fade"
                    :class="{ active: OptionAllowed('vehicle'), show: OptionAllowed('vehicle') }" id="dash-bolo-vehicle"
                    role="tabpanel" aria-labelledby="dash-bolo-vehicle-tab">
                    <table class="table text-center">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 5%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_ref') }}
                                </th>
                                <th scope="col" style="width: 40%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_model') }}
                                </th>
                                <th scope="col" style="width: 10%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_plate') }}
                                </th>
                                <th scope="col" style="width: 30%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_lseen') }}
                                </th>
                                <th scope="col" style="width: 15%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_act') }}
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr v-for="data in $store.state.bolos.vehBolos" :key="data.id">
                                <td scope="row">{{ FormatStringLength(data.id, 7) }}</td>
                                <td>{{ FormatStringLength(data.model, 30) }}</td>
                                <td>{{ FormatStringLength(data.plate, 10) }}</td>
                                <td>{{ FormatStringLength(data.lastSeen, 26) }}</td>
                                <td>
                                    <button @click="ViewBolo({ type: 'vehicle', info: data, options: options })"
                                        type="button" class="btn btn-sm orange-btn">
                                        {{ $store.getters.GetTranslation('bolotable', 'view') }}
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <template v-if="$store.state.bolos.vehBolos.length <= 0">
                        <div class="h6 text-center">
                            {{ $store.getters.GetTranslation('bolotable', 'no_results') }}
                        </div>
                    </template>
                </div>

                <!-- People -->
                <div v-if="OptionAllowed('people')" class="tab-pane fade"
                    :class="{ active: OptionAllowed('people') && !OptionAllowed('vehicle'), show: OptionAllowed('people') && !OptionAllowed('vehicle') }"
                    id="dash-bolo-people" role="tabpanel" aria-labelledby="dash-bolo-people-tab">
                    <table class="table text-center">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 5%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_ref') }}
                                </th>
                                <th scope="col" style="width: 40%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_name') }}
                                </th>
                                <th scope="col" style="width: 40%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_lseen') }}
                                </th>
                                <th scope="col" style="width: 15%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_act') }}
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr v-for="data in $store.state.bolos.personBolos" :key="data.id">
                                <td scope="row">{{ FormatStringLength(data.id, 7) }}</td>
                                <td>{{ FormatStringLength(data.name, 30) }}</td>
                                <td>{{ FormatStringLength(data.lastSeen, 30) }}</td>
                                <td>
                                    <button type="button" class="btn btn-sm orange-btn"
                                        @click=" ViewBolo({ type: 'person', info: data, options: options })">
                                        {{ $store.getters.GetTranslation('bolotable', 'view') }}
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <template v-if="$store.state.bolos.personBolos.length <= 0">
                        <div class="h6 text-center">
                            {{ $store.getters.GetTranslation('bolotable', 'no_results') }}
                        </div>
                    </template>
                </div>

                <!-- Warrants -->
                <div v-if="OptionAllowed('warrants')" class="tab-pane fade"
                    :class="{ active: OptionAllowed('warrants') && !OptionAllowed('people') && !OptionAllowed('vehicle'), show: OptionAllowed('warrants') && !OptionAllowed('people') && !OptionAllowed('vehicle') }"
                    id="dash-warrant" role="tabpanel" aria-labelledby="dash-warrant-tab">
                    <table class="table text-center">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 5%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_ref') }}
                                </th>
                                <th scope="col" style="width: 40%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_name') }}
                                </th>
                                <th scope="col" style="width: 40%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_lseen') }}
                                </th>
                                <th scope="col" style="width: 15%">
                                    {{ $store.getters.GetTranslation('bolotable', 'col_act') }}
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr v-for="data in $store.state.bolos.warrants" :key="data.id">
                                <td scope="row">{{ FormatStringLength(data.id, 7) }}</td>
                                <td>{{ FormatStringLength(data.name, 30) }}</td>
                                <td>{{ FormatStringLength(data.lastSeen, 30) }}</td>
                                <td>
                                    <button @click="ViewBolo({ type: 'warrant', info: data, options: options, })"
                                        type="button" class="btn btn-sm orange-btn">
                                        {{ $store.getters.GetTranslation('bolotable', 'view') }}
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <template v-if="$store.state.bolos.warrants.length <= 0">
                        <div class="h6 text-center">
                            {{ $store.getters.GetTranslation('bolotable', 'no_results') }}
                        </div>
                    </template>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import ViewBoloModal from "@/components/Modals/Bolos/ViewBolo";
import EditBoloModal from "@/components/Modals/Bolos/EditBolo";
import AffirmationModal from "@/components/Modals/General/Affirmation";

export default {
    name: "BoloTableModule",
    components: {
        ViewBoloModal,
        EditBoloModal,
        AffirmationModal,
    },
    props: [
        "parentElId",
        "options",
        /*
            vehicleBolo: bool
            personBolo: bool
            warrants: bool
        */
    ],
    data() {
        return {
            modalData: {
                ViewBoloInfo: {
                    data: new Object(),
                    cb: new Object(),
                    show: false,
                },
                Affirmation: {
                    data: new Object(),
                    show: false,
                },
                EditBoloInfo: {
                    data: new Object(),
                    show: false,
                },
            },
        };
    },
    methods: {
        ViewBolo(data) {
            this.modalData.ViewBoloInfo.data = data;
            this.modalData.ViewBoloInfo.show = true;

            setTimeout(() => {
                this.modalData.ViewBoloInfo.show = false;
            }, 200);
        },

        EditBolo(data) {
            setTimeout(() => {
                this.modalData.EditBoloInfo.data = data;
                this.modalData.EditBoloInfo.show = true;

                setTimeout(() => {
                    this.modalData.EditBoloInfo.show = false;
                }, 200);
            }, 350)
        },

        DeleteBoloConfirmation(type, data) {
            if (type === "vehicle" || type === "person") {
                this.modalData.Affirmation.data = this.$store.getters.GetTranslation('bolotable', 'delete_bolo_warning');
            } else if ( type === 'warrant' ) {
                this.modalData.Affirmation.data = this.$store.getters.GetTranslation('bolotable', 'delete_warrant_warning');
            }

            this.modalData.ViewBoloInfo.cb = {
                type: type,
                data: data,
            };

            setTimeout(() => {
                this.modalData.Affirmation.show = true;

                setTimeout(() => {
                    this.modalData.Affirmation.show = false;
                }, 200);
            }, 350)
        },

        DeleteBolo(status) {
            if (status) {
                let type = this.modalData.ViewBoloInfo.cb.type;
                let data = this.modalData.ViewBoloInfo.cb.data;

                if ( type === 'person' ) {
                    this.$store.dispatch('DeletePersonBolo', data)
                } else if ( type === 'vehicle' ) {
                    this.$store.dispatch('DeleteVehicleBolo', data)
                } else if ( type === 'warrant' ) {
                    this.$store.dispatch('DeleteWarrant', data)
                }

                this.SendNotification(
                    this.$store.getters.GetTranslation('bolotable', 'deleted'),
                    this.$store.getters.GetTranslation('bolotable', 'deleted_msg'),
                    5000,
                    'success',
                    false,
                );
            }

            this.modalData.ViewBoloInfo.cb = {};
        },



        OptionAllowed(type) {
            if (type == "vehicle") {
                if ( this.options != undefined && this.options.vehicleBolo != undefined && this.options.vehicleBolo == true) {
                    return true;
                } else if ( this.options == undefined || this.options.vehicleBolo == undefined ) {
                    return true;
                } else {
                    return false;
                }
            } else if (type == "people") {
                if ( this.options != undefined && this.options.personBolo != undefined && this.options.personBolo == true ) {
                    return true;
                } else if ( this.options == undefined || this.options.personBolo == undefined ) {
                    return true;
                } else {
                    return false;
                }
            } else if (type == "warrants") {
                if ( this.options != undefined && this.options.warrants != undefined && this.options.warrants == true ) {
                    return true;
                } else if ( this.options == undefined || this.options.warrants == undefined ) {
                    return true;
                } else {
                    return false;
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

.boloTable {
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
</style>
