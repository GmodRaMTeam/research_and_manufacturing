--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/6/2018
-- Time: 7:37 PM
-- To change this template use File | Settings | File Templates.
--

DEFINE_BASECLASS( "gamemode_base" )

local function OverseerSelectSpawn(team)
    local spawn_class = ''

    if team == TEAM_BLUE then
        spawn_class = 'info_overseer_blue_spawn'
    else
        spawn_class = 'info_overseer_orange_spawn'
    end

    local SpawnPoints = ents.FindByClass(spawn_class)

    local ChosenSpawnPoint = table.Random(SpawnPoints)

    if ChosenSpawnPoint == nil then
        return nil
    else
        return {
            pos = ChosenSpawnPoint:GetPos(),
            ang = ChosenSpawnPoint:GetAngles()
        }
    end
end

hook.Add("PlayerDeath", "RAM_PlayerDropScientistOnDeath", function(victim, inflictor, attacker)
    victim:DropScientist(victim:GetPos())
end)

hook.Add("EntityTakeDamage", "RAM_CorrectHL2Damage", function(target, dmg)
    local attacker = dmg:GetAttacker()
    if IsValid(target) and IsValid(attacker) then
        if target:IsPlayer() and attacker:IsPlayer() then
            local attacker_weapon = attacker:GetActiveWeapon()
            if attacker_weapon:GetClass() == 'weapon_rpg' then
                print("Correcting RPG damage!")
                dmg:ScaleDamage( 0.65 )
            end
            if attacker_weapon:GetClass() == 'weapon_stunstick' then
                dmg:SetDamage(25) -- 40 is wayyyyy too stronky
            end
        end
    end
end)

hook.Add("PlayerInitialSpawn", "RAM_SetBotsToOrangeTeam", function(ply)
    if ply:IsBot() then
        timer.Simple(5, function()
            print("Player is a bot")
    --        BaseClass.PlayerJoinTeam(self, ply, TEAM_ORANGE )
            local iOldTeam = ply:Team()

            if (ply:Alive()) then
                if (iOldTeam == TEAM_SPECTATOR or iOldTeam == TEAM_UNASSIGNED) then
                    ply:KillSilent()
                else
                    ply:Kill()
                end
            end

            ply:SetTeam(TEAM_ORANGE)
            ply.LastTeamSwitch = RealTime()

            -- Here's an immediate respawn thing by default. If you want to
            -- re-create something more like CS or some shit you could probably
            -- change to a spectator or something while dead.
            if (ply:Team() == TEAM_SPECTATOR) then

                -- If we changed to spectator mode, respawn where we are
                local Pos = ply:EyePos()
                ply:Spawn()
                ply:SetPos(Pos)

            elseif (iOldTeam == TEAM_SPECTATOR) then

                -- If we're changing from spectator, join the game
                ply:Spawn()

            else

                -- If we're straight up changing teams just hang
                -- around until we're ready to respawn onto the
                -- team that we chose
            end

            PrintMessage(HUD_PRINTTALK, Format("%s joined '%s'", ply:Nick(), team.GetName(ply:Team())))
         end)
    end
end)

hook.Add("PlayerDeath", "RAM_PlayerTakeMoneyFromTeamOnDeath", function(victim, inflictor, attacker)
    if IsValid(victim) and victim:IsPlayer() and victim:Team() == TEAM_BLUE or victim:Team() == TEAM_ORANGE then
        local team_index = victim:Team()
        local team_table = team.GetAllTeams()[team_index]
        if team_table.ResearchManager.status ~= RESEARCH_STATUS_PREP then
            team.GetAllTeams()[team_index].Money = team_table.Money - GetConVar("ram_player_death_cost"):GetInt()
            team_table.ResearchManager:send_team_money_update()
        end
    end
end)

hook.Add("InitPostEntity", "SpawnRMNPCS", function()
    local AllTeams = team.GetAllTeams()
    for ID, TeamInfo in pairs(AllTeams) do
        if (ID ~= TEAM_CONNECTING and ID ~= TEAM_UNASSIGNED and ID ~= TEAM_SPECTATOR) then
            for k = 0, TeamInfo.Scientists - 1 do
                local new_scientist = ents.Create("ram_simple_scientist")
                if (not IsValid(new_scientist)) then return end -- Check whether we successfully made an entity, if not - bail
                --                button:SetModel("models/dav0r/buttons/button.mdl")
                local spawnpoint_pos = new_scientist:ScientistSelectSpawn(ID)
                if spawnpoint_pos ~= nil then
                    new_scientist:SetPos(spawnpoint_pos)
                    new_scientist:SetTeam(ID)
                    new_scientist:Spawn()
                else
                    new_scientist:Remove()
                end
            end
            local new_overseer = ents.Create("ram_overseer")
            if (not IsValid(new_overseer)) then return end -- Check whether we successfully made an entity, if not - bail
            --                button:SetModel("models/dav0r/buttons/button.mdl")
            local spawnpoint_pos_data = OverseerSelectSpawn(ID)
            if spawnpoint_pos_data ~= nil then
                new_overseer:SetPos(spawnpoint_pos_data['pos'])
                new_overseer:SetAngles(spawnpoint_pos_data['ang'])
                new_overseer:SetTeam(ID)
                new_overseer:Spawn()
            else
                new_overseer:Remove()
            end
        end
    end
end)

