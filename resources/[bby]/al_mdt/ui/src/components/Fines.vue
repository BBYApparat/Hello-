<template>
    <div id="fines-dashboard" class="container mt-3 p-3">
        <!-- Main Start -->
        <div class="row justify-content-md-center mb-4">
            <div class="col-4 h3 text-center">{{ $store.getters.GetTranslation('fines', 'title') }}</div>
        </div>

        <div class="container col-7 table-con finesTable">
            <ul class="nav nav-pills mb-3 justify-content-center" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="fines-active-tab" data-bs-toggle="pill"
                        data-bs-target="#fines-active" type="button" role="tab" aria-controls="fines-active"
                        aria-selected="true">
                        {{ $store.getters.GetTranslation('fines', 'title_2') }}
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="pills-tabContent">
                <div class="tab-pane fade show active" id="fines-active" role="tabpanel"
                    aria-labelledby="fines-active-tab">
                    <table class="table text-center">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 20%">
                                    {{ $store.getters.GetTranslation('fines', 'col_fine') }}
                                </th>
                                <th scope="col" style="width: 25%">
                                    {{ $store.getters.GetTranslation('fines', 'col_date') }}
                                </th>
                                <th scope="col" style="width: 25%">
                                    {{ $store.getters.GetTranslation('fines', 'col_due') }}
                                </th>
                                <th scope="col" style="width: 30%">
                                    {{ $store.getters.GetTranslation('fines', 'col_act') }}
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <template v-if="$store.getters.HasLoadedFines()">
                                <tr v-for="data in $store.state.fines.data.filter((fine) => fine.paid === 0)"
                                    :key="data.id">
                                    <td scope="row">${{ FormatNumber(data.fine) }}</td>
                                    <td>{{ FormatDate(data.date) }}</td>
                                    <td>{{ FormatDate(data.due_date) }}</td>
                                    <td>
                                        <div class="row justify-content-center">
                                            <div class="col-6">
                                                <button @click="PayFine(data.id, data.fine)" type="button"
                                                    class="btn btn-sm green-btn">
                                                    <i class="fas fa-receipt"></i>
                                                    {{ $store.getters.GetTranslation('fines', 'pay') }}
                                                </button>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>

                    <div class="d-flex justify-content-center">
                        <div class="spinner-border m-auto" style="width: 1.25rem; height: 1.25rem" role="status"
                            v-if="!$store.getters.HasLoadedFines()">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>

                    <template
                        v-if="$store.state.fines.data.filter((fine) => fine.paid === 0).length <= 0 && $store.getters.HasLoadedFines()">
                        <div class="h6 text-center">
                            {{ $store.getters.GetTranslation('fines', 'no_fines') }}
                        </div>
                    </template>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import api from '@/api/main'

export default {
    name: "FinesDashboard",
    methods: {
        async PayFine(id, amount) {
            try {
                const resp = await api.reports.PayFine({ id: id, fine: amount })

                if (resp) {
                    this.$store.dispatch('GetFines', this.$store.state.fines.identifier)

                    this.SendNotification(
                        this.$store.getters.GetTranslation('fines', 'success'),
                        `${this.$store.getters.GetTranslation('fines', 'success_msg_1')}${this.FormatNumber(amount)} ${this.$store.getters.GetTranslation('fines', 'success_msg_2')}`,
                        5000,
                        'success',
                        false,
                        false
                    );
                } else {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('fines', 'error_1'),
                        `${this.$store.getters.GetTranslation('fines', 'error_1_msg_1')}${this.FormatNumber(amount)} ${this.$store.getters.GetTranslation('fines', 'error_1_msg_2')}`,
                        5000,
                        'error',
                        false,
                        false
                    );
                }
            } catch (error) {
                console.log(error)
                this.SendNotification(
                    this.$store.getters.GetTranslation('fines', 'error_2'),
                    this.$store.getters.GetTranslation('fines', 'error_2_msg'),
                    5000,
                    'error',
                    false,
                    false
                );
            }
        }
    }
};
</script>

<style lang="scss" scoped>
$primaryColorLight: #2a2c34;
$primaryColorLightHover: #383a44;
$textColor: #ececec;

#fines-dashboard {
    background-color: $primaryColorLight;
    border-radius: 5px;
}

.finesTable {
    background-color: $primaryColorLight;
    border-radius: 5px;

    .table {
        color: $textColor;
        background-color: $primaryColorLightHover;
    }
}

.table-con {
    border: 10px $primaryColorLightHover solid;
    border-radius: 5px;
    background-color: $primaryColorLightHover;
}
</style>
