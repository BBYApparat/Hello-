<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        :aria-labelledby="`${modalId}Label`" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" :id="`${modalId}Label`">
                        {{ $store.getters.GetTranslation('affirmation', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="container">
                        {{ bodyText }}
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn red-btn" @click="OnClick(false)">
                        {{ $store.getters.GetTranslation('affirmation', 'no') }}
                    </button>
                    <button type="button" class="btn green-btn" @click="OnClick(true)">
                        {{ $store.getters.GetTranslation('affirmation', 'yes') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "AffirmationModal",
    data() {
        return {
            modalId: "affirmation" + "Modal",
            beingShown: false,
        };
    },
    props: ["bodyText", "parentElId", "show", "id"],
    mounted() {
        if (this.id !== undefined && this.id.length > 0) {
            this.modalId = this.id;
        }

        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
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
            }, 175);

            this.$store.commit('SetModalClosed')
            this.beingShown = false;
        },
        OnClick(status) {
            this.CloseModal();
            this.$emit("affirmation-cb", status);
        },
    },
};
</script>
