import { createApp } from "vue";
import store from './store/index'

import App from "./App.vue";

// Bootstrap
import { Tooltip } from "bootstrap/dist/js/bootstrap.esm.min.js";
import router from "./router/index";

const app = createApp(App);

app.use(router)
app.use(store)

app.mixin({
    methods: {
        PlayAudio(sound, volume) {
            var audio = new Audio(`/ui/media/${sound}.ogg`)
            audio.volume = volume > 1 ? 1 : volume
            audio.play()
        },

        alertTabChange() {
            var app = document.getElementById("app");
            app.dispatchEvent(new Event("changingTab"));
        },

        changeTab(id) {
            this.alertTabChange();
            this.$router.push(`/${id}`)

            setTimeout(() => {
                this.RefreshBS();
            }, 500);
        },

        TimeSince(date) {
            var seconds = Math.floor((new Date() - date) / 1000);
            var interval = seconds / 31536000;

            if (interval > 1) {
                let timeAgo = Math.floor(interval);
                return `${timeAgo} ${timeAgo === 1 ? this.$store.getters.GetTranslation('store_users', 'year') : this.$store.getters.GetTranslation('store_users', 'years')}`;
            }
            interval = seconds / 2592000;
            if (interval > 1) {
                let timeAgo = Math.floor(interval);
                return `${timeAgo} ${timeAgo === 1 ? this.$store.getters.GetTranslation('store_users', 'month') : this.$store.getters.GetTranslation('store_users', 'months')}`;
            }
            interval = seconds / 86400;
            if (interval > 1) {
                let timeAgo = Math.floor(interval);
                return `${timeAgo} ${timeAgo === 1 ? this.$store.getters.GetTranslation('store_users', 'day') : this.$store.getters.GetTranslation('store_users', 'days')}`;
            }
            interval = seconds / 3600;
            if (interval > 1) {
                let timeAgo = Math.floor(interval);
                return `${timeAgo} ${timeAgo === 1 ? this.$store.getters.GetTranslation('store_users', 'hour') : this.$store.getters.GetTranslation('store_users', 'hours')}`;
            }
            interval = seconds / 60;
            if (interval > 1) {
                let timeAgo = Math.floor(interval);
                return `${timeAgo} ${timeAgo === 1 ? this.$store.getters.GetTranslation('store_users', 'minute') : this.$store.getters.GetTranslation('store_users', 'minutes')}`;
            }

            return `${Math.floor(seconds)} ${Math.floor(seconds) === 1 ? this.$store.getters.GetTranslation('store_users', 'second') : this.$store.getters.GetTranslation('store_users', 'seconds') }`;
        },

        GetElapsedTime(startTime, endTime) {
            var seconds;
            if (startTime && endTime) {
                seconds = Math.floor((startTime - endTime) / 1000);
            } else {
                seconds = Math.floor(startTime / 1000);
            }
            var interval = seconds / 31536000;

            interval = seconds / 3600;
            if (interval > 1) {
                let timeAgo = Math.floor(interval);
                return `${timeAgo} ${timeAgo === 1 ? this.$store.getters.GetTranslation('store_users', 'hour') : this.$store.getters.GetTranslation('store_users', 'hours') }`;
            }
            interval = seconds / 60;
            if (interval > 1) {
                let timeAgo = Math.floor(interval);
                return `${timeAgo} ${timeAgo === 1 ? this.$store.getters.GetTranslation('store_users', 'minute') : this.$store.getters.GetTranslation('store_users', 'minutes') }`;
            }

            return `${Math.floor(seconds)} ${Math.floor(seconds) === 1 ? this.$store.getters.GetTranslation('store_users', 'second') : this.$store.getters.GetTranslation('store_users', 'seconds')}`;
        },

        GetStatusLabel(status) {
            var statusDict = [
                this.$store.getters.GetTranslation('store_users', 'status_unavail'),
                this.$store.getters.GetTranslation('store_users', 'status_avail'),
                this.$store.getters.GetTranslation('store_users', 'status_busy'),
                this.$store.getters.GetTranslation('store_users', 'status_oncall'),
                this.$store.getters.GetTranslation('store_users', 'status_intran'),
                this.$store.getters.GetTranslation('store_users', 'status_panic'),
            ]

            if (statusDict[status] !== undefined) {
                return statusDict[status] !== undefined ? statusDict[status] : 'Error - Unknown Status'
            }
        },

        SendNotification(title, msg, duration, type, tracked, useSound) {
            let timeStamp = Date.now();

            const event = new CustomEvent("newNotificationEntry", {
                detail: {
                    timeStamp: timeStamp,
                    title: title ? title : "No title was set to this notification",
                    msg: msg ? msg : "No message was set to this notification",
                    duration: duration ? duration : 5000,
                    type: type ? type : false,
                    tracked: tracked ? true : false,
                    useSound: useSound ? useSound : false,
                },
            });

            document.getElementById("app").dispatchEvent(event);
        },

        // Utils
        FormatDate(date, includeTime) {
            if (includeTime) {
                return new Date(date).toLocaleString(false, { dateStyle: 'short', timeStyle: 'short' })
            } else {
                return new Date(date).toLocaleDateString()
            }

        },

        FormatNumber(num) {
            if (num != undefined && typeof num == "number") {
                return new Intl.NumberFormat().format(num);
            }
        },

        FormatStringLength(str, maxLength) {
            if (str != undefined && maxLength != undefined) {
                if (typeof str == "number") {
                    str = this.FormatNumber(str);
                }

                if (str.length > maxLength) {
                    return `${str.substring(0, maxLength)}...`;
                } else {
                    return str;
                }
            }
        },

        GetRandomInt(max) {
            return Math.floor(Math.random() * max);
        },

        ToggleLoadingScreen(show) {
            var loadEl = document.getElementById("loading");

            if (show != undefined) {
                if (show) {
                    loadEl.style.display = "block";

                    setTimeout(() => {
                        loadEl.classList.add("show");
                    }, 10);
                } else if (!show) {
                    loadEl.classList.remove("show");
                    setTimeout(() => {
                        loadEl.style.display = "none";
                    }, 500);
                }
            } else {
                if (loadEl.classList.contains("show")) {
                    loadEl.classList.remove("show");
                    setTimeout(() => {
                        loadEl.style.display = "none";
                    }, 500);
                } else {
                    loadEl.style.display = "block";
                    setTimeout(() => {
                        loadEl.classList.add("show");
                    }, 10);
                }
            }
        },

        Pagination(currentPage, pageCount) {
            let delta = 2,
                left = currentPage - delta,
                right = currentPage + delta + 1,
                result = [];

            result = Array.from({ length: pageCount }, (v, k) => k + 1)
                .filter(i => i && i >= left && i < right);

            return result;
        },

        RefreshBS() {
            // BS Tooltips
            Array.from(document.querySelectorAll('button[data-bs-toggle="tooltip"]')).forEach(
                (tooltipNode) => new Tooltip(tooltipNode)
            );
        },
    },
});

app.mount("#app");