<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="searchCharLabel" aria-hidden="true">
        <div class=" modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable ">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="searchCharLabel">
                        {{ $store.getters.GetTranslation('searchchar', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="container-fluid" v-if="!queryResults.length > 0">
                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-4 text-center">
                                <label for="mdt-search-modal-firstname" class="col-form-label">
                                    {{ $store.getters.GetTranslation('searchchar', 'col_fname') }}
                                </label>
                                <input id="mdt-search-modal-firstname" class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('searchchar', 'ph_fname')"
                                    v-model="inputFields.firstName" />
                            </div>

                            <div class="col-4 text-center">
                                <label for="mdt-search-modal-lastname" class="col-form-label">
                                    {{ $store.getters.GetTranslation('searchchar', 'col_lname') }}
                                </label>
                                <input id="mdt-search-modal-lastname" class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('searchchar', 'ph_lname')"
                                    v-model="inputFields.lastName" />
                            </div>
                        </div>

                        <div class="row justify-content-md-center mdt-form mt-3">
                            <div class="col-6 text-center">
                                <label class="col-form-label" :class="{ 'is-invalid': validationFeedback.length > 0 }">
                                    {{ $store.getters.GetTranslation('searchchar', 'col_gender') }}
                                    <span class="mdt_required" title="Required">*</span>
                                </label>

                                <br />

                                <div class="form-check form-check-inline">
                                    <input id="mdt-search-modal-male" name="genderRadios" class="form-check-input"
                                        type="radio" value="m" @click="inputFields.gender = 'Male'" />
                                    <label class="form-check-label" for="mdt-search-modal-male">
                                        {{ $store.getters.GetTranslation('searchchar', 'col_gender_m') }}
                                    </label>
                                </div>

                                <div class="form-check form-check-inline">
                                    <input id="mdt-search-modal-female" name="genderRadios" class="form-check-input"
                                        type="radio" value="f" @click="inputFields.gender = 'Female'" />
                                    <label class="form-check-label" for="mdt-search-modal-female">
                                        {{ $store.getters.GetTranslation('searchchar', 'col_gender_f') }}
                                    </label>
                                </div>

                                <div class="form-check form-check-inline">
                                    <input id="mdt-search-modal-na" name="genderRadios" class="form-check-input"
                                        type="radio" value="na" @click="inputFields.gender = 'NA'" />
                                    <label class="form-check-label" for="mdt-search-modal-na">
                                        {{ $store.getters.GetTranslation('searchchar', 'col_gender_n') }}
                                    </label>
                                </div>

                                <div class="invalid-feedback mt-2">
                                    {{ validationFeedback }}
                                </div>
                            </div>
                        </div>

                        <div class="mt-3 mb-2 text-center">
                            <button type="button" class="btn green-btn"
                                @click=" SearchForCharacter( inputFields.firstName, inputFields.lastName, inputFields.gender ) ">
                                {{ $store.getters.GetTranslation('searchchar', 'search') }}
                                <span v-if="isLoading">
                                    <div class="spinner-border ms-1" style="width: 1rem; height: 1rem" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </span>
                            </button>
                        </div>

                        <!-- <div class="row justify-content-md-center mt-1">
                            <div class="text-center" style="font-size: 0.8rem"><i class="fas fa-info-circle"></i> Note that this only searches through all <strong>registered</strong> profiles</div>
                        </div> -->
                    </div>

                    <div class="row justify-content-md-center mdt-form" v-if="queryResults.length > 0">
                        <div class="row justify-content-md-center mb-2">
                            <div class="col-4 h5 text-center">
                                {{ queryResults.length }}
                                {{ queryResults.length > 1 ? $store.getters.GetTranslation('searchchar', 'results') :
                                $store.getters.GetTranslation('searchchar', 'result') }}
                                {{ $store.getters.GetTranslation('searchchar', 'found') }}
                            </div>
                        </div>

                        <div class="col-4">
                            <div class="list-group text-center">
                                <a href="#" class="list-group-item list-group-item-action"
                                    v-for="character in queryResults" :key="character.identifier"
                                    @click="SelectCharacter(character)">
                                    {{ `${character.firstName} ${character.lastName}` }}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <template v-if="queryResults.length > 0">
                        <button type="button" class="btn grey-btn me-auto" @click="GoBack()">
                            <i class="fas fa-caret-left"></i>
                            {{ $store.getters.GetTranslation('searchchar', 'back') }}
                        </button>
                    </template>

                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('searchchar', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import api from '@/api/main'
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "SearchChar",
    data() {
        return {
            modalId: "searchChar" + "Modal",
            beingShown: false,
            inputFields: {
                firstName: "",
                lastName: "",
                gender: "",
            },
            validationFeedback: "",
            isLoading: false,
            queryResults: new Array(),
        };
    },
    props: ["parentElId", "show", "detailed", "id"],
    mounted() {
        if (this.id) {
            this.modalId = this.id
        }
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
        SearchForCharacter(firstName, lastName, gender) {
            if ( (firstName === "" && lastName !== "" || firstName !== "" && lastName === "" || firstName !== "" && lastName !== "") && !this.isLoading ) {
                if ( gender !== "" ) {
                    this.isLoading = true;
                    this.validationFeedback = "";

                    this.GetCharacter(firstName, lastName, gender);
                } else if (!this.isLoading) {
                    this.validationFeedback = this.$store.getters.GetTranslation('searchchar', 'feedback_1');
                }
            } else if ( firstName === "" && lastName === "" && !this.isLoading ) {
                this.validationFeedback = this.$store.getters.GetTranslation('searchchar', 'feedback_2');
            }

        },
        async GetCharacter(firstName, lastName, gender) {
            try {
                const result = await api.characters.GetCharacterByName( firstName, lastName, gender );

                if (!result) {
                    this.validationFeedback = this.$store.getters.GetTranslation('searchchar', 'feedback_3');
                } else if (Array.isArray(result)) {
                    this.queryResults = result;

                    if (this.queryResults.length == 0) {
                        this.validationFeedback = this.$store.getters.GetTranslation('searchchar', 'feedback_4');
                    }
                }
                this.isLoading = false;
            } catch (error) {
                console.log('Error fetching character', error)
                this.validationFeedback = this.$store.getters.GetTranslation('searchchar', 'feedback_5');
                this.isLoading = false;
            }
        },
        async SelectCharacter(character) {
            this.CloseModal();

            if (this.detailed) { // Fetch a detailed profile
                this.ToggleLoadingScreen(true)
                const result = await api.characters.GetDetailedProfile(character.identifier);

                this.$emit( "found-character", result, `${character.firstName} ${character.lastName}` );
            } else {
                this.$emit( "found-character", character, `${character.firstName} ${character.lastName}` );
            }
        },
        GoBack() {
            this.queryResults = [];
            this.inputFields.gender = "";
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
                firstName: "",
                lastName: "",
                gender: "",
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
