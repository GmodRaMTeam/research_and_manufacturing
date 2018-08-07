--
-- Created by IntelliJ IDEA.
-- User: Комерад
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
ENT.XBowAmmoMax = 5
ENT.RPGAmmoMax = 3
ENT.GaussAmmoMax = 150
ENT.SatchelAmmoMax = 5
ENT.GrenadeAmmoMax = 5
ENT.TripmineAmmoMax = 5
ENT.Model = Model("models/items/item_item_crate.mdl")
ENT.RespawnTime = 5
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

function ENT:CheckTechRequirement(team_index, cat_key, weapon_key)
    local weaponTech = team.GetAllTeams()[team_index].ResearchManager.categories[cat_key].techs[weapon_key]
    return weaponTech.researched
end

function ENT:CheckPlayerWeaponAndGive(ent, weapon_class)
    if not ent:HasWeapon(weapon_class) then ent:Give(weapon_class) end
end

function ENT:GivePlayerAmmo(ply, ammo_type, ammo_max_key, use_alt_type, is_gadget)
    if use_alt_type == nil then
        use_alt_type = false
    end

    local current_ammo = nil

    if not use_alt_type then
        current_ammo = ply:GetAmmoCount(ammo_type)
    else
        current_ammo = ply:GetAmmunition(ammo_type)
    end

    local current_can_add = nil

    if is_gadget then
        current_can_add = self[ammo_max_key] >= (current_ammo + 1)
    else
        current_can_add = self[ammo_max_key] >= (current_ammo + math.ceil(self.AmmoAmount * 0.25))
    end

    if current_can_add then
        if not use_alt_type then
            local given = self.AmmoAmount
            given = math.min(given, self[ammo_max_key] - current_ammo)
            ply:GiveAmmo(given, ammo_type)
        else
            if is_gadget then
                local given = 1
                given = math.min(given, self[ammo_max_key] - current_ammo)
                ply:AddAmmunition(ammo_type, given)
            else
                local given = self.AmmoAmount
                given = math.min(given, self[ammo_max_key] - current_ammo)
                ply:AddAmmunition(ammo_type, given)
            end
        end
        self.taken = true
    end
end

function ENT:Touch(ent)
    if SERVER and not self.taken then
        if (ent:IsValid() and ent:IsPlayer()) then

            self:GivePlayerAmmo(ent, 'Pistol', 'PistolAmmoMax')

            if self:CheckTechRequirement(ent:Team(), 'weapons', 'shotgun') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_ram_shotgun')
                self:GivePlayerAmmo(ent, 'Buckshot', 'ShotgunAmmoMax')
            end

            if self:CheckTechRequirement(ent:Team(), 'weapons', 'revolver') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_ram_revolver')
                self:GivePlayerAmmo(ent, '357', 'RevolverAmmoMax')
            end

            if self:CheckTechRequirement(ent:Team(), 'weapons', 'smg') then
                self:CheckPlayerWeaponAndGive(ent,'weapon_ram_smg')
                self:GivePlayerAmmo(ent, 'smg1', 'SMGAmmoMax')
            end

            if self:CheckTechRequirement(ent:Team(), 'weapons', 'ar') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_ram_ar2')
                self:GivePlayerAmmo(ent, 'ar2', 'ARAmmoMax')
            end

            if self:CheckTechRequirement(ent:Team(), 'weapons', 'crossbow') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_crossbow')
                self:GivePlayerAmmo(ent, 'XBowBolt', 'XBowAmmoMax', false, true)
--                ent:AddAmmunition('uranium', 20)
            end

            if self:CheckTechRequirement(ent:Team(), 'weapons', 'rpg') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_rpg')
                self:GivePlayerAmmo(ent, 'RPG_Round', 'RPGAmmoMax', false, true)
--                ent:AddAmmunition('uranium', 20)
            end

            if self:CheckTechRequirement(ent:Team(), 'weapons', 'gauss') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_ram_gauss')
                self:GivePlayerAmmo(ent, 'uranium', 'GaussAmmoMax', true)
--                ent:AddAmmunition('uranium', 20)
            end

            if self:CheckTechRequirement(ent:Team(), 'weapons', 'egon') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_ram_egon')
                self:GivePlayerAmmo(ent, 'uranium', 'GaussAmmoMax', true)
--                ent:AddAmmunition('uranium', 20)
            end

            if self:CheckTechRequirement(ent:Team(), 'gadgets', 'satchel') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_ram_satchel')
                self:GivePlayerAmmo(ent, 'satchel', 'SatchelAmmoMax', true, true)
                --                ent:AddAmmunition('uranium', 20)
            end

            if self:CheckTechRequirement(ent:Team(), 'gadgets', 'grenade') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_frag')
                self:GivePlayerAmmo(ent, 'Grenade', 'GrenadeAmmoMax', true, true)
                --                ent:AddAmmunition('uranium', 20)
            end

            if self:CheckTechRequirement(ent:Team(), 'gadgets', 'tripmine') then
                self:CheckPlayerWeaponAndGive(ent, 'weapon_ram_tripmine')
                self:GivePlayerAmmo(ent, 'tripmine', 'TripmineAmmoMax', true, true)
            end

            if self.taken then
                self:RemoveAndCreateRespawn()
            end
        end
    end
end
