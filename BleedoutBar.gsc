#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include maps\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_hud_util;




init()
{
    level endon("end_game");
    self endon("disconnect");
    level thread onplayerconnect();
}


onplayerconnect()
{
    for(;;)
        {
            level waittill("connected", player);
            player thread onplayerspawn();
            player thread PlayerDowned();
        }
}

onplayerspawn()
{
    level endon("end_game");
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
    }
}


//First we'll create a function that will wait for the player to be downed
PlayerDowned()
{
    self endon("end_game");
    self endon("disconnect");
    
    for(;;)
    {
        self waittill("player_downed");
        self.BleedoutBar_r = true;
        self thread BleedoutBar();
        self iPrintLn("working?");
        self waittill_any("player_revived","bled_out", "death");
        
    }
}

BleedoutBar()
{
    self endon("end_game");
    self endon("disconnect");
    //Creating the bleedout bar
    self.bleedingout_bar = createPrimaryProgressBar();
    self.bleedingout_bar setPoint("CENTER", "CENTER", 0, 120);
    self.bleedingout_bar.color = (0, 0, 0);
    self.bleedingout_bar.bar.color = (1, 0, 0);
    self.bleedingout_bar.alpha = 1;
    self.bleedingout_bar.archived = 1;
    self.bleedingout_text = createFontString("small", 1);
    self.bleedingout_text setPoint("CENTER", "CENTER", 0,100);
    self thread Bleedout_revived_ornot();
    while(self.BleedoutBar_r == true)
        {
            self.bleedingout_bar updatebar(int(self.bleedout_time) / int(getdvarint("player_laststandBleedouttime")));
            self.bleedingout_text settext("Bleeding out in ^1" + int(self.bleedout_time));
            wait 0.05;
        }
}

Bleedout_revived_ornot()
{
    self endon("end_game");
    self endon("disconnect");
    self waittill_any("player_revived","bled_out", "death");
            self.BleedoutBar_r = false;
            self.bleedingout_bar destroyElem();
            self.bleedingout_text destroy();
}
