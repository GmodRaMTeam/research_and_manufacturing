--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/24/2018
-- Time: 4:20 PM
-- To change this template use File | Settings | File Templates.
--

AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.Spawnable = true
ENT.Team = nil -- This needs set after being made

function ENT:Initialize()
    self:SetHealth(10000)
    self:SetModel("models/gman.mdl")
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Team")
end

function ENT:OnInjured( damageInfo )
	local attacker = damageInfo:GetAttacker()
	local inflictor = damageInfo:GetInflictor()
    damageInfo:SetDamage(0) -- WE NEVER GUNNA DIE
	if attacker:IsValid() and attacker:IsPlayer() then
		if attacker:Team() == self:GetTeam() then
			local message = "This Overseer is on your team idiot!"
			DynamicStatusUpdate(nil, message, 'error', attacker.Player)
--			damageInfo:SetDamage(0)
		end -- WHY YO HITTING OUR SCIENTISTS
	end
end

function ENT:RunBehaviour()

    while (true) do -- Here is the loop, it will run forever

        self:StartActivity(ACT_IDLE) -- Idle animation
        coroutine.wait(2) -- Pause for 2 seconds

        coroutine.yield()
        -- The function is done here, but will start back at the top of the loop and make the bot walk somewhere else
    end
end

function ENT:OnContact(ent)
    if ent:IsValid() and ent:IsPlayer() then
        if ent:Team() == self:GetTeam() then
            local data = ent:RemoveScientist()
            local status = data['status']
            local name = data['name']
            local cost = data['cost']
            local original_team = data['original_team']
            if status then
                if name ~= nil and cost ~= nil and original_team ~= nil then
                    local message = "Your team-member " .. ent:Nick() .. " has recruited a new scientist: " .. name .. "!"
                    DynamicStatusUpdate(self.Team, message, 'success', nil)
                    -- Something to do here
                    print("Overseer is sending name"..name..".")
                    CaptureScientist(self:GetTeam(), name, cost, original_team)
                else

                end
            else
            end
        end
    end
end

list.Set("NPC", "ram_overseer", {
    Name = "Simple Overseer",
    Class = "ram_overseer",
    Category = "NextBot"
})

