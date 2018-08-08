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

    if HUD.html == nil then
        HUD:Init()
    end

    HUD.html:AddFunction("player", "getAll", function()

        local team_table = team.GetAllTeams()
        local teams_tbl = {}

        for index, team in ipairs(team_table) do
            if index == TEAM_BLUE or index == TEAM_ORANGE then
                teams_tbl[index] = {
                    index = index,
                    name = team['Name'],
                    score = team['Score'],
                    money = team['Money'],
                    scientists = team['Scientists'],
                    color = team['Color'],
                    team_members = {},
                }
            end
        end
        teams_tbl[999] = {
            index = 999,
            name = 'Spectators/Unassigned',
            score = 0,
            color = Color(255,255,255,255),
            team_members = {},
        }

        local player_table = player.GetAll()

        for index, ply in ipairs(player_table) do
            if ply:IsValid() then
                -- For some reason when the ply is on the unassigned/spectator team it causes issues.
                if ply:Team() == TEAM_BLUE or ply:Team() == TEAM_ORANGE then
                    table.insert(teams_tbl[ply:Team()]['team_members'], {
                        nick = ply:Nick(),
                        steamid = ply:SteamID(),
                        frags = ply:Frags(),
                        deaths = ply:Deaths(),
                        ping = ply:Ping(),
                    })
                else
                    table.insert(teams_tbl[999]['team_members'], {
                        nick = ply:Nick(),
                        steamid = ply:SteamID(),
                        frags = ply:Frags(),
                        deaths = ply:Deaths(),
                        ping = ply:Ping(),
                    })
                end
            end
        end
        return util.TableToJSON(teams_tbl)
    end)
    print("-- RM Scoreboard Initialized --")
end

function GM:ScoreboardShow()
    if HUD.html == nil then
        HUD:Init()
    end
    -- Only inits on first attempt to draw
    scoreboard:init()

    surface.PlaySound("ding.wav")

    HUD.html:QueueJavascript([[ EVENTS.trigger('show_scoreboard') ]])
end

function GM:ScoreboardHide()
    HUD.html:QueueJavascript([[ EVENTS.trigger('hide_scoreboard') ]])
end
