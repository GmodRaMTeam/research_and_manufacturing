--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 2:18 PM
-- To change this template use File | Settings | File Templates.
--

include( "cl_research_technology.lua" )

local ClientResearchCategoryClass = {}
ClientResearchCategoryClass.key = '' -- Default empty string
ClientResearchCategoryClass.name = '' -- Default empty string
ClientResearchCategoryClass.icon = '' -- Default empty string, set to a semantic ui icon
ClientResearchCategoryClass.techs = {} -- Default empty array
ClientResearchCategoryClass.manager = nil

function ClientResearchCategoryClass:AddTechnology(args)
    -- key, name, description, cost, tier, reqs, category
    if args.category == nil then
        args.category = self
    end
    local newResearchTechnology = ClientResearchTechnology(args)
    self.techs[args.key] = newResearchTechnology-- Add to our categories
    return newResearchTechnology-- Return our category to do something with it
end

function ClientResearchCategoryClass:GetHighestTechResearched()
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

function ClientResearchCategoryClass:HasAtLeastOneTechUnlocked()
    for tech_key, technology in pairs(self.techs) do
        if technology.researched then
            return true
        end
    end
    return false
end

function ClientResearchCategory(args)
    -- key, name, icon, manager
    assert(args.key ~= nil, "ClientResearchCategory must be passed a valid key")
    assert(args.name ~= nil, "ClientResearchCategory must be passed a valid name")
    assert(args.icon ~= nil, "ClientResearchCategory must be passed a valid icon")
    assert(args.manager ~= nil, "ClientResearchCategory must be passed a valid manager table/object")
    assert(type(args.manager) == 'table', "ClientResearchCategory must be passed a valid manager table/object")
    local newClientResearchCategory = table.Copy(ClientResearchCategoryClass)
    newClientResearchCategory.key = args.key
    newClientResearchCategory.name = args.name
    newClientResearchCategory.icon = args.icon
    newClientResearchCategory.manager = args.manager
    --Return our new Object.
    return newClientResearchCategory
end

