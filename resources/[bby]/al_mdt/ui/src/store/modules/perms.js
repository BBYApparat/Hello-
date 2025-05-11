const state = {
    permissions: {}
}

const getters = {
    HasPerm: state => (role, type, details) => {
        const rolePerm = state.permissions[role]

        if (rolePerm !== undefined) {
            if ((type === 'changeStatus' || type === 'copyStatus' || type === 'gps') && details !== undefined) {
                if (rolePerm.units[details]) {
                    return rolePerm.units[details][type]
                }
            } else if (type === 'units' && details !== undefined) {
                if (rolePerm.units[details]) {
                    return rolePerm.units[details]
                }
            } else if (type === 'dbSearch') {
                return rolePerm.database.search
            } else if (type === 'createReport') {
                return rolePerm.database.createReport
            } else if (type === 'viewReport') {
                return rolePerm.database.viewReport
            } else if (type === 'customTab1') {
                return rolePerm.customTabs.tab1
            } else if (type === 'customTab2') {
                return rolePerm.customTabs.tab2
            } else if (type === 'customTab3') {
                return rolePerm.customTabs.tab3
            } else if (type === 'clockin') {
                return rolePerm.clockin
            } else if (type === 'activity') {
                return rolePerm.activity
            } else if (type === 'reports' && details !== undefined) {
                if (rolePerm.reports[details]) {
                    return rolePerm.reports[details]
                }
            } else if (type === 'civProfile' && details !== undefined) {
                if (rolePerm.profiles.civ[details]) {
                    return rolePerm.profiles.civ[details]
                }
            } else if (type === 'vehProfile' && details !== undefined) {
                if (rolePerm.profiles.veh[details]) {
                    return rolePerm.profiles.veh[details]
                }
            } else if (type === 'bolos' && details !== undefined) {
                if (rolePerm.bolos[details]) {
                    return rolePerm.bolos[details]
                }
            } else if (type === 'warrants' && details !== undefined) {
                if (rolePerm.warrants[details]) {
                    return rolePerm.warrants[details]
                }
            }
        }
        return false
    },
}

const mutations = {
    SetPermissions(state, payload) {
        state.permissions = payload
    },
}

export default {
    state,
    getters,
    mutations
}