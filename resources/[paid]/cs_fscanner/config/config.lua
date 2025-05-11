CodeStudio = {}

CodeStudio.Wait_TIme = 2    --Scaning Waiting Time in seconds

CodeStudio.Animations = {
    Enable = true,
    Scanner_Prop = `prop_police_phone`,
    Use_Anim = 'idle_f',
    Use_Dict = 'random@hitch_lift'
}

CodeStudio.Enable_Fingerprint_ID = true     --Enable/Disable Fingerprint ID in scanner
CodeStudio.DicordLogs = false  -- if Enabled put webhook in open.lua

----Notifications Customization----

function Notify(msg)
    lib.notify({
        title = 'Finger Scanner',
        description = msg
    })
end

----Language Editor----

CodeStudio.Language = {
    welcome_txt = 'WELCOME',
    department_txt = 'Fingerprint Scanner Department',
    tester_share = 'Fingerprint scan transferred. Awaiting confirmation...',
    new_scan = 'New Scan',
    view_history = 'History',
    history_head = 'History',
    view_btn = 'View',
    report_head = 'Report',
    scaning_txt = 'Please put your finger on the scanner',
    male_txt = 'Male',
    female_txt = 'Female'
}