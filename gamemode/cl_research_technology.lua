--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 2:18 PM
-- To change this template use File | Settings | File Templates.
--


local ClientResearchTechnologyClass = {}
ClientResearchTechnologyClass.key = '' -- Default empty string
ClientResearchTechnologyClass.name = '' -- Default empty string
ClientResearchTechnologyClass.description = '' -- Default empty string
ClientResearchTechnologyClass.cost = 60 -- Default of 60
ClientResearchTechnologyClass.tier = 60 -- Default of 60
ClientResearchTechnologyClass.researched = false -- Default of false
ClientResearchTechnologyClass.reqs = {} -- Defaults to empty array/table
ClientResearchTechnologyClass.votes = 0 -- Defaults to empty array/table
ClientResearchTechnologyClass.category = nil

function ClientResearchTechnologyClass:request_server_update()
    print("Requesting server update")
    net.Start("RAMCL_request_technology_update")
    net.WriteString(self.category.key)
    net.WriteString(self.key)
    net.SendToServer()
end


function ClientResearchTechnologyClass:update_from_server(is_researched, vote_count)
    self.researched = is_researched
    self.votes = vote_count
end


function ClientResearchTechnologyClass:requirements_met()
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


function ClientResearchTechnologyClass:can_do_research()
    local manager = self.category.manager
    --    if (manager.status == RESEARCH_STATUS_VOTING) then
    -- If we have researched it, return false, if not keep going
    if self.researched then return false end
    if self:requirements_met() then
        return true
    else
        return false
    end
end

function ClientResearchTechnology(args)
    -- key, name, description, cost, tier, reqs, category
    assert(args.key ~= nil, "ClientResearchTechnology must be passed a valid key")
    assert(args.name ~= nil, "ClientResearchTechnology must be passed a valid name")
    assert(args.tier ~= nil, "ClientResearchTechnology must be passed a valid tier")
    assert(args.description ~= nil, "ClientResearchTechnology must be passed a valid description")
    assert(args.category ~= nil, "ClientResearchTechnology must be passed a valid ResearchCategory table/object")
    assert(type(args.category) == 'table', "ClientResearchTechnology must be passed a valid ResearchCategory table/object")
    local newClientResearchTechnology = table.Copy(ClientResearchTechnologyClass)
    newClientResearchTechnology.key = args.key
    newClientResearchTechnology.name = args.name
    newClientResearchTechnology.tier = args.tier
    newClientResearchTechnology.description = args.description
    newClientResearchTechnology.category = args.category
    -- Cost is optional
    if args.cost ~= nil then
        newClientResearchTechnology.cost = args.cost
    end
    if args.reqs ~= nil then
        assert(type(args.reqs) == 'table', "ClientResearchTechnology must be passed a valid table/object for reqs")
        newClientResearchTechnology.reqs = args.reqs
    end
    --Return our new Object.
    return newClientResearchTechnology
end
