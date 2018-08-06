--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/1/2018
-- Time: 1:54 PM
-- To change this template use File | Settings | File Templates.
--

AddCSLuaFile()

sound.Add( {
	name = "ram_armor_charge",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = "items/suitcharge1.wav"
} )

ENT.Type = 'anim'
ENT.Model = Model("models/props_combine/suit_charger001.mdl")
ENT.ShouldEmitSound = false
ENT.EmittingSound = false
ENT.Delay = 0
-- models/props_combine/suit_charger001.mdl

function ENT:Initialize()
    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)

    self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
    --   local b = 26
    --   self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))

    if SERVER then
        self:SetTrigger(true)
    end
end

function ENT:Use( activator, caller, num_use_type, any_value )
    if IsValid(activator) and activator:IsPlayer() then
        self:DispenseArmor(activator)
    end
--    else
--        self:StopSound("ram_armor_charge")
--    end
end

function ENT:DispenseArmor(ply)
    if CurTime() < self.Delay then return
    else
        if ply:Armor() < ply.MaxArmor then
            self.LastUsed = CurTime()
            ply:SetArmor(ply:Armor() + 1)
--            self.ShouldEmitSound = true
            self:EmitSound("ram_armor_charge")
            self.Delay = CurTime() + 0.1
            timer.Simple(0.1, function()
                self:StopSound("ram_armor_charge")
            end)
--        else
--            self.ShouldEmitSound = false
--            self:StopSound("ram_armor_charge")
        end
    end
end