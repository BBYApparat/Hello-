<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="searchCharLabel" aria-hidden="true">
        <div class=" modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable ">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="searchCharLabel">
                        {{ $store.getters.GetTranslation('searchplate', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="container-fluid" v-if="!queryResults.length > 0">
                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-4 text-center">
                                <label for="mdt-search-modal-plate" class="col-form-label">
                                    {{ $store.getters.GetTranslation('searchplate', 'col_plate') }}
                                    <span class="mdt_required" title="Required">*</span>
                                </label>
                                <input id="mdt-search-modal-plate" class="form-control"
                                    :class="{ 'is-invalid': validationFeedback.length > 0 }" type="text"
                                    placeholder="49HAP060" v-model="inputFields.plate" />
                                <div class="invalid-feedback mt-2">
                                    {{ validationFeedback }}
                                </div>
                            </div>
                        </div>

                        <div class="mt-3 mb-2 text-center">
                            <button type="button" class="btn green-btn" @click="SearchPlate(inputFields.plate)">
                                {{ $store.getters.GetTranslation('searchplate', 'search') }}
                                <span v-if="isLoading">
                                    <div class="spinner-border ms-1" style="width: 1rem; height: 1rem" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </span>
                            </button>
                        </div>
                    </div>

                    <div class="row justify-content-md-center mdt-form" v-if="queryResults.length > 0">
                        <div class="row justify-content-md-center mb-2">
                            <div class="col-4 h5 text-center">
                                {{ queryResults.length }}
                                {{ queryResults.length > 1 ? $store.getters.GetTranslation('searchplate', 'results') :
                                $store.getters.GetTranslation('searchplate', 'result') }}
                                {{ $store.getters.GetTranslation('searchplate', 'found') }}
                            </div>
                        </div>

                        <div class="col-4">
                            <div class="list-group text-center">
                                <a href="#" class="list-group-item list-group-item-action"
                                    v-for="(data, index) in queryResults" :key="index"
                                    @click="SelectVehicle(data.plate)">
                                    {{ data.plate }}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <template v-if="queryResults.length > 0">
                        <button type="button" class="btn grey-btn me-auto" @click="GoBack()">
                            <i class="fas fa-caret-left"></i>
                            {{ $store.getters.GetTranslation('searchplate', 'back') }}
                        </button>
                    </template>

                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('searchplate', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";
import api from '@/api/main'

export default {
    name: "SearchPlate",
    data() {
        return {
            modalId: "searchPlate" + "Modal",
            beingShown: false,
            inputFields: {
                plate: "",
            },

            validationFeedback: "",
            queryResults: new Array(),
            isLoading: false,
        };
    },
    props: ["parentElId", "show"],
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
        GoBack() {
            this.queryResults = [];
            this.inputFields.plate = "";
        },
        SearchPlate(plate) {
                if (plate.length > 1 && !this.isLoading) {
                    this.isLoading = true;
                    this.validationFeedback = "";

                    this.GetVehicle(plate.toUpperCase())
                } else if (!this.isLoading) {
                    this.validationFeedback = this.$store.getters.GetTranslation('searchplate', 'feedback_1');
                }
        },
        async GetVehicle(plate) {
            try {
                const result = await api.vehicles.GetVehiclePlates(plate)

                if (!result) {
                    this.validationFeedback = this.$store.getters.GetTranslation('searchplate', 'feedback_2');
                    this.isLoading = false;
                } else if (Array.isArray(result)) {
                    this.queryResults = result;

                    if (this.queryResults.length == 0) {
                        this.validationFeedback = this.$store.getters.GetTranslation('searchplate', 'feedback_3');
                    }

                    this.isLoading = false;
                }
            } catch (error) {
                console.log('Error fetching vehicle', error)
                this.validationFeedback = this.$store.getters.GetTranslation('searchplate', 'feedback_4');
                this.isLoading = false;
            }
        },
        async SelectVehicle(plate) {
            this.ToggleLoadingScreen(true)
            const result = await api.vehicles.GetProfile(plate)

            this.$emit("found-vehicle", result);
            this.CloseModal();
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
        ResetSession() {
            this.inputFields = {
                plate: "",
            };
            this.isLoading = false;
            this.queryResults = [];
        },
        CloseModal() {
            if (!this.isLoading) {
                // Append modal to original parent
                var modalEl = document.getElementById(this.modalId);
                var modalInstance = Modal.getInstance(modalEl);
                modalInstance.hide();

                setTimeout(() => {
                    var parentEl = document.getElementById(this.parentElId);
                    parentEl.appendChild(modalEl);
                    this.ResetSession();
                }, 175);

                this.$store.commit('SetModalClosed')
                this.beingShown = false;
            }
        },
    },
};
</script>
