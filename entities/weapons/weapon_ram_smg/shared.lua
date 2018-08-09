-- Variables that are used on both client and server
SWEP.Gun = ("weapon_ram_smg") -- must be the name of your swep but NO CAPITALS!
SWEP.Category = "R&M" --Category where you will find your weapons
SWEP.Author = "Комерад"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.PrintName = "SMG"        -- Weapon name (Shown on HUD)
SWEP.Slot = 2                -- Slot in the weapon selection menu
SWEP.SlotPos = 1            -- Position in the slot
SWEP.DrawAmmo = true        -- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox = false        -- Should draw the weapon info box
SWEP.BounceWeaponIcon = false        -- Should the weapon icon bounce?
SWEP.DrawCrosshair = true        -- set false if you want no crosshair
SWEP.Weight = 30        -- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo = true        -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom = true        -- Auto switch from if you pick up a better weapon
SWEP.HoldType = "smg"        -- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_smg1.mdl"    -- Weapon view model
SWEP.WorldModel = "models/weapons/w_smg1.mdl"    -- Weapon world model
SWEP.ShowWorldModel = true
SWEP.Base = "komerads_gun_base" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound = Sound("Weapon_Smg1.Single")        -- Script that calls the primary fire sound
SWEP.Primary.SilencedSound = Sound("")        -- Sound if the weapon is silenced
SWEP.Primary.RPM = 650            -- This is in Rounds Per Minute
SWEP.Primary.ClipSize = 30        -- Size of a clip
SWEP.Primary.DefaultClip = 60        -- Bullets you start with
SWEP.Primary.KickUp = 0.4        -- Maximum up recoil (rise)
SWEP.Primary.KickDown = 0.3        -- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal = 0.3        -- Maximum up recoil (stock)
SWEP.Primary.Automatic = true        -- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo = "smg1"            -- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets
SWEP.SelectiveFire = true
SWEP.CanBeSilenced = false

SWEP.Secondary.IronFOV = 70        -- How much you 'zoom' in. Less is more!

SWEP.data = {}                --The starting firemode
SWEP.data.ironsights = 1

SWEP.Primary.Damage = 16    -- Base damage per bullet
SWEP.Primary.Spread = .02    -- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-6.433, -12.462, 2.519) --Iron Sight positions and angles. Use the Iron sights utility in
SWEP.IronSightsAng = Vector(0, 0, 0)    --Clavus's Swep Construction Kit to get these vectors
SWEP.RunSightsPos = Vector(3.216, 0, 4.421) --These are for the angles your viewmodel will be when running
SWEP.RunSightsAng = Vector(-20.403, 16.18, 0) --Again, use the Swep Construction Kit
