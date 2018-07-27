---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Комерад.
--- DateTime: 5/22/2018 10:15 PM
---

DEFINE_BASECLASS( "gamemode_base" )

util.AddNetworkString("RMDynamicNotification")
util.AddNetworkString("RMShowHelp")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_pickteam.lua")
AddCSLuaFile("cl_researchmenu.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("shared.lua")
--AddCSLuaFile("utils.lua")

include("shared.lua")
include("player.lua")
include("player_ext.lua")
include("komerad_autorun.lua")
include("research_manager.lua")
include("research_category.lua")
include("research_technology.lua")

-- Convars --
CreateConVar("rm_map_time_limit", "30", FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("rm_auto_vote_time_seconds", "30", FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("rm_vote_time_limit_seconds", "60", FCVAR_NOTIFY + FCVAR_REPLICATED)

--[[All local spaced server functions]]

local function IsScientistSpawnpointSuitable(spawnpoint_pos, spawn_class)

--	local Pos = spawnpointent:GetPos()

	-- Note that we're searching the default hull size here for a player in the way of our spawning.
	-- This seems pretty rough, seeing as our player's hull could be different.. but it should do the job
	-- (HL2DM kills everything within a 128 unit radius)
	local Ents = ents.FindInBox( spawnpoint_pos + Vector( -16, -16, 0 ), spawnpoint_pos + Vector( 16, 16, 64 ) )

--	if ( pl:Team() == TEAM_SPECTATOR ) then return true end

	local Blockers = 0

	for k, v in pairs( Ents ) do
		if ( IsValid( v ) and v:GetClass() == "ram_simple_scientist" ) then

			Blockers = Blockers + 1

--			if ( bMakeSuitable ) then
--				v:Kill()
--			end

		end
	end

--	if ( bMakeSuitable ) then return true end
	if ( Blockers > 0 ) then return false end
	return true

end

local function ScientistSelectSpawn(team)

    --	local SpawnPoints = team.GetSpawnPoints( TeamID )
    --	if ( !SpawnPoints || table.Count( SpawnPoints ) == 0 ) then return end
    --   local SpawnPoints = { 'info_scientist_spawn' }

    local spawn_class = ''

    if team == 1 then
        spawn_class = 'info_scientist_blue_spawn'
    else
        spawn_class = 'info_scientist_orange_spawn'
    end


    local SpawnPoints = ents.FindByClass(spawn_class)

    local ChosenSpawnPoint = nil

    local searcing_for_spawn = true

    while searcing_for_spawn do
        local ChosenSpawnPoint = table.Random(SpawnPoints)
        if ChosenSpawnPoint ~= nil then
            if (IsScientistSpawnpointSuitable(ChosenSpawnPoint:GetPos())) then
                return ChosenSpawnPoint:GetPos()
            end
        end
    end

--    return ChosenSpawnPoint:GetPos()
end

local function OverseerSelectSpawn(team)
    local spawn_class = ''

    if team == 1 then
        spawn_class = 'info_overseer_blue_spawn'
    else
        spawn_class = 'info_overseer_orange_spawn'
    end

    local SpawnPoints = ents.FindByClass(spawn_class)

    local ChosenSpawnPoint = table.Random(SpawnPoints)

    return ChosenSpawnPoint:GetPos()
end

local function EndRound()
    --   print("THE ROUND HAS ENDED!!!!!!!!")
    local text = "The round has ended"

    -- announce to players
    for k, ply in pairs(player.GetAll()) do
        if IsValid(ply) then
            ply:PrintMessage(HUD_PRINTTALK, text)
        end
    end

    timer.Simple(15, function() game.LoadNextMap() end)
end

local function InitGamemodeVariables()
end

local function SetRoundEnd(endtime)
    SetGlobalFloat("rm_map_end", endtime)
end

--function IncRoundEnd(incr)
--   SetRoundEnd(GetGlobalFloat("rm_round_end", 0) + incr)
--end

local function InitMapEndTimer()
    timer.Create('mapendtimer', GetConVar("rm_map_time_limit"):GetInt() * 60, 1, EndRound)
end

local function InitRoundEndTime()
    -- Init round values
    local endtime = CurTime() + (GetConVar("rm_map_time_limit"):GetInt() * 60)

    SetRoundEnd(endtime)
end

local function InitTeamVariables()
    local AllTeams = team.GetAllTeams()
    for ID, TeamInfo in pairs(AllTeams) do
        if (ID ~= TEAM_CONNECTING and ID ~= TEAM_UNASSIGNED and ID ~= TEAM_SPECTATOR) then
--            PrintTable(TeamInfo)
            local newResearchManager = ResearchManager(ID, TeamInfo['Name'])
            local armorCat = newResearchManager:AddCategory('armor', 'Armor')
            local armor_one = armorCat:AddTechnology('armor_one', 'Armor Type I', 'Decent Armor (20)', 60, 1)
            local armor_two = armorCat:AddTechnology('armor_two', 'Armor Type II', 'Decent Armor (40)', 65, 2, {'armor_one'})
            local armor_three = armorCat:AddTechnology('armor_three', 'Armor Type III', 'Better Armor (60)', 70, 3, {'armor_two'})
--            table.insert(armor_two.reqs, armor_one.key)

--            PrintTable(newResearchManager)
            TeamInfo.ResearchManager = newResearchManager
            TeamInfo.Money = 30000 -- Every team gets $30,000 to start
            TeamInfo.Scientists = 3 -- Every team gets 3 to start

            local menu_vote_time = GetConVar("rm_vote_time_limit_seconds"):GetInt()
            timer.Create("Team" .. ID .. "VoteMenuTimeLimit", menu_vote_time, 1, function() newResearchManager:TallyVotes() end)
        end
    end
end

local function PrintTimeLeft()
    --print(GetGlobalFloat("rm_round_end", 0) - CurTime())
    --print(util.SimpleTime( math.max(0, GetGlobalFloat("rm_map_end", 0)) - CurTime(), "%02i:%02i"))
    local endtime = GetGlobalFloat("rm_map_end", 0) - CurTime()
    local text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
    --   print(text)
end

--[[All GM: spaced functions]]

function GM:Initialize()

--    GAMEMODE.playermodel = "models/player/phoenix.mdl"

    InitGamemodeVariables()
    InitTeamVariables()

    local AllTeams = team.GetAllTeams()

    -- Do stuff
    InitMapEndTimer()
    --local ptime = GetConVar("ttt_preptime_seconds"):GetInt()
    InitRoundEndTime()

    --hook.Add("Tick", "PrintTimeLeft", PrintTimeLeft )
end

function GM:ShowHelp(ply) -- This hook is called everytime F1 is pressed.
    --    umsg.Start( "OpenResearchMenu", ply ) -- Sending a message to the client.
    --    umsg.End()
    local AllTeams = team.GetAllTeams()
    --   PrintTable(AllTeams)
    --   PrintTable(AllTeams[ply:Team()])

    if (ply:Team() == 1 or ply:Team() == 2) then
        local status = AllTeams[ply:Team()]['ResearchManager'].status
        if status ~= RESEARCH_STATUS_IN_PROGRESS then
            net.Start("RMShowHelp")
            net.WriteInt(status, 3)
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

end

--Ends function

--function GM:PlayerInitialSpawn( ply )
--   ply:PrintScientistVars()
--   ply:InitScientistVars()
--   ply:PrintScientistVars()
--end

--hook.Add("PlayerInitialSpawn", "InitScientistVarsForPlayer", function(ply)
--    ply:PrintScientistVars()
--    ply:InitScientistVars()
--    ply:PrintScientistVars()
--end)

hook.Add("InitPostEntity", "SpawnRMNPCS", function()
    --	print( "Initialization hook called" )
    local AllTeams = team.GetAllTeams()
    for ID, TeamInfo in pairs(AllTeams) do
        if (ID ~= TEAM_CONNECTING and ID ~= TEAM_UNASSIGNED and ID ~= TEAM_SPECTATOR) then
            for k = 0, TeamInfo.Scientists - 1 do
                local new_scientist = ents.Create("ram_simple_scientist")
                if (not IsValid(new_scientist)) then return end -- Check whether we successfully made an entity, if not - bail
                --                button:SetModel("models/dav0r/buttons/button.mdl")
                new_scientist:SetPos(ScientistSelectSpawn(ID))
                new_scientist:SetTeam(ID)
                new_scientist:Spawn()
            end
            local new_overseer = ents.Create("ram_overseer")
            if (not IsValid(new_overseer)) then return end -- Check whether we successfully made an entity, if not - bail
            --                button:SetModel("models/dav0r/buttons/button.mdl")
            new_overseer:SetPos(OverseerSelectSpawn(ID))
            new_overseer:SetTeam(ID)
            new_overseer:Spawn()
        end
    end
end)

function CaptureScientist(new_team, scientist_name, scientist_cost, scientist_original_team)
--    print("CaptureScientist got value "..scientist_name.." for scientist name!")
--    print("Original team is "..scientist_original_team.."!")
    local new_scientist = ents.Create("ram_simple_scientist")
    if (not IsValid(new_scientist)) then return end -- Check whether we successfully made an entity, if not - bail
    --                button:SetModel("models/dav0r/buttons/button.mdl")
    -- Create a new scientist with the same name/cost and new team
    new_scientist:SetPos(ScientistSelectSpawn(new_team))
    new_scientist:Spawn()
--    print("Setting name "..scientist_name.." on scientist.")
    new_scientist:SetTeam(new_team)
    new_scientist:SetDisplayName(scientist_name)
--    print("New scientist name is "..new_scientist:GetDisplayName().."!")
    new_scientist:SetCost(scientist_cost)

    -- Remove one from the count of the old team, and add one to the new team
    local AllTeams = team.GetAllTeams()
--    PrintTable(AllTeams)
    AllTeams[new_team].Scientists = AllTeams[new_team].Scientists + 1
    AllTeams[scientist_original_team].Scientists = AllTeams[scientist_original_team].Scientists - 1
--    PrintTable(AllTeams)
end

-- Convar replication is broken in gmod, so we do this.
-- I don't like it any more than you do, dear reader.
-- Saw this in TTT, seems like a good idea to replicate for our timer.
function GM:SyncGlobals()
    SetGlobalInt("rm_map_time_limit", GetConVar("rm_map_time_limit"):GetInt())
end

--[[All global server functions]]

function GetTeamInfoTable(teamIndex)
    local AllTeams = team.GetAllTeams()
    return AllTeams[teamIndex]
end

function DynamicStatusUpdate(team_index, message, status, specific_player)
    -- Status can be: 'warning', 'success', 'error'
    if team_index ~= nil then
        for k, ply in pairs(player.GetAll()) do
            if IsValid(ply) and ply:Team() == team_index then
                net.Start("RMDynamicNotification")
                net.WriteString(message)
                net.WriteString(status)
                net.Send(ply)
            end
        end
    elseif specific_player ~= nil and specific_player:IsValid() and team_index == nil then
        net.Start("RMDynamicNotification")
        net.WriteString(message)
        net.WriteString(status)
        net.Send(ply)
    else
        net.Start("RMDynamicNotification")
        net.WriteString(message)
        net.WriteString(status)
        net.Broadcast()
    end
end