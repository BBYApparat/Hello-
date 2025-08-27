-- ESX MDT Shared Configuration
Config = {}

-- Jobs that can access MDT
Config.AllowedJobs = {
    'police',
    'ambulance',
    'government'
}

-- Police department configurations
Config.PoliceDepartments = {
    {
        id = 'lspd',
        name = 'Los Santos Police Department',
        shortName = 'LSPD'
    },
    {
        id = 'bcso',
        name = 'Blaine County Sheriff Office',
        shortName = 'BCSO'
    },
    {
        id = 'sasp',
        name = 'San Andreas State Police',
        shortName = 'SASP'
    }
}

-- Database tables
Config.Tables = {
    users = 'users',
    callsigns = 'mdt_callsigns',
    reports = 'mdt_reports',
    incidents = 'mdt_incidents',
    warrants = 'mdt_warrants',
    vehicles = 'owned_vehicles',
    properties = 'properties',
    evidence = 'mdt_evidence',
    people = 'mdt_people'
}

-- Permission levels by job grade
Config.Permissions = {
    police = {
        [0] = { -- Cadet
            mdt_access = true,
            view_reports = true,
            create_reports = true,
            view_incidents = true,
            create_incidents = true,
        },
        [1] = { -- Officer  
            mdt_access = true,
            view_reports = true,
            create_reports = true,
            edit_reports = true,
            view_incidents = true,
            create_incidents = true,
            edit_incidents = true,
        },
        [2] = { -- Senior Officer
            mdt_access = true,
            view_reports = true,
            create_reports = true,
            edit_reports = true,
            view_incidents = true,
            create_incidents = true,
            edit_incidents = true,
        },
        [3] = { -- Corporal
            mdt_access = true,
            view_reports = true,
            create_reports = true,
            edit_reports = true,
            view_incidents = true,
            create_incidents = true,
            edit_incidents = true,
            manage_callsigns = true,
        },
        [4] = { -- Captain (your rank)
            mdt_access = true,
            view_reports = true,
            create_reports = true,
            edit_reports = true,
            delete_reports = true,
            view_incidents = true,
            create_incidents = true,
            edit_incidents = true,
            delete_incidents = true,
            manage_callsigns = true,
            hire_fire = true,
            promote_demote = true,
            view_all_reports = true,
            system_admin = true,
        },
        [5] = { -- Sergeant+
            mdt_access = true,
            view_reports = true,
            create_reports = true,
            edit_reports = true,
            view_incidents = true,
            create_incidents = true,
            edit_incidents = true,
            manage_callsigns = true,
            hire_fire = true,
            promote_demote = true,
            view_all_reports = true,
        },
        [10] = { -- Command Staff
            mdt_access = true,
            view_reports = true,
            create_reports = true,
            edit_reports = true,
            delete_reports = true,
            view_incidents = true,
            create_incidents = true,
            edit_incidents = true,
            delete_incidents = true,
            manage_callsigns = true,
            hire_fire = true,
            promote_demote = true,
            view_all_reports = true,
            system_admin = true,
        }
    },
    ambulance = {
        [0] = {
            mdt_access = true,
            view_reports = true,
            create_reports = true,
        },
        [5] = {
            mdt_access = true,
            view_reports = true,
            create_reports = true,
            edit_reports = true,
            manage_callsigns = true,
        }
    }
}