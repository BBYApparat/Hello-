<template>
    <div id="mdt-notifications" aria-live="polite" aria-atomic="true" class="position-sticky" style="top: 0; z-index: 9999;">
        <div class="toast-container position-absolute end-0 p-3">
            <template v-for="(data, index) in $store.state.notifications.currentFeed" :key="data.timeStamp + '_notification_feed'">
                <Toast
                    :id="index"
                    :timeStamp="data.timeStamp"
                    :title="data.title"
                    :msg="data.msg"
                    :duration="data.duration"
                    :type="data.type"
                    :useSound="data.useSound"
                />
            </template>
        </div>
    </div>
</template>

<script>
import Toast from "./Modules/Notifcations/Toast";

export default {
    name: "NotificationManager",
    components: {
        Toast,
    },
    mounted() {
        document.getElementById("app").addEventListener("newNotificationEntry", this.NotificationListener);
    },
    unmounted() {
        document.getElementById("app").removeEventListener("newNotificationEntry", this.NotificationListener);
    },
    methods: {
        NotificationListener(e) {
            e.detail.duration = e.detail.duration > 2000 ? e.detail.duration : 2000 // Ensure notification is at least 2 secs long

            this.$store.dispatch('AddNotification', e.detail)
        }
    }
};
</script>