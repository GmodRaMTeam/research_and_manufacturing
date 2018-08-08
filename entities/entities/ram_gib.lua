--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/7/2018
-- Time: 6:18 PM
-- To change this template use File | Settings | File Templates.
--

AddCSLuaFile()

--ENT.Base = "base_entity"

ENT.Type = 'anim'
ENT.PrintName		= "Gib"
ENT.Author			= "Komerad"
ENT.Contact			= "komeradgygabite@gmail.com"
ENT.Purpose			= "Gibby"
ENT.Instructions	= "Always handle with gloves."

ENT.Model = Model("models/gibs/gibhead.mdl")

function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        if SERVER then
            phys:Wake()
    --        phys:SetMass( 0.001 )
            phys:SetVelocity( Vector(math.random(150, 300), math.random(150, 300), math.random(150, 300)) )
        end
    end

--    self:SetModel(self.Model)

    if SERVER then
        self:SetTrigger(true)
    end

    timer.Simple(5, function() -- Hang around for 5 seconds then dissapear
        if IsValid(self) and SERVER then
            self:Remove()
        end
    end)
end

function ENT:Think()
--    if self:NextThink() > CurTime() then return end
    local next_think_time = math.random(0.5, 3)
    if SERVER then
        self:NextThink( CurTime() + next_think_time )
        self:Bleed()
    end
    if CLIENT then
        self:SetNextClientThink( CurTime() + next_think_time )
    end
    return true
end


local bounce_sounds = {
    Sound("physics/flesh/flesh_squishy_impact_hard1.wav"),
    Sound("physics/flesh/flesh_squishy_impact_hard2.wav"),
    Sound("physics/flesh/flesh_squishy_impact_hard3.wav"),
    Sound("physics/flesh/flesh_squishy_impact_hard4.wav")
}

function ENT:Bleed()
    local phys_object_pos = self:GetPhysicsObject():GetPos()
    if SERVER then
        -- Make a blood impact effect: BloodImpact
        -- bloodspray	A long spray of blood, set flags = 3, color = 0, scale = 6 for best results
        local vPoint = self:GetPhysicsObject():GetPos()
        local effectdata = EffectData()
        effectdata:SetOrigin( vPoint )
        effectdata:SetFlags( 3 )
        effectdata:SetColor( 0 )
        effectdata:SetScale( 6 )

        util.Effect( 'bloodspray', effectdata, false, true )
        util.Effect( 'BloodImpact', effectdata, false, true )

        local pitch = math.random(90, 110)
        local selected_sound = table.Random(bounce_sounds)
		sound.Play( selected_sound, phys_object_pos, 75, math.random( pitch - 10, pitch + 10 ), math.Clamp( 150 / 150, 0, 1 ) )
    end

    -- What the fuck is wrong with trying to draw decals on ground?
    local startp = phys_object_pos + Vector(0, 0, 150) -- Have to go 150 units up, 300 down for this shit to work
    local traceinfo = { start = startp, endpos = startp - Vector(0, 0, 300), filter = self, mask = MASK_SOLID }
    local trace = util.TraceLine(traceinfo)
    local todecal1 = trace.HitPos + trace.HitNormal
    local todecal2 = trace.HitPos - trace.HitNormal
    util.Decal("Blood", todecal1, todecal2)

end


function ENT:PhysicsCollide( data, physobj )

	-- Play sound on bounce
	if ( data.Speed > 60 and data.DeltaTime > 0.2 ) then

        local pitch = math.random(90, 110)
        local selected_sound = table.Random(bounce_sounds)
		sound.Play( selected_sound, self:GetPos(), 75, math.random( pitch - 10, pitch + 10 ), math.Clamp( data.Speed / 150, 0, 1 ) )

	end

	-- Bounce like a crazy bitch
	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()

	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )

	local TargetVelocity = NewVelocity * LastSpeed * 0.9

	physobj:SetVelocity( TargetVelocity )

end
