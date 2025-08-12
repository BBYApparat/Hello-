<template>
    <div class="modal fade" data-bs-backdrop="false" data-bs-keyboard="false" :id="modalId" tabindex="-1"
        aria-labelledby="settingsLabel" aria-hidden="true">
        <div class=" modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable ">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="settingsLabel">
                        {{ $store.getters.GetTranslation('settings', 'title') }}
                    </h5>
                </div>

                <div class="modal-body">
                    <div class="row justify-content-md-center mb-1">
                        <div class="col h5 text-center fw-bold">
                            {{ $store.getters.GetTranslation('settings', 'category_1') }}
                        </div>

                        <div class="row justify-content-center mdt-form">
                            <div class="col text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('settings', 'category_2') }}
                                </label>
                                <div class="dropdown">
                                    <a class="btn grey-btn btn-sm dropdown-toggle position-relative me-3" href="#"
                                        role="button" id="settingsDropdown" data-bs-toggle="dropdown"
                                        data-bs-auto-close="outside" aria-expanded="false"
                                        @click="ToggleDropdown('settingsDropdown')">
                                        {{ notifySoundLabel }}
                                    </a>

                                    <button type="button" class="btn btn-sm blue-btn" @click="PlaySound()">
                                        {{ $store.getters.GetTranslation('settings', 'play') }}
                                    </button>

                                    <ul class="dropdown-menu" aria-labelledby="settingsDropdown">
                                        <li>
                                            <a class="dropdown-item" href="#" @click="UpdateNotifySound(1)">
                                                {{ $store.getters.GetTranslation('settings', 'notif_1') }}
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="#" @click="UpdateNotifySound(2)">
                                                {{ $store.getters.GetTranslation('settings', 'notif_2') }}
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="#" @click="UpdateNotifySound(3)">
                                                {{ $store.getters.GetTranslation('settings', 'notif_3') }}
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-4 text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('settings', 'category_3') }}
                                </label>
                                <input type="range" class="form-range" min="0" max="1" step="0.1"
                                    v-model="settings.notify.volume">
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-4 text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('settings', 'category_4') }}
                                </label>
                                <input type="range" class="form-range" min="0" max="1" step="0.1"
                                    v-model="settings.notify.panicVolume">
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form">
                            <div class="col text-center">
                                <button type="button" class="btn btn-sm blue-btn" @click="PlaySound(true)">
                                    {{ $store.getters.GetTranslation('settings', 'play') }}
                                </button>
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-3">
                            <div class="col h6 text-center">
                                {{ $store.getters.GetTranslation('settings', 'category_5') }}
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form">
                            <div class="col-8 text-center">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox"
                                        v-model="settings.notify.alerts.onDuty">
                                    <label class="form-check-label">
                                        {{ $store.getters.GetTranslation('settings', 'alert_1') }}
                                    </label>
                                </div>

                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox"
                                        v-model="settings.notify.alerts.offDuty">
                                    <label class="form-check-label">
                                        {{ $store.getters.GetTranslation('settings', 'alert_2') }}
                                    </label>
                                </div>

                                <div class="form-check form-check-inline" v-if="perms.bolo || perms.warrant">
                                    <input class="form-check-input" type="checkbox"
                                        v-model="settings.notify.alerts.boloEntry">
                                    <label class="form-check-label">
                                        {{ $store.getters.GetTranslation('settings', 'alert_3') }}
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center mdt-form mt-3">
                        <div class="col h5 text-center fw-bold">
                            {{ $store.getters.GetTranslation('settings', 'category_6') }}
                        </div>

                        <div class="row justify-content-center mdt-form">
                            <div class="col-xxl-3 col-4 text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('settings', 'category_7') }}
                                </label>
                                <div class="input-group">
                                    <button class="btn blue-btn btn-sm" type="button" id="keybind-btn"
                                        @click="ToggleKeybindClick()">
                                        {{ $store.getters.GetTranslation('settings', 'set') }}
                                    </button>

                                    <input type="text" class="form-control"
                                        :placeholder="listeningForKeyPress ? $store.getters.GetTranslation('settings', 'assignkey') : $store.getters.GetTranslation('settings', 'defaultkey')"
                                        :value="settings.keybind" readonly />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn green-btn me-3" @click="SaveSettings()">
                        {{ $store.getters.GetTranslation('settings', 'save') }}
                    </button>
                    <button type="button" class="btn orange-btn" @click="CloseModal()">
                        {{ $store.getters.GetTranslation('settings', 'close') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Dropdown } from "bootstrap/dist/js/bootstrap.esm.min.js";
import { Modal } from "bootstrap/dist/js/bootstrap.esm.min.js";
import api from '@/api/main'

export default {
    name: "Settings",
    data() {
        return {
            modalId: "settings" + "Modal",
            beingShown: false,

            settings: {
                notify: {
                    sound: 1,
                    volume: 0.5,
                    panicVolume: 0.75,
                    alerts: {
                        onDuty: true,
                        offDuty: true,
                        boloEntry: true
                    },
                },
                keybind: '',
            },

            notifySoundLabel: 'Loading...',
            listeningForKeyPress: false,
            prevKey: '',

            perms: {
                bolo: false,
                warrant: false,
            }
        };
    },
    props: ["parentElId", "show"],
    mounted() {
        setInterval(() => {
            if (this.show && !this.beingShown) {
                this.ShowModal();
            }
        }, 100);

        this.CheckPerms()
    },
    methods: {
        CheckPerms() {
            let player = this.$store.getters.GetSelf()

            if (player) {
                const playerJob = player.job

                this.perms.bolo = this.$store.getters.HasPerm(playerJob, 'bolos', 'tab')
                this.perms.warrant = this.$store.getters.HasPerm(playerJob, 'warrants', 'tab')
            }
        },

        ToggleKeybindClick() {
            let el = document.getElementById('keybind-btn')
            el.blur()

            this.ToggleKeybindSet()
        },

        ToggleKeybindSet() {
            if (!this.listeningForKeyPress) {
                this.listeningForKeyPress = true
                this.prevKey = this.settings.keybind
                this.settings.keybind = ''
                document.addEventListener('keydown', this.ListenForKeypress);
            } else {
                this.listeningForKeyPress = false
                if (this.settings.keybind.length === 0) {
                    this.settings.keybind = this.prevKey
                    this.prevKey = ''
                }
                document.removeEventListener('keydown', this.ListenForKeypress);
            }
        },

        ListenForKeypress(e) {
            const keybinds = this.$store.state.config.Keybinds.list;
            if ( keybinds.find(key => e.code === key) ) {
                this.settings.keybind = e.code
            } else {
                this.SendNotification(
                    this.$store.getters.GetTranslation('settings', 'error'),
                    this.$store.getters.GetTranslation('settings', 'error_msg'),
                    4000,
                    'error',
                    false,
                    false
                );
            }
            this.ToggleKeybindSet()
        },

        PlaySound(panic) {
            if ( panic ) {
                this.PlayAudio('panic', this.settings.notify.panicVolume)
            } else {
                this.PlayAudio(`notification${this.settings.notify.sound}`, this.settings.notify.volume)
            }
        },

        UpdateNotifySound(sound) {
            this.settings.notify.sound = sound
            this.notifySoundLabel = `${this.$store.getters.GetTranslation('settings', 'sound')} ${sound}`

            this.ToggleDropdown('settingsDropdown')
        },

        SaveSettings() {
            api.general.UpdateSettings(this.settings)

            this.CloseModal()

            this.SendNotification(
                this.$store.getters.GetTranslation('settings', 'saved'),
                this.$store.getters.GetTranslation('settings', 'saved_msg'),
                4000,
                'success',
                false,
            );
        },

        ToggleDropdown(id) {
            var dropdownEl = document.getElementById(id);
            var dropdownInstance = Dropdown.getOrCreateInstance(dropdownEl);
            dropdownInstance.toggle();
        },

        ShowModal() {
            if (!this.beingShown) {
                // Append modal to body
                var modalEl = document.getElementById(this.modalId);
                document.body.appendChild(modalEl);

                var modalInstance = Modal.getOrCreateInstance(modalEl);
                modalInstance.show();

                this.settings.keybind = this.$store.state.settings.keybind

                this.settings.notify.sound = this.$store.state.settings.notify.sound
                this.settings.notify.volume = this.$store.state.settings.notify.volume
                this.settings.notify.panicVolume = this.$store.state.settings.notify.panicVolume
                this.notifySoundLabel = `${this.$store.getters.GetTranslation('settings', 'sound')} ${this.$store.state.settings.notify.sound}`

                // Alerts
                this.settings.notify.alerts.onDuty = this.$store.state.settings.notify.alerts.onDuty
                this.settings.notify.alerts.offDuty = this.$store.state.settings.notify.alerts.offDuty
                this.settings.notify.alerts.boloEntry = this.$store.state.settings.notify.alerts.boloEntry

                this.$store.commit('SetModalOpen')
                this.beingShown = true;
            }
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
                }, 175);

                this.$store.commit('SetModalClosed')
                this.beingShown = false;
            }
        },
    },
};
</script>
