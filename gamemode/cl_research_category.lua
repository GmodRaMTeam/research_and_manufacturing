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
ClientResearchCategoryClass.techs = {} -- Default empty array
ClientResearchCategoryClass.manager = nil

function ClientResearchCategoryClass:AddTechnology(key, cost, tier, reqs)
    local newResearchTechnology = ClientResearchTechnology(key, cost, tier, reqs, self)
    self.techs[key] = newResearchTechnology-- Add to our categories
    return newResearchTechnology-- Return our category to do something with it
end

function ClientResearchCategoryClass:GetHighestTechResearched()
    local last_researched = nil
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    PrintTable(self.techs)
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    for tech_key, technology in pairs(self.techs) do
        print(tech_key)
        PrintTable(technology)
        if technology.researched then
            if last_researched == nil then
                last_researched = technology
            else
                print("IS "..technology.tier.." GREATER THAN "..last_researched.tier.."????")
                if technology.tier > last_researched.tier then
                    last_researched = technology
                else
                    print("WE DUN NOTHING")
                end
            end
        end
    end
    print("LAST RESEARCHED IS")
--    PrintTable(last_researched)
    print(last_researched.key)
    PrintTable(last_researched)
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

function ClientResearchCategory(key, name, manager)
    assert(key ~= nil, "ClientResearchCategory must be passed a valid key")
    assert(name ~= nil, "ClientResearchCategory must be passed a valid name")
    assert(manager ~= nil, "ClientResearchCategory must be passed a valid manager table/object")
    assert(type(manager) == 'table', "ClientResearchCategory must be passed a valid manager table/object")
    local newClientResearchCategory = table.Copy(ClientResearchCategoryClass)
    newClientResearchCategory.key = key
    newClientResearchCategory.name = name
    newClientResearchCategory.manager = manager
    --Return our new Object.
    return newClientResearchCategory
end

