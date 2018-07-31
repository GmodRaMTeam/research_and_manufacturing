---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Комерад.
--- DateTime: 5/26/2018 3:54 PM
---

net.Receive("RAM_PrintToTeam", function(len, pl)
    local stringMsg = net.ReadString()
    chat.AddText(stringMsg)
end)

net.Receive("RAM_ClientStatusUpdate", function(len, pl)
    local intStatus = net.ReadInt(3)
    local intTeam = net.ReadInt(3)
    if LocalPlayer():Team() == intTeam then
        surface.PlaySound("garrysmod/save_load1.wav")
    end
    --end
end)

local function ResearchMenu()
    local ply = LocalPlayer()
    if ply:IsValid() and ply:IsPlayer() then
        local team = ply:Team()
		if team == TEAM_SPECTATOR or team == TEAM_UNASSIGNED or team == TEAM_UNASSIGNED then
			--if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_CONNECTING then
			return false
		end
	end
    local Menu = vgui.Create("DFrame")
    Menu:SetPos(ScrW() / 2 - 400, ScrH() / 2 - 400)
    Menu:SetSize(800, 700)
    Menu:SetText("My Menu")
    Menu:SetDraggable(false)
    Menu:ShowCloseButton(true)
    Menu:MakePopup()
    function Menu:Paint()
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 230))
	end

    local sheet = vgui.Create("DPropertySheet", Menu)
    sheet:Dock(FILL)

    local panel_armor = vgui.Create("DPanel", sheet)
    panel_armor.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, self:GetAlpha()))
    end
    sheet:AddSheet("test", panel_armor, "icon16/shield.png")

    local armor_techs = {"armor_one", "armor_two"}

    for index, stringResearchIndex in ipairs(armor_techs) do
        local DermaButton = vgui.Create("DButton", panel_armor) --// Create the button and parent it to the frame
        DermaButton:SetText("Armor "..index)                    --// Set the text on the button
        --DermaButton:SetPos(25, 50)                    --// Set the position on the frame
        DermaButton:Dock(TOP)
        DermaButton:SetSize(250, ScrH()/8)                    --// Set the size
        DermaButton.DoClick = function()
            net.Start("RAM_RecordResearchVote")
            net.WriteString("armor")
            net.WriteString(stringResearchIndex)
            net.SendToServer()
            --end
        end
    end

    local panel_health = vgui.Create("DPanel", sheet)
    panel_health.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 128, 0, self:GetAlpha()))
    end
    sheet:AddSheet("test 2", panel_health, "icon16/tick.png")

    ----//You can leave out the parentheses if there is a single string as an argument.
end
--usermessage.Hook("OpenResearchMenu", function()
--    ResearchMenu()
--end)

net.Receive('RAM_ShowHelp', function()
    local ply = LocalPlayer()
    local researchStatus = net.ReadInt(3)
    if ( ply:Team() ~= TEAM_CONNECTING and ID ~= TEAM_UNASSIGNED and ID ~= TEAM_SPECTATOR ) then
        if researchStatus ~= RESEARCH_STATUS_IN_PROGRESS then
            ResearchMenu()
        end
    end
end)
