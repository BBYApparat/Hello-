import store from '@/store'
const resourceName = 'al_mdt'

class loginApi {
    constructor() {
        this.GetLanguage()
        
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
    InitWebApp(data) {
        /*
            data.users = Array
            data.bolos = {
                persons = Array,
                vehicles = Array,
                warrants = Array,
            }
        */

        try {
            if (data) {
                //console.log(data)

                // Setup users data
                store.dispatch('SetUsers', data.users)

                if (store.getters.HasPerm(store.getters.GetSelf().job, 'bolos', 'tab')) {
                    store.commit('SetupBoloData', {
                        type: 'vehicles',
                        data: data.bolos.vehicles
                    })

                    store.commit('SetupBoloData', {
                        type: 'people',
                        data: data.bolos.persons
                    })
                }

                if (store.getters.HasPerm(store.getters.GetSelf().job, 'warrants', 'tab')) {
                    store.commit('SetupBoloData', {
                        type: 'warrants',
                        data: data.bolos.warrants
                    })
                    store.commit('SetupBoloData', {
                        type: 'warrants',
                        data: data.bolos.warrants
                    })
                }

                return true
            } else {
                console.log('no data')
                return false
            }
        } catch (error) {
            console.log(error)
            return false
        }
    }

    // [POST] Get language / translation
    async GetLanguage() {
        try {
            let data = await this.Post('getLanguage')

            if (data) {
                // Setup language
                store.commit('SetLanguage', data)

                return true
            } else {
                return false
            }
        } catch (error) {
            return false
        }
    }

    // [POST] Get config
    async GetConfig() {
        /*
            data.CriminalCode = Array
            data.General = {
                Title: string
            }
            data.LicenseLabels = Array
            data.incidentResultTypes = Object
            data.Permissions = Object
        */

        try {
            let data = await this.Post('getConfig')

            if (data) {
                // Setup permissions
                store.commit('SetPermissions', data.Permissions)
                data.Permissions = undefined

                // Setup config
                store.commit('SetConfig', data)

                return true
            } else {
                return false
            }
        } catch (error) {
            return false
        }
    }

    // [POST] Get login information
    async GetLoginInfo() {
        let loginData = await this.Post('getLoginInfo')
        return loginData
    }

    // [POST] Register
    async Register() {
        let appData = await this.Post('registerUser')
        let configInit = await this.GetConfig()
        let canInit = this.InitWebApp(appData)

        return (appData !== undefined && canInit && configInit) ? true : false
    }

    // [POST] Login
    async Login() {
        let appData = await this.Post('loginUser')
        let configInit = await this.GetConfig()
        let canInit = this.InitWebApp(appData.resp)

        if (appData.resp !== undefined && canInit && configInit) {
            if (appData.user.settings !== undefined) {
                store.dispatch('SetSettings', appData.user.settings)
            }

            return appData.resp
        } else {
            return false
        }
    }
}

const instance = new loginApi()

export default instance