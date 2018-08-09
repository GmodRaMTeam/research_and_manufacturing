--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 2:18 PM
-- To change this template use File | Settings | File Templates.
--

include( "sv_research_category.lua" )

-------------------------------------------------

local ResearchManagerClass = {}
ResearchManagerClass.team_index = nil -- Changes on constructor
ResearchManagerClass.team_name = nil -- Changes on constructor
ResearchManagerClass.status = RESEARCH_STATUS_PREP -- Status, defaults to waiting
--ResearchManagerClass.current_cost = 0 -- Current research time cost, defaults to 0
ResearchManagerClass.categories = {} -- Array of categories.


-- This might be an expensive dumb idea
function ResearchManagerClass:send_client_technology_update(cat_key, tech_key)
    local boolResearched = self.categories[cat_key].techs[tech_key].researched
    local intVoteCount = #self.categories[cat_key].techs[tech_key].votes
    net.Start('RAM_technology_update', true)
    net.WriteInt(self.team_index, 12)
    net.WriteString(cat_key)
    net.WriteString(tech_key)
    net.WriteBool(boolResearched)
    net.WriteInt(intVoteCount, 8)
--    net.Send(calling_ply)
    net.Broadcast()
    -- Broadcasting becasue this might make more sense for clients swithcing teams, etc
end

-- This might be an expensive dumb idea
function ResearchManagerClass:send_team_client_technology_update(cat_key, tech_key)
--    for k, ply in pairs(player.GetAll()) do
--        if IsValid(ply) and ply:Team() == self.team_index then
--            self:send_client_technology_update(cat_key, tech_key, ply)
--        end
--    end
    self:send_client_technology_update(cat_key, tech_key)
end

function ResearchManagerClass:update_client_table()
    for cat_key, category in pairs(self.categories) do
        for tech_key, technology in pairs(category.techs) do
            self:send_client_technology_update(cat_key, tech_key)
        end
    end
end

function ResearchManagerClass:is_valid_cat_tech_pair(cat_key, tech_key)
    if cat_key ~= nil and #cat_key > 0 then
        if tech_key ~= nil and #tech_key > 0 then
            local cat_keys = table.GetKeys( self.categories )
            for index_cat, temp_cat_key in ipairs(cat_keys) do
                if cat_key == temp_cat_key then
                    local tech_keys = table.GetKeys( self.categories[temp_cat_key].techs )
                    for index_tech, temp_tech_key in ipairs(tech_keys) do
                        if tech_key == temp_tech_key then
                            return true
                        end
                    end
                end
            end
        end
    end
end


function ResearchManagerClass:add_category(args)
    --key, name, manager
    if args.manager == nil then
        args.manager = self
    end
    local newResearchCategory = ResearchCategory(args)
    self.categories[args.key] = newResearchCategory -- Add to our categories
    return newResearchCategory -- Return our category to do something with it
end


function ResearchManagerClass:auto_pick_research()
    local success = false
    -- If this gets called but we chose some research!
    if self.status == RESEARCH_STATUS_IN_PROGRESS then
        return
    end
    local random_category, cat_key = table.Random( self.categories )
--    for cat_key, category in pairs(self.categories) do
    for tech_key, technology in pairs(random_category.techs) do
        if technology:can_do_research() then
            self:do_research(cat_key, tech_key)
            success = true
        end
    end
    if not success then -- If we don't succeed, try again
        self:auto_pick_research()
    end
--    end
end


function ResearchManagerClass:complete_research(cat_key, tech_key)
    -- First things first, update our technology.
    local technology = self.categories[cat_key].techs[tech_key]
    technology.researched = true

    -- Then check if we're done resarching eeeeevvvveryyythinggggg
    if self:are_all_techs_researched() then
        self.status = RESEARCH_STATUS_WAITING
        -- Send our team an update!
        local msg = "Completed research: " .. technology.name .. "! Appears you've finished all current contracts!"
        ram_dynamic_status_update(self.team_index, msg, 'warning', nil)
        -- Reset vote count, send client updated tech values, and send client the new status
        self:reset_votes()
        self:send_team_client_technology_updatee(cat_key, tech_key)
        ram_client_status_update(self.status, self.team_index)
    else
        self.status = RESEARCH_STATUS_VOTING
        -- Send our team an update!
        local msg = "Completed research: " .. technology.name .. "! Begin voting for next tech!"
        ram_dynamic_status_update(self.team_index, msg, 'voting', nil)
        -- Reset vote count, send client updated tech values, and send client the new status
        self:reset_votes()
        self:send_team_client_technology_update(cat_key, tech_key)
        ram_client_status_update(self.status, self.team_index)
        -- Create our new timer for the next vote cycle
        local menu_vote_time = GetConVar("ram_vote_time_limit_seconds"):GetInt()
        timer.Create("Team" .. self.team_index .. "VoteMenuTimeLimit", menu_vote_time, 1, function() self:tally_votes() end)
    end
end


function ResearchManagerClass:do_research(cat_key, tech_key)
    local technology = self.categories[cat_key].techs[tech_key]
    local TeamInfo = team.GetAllTeams()[self.team_index]
    self.status = RESEARCH_STATUS_IN_PROGRESS
    local msg = "Research started on "..technology.name.."!"
    ram_dynamic_status_update(self.team_index, msg, 'success', nil)
    ram_client_status_update(self.status, self.team_index)
    local research_cost = technology.cost - (5 * TeamInfo.Scientists)
    timer.Create("Team" .. self.team_index .. "ResearchTimer", research_cost, 1, function() self:complete_research(cat_key, tech_key) end)
    self:sync_team_research_timer(research_cost)
end


function ResearchManagerClass:tally_votes()
    -- Setup a temp table to track our values
    local temp_current_winner = {}
    temp_current_winner.value = 0
    temp_current_winner.cat_key = nil
    temp_current_winner.tech_key = nil

    for cat_key, category in pairs(self.categories) do
        for tech_key, technology in pairs(category.techs) do
            -- If our current value is the default shit
            if temp_current_winner.value == 0 or temp_current_winner.cat_key == nil or temp_current_winner.tech_key == nil then
                -- Don't bother assigning a temp winner if their score isn't above 0
                if #technology.votes > 0 then
                    temp_current_winner.value = #technology.votes
                    temp_current_winner.cat_key = cat_key
                    temp_current_winner.tech_key = tech_key
                end
            else
                if #technology.votes > 0 then
                    if #technology.votes > temp_current_winner.value then
                        temp_current_winner.value = #technology.votes
                        temp_current_winner.cat_key = cat_key
                        temp_current_winner.tech_key = tech_key
                    end
                end
            end
        end
    end
    if temp_current_winner.value == 0 or temp_current_winner.cat_key == nil or temp_current_winner.tech_key == nil then
        local msg = "Your team had research automatically chosen, because no-one voted."
        ram_dynamic_status_update(self.team_index, msg, 'warning', nil)
        self:auto_pick_research()
    else
        local technology = self.categories[temp_current_winner.cat_key].techs[temp_current_winner.tech_key]
        -- Remove our timer if it is there
        if timer.Exists("Team" .. self.team_index .. "ResearchAutoTimer") then
            timer.Remove("Team" .. self.team_index .. "ResearchAutoTimer")
        end
        self:do_research(temp_current_winner.cat_key, temp_current_winner.tech_key)
    end
end


function ResearchManagerClass:reset_votes()
    for cat_key, category in pairs(self.categories) do
        for tech_key, technology in pairs(category.techs) do
            technology.votes = {}
        end
    end
end


function ResearchManagerClass:has_user_voted(player_steamid)
    for cat_key, category in pairs(self.categories) do
        for tech_key, technology in pairs(category.techs) do
            for vote_index, vote in pairs(technology.votes) do
                if vote == player_steamid then
                    return true
                end
            end
        end
    end
    return false
end


function ResearchManagerClass:make_money()
    local TeamInfo = team.GetAllTeams()[self.team_index]
    TeamInfo.Money = TeamInfo.Money + (200 + (100 * TeamInfo.Scientists))
    self:send_team_money_update()
end


function ResearchManagerClass:send_team_money_update()
    local TeamInfo = team.GetAllTeams()[self.team_index]
    net.Start("RAM_make_money")
    net.WriteInt(self.team_index, 3)
    net.WriteInt(TeamInfo.Money, 21)
    net.Broadcast()
end


function ResearchManagerClass:start_research_cycle()
    timer.Create('RAM_Team' .. self.team_index .. "MoneyCycleTimer", GetConVar("ram_money_cycle_time_seconds"):GetInt(), 0, function()
        self:make_money()
    end)
    self.status = RESEARCH_STATUS_VOTING
    local menu_vote_time = GetConVar("ram_vote_time_limit_seconds"):GetInt()
    timer.Create("Team" .. self.team_index .. "VoteMenuTimeLimit", menu_vote_time, 1, function() self:tally_votes() end)
end

function ResearchManagerClass:are_all_techs_researched()
    for cat_key, category in pairs(self.categories) do
        for tech_key, technology in pairs(category.techs) do
            if not technology.researched then return false end
        end
    end
    return true
end

function ResearchManagerClass:sync_team_research_timer()
    if timer.Exists("Team" .. self.team_index .. "ResearchTimer") then
        local research_cost = timer.TimeLeft("Team" .. self.team_index .. "ResearchTimer")
        print("Syncing timers with players")
        for k, ply in pairs(player.GetAll()) do
            if IsValid(ply) and ply:Team() == self.team_index then
                net.Start("RAM_sync_research_timer")
                net.WriteInt(research_cost, 12)
                net.Send(ply)
            end
        end
    end
end

function ResearchManagerClass:sync_player_research_timer(ply)
    if timer.Exists("Team" .. self.team_index .. "ResearchTimer") then
        local research_cost = timer.TimeLeft("Team" .. self.team_index .. "ResearchTimer")
        if IsValid(ply) and ply:Team() == self.team_index then
            net.Start("RAM_sync_research_timer")
            net.WriteInt(research_cost, 12)
            net.Send(ply)
            print("WE SENT A PLAYER RESEARCH TIMER")
        end
    end
end

function ResearchManager(args)
    -- team_index, team_name
    assert(args.team_index ~= nil, "ResearchManager must be passed a valid team_index")
    assert(args.team_name ~= nil, "ResearchManager must be passed a valid team_name")
    local newResearchManager = table.Copy(ResearchManagerClass)
    newResearchManager.team_index = args.team_index
    newResearchManager.team_name = args.team_name

    --Return our new Object.
    return newResearchManager
end
