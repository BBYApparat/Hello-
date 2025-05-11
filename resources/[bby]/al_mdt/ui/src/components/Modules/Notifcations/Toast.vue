<template>
    <div :id="toastId" class="toast hide" role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false">
        <div class="toast-header">
            <!-- Success -->
            <i class="fas fa-check-circle me-1 mdt-color-lightgreen" v-if="type == 'success'" ></i>
            <!-- Error -->
            <i class="fas fa-times-circle me-1 mdt-color-red" v-if="type == 'error'" ></i>
            <!-- Alert -->
            <i class="fas fa-exclamation-circle me-1 mdt-color-yellow" v-if="type == 'alert'" ></i>
            <!-- Info -->
            <i class="fas fa-info-circle me-1 mdt-color-grey" v-if="type == 'info'" ></i>

            <strong class="me-auto">{{ title }}</strong>
            <button type="button" class="btn-close btn-close-white" aria-label="Close" @click="EndToast(true)"></button>
        </div>
        <div class="toast-body">
            {{ msg }}
        </div>
    </div>
</template>

<script>
import { Toast } from "bootstrap/dist/js/bootstrap.esm.min.js";

export default {
    name: "Toast",
    props: ["id", "timeStamp", "title", "msg", "duration", "type", "useSound"],
    data() {
        return {
            toast: false,
            closed: false,
            toastId: `${this.timeStamp}_notify`,
        };
    },
    mounted() {
        this.InitToast();

        setTimeout( () => {
            if (!this.closed) {
                this.EndToast();
            }
        }, this.duration);
    },
    methods: {
        InitToast() {
            var myToastEl = document.getElementById(this.toastId);
            this.toast = Toast.getOrCreateInstance(myToastEl);

            this.toast.show();

            if ( this.useSound === 'panic' ) {
                this.PlayAudio('panic', this.$store.state.settings.notify.panicVolume);
            } else if ( this.useSound === true ) {
                this.PlayAudio(this.$store.getters.GetNotifySound(), this.$store.state.settings.notify.volume);
            }
        },
        EndToast(forced) {
            this.closed = true;

            this.toast.hide();

            if ( forced ) {
                setTimeout(() => {
                    this.$store.dispatch('RemoveStoredNotification', this.timeStamp)
                }, 150);
            }
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
$formBackground: #4d515e;
$formPlaceholderText: #bfbfbf7c;

// Colors
$redColor: #9f1600;
$redColorFaded: #9f1500c2;
$redColorHover: #7e1100;

$greenColor: #007b1d;
$greenColorFaded: #007b1db6;
$greenColorHover: #006317;

$purpleColor: #884ea0;
$purpleFadedColor: #874ea0a9;
$purpleColorHover: #71368a;

$tealColor: #16a085;
$tealFadedColor: #16a084a8;
$tealColorHover: #107a65;

$yellowColor: #f5b041;
$yellowFadedColor: #f5b041b7;
$yellowColorHover: #d39634;

$blueColor: #2e86c1;
$blueFadedColor: #2e86c1a6;
$blueColorHover: #2170a5;

$dark-blueColor: #1249af;
$dark-blueFadedColor: #1249afad;
$dark-blueColorHover: #0e3e96;

$greyColor: #839192;
$greyFadedColor: #8391929d;
$greyColorHover: #707b7c;

$light-greenColor: #58d68d;
$light-greenFadedColor: #58d68cab;
$light-greenColorHover: #4cb979;

$toastHeaderColor: #363942;
$toastBodyColor: #484b57;
$toastBorderColor: #5d5f6b;

.toast {
    z-index: 9999;
    background: transparent;
    border: none;
}

.toast-header {
    background-color: $toastHeaderColor;
    border-color: $toastBorderColor;
    color: $textColor;
    border-radius: 3px 3px 0 0;
}

.toast-body {
    background-color: $toastBodyColor;
    border-color: $toastBorderColor;
    color: $textColor;
    border-radius: 0 0 3px 3px;
}
</style>
