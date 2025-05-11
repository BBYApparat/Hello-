import api from '@/api/main'

const state = {
    vehBolos: [],
    personBolos: [],
    warrants: [],
}

const getters = {
    HasActiveWarrant: (state) => (identifier) => {
        let hasWarrant = state.warrants.find(data => data.targetIdentifier == identifier)

        return hasWarrant !== undefined ? true : false
    },

    HasActiveBolo: (state) => (identifier) => {
        let hasBolo = state.personBolos.find(data => data.targetIdentifier == identifier)

        return hasBolo !== undefined ? true : false
    },

    HasActiveVehBolo: (state) => (plate) => {
        let hasBolo = state.vehBolos.find(data => data.plate === plate)

        return hasBolo !== undefined ? true : false
    },

    GetSpecificPersonBolo: (state) => (id) => {
        return state.vehBolos.find(data => data.id === id)
    },
    GetSpecificVehicleBolo: (state) => (id) => {
        return state.personBolos.find(data => data.id === id)
    },
    GetSpecificWarrant: (state) => (id) => {
        return state.warrants.find(data => data.id === id)
    },
}

const mutations = {
    AddEntry(state, payload) {
        if (payload.type == 'person') {
            state.personBolos.push(payload.data)
        } else if (payload.type == 'vehicle') {
            state.vehBolos.push(payload.data)
        } else if (payload.type == 'warrant') {
            state.warrants.push(payload.data)
        }
    },

    UpdateEntry(state, payload) {
        if (payload.type == 'person') {
            state.personBolos.forEach((val, index, arry) => {
                if (val.id == payload.data.id) {
                    arry[index] = payload.data;
                }
            });
        } else if (payload.type == 'vehicle') {
            state.personBolos.forEach((val, index, arry) => {
                if (val.id == payload.data.id) {
                    arry[index] = payload.data;
                }
            });
        } else if (payload.type == 'warrant') {
            state.warrants.forEach((val, index, arry) => {
                if (val.id == payload.data.id) {
                    arry[index] = payload.data;
                }
            });
        }
    },

    DeleteEntry(state, payload) {
        if (payload.type == 'person') {
            let entry = state.personBolos.findIndex(data => payload.id === data.id)

            state.personBolos.splice(entry, 1)
        } else if (payload.type == 'vehicle') {
            let entry = state.vehBolos.findIndex(data => payload.id === data.id)

            state.vehBolos.splice(entry, 1)
        } else if (payload.type == 'warrant') {
            let entry = state.warrants.findIndex(data => payload.id === data.id)

            state.warrants.splice(entry, 1)
        }
    },

    SetupBoloData(state, payload) {
        if (payload.data) {
            if (payload.type == 'warrants') {
                state.warrants = payload.data
            } else if (payload.type == 'vehicles') {
                state.vehBolos = payload.data
            } else if (payload.type == 'people') {
                state.personBolos = payload.data
            }
        }
    }
}

const actions = {
    // Add bolo/warrant entry
    AddPersonBolo(_, data) {
        let entry = {
            type: 'person',
            creator: data.creator,
            name: data.name,
            lastSeen: data.lastSeen,
            description: data.description,
            reason: data.reason,
            notes: data.notes,
            targetIdentifier: data.charData.identifier,
            date: Date.now(),
        }

        api.bolos.AddBolo(entry)
    },
    AddVehicleBolo(_, data) {
        let entry = {
            type: 'vehicle',
            creator: data.creator,
            model: data.model,
            plate: data.plate,
            color: data.color,
            lastSeen: data.lastSeen,
            description: data.description,
            reason: data.reason,
            notes: data.notes,
            date: Date.now(),
        }

        api.bolos.AddBolo(entry)
    },
    AddWarrant(_, data) {
        let entry = {
            type: 'warrant',
            creator: data.creator,
            name: data.name,
            lastSeen: data.lastSeen,
            description: data.description,
            reason: data.reason,
            notes: data.notes,
            targetIdentifier: data.charData.identifier,
            date: Date.now(),
        }

        api.bolos.AddBolo(entry)
    },

    // Update bolo/warrant Entry
    UpdatePersonBolo(_, data) {
        data.type = 'person'
        api.bolos.UpdateBolo(data)
    },
    UpdateVehicleBolo(_, data) {
        data.type = 'vehicle'
        api.bolos.UpdateBolo(data)
    },
    UpdateWarrant(_, data) {
        data.type = 'warrant'
        api.bolos.UpdateBolo(data)
    },

    // Delete bolo/warrant Entry
    DeletePersonBolo(_, id) {
        api.bolos.RemoveBolo({
            type: 'person',
            id: id
        })
    },
    DeleteVehicleBolo(_, id) {
        api.bolos.RemoveBolo({
            type: 'vehicle',
            id: id
        })
    },
    DeleteWarrant(_, id) {
        api.bolos.RemoveBolo({
            type: 'warrant',
            id: id
        })
    },
}

export default {
    state,
    getters,
    actions,
    mutations
}

if (process.env.NODE_ENV !== 'production') {
    state.vehBolos = [
        {
            id: 1,
            model: "2015 BMW M4 GTS Libertywalk",
            plate: "TOXIC",
            lastSeen: "East-bound vespucci blvd",
            color: "Red",
            description: "Has a black spoiler, tinted windows, black and yellow license plate, and red neon lights.",
            reason: "P.C. 1207 Federal Bank Robbery, P.C. 1505 Fleeing and Eluding, P.C. 1110 Hostage Taking",
            notes: "",
            date: "08/29/2021 4:56PM EST"
        },
        {
            id: 2,
            model: "Panto",
            plate: "GARY",
            lastSeen: "East-bound pillbox blvd",
            color: "Pink & Black",
            description: "Has black stripes, red painted rims, and a pushbar in front.",
            reason: "P.C. 1207 Federal Bank Robbery, P.C. 1505 Fleeing and Eluding",
            notes: "The owner of the vehicle is agressive and was last seen with a firearm, beware.",
            date: "08/01/2021 1:14AM EST"
        }
    ]

    state.personBolos = [
        {
            id: 1,
            name: "Jesse Katsopolis",
            lastSeen: "North-bound vespucci blvd",
            reason: "Fleeing and Eluding, attempted first degree on an LEO",
            description: "White male, blonde affro hair, red tie, gray dress vest, white suit. gray dress pants",
            notes: "",
            date: "08/17/2021 12:43AM EST"
        },
        {
            id: 2,
            name: "Evan Venter",
            lastSeen: "North-bound vespucci blvd",
            reason: "Fleeing and Eluding, Reckless Driving, hostage taking of an LEO, brandishing",
            description: "White male, black sunglasses, black baseball cap, red and white shirt.",
            notes: "C-3 performed a 10-11 on a white GTR with plate Z1LLA, Evan Venter recognized from earlier in the day from an earlier 10-11 came out from the trunk of the GTR and held C-3 at gunpoint asking for his car back near the PDM, his Karin Sultan RSV8 was unimpounded, Evan then got into the GTR and fled west on adams apple blvd where vehicle was VCB. Evan Venter was positively IDed earlier in the day through drivers license wearing the same thing that he wore during the unimpound incident. 07/16/21 C-3 M. Luxford",
            date: "08/30/2021 3:01PM EST"
        }
    ]

    state.warrants = [
        {
            id: 1,
            name: "Trevor Yokoshim",
            lastSeen: "Portola Dr",
            reason: "Fleeing and Eluding | Federal bank robbery | hostage taking of an LEO | Hostage taking | Brandishing",
            description: "White male, brown hair, brown beard, black shirt, tan white shorts",
            notes: "",
            date: "07/25/2021 3:59PM EST"
        }
    ]
}