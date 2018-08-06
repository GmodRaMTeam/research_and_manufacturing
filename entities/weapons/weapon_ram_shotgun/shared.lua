-- Variables that are used on both client and server
SWEP.Gun = ("weapon_ram_shotgun") -- must be the name of your swep
SWEP.Category = "R&M" --Category where you will find your weapons
SWEP.Author = "Комерад"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.PrintName = "Shotgun"        -- Weapon name (Shown on HUD)
SWEP.Slot = 3                -- Slot in the weapon selection menu
SWEP.SlotPos = 1            -- Position in the slot
SWEP.DrawAmmo = true        -- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox = false        -- Should draw the weapon info box
SWEP.BounceWeaponIcon = false    -- Should the weapon icon bounce?
SWEP.DrawCrosshair = true        -- set false if you want no crosshair
SWEP.Weight = 30            -- rank relative to other weapons. bigger is better
SWEP.AutoSwitchTo = true        -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom = true        -- Auto switch from if you pick up a better weapon
SWEP.HoldType = "shotgun"

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_Shotgun.mdl"    -- Weapon view model
SWEP.WorldModel = "models/weapons/w_Shotgun.mdl"    -- Weapon world model
SWEP.Base = "komerads_shotty_base" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Sound = Sound("Weapon_Shotgun.Single")         -- script that calls the primary fire sound
SWEP.Primary.RPM = 150        -- This is in Rounds Per Minute
SWEP.Primary.ClipSize = 8            -- Size of a clip
SWEP.Primary.DefaultClip = 30    -- Default number of bullets in a clip
SWEP.Primary.KickUp = 5                -- Maximum up recoil (rise)
SWEP.Primary.KickDown = 0.8        -- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal = 1    -- Maximum up recoil (stock)
SWEP.Primary.Automatic = false        -- Automatic/Semi Auto
SWEP.Primary.Ammo = "buckshot"

SWEP.Secondary.IronFOV = 70        -- How much you 'zoom' in. Less is more!

SWEP.ShellTime = .3

SWEP.Primary.NumShots = 9        -- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage = 5    -- Base damage per bullet
SWEP.Primary.Spread = .035    -- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .035    -- Ironsight accuracy, should be the same for shotguns
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
--SWEP.IronSightsPos = Vector(0, 0, 0)
--SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.IronSightsPos = Vector(-9, -14.674, 4.159)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.719, 0, 1.879)
SWEP.RunSightsAng = Vector(-11.256, 16.884, 0)
