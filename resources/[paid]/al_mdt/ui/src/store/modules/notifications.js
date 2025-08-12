//import api from '@/api/main'

const state = {
    storedFeed: [],
    currentFeed: []
}

const getters = {
    DoesNotifyExist: (state) => (timeStamp) => {
        return (state.currentFeed.find(data => data.timeStamp === timeStamp) !== undefined)
    }
}

const mutations = {
    // Regular notifications
    AddNotifyEntry(state, payload) {
        state.currentFeed.push(payload)
    },

    RemoveNotifyEntry(state, payload) {
        let notifyId = state.currentFeed.findIndex(data => data.timeStamp === payload.timeStamp)

        state.currentFeed.splice(notifyId, 1)
    },

    // Tracked/Important notifications
    StoreNotifyEntry(state, payload) {
        let notifyId = state.currentFeed.findIndex(data => data.timeStamp === payload.timeStamp)

        state.storedFeed.push(state.currentFeed[notifyId])
        state.currentFeed.splice(notifyId, 1)
    },

    RemoveStoredNotifyEntry(state, payload) {
        let notifyId = state.storedFeed.findIndex(data => data.timeStamp === payload.timeStamp)

        state.storedFeed.splice(notifyId, 1)
    },

    ClearStoredNotifications(state) {
        state.storedFeed = [];
    },
}

const actions = {
    AddNotification({ commit, getters }, data) {
        commit('AddNotifyEntry', {
            timeStamp: data.timeStamp,
            title: data.title,
            msg: data.msg,
            duration: data.duration,
            type: data.type,
            tracked: data.tracked,
            useSound: data.useSound
        })

        setTimeout(() => {
            if (getters.DoesNotifyExist(data.timeStamp)) {
                if (data.tracked) {
                    commit('StoreNotifyEntry', { timeStamp: data.timeStamp })
                } else {
                    commit('RemoveNotifyEntry', { timeStamp: data.timeStamp })
                }
            }
        }, data.duration + 200) // Add 200 for animation delay
    },
    RemoveStoredNotification({ commit }, data) {
        commit('RemoveNotifyEntry', {
            timeStamp: data,
        })
    },
}

export default {
    state,
    getters,
    actions,
    mutations
}