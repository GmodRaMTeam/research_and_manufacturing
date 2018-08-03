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


net.Receive("RAM_ServerTechnologyUpdate", function(len, pl)
    print("Got server update")
    -- Make sur ethe player calling this is a valid entity, and a valid player, on a team.
    local int_team = net.ReadInt(12)
    local cat_key = net.ReadString()
    local tech_key = net.ReadString()
    local is_researched = net.ReadBool()
    local vote_count = net.ReadInt(8)

    local researchManager = team.GetAllTeams()[int_team].ResearchManager
    researchManager.categories[cat_key].techs[tech_key]:UpdateFromServer(is_researched, vote_count)

end)


function ClientResearchTechnologyClass:RequestServerUpdate()
    print("Requesting server update")
    net.Start("RAM_RequestClientTechnologyUpdate")
    net.WriteString(self.category.key)
    net.WriteString(self.key)
    net.SendToServer()
end


function ClientResearchTechnologyClass:UpdateFromServer(is_researched, vote_count)
    print("Update from server")
    self.researched = is_researched
    self.votes = vote_count
end


function ClientResearchTechnologyClass:MeetsRequirements()
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


function ClientResearchTechnologyClass:CanDoResearch()
    local manager = self.category.manager
    --    if (manager.status == RESEARCH_STATUS_VOTING) then
    -- If we have researched it, return false, if not keep going
    if self.researched then
        return false
    else
        if self:MeetsRequirements() then
            return true
        else
            return false
        end
    end
    --    else
    --        return false
    --    end
end

function ClientResearchTechnology(key, name, description, cost, tier, reqs, category)
    assert(key ~= nil, "ClientResearchTechnology must be passed a valid key")
    assert(name ~= nil, "ClientResearchTechnology must be passed a valid name")
    assert(tier ~= nil, "ClientResearchTechnology must be passed a valid tier")
    assert(description ~= nil, "ClientResearchTechnology must be passed a valid description")
    assert(category ~= nil, "ClientResearchTechnology must be passed a valid ResearchCategory table/object")
    assert(type(category) == 'table', "ClientResearchTechnology must be passed a valid ResearchCategory table/object")
    local newClientResearchTechnology = table.Copy(ClientResearchTechnologyClass)
    newClientResearchTechnology.key = key
    newClientResearchTechnology.name = name
    newClientResearchTechnology.tier = tier
    newClientResearchTechnology.description = description
    newClientResearchTechnology.category = category
    -- Cost is optional
    if cost ~= nil then
        newClientResearchTechnology.cost = cost
    end
    if reqs ~= nil then
        assert(type(reqs) == 'table', "ClientResearchTechnology must be passed a valid table/object for reqs")
        newClientResearchTechnology.reqs = reqs
    end
    --Return our new Object.
    return newClientResearchTechnology
end
