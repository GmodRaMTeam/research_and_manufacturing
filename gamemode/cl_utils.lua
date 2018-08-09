--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/1/2018
-- Time: 8:53 AM
-- To change this template use File | Settings | File Templates.
--

---------------------------------- All Clientside Gamemode Utillity Functions ----------------------------------

function EndMap()
    -- Yay we're a placeholder
    HUD.html:QueueJavascript([[ EVENTS.trigger('show_scoreboard') ]])
end

function EndPrep()
    -- Yay we're a placeholder
end

function client_init_map_end_timer()
    net.Start("RAMCL_request_sync_map_timer")
    net.SendToServer()
end

function cl_init_prep_end_timer()
    net.Start("RAMCL_request_sync_prep_timer")
    net.SendToServer()
end

function cl_ram_sync_scientists()
    net.Start("RAMCL_request_scientist_sync")
    net.SendToServer()
end

function cl_sync_research()
    net.Start("RAMCL_request_entire_research_table")
    net.SendToServer()
end

function cl_request_status()
    net.Start("RAMCL_request_sync_status")
    net.SendToServer()
end

function cl_sync_research_timer()
    net.Start("RAMCL_request_sync_research_timer")
    net.SendToServer()
end
