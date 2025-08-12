<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="criminalCodeLabel" aria-hidden="true">
        <div class="modal-dialog modal-fullscreen">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="criminalCodeLabel">
                        {{ $store.getters.GetTranslation('criminalcode', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="row justify-content-md-center mb-2">
                        <div class="col-6 h4 text-center">
                            {{ criminalCodeDict.length > 0 ? $store.getters.GetTranslation('criminalcode', 'title') :
                            $store.getters.GetTranslation('criminalcode', 'nocrimcode') }}
                        </div>
                    </div>

                    <div class="container-fluid">
                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-3 text-center">
                                <label for="mdt-criminalcode-modal" class="col-form-label">
                                    {{ $store.getters.GetTranslation('criminalcode', 'search') }}
                                </label>
                                <input id="mdt-criminalcode-modal" class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('criminalcode', 'placeholder')"
                                    v-model="inputFields.search" @focus="UpdateTables(true)"
                                    @blur="UpdateTables(false)" />
                            </div>
                        </div>
                    </div>

                    <div class="container-fluid" v-if="criminalCodeDict.length > 0">
                        <template v-for="(sectionData, index) in criminalCodeDict" :key="`criminalCode_${index}`">
                            <div class="row justify-content-md-center mdt-form mt-4"
                                :class="{ 'hide-section': search.tableMetadata[index] }">
                                <div class="row justify-content-md-center mb-1">
                                    <div class="col-5 h5 text-center">
                                        {{ sectionData.label }}
                                    </div>
                                </div>

                                <div class="col-10 mdt-table-container">
                                    <table class="table text-center" :id="`criminalCode_${index}`">
                                        <thead>
                                            <tr>
                                                <th scope="col" style="width: 20%">
                                                    {{ $store.getters.GetTranslation('criminalcode', 'col_offense') }}
                                                </th>
                                                <th scope="col" style="width: 10%">
                                                    {{ $store.getters.GetTranslation('criminalcode', 'col_class') }}
                                                </th>
                                                <th scope="col" style="width: 20%">
                                                    {{ $store.getters.GetTranslation('criminalcode', 'col_pun') }}
                                                </th>
                                                <th scope="col" style="width: 42.5%">
                                                    {{ $store.getters.GetTranslation('criminalcode', 'col_des') }}
                                                </th>
                                                <th scope="col" style="width: 7.5%">
                                                    {{ $store.getters.GetTranslation('criminalcode', 'col_act') }}
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <template v-for="(data, i) in sectionData.list"
                                                :key="`criminalCode_${index}_${i}`">
                                                <tr
                                                    v-if=" inputFields.search !== '' ? data.offense.toLowerCase().match(inputFields.search.toLowerCase()) : true ">
                                                    <td scope="row">{{ data.offense }}</td>
                                                    <td>{{ data.class }}</td>
                                                    <td>{{ data.punishment.label }}</td>
                                                    <td>{{ data.description }}</td>
                                                    <td>
                                                        <div class="row justify-content-center">
                                                            <div class="col">
                                                                <template
                                                                    v-if="selectedCharges.metaData[`criminalCode_${index}_${i}`] !== undefined ? !selectedCharges.metaData[`criminalCode_${index}_${i}`].count : true ">
                                                                    <button type="button" class="btn btn-sm orange-btn"
                                                                        @click=" SelectCharge( data, `criminalCode_${index}_${i}` ) ">
                                                                        {{ $store.getters.GetTranslation('criminalcode',
                                                                        'select') }}
                                                                    </button>
                                                                </template>

                                                                <template
                                                                    v-else-if=" selectedCharges.metaData[`criminalCode_${index}_${i}`].count != undefined && selectedCharges.metaData[`criminalCode_${index}_${i}`].count > 0 ">
                                                                    <label for="mdt-criminalcode-count"
                                                                        class="col-form-label pt-1 pb-1">
                                                                        <strong>{{
                                                                            $store.getters.GetTranslation('criminalcode',
                                                                            'count') }} - {{
                                                                            selectedCharges.metaData[`criminalCode_${index}_${i}`].count
                                                                            }}</strong>
                                                                    </label>

                                                                    <br />

                                                                    <button type="button"
                                                                        class="btn btn-sm red-btn me-2"
                                                                        @click=" UpdateCharge( 'sub', `criminalCode_${index}_${i}` ) ">
                                                                        <strong>-</strong>
                                                                    </button>

                                                                    <button type="button" class="btn btn-sm green-btn"
                                                                        @click=" UpdateCharge( 'add', `criminalCode_${index}_${i}` ) ">
                                                                        <strong>+</strong>
                                                                    </button>

                                                                    <br />
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
                        </template>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('criminalcode', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "CriminalCode",
    data() {
        return {
            modalId: "criminalCode" + "Modal",
            beingShown: false,

            inputFields: {
                search: "",
            },
            criminalCodeDict: [],

            search: {
                tableMetadata: {},
                tableInterval: false,
            },
            selectedCharges: {
                list: [],
                metaData: {},
            },
            stringArr: "",
        };
    },
    props: ["parentElId", "show", "restoredData"],
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
                this.FetchCriminalCode();
            }
        }, 100);
    },
    methods: {
        SelectCharge(charge, key) {
            if (this.selectedCharges.metaData[key] == undefined) {
                this.selectedCharges.metaData[key] = {};
            }
            var data = this.selectedCharges.metaData[key];

            data.selected = data.selected != undefined ? !data.selected : true; // Sets data.select to true or false
            data.count = 1;

            var found = false;
            this.selectedCharges.list.forEach((val, index, arry) => {
                if (val.key === key) {
                    found = true;
                    arry.splice(index, 1);
                }
            });

            if (!found) {
                charge.count = 1;

                this.selectedCharges.list.push({
                    data: charge,
                    key: key,
                });
            }
        },
        UpdateCharge(action, key) {
            var data = this.selectedCharges.metaData[key];

            if (action == "sub") {
                data.count--;

                if (data.count <= 0) {
                    data.count = 0;
                    data.selected = false;
                }
            } else if (action == "add") {
                data.count++;
            }

            this.selectedCharges.list.forEach((val, index, arry) => {
                if (val.key == key) {
                    if (data.count > 0) {
                        val.data.count = data.count;
                    } else {
                        arry.splice(index, 1);
                    }
                }
            });
        },
        RefreshStringArray() {
            var newStringArray = "";

            if (this.selectedCharges.list.length > 0) {
                this.selectedCharges.list.forEach((val, index, arry) => {
                    if ( arry.length == index + 1 ) {
                        newStringArray += `- [${val.data.class}] ${val.data.offense} x${val.data.count}`;
                    } else {
                        newStringArray += `- [${val.data.class}] ${val.data.offense} x${val.data.count}\n`;
                    }
                });

                this.stringArry = newStringArray;
            } else {
                this.stringArry = "";
            }
        },
        UpdateTables(state) {
            if (state && !this.search.tableInterval) {
                this.search.tableInterval = setInterval(() => {
                    if (this.beingShown) {
                        for (var index = 0; index != this.criminalCodeDict.length; index++) {
                            var table = document.getElementById(`criminalCode_${index}`);
                            if (table != undefined) {
                                var totalRowCount = table.rows.length;
                                this.search.tableMetadata[index] = totalRowCount <= 1;
                            }
                        }
                    }
                }, 250);
            } else if (!state && this.search.tableInterval) {
                clearInterval(this.search.tableInterval);
                this.search.tableInterval = false;

                // Final table check
                for (var index = 0; index != this.criminalCodeDict.length; index++) {
                    var table = document.getElementById(`criminalCode_${index}`);
                    if (table != undefined) {
                        var totalRowCount = table.rows.length;
                        this.search.tableMetadata[index] = totalRowCount <= 1;
                    }
                }
            }
        },
        FetchCriminalCode() {
            this.criminalCodeDict = this.$store.state.config.CriminalCode;

            this.UpdateTables();

            if ( this.restoredData ) {
                this.selectedCharges = this.restoredData
            }
        },
        ResetSession() {
            this.inputFields = {
                search: "",
            };
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
                this.ResetSession();
            }, 175);

            this.RefreshStringArray();

            if (this.selectedCharges.list.length > 0) {
                this.$emit("update-charges", this.selectedCharges.list, this.stringArry, this.selectedCharges.metaData);
            } else {
                this.$emit("update-charges", false);
            }

            this.$store.commit('SetModalClosed')
            this.beingShown = false;
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

#criminalCodeModal {
    .mdt-table-container {
        background-color: $primaryColorLightHover;
        padding: 10px;
        border-radius: 5px;
    }

    .hide-section {
        display: none !important;
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

    .list-group-item {
        background-color: $primaryColorLightHover;
        color: $textColor;

        &:hover {
            background-color: #383a44af;
            color: $textColorHover;
        }
    }
}
</style>
