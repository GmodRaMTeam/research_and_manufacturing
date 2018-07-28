--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 5:24 PM
-- To change this template use File | Settings | File Templates.
--

-- ===== Scoreboard ===== --

local scoreboard = scoreboard or {}
scoreboard.initialized = nil

function scoreboard:init()
    -- We only want to initialize once, so check that
    if scoreboard.initialized then
        return
    else
        scoreboard.initialized = true
    end

    HUD.html:AddFunction("player", "getAll", function()

        local team_table = team.GetAllTeams()
        local teams_tbl = {}

        for index, team in ipairs(team_table) do
            teams_tbl[index] = {
                name = team['Name'],
                score = team['Score'],
                color = team['Color'],
                team_members = {},
            }
        end

        local player_table = player.GetAll()

        for index, ply in ipairs(player_table) do
            if ply:IsValid() then
                -- For some reason when the ply is on the unassigned/spectator team it causes issues.
                if ply:Team() ~= 1001 or ply:Team() ~= 1002 then
                    teams_tbl[ply:Team()]['team_members'][ply:SteamID()] = {
                        nick = ply:Nick(),
                        steamid = ply:SteamID(),
                        frags = ply:Frags(),
                        deaths = ply:Deaths(),
                        ping = ply:Ping(),
                    }
                end
            end
        end
        return util.TableToJSON(teams_tbl)
    end)
    print("-- RM Scoreboard Initialized --")
end

function GM:ScoreboardShow()
    -- Only inits on first attempt to draw
    scoreboard:init()

    HUD.html:QueueJavascript([[ EVENTS.trigger('show_scoreboard') ]])
end

function GM:ScoreboardHide()
    HUD.html:QueueJavascript([[ EVENTS.trigger('hide_scoreboard') ]])
end
