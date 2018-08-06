--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 2:18 PM
-- To change this template use File | Settings | File Templates.
--

include( "research_category.lua" )

-------------------------------------------------

local ResearchManagerClass = {}
ResearchManagerClass.team_index = nil -- Changes on constructor
ResearchManagerClass.team_name = nil -- Changes on constructor
ResearchManagerClass.status = RESEARCH_STATUS_PREP -- Status, defaults to waiting
--ResearchManagerClass.current_cost = 0 -- Current research time cost, defaults to 0
ResearchManagerClass.categories = {} -- Array of categories.

net.Receive("RAM_RequestClientTechnologyUpdate", function(len, pl)
    -- Make sure the player calling this is a valid entity, and a valid player, on a team.
    if (IsValid(pl) and pl:IsPlayer()) and (pl:Team() == TEAM_BLUE or pl:Team() == TEAM_ORANGE) then
        local cat_key = net.ReadString()
        local tech_key = net.ReadString()
        local plyTeamResearchManager = team.GetAllTeams()[pl:Team()].ResearchManager
        if plyTeamResearchManager:IsValidCategoryAndTechnology(cat_key, tech_key) then
            plyTeamResearchManager:SendClientStatusUpdate(cat_key, tech_key, pl)
        end
    end
end)

net.Receive("RAM_RequestClientUpdateEntireResearchTable", function(len, pl)
    if (IsValid(pl) and pl:IsPlayer()) and (pl:Team() == TEAM_BLUE or pl:Team() == TEAM_ORANGE) then
        local plyTeamResearchManager = team.GetAllTeams()[pl:Team()].ResearchManager
        plyTeamResearchManager:UpdateClientTable(pl)
    end
end)

-- This might be an expensive dumb idea
function ResearchManagerClass:SendClientStatusUpdate(cat_key, tech_key, calling_ply)
    local boolResearched = self.categories[cat_key].techs[tech_key].researched
    local intVoteCount = #self.categories[cat_key].techs[tech_key].votes
    net.Start('RAM_ServerTechnologyUpdate', true)
    net.WriteInt(calling_ply:Team(), 12)
    net.WriteString(cat_key)
    net.WriteString(tech_key)
    net.WriteBool(boolResearched)
    net.WriteInt(intVoteCount, 8)
    net.Send(calling_ply)
    print("-----------------------------------------------------------------")
    print("Sending shit from server")
    print(cat_key)
    print(tech_key)
    print(calling_ply:Nick())
    print(boolResearched)
    print(intVoteCount)
--    print(calling_ply:Nick())
    print("-----------------------------------------------------------------")
end

-- This might be an expensive dumb idea
function ResearchManagerClass:SendClientTeamStatusUpdate(cat_key, tech_key)
--    print("Doing some team updates")
    for k, ply in pairs(player.GetAll()) do
        if IsValid(ply) and ply:Team() == self.team_index then
            self:SendClientStatusUpdate(cat_key, tech_key, ply)
        end
    end
end

function ResearchManagerClass:UpdateClientTable(ply)
    for cat_key, category in pairs(self.categories) do
        for tech_key, technology in pairs(category.techs) do
            self:SendClientStatusUpdate(cat_key, tech_key, ply)
        end
    end
end

function ResearchManagerClass:IsValidCategoryAndTechnology(cat_key, tech_key)
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


function ResearchManagerClass:AddCategory(args)
    --key, name, manager
    if args.manager == nil then
        args.manager = self
    end
    local newResearchCategory = ResearchCategory(args)
    self.categories[args.key] = newResearchCategory -- Add to our categories
    return newResearchCategory -- Return our category to do something with it
end


function ResearchManagerClass:TeamAutoPickResearch()
    local success = false
    -- If this gets called but we chose some research!
    if self.status == RESEARCH_STATUS_IN_PROGRESS then
        return
    end
    local random_category, cat_key = table.Random( self.categories )
--    for cat_key, category in pairs(self.categories) do
    for tech_key, technology in pairs(random_category.techs) do
        if technology:CanDoResearch() then
            self:TeamDoResearch(cat_key, tech_key)
            success = true
        end
    end
    if not success then -- If we don't succeed, try again
        self:TeamAutoPickResearch()
    end
--    end
end


function ResearchManagerClass:CompleteResearch(cat_key, tech_key)
    local technology = self.categories[cat_key].techs[tech_key]

    local msg = "Completed research: " .. technology.name .. "! Begin voting for next tech!"
    DynamicStatusUpdate(self.team_index, msg, 'voting', nil)

    technology.researched = true
    self.status = RESEARCH_STATUS_VOTING

    self:ResetVoteCount()

    self:SendClientTeamStatusUpdate(cat_key, tech_key)
    ClientStatusUpdate(self.status, self.team_index)

    local menu_vote_time = GetConVar("ram_vote_time_limit_seconds"):GetInt()
    timer.Create("Team"..self.team_index.."VoteMenuTimeLimit", menu_vote_time, 1, function() self:TallyVotes() end)
end


function ResearchManagerClass:TeamDoResearch(cat_key, tech_key)
    local technology = self.categories[cat_key].techs[tech_key]
    local TeamInfo = team.GetAllTeams()[self.team_index]
    self.status = RESEARCH_STATUS_IN_PROGRESS
    local msg = "Research started on "..technology.name.."!"
    DynamicStatusUpdate(self.team_index, msg, 'success', nil)
    ClientStatusUpdate(self.status, self.team_index)
    local research_cost = technology.cost - (5 * TeamInfo.Scientists)
--    print("RESEARCH COST WAS: "..research_cost.."!!!!")
    timer.Create("Team" .. self.team_index .. "ResearchTimer", research_cost, 1, function() self:CompleteResearch(cat_key, tech_key) end)
end


function ResearchManagerClass:TallyVotes()
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
        DynamicStatusUpdate(self.team_index, msg, 'warning', nil)
        self:TeamAutoPickResearch()
    else
        local technology = self.categories[temp_current_winner.cat_key].techs[temp_current_winner.tech_key]
        -- Remove our timer if it is there
        if timer.Exists("Team" .. self.team_index .. "ResearchAutoTimer") then
            timer.Remove("Team" .. self.team_index .. "ResearchAutoTimer")
        end
        self:TeamDoResearch(temp_current_winner.cat_key, temp_current_winner.tech_key)
    end
end


function ResearchManagerClass:ResetVoteCount()
    for cat_key, category in pairs(self.categories) do
        for tech_key, technology in pairs(category.techs) do
            technology.votes = {}
        end
    end
end


function ResearchManagerClass:HasUserVoted(player_steamid)
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


function ResearchManagerClass:MakeMoney()
--    print("Make money called")
    local TeamInfo = team.GetAllTeams()[self.team_index]
    TeamInfo.Money = TeamInfo.Money + (200 + (100 * TeamInfo.Scientists))
    self:SendTeamMoneyUpdate()
end


function ResearchManagerClass:SendTeamMoneyUpdate()
    local TeamInfo = team.GetAllTeams()[self.team_index]
    net.Start("RAM_MakeMoney")
    net.WriteInt(self.team_index, 3)
    net.WriteInt(TeamInfo.Money, 21)
    net.Broadcast()
end


function ResearchManagerClass:StartResearchAndMoneyMaking()
    timer.Create('RAM_Team' .. self.team_index .. "MoneyCycleTimer", 15, 0, function()
        self:MakeMoney()
    end)
    self.status = RESEARCH_STATUS_VOTING
    local menu_vote_time = GetConVar("ram_vote_time_limit_seconds"):GetInt()
    timer.Create("Team" .. self.team_index .. "VoteMenuTimeLimit", menu_vote_time, 1, function() self:TallyVotes() end)
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

--====================================================================================================================--
--                                                                                                                    --
--====================================================================================================================--

net.Receive("RAM_RecordResearchVote", function(len, ply)
--    DynamicStatusUpdate(ply:Team(), 'Test', 'success', nil)

	local research_cat = net.ReadString()
	local research_index = net.ReadString()
    local AllTeams = team.GetAllTeams()
    local TeamInfo = AllTeams[ply:Team()]

    local ply_has_voted = TeamInfo.ResearchManager:HasUserVoted(ply:SteamID())
    local tech = TeamInfo.ResearchManager.categories[research_cat].techs[research_index]

    if not ply_has_voted then
        if tech:CanDoResearch() and not tech.researched then
            table.insert(tech.votes, ply:SteamID())
            local research_name = tech.name
            local msg = "Vote recorded for " .. research_name .. " by " .. ply:Nick() .. "!"
            DynamicStatusUpdate(ply:Team(), msg, 'success', nil)
            ClientStatusUpdateToPlayer(RESEARCH_STATUS_CLIENT_VOTED, ply:Team(), ply)
        else
            local msg = "You are un-able to currently research that!"
            DynamicStatusUpdate(nil, msg, 'error', ply)
        end
    else
        local msg = "Please wait until the next voting session to vote again!"
        DynamicStatusUpdate(nil, msg, 'error', ply)
    end
end)