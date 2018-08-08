--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/7/2018
-- Time: 6:43 PM
-- To change this template use File | Settings | File Templates.
--

util.PrecacheModel("models/gibs/gibhead.mdl")
util.PrecacheModel("models/gibs/heart.mdl")
util.PrecacheModel("models/gibs/leg.mdl")
util.PrecacheModel("models/gibs/leg.mdl")
util.PrecacheModel("models/gibs/pgib_p1.mdl")
util.PrecacheModel("models/gibs/pgib_p2.mdl")
util.PrecacheModel("models/gibs/pgib_p3.mdl")
util.PrecacheModel("models/gibs/pgib_p4.mdl")
util.PrecacheModel("models/gibs/pgib_p5.mdl")
util.PrecacheModel("models/gibs/rgib_p1.mdl")
util.PrecacheModel("models/gibs/rgib_p2.mdl")
util.PrecacheModel("models/gibs/rgib_p3.mdl")
util.PrecacheModel("models/gibs/rgib_p4.mdl")
util.PrecacheModel("models/gibs/rgib_p5.mdl")

GIBS = {}

function GIBS.CreateGib(args)
    assert (args.pos ~= nil, "CreateGib must be called with a valid position")

    local gib = ents.Create("ram_gib")
    if ( not IsValid(gib)) then return end -- / / Check whether we successfully made an entity, if not - bail

    if args.model ~= nil and type(args.model == 'string') then
--        gib.Model = args.model
        gib:SetModel(args.model)
    end

    gib:SetPos(args.pos)
    gib:Spawn()

    return gib
end
