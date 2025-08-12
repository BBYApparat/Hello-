import api from '@/api/main'

const state = {
    players: [],

    dutySession: {
        shiftStart: false,
    },
}

const getters = {
    GetSelf: state => () => {
        return state.players.find(player => player.self)
    },

    IsOnDuty: state => () => {
        let self = state.players.find(player => player.self)

        if (self) {
            return self.onDuty ? true : false
        } else {
            return false
        }
    },

    GetPlayersFromJob: (state) => (job) => {
        return state.players.filter(player => player.job === job)
    },

    GetOnDutyPlayersFromJob: (state) => (job) => {
        return state.players.filter(player => player.job === job && player.onDuty)
    },

    GetElapsedTimeOnDuty: (state, getters, rootState, rootGetters) => () => {
        if (state.dutySession.shiftStart) {
            var seconds = Math.floor((new Date() - state.dutySession.shiftStart) / 1000);
            var interval = seconds / 31536000;

            interval = seconds / 3600;
            if (interval > 1) {
                let timeAgo = Math.floor(interval);
                return `${timeAgo} ${timeAgo === 1 ? rootGetters.GetTranslation('store_users', 'hour') : rootGetters.GetTranslation('store_users', 'hours') }`;
            }
            interval = seconds / 60;
            if (interval > 1) {
                let timeAgo = Math.floor(interval);
                return `${timeAgo} ${timeAgo === 1 ? rootGetters.GetTranslation('store_users', 'minute') : rootGetters.GetTranslation('store_users', 'minutes') }`;
            }

            return `${Math.floor(seconds)} ${Math.floor(seconds) === 1 ? rootGetters.GetTranslation('store_users', 'second') : rootGetters.GetTranslation('store_users', 'seconds') }`;
        }
    }
}

const mutations = {
    SetPlayerStatus(state, payload) {
        let user = state.players.find(player => player.identifier === payload.identifier)

        if (user !== undefined) {
            user.status = payload.status;
        }
    },

    SetOnDuty(state, payload) {
        let self = state.players.find(player => player.self)
        self.onDuty = true
        self.status = 1 // Available

        if (payload.callsign) {
            self.callsign = payload.callsign
        }

        state.dutySession.shiftStart = payload.time
    },

    SetOffDuty(state) {
        let self = state.players.find(player => player.self)
        self.status = 0 // Unavailable
        self.onDuty = false

        state.dutySession.shiftStart = false
    },

    SetUsers(state, payload) {
        state.players = payload !== undefined ? payload : []
    }
}

const actions = {
    SetPlayerStatus({ commit }, data) {
        commit('SetPlayerStatus', data)

        api.users.SetStatus(data.identifier, data.status)
    },

    CopyPlayerStatus({ commit, getters }, status) {
        commit('SetPlayerStatus', {
            identifier: getters.GetSelf().identifier,
            status: status,
        })

        api.users.SetStatus(getters.GetSelf().identifier, status)
    },

    SetOnDuty({ commit, getters }, callsign) {
        if (callsign) {
            if (getters.GetSelf().callsign !== callsign) {
                api.users.SetUserCallsign(callsign)
            }
        }
        const currentTime = Date.now()

        commit('SetOnDuty', {
            callsign: callsign,
            time: currentTime
        })
        api.users.GoOnDuty(getters.GetSelf().identifier, currentTime)
    },

    SetOffDuty({ commit, getters }) {
        commit('SetOffDuty')

        api.users.GoOffDuty({
            identifier: getters.GetSelf().identifier,
            time: Date.now()
        })
    },

    SetUsers({ commit }, payload) {
        // let users = payload
        // users.forEach((val, index) => {
        //     let job = rootGetters.GetJobReplacement(val.job)

        //     if (job !== undefined) {
        //         users[index].job = job
        //     }
        // })

        commit('SetUsers', payload)
    }
}

export default {
    state,
    getters,
    actions,
    mutations
}

if (process.env.NODE_ENV !== 'production') {
    state.players = [
        {
            self: true,
            name: "Peter Pennywhacker",
            callsign: "D-2",
            status: 1,
            id: 1,
            onDuty: false,
            job: 'police'
        },
        {
            name: "Matt Jenkins",
            callsign: "R-5",
            status: 1,
            id: 2,
            onDuty: false,
            job: 'police'
        },
        {
            name: "Stacy Burr",
            callsign: "D-1",
            status: 2,
            id: 3,
            onDuty: false,
            job: 'police'
        },
        {
            name: "Gary Shmorshky",
            callsign: "E-1",
            status: 0,
            id: 4,
            onDuty: false,
            job: 'ems'
        },
        {
            name: "Dave Johnson",
            callsign: "E-2",
            status: 1,
            id: 5,
            onDuty: false,
            job: 'ems'
        },
        {
            name: "Carter Dob",
            callsign: "E-3",
            status: 2,
            id: 6,
            onDuty: false,
            job: 'ems'
        },
        {
            name: "Tyler Hill",
            callsign: "E-4",
            status: 3,
            id: 7,
            onDuty: false,
            job: 'ems'
        },
        {
            name: "Owen Smith",
            callsign: "E-5",
            status: 4,
            id: 8,
            onDuty: false,
            job: 'ems'
        },
        {
            name: "Matthew Tillman",
            callsign: "E-6",
            status: 5,
            id: 9,
            onDuty: false,
            job: 'ems'
        },
        {
            name: "Richard Childs",
            callsign: "PW-1",
            status: 2,
            id: 10,
            onDuty: false,
            job: 'roadside'
        },
        {
            name: "Jeff Musk",
            callsign: "PW-2",
            status: 2,
            id: 11,
            onDuty: false,
            job: 'roadside'
        }
    ]
}