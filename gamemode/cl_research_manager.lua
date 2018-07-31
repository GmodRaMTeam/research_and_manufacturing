--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 2:18 PM
-- To change this template use File | Settings | File Templates.
--

include( "cl_research_category.lua" )

-------------------------------------------------

local ClientResearchManagerClass = {}
ClientResearchManagerClass.team_index = nil -- Changes on constructor
ClientResearchManagerClass.team_name = nil -- Changes on constructor
ClientResearchManagerClass.last_time = CurTime() -- Last research time, defaults to the current time
ClientResearchManagerClass.last_vote_time = CurTime() -- Last vote time, defaults to the current time
ClientResearchManagerClass.status = RESEARCH_STATUS_WAITING -- Status, defaults to waiting
ClientResearchManagerClass.current_cost = 0 -- Current research time cost, defaults to 0
ClientResearchManagerClass.categories = {} -- Array of categories.

function ClientResearchManagerClass:AddCategory(key, name)
    local newClientResearchCategory = ClientClientResearchCategory(key, name, self)
    self.categories[key] = newClientResearchCategory -- Add to our categories
    return newClientResearchCategory -- Return our category to do something with it
end


function ClientResearchManager(team_index, team_name)
    assert(team_index ~= nil, "ClientResearchManager must be passed a valid team_index")
    assert(team_name ~= nil, "ClientResearchManager must be passed a valid team_name")
    local newClientResearchManager = table.Copy(ClientResearchManagerClass)
    newClientResearchManager.team_index = team_index
    newClientResearchManager.team_name = team_name
    --Return our new Object.
    return newClientResearchManager
end

--====================================================================================================================--
--                                                                                                                    --
--====================================================================================================================--