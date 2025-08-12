const state = {
    General: {
        Title: '',
        JailButton: false,
        JailReason: false,
        JailButtonActiveDefault: false,
    },

    incidentResultTypes: [],

    CustomTabs: [],

    Jobs: [],

    LicenseLabels: {},

    GrantableLicenses: {},

    CriminalCode: {},

    Keybinds: [],

    Language: {},
    LanguageInitiated: false,
}

const getters = {
    GetJobReplacement: state => (job) => {
        let resp = state.Jobs.find((data) => data.job === job)
        return resp !== undefined && resp.type ? resp.type : job
    },

    GetTranslation: (state) => (category, key) => {
        if (state.Language[category] && state.Language[category][key]) {
            return state.Language[category][key]
        } else {
            return `No translation for [${category}:${key}]`
        }

    },
}

const mutations = {
    SetLanguage(state, payload) {
        state.Language = payload
        state.LanguageInitiated = true
    },

    SetConfig(state, payload) {
        state.General.Title = payload.General.Title
        state.General.JailButton = payload.General.JailButton
        state.General.JailButtonActiveDefault = payload.General.JailButtonActiveDefault
        state.General.JailReason = payload.General.JailReason
        state.incidentResultTypes = payload.incidentResultTypes
        state.CustomTabs = payload.CustomTabs
        state.Jobs = payload.Jobs
        state.LicenseLabels = payload.LicenseLabels
        state.GrantableLicenses = payload.GrantableLicenses
        state.CriminalCode = payload.CriminalCode
        state.Keybinds = payload.Keybinds
    },
}

export default {
    state,
    getters,
    mutations
}