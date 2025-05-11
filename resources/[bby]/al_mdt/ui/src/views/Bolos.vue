<template>
    <div id="bolos" class="container mt-3 p-3">
        <!-- Main start -->
        <div id="mdt-bolo-main" class="container-fluid fade show">
            <div class="row justify-content-center mb-4">
                <div class="col h3 text-center">{{ $store.getters.GetTranslation('bolos', 'title') }}</div>
            </div>

            <template v-if="perms.create">
                <div class="row justify-content-center">
                    <div class="col h5 text-center">{{ $store.getters.GetTranslation('bolos', 'register') }}</div>

                    <div class="row">
                        <div class="col text-center">
                            <button @click="OpenBoloCreation('vehicle')" type="button"
                                class="btn btn-sm orange-btn me-3" style="font-weight: bold">
                                <i class="fas fa-plus me-1"></i>
                                {{ $store.getters.GetTranslation('bolos', 'voi') }}
                            </button>

                            <button @click="OpenBoloCreation('person')" type="button" class="btn btn-sm orange-btn"
                                style="font-weight: bold">
                                <i class="fas fa-plus me-1"></i>
                                {{ $store.getters.GetTranslation('bolos', 'poi') }}
                            </button>
                        </div>
                    </div>
                </div>
            </template>

            <div class="container-fluid">
                <div class="row justify-content-center mb-2 mt-5">
                    <div class="col-4 h4 text-center">{{ $store.getters.GetTranslation('bolos', 'active') }}</div>
                </div>

                <BoloTable :parentElId='"bolos"' :options="{
                        vehicleBolo: true,
                        personBolo: true,
                        warrants: false,
                        allowEdits: true,
                    }" />
            </div>
        </div>

        <template v-if="createBoloToggle">
            <CreateBoloForm @close="CloseBoloCreation" :type="creationType" />
        </template>
    </div>
</template>

<script>
// Modules
import BoloTable from "../components/Modules/BoloTable";
import CreateBoloForm from "../components/Modules/CreateBolo";

export default {
    name: "Bolos",
    components: {
        BoloTable,
        CreateBoloForm,
    },
    data() {
        return {
            createBoloToggle: false,
            creationType: false,
            perms: {
                create: false,
            }
        };
    },
    mounted() {
        this.CheckPerms();
    },
    methods: {
        CheckPerms() {
            let player = this.$store.getters.GetSelf()

            if (player) {
                const playerJob = player.job

                this.perms.create = this.$store.getters.HasPerm(playerJob, 'bolos', 'create')
            }
        },

        OpenBoloCreation(type) {
            this.creationType = type
            this.createBoloToggle = true

            setTimeout(() => {
                this.TransitionEl('mdt-bolo-main', 'mdt-create-bolo')
            }, 10)
        },

        CloseBoloCreation(type, data) {
            this.TransitionEl('mdt-create-bolo', 'mdt-bolo-main')

            if ( type && data ) {
                this.CreateBolo(type, data)
            }

            setTimeout(() => {
                this.createBoloToggle = false
                this.creationType = false
            }, 200)
        },

        CreateBolo(type, data) {
            if ( type === 'person' ) {
                this.$store.dispatch('AddPersonBolo', data)
            } else if ( type === 'vehicle' ) {
                this.$store.dispatch('AddVehicleBolo', data)
            }

            this.SendNotification(
                this.$store.getters.GetTranslation('bolos', 'entry_add'),
                this.$store.getters.GetTranslation('bolos', 'entry_add_msg'),
                5000,
                'success',
                false,
            );
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
    },
};
</script>

<style lang="scss" scoped>
$primaryColorLight: #2a2c34;
$primaryColorLightHover: #383a44;
$textColor: #ececec;

#bolos {
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
}
</style>
