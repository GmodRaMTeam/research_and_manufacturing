--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/23/2018
-- Time: 2:18 PM
-- To change this template use File | Settings | File Templates.
--

include( "research_category.lua" )

util.AddNetworkString("RMStartTeamResearch")
util.AddNetworkString("RMRecordResearchVote")
util.AddNetworkString("RMClientStatusUpdate")
util.AddNetworkString("RMPrintToTeam")

-------------------------------------------------

local ResearchManagerClass = {}
ResearchManagerClass.team_index = nil -- Changes on constructor
ResearchManagerClass.team_name = nil -- Changes on constructor
ResearchManagerClass.last_time = CurTime() -- Last research time, defaults to the current time
ResearchManagerClass.last_vote_time = CurTime() -- Last vote time, defaults to the current time
ResearchManagerClass.status = RESEARCH_STATUS_WAITING -- Status, defaults to waiting
ResearchManagerClass.current_cost = 0 -- Current research time cost, defaults to 0
ResearchManagerClass.categories = {} -- Array of categories.

function ResearchManagerClass:AddCategory(key, name)
    local newResearchCategory = ResearchCategory(key, name, self)
    self.categories[key] = newResearchCategory -- Add to our categories
    return newResearchCategory -- Return our category to do something with it
end


function ResearchManagerClass:TeamAutoPickResearch()
    -- If this gets called but we chose some research!
    if self.status == RESEARCH_STATUS_IN_PROGRESS then
        return
    end
    for cat_key, category in pairs(self.categories) do
        for tech_key, technology in pairs(category.techs) do
            if technology:CanDoResearch() then
                local research_cost = technology.cost
                self:TeamDoResearch(cat_key, tech_key)
                PrintMessage( HUD_PRINTTALK, self.team_name.." team has started research: "..technology.name.."!" )
            end
        end
    end
end


function ResearchManagerClass:CompleteResearch(cat_key, tech_key)
    local technology = self.categories[cat_key].techs[tech_key]
    PrintMessage(HUD_PRINTTALK, "Team " .. self.team_name .. " has completed research " .. technology.name .. ".")
    technology.researched = true
    self.status = RESEARCH_STATUS_WAITING
    ClientStatusUpdate(RESEARCH_STATUS_WAITING, self.team_index)
    self:ResetVoteCount()
--    local auto_vote_time = GetConVar("rm_auto_vote_time_seconds"):GetInt()
--    timer.Create("Team" .. self.team_index .. "ResearchAutoTimer", auto_vote_time, 1, function() self:TeamAutoPickResearch() end)
    local menu_vote_time = GetConVar("rm_vote_time_limit_seconds"):GetInt()
    timer.Create("Team" .. self.team_index .. "VoteMenuTimeLimit", menu_vote_time, 1, function() self:TallyVotes() end)
end


function ResearchManagerClass:TeamDoResearch(cat_key, tech_key)
    local technology = self.categories[cat_key].techs[tech_key]
    self.last_vote_time = CurTime()
    self.last_time = CurTime()
    self.status = RESEARCH_STATUS_IN_PROGRESS
    self.current_cost = technology.cost
    ClientStatusUpdate(RESEARCH_STATUS_IN_PROGRESS, self.team_index)
    timer.Create("Team" .. self.team_index .. "ResearchTimer", technology.cost, 1, function() self:CompleteResearch(cat_key, tech_key) end)
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
        -- Call auto-mated vote
        print("Auto vote!")
        self:TeamAutoPickResearch()
    else
        local technology = self.categories[temp_current_winner.cat_key].techs[temp_current_winner.tech_key]
        PrintMessage( HUD_PRINTTALK, self.team_name.." team has started research: "..technology.name.."!" )
        -- Remove our timer if it is there
        if timer.Exists("Team" .. self.team_index .. "ResearchAutoTimer") then
            timer.Remove("Team" .. self.team_index .. "ResearchAutoTimer")
        end
--        local research_time = self.categories[temp_current_winner.cat_key].techs[temp_current_winner.tech_key].cost
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


function ResearchManager(team_index, team_name)
    print("Team index is: "..team_index)
    print("Team name is "..team_name)
    assert(team_index ~= nil, "ResearchManager must be passed a valid team_index")
    assert(team_name ~= nil, "ResearchManager must be passed a valid team_name")
    local newResearchManager = table.Copy(ResearchManagerClass)
    newResearchManager.team_index = team_index
    newResearchManager.team_name = team_name
    --Return our new Object.
    return newResearchManager
end

--====================================================================================================================--
--                                                                                                                    --
--====================================================================================================================--

net.Receive("RMRecordResearchVote", function(len, ply)
	local research_cat = net.ReadString()
	local research_index = net.ReadString()
    local TeamInfo = GetTeamInfoTable(ply:Team())

    local ply_has_voted = TeamInfo.ResearchManager:HasUserVoted(ply:SteamID())
    local tech = TeamInfo.ResearchManager.categories[research_cat].techs[research_index]

--    if not ply_has_voted and TeamInfo.ResearchManager:TeamCanDoResearch(research_cat, research_index) then
    if not ply_has_voted and tech:CanDoResearch() and not tech.researched then
        table.insert(tech.votes, ply:SteamID())
        local research_name = tech.name
        PrintMessage(HUD_PRINTTALK, "Vote recorded for " .. research_name .. " by " .. ply:Nick() .. "!")
    else
        local difference = (CurTime() - (TeamInfo.ResearchManager.last_vote_time))
        print(difference)
    end
end)