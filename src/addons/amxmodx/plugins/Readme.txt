/***************************************************************************
* Advanced Team Attack Control [ATAC] AMX Plugin for use with Counter-Strike 1.5 and 1.6
* First Release Date: Apr 2002
* Written/Developed by: F117Bomb & [DsV]T(+)rget
* Special Thanks to: PsychoGuard and OLO.
* Contact: TheJew@socal.rr.com or target@dreamscapevirus.com
* Lines of Code: 1000+ 
* FOR ADDITIONAL HELP THE FORUMS ARE HERE: http://www.amxmodx.org/forums/
* Source: http://www.snowboardingandstuff.com/
*
* SAY COMMANDS:
*	/tastatus - Shows how many TEAM ATTACK Warnings you have.
*	/tkstatus - Show how many Team Kill Violations you have.
*	/whotkedme - Shows all players that have TKed you.
*
* EXPLANATION:
*	TK CONTROL:
*		1. When a player gets TKed menu comes up and displays his revenge options. 
*		2. Unless forgiven the Killers Team Kill Count Increases by one.
*	TA CONTROL:
*		1. If player TA's within 'taNotAllowedFor' secs of new round his is slayed.
*		2. If player TA's after 'taNotAllowedFor' his TA count is increase by one. 
*		3. When player has reached the max. allowable TA's for a specific round his  
*		   Team Kill Count Increase by one and if SlayOnMaxTAs is on 
*		   then the player is slayed.  
*	TEAM ATTACK VIOLATION:
*		1. When a play has reached the max Team Kill Violations he is banned for 
*		   'banTime' min. 
*
* REQUIRED: 
*	AMXX MOD - http://www.amxmodx.org/
*
***************************************************************************/ 

Installation instructions:

	1. Upload 'amx_atac.amxx' and 'amx_atac_cfg.amxx' to cstrike/addons/amxmodx/plugins
	2. Edit plugins.ini and add the plugin 'amx_atac.amxx' and 'amx_atac_cfg.amxx'
	3. Upload the atac directory and all its contents to cstrike/addons/amxmodx/configs/
	4. REMOVE ALL OTHER TK's SCRIPTS THAT ARE RUNNING ON YOUR SERVER 
	5. Make sure the AMXX FUN module is installed 
	6. Restart your server and play!
	
	
Optional:
	
	- Install Chicken Mod for chicken option to work 
	
	- Edit 'atac/atac.cfg', read and edit the variables to customize it 
	  they way you want it.  

	- These should be set to the following values in your server.cfg file:
		mp_tkpunish 0 
		mp_autokick 0
		mp_friendlyfire 1 

Things to know:

	- To list banned by id/ip use rcon command  'listid' / 'listip' respectively   
	- To remove a ban id/ip use rcon command 'removeid' / 'removeip' respectively  
	- All atac.cfg settings can be changed in-game via 'amx_rcon'
	- Use /say atacmenu for on the fly ATAC config (requires you install amx_atac_cfg.amxx)  
	
Dir Tree:
	
	.../cstrike/addons/amxmodx/configs/plugins.ini
	.../cstrike/addons/amxmodx/configs/atac/atac.cfg
	.../cstrike/addons/amxmodx/configs/atac/atac.cor
	.../cstrike/addons/amxmodx/configs/atac/atacban.log
	.../cstrike/addons/amxmodx/plugins/amx_atac.amxx
	.../cstrike/addons/amxmodx/plugins/amx_atac_config.amxx

	