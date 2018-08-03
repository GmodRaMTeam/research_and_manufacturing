include('shared.lua')

language.Add("weapon_gauss", "Gauss Cannon")

SWEP.PrintName = "Gauss Cannon"
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false

SWEP.WepSelectIcon = surface.GetTextureID("HUD/weapons/weapon_gauss") 
SWEP.BounceWeaponIcon = false 

function SWEP:HUDShouldDraw(element)
	if self.bInAttack and element == "CHudWeaponSelection" then return false end
	return true
end