<template>
    <div :id="modalId" class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" tabindex="-1"
        aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        {{ $store.getters.GetTranslation('viewnotif', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <template v-for="(val) in $store.state.notifications.storedFeed"
                            :key="`${val.timeStamp}_show_notify_feed`">
                            <div class="col-6">
                                <div class="card mt-2 mb-2 m-auto" style="width: 22rem;">
                                    <div class="card-header">
                                        <h5 class="card-title">
                                            <!-- Success -->
                                            <i class="fas fa-check-circle me-1 mdt-color-lightgreen fs-6"
                                                v-if="val.type == 'success'"></i>
                                            <!-- Error -->
                                            <i class="fas fa-times-circle me-1 mdt-color-red fs-6"
                                                v-if="val.type == 'error'"></i>
                                            <!-- Alert -->
                                            <i class="fas fa-exclamation-circle me-1 mdt-color-yellow fs-6"
                                                v-if="val.type == 'alert'"></i>

                                            {{ val.title }}
                                        </h5>
                                        <h6 class="card-subtitle">{{ `${this.TimeSince(val.timeStamp)}
                                            ${$store.getters.GetTranslation('viewnotif', 'timeago')}` }}</h6>
                                    </div>
                                    <div class="card-body">
                                        <p class="card-text">{{ val.msg }}</p>
                                    </div>

                                    <div class="card-footer">
                                        <button type="button" class="float-end btn btn-sm red-btn"
                                            @click="DeleteNotification(val.timeStamp)">
                                            {{ $store.getters.GetTranslation('viewnotif', 'delete') }}
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn red-btn" @click="ClearNotifications()">
                        {{ $store.getters.GetTranslation('viewnotif', 'clear') }}
                    </button>
                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('viewnotif', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "ViewAllNotifications",
    props: ["parentElId", "show"],
    data() {
        return {
            modalId: 'view-notifications-modal'
        }
    },
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);
    },
    methods: {
        DeleteNotification(timeStamp) {
            if ( this.$store.state.notifications.storedFeed.length === 1 ) {
                this.CloseModal()
            }
            this.$store.commit('RemoveStoredNotifyEntry', { timeStamp: timeStamp })
        },
        ClearNotifications() {
            this.CloseModal()
            this.$store.commit('ClearStoredNotifications')

            this.SendNotification(
                this.$store.getters.GetTranslation('viewnotif', 'alert'),
                this.$store.getters.GetTranslation('viewnotif', 'alert_msg'),
                4000,
                'success',
                false
            );
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
            }, 175);

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

// Form specific
$formBackground: #2d3138;
$formPlaceholderText: #bfbfbf7c;

// Colors
$redColor: #9f1600;
$redFadedColor: #9f1500ab;
$redColorHover: #7e1100;

$greenColor: #007b1d;
$greenFadedColor: #007b1db6;
$greenColorHover: #006317;

$purpleColor: #884ea0;
$purpleFadedColor: #874ea0a9;
$purpleColorHover: #71368a;

$tealColor: #16a085;
$tealFadedColor: #16a084a8;
$tealColorHover: #107a65;

$yellowColor: #d39736;
$yellowFadedColor: #f5b041b7;
$yellowColorHover: #d39634;

$blueColor: #2e86c1;
$blueFadedColor: #2e86c1a6;
$blueColorHover: #2170a5;

$greyColor: #839192;
$greyFadedColor: #8391929d;
$greyColorHover: #707b7c;

$light-greenColor: #41a068;
$light-greenFadedColor: #41a068b4;
$light-greenColorHover: #31794f;

.card {
    color: $textColor;
    background-color: $primaryColorLightHover;
    border: 3px $primaryColorLight solid;

    .card-subtitle {
        color: $textColorHover;
    }

    .card-body {
        width: 100%;
    }

    .card-text {
        font-size: 0.9rem !important;
    }
}
</style>
