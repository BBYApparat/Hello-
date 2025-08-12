import { createRouter, createWebHistory } from "vue-router";

import Login from "../views/Login.vue";

import Dashboard from "../views/Dashboard";
import Bolos from "../views/Bolos";
import Warrants from "../views/Warrants";
import Reports from "../views/Database/Reports";
import ViewReports from "../views/Database/View";
import QuickSearch from "../views/Database/Lookup";
import ShiftTracker from "../views/Activity";
import CustomTab1 from "../views/CustomTabs/CustomTab1";
import CustomTab2 from "../views/CustomTabs/CustomTab2";
import CustomTab3 from "../views/CustomTabs/CustomTab3";

const routes = [
    {
        path: "/",
        name: "Login",
        component: Login,
    },
    {
        path: "/dashboard",
        name: "Dashboard",
        component: Dashboard,
    },
    {
        path: "/bolos",
        name: "Bolos",
        component: Bolos,
    },
    {
        path: "/warrants",
        name: "Warrants",
        component: Warrants,
    },
    {
        path: "/database/create-report",
        name: "CreateReport",
        component: Reports,
    },
    {
        path: "/database/lookup",
        name: "QuickSearch",
        component: QuickSearch,
    },
    {
        path: "/database/view-report",
        name: "ViewReports",
        component: ViewReports,
    },
    {
        path: "/activity",
        name: "Activity",
        component: ShiftTracker,
    },
    {
        path: "/custom1",
        name: "CustomTab1",
        component: CustomTab1,
    },
    {
        path: "/custom2",
        name: "CustomTab2",
        component: CustomTab2,
    },
    {
        path: "/custom3",
        name: "CustomTab3",
        component: CustomTab3,
    },

    // Redirct out of non-existant pages
    {
        path: '/:catchAll(.*)',
        redirect: '/',
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
