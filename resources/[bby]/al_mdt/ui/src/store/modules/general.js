import api from '@/api/main'

const state = {
    loginUsername: '',
    loggedIn: false,

    registerUser: {
        username: '',
        job: '',
    },

    savedComponents: {},

    visibility: {
        mdt: false,
        fines: false
    },

    modalOpen: false,
}

const getters = {
    GetComponentData: (state) => (id) => {
        if (state.savedComponents[id] !== undefined) {
            return state.savedComponents[id]
        } else {
            return false
        }
    },

    IsLoggedIn: (state) => () => {
        return state.loggedIn
    },

    IsVisible: (state) => (type) => {
        if (state.visibility[type] !== undefined) {
            return state.visibility[type]
        } else {
            return false
        }
    },

    IsModalOpen: (state) => () => {
        return state.modalOpen
    }
}

const mutations = {
    SaveComponentData(state, payload) {
        state.savedComponents[payload.index] = payload.data
    },

    RemoveComponentData(state, payload) {
        state.savedComponents[payload.index] = undefined;
    },

    UpdateLoginUsername(state, payload) {
        if (payload) {
            state.loginUsername = payload;
        }
    },

    SetLogin(state, payload) {
        state.loggedIn = payload ? true : false;
    },

    SetRegisterData(state, payload) {
        if (payload !== undefined) {
            state.registerUser = {
                username: payload.name,
                job: payload.job,
            }
        }
    },

    SetVisibility(state, payload) {
        if (state.visibility[payload.type] !== undefined) {
            state.visibility[payload.type] = payload.visible
        }
    },

    ResetLogin(state) {
        state.loginUsername = ''
        state.loggedIn = false
        state.registerUser = {
            username: '',
            job: '',
        }
        state.savedComponents = {}
    },

    SetModalOpen(state) {
        state.modalOpen = true
    },

    SetModalClosed(state) {
        state.modalOpen = false
    }
}

const actions = {
    async InitLogin({ commit }) {
        const apiResp = await api.login.GetLoginInfo()

        if (apiResp.name !== undefined) {
            commit('UpdateLoginUsername', apiResp.name)
        } else if (apiResp.register.name !== undefined) {
            commit('SetRegisterData', apiResp.register)
        }
    },

    async Login({ commit }, registerNewUser) {
        try {
            if (registerNewUser) {
                const apiResp = await api.login.Register() // Returns bool

                commit('SetLogin', apiResp) // Log in if approved
                return apiResp
            } else {
                const apiResp = await api.login.Login()

                commit('SetLogin', apiResp) // Log in if approved
                return apiResp
            }
        } catch (error) {
            return false
        }
    }
}

export default {
    state,
    getters,
    actions,
    mutations
}