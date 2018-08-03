--
-- Created by IntelliJ IDEA.
-- User: Tyler
-- Date: 8/1/2018
-- Time: 1:54 PM
-- To change this template use File | Settings | File Templates.
--

AddCSLuaFile()

ENT.Type = 'anim'
ENT.AmmoAmount = 20
ENT.PistolAmmoMax = 120
ENT.ShotgunAmmoMax = 96
ENT.RevolverAmmoMax = 48
ENT.SMGAmmoMax = 240
ENT.ARAmmoMax = 180
ENT.GaussAmmoMax = 150
ENT.Model = Model("models/items/boxsrounds.mdl")
ENT.RespawnTime = 10
ENT.taken = false

local function CreateNewCopy(pos, ang)
    local newAmmo = ents.Create("ram_ammo_stock")
    if (not IsValid(newAmmo)) then
        timer.Simple(5, function()
            CreateNewCopy(pos, ang)
        end)
    end -- Check whether we successfully made an entity, if not - bail
    newAmmo:SetPos(pos)
    newAmmo:SetAngles(ang)
    newAmmo:Spawn()
end

function ENT:Initialize()
    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    --   local b = 26
    --   self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))

    if SERVER then
        self:SetTrigger(true)
    end
end

function ENT:RemoveAndCreateRespawn()
    local pos = self:GetPos()
    local ang = self:GetAngles()
    self:Remove()
    timer.Simple( self.RespawnTime, function()
        CreateNewCopy(pos, ang)
    end )
end

function ENT:CheckTechRequirement(team_index, weapon_key)
    local weaponTech = team.GetAllTeams()[team_index].ResearchManager.categories['weapons'].techs[weapon_key]
    return weaponTech.researched
end

function ENT:GivePlayerAmmo(ply, ammo_type, ammo_max_key, use_alt_type)
    if use_alt_type == nil then
        use_alt_type = false
    end

    local current_ammo = nil

    if not use_alt_type then
        current_ammo = ply:GetAmmoCount(ammo_type)
    else
        current_ammo = ply:GetAmmunition(ammo_type)
    end
    if self[ammo_max_key] >= (current_ammo + math.ceil(self.AmmoAmount * 0.25)) then
        local given = self.AmmoAmount
        given = math.min(given, self[ammo_max_key] - current_ammo)
        if not use_alt_type then
            ply:GiveAmmo(given, ammo_type)
        else
            print("We alternatively gave: "..given.." amount of ammo type: "..ammo_type.."!")
            ply:AddAmmunition(ammo_type, given)
        end
        self.taken = true
    end
end

function ENT:Touch(ent)
    if SERVER and not self.taken then
        if (ent:IsValid() and ent:IsPlayer()) then

            self:GivePlayerAmmo(ent, 'Pistol', 'PistolAmmoMax')

            if self:CheckTechRequirement(ent:Team(), 'shotgun') then
                self:GivePlayerAmmo(ent, 'Buckshot', 'ShotgunAmmoMax')
            end

            if self:CheckTechRequirement(ent:Team(), 'revolver') then
                self:GivePlayerAmmo(ent, '357', 'RevolverAmmoMax')
            end

            if self:CheckTechRequirement(ent:Team(), 'smg') then
                self:GivePlayerAmmo(ent, 'smg1', 'SMGAmmoMax')
            end

            if self:CheckTechRequirement(ent:Team(), 'ar') then
                self:GivePlayerAmmo(ent, 'ar2', 'ARAmmoMax')
            end

            if self:CheckTechRequirement(ent:Team(), 'gauss') then
                self:GivePlayerAmmo(ent, 'uranium', 'GaussAmmoMax', true)
--                ent:AddAmmunition('uranium', 20)
            end

            if self:CheckTechRequirement(ent:Team(), 'egon') then
                self:GivePlayerAmmo(ent, 'uranium', 'GaussAmmoMax', true)
--                ent:AddAmmunition('uranium', 20)
            end

            if self.taken then
                self:RemoveAndCreateRespawn()
            end
        end
    end
end
