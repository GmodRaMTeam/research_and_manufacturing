--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/4/2018
-- Time: 3:29 PM
-- To change this template use File | Settings | File Templates.
--

meta = FindMetaTable("PhysObj")
function meta:SetAngleVelocity(ang)
	self:AddAngleVelocity(self:GetAngleVelocity() *-1 +ang)
end
