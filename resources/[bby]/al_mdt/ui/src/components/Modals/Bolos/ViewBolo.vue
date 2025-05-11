<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="viewBoloInfoLabel" aria-hidden="true">
        <div class=" modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable ">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewBoloInfoLabel">{{ title }}</h5>

                    <h6 v-if="data.info != undefined && data.info.id">
                        {{ `${$store.getters.GetTranslation('viewbolo', 'ref_num')} ${FormatNumber(data.info.id)}` }}
                    </h6>
                </div>

                <div class="modal-body">
                    <div class="container-fluid" v-if="data.type == 'vehicle'">
                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_sub') }}
                                </label>
                                <input class="form-control" type="text" :value="data.info.creator" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_veh') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'not_avail')"
                                    :value="data.info.model" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_plate') }}
                                </label>
                                <input class="form-control" type="text" :value="data.info.plate" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_color') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'not_avail')"
                                    :value="data.info.color" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_lastseen') }}
                                </label>
                                <input class="form-control" type="text" :value="data.info.lastSeen" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_vehdes') }}
                                </label>
                                <textarea class="form-control" rows="3"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'none')"
                                    :value="data.info.description" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_reason') }}
                                </label>
                                <textarea class="form-control" rows="3"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'none')"
                                    :value="data.info.reason" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-10">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_notes') }}
                                </label>
                                <textarea class="form-control" rows="4"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'none')"
                                    :value="data.info.notes" readonly />
                            </div>
                        </div>
                    </div>

                    <div class="container" v-if="data.type == 'person'">
                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_sub') }}
                                </label>
                                <input class="form-control" type="text" :value="data.info.creator" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_name') }}
                                </label>
                                <input class="form-control fw-bold" type="text" :value="data.info.name" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_lastseen') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'not_avail')"
                                    :value="data.info.lastSeen" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_des') }}
                                </label>
                                <textarea class="form-control" rows="3"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'none')"
                                    :value="data.info.description" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_reason') }}
                                </label>
                                <textarea class="form-control" rows="3"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'none')"
                                    :value="data.info.reason" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-10">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_notes') }}
                                </label>
                                <textarea class="form-control" rows="4"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'none')"
                                    :value="data.info.notes" readonly />
                            </div>
                        </div>
                    </div>

                    <div class="container" v-if="data.type == 'warrant'">
                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_sub') }}
                                </label>
                                <input class="form-control" type="text" :value="data.info.creator" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_name') }}
                                </label>
                                <input class="form-control fw-bold" type="text" :value="data.info.name" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_lastseen') }}
                                </label>
                                <input class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'not_avail')"
                                    :value="data.info.lastSeen" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_des') }}
                                </label>
                                <textarea class="form-control" rows="3"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'none')"
                                    :value="data.info.description" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_reason') }}
                                </label>
                                <textarea class="form-control" rows="3"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'none')"
                                    :value="data.info.reason" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-10">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewbolo', 'col_notes') }}
                                </label>
                                <textarea class="form-control" rows="4"
                                    :placeholder="$store.getters.GetTranslation('viewbolo', 'none')"
                                    :value="data.info.notes" readonly />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <div class="h6 me-auto" v-if="data.type">
                        {{ `${$store.getters.GetTranslation('viewbolo', 'date_reg')} ${FormatDate(data.info.date)}` }}
                    </div>

                    <template v-if="perms.delete && ShouldAllowEdits()">
                        <button type="button" class="btn red-btn" @click="OnClick('delete', data)">
                            {{ $store.getters.GetTranslation('viewbolo', 'delete') }}
                        </button>
                    </template>

                    <template v-if="perms.edit && ShouldAllowEdits()">
                        <button type="button" class="btn blue-btn" @click="OnClick('edit', data)">
                            {{ $store.getters.GetTranslation('viewbolo', 'edit') }}
                        </button>
                    </template>

                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('viewbolo', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "ViewBoloModal",
    data() {
        return {
            modalId: "viewBoloInfo" + "Modal",
            beingShown: false,
            title: "View Bolo/Warrant",
            perms: {
                edit: false,
                delete: false,
            }
        };
    },
    props: ["parentElId", "show", "data"],
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
                this.CheckPerms();
            }
        }, 100);
    },
    methods: {
        CheckPerms() {
            let player = this.$store.getters.GetSelf()

            if (player) {
                const playerJob = player.job

                if (this.data.type == "vehicle" || this.data.type == "person") {
                    this.perms.edit = this.$store.getters.HasPerm(playerJob, 'bolos', 'edit')
                    this.perms.delete = this.$store.getters.HasPerm(playerJob, 'bolos', 'delete')
                } else if (this.data.type == "warrant") {
                    this.perms.edit = this.$store.getters.HasPerm(playerJob, 'warrants', 'edit')
                    this.perms.delete = this.$store.getters.HasPerm(playerJob, 'warrants', 'delete')
                }
            }
        },
        ShowModal() {
            if (!this.beingShown) {
                // Append modal to body
                var modalEl = document.getElementById(this.modalId);
                document.body.appendChild(modalEl);
                this.UpdateTitle();

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
            }, 175);

            this.$store.commit('SetModalClosed')
            this.beingShown = false;
        },
        UpdateTitle() {
            if (this.data.type == "vehicle") {
                this.title = this.$store.getters.GetTranslation('viewbolo', 'title_1');
            } else if (this.data.type == "person") {
                this.title = this.$store.getters.GetTranslation('viewbolo', 'title_2');
            } else if (this.data.type == "warrant") {
                this.title = this.$store.getters.GetTranslation('viewbolo', 'title_3');
            } else {
                this.title = this.$store.getters.GetTranslation('viewbolo', 'title_4');
            }
        },
        ShouldAllowEdits() {
            if (this.data.options != undefined) {
                if (this.data.options.allowEdits) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        },
        OnClick(status, data) {
            if (status == "edit") {
                this.CloseModal();
                this.$emit("edit-bolo", {
                    type: data.type,
                    id: data.info.id,
                });
            } else if (status == "delete") {
                this.CloseModal();
                this.$emit("delete-bolo", data.type, data.info.id);
            }
        },
    },
};
</script>
