--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/6/2018
-- Time: 7:33 PM
-- To change this template use File | Settings | File Templates.
--

--====================================================================================================================--
--                                                                                                                    --
--====================================================================================================================--

net.Receive("RAMCL_request_sync_map_timer", function(len, ply)
    ram_sync_map_timer(ply)
end)

net.Receive("RAMCL_request_sync_prep_timer", function(len, ply)
    ram_sync_prep_timer(ply)
end)

net.Receive("RAMCL_request_sync_status", function(len, ply)
    ram_sync_status(ply)
end)

net.Receive("RAMCL_request_scientist_sync", function(len, ply)
    sv_ram_sync_scientists(ply)
end)

net.Receive("RAMCL_request_sync_research_timer", function(len, ply)
    if ply:IsValid() and (ply:Team() == TEAM_BLUE or ply:Team() == TEAM_ORANGE) then
        team.GetAllTeams()[ply:Team()].ResearchManager:sync_player_research_timer(ply)
    end
end)

net.Receive("RAMCL_record_research_vote", function(len, ply)
--    ram_dynamic_status_update(ply:Team(), 'Test', 'success', nil)

	local research_cat = net.ReadString()
	local research_index = net.ReadString()
    local AllTeams = team.GetAllTeams()
    local TeamInfo = AllTeams[ply:Team()]

    local ply_has_voted = TeamInfo.ResearchManager:has_user_voted(ply:SteamID())
    local tech = TeamInfo.ResearchManager.categories[research_cat].techs[research_index]

    if not ply_has_voted then
        if tech:can_do_research() and not tech.researched then
            table.insert(tech.votes, ply:SteamID())
            local research_name = tech.name
            local msg = "Vote recorded for " .. research_name .. " by " .. ply:Nick() .. "!"
            ram_dynamic_status_update(ply:Team(), msg, 'success', nil)
            ram_client_status_updateToPlayer(RESEARCH_STATUS_CLIENT_VOTED, ply:Team(), ply)
        else
            local msg = "You are un-able to currently research that!"
            ram_dynamic_status_update(nil, msg, 'error', ply)
        end
    else
        local msg = "Please wait until the next voting session to vote again!"
        ram_dynamic_status_update(nil, msg, 'error', ply)
    end
    -- Either way update them in-case they're out of sync
--    AllTeams[ply:Team()].ResearchManager:send_client_technology_update(research_cat, research_index)
end)

-- One question is whether to do player validation, which really we should.
net.Receive("RAMCL_request_technology_update", function(len, pl)
--    print("!!!!!!!!!!!!!!!!!!!!RAMCL_request_technology_update!!!!!!!!!!!!!!!!!!!!")
    -- Make sure the player calling this is a valid entity, and a valid player, on a team.
    if (IsValid(pl) and pl:IsPlayer()) and (pl:Team() == TEAM_BLUE or pl:Team() == TEAM_ORANGE) then
        local cat_key = net.ReadString()
        local tech_key = net.ReadString()
        local plyTeamResearchManager = team.GetAllTeams()[pl:Team()].ResearchManager
        if plyTeamResearchManager:is_valid_cat_tech_pair(cat_key, tech_key) then
            plyTeamResearchManager:send_client_technology_update(cat_key, tech_key)
        end
    end
end)

-- We should update both teams. Does it really matter if clients can see the other teams research in the code?
-- A lot of work for the obvious
net.Receive("RAMCL_request_entire_research_table", function(len, pl)
--    if (IsValid(pl) and pl:IsPlayer()) and (pl:Team() == TEAM_BLUE or pl:Team() == TEAM_ORANGE) then
--        local plyTeamResearchManager = team.GetAllTeams()[pl:Team()].ResearchManager
--        plyTeamResearchManager:update_client_table()
--    end
    if not IsValid(pl) then return end
    team.GetAllTeams()[TEAM_BLUE].ResearchManager:update_client_table()
    team.GetAllTeams()[TEAM_ORANGE].ResearchManager:update_client_table()
end)
