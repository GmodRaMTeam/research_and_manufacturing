---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Комерад.
--- DateTime: 5/23/2018 6:00 PM
---

AddCSLuaFile()

local available_names = {
	'Albert Einstein',
	'Gordon Freeman',
	'Stephen Hawking',
	'Marie Curie',
	'Carl Frederick Gauss',
	'Robert Rosenthal',
	'Robert Openheimer',
	'Issac Newton',
	'Galileo Galilei',
	'Michael Faraday',
}

local function SelectName()
--	if #available_names == 0 then
--		return 'Generic Name Fred'
--	end
	local selected_name_index = math.random(1, #available_names)
	local name = table.remove(available_names, selected_name_index)
	if name == nil then
		return 'Generic Fred Durst'
	else
		return name
	end
end

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.Health = 100
ENT.Cost = 0

function ENT:Initialize()

	self:SetModel( "models/humans/group02/male_08.mdl" )
	self:SetHealth(100)

	--self.LoseTargetDist	= 2000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1000	-- How far to search for enemies

	if SERVER then
		self:SetDisplayName(SelectName())
	end

	self.Cost = math.random(10000, 35000)

end

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "Team" )
	self:NetworkVar( "String", 1, "DisplayName" )

end

function ENT:SetCost(cost)
	self.Cost = cost
end

function ENT:OnInjured( damageInfo )
	local attacker = damageInfo:GetAttacker()
	local inflictor = damageInfo:GetInflictor()
	damageInfo:SetDamage(0) -- WE NEVER GUNNA DIE
	if attacker:IsValid() and attacker:IsPlayer() then
		local TeamInfo = team.GetAllTeams()[attacker:Team()]
		if TeamInfo.ResearchManager.status ~= RESEARCH_STATUS_PREP then
			if attacker:Team() == self:GetTeam() then
				local message = "This scientist is on your team!"
				DynamicStatusUpdate(nil, message, 'error', attacker)
			else
				local weapon = attacker:GetActiveWeapon()
				if weapon:GetClass() == "weapon_stunstick" then
					local success = attacker:PickUpScientist(self:GetDisplayName(), self.Cost, self:GetTeam())
					if success then
						local message = "Your scientist "..self:GetDisplayName().." was taken from your research lab!"
						DynamicStatusUpdate(self:GetTeam(), message, 'kidnap', nil)
						self:Remove()
					end
				end
			end
		else
			local message = "Please wait for prep to end!"
			DynamicStatusUpdate(nil, message, 'error', attacker)
		end
	end
end

----------------------------------------------------
-- ENT:RunBehaviour()
-- This is where the meat of our AI is
----------------------------------------------------
function ENT:RunBehaviour()
	-- This function is called when the entity is first spawned, it acts as a giant loop that will run as long as the NPC exists
	while ( true ) do
		self:StartActivity( ACT_WALK )			-- Walk anmimation
		self.loco:SetDesiredSpeed( 100 )		-- Walk speed
		self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 32 ) -- Walk to a random place within about 32 units ( yielding )
		self:HandleStuck()
		self:StartActivity( ACT_IDLE )
		coroutine.wait( math.random(1, 2) )
		self:StartActivity( ACT_BUSY_QUEUE )
		coroutine.yield()
	end

end

if SERVER then

	function ENT:IsScientistSpawnpointSuitable(spawnpoint_pos)

	--	local Pos = spawnpointent:GetPos()

		-- Note that we're searching the default hull size here for a player in the way of our spawning.
		-- This seems pretty rough, seeing as our player's hull could be different.. but it should do the job
		-- (HL2DM kills everything within a 128 unit radius)
		local Ents = ents.FindInBox( spawnpoint_pos + Vector( -16, -16, 0 ), spawnpoint_pos + Vector( 16, 16, 64 ) )

	--	if ( pl:Team() == TEAM_SPECTATOR ) then return true end

		local Blockers = 0

		for k, v in pairs( Ents ) do
			if ( IsValid( v ) and v:GetClass() == "ram_simple_scientist" ) then

				Blockers = Blockers + 1

	--			if ( bMakeSuitable ) then
	--				v:Kill()
	--			end

			end
		end

	--	if ( bMakeSuitable ) then return true end
		if ( Blockers > 0 ) then return false end
		return true

	end

	function ENT:ScientistSelectSpawn(team)
		local spawn_class = ''

		if team == TEAM_BLUE then
			spawn_class = 'info_scientist_blue_spawn'
		else
			spawn_class = 'info_scientist_orange_spawn'
		end

		local SpawnPoints = ents.FindByClass(spawn_class)
		local ChosenSpawnPoint = nil

		for i=0,6 do
			ChosenSpawnPoint = table.Random(SpawnPoints)
			if ChosenSpawnPoint ~= nil then
				if (self:IsScientistSpawnpointSuitable(ChosenSpawnPoint:GetPos())) then
					return ChosenSpawnPoint:GetPos()
				end
			end
		end
	end

	function ENT:ReturnToBase()
		local pos = self:ScientistSelectSpawn(self:GetTeam())
		if pos ~= nil then
			timer.Simple( 5, function()
				self:SetPos(pos)
			end )
		end
	end

end

list.Set( "NPC", "ram_simple_scientist", {
	Name = "Simple Scientist",
	Class = "ram_simple_scientist",
	Category = "NextBot"
} )
