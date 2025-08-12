<template>
    <div id="warrants" class="container mt-3 p-3">
        <!-- Main start -->
        <div id="mdt-warrant-main" class="container-fluid fade show">
            <div class="row justify-content-md-center mb-4">
                <div class="col-4 h3 text-center">{{ $store.getters.GetTranslation('warrants', 'title') }}</div>
            </div>

            <template v-if="perms.create">
                <div class="row justify-content-center">
                    <div class="col text-center">
                        <button @click="OpenWarrantCreation()" type="button" class="btn btn-sm orange-btn"
                            style="font-weight: bold">
                            <i class="fas fa-plus me-1"></i>
                            {{ $store.getters.GetTranslation('warrants', 'register') }}
                        </button>
                    </div>
                </div>
            </template>

            <div class="container-fluid">
                <div class="row justify-content-center mt-5">
                    <div class="col-4 h4 text-center">{{ $store.getters.GetTranslation('warrants', 'active') }}</div>
                </div>

                <BoloTable :parentElId='"warrants"' :options="{
                    vehicleBolo: false,
                    personBolo: false,
                    warrants: true,
                    allowEdits: true,
                }" />
            </div>
        </div>

        <template v-if="createWarrantToggle">
            <CreateBoloForm @close="CloseWarrantCreation" :type="'warrant'" />
        </template>
    </div>
</template>

<script>
// Modules
import BoloTable from "../components/Modules/BoloTable";
import CreateBoloForm from "../components/Modules/CreateBolo";

export default {
    name: "Warrants",
    components: {
        BoloTable,
        CreateBoloForm,
    },
    data() {
        return {
            createWarrantToggle: false,
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

                this.perms.create = this.$store.getters.HasPerm(playerJob, 'warrants', 'create')
            }
        },
        
        OpenWarrantCreation() {
            this.createWarrantToggle = true

            setTimeout(() => {
                this.TransitionEl('mdt-warrant-main', 'mdt-create-bolo')
            }, 10)
        },

        CloseWarrantCreation(data) {
            this.TransitionEl('mdt-create-bolo', 'mdt-warrant-main')

            if ( data) {
                this.CreateWarrant(data)
            }

            setTimeout(() => {
                this.createWarrantToggle = false
            }, 200)
        },

        CreateWarrant(data) {
            // Set a temp id then set real id after being registered into db...or create bolo AFTER its been registered into db
            data.id = this.GetRandomInt(10000);

            this.$store.dispatch('AddWarrant', data)

            this.SendNotification(
                this.$store.getters.GetTranslation('warrants', 'entry_add'),
                this.$store.getters.GetTranslation('warrants', 'entry_add_msg'),
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

#warrants {
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
