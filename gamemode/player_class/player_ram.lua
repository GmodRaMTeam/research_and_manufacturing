---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Комерад.
--- DateTime: 5/27/2018 1:59 PM
---


AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

--if ( CLIENT ) then
--
--	CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
--	CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
--	CreateConVar( "cl_playerskin", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" )
--	CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )
--
--end

local PLAYER = {}

--
----
---- Creates a Taunt Camera
----
PLAYER.TauntCam = TauntCamera()
--
----
---- See gamemodes/base/player_class/player_default.lua for all overridable variables
----
--PLAYER.WalkSpeed 			= 200
--PLAYER.RunSpeed				= 400

PLAYER.WalkSpeed			= 200		-- How fast to move when not running
PLAYER.RunSpeed				= 400		-- How fast to move when running
PLAYER.CrouchedWalkSpeed	= 0.3		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 200		-- How powerful our jump should be
PLAYER.CanUseFlashlight		= true		-- Can we use the flashlight
--PLAYER.MaxHealth			= 100		-- Max health we can have
--PLAYER.StartHealth			= 100		-- How much health we start with
--PLAYER.StartArmor			= 0			-- How much armour we start with
--PLAYER.MaxArmor				= 100
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= true		-- Automatically swerves around other players
PLAYER.UseVMHands			= false		-- Uses viewmodel hands

--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

	self.Player:NetworkVar( 'Bool', 21, 'HasScientist')
	self.Player:SetHasScientist(false)

end


function PLAYER:Loadout()
	self.Player:RemoveAllAmmo()

	-- If we're on one of the two teams we made...
	if self.Player:Team() == TEAM_BLUE or self.Player:Team() == TEAM_ORANGE then
		local ResearchManager = team.GetAllTeams()[self.Player:Team()].ResearchManager
		if ResearchManager.categories['armor']:has_at_least_one_tech() then
			local tech = ResearchManager.categories['armor']:get_highest_tech_researched()
			if tech then
				self.Player.MaxArmor = tech.tier * 20
--				self.Player.StartArmor = tech.tier * 20
				self.Player:SetArmor(self.Player.MaxArmor)
			end
		else
			self.Player.MaxArmor = 0
--			self.StartArmor = 0
			self.Player:SetArmor(0)
		end

		if ResearchManager.categories['health']:has_at_least_one_tech() then
			local tech = ResearchManager.categories['health']:get_highest_tech_researched()
			if tech then
				self.Player.MaxHealth = 100 + (tech.tier * 10)
--				self.StartHealth = 100 +  (tech.tier * 20)
				self.Player:SetHealth(self.Player.MaxHealth)
			end
		else
			self.Player.MaxHealth = 100
--			self.StartHealth = 100
			self.Player:SetHealth(100)
		end

		if ResearchManager.categories['weapons'].techs['shotgun'].researched then
			self.Player:Give( "weapon_ram_shotgun" )
		end
		if ResearchManager.categories['weapons'].techs['revolver'].researched then
			self.Player:Give( "weapon_ram_revolver" )
		end
		if ResearchManager.categories['weapons'].techs['smg'].researched then
			self.Player:Give( "weapon_ram_smg" )
		end
		if ResearchManager.categories['weapons'].techs['ar'].researched then
			self.Player:Give( "weapon_ram_ar2" )
		end
		if ResearchManager.categories['weapons'].techs['crossbow'].researched then
			self.Player:Give( "weapon_crossbow" )
		end
		if ResearchManager.categories['weapons'].techs['rpg'].researched then
			self.Player:Give( "weapon_rpg" )
		end
		if ResearchManager.categories['weapons'].techs['gauss'].researched then
			self.Player:Give( "weapon_ram_gauss" )
		end
		if ResearchManager.categories['weapons'].techs['egon'].researched then
			self.Player:Give( "weapon_ram_egon" )
		end

		if ResearchManager.categories['gadgets'].techs['satchel'].researched then
			self.Player:Give( "weapon_ram_satchel" )
		end
		if ResearchManager.categories['gadgets'].techs['grenade'].researched then
			self.Player:Give( "weapon_frag" )
		end
		if ResearchManager.categories['gadgets'].techs['tripmine'].researched then
			self.Player:Give( "weapon_ram_tripmine" )
		end

		if ResearchManager.categories['implants'].techs['legs_one'].researched and not ResearchManager.categories['implants'].techs['legs_two'].researched then
			self.Player:SetRunSpeed( 325 )
			self.Player:SetWalkSpeed( 225 )
		elseif ResearchManager.categories['implants'].techs['legs_two'].researched then
			self.Player:SetRunSpeed( 350 )
			self.Player:SetWalkSpeed( 250 )
		else
			self.Player:SetRunSpeed( 300 )
			self.Player:SetWalkSpeed( 200 )
		end

	end
	self.Player:Give( "weapon_crowbar" )
	self.Player:Give( "weapon_stunstick" ) -- Capture scientist tool
	self.Player:Give( "weapon_ram_pistol" )
	self.Player:GiveAmmo( 60,	"Pistol", 		true )

	self.Player:SwitchToDefaultWeapon()

end

function PLAYER:SetModel()

	BaseClass.SetModel( self )

	--local skin = self.Player:GetInfoNum( "cl_playerskin", 0 )
	--self.Player:SetSkin( skin )
    --
	--local groups = self.Player:GetInfo( "cl_playerbodygroups" )
	--if ( groups == nil ) then groups = "" end
	--local groups = string.Explode( " ", groups )
	--for k = 0, self.Player:GetNumBodyGroups() - 1 do
	--	self.Player:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
	--end

end

--
-- Called when the player spawns
--
function PLAYER:Spawn()

	BaseClass.Spawn( self )

end


--
-- Called when the player spawns
--
function PLAYER:Death()

	BaseClass.Death( self )
	local TeamInfo = team.GetAllTeams()[self.Player:Team()]
	TeamInfo.Money = TeamInfo.Money - 1000

end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal()

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end

function PLAYER:GetHandsModel()

	-- return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }

	local cl_playermodel = self.Player:GetInfo( "cl_playermodel" )
	return player_manager.TranslatePlayerHands( cl_playermodel )

end

--
-- Reproduces the jump boost from HL2 singleplayer
--
local JUMPING

function PLAYER:StartMove( move )

	-- Only apply the jump boost in FinishMove if the player has jumped during this frame
	-- Using a global variable is safe here because nothing else happens between SetupMove and FinishMove
	if bit.band( move:GetButtons(), IN_JUMP ) ~= 0 and bit.band( move:GetOldButtons(), IN_JUMP ) == 0 and self.Player:OnGround() then
		JUMPING = true
	end

end

function PLAYER:FinishMove( move )

	-- If the player has jumped this frame
	if JUMPING then
		-- Get their orientation
		local forward = move:GetAngles()
		forward.p = 0
		forward = forward:Forward()

		-- Compute the speed boost

		-- HL2 normally provides a much weaker jump boost when sprinting
		-- For some reason this never applied to GMod, so we won't perform
		-- this check here to preserve the "authentic" feeling
		local speedBoostPerc = ( ( not self.Player:Crouching() ) and 0.5 ) or 0.1

		local speedAddition = math.abs( move:GetForwardSpeed() * speedBoostPerc )
		local maxSpeed = move:GetMaxSpeed() * ( 1 + speedBoostPerc )
		local newSpeed = speedAddition + move:GetVelocity():Length2D()

		-- Clamp it to make sure they can't bunnyhop to ludicrous speed
		if newSpeed > maxSpeed then
			speedAddition = speedAddition - (newSpeed - maxSpeed)
		end

		-- Reverse it if the player is running backwards
		if move:GetVelocity():Dot(forward) < 0 then
			speedAddition = -speedAddition
		end

		-- Apply the speed boost
		move:SetVelocity(forward * speedAddition + move:GetVelocity())
	end

	JUMPING = nil

end

player_manager.RegisterClass( "player_ram", PLAYER, "player_default" )
