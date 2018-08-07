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
ClientResearchManagerClass.status = RESEARCH_STATUS_PREP -- Status, defaults to waiting
ClientResearchManagerClass.categories = {} -- Array of categories.

function ClientResearchManagerClass:add_category(args)
    -- key, name, icon, manager
    if args.manager == nil then
        args.manager = self
    end
    local newClientResearchCategory = ClientResearchCategory(args)
    self.categories[args.key] = newClientResearchCategory -- Add to our categories
    return newClientResearchCategory -- Return our category to do something with it
end


function ClientResearchManagerClass:to_JSON()
    local temp_data = {}
    for cat_key, category in pairs(self.categories) do
        local cat_key_index = table.insert(temp_data, {
            key=cat_key,
            name=category.name,
            icon=category.icon,
            techs={},
        })
        for tech_key, technology in pairs(self.categories[cat_key].techs) do
            local temp_list_reqs = {}
            for index, req_key in ipairs(technology.reqs) do
                table.insert(temp_list_reqs, category.techs[req_key].name)
            end
            local tech_key_index = table.insert(temp_data[cat_key_index].techs, {
                key=tech_key,
                name=technology.name,
                description=technology.description,
                tier=technology.tier,
                cost=technology.cost,
                reqs=temp_list_reqs,
                votes=technology.votes,
                can_research=(technology:can_do_research() and not technology.researched),
--                researched=technology.researched
            })
            print(tostring((technology:can_do_research() and not technology.researched)))
        end
    end
    local temp_data_json = util.TableToJSON(temp_data)
    return temp_data_json
end


function ClientResearchManager(args)
    -- team_index, team_name
    assert(args.team_index ~= nil, "ClientResearchManager must be passed a valid team_index")
    assert(args.team_name ~= nil, "ClientResearchManager must be passed a valid team_name")
    local newClientResearchManager = table.Copy(ClientResearchManagerClass)
    newClientResearchManager.team_index = args.team_index
    newClientResearchManager.team_name = args.team_name
    --Return our new Object.
    return newClientResearchManager
end
