--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 5:24 PM
-- To change this template use File | Settings | File Templates.
--

-- ===== Scoreboard ===== --

local scoreboard = scoreboard or {}
scoreboard.frame = nil

function scoreboard:show()
    --Create the scoreboard here, with an base like DPanel, you can use an DListView for the rows.
    function scoreboard:init()
        -- Drawing the scoreboard here for now, then hiding. Way faster to hide/un-hide than draw everytime.

        local scoreboard_frame = vgui.Create("DFrame")
        scoreboard_frame:SetTitle("")
        scoreboard_frame:SetSize(ScrW() * 0.75, ScrH() * 0.75)
        scoreboard_frame:Center()
        scoreboard_frame:ShowCloseButton(false)
        scoreboard_frame:SetSizable(false)
        scoreboard_frame:SetPaintShadow(true)
        function scoreboard_frame:Paint()
            --    draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 230))
        end

        local html = vgui.Create("DHTML", scoreboard_frame)
        html:Dock(FILL)
        html:OpenURL("asset://garrysmod/gamemodes/research_and_manufacturing/content/html/scoreboard.html")
        html:SetAllowLua(true)

        html:AddFunction("player", "getAll", function()

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
--        scoreboard_frame:Hide()
        print("-- RM Scoreboard Initialized --")
        return scoreboard_frame
    end

    if scoreboard.frame == nil then
        scoreboard.frame = scoreboard:init()
    else
        scoreboard.frame:Show()
    end

    function scoreboard:hide()
        -- This is where you hide the scoreboard, such as with Base:Remove()
        if scoreboard.frame == nil then
            scoreboard.frame = scoreboard:init()
            scoreboard.frame:Hide()
        else
            scoreboard.frame:Hide()
        end
    end

end

function GM:ScoreboardShow()
    scoreboard:show()
end

function GM:ScoreboardHide()
    scoreboard:hide()
end
