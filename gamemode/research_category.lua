--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 2:18 PM
-- To change this template use File | Settings | File Templates.
--

include( "research_technology.lua" )

local ResearchCategoryClass = {}
ResearchCategoryClass.key = '' -- Default empty string
ResearchCategoryClass.name = '' -- Default empty string
ResearchCategoryClass.techs = {} -- Default empty array
ResearchCategoryClass.manager = nil

function ResearchCategoryClass:AddTechnology(key, name, description, class, cost, tier, reqs)
    -- function ResearchTechnology(key, name, description, cost, tier, reqs, category)
    local newResearchTechnology = ResearchTechnology(key, name, description, class, cost, tier, reqs, self)
    self.techs[key] = newResearchTechnology-- Add to our categories
    return newResearchTechnology-- Return our category to do something with it
end

function ResearchCategoryClass:GetHighestTechResearched()
    local last_researched = nil
    for tech_key, technology in pairs(self.techs) do
        if technology.researched then
            if last_researched == nil then
                last_researched = technology
            else
                if technology.tier > last_researched.tier then
                    last_researched = technology
                else
                end
            end
        end
    end
    return last_researched
end

function ResearchCategoryClass:HasAtLeastOneTechUnlocked()
    for tech_key, technology in pairs(self.techs) do
        if technology.researched then
            return true
        end
    end
    return false
end

function ResearchCategory(key, name, manager)
    assert(key ~= nil, "ResearchCategory must be passed a valid key")
    assert(name ~= nil, "ResearchCategory must be passed a valid name")
    assert(manager ~= nil, "ResearchCategory must be passed a valid manager table/object")
    assert(type(manager) == 'table', "ResearchCategory must be passed a valid manager table/object")
    local newResearchCategory = table.Copy(ResearchCategoryClass)
    newResearchCategory.key = key
    newResearchCategory.name = name
    newResearchCategory.manager = manager
    --Return our new Object.
    return newResearchCategory
end

