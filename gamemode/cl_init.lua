---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Комерад.
--- DateTime: 5/22/2018 10:16 PM
---

include( "shared.lua" )
include( "cl_pickteam.lua" )
include( "cl_researchmenu.lua" )
include( "cl_hud.lua" )
include( "cl_scoreboard.lua" )
include( "cl_research_manager.lua" )
include( "cl_research_category.lua" )
include( "cl_research_technology.lua" )

local function InitTeamVariables()
    local AllTeams = team.GetAllTeams()
    for ID, TeamInfo in pairs(AllTeams) do
        if (ID ~= TEAM_CONNECTING and ID ~= TEAM_UNASSIGNED and ID ~= TEAM_SPECTATOR) then
            -- These should be client objects.
            local newResearchManager = ClientResearchManager(ID, TeamInfo['Name'])
            local armorCat = newResearchManager:AddCategory('armor', 'Armor')
            local armor_one = armorCat:AddTechnology('armor_one', 'Armor Type I', 'Light Armor (20)', 60, 1)
            local armor_two = armorCat:AddTechnology('armor_two', 'Armor Type II', 'Decent Armor (40)', 65, 2, {'armor_one'})
            local armor_three = armorCat:AddTechnology('armor_three', 'Armor Type III', 'Better Armor (60)', 70, 3, {'armor_two'})
            local armor_four = armorCat:AddTechnology('armor_four', 'Armor Type IV', 'Good Armor', 75, 4, {'armor_three'})
            local armor_five = armorCat:AddTechnology('armor_five', 'Armor Type V', 'Best Armor', 75, 5, {'armor_four'})

            local healthCat = newResearchManager:AddCategory('health', 'Health')
            local health_one = healthCat:AddTechnology('health_one', 'Health Type I', 'Light Health (20)', 60, 1)
            local health_two = healthCat:AddTechnology('health_two', 'Health Type II', 'Decent Health (40)', 65, 2, {'health_one'})
            local health_three = healthCat:AddTechnology('health_three', 'Health Type III', 'Better Health (60)', 70, 3, {'health_two'})
            local health_four = healthCat:AddTechnology('health_four', 'Health Type IV', 'Good Armor', 75, 4, {'health_three'})
            local health_five = healthCat:AddTechnology('health_five', 'Health Type V', 'Best Armor', 75, 5, {'health_four'})

            TeamInfo.ResearchManager = newResearchManager
            TeamInfo.ResearchManager:ToJSON()
        end
    end
end

function GM:Initialize()
    -- Do stuff
    MsgN("RM Client initializing...")

    self.BaseClass:Initialize()

    InitTeamVariables()
end
