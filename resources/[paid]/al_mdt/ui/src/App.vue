<template>
    <div id="mdt-mothership" v-if="ready">
        <div id="mdt-main" :style="{ display: $store.getters.IsVisible('mdt') ? 'block' : 'none' }">
            <div class="container-fluid">
                <!-- Nav bar -->
                <template v-if="$router.currentRoute.value.name !== 'Login' && hasMounted">
                    <Nav />
                </template>

                <Loading />

                <template v-if="!$store.getters.IsVisible('fines')">
                    <Notifications />
                </template>

                <router-view v-slot="{Component}">
                    <transition name="fade" mode="out-in">
                        <component :is="Component" :key="$route.path">

                        </component>
                    </transition>
                </router-view>
            </div>
        </div>

        <div id="mdt-fines" v-if="$store.getters.IsVisible('fines')">
            <div class="container-fluid">
                <Notifications />

                <Fines />
            </div>
        </div>
    </div>
</template>

<script>
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap/dist/js/bootstrap.min.js";

// Vue Components
import Nav from "@/components/Nav";
import Loading from "@/components/Loading";
import Notifications from "@/components/Notifications";
import Fines from "@/components/Fines";
import api from '@/api/main'

export default {
    name: "App",
    components: {
        Nav,
        Loading,
        Notifications,
        Fines,
    },
    data() {
        return {
            hasMounted: false,
            openedModal: false,
            ready: false
        }
    },
    mounted() {
        // Modals //

        // Create backdrop when modal appears
        addEventListener("show.bs.modal", () => {
            var modalArray = Array.from(document.querySelectorAll(".modal-backdrop"));
            this.openedModal = true

            if (modalArray.length == 0) {
                var backdropEl = document.createElement("div");
                document.body.appendChild(backdropEl);
                backdropEl.classList.add("modal-backdrop", "fade-in-visible", "show");

                setTimeout(() => {
                    backdropEl.classList.remove("fade-in-visible");
                }, 150);
            }
        });

        // Hide backdrop when modal disappears
        addEventListener("hide.bs.modal", () => {
            var modalArray = Array.from(document.querySelectorAll(".modal-backdrop"));

            // Checks if there are any modals open
            if (modalArray.length > 0) {
                modalArray[0].classList.add("fade-out-hide");

                // Remove the backdrop after fading out
                setTimeout(() => {
                    modalArray[0].remove();
                }, 150);

                // Ensure that there aren't any modals appended to body
                setTimeout(() => {
                    if ( this.openedModal === true ) {
                        this.openedModal = false

                        var modalArray = Array.from(document.querySelectorAll(":scope body > .modal"));

                        modalArray.forEach(el => {
                            el.remove()
                            console.log('Removed modal from body (Closing procedure failed)')
                        })
                    }
                }, 200)
            }
        });

        document.addEventListener('keydown', (e) => {
            if ( e.key === 'Escape' && (this.$store.getters.IsVisible('mdt') || this.$store.getters.IsVisible('fines')) ) {
                // if ( !this.$store.getters.IsModalOpen() ) {
                //     api.general.ToggleVisibility()
                // }
                if ( !this.IsModalOpen() ) {
                    api.general.ToggleVisibility()
                }
            }
        });

        const langInit = setInterval(() => {
            if (this.$store.state.config.LanguageInitiated) {
                this.ready = true
                clearInterval(langInit)

                setTimeout(() => {
                    this.hasMounted = true
                }, 500)
            }
        }, 100);
    },
    methods: {
        IsModalOpen() {
            var modalArray = Array.from(document.querySelectorAll(".modal-mask"));

            return modalArray.length > 0 ? true : false
        },
    },
};
</script>

<style lang="scss">
@import url("https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700&display=swap");

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

body {
    z-index: 100;
    background: transparent;
    color: $textColor;
    font-family: Roboto, Helvetica, Arial, sans-serif !important;
    overflow: hidden;
    /*
  padding: 0;
    border: 0;
    list-style: none;
    margin: 0;
  */
}

#app {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 100vh;
}

#mdt-mothership {
    display: none;
    opacity: 0;
    overflow: auto;
    background: $primaryColor;
    border: 0.6rem solid #131418;
    border-radius: 5px;
    width: 80vw;
    max-width: 1920px;
    height: 80vh;
    max-height: 1080px;
    padding: 10px;
}

.btn {
    color: $textColor;
}

.mdt-color-red {
    color: $redColor;

    &:hover {
        color: $redColorHover;
    }
}

.mdt-color-blue {
    color: $blueColor;

    &:hover {
        color: $blueColorHover;
    }
}

.mdt-color-darkblue {
    color: $dark-blueColor;

    &:hover {
        color: $dark-blueColorHover;
    }
}

.mdt-color-green {
    color: $greenColor;

    &:hover {
        color: $greenColorHover;
    }
}

.mdt-color-lightgreen {
    color: $light-greenColor;

    &:hover {
        color: $light-greenColorHover;
    }
}

.mdt-color-grey {
    color: $greyColor;

    &:hover {
        color: $greyColorHover;
    }
}

.mdt-color-yellow {
    color: $yellowColor;

    &:hover {
        color: $yellowColorHover;
    }
}

.mdt-color-text {
    color: $textColor;

    &:hover {
        color: $textColorHover;
    }
}

.green-btn {
    background-color: $greenColor;
    box-shadow: 0 0 10px $greenColorFaded;
    color: $textColor;

    &:hover {
        background-color: $greenColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px $greenColorFaded;
    }
}

.orange-btn {
    background-color: $secondaryColor;
    box-shadow: 0 0 10px #e37826ab;
    color: $textColor;

    &:hover {
        background-color: $secondaryColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px #b460209e;
    }
}

.red-btn {
    background-color: $redColor;
    box-shadow: 0 0 10px $redColorFaded;
    color: $textColor;

    &:hover {
        background-color: $redColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px $redColorFaded;
    }
}

.purple-btn {
    background-color: $purpleColor;
    box-shadow: 0 0 10px $purpleFadedColor;
    color: $textColor;

    &:hover {
        background-color: $purpleColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px $purpleFadedColor;
    }
}

.teal-btn {
    background-color: $tealColor;
    box-shadow: 0 0 10px $tealFadedColor;
    color: $textColor;

    &:hover {
        background-color: $tealColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px $tealFadedColor;
    }
}

.yellow-btn {
    background-color: $yellowColor;
    box-shadow: 0 0 10px $yellowFadedColor;
    color: $textColor;

    &:hover {
        background-color: $yellowColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px $yellowFadedColor;
    }
}

.blue-btn {
    background-color: $blueColor;
    box-shadow: 0 0 10px $blueFadedColor;
    color: $textColor;

    &:hover {
        background-color: $blueColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px $blueFadedColor;
    }
}

.dark-blue-btn {
    background-color: $dark-blueColor;
    box-shadow: 0 0 10px $dark-blueFadedColor;
    color: $textColor;

    &:hover {
        background-color: $dark-blueColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px $dark-blueFadedColor;
    }
}

.grey-btn {
    background-color: $greyColor;
    box-shadow: 0 0 10px $greyFadedColor;
    color: $textColor;

    &:hover {
        background-color: $greyColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px $greyFadedColor;
    }
}

.light-green-btn {
    background-color: $light-greenColor;
    box-shadow: 0 0 10px $light-greenFadedColor;
    color: $textColor;

    &:hover {
        background-color: $light-greenColorHover;
        color: $textColorHover;
    }

    &:focus {
        box-shadow: 0 0 10px $light-greenFadedColor;
    }
}

/* Bootstrap overwrite */
input,
textarea {
    color: $textColorHover !important;
    border-color: $primaryColorLightHover !important;
    background-color: $primaryColorLightHover !important;
}

textarea {
    resize: none;
}

input[type="range"] {
    background-color: transparent !important;
}

input[type="range"]::-webkit-slider-thumb {
    background-color: $secondaryColor;

    &:focus {
        background-color: $secondaryColorHover !important;
    }

    &:active {
        background-color: $secondaryColorHover !important;
        box-shadow: 0 0 10px #e37826ab;
    }
}

input[type="range"]:focus::-webkit-slider-thumb {
    box-shadow: 1px 1px 1px #e37826ab;
}

.dropdown-menu {
    background-color: $primaryColorLightHover;

    .dropdown-header,
    .dropdown-item {
        background-color: $primaryColorLightHover;
        color: $textColor;
    }

    .dropdown-item {
        &:hover {
            background-color: $primaryColorLight;
        }
    }
}

.form-control:focus,
.form-check-input:focus {
    border-color: $secondaryDarkColor !important;
    box-shadow: 0 0 0 0.1rem #a5571baf;
}

.nav-pills .nav-link.active,
.nav-pills .show > .nav-link {
    color: $textColor;
    background-color: $secondaryColor;
    box-shadow: 0 0 10px #e37826ab;
}

.nav-link {
    display: block;
    padding: 0.5rem 1rem;
    color: $textColorHover;
    text-decoration: none;
    transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out,
        border-color 0.15s ease-in-out;

    &:hover {
        color: $textColor;
    }
}

.list-group-item {
    color: $textColor !important;
    border-color: $primaryColorLight !important;
    background-color: $formBackground !important;

    &:hover {
        background-color: #3a3d47 !important;
    }
}

.page-link {
    background-color: #2d3138;
    color: $textColor;
    border-color: #3e414b;

    &:focus,
    &:hover {
        color: $textColorHover;
        background-color: $primaryColorLightHover;
        border-color: #3e414b;
    }

    &:focus {
        box-shadow: 0 0 0.25rem #b460209e;
    }
}

.page-item.active .page-link {
    color: $textColor;
    background-color: $secondaryColor;
    border-color: #3e414b;
}

.page-item.disabled .page-link {
    color: #bfbfbf7c;
    background-color: #2d3138;
    border-color: #3e414b;
}

.modal-content {
    border: none;
}

.modal-header,
.modal-body,
.modal-footer {
    background-color: #292c35;
    border-color: $primaryColorLightHover;
}

.mdt_required {
    color: $redColor;
}

// Animations
.fade-in-visible {
    animation: fadeIn 0.15s;
}

.fade-out-hide {
    animation: fadeOut 0.15s;
}

@keyframes fadeOut {
    0% {
        opacity: 0.5;
    }
    100% {
        opacity: 0;
    }
}

@keyframes fadeIn {
    0% {
        opacity: 0;
    }
    100% {
        opacity: 0.5;
    }
}

.mdt-show {
    animation: mdtShow 0.75s forwards;
}

.mdt-hide {
    animation: mdtHide 0.75s forwards;
}

.mdt-placeholder {
    color: #bfbfbf7c;
}

@keyframes mdtHide {
    0% {
        opacity: 1;
        transform: translateY(0px);
    }
    100% {
        opacity: 0;
        transform: translateY(500px);
    }
}

@keyframes mdtShow {
    0% {
        opacity: 0;
        transform: translateY(500px);
    }
    100% {
        opacity: 1;
        transform: translateY(0px);
    }
}

/* Scrollbar */
::-webkit-scrollbar {
    width: 10px;
    border-radius: 3px;
}

::-webkit-scrollbar-track {
    background: $primaryColorLight;
    border-radius: 3px;
}

::-webkit-scrollbar-thumb {
    background: #41434b;
    border-radius: 3px;
}

::-webkit-scrollbar-thumb:hover {
    background: #53565f;
    border-radius: 3px;
}

.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.2s;
}

.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>