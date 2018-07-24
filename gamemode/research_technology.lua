--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 2:18 PM
-- To change this template use File | Settings | File Templates.
--


local ResearchTechnologyClass = {}
ResearchTechnologyClass.key = '' -- Default empty string
ResearchTechnologyClass.name = '' -- Default empty string
ResearchTechnologyClass.description = '' -- Default empty string
ResearchTechnologyClass.cost = 60 -- Default of 60
ResearchTechnologyClass.researched = false -- Default of false
ResearchTechnologyClass.reqs = {} -- Defaults to empty array/table
ResearchTechnologyClass.votes = {} -- Defaults to empty array/table
ResearchTechnologyClass.category = nil

function ResearchTechnologyClass:MeetsRequirements()
    -- If no requirementList passed, return True
    if #self.reqs == 0 then
        return true
    end
    -- Loop through the requirment list given, see if we have them researched
    for index, req_tech_key in ipairs(self.reqs) do
        if not self.category.techs[req_tech_key].researched then
            return false
        end
    end
    return true
end


function ResearchTechnologyClass:CanDoResearch()
    local manager = self.category.manager
    if (CurTime() >= manager.last_time) and (manager.status ~= RESEARCH_STATUS_IN_PROGRESS) then
        -- If we have researched it, return false, if not keep going
        if self.researched then
            local msg = "Cannot start research! You already have this researched."
            PrintToTeam(manager.team_index, msg)
            return false
        else
            if self:MeetsRequirements() then
                return true
            else
                local msg = "Cannot start research! You need to research the requirements!"
                PrintToTeam(manager.team_index, msg)
                return false
            end
        end
    else
        local difference = round(manager.current_cost - (CurTime() - (manager.last_time)), 1)
        local msg = "Cannot start research! Please wait " .. difference .. " more seconds."
        PrintToTeam(manager.team_index, msg)
        return false
    end
end

function ResearchTechnology(key, name, description, cost, category)
    assert(key ~= nil, "ResearchTechnology must be passed a valid key")
    assert(name ~= nil, "ResearchTechnology must be passed a valid name")
    assert(description ~= nil, "ResearchTechnology must be passed a valid description")
    assert(category ~= nil, "ResearchTechnology must be passed a valid ResearchCategory table/object")
    assert(type(category) == 'table', "ResearchTechnology must be passed a valid ResearchCategory table/object")
    local newResearchTechnology = table.Copy(ResearchTechnologyClass)
    newResearchTechnology.key = key
    newResearchTechnology.name = name
    newResearchTechnology.description = description
    newResearchTechnology.category = category
    -- Cost is optional
    if cost ~= nil then
        newResearchTechnology.cost = cost
    end
    --Return our new Object.
    return newResearchTechnology
end
