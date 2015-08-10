// CONFIG ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

AdvancedDamageLogger_WipeTime				=	300						// 	How often the server wipes the damage logs (In Seconds)
AdvancedDamageLogger_ConCommand			= "damagelog"		//	The CONSOLE command to open the damage info
AdvancedDamageLogger_ChatCommand		= "!damagelog"	//	The CHAT command to open the damage info
AdvancedDamageLogger_ForceRefresh		= true					//	Everytime logs are wiped, should all players refresh their menus? (May cause lag)
AdvancedDamageLogger_WipeButton			=	true					//	Enables button to wipe the logs
AdvancedDamageLogger_DelayRefresh		=	true					//	Enables button to delay the wiping of logs

AdvancedDamageLogger_DmgDelay				=	true					//	Does the auto wipe time delay if a player takes damage?
AdvancedDamageLogger_DmgDelayTime		=	10						//	If so, how long?

AdvancedDamageLogger_KillDelayDelay	=	true					//	Does the auto wipe time delay if a player is killed?
AdvancedDamageLogger_KillDelayTime	=	20						//	If so how long?

AdvancedDamageLogger_WipetimeCap		=	300						// 	In the event of the above delays, what will the max wipe time be?

AdvancedDamageLogger_ButtonsAdminOnly	= true				//	Are the two specialty buttons above admin only?
AdvancedDamageLogger_AdminOnly				=	true				//	Only Admins can see the damage logs
AdvancedDamageLogger_ulx							=	true				//	Does the server have ulx?


AdvancedDamageLogger_AdminRanks	=	{		//	Admin classes for ulx
	"superadmin",
	"admin",
	"Developer"
}

// CONFIG ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
