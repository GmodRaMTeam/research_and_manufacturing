--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/4/2018
-- Time: 3:23 PM
-- To change this template use File | Settings | File Templates.
--

meta = FindMetaTable("Entity")
function meta:DoExplode(dmg, radius, owner, bDontRemove)
	util.CreateExplosion(self:GetPos(),dmg,radius,self,owner)
	if not bDontRemove then self:Remove() end
end
