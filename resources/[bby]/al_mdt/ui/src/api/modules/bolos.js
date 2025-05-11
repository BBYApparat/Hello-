import store from '@/store'
const resourceName = 'al_mdt'

class boloApi {
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

    // [MESSAGE]
    SyncBolos(data) {
        try {
            if (data && (store.getters.HasPerm(store.getters.GetSelf().job, 'bolos', 'tab') || store.getters.HasPerm(store.getters.GetSelf().job, 'warrants', 'tab'))) {
                // Update bolo data
                store.commit('SetupBoloData', {
                    type: 'vehicles',
                    data: data.bolos.vehicles
                })

                store.commit('SetupBoloData', {
                    type: 'people',
                    data: data.bolos.persons
                })

                store.commit('SetupBoloData', {
                    type: 'warrants',
                    data: data.bolos.warrants
                })

                if (data.boloType) {
                    if (data.boloType === 'warrant') {
                        this.SendNotification(
                            'New warrant entry',
                            `A new warrant entry was submitted`,
                            7500,
                            'info',
                            true,
                            store.getters.CanNotify('boloEntry')
                        );
                    } else if (data.boloType === 'vehicle') {
                        this.SendNotification(
                            'New bolo entry',
                            `A new (vehicle) bolo entry was submitted`,
                            7500,
                            'info',
                            true,
                            store.getters.CanNotify('boloEntry')
                        );
                    } else if (data.boloType === 'person') {
                        this.SendNotification(
                            'New bolo entry',
                            `A new (person) bolo entry was submitted`,
                            7500,
                            'info',
                            true,
                            store.getters.CanNotify('boloEntry')
                        );
                    }
                }
            }
        } catch (error) {
            console.log('Error caught (Sync bolos): ', error)
        }
    }

    // [POST]
    AddBolo(entry) {
        try {
            this.Post('addBolo', entry)
        } catch (error) {
            console.log('Error caught (Adding bolo): ', error)
        }
    }

    // [POST]
    UpdateBolo(entry) {
        try {
            this.Post('updateBolo', entry)
        } catch (error) {
            console.log('Error caught (Updating bolo): ', error)
        }
    }

    // [POST]
    RemoveBolo(entry) {
        try {
            this.Post('removeBolo', entry)
        } catch (error) {
            console.log('Error caught (Removing bolo): ', error)
        }
    }
}

const instance = new boloApi()

export default instance