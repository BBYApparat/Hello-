import store from '@/store'
const resourceName = 'al_mdt'

class usersApi {
    constructor() {
        window.addEventListener('message', (event) => {
            const eventType = event.data.type
            if (eventType !== undefined && typeof this[eventType] === 'function') {
                this[eventType](event.data)
            }
        })
    }

    async Post(method, data) {
        if (process.env.NODE_ENV !== 'development') {
            const formattedData = data === undefined ? '{}' : JSON.stringify(data)

            try {
                let response = await fetch(`https://${resourceName}/${method}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: formattedData
                });

                return await response.json()
            } catch (error) {
                return false
            }
        }
    }

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
    }

    // [POST]
    SetGPS(player) {
        this.Post('setGPS', player)
    }

    // [POST]
    SetStatus(player, status) {
        this.Post('setStatus', {
            identifier: player,
            status: status,
        })
    }

    // [POST]
    SetUserCallsign(callsign) {
        this.Post('setUserCallsign', {
            identifier: store.getters.GetSelf().identifier,
            callsign: callsign,
        })
    }

    // [POST]
    GoOnDuty(identifier, time) {
        this.Post('goOnDuty', {
            identifier: identifier,
            time: time,
            job: store.getters.GetSelf().job,
        })
    }

    // [POST]
    GoOffDuty(data) {
        this.Post('goOffDuty', data)
    }

    // [POST]
    async GetJobActivity(pageNumber, getTotalUsers) {
        return await this.Post('getJobActivity', {
            job: store.getters.GetSelf().job,
            page: pageNumber,
            getTotal: getTotalUsers || false,
            date: Date.now() - 604800000
        })
    }

    // [POST]
    async GetActivityStatistics(identifier) {
        return await this.Post('getActivityStatistics', {
            identifier: identifier,
            job: store.getters.GetSelf().job,
        })
    }

    // [POST]
    async GetActivityLog(identifier, pageNumber, getTotalPages) {
        return await this.Post('getActivityLog', {
            identifier: identifier,
            job: store.getters.GetSelf().job,
            page: pageNumber,
            getTotal: getTotalPages,
        })
    }

    // [MESSAGE]
    SyncUsers(data) {
        data = data.data

        if (data) {
            // Update users data
            store.dispatch('SetUsers', data.users)

            if (data.update !== undefined) {
                if (store.getters.HasPerm(store.getters.GetSelf().job, 'units', data.update.playerJob)) { // If has perms
                    if (data.update.type === 'onduty') {
                        this.SendNotification(
                            'New unit on duty',
                            `${data.update.player} has began their shift.`,
                            7500,
                            'info',
                            true,
                            store.getters.CanNotify('onDuty')
                        );
                    } else if (data.update.type === 'offduty') {
                        this.SendNotification(
                            'Unit went off duty',
                            `${data.update.player} has ended their shift.`,
                            7500,
                            'info',
                            true,
                            store.getters.CanNotify('onDuty')
                        );
                    } else if (data.update.type === 'panic') {
                        this.SendNotification(
                            'Panic',
                            `${data.update.player} has triggered a panic button`,
                            7500,
                            'alert',
                            true,
                            'panic'
                        );
                    }
                }
            }
        }
    }

    // [MESSAGE]
    PanicButton() {
        try {
            const self = store.getters.GetSelf().identifier

            if (self) {
                const isOnDuty = store.getters.IsOnDuty()

                if (isOnDuty) {
                    store.dispatch('SetPlayerStatus', {
                        identifier: self,
                        status: 5, // Panic
                    })
                }
            }
        } catch (error) {
            console.log('Error caught in "PanicButton" function')
        }
    }
}

const instance = new usersApi()

export default instance