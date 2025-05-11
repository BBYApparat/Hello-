import store from '@/store'
const resourceName = 'al_mdt'

class generalApi {
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

    // [UTILITY]
    ToggleVisibility(type) {
        let el = document.getElementById('mdt-mothership')
        let visible = false

        if (type !== undefined) {
            visible = store.getters.IsVisible(type)
        } else {
            if (store.getters.IsVisible('mdt')) {
                type = 'mdt'
                visible = true
            } else if (store.getters.IsVisible('fines')) {
                type = 'fines'
                visible = true
            }
        }

        if (visible) {
            this.Post('closeMDT')
            el.classList.add('mdt-hide')

            // Remove tooltips from view
            var tooltipArray = Array.from(document.querySelectorAll(":scope body > .tooltip"));
            tooltipArray.forEach(el => {
                el.remove()
                console.log('Removed tooltip')
            })

            setTimeout(() => {
                el.style.opacity = 0;
                el.style.display = 'none'

                store.commit('SetVisibility', {
                    type: type,
                    visible: !visible,
                })
            }, 750)
        } else {
            el.style.display = 'block'
            el.classList.remove('mdt-hide')
            el.classList.add('mdt-show')

            setTimeout(() => {
                el.style.opacity = 1;
                el.classList.remove('mdt-show')
            }, 750)

            store.commit('SetVisibility', {
                type: type,
                visible: !visible,
            })
        }
    }

    // [MESSAGE]
    OpenMDT() {
        if (!store.state.general.loggedIn) {
            store.dispatch('InitLogin')
            console.log('Init login')
        }

        this.ToggleVisibility('mdt')
    }

    // [MESSAGE]
    OpenFines(data) {
        this.ToggleVisibility('fines')

        store.dispatch('GetFines', data.identifier)
    }

    Logout() {
        // Clear bolo data
        store.commit('SetupBoloData', {
            type: 'vehicles',
            data: []
        })

        store.commit('SetupBoloData', {
            type: 'people',
            data: []
        })

        store.commit('SetupBoloData', {
            type: 'warrants',
            data: []
        })

        // Clear users data
        store.dispatch('SetUsers', [])

        store.commit('ResetLogin')

        // Post here
        this.Post('logout')

        setTimeout(() => {
            store.dispatch('InitLogin')
        }, 250)
    }

    // [POST]
    UpdateSettings(settings) {
        store.dispatch('SetSettings', settings)

        this.Post('updateSettings', settings)
    }

    async TakePhoto() {
        this.ToggleVisibility('mdt') // Hide
        const resp = await this.Post('takePhoto')
        this.ToggleVisibility('mdt') // Show

        if (resp !== undefined && resp && resp.length !== 0) {
            return resp
        } else {
            return false
        }
    }
}

const instance = new generalApi()

export default instance