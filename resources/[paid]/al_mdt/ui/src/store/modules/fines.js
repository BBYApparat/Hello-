import api from '@/api/main'

const state = {
    data: [],
    loaded: false,
    identifier: false,
}

const getters = {
    HasLoadedFines: (state) => () => {
        return state.loaded
    },
}

const mutations = {
    SetFines(state, payload) {
        if (payload !== undefined) {
            state.data = payload

            if (!state.loaded) {
                setTimeout(() => {
                    state.loaded = true
                }, 1000)
            }
        }
    },
    SetIdentifier(state, payload) {
        state.identifier = payload
    },
    SetLoaded(state, payload) {
        state.loaded = payload
    },
}

const actions = {
    async GetFines({ commit }, identifier) {
        commit('SetLoaded', false)

        const resp = await api.reports.FetchFines(identifier);

        commit('SetIdentifier', identifier)
        commit('SetFines', resp)
    },
}

export default {
    state,
    getters,
    actions,
    mutations
}