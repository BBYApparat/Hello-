<template>
    <div id="dashboard" class="container mt-3 p-3">
        <!-- Main Start -->
        <div class="row justify-content-md-center mb-4">
            <div class="col-4 h3 text-center">{{ $store.getters.GetTranslation('dashboard', 'term_dash') }}</div>
        </div>

        <template v-if="perms.units">
            <div class="container-fluid">
                <div class="row justify-content-md-center mb-2">
                    <div class="col-4 h4 text-center">{{ $store.getters.GetTranslation('dashboard', 'act_units') }}
                    </div>
                </div>

                <ActiveUnitsTable />
            </div>
        </template>

        <template v-if="perms.bolo || perms.warrant">
            <div class="container-fluid">
                <div class="row justify-content-center mb-2 mt-5">
                    <div class="col-4 h4 text-center">{{ $store.getters.GetTranslation('dashboard', 'act_bolo') }}</div>
                </div>

                <BoloTable :parentElId='"dashboard"' :options="{
                    vehicleBolo: perms.bolo,
                    personBolo: perms.bolo,
                    warrants: perms.warrant,
                    allowEdits: false,
                }" />
            </div>
        </template>
    </div>
</template>

<script>
// Modules
import ActiveUnitsTable from "../components/Modules/ActiveUnitsTable";
import BoloTable from "../components/Modules/BoloTable";

export default {
    name: "Dashboard",
    components: {
        ActiveUnitsTable,
        BoloTable,
    },
    data() {
        return {
            perms: {
                units: false,
                bolo: false,
                warrant: false,
            }
        }
    },
    mounted() {
        this.CheckPerms()

        setTimeout(() => {
            this.RefreshBS()
        }, 750)
    },
    methods: {
        CheckPerms() {
            const playerJob = this.$store.getters.GetSelf().job

            this.perms.units = this.$store.getters.HasPerm(playerJob, 'units', 'tab')
            this.perms.bolo = this.$store.getters.HasPerm(playerJob, 'bolos', 'tab')
            this.perms.warrant = this.$store.getters.HasPerm(playerJob, 'warrants', 'tab')
        },
    }
};
</script>

<style lang="scss" scoped>
$primaryColorLight: #2a2c34;
$primaryColorLightHover: #383a44;

#dashboard {
    background-color: $primaryColorLight;
    border-radius: 5px;
}
</style>
