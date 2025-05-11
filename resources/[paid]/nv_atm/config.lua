config = {}


--=========== Framework ===========--
-- ESX - ESX Framework
-- QB - QBCore Frameowk
config.framework = "ESX"
--=================================--

--=========== Targets ===========--
config.ox_target = true -- If you want to turn on, set this to -> true
config.ox_target_name = "Open ATM"
config.ox_target_color = "red"


-- THIS "Sleep Interaction" IS IN DEVELOPMENT
config.sleeplessInteraction = false -- If you want to turn on, set this to -> true
config.sleeplessInteraction_name = "Open ATM"
-- THIS "Sleep Interaction" IS IN DEVELOPMENT



config.qb_target = false -- If you want to turn on, set this to -> true
config.qb_target_name = "Open ATM"
--===============================--

--=========== Notification ===========--
config.notifyName = "Fleeca Bank"
config.notifyDesc = "ATM Machine"
config.notifyIcon = "CHAR_BANK_FLEECA" -- Find more at https://wiki.rage.mp/index.php?title=Notification_Pictures
config.enableNotification = false
--====================================--

config.atmModels = {"prop_atm_01","prop_atm_02","prop_atm_03","prop_fleeca_atm"}

config.msg_deposit1 = "You don't have enough money."
config.msg_deposit2 = {"You are successfully deposit $","to bank."}

config.msg_withdraw1 = "You don't have enough money."
config.msg_withdraw2 = {"You are successfully withdraw $","from bank."}

config.atm_lang = {
	welcome_title = "Welcome to",
	title="FL<b>EE</b>CA BANK",
	insert_card="Insert a card",

	balance="Balance",
	withdraw="Withdrawal",
	deposit="Deposit",
	exit="Exit",
	back="Back",
	custom_input="Custom Input",
	msg_balance="Your Balance",
	
	msg_deposit="How much money you want to deposit?",
	msg_withdraw="How much money you want to withdraw?",

	msg_thanks = "Thanks for using our services",
	msg_soon = "See you soon!"

}