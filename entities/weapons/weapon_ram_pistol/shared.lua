-- Variables that are used on both client and server
SWEP.Gun = ("weapon_ram_pistol") -- must be the name of your swep but NO CAPITALS!
SWEP.Category = "R&M" --Category where you will find your weapons
SWEP.Author = "Комерад"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.PrintName = "Pistol"        -- Weapon name (Shown on HUD)
SWEP.Slot = 1                -- Slot in the weapon selection menu
SWEP.SlotPos = 1            -- Position in the slot
SWEP.DrawAmmo = true        -- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox = false        -- Should draw the weapon info box
SWEP.BounceWeaponIcon = false        -- Should the weapon icon bounce?
SWEP.DrawCrosshair = true        -- set false if you want no crosshair
SWEP.Weight = 10        -- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo = false       -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom = false        -- Auto switch from if you pick up a better weapon
SWEP.HoldType = "pistol"        -- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg makes for good sniper rifles

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_Pistol.mdl"    -- Weapon view model
SWEP.WorldModel = "models/weapons/w_Pistol.mdl"    -- Weapon world model
SWEP.ShowWorldModel = false
SWEP.Base = "komerads_gun_base" --the Base this weapon will work on. PLEASE RENAME THE BASE!
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.FiresUnderwater = true

SWEP.Primary.Sound = Sound("Weapon_Pistol.Single")        -- Script that calls the primary fire sound
SWEP.Primary.SilencedSound = Sound( "Weapon_USP.SilencedShot" )        -- Sound if the weapon is silenced
SWEP.Primary.RPM = 625            -- This is in Rounds Per Minute
SWEP.Primary.ClipSize = 15        -- Size of a clip
SWEP.Primary.DefaultClip = 30        -- Bullets you start with
SWEP.Primary.KickUp = 0.4        -- Maximum up recoil (rise)
SWEP.Primary.KickDown = 0.3        -- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal = 0.3        -- Maximum up recoil (stock)
SWEP.Primary.Automatic = false        -- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo = "pistol"            -- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. 
--Use AirboatGun for a light metal peircing shotgun pellets
SWEP.SelectiveFire = false
SWEP.CanBeSilenced = false

SWEP.Secondary.IronFOV = 70        -- How much you 'zoom' in. Less is more!

SWEP.data = {}                --The starting firemode
SWEP.data.ironsights = 1

SWEP.Primary.Damage = 12    -- Base damage per bullet
SWEP.Primary.Spread = .02    -- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-5.628, -18.493, 4.179)
SWEP.IronSightsAng = Vector(0, -1.407, 0)
SWEP.RunSightsPos = Vector(19.295, -8.643, 0)
SWEP.RunSightsAng = Vector(-4.926, 38.693, 0)

--SWEP.WElements = {
--    ["gun"] = { type = "Model", model = "models/weapons/w_pist_usp_silencer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0.323, 0), angle = Angle(-176.958, -180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
--}
