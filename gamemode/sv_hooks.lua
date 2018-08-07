--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/6/2018
-- Time: 7:37 PM
-- To change this template use File | Settings | File Templates.
--

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

