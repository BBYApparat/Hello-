<template>
    <div id="mdt-create-bolo" class="container-fluid fade">
        <!-- Modals -->
        <SearchCharacterModal @found-character="SetCharData" :parentElId="type == 'warrant' ? 'warrants' : 'bolos'"
            :id="'bolos-search-char'" :show="modalData.SearchChar.show" />

        <div class="row justify-content-center">
            <div class="col-10">
                <div class="row justify-content-center mb-2">
                    <div class="col-4 h5 text-center">
                        <template v-if="type == 'warrant'">
                            {{ $store.getters.GetTranslation('createbolo', 'title_1') }}
                        </template>

                        <template v-else-if="type == 'vehicle'">
                            {{ $store.getters.GetTranslation('createbolo', 'title_2') }}
                        </template>

                        <template v-else-if="type == 'person'">
                            {{ $store.getters.GetTranslation('createbolo', 'title_3') }}
                        </template>
                    </div>
                </div>

                <div class="container" v-if="type == 'vehicle'">
                    <div class="row justify-content-center mdt-form mt-4">
                        <div class="col-5">
                            <label for="mdt-boloform-vehicle-model" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_model') }}
                            </label>
                            <input id="mdt-boloform-vehicle-model" class="form-control" type="text"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_model')"
                                aria-label="Vehicle model" v-model="formInput.vehicle.model" />
                        </div>

                        <div class="col-5">
                            <label for="mdt-boloform-vehicle-plate" class="col-form-label"
                                :class="{ 'is-invalid': validationFeedback.length > 0 }">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_plate') }}
                                <span class="mdt_required" title="Required">*</span>
                            </label>
                            <input id="mdt-boloform-vehicle-plate" class="form-control" type="text"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_plate')"
                                aria-label="License plate" v-model="formInput.vehicle.plate" />

                            <div class="invalid-feedback">
                                {{ validationFeedback }}
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label for="mdt-boloform-vehicle-color" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_color') }}
                            </label>
                            <input id="mdt-boloform-vehicle-color" class="form-control" type="text"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_color')"
                                aria-label="Vehicle color" v-model="formInput.vehicle.color" />
                        </div>

                        <div class="col-5">
                            <label for="mdt-boloform-vehicle-lastseen" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_lseen') }}
                            </label>
                            <input id="mdt-boloform-vehicle-lastseen" class="form-control" type="text"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_lseen')"
                                aria-label="Last seen" v-model="formInput.vehicle.lastSeen" />
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label for="mdt-boloform-vehicle-details" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_vdetails') }}
                            </label>
                            <textarea class="form-control" id="mdt-boloform-vehicle-details"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_vdetails')" rows="3"
                                v-model="formInput.vehicle.description"></textarea>
                        </div>
                        <div class="col-5">
                            <label for="mdt-boloform-vehicle-reason" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_reason') }}
                            </label>
                            <textarea class="form-control" id="mdt-boloform-vehicle-reason"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_reason')" rows="3"
                                v-model="formInput.vehicle.reason"></textarea>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-7">
                            <label for="mdt-boloform-vehicle-notes" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_notes') }}
                            </label>
                            <textarea class="form-control" id="mdt-boloform-vehicle-notes"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_notes_veh')" rows="4"
                                v-model="formInput.vehicle.notes"></textarea>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-3">
                        <div class="col-4 text-center">
                            <button type="button" class="btn red-btn me-3" @click="Discard()">
                                {{ this.$store.getters.GetTranslation('createbolo', 'discard') }}
                            </button>

                            <button type="button" class="btn green-btn" @click="SaveBolo()">
                                {{ this.$store.getters.GetTranslation('createbolo', 'submit') }}
                            </button>
                        </div>
                    </div>
                </div>

                <div class="container" v-if="type == 'person'">
                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label for="mdt-boloform-person-name" class="col-form-label"
                                :class="{ 'is-invalid': validationFeedback.length > 0 }">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_name') }}
                                <span class="mdt_required" title="Required">*</span>
                            </label>

                            <div id="mdt-boloform-person-name" class="input-group">
                                <button class="btn btn-sm blue-btn" type="button" @click="SearchForCharacter()">
                                    {{ this.$store.getters.GetTranslation('createbolo', 'select') }}
                                </button>
                                <input type="text" class="form-control"
                                    :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_name')"
                                    v-model="formInput.person.name" readonly />
                            </div>

                            <div class="invalid-feedback">
                                {{ validationFeedback }}
                            </div>
                        </div>

                        <div class="col-5">
                            <label for="mdt-boloform-person-lastseen" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_lseen') }}
                            </label>
                            <input id="mdt-boloform-person-lastseen" class="form-control" type="text"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_lseen')"
                                aria-label="Last seen" v-model="formInput.person.lastSeen" />
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label for="mdt-boloform-person-details" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_des') }}
                            </label>
                            <textarea class="form-control" id="mdt-boloform-person-details"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_des')" rows="3"
                                v-model="formInput.person.description"></textarea>
                        </div>

                        <div class="col-5">
                            <label for="mdt-boloform-person-reason" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_reason') }}
                            </label>
                            <textarea class="form-control" id="mdt-boloform-person-reason"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_reason')" rows="3"
                                v-model="formInput.person.reason"></textarea>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-7">
                            <label for="mdt-boloform-person-notes" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_notes') }}
                            </label>
                            <textarea class="form-control" id="mdt-boloform-person-notes"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_notes_bolo')"
                                rows="4" v-model="formInput.person.notes"></textarea>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-3">
                        <div class="col-4 text-center">
                            <button type="button" class="btn red-btn me-3" @click="Discard()">
                                {{ this.$store.getters.GetTranslation('createbolo', 'discard') }}
                            </button>

                            <button type="button" class="btn green-btn" @click="SaveBolo()">
                                {{ this.$store.getters.GetTranslation('createbolo', 'submit') }}
                            </button>
                        </div>
                    </div>
                </div>

                <div class="container" v-if="type == 'warrant'">
                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label for="mdt-boloform-warrant-name" class="col-form-label"
                                :class="{ 'is-invalid': validationFeedback.length > 0 }">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_name') }}
                                <span class="mdt_required" title="Required">*</span>
                            </label>

                            <div id="mdt-boloform-warrant-name" class="input-group">
                                <button class="btn btn-sm blue-btn" type="button" @click="SearchForCharacter()">
                                    {{ this.$store.getters.GetTranslation('createbolo', 'select') }}
                                </button>
                                <input type="text" class="form-control"
                                    :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_name')"
                                    v-model="formInput.warrant.name" readonly />
                            </div>

                            <div class="invalid-feedback">
                                {{ validationFeedback }}
                            </div>
                        </div>

                        <div class="col-5">
                            <label for="mdt-boloform-warrant-lastseen" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_lseen') }}
                            </label>
                            <input id="mdt-boloform-warrant-lastseen" class="form-control" type="text"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_lseen')"
                                aria-label="Last seen" v-model="formInput.warrant.lastSeen" />
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-5">
                            <label for="mdt-boloform-warrant-details" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_des') }}
                            </label>
                            <textarea class="form-control" id="mdt-boloform-warrant-details"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_des')" rows="3"
                                v-model="formInput.warrant.description"></textarea>
                        </div>

                        <div class="col-5">
                            <label for="mdt-boloform-warrant-reason" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_reason') }}
                            </label>
                            <textarea class="form-control" id="mdt-boloform-warrant-reason"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_reason')" rows="3"
                                v-model="formInput.warrant.reason"></textarea>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-2">
                        <div class="col-7">
                            <label for="mdt-boloform-warrant-notes" class="col-form-label">
                                {{ this.$store.getters.GetTranslation('createbolo', 'col_notes') }}
                            </label>
                            <textarea class="form-control" id="mdt-boloform-warrant-notes"
                                :placeholder="this.$store.getters.GetTranslation('createbolo', 'ph_notes_bolo')"
                                rows="4" v-model="formInput.warrant.notes"></textarea>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-3">
                        <div class="col-4 text-center">
                            <button type="button" class="btn red-btn me-3" @click="Discard()">
                                {{ this.$store.getters.GetTranslation('createbolo', 'discard') }}
                            </button>

                            <button type="button" class="btn green-btn" @click="SaveBolo()">
                                {{ this.$store.getters.GetTranslation('createbolo', 'submit') }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
// Modals
import SearchCharacterModal from "../Modals/General/SearchChar";

export default {
    name: "CreateBoloModule",
    emits: ["close"],
    components: {
        SearchCharacterModal,
    },
    data() {
        return {
            formInput: {
                vehicle: {
                    model: "",
                    plate: "",
                    color: "",
                    description: "",
                    lastSeen: "",
                    reason: "",
                    notes: "",
                    creator: "",
                },
                person: {
                    name: "",
                    description: "",
                    lastSeen: "",
                    reason: "",
                    notes: "",
                    creator: "",
                },
                warrant: {
                    name: "",
                    description: "",
                    lastSeen: "",
                    reason: "",
                    notes: "",
                    creator: "",
                },
            },
            requiredFormInput: {
                vehicle: ["plate"],
                person: ["name"],
                warrant: ["name"],
            },
            modalData: {
                SearchChar: {
                    show: false,
                },
            },

            validationFeedback: '',
        };
    },
    props: ["type"],
    methods: {
        SearchForCharacter() {
            this.modalData.SearchChar.show = true;

            setTimeout(() => {
                this.modalData.SearchChar.show = false;
            }, 200);
        },
        SetCharData(data, fullName) {
            if (this.type == "person") {
                this.formInput.person.name = fullName;
                this.formInput.person.charData = data;
            } else if (this.type == "warrant") {
                this.formInput.warrant.name = fullName;
                this.formInput.warrant.charData = data;
            }
        },

        Discard() {
            this.$emit("close");
        },

        VerifyInputs() {
            var formEntry = this.formInput[this.type];
            let allowSubmittion = false;

            this.requiredFormInput[this.type].forEach((val) => {
                if (formEntry[val].length > 0) {
                    allowSubmittion = true;
                }
            });

            return allowSubmittion;
        },

        SaveBolo() {
            if (this.VerifyInputs()) {
                const self = this.$store.getters.GetSelf()
                this.formInput[this.type].creator = self.callsign.length > 0 ? `${self.callsign} - ${self.name}` : self.name

                var newEntry = this.formInput[this.type];
                if ( this.type == 'warrant' ) {
                    this.$emit("close", newEntry);
                } else {
                    this.$emit("close", this.type, newEntry);
                }

                this.Discard();
            } else {
                this.validationFeedback = this.$store.getters.GetTranslation('createbolo', 'feedback')
            }
        },
    },
};
</script>

<style lang="scss" scoped>
#mdt-create-bolo {
    display: none;
}
</style>