Mobile Data Terminal (MDT - ESX and QBCore) | Aljunier

[Installation]
1. Execute the .sql file in the SQL folder.

2. Review the entirety of the config folder to ensure that everything is to your likings. And I highly recommend reviewing the framework.lua files on both the client and server...
...to ensure that everything is set to your preferences. This will be necessary for certain features such as automatically jailing a player (See server framework.lua for this)

3. I recommend checking the accessible files (list given below), especially the server sided files, to ensure that everything will work for your server.
Generally, the code already there should work for your needs -- assuming you're using ESX or QBCore

3. Add 'ensure al_mdt' to your server.cfg

[Accessible files]
ALL files are now accessible EXCEPT for 'server/key.lua' for security reasons to prevent unfavorable players to tamper with MDT data and core functionality

[Report a bug]
If you encounter a bug/issue with the resource, feel free to join the official discord and submit a ticket! (https://discord.gg/KqrCtxd7NY).
UPDATE 1/29/23 - Due to unforeseen circumstances, support will see an indefinite pause. Because of this change, you now have access to "all" files.

[Exports]
(Client) - exports['al_mdt']:TriggerPanicButton()

[Notes]
This resource is targeted toward ESX or QBCore servers. However, with enough effort, it is possible to get this to work with
other frameworks as long as you are willing to change the necessary db queries - I won't be giving support for this though.