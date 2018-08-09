--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/1/2018
-- Time: 1:54 PM
-- To change this template use File | Settings | File Templates.
--

AddCSLuaFile()

sound.Add( {
	name = "ram_health_charge",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "items/medcharge4.wav"
} )

ENT.Type = 'anim'
ENT.Model = Model("models/props_combine/health_charger001.mdl")
--ENT.ShouldEmitSound = false
--ENT.EmittingSound = false
ENT.Delay = 0
-- models/props_combine/suit_charger001.mdl

function ENT:Initialize()
    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)

    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    --   local b = 26
    --   self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))

    if SERVER then
        self:SetTrigger(true)
    end
end

function ENT:Use( activator, caller, num_use_type, any_value )
    if IsValid(activator) and activator:IsPlayer() then
        self:DispenseHealth(activator)
--    else
--        self:StopSound("ram_health_charge")
    end
end

function ENT:DispenseHealth(ply)
    if CurTime() < self.Delay then return
    else
        if ply:Health() < ply.MaxHealth then
            ply:SetHealth(ply:Health() + 1)
    --        self.ShouldEmitSound = true
            self:EmitSound("ram_health_charge")
            self.Delay = CurTime() + 0.1
            timer.Simple(0.1, function()
                self:StopSound("ram_health_charge")
            end)
    --    else
    --        self.ShouldEmitSound = false
    --        self:StopSound("ram_health_charge")
        end
    end
end