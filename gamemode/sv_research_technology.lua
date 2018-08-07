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
ResearchTechnologyClass.class = '' -- Default empty string
ResearchTechnologyClass.cost = nil
ResearchTechnologyClass.tier = 60 -- Default of 60
ResearchTechnologyClass.researched = false -- Default of false
ResearchTechnologyClass.reqs = {} -- Defaults to empty array/table
ResearchTechnologyClass.votes = {} -- Defaults to empty array/table
ResearchTechnologyClass.category = nil

function ResearchTechnologyClass:requirements_met()
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


function ResearchTechnologyClass:can_do_research()
    local manager = self.category.manager
    if (manager.status == RESEARCH_STATUS_VOTING) then
        -- If we have researched it, return false, if not keep going
        if self.researched then
            return false
        else
            if self:requirements_met() then
                return true
            else
                return false
            end
        end
    else
        return false
    end
end

function ResearchTechnology(args)
    -- key, name, description, class, cost, tier, reqs, category
    assert(args.key ~= nil, "ResearchTechnology must be passed a valid key")
    assert(args.name ~= nil, "ResearchTechnology must be passed a valid name")
    assert(args.tier ~= nil, "ResearchTechnology must be passed a valid tier")
    assert(args.category ~= nil, "ResearchTechnology must be passed a valid ResearchCategory table/object")
    assert(type(args.category) == 'table', "ResearchTechnology must be passed a valid ResearchCategory table/object")
    local newResearchTechnology = table.Copy(ResearchTechnologyClass)
    newResearchTechnology.key = args.key
    newResearchTechnology.name = args.name
    newResearchTechnology.tier = args.tier
    newResearchTechnology.category = args.category
    -- Cost is optional
    if args.cost ~= nil then
        newResearchTechnology.cost = args.cost
    else
        newResearchTechnology.cost = GetConVar("ram_research_time_seconds"):GetInt()
    end
    if args.reqs ~= nil then
        assert(type(args.reqs) == 'table', "ResearchTechnology must be passed a valid table/object for reqs")
        newResearchTechnology.reqs = args.reqs
    end
    if args.class ~= nil then
        assert(type(args.class) == 'string', "ResearchTechnology must be passed a valid string for field class.")
        newResearchTechnology.class = args.class
    end
    --Return our new Object.
    return newResearchTechnology
end
