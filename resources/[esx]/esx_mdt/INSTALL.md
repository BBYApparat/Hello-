# ESX MDT Installation Guide

## Quick Installation

### 1. **Copy Files**
Place the entire `esx_mdt` folder in your `[esx]` resources directory:
```
F:\YourServer\resources\[esx]\esx_mdt\
```

### 2. **Add to Server Config**
Add this line to your `server.cfg`:
```cfg
ensure esx_mdt
```

### 3. **Restart Server**
Restart your server. The database tables will be created automatically.

### 4. **Test Installation**
1. Give yourself a police job: `/job police`
2. Press **F5** or type `/mdt` to open the MDT
3. Test callsign assignment: `/setcallsign 1 Adam-12`

## Troubleshooting

### UI Not Loading
If the MDT interface doesn't appear:

1. **Check files are present:**
   - `ui/dist/index.html` ✓
   - `ui/dist/main.js` ✓

2. **Check fxmanifest.lua includes:**
   ```lua
   ui_page 'ui/dist/index.html'
   files {
       'ui/dist/index.html',
       'ui/dist/*.js'
   }
   ```

3. **Check browser console (F12)** for JavaScript errors

### Database Issues
If commands aren't working:
1. Check MySQL connection is working
2. Verify `oxmysql` resource is running
3. Check server console for SQL errors

### Permission Issues
If you can't access MDT:
1. Make sure you have a police/EMS/government job
2. Check `shared/shared.lua` for allowed jobs:
   ```lua
   Config.AllowedJobs = {
       'police',
       'ambulance',
       'government'
   }
   ```

## File Verification

**Essential Files:**
```
esx_mdt/
├── fxmanifest.lua        ✓ Required
├── shared/shared.lua     ✓ Required  
├── server/main.lua       ✓ Required
├── server/commands.lua   ✓ Required
├── server/callbacks.lua  ✓ Required
├── client/main.lua       ✓ Required
└── ui/
    ├── dist/
    │   ├── index.html    ✓ Critical - UI won't work without this
    │   └── main.js       ✓ Critical - UI won't work without this
    └── src/              ✓ Source files (for development)
```

## Success Indicators

**✅ Installation Successful When:**
- Server starts without errors
- MDT opens with F5 key
- Commands work: `/setcallsign`, `/mdt`
- Database tables created (check your MySQL)

**❌ Installation Failed When:**
- "You do not have access to MDT" message
- F5 key does nothing
- Black screen when opening MDT
- SQL/Database errors in console

Need help? Check the README.md for detailed documentation.