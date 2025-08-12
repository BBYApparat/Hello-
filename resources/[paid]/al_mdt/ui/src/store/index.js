import { createStore } from 'vuex'

import generalModule from './modules/general'
import notificationsModule from './modules/notifications'
import settingsModule from './modules/settings'
import configModule from './modules/config'
import permsModule from './modules/perms'

import usersModule from './modules/users'
import boloModule from './modules/bolos'
import finesModule from './modules/fines'

export default createStore({
    modules: {
        general: generalModule,
        notifications: notificationsModule,
        settings: settingsModule,
        config: configModule,
        perms: permsModule,

        users: usersModule,
        bolos: boloModule,
        fines: finesModule,
    }
});

/*
if (process.env.NODE_ENV !== 'production') {

}
*/