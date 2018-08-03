--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/1/2018
-- Time: 8:41 AM
-- To change this template use File | Settings | File Templates.
--

---------------------------------- All ServerSide Gamemode Utillity Functions ----------------------------------

function GetMapTimeLeft()
    if timer.Exists('RAM_TimerMapEnd') then
        return timer.TimeLeft('RAM_TimerMapEnd')
    end
end

function GetPrepTimeLeft()
    if timer.Exists('RAM_TimerPrepEnd') then
        return timer.TimeLeft('RAM_TimerPrepEnd')
    end
end

function DynamicStatusUpdate(team_index, message, status, specific_player)
    -- Status can be: 'warning', 'success', 'error'
    if team_index ~= nil then
        for k, ply in pairs(player.GetAll()) do
            if IsValid(ply) and ply:Team() == team_index then
                net.Start("RAM_DynamicNotification")
                net.WriteString(message)
                net.WriteString(status)
                net.Send(ply)
            end
        end
    elseif specific_player ~= nil and specific_player:IsValid() and team_index == nil then
        net.Start("RAM_DynamicNotification")
        net.WriteString(message)
        net.WriteString(status)
        net.Send(specific_player)
        print("We sent player: "..specific_player:Nick().." A dynamic update!")
    else
        net.Start("RAM_DynamicNotification")
        net.WriteString(message)
        net.WriteString(status)
        net.Broadcast()
        if team_index ~= nil then
            print("We sent team"..team_index.." A dynamic update!")
        end
    end
end

function PrintToTeam(teamIndex, stringMsg)
    for k, ply in pairs(player.GetAll()) do
        if ply:Team() == teamIndex then
            --ply:ChatPrint(stringMsg)
            net.Start("RAM_PrintToTeam")
            net.WriteString(stringMsg)
            net.Send(ply)
        end
    end
end

function ClientStatusUpdate(intStatus, intTeam)
    net.Start("RAM_ClientStatusUpdate")
    --net.WriteString("some text")
    net.WriteInt(intStatus, 3)
    net.WriteInt(intTeam, 3)
    net.Broadcast()
    -- We did something!
end
