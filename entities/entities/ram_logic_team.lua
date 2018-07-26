--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 7/24/2018
-- Time: 1:03 PM
-- To change this template use File | Settings | File Templates.
--

ENT.Type = "point"
ENT.Base = "base_point"

local TEAM_ANY = 3

ENT.Team = TEAM_ANY

function ENT:KeyValue(key, value)
    if key == "OnPass" or key == "OnFail" then
        -- this is our output, so handle it as such
        self:StoreOutput(key, value)
    elseif key == "Team" then
        self.Team = tonumber(value)

        if not self.Team then
            ErrorNoHalt("ram_logic_team: bad value for Team key, not a number\n")
            self.Team = TEAM_ANY
        end
    end
end


function ENT:AcceptInput(name, activator)
    if name == "TestActivator" then
        if IsValid(activator) and activator:IsPlayer() then
            --         local activator_role = (GetRoundState() == ROUND_PREP) and TEAM_INNOCENT or activator:GetRole()
            local activator_team = activator:Team()

            if self.Team == TEAM_ANY or self.Team == activator_team then
--                Dev(2, activator, "passed logic_team test of", self:GetName())
                self:TriggerOutput("OnPass", activator)
            else
--                Dev(2, activator, "failed logic_team test of", self:GetName())
                self:TriggerOutput("OnFail", activator)
            end
        end

        return true
    end
end
