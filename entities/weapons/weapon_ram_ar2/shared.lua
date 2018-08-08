-- Variables that are used on both client and server
SWEP.Gun = ("weapon_ram_ar2") -- must be the name of your swep but NO CAPITALS!
SWEP.Category = "R&M" --Category where you will find your weapons
SWEP.Author = "Комерад"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.PrintName = "Ar2"        -- Weapon name (Shown on HUD)
SWEP.Slot = 2                -- Slot in the weapon selection menu
SWEP.SlotPos = 2            -- Position in the slot
SWEP.DrawAmmo = true        -- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox = false        -- Should draw the weapon info box
SWEP.BounceWeaponIcon = false        -- Should the weapon icon bounce?
SWEP.DrawCrosshair = true        -- set false if you want no crosshair
SWEP.Weight = 30        -- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo = true        -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom = true        -- Auto switch from if you pick up a better weapon
SWEP.HoldType = "ar2"        -- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"    -- Weapon view model
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"    -- Weapon world model
SWEP.ShowWorldModel = true
SWEP.Base = "komerads_gun_base" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound = Sound("Weapon_Ar2.Single")        -- Script that calls the primary fire sound
SWEP.Primary.SilencedSound = Sound("")        -- Sound if the weapon is silenced
SWEP.Primary.RPM = 900            -- This is in Rounds Per Minute
SWEP.Primary.ClipSize = 30        -- Size of a clip
SWEP.Primary.DefaultClip = 60        -- Bullets you start with
SWEP.Primary.KickUp = 0.4        -- Maximum up recoil (rise)
SWEP.Primary.KickDown = 0.3        -- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal = 0.3        -- Maximum up recoil (stock)
SWEP.Primary.Automatic = true        -- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo = "ar2"            -- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets
SWEP.SelectiveFire = true
SWEP.CanBeSilenced = false

SWEP.Secondary.IronFOV = 70       -- How much you 'zoom' in. Less is more!

SWEP.data = {}                --The starting firemode
SWEP.data.ironsights = 1

SWEP.Primary.Damage = 13    -- Base damage per bullet
SWEP.Primary.Spread = .02    -- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
--SWEP.IronSightsPos = Vector(0, 0, 0)    --Iron Sight positions and angles. Use the Iron sights utility in
--SWEP.IronSightsAng = Vector(0, 0, 0)    --Clavus's Swep Construction Kit to get these vectors
SWEP.IronSightsPos = Vector(-5.829, -10.051, 2.21)
SWEP.IronSightsAng = Vector(0.703, -0.35, 0)
SWEP.RunSightsPos = Vector(9.446, 0, -0.16) --These are for the angles your viewmodel will be when running
SWEP.RunSightsAng = Vector(-7.739, 27.437, 0) --Again, use the Swep Construction Kit
