//import api from '@/api/main'

const state = {
    notify: {
        sound: 1,
        volume: 0.5,
        panicVolume: 0.75,

        alerts: {
            onDuty: true,
            offDuty: true,
            boloEntry: true,
        },
    },

    keybind: '',
}

const getters = {
    GetNotifySound: (state) => () => {
        return `notification${state.notify.sound}`
    },

    CanNotify: (state) => (type) => {
        if (state.notify.alerts[type] !== undefined) {
            return state.notify.alerts[type] // Returns bool
        } else {
            return false
        }
    },
}

const mutations = {
    SetNotifySound(state, payload) {
        if (payload) {
            state.notify.sound = payload
        }
    },

    SetNotifyVolume(state, payload) {
        if (payload) {
            state.notify.volume = payload
        }
    },

    SetPanicVolume(state, payload) {
        if (payload) {
            state.notify.panicVolume = payload
        }
    },

    SetKeybind(state, payload) {
        if (payload) {
            state.keybind = payload
        }
    },

    SetAlerts(state, payload) {
        if (payload) {
            state.notify.alerts = {
                onDuty: payload.onDuty !== undefined ? payload.onDuty : true,
                offDuty: payload.offDuty !== undefined ? payload.offDuty : true,
                boloEntry: payload.boloEntry !== undefined ? payload.boloEntry : true,
            }
        }
    },
}

const actions = {
    SetSettings({ commit }, payload) {
        if (payload.keybind !== undefined && payload.keybind.length > 0) {
            commit('SetKeybind', payload.keybind)
        }

        if (payload.notify !== undefined) {
            commit('SetNotifySound', payload.notify.sound)
            commit('SetNotifyVolume', payload.notify.volume)
            commit('SetPanicVolume', payload.notify.panicVolume)

            if (payload.notify.alerts !== undefined) {
                commit('SetAlerts', payload.notify.alerts)
            }
        }
    },
}

export default {
    state,
    getters,
    mutations,
    actions,
}