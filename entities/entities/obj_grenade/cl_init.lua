include('shared.lua')

language.Add("obj_grenade", "Grenade")
function ENT:Draw()           
	self:DrawModel()
end

function ENT:Initialize()
end
 
function ENT:OnRemove()
end
 
function ENT:Think()
end