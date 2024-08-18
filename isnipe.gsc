#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_weapons;
#include maps\mp\gametypes\_gamelogic;

/**
 * iSnipe Script by @Trxyy
 * A very simple script for Sniper Only Mode
 * All weapons can be used but only snipers do damage (Intervention, Barrett and M40A3)
 * @trxyywashere on Discord !
 * https://www.youtube.com/Trxyy
 * https://github.com/TrxyyDev
 */

init() {
    level thread onPlayerConnected();
	level.playerDamageStub = level.callbackplayerdamage; // no hitmarkers
	level.callbackplayerdamage = ::Callback_PlayerDamageHook; // no hitmarkers
}

main() {}

onPlayerConnected() {
    level endon("game_ended");
    for (;;) {
        level waittill("connected", player);
		player thread onPlayerSpawned();
    }
}

refill_ammo_and_check_weapon()
{
	self endon( "disconnect" );
	sweapon = self getcurrentweapon();
	for ( ;; )
	{
		self GiveMaxAmmo(sweapon); // Refill Weapon
		wait ( 5 );
		self thread refill_ammo_and_check_weapon(); // Call again the func
		break;
	}
}

onPlayerSpawned()
{
	level endon ( "game_ended" );

	for ( ;; )
	{
		self waittill ( "spawned_player" );
		self simple_watermark(); // Show Watermark
		self thread refill_ammo_and_check_weapon();
		wait 0.1;
		self AllowMelee(false); // Disable melee
	}
}

simple_watermark()
{
	self.website = self createFontString( "Objective", 1 );
	self.website setPoint( "TOP", "CENTER", 10, -240 );
	self.website setText( "^:iSnipe Mod v1.1" ); 
	self.discord = self createFontString( "Objective", 1 );
	self.discord setPoint( "TOP", "CENTER", 10, -230 );
	self.discord setText( "^2by ^5@Trxyy" );
}

Callback_PlayerDamageHook( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex ) {
	self endon( "disconnect" );	
	
	if(string_starts_with(sweapon, "h2_cheytac_mp") || string_starts_with(sweapon, "h2_m40a3_mp") || string_starts_with(sweapon, "h2_barrett_mp"))
	{
		idamage = 1000;
		[[level.playerDamageStub]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex );
	}
	
}