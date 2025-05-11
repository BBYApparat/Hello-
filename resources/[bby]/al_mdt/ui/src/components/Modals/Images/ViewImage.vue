<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        {{ $store.getters.GetTranslation('viewimage', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="container-fluid" v-if="loading">
                        <div class="row justify-content-md-center">
                            <div class="col-3 text-center">
                                <span v-if="loading">
                                    <div class="spinner-border ms-1" style="width: 1rem; height: 1rem" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="container-fluid fade" :id="`${modalId}-show-image-con`" style="display: none"
                        v-if="beingShown">
                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-10 text-center">
                                <img id="mdt-view-image-img" :src="img" class="img-fluid" style="max-height: 50vh"
                                    @load="hasImageLoaded = true" />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('viewimage', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "ShowImage",
    data() {
        return {
            modalId: "showImage" + "Modal",
            beingShown: false,

            loading: false,
            hasImageLoaded: false,
            cancelLoading: false,
            canStopLoading: true,
        };
    },
    props: ["parentElId", "show", "img", "id"],
    mounted() {
        if ( this.id ) {
            this.modalId = this.id;
        }

        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
        ShowImage() {
            this.hasImageLoaded = false;
            this.loading = true;
            this.canStopLoading = false;

            setTimeout(() => {
                this.canStopLoading = true;
            }, 1000);

            setTimeout(() => {
                if (!this.hasImageLoaded) {
                    this.cancelLoading = true;
                }
            }, 5000);

            setTimeout(() => {
                var tabEl = document.getElementById(`${this.modalId}-show-image-con`);
                tabEl.style.display = "none";

                const waitInterval = setInterval(() => {
                    if (this.canStopLoading && this.loading && this.hasImageLoaded) {
                        tabEl.style.display = "block";
                        this.loading = false;
                        this.canStopLoading = true;
                        setTimeout(() => {
                            tabEl.classList.add("show");
                        }, 10);

                        clearInterval(waitInterval);
                    } else if (this.cancelLoading) {
                        this.loading = false;
                        this.canStopLoading = true;
                        this.cancelLoading = false;

                        this.CloseModal();
                        clearInterval(waitInterval);
                    }
                }, 500);
            }, 500);
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

                this.ShowImage();
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

                this.$store.commit('SetModalClosed')
                this.beingShown = false;
            }, 175);
        },
    },
};
</script>
