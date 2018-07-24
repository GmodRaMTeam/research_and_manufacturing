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

function ResearchCategoryClass:AddTechnology(key, name, description, cost)
    local newResearchTechnology = ResearchTechnology(key, name, description, cost, self)
    self.techs[key] = newResearchTechnology-- Add to our categories
    return newResearchTechnology-- Return our category to do something with it
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

