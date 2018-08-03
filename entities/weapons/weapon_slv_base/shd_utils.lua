--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/2/2018
-- Time: 8:11 PM
-- To change this template use File | Settings | File Templates.
--

--local meta = FindMetaTable("Player")

function util.GetCustomAmmoTypes()
	return tblCustomAmmo
end

function util.GetAmmoName(ammo)
	if tblCustomAmmo[ammo] then return tblCustomAmmo[ammo] end
	if ammo == "Buckshot" then return "Shotgun Ammo"
	elseif ammo == "RPG_Round" then return "RPG Round"
	elseif ammo == "XBowBolt" then return "Crossbow Bolts"
	elseif ammo == "SniperRound" or ammo == "SniperPenetratedRound" then return "Sniper Round"
	elseif ammo == "GaussEnergy" then return "Gauss Energy"
	elseif ammo == "Grenade" then return "Grenades"
	elseif ammo == "SMG1_Grenade" then return "SMG Grenades"
	elseif ammo == "AR2AltFire" then return "Combine's Balls"
	elseif ammo == "slam" then return "SLAM Ammo"
	else return ammo .. " Ammo" end
end

local tblAmmoDefault = {
	"ar2",
	"alyxgun",
	"pistol",
	"smg1",
	"357",
	"xbowbolt",
	"buckshot",
	"rpg_round",
	"smg1_grenade",
	"sniperround",
	"sniperpenetratedround",
	"grenade",
	"thumper",
	"gravity",
	"battery",
	"gaussenergy",
	"combinecannon",
	"airboatgun",
	"striderminigun",
	"helicoptergun",
	"ar2altfire",
	"slam"
}

function util.IsDefaultAmmoType(ammo)
	return table.HasValue(tblAmmoDefault, string.lower(ammo))
end
