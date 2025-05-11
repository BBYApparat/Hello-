Hi,
thank you for your purchase.
Please don't release my work any longer.

--------------------------------------------------
My contact: 
Cfx forum:			 https://forum.cfx.re/u/bzzzi/summary
Tebex:				 https://bzzz.tebex.io/
Discord:			  /PpAHBCMW97
--------------------------------------------------



Installation:
1) Insert folder "bzzz_pizzapack" to resources folder
2) Add to server.cfg
3) Restart server



If you stream props in another resource, you must edit the fxmanifest.
Add this line:
data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_foodpack_pizzapack.ytyp'

Then the server must be restarted. 
YTYP loads properties of props.
Flag of the prop is set to 32 (static). You can change the properties in the YTYP.




--------------------------------------------------
Props can be used with animations in your script or in your MLO.
You can customize a props as needed.
The props are not locked. If OpenIV says the props are locked, you can unlock them.
GTA animation list: https://alexguirre.github.io/animations-list/


--------------------------------------------------
Template code for eating a pizza:



["pizza01"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Eat Pizza", AnimationOptions =
   {
       Prop = 'bzzz_foodpack_pizza_marinara002',
       PropBone = 18905,
       PropPlacement = {0.16, 0.04, 0.02, -33.0, -245.0, -161.0},
       EmoteMoving = true,
   }},

--------------------------------------------------

["pizza_peel"] = {"timetable@lamar@ig_2", "grill_protien_like_clockwork_lamar", "Pizza", AnimationOptions =
    {
        Prop = "bzzz_foodpack_pizza_peel002",
        PropBone = 57005,
        PropPlacement = {0.22, 0.17, -0.02, 132.0, 93.0, 2.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},