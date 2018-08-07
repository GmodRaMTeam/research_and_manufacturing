--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/6/2018
-- Time: 7:27 PM
-- To change this template use File | Settings | File Templates.
--

net.Receive("RAM_sync_research_timer", function()
    local research_time = net.ReadInt(12)
    if timer.Exists("RAM_LocalPlayerResearchTimer") then
        timer.Remove("RAM_LocalPlayerResearchTimer")
    end
    if research_time ~= nil and research_time > 0 then
        timer.Create("RAM_LocalPlayerResearchTimer", research_time, 1, function()
            print("!RAM_sync_research_timer!")
        end)
    end
end)

net.Receive("RAM_sync_map_timer", function()
    local time = net.ReadFloat()
    timer.Create('RAM_TimerMapEnd', time , 1, EndMap)
end)

net.Receive("RAM_sync_prep_timer", function()
    local time = net.ReadFloat()
    timer.Create('RAM_TimerPrepEnd', time, 1, EndPrep)
end)

net.Receive("RAM_sync_status", function()
    local blue_status = net.ReadInt(4)
    local orange_status = net.ReadInt(4)
    team.GetAllTeams()[TEAM_BLUE].ResearchManager.status = blue_status
    team.GetAllTeams()[TEAM_ORANGE].ResearchManager.status = orange_status
end)

net.Receive('RAM_show_help', function()
    local ply = LocalPlayer()
    local researchStatus = net.ReadInt(4)
    if ( ply:Team() ~= TEAM_CONNECTING and ID ~= TEAM_UNASSIGNED and ID ~= TEAM_SPECTATOR ) then
        if researchStatus == RESEARCH_STATUS_VOTING then
            if HUD.html ~= nil then
                HUD.html:QueueJavascript([[ EVENTS.trigger('toggle_research_menu') ]])
                local current_cursor_status = vgui.CursorVisible()
                gui.EnableScreenClicker((not current_cursor_status))
            end
        end
    end
end)

net.Receive("RAM_scientist_update", function()
    team.GetAllTeams()[TEAM_BLUE].Scientists = net.ReadInt(4)
    team.GetAllTeams()[TEAM_ORANGE].Scientists = net.ReadInt(4)
end)

net.Receive("RAM_technology_update", function(len, pl)
    -- Make sur ethe player calling this is a valid entity, and a valid player, on a team.
    local int_team = net.ReadInt(12)
    local cat_key = net.ReadString()
    local tech_key = net.ReadString()
    local is_researched = net.ReadBool()
    local vote_count = net.ReadInt(8)

    local researchManager = team.GetAllTeams()[int_team].ResearchManager
    researchManager.categories[cat_key].techs[tech_key]:update_from_server(is_researched, vote_count)

end)

net.Receive("RAM_print_to_team", function(len, pl)
    local stringMsg = net.ReadString()
    chat.AddText(stringMsg)
end)

net.Receive("RAM_status_update", function(len, pl)
    local intStatus = net.ReadInt(4)
    local intTeam = net.ReadInt(3)
    if LocalPlayer():Team() == intTeam then
--        surface.PlaySound("garrysmod/save_load1.wav")
        team.GetAllTeams()[intTeam].ResearchManager.status = intStatus
    end

    --end
end)

net.Receive("RAM_dynamic_notification", function(len, pl)
    -- Play cute annoying sound
    local stringMsg = net.ReadString()
    local stringStatus = net.ReadString()
    if stringStatus == 'success' then --------------------- Success
        surface.PlaySound("beep_short.wav")
    elseif stringStatus == 'voting' then ------------------ Voting
        surface.PlaySound("Electronic_Chime.wav")
        stringStatus = 'success'
    elseif stringStatus == 'warning' then ----------------- Warning
        surface.PlaySound("Pling.wav")
    elseif stringStatus == 'kidnap' then ------------------- Kidnap
        surface.PlaySound("garrysmod/save_load3.wav")
        stringStatus = 'error'
    elseif stringStatus == 'error' then -------------------- Error
        surface.PlaySound("garrysmod/save_load3.wav")
    else---------------------------------------------------- Else
        surface.PlaySound("beep-5.wav")
    end

    HUD.html:QueueJavascript("toastr." .. stringStatus .. "('" .. stringMsg .. "')")
end)

net.Receive("RAM_make_money", function()
    local team_to_update = net.ReadInt(3)
    local new_money = net.ReadInt(21)
    local TeamInfo = team.GetAllTeams()[team_to_update]
    TeamInfo.Money = new_money
end)
