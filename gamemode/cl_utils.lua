--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/1/2018
-- Time: 8:53 AM
-- To change this template use File | Settings | File Templates.
--

---------------------------------- All Clientside Gamemode Utillity Functions ----------------------------------

net.Receive("RAM_PrintToTeam", function(len, pl)
    local stringMsg = net.ReadString()
    chat.AddText(stringMsg)
end)

net.Receive("RAM_ClientStatusUpdate", function(len, pl)
    local intStatus = net.ReadInt(4)
    local intTeam = net.ReadInt(3)
    if LocalPlayer():Team() == intTeam then
--        surface.PlaySound("garrysmod/save_load1.wav")
        team.GetAllTeams()[intTeam].ResearchManager.status = intStatus
    end

    --end
end)

net.Receive("RAM_DynamicNotification", function(len, pl)
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
