--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/6/2018
-- Time: 7:31 PM
-- To change this template use File | Settings | File Templates.
--

--hook.Add("HUDPaint", "PaintOurHud", function()
--    HUD:Draw()
--end);

hook.Add("InitPostEntity", "PlayerSpawnSyncTimers", function()
    cl_init_prep_end_timer()
    client_init_map_end_timer()
    cl_ram_sync_scientists()
    cl_request_status()
    cl_sync_research()
    cl_sync_research_timer()
    if HUD.html == nil then
        HUD:Init()
    end
end)

hook.Add("HUDPaint", "ShowNPCHealthAboveHead", function() -- Get the entity we're looking at
    local ent = LocalPlayer():GetEyeTrace().Entity
    -- check if it's really an NPC and the class we want
    if IsValid(ent) and ent:GetClass() == 'ram_simple_scientist' then
        local pos = (ent:GetPos() + Vector(0,-2,80)):ToScreen()
        local team = ''
        local color = Color(255, 255, 255)
        if ent:GetTeam() == TEAM_BLUE then
            team = 'Blue Team'
            color = Color(0, 0, 255)
        else
            team = 'Orange Team'
            color = Color(255, 160, 0)
        end
        -- check we can actually see this part of the entity
        if pos.visible and LocalPlayer():GetPos():Distance(ent:GetPos()) < 100 then -- what info to draw
            draw.DrawText(
                tostring(ent:GetDisplayName()),
                "Trebuchet18",
                pos.x, pos.y,
                color,
                -- how to align the text
                TEXT_ALIGN_CENTER
            )
            draw.DrawText(
                tostring(team),
                "Trebuchet18",
                pos.x, pos.y + 10,
                color,
                -- how to align the text
                TEXT_ALIGN_CENTER
            )
        end
    end
end)
