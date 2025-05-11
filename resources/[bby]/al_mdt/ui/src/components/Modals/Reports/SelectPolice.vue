<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="selectLawEnforcementLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="selectLawEnforcementLabel">
                        {{ $store.getters.GetTranslation('selectpolice', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <!-- Search -->
                    <div class="container-fluid">
                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-6 text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('selectpolice', 'search') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('selectpolice', 'placeholder')"
                                    v-model="searchInput" />
                            </div>
                        </div>
                    </div>

                    <!-- List -->
                    <div class="container-fluid" v-if="players.length > 0">
                        <div class="row justify-content-md-center mdt-form mt-4">
                            <div class="col-8 mdt-table-container">
                                <table class="table text-center">
                                    <thead>
                                        <tr>
                                            <th scope="col" style="width: 20%">
                                                {{ $store.getters.GetTranslation('selectpolice', 'col_call') }}
                                            </th>
                                            <th scope="col" style="width: 50%">
                                                {{ $store.getters.GetTranslation('selectpolice', 'col_name') }}
                                            </th>
                                            <th scope="col" style="width: 30%">
                                                {{ $store.getters.GetTranslation('selectpolice', 'col_act') }}
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <template v-for="player in players" :key="player.identifier">
                                            <tr
                                                v-if=" searchInput.length > 0 ? player.name.toLowerCase().match(searchInput.toLowerCase()) : true ">
                                                <td scope="row"
                                                    :class="{ 'mdt-placeholder': player.callsign.length <= 0 }">
                                                    {{ player.callsign.length > 0 ? player.callsign :
                                                    $store.getters.GetTranslation('selectpolice', 'none') }}
                                                </td>
                                                <td>{{ player.name }}</td>
                                                <td>
                                                    <div class="row justify-content-center">
                                                        <div class="col text-center">
                                                            <template
                                                                v-if=" selectedPlayers.find((data) => data.identifier === player.identifier) === undefined ">
                                                                <button type="button" class="btn btn-sm orange-btn"
                                                                    @click=" SelectPlayer( player ) ">
                                                                    {{ $store.getters.GetTranslation('selectpolice',
                                                                    'select') }}
                                                                </button>
                                                            </template>

                                                            <template v-else>
                                                                <button type="button" class="btn btn-sm red-btn"
                                                                    @click=" SelectPlayer( player ) ">
                                                                    {{ $store.getters.GetTranslation('selectpolice',
                                                                    'remove') }}
                                                                </button>
                                                            </template>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </template>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn orange-btn me-2" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('selectpolice', 'close') }}
                    </button>

                    <button type="button" class="btn red-btn me-2" @click="ClearAll()">
                        {{ $store.getters.GetTranslation('selectpolice', 'clear') }}
                    </button>

                    <button type="button" class="btn green-btn" @click="Save()">
                        {{ $store.getters.GetTranslation('selectpolice', 'save') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "SelectPolice",
    data() {
        return {
            modalId: "selectLawEnforcement" + "Modal",
            beingShown: false,

            searchInput: '',
            players: [],
            selectedPlayers: [],
            stringArr: "",
        };
    },
    props: ["parentElId", "show", "restoredData"],
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
                this.FetchPlayers();
            }
        }, 100);
    },
    methods: {
        SelectPlayer(player) {
            const playerIdentifier = player.identifier

            if ( this.selectedPlayers.find((data) => data.identifier === playerIdentifier) === undefined ) { // Select
                this.selectedPlayers.push({
                    identifier: playerIdentifier,
                    name: player.name,
                    callsign: player.callsign
                });
            } else { // Remove
                this.selectedPlayers.forEach((val, index, arry) => {
                    if ( val.identifier === playerIdentifier ) {
                        arry.splice(index, 1);
                    }
                });
            }
        },
        RefreshStringArray() {
            var newStringArray = "";

            if (this.selectedPlayers.length > 0) {
                this.selectedPlayers.forEach((val, index, arry) => {
                    let name = val.callsign.length > 0 ? `${val.callsign} - ${val.name}` : val.name

                    if (arry.length === index + 1) {
                        if (arry.length === 1) {
                            newStringArray = `${newStringArray}` + `${name}.`;
                        } else {
                            newStringArray = `${newStringArray}` + this.$store.getters.GetTranslation('selectpolice', 'and') + ` ${name}.`;
                        }
                    } else {
                        newStringArray = `${newStringArray}` + `${name}, `;
                    }
                });

                this.stringArry = newStringArray;
            } else {
                this.stringArry = "";
            }
        },
        FetchPlayers() {
            this.players = this.$store.getters.GetPlayersFromJob('police');

            if ( this.restoredData ) {
                this.selectedPlayers = this.restoredData
            }
        },
        Save() {
            this.RefreshStringArray();

            if (this.selectedPlayers.length > 0) {
                this.$emit("update-selected", this.selectedPlayers, this.stringArry);
            } else {
                this.$emit("update-selected", false);
            }

            this.CloseModal()
        },
        ClearAll() {
            this.selectedPlayers = []
        },

        ShowModal() {
            if (!this.beingShown) {
                // Append modal to body
                var modalEl = document.getElementById(this.modalId);
                document.body.appendChild(modalEl);

                var modalInstance = Modal.getOrCreateInstance(modalEl);
                modalInstance.show();

                this.$store.commit('SetModalOpen')
                this.beingShown = true;
            }
        },
        CloseModal() {
            // Append modal to original parent
            var modalEl = document.getElementById(this.modalId);
            var modalInstance = Modal.getInstance(modalEl);
            modalInstance.hide();

            setTimeout(() => {
                var parentEl = document.getElementById(this.parentElId);
                parentEl.appendChild(modalEl);

                // Reset session
                this.searchInput = '';
            }, 175);

            this.$store.commit('SetModalClosed')
            this.beingShown = false;
        },
    },
};
</script>

<style lang="scss" scoped>
$primaryColorLightHover: #383a44;
$textColor: #ececec;

.mdt-table-container {
    background-color: $primaryColorLightHover;
    padding: 10px;
    border-radius: 5px;
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
</style>
