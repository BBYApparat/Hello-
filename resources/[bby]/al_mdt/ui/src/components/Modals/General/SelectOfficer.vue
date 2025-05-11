<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="selectOfficerLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="selectOfficerLabel">
                        {{ $store.getters.GetTranslation('selectofficer', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <!-- Search -->
                    <div class="container-fluid">
                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-6 text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('selectofficer', 'search') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('selectofficer', 'ph_name')"
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
                                                {{ $store.getters.GetTranslation('selectofficer', 'col_call') }}
                                            </th>
                                            <th scope="col" style="width: 50%">
                                                {{ $store.getters.GetTranslation('selectofficer', 'col_name') }}
                                            </th>
                                            <th scope="col" style="width: 30%">
                                                {{ $store.getters.GetTranslation('selectofficer', 'col_action') }}
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
                                                    $store.getters.GetTranslation('selectofficer', 'none') }}
                                                </td>
                                                <td>{{ player.name }}</td>
                                                <td>
                                                    <div class="row justify-content-center">
                                                        <div class="col text-center">
                                                            <button type="button" class="btn btn-sm orange-btn"
                                                                @click="SelectPlayer( player )">
                                                                {{ $store.getters.GetTranslation('selectofficer',
                                                                'select') }}
                                                            </button>
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
                    <button type="button" class="btn red-btn me-2" @click="SelectPlayer(false)">
                        {{ $store.getters.GetTranslation('selectofficer', 'clear') }}
                    </button>

                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('selectofficer', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "SelectOfficer",
    data() {
        return {
            modalId: "selectOfficer" + "Modal",
            beingShown: false,

            searchInput: '',
            players: [],
        };
    },
    props: ["parentElId", "show"],
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
            this.$emit('select-officer', player)
            this.CloseModal()
        },
        FetchPlayers() {
            this.players = this.$store.getters.GetPlayersFromJob('police');
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
