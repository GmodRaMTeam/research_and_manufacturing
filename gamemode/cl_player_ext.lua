--
-- Created by IntelliJ IDEA.
-- User: Tyler
-- Date: 8/2/2018
-- Time: 8:24 PM
-- To change this template use File | Settings | File Templates.
--

local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

local tblAmmoCount = {}

usermessage.Hook("SLV_SetAmmunition", function(um)
	local ammo = um:ReadString()
	if not ammo then return end
	local amount = um:ReadShort()
	if not amount then return end
	tblAmmoCount[ammo] = amount
end)
local tblAmmoTypeNames = {
	[1] = "ar2",
	[2] = "ar2altfire",
	[3] = "pistol",
	[4] = "smg1",
	[5] = "357",
	[6] = "xbowbolt",
	[7] = "buckshot",
	[8] = "rpg_round",
	[9] = "smg1_grenade",
	[10] = "grenade",
	[11] = "slam",
	[12] = "alyxgun",
	[13] = "sniperround",
	[14] = "sniperpenetratedround",
	[15] = "thumper",
	[16] = "gravity",
	[17] = "battery",
	[18] = "gaussenergy",
	[19] = "combinecannon",
	[20] = "airboatgun",
	[21] = "striderminigun",
	[22] = "helicoptergun"
}
local function ToAmmoName(i)
	return tblAmmoTypeNames[i] or ""
end

function plymeta:GetAmmunition(ammo)
	if type(ammo) == "number" then ammo = ToAmmoName(ammo) end
	if util.IsDefaultAmmoType(ammo) then return self:GetAmmoCount(ammo) end
	return tblAmmoCount[ammo] or 0
end
