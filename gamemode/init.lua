---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Комерад.
--- DateTime: 5/22/2018 10:15 PM
---

DEFINE_BASECLASS( "gamemode_base" )

util.AddNetworkString("RAM_dynamic_notification")
util.AddNetworkString("RAM_show_help")
util.AddNetworkString("RAM_status_update")
util.AddNetworkString("RAM_print_to_team")
util.AddNetworkString("RAM_technology_update")
util.AddNetworkString("RAM_sync_map_timer")
util.AddNetworkString("RAM_sync_prep_timer")
util.AddNetworkString("RAM_sync_status")
util.AddNetworkString("RAM_make_money")
util.AddNetworkString("RAM_scientist_update")
util.AddNetworkString("RAM_sync_research_timer")

util.AddNetworkString("RAMCL_request_technology_update")
util.AddNetworkString("RAMCL_record_research_vote")
util.AddNetworkString("RAMCL_request_sync_map_timer")
util.AddNetworkString("RAMCL_request_sync_prep_timer")
util.AddNetworkString("RAMCL_request_sync_status")
util.AddNetworkString("RAMCL_request_entire_research_table")
util.AddNetworkString("RAMCL_request_scientist_sync")
util.AddNetworkString("RAMCL_request_sync_research_timer")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hooks.lua")
AddCSLuaFile("cl_net.lua")
AddCSLuaFile("vgui/cl_hud.lua")
AddCSLuaFile("vgui/cl_pickteam.lua")
AddCSLuaFile("vgui/cl_research_menu.lua")
AddCSLuaFile("vgui/cl_scoreboard.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("shd_hooks.lua")
AddCSLuaFile("shd_player_ext.lua")
AddCSLuaFile("cl_research_manager.lua")
AddCSLuaFile("cl_research_category.lua")
AddCSLuaFile("cl_research_technology.lua")
AddCSLuaFile("shd_utils.lua")
AddCSLuaFile("cl_utils.lua")
AddCSLuaFile("cl_player_ext.lua")

include("shared.lua")
include("sv_net.lua")
include("sv_hooks.lua")
include("sv_player.lua")
include("sv_player_ext.lua")
include("sv_entity_ext.lua")
include("sv_physobj_ext.lua")
include("shd_komerad_autorun.lua")
include("shd_player_ext.lua")
include("sv_research_manager.lua")
include("sv_research_category.lua")
include("sv_research_technology.lua")
include("shd_utils.lua")
include("sv_utils.lua")
include("sv_gibs.lua")
include("shd_hooks.lua")

--DEFAULT_RESEARCH_TIME = 60 -- GetConvar was not working in a specific spot...

-- Convars --
CreateConVar("ram_map_time_limit_minutes", "30", FCVAR_NOTIFY + FCVAR_REPLICATED) -- Map time limit
CreateConVar("ram_prep_time_limit_seconds", "30", FCVAR_NOTIFY + FCVAR_REPLICATED) -- Prep time
CreateConVar("ram_vote_time_limit_seconds", "30", FCVAR_NOTIFY + FCVAR_REPLICATED) -- How long you have to vote
CreateConVar("ram_player_death_cost", "250", FCVAR_NOTIFY + FCVAR_REPLICATED) -- How much money to lose on player death
CreateConVar("ram_research_time_seconds", "75", FCVAR_NOTIFY + FCVAR_REPLICATED) -- Research time in seconds. Do not go lower than 30
CreateConVar("ram_money_cycle_time_seconds", "15", FCVAR_NOTIFY + FCVAR_REPLICATED) -- How often to make money
CreateConVar("ram_player_respawn_time", "5", FCVAR_NOTIFY + FCVAR_REPLICATED) -- How often to make money

--[[All local spaced server functions]]

local function prep_end_sync_timers()
    local time_left = nil
    if timer.Exists("RAM_TimerPrepEnd") then
        time_left = timer.TimeLeft("RAM_TimerPrepEnd")
    else
        time_left = 0
    end
    net.Start("RAM_sync_prep_timer")
    net.WriteFloat(time_left)
    net.Broadcast()
end

------------------------------------------------------------------------------------------------------------


local function EndMap()
    ram_dynamic_status_update(nil, 'The map has ended!', 'warning', nil)

    timer.Simple(15, function() game.LoadNextMap() end)
end

function EndPrep()
    if timer.Exists("RAM_TimerPrepEnd") then
        timer.Remove("RAM_TimerPrepEnd")
        prep_end_sync_timers()
        ram_dynamic_status_update(nil, 'Preparation has ended! Begin voting!', 'voting', nil)
        local AllTeams = team.GetAllTeams()
        for ID, TeamInfo in pairs(AllTeams) do
            if ID == TEAM_BLUE or ID == TEAM_ORANGE then
                ram_client_status_update(RESEARCH_STATUS_VOTING, ID)
                TeamInfo.ResearchManager:start_research_cycle()
            end
        end
    end
end

local function server_init_map_end_timer()
    timer.Create('RAM_TimerMapEnd', GetConVar("ram_map_time_limit_minutes"):GetInt() * 60, 1, EndMap)
end

local function server_init_prep_end_timer()
    timer.Create('RAM_TimerPrepEnd', GetConVar("ram_prep_time_limit_seconds"):GetInt(), 1, EndPrep)
end

local function InitTeamVariables()
    local AllTeams = team.GetAllTeams()
    for ID, TeamInfo in pairs(AllTeams) do
        if ID == TEAM_BLUE or ID == TEAM_ORANGE then

            local newResearchManager = ResearchManager({
                team_index = ID,
                team_name = TeamInfo['Name']
            })
            local armorCat = newResearchManager:add_category({
                key = 'armor',
                name = 'Armor',
            })

            armorCat:add_technology({
                key = 'armor_one', -- This is required
                name = 'Armor Type I', -- This is required
                tier = 1, -- This is required
            })

            armorCat:add_technology({
                key = 'armor_two', -- This is required
                name = 'Armor Type II', -- This is required
                tier = 2, -- This is required
                reqs = {'armor_one'}
            })

            armorCat:add_technology({
                key = 'armor_three', -- This is required
                name = 'Armor Type III', -- This is required
                tier = 3, -- This is required
                reqs = {'armor_two'}
            })

            armorCat:add_technology({
                key = 'armor_four', -- This is required
                name = 'Armor Type IV', -- This is required
                tier = 4, -- This is required,
                reqs = {'armor_three'}
            })

            armorCat:add_technology({
                key = 'armor_five', -- This is required
                name = 'Armor Type V', -- This is required
                tier = 5, -- This is required,
                reqs = {'armor_four'}
            })

            local healthCat = newResearchManager:add_category({
                key = 'health',
                name = 'Health',
            })

            healthCat:add_technology({
                key = 'health_one', -- This is required
                name = 'Health Type I', -- This is required
                tier = 1, -- This is required,
            })

            healthCat:add_technology({
                key = 'health_two', -- This is required
                name = 'Health Type II', -- This is required
                tier = 2, -- This is required
                reqs = {'health_one'}
            })

            healthCat:add_technology({
                key = 'health_three', -- This is required
                name = 'Health Type III', -- This is required
                tier = 3, -- This is required
                reqs = {'health_two'}
            })

            healthCat:add_technology({
                key = 'health_four', -- This is required
                name = 'Health Type IV', -- This is required
                tier = 4, -- This is required
                reqs = {'health_three'}
            })

            healthCat:add_technology({
                key = 'health_five', -- This is required
                name = 'Health Type V', -- This is required
                tier = 5, -- This is required
                reqs = {'health_four'}
            })

            local weapCat = newResearchManager:add_category({
                key = 'weapons',
                name = 'Weapons',
            })

            weapCat:add_technology({
                key = 'revolver',
                name = 'Revolver',
                class = 'weapon_ram_revolver',
                tier = 1
            })

            weapCat:add_technology({
                key = 'smg',
                name = 'SMG',
                class = 'weapon_ram_smg',
                tier = 2,
            })

            weapCat:add_technology({
                key = 'shotgun',
                name = 'Shotgun',
                class = 'weapon_ram_shotgun',
                tier = 3,
                reqs = { 'revolver' }
            })

            weapCat:add_technology({
                key = 'ar',
                name = 'Ar2',
                class = 'weapon_ram_ar2',
                tier = 4,
                reqs = { 'smg' }
            })

            weapCat:add_technology({
                key = 'crossbow',
                name = 'Crossbow',
                class = 'weapon_crossbow',
                tier = 5,
                reqs = { 'smg' }
            })

            weapCat:add_technology({
                key = 'rpg',
                name = 'RPG',
                class = 'weapon_rpg',
                tier = 6,
                reqs = { 'ar' }
            })

            weapCat:add_technology({
                key = 'gauss',
                name = 'Gauss Gun',
                class = 'weapon_ram_gauss',
                tier = 7,
                reqs = { 'crossbow' }
            })

            weapCat:add_technology({
                key = 'egon',
                name = 'Gluon Gun',
                class = 'weapon_ram_egon',
                tier = 8,
                reqs = { 'rpg' }
            })

            local gadgetCat = newResearchManager:add_category({
                key = 'gadgets',
                name = 'Gadgets'
            })

            gadgetCat:add_technology({
                key = 'satchel',
                name = 'Satchel Charges',
                class = 'weapon_ram_satchel',
                tier = 1
            })

            gadgetCat:add_technology({
                key = 'grenade',
                name = 'Grenades',
                class = 'weapon_frag',
                tier = 2,
                reqs = { 'satchel' }
            })

            gadgetCat:add_technology({
                key = 'tripmine',
                name = 'Tripmines',
                class = 'weapon_ram_tripmine',
                tier = 3,
                reqs = { 'grenade' }
            })

            local implantCat = newResearchManager:add_category({
                key = 'implants',
                name = 'Implants'
            })

            implantCat:add_technology({
                key = 'legs_one',
                name = 'Cybenetic Legs MKI',
                tier = 1
            })

            implantCat:add_technology({
                key = 'legs_two',
                name = 'Cybenetic Legs MKII',
                tier = 2,
                reqs = { 'legs_one' }
            })

            TeamInfo.ResearchManager = newResearchManager
            TeamInfo.Money = 30000 -- Every team gets $30,000 to start
            TeamInfo.Scientists = 3 -- Every team gets 3 to start
        end
    end
end

--[[All GM: spaced functions]]

function GM:Initialize()
    InitTeamVariables()
    server_init_prep_end_timer()
    server_init_map_end_timer()
end

function GM:ShowHelp(ply) -- This hook is called everytime F1 is pressed.
    local AllTeams = team.GetAllTeams()
    if (ply:Team() == TEAM_BLUE or ply:Team() == TEAM_ORANGE) then
        local status = AllTeams[ply:Team()]['ResearchManager'].status
        if status == RESEARCH_STATUS_VOTING and not AllTeams[ply:Team()].ResearchManager:has_user_voted(ply:SteamID()) then
            net.Start("RAM_show_help")
            net.WriteInt(status, 4)
            net.Send(ply)
        end
    end
end


--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawn( )
   Desc: Called when a player spawns
-----------------------------------------------------------]]
function GM:PlayerSpawn( pl )

	player_manager.SetPlayerClass( pl, "player_ram" )

	BaseClass.PlayerSpawn( self, pl )

    pl:CrosshairDisable()

end

function GM:PlayerShouldTakeDamage(victim, pl)
    if pl:IsPlayer() and victim ~= pl then -- check the attacker is player
        if (pl:Team() == victim:Team()) then -- check the teams are equal and that friendly fire is off.
            return false -- do not damage the player
        end
    end
    return true -- damage the player
end

--[[---------------------------------------------------------
   Name: gamemode:DoPlayerDeath( )
   Desc: Carries out actions when the player dies
-----------------------------------------------------------]]
function GM:DoPlayerDeath( ply, attacker, dmginfo )

--    if IsValid(ply) and IsValid(attacker) then
--        if dmginfo:GetDamage() > ply:Health() * 2 then
--            ply:Gib()
--        end
--    end

--  if       dmg         greater than a quarter of playermaxhp (Eg dmg > 25)
    if dmginfo:GetDamage() > (ply:GetMaxHealth() * 0.80) then
        ply:ExplodeIntoGibs()
    else
        ply:CreateRagdoll()
    end

	ply:AddDeaths( 1 )

	if ( attacker:IsValid() and attacker:IsPlayer() ) then

		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end

	end

end

--[[---------------------------------------------------------
   Name: gamemode:CanPlayerSuicide( )
   Desc: Checks whether we can suicide
-----------------------------------------------------------]]
function GM:CanPlayerSuicide( ply )
	return ply:IsSuperAdmin() or ply:IsAdmin()
--    return false
end
