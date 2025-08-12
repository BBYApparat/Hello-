Config = Config or {}

-- Police MDT Configuration
Config.PoliceMDT = {
    -- Jobs that can access the MDT system
    PoliceJobs = {
        'police',
        'sheriff', 
        'leo'
    },
    
    -- Key to open MDT (default F5)
    OpenKey = 'F5',
    
    -- Vehicle settings
    MaxSpeed = 2.0, -- Maximum speed (MPH) to access MDT
    EmergencyVehiclesOnly = true, -- Only emergency vehicles can access MDT
    
    -- UI Settings
    MenuAlign = 'top-left',
    
    -- Notification settings
    NotificationDuration = 5000,
    
    -- Database settings
    AutoCreateTables = true, -- Automatically create database tables on startup
    
    -- Backup settings
    BackupNotificationTypes = {
        'notification', -- ESX notification
        'chat',        -- Chat message
        -- 'dispatch'   -- Future: integrate with dispatch system
    },
    
    -- Crime types for current crimes system
    CrimeTypes = {
        'Vehicle Theft',
        'Robbery', 
        'Assault',
        'Drug Deal',
        'Burglary',
        'Murder',
        'Domestic Violence',
        'Public Disturbance',
        'Traffic Violation',
        'Weapons Violation'
    },
    
    -- Record types for police records
    RecordTypes = {
        'Arrest',
        'Citation',
        'Violation',
        'Investigation',
        'Incident Report',
        'Warning',
        'Court Order'
    },
    
    -- System messages
    Messages = {
        NoPermission = 'You must be a police officer to access the MDT',
        NotInVehicle = 'You must be in a vehicle to access the MDT',
        NotEmergencyVehicle = 'You must be in an emergency vehicle to access the MDT',
        VehicleMoving = 'Vehicle must be stationary to access the MDT',
        NotDriver = 'You must be the driver to access the MDT',
        MDTClosed = 'MDT closed - conditions no longer met',
        NoteAdded = 'Note added successfully',
        ViolationAdded = 'Violation added successfully',
        BackupCalled = 'Backup called successfully',
        CitizenNotFound = 'No citizen found with that name',
        InvalidName = 'Please enter a valid name',
        InvalidNote = 'Please enter a valid note',
        InvalidViolation = 'Please enter a valid violation'
    }
}