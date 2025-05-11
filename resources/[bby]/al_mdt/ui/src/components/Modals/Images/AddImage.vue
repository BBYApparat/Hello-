<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="addImageLabel" aria-hidden="true">
        <div class=" modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable ">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addImageLabel">
                        {{ $store.getters.GetTranslation('addimage', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="container-fluid fade show" id="mdt-image-search" v-if="showImageSubmissionEl">
                        <div class="row justify-content-center mdt-form" v-if="IsOptionAllowed('label')">
                            <div class="col-5 text-center mb-3">
                                <label for="mdt-add-image-modal-name" class="col-form-label">
                                    {{ $store.getters.GetTranslation('addimage', 'label') }}
                                    <span class="mdt_required" title="Required">*</span>
                                </label>
                                <input id="mdt-add-image-name" class="form-control" type="text"
                                    :placeholder="$store.getters.GetTranslation('addimage', 'placeholder')"
                                    v-model="inputFields.name" required />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-4">
                            <div class="col-10 text-center">
                                <button class="btn blue-btn btn-sm" type="button" @click="TakePhotoPhone()">
                                    {{ $store.getters.GetTranslation('addimage', 'takepicture') }}
                                </button>
                            </div>
                        </div>

                        <div class="row justify-content-md-center mt-3">
                            <div class="col h5 text-center fw-bold">
                                {{ $store.getters.GetTranslation('addimage', 'or') }}
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form">
                            <div class="col-10 text-center">
                                <label for="mdt-add-image-modal-link" class="col-form-label">
                                    {{ $store.getters.GetTranslation('addimage', 'link') }}
                                </label>
                                <input id="mdt-add-image-link" class="form-control"
                                    :class="{ 'is-invalid': validationFeedback.length > 0 }" type="text"
                                    placeholder="https://i.imgur.com/*.jpeg" v-model="inputFields.link" required />
                                <div class="invalid-feedback">
                                    {{ validationFeedback }}
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 text-center">
                            <button type="submit" class="btn green-btn" @click="AddLink(inputFields.link)">
                                {{ $store.getters.GetTranslation('addimage', 'add') }}
                                <span v-if="loading">
                                    <div class="spinner-border ms-1" style="width: 1rem; height: 1rem" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </span>
                            </button>
                        </div>
                    </div>

                    <div class="container-fluid fade" id="mdt-confirming-image" style="display: none"
                        v-if="showConfirmingImageEl">
                        <div class="row justify-content-md-center mb-2">
                            <div class="col-10 h4 text-center">
                                {{ $store.getters.GetTranslation('addimage', 'confirm_msg') }}
                            </div>
                        </div>

                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-10 text-center">
                                <img id="mdt-image-submission" :src="imgLink" class="img-fluid" style="max-height: 40vh"
                                    @load="hasImageLoaded = true" v-if="showImgCon" />
                            </div>
                        </div>

                        <div class="mt-4 text-center">
                            <button type="button" class="btn red-btn" @click="ConfirmImage(false)">
                                {{ $store.getters.GetTranslation('addimage', 'discard') }}
                            </button>
                            <button type="button" class="btn green-btn ms-4" @click="SubmitImage()">
                                {{ $store.getters.GetTranslation('addimage', 'confirm') }}
                            </button>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('addimage', 'close') }}
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
    name: "AddImage",
    data() {
        return {
            modalId: "addImage" + "Modal",
            beingShown: false,
            confirmingImage: false,
            showImageSubmissionEl: true,
            showConfirmingImageEl: false,
            hasImageLoaded: false,
            cancelLoading: false,
            loading: false,
            canStopLoading: true,
            showImgCon: true,
            validationFeedback: "",
            imgLink: "",

            inputFields: {
                link: "",
                name: "",
            },
        };
    },
    props: ["parentElId", "show", "options"],
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
        AddLink(link) {
            if (this.IsOptionAllowed('label')) {
                if (this.inputFields.name.length === 0) {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('addimage', 'feedback_1'),
                        this.$store.getters.GetTranslation('addimage', 'feedback_1_msg'),
                        5000,
                        'error',
                        false,
                        true
                    );
                    return
                }
            }

            this.checkImage(link)
        },
        async TakePhotoPhone() {
            if (this.IsOptionAllowed('label')) {
                if (this.inputFields.name.length === 0) {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('addimage', 'feedback_1'),
                        this.$store.getters.GetTranslation('addimage', 'feedback_1_msg'),
                        5000,
                        'error',
                        false,
                        true
                    );
                    return
                }
            }
            this.TempCloseModal()
            const imgURL = await api.general.TakePhoto()

            setTimeout(() => {
                this.ReopenModal()
                if (imgURL) {
                    this.checkImage(imgURL)
                } else {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('addimage', 'error_1'),
                        this.$store.getters.GetTranslation('addimage', 'error_1_msg'),
                        5000,
                        'error',
                        false,
                        true
                    );
                }
            }, 1000)
        },
        IsOptionAllowed(type) {
            if (type == "label") {
                if (this.options != undefined && this.options.label) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        },
        ResetImgContainer() {
            this.showImgCon = false;
            this.imgLink = "";

            setTimeout(() => {
                this.showImgCon = true;
            }, 500);
        },
        checkImage(url, disableValidation) {
            if (/^https?:\/\/.*\.(png|jpg|jpeg)/.test(url)) {
                if (disableValidation) {
                    this.validationFeedback = "";
                }
                this.hasImageLoaded = false;
                this.loading = true;
                this.canStopLoading = false;
                setTimeout(() => {
                    this.canStopLoading = true;
                }, 1000);

                setTimeout(() => {
                    if (!this.hasImageLoaded) {
                        this.cancelLoading = true;
                        this.ResetImgContainer();
                    }
                }, 5000);

                this.imgLink = url;
                this.ConfirmImage(true, disableValidation);
            } else {
                if (disableValidation) {
                    this.validationFeedback = this.$store.getters.GetTranslation('addimage', 'feedback_2');
                } else {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('addimage', 'error_2'),
                        this.$store.getters.GetTranslation('addimage', 'error_2_msg'),
                        5000,
                        'error',
                        false,
                        true
                    );
                }
            }
        },
        ConfirmImage(state, disableValidation) {
            if (state != undefined) {
                this.confirmingImage = state;
            }
            if (!this.confirmingImage) {
                // Clear inputfields
                this.TransitionEl();
            } else {
                this.hasImageLoaded = false;
                this.showConfirmingImageEl = true;

                setTimeout(() => {
                    document.getElementById("mdt-confirming-image").style.display = "none"; // Lets the image load

                    const waitInterval = setInterval(() => {
                        if (this.canStopLoading && this.loading && this.hasImageLoaded) {
                            this.TransitionEl();

                            this.loading = false;
                            this.canStopLoading = true;
                            clearInterval(waitInterval);
                        } else if (this.cancelLoading) {
                            this.loading = false;
                            this.canStopLoading = true;
                            this.cancelLoading = false;
                            if (disableValidation) {
                                this.validationFeedback = this.$store.getters.GetTranslation('addimage', 'feedback_3');
                            } else {
                                this.SendNotification(
                                    this.$store.getters.GetTranslation('addimage', 'error_3'),
                                    this.$store.getters.GetTranslation('addimage', 'error_3_msg'),
                                    5000,
                                    'error',
                                    false,
                                    true
                                );
                            }
                            clearInterval(waitInterval);
                        }
                    }, 500);
                }, 100);
            }
        },
        TransitionEl() {
            var tabEl = this.confirmingImage ? document.getElementById("mdt-image-search") : document.getElementById("mdt-confirming-image");
            tabEl.classList.remove("show");

            setTimeout(() => {
                if (!this.confirmingImage) {
                    this.showImageSubmissionEl = true;
                    this.showConfirmingImageEl = false;
                    this.inputFields.link = "";
                } else {
                    if (this.showConfirmingImageEl) {
                        document.getElementById("mdt-confirming-image").style.display = "block";
                    }
                    this.showImageSubmissionEl = false;
                }

                setTimeout(() => {
                    tabEl = this.confirmingImage ? document.getElementById("mdt-confirming-image") : document.getElementById("mdt-image-search");

                    tabEl.classList.add("show");

                    setTimeout(() => {
                        this.RefreshBS();
                    }, 500);
                }, 10);
            }, 150);
        },
        SubmitImage() {
            this.$emit("submit-image", {
                name: this.inputFields.name,
                img: this.imgLink,
            });
            this.CloseModal();

            this.showImageSubmissionEl = true;
            this.showConfirmingImageEl = false;
            this.inputFields.link = "";
            this.inputFields.name = "";
            this.imgLink = "";
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
        ReopenModal() {
            var modalEl = document.getElementById(this.modalId);
            document.body.appendChild(modalEl);

            var modalInstance = Modal.getOrCreateInstance(modalEl);
            modalInstance.show();
        },
        TempCloseModal() {
            // Append modal to original parent
            var modalEl = document.getElementById(this.modalId);
            var modalInstance = Modal.getInstance(modalEl);
            modalInstance.hide();

            setTimeout(() => {
                var parentEl = document.getElementById(this.parentElId);
                parentEl.appendChild(modalEl);
            }, 175);
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
    },
};
</script>
