--
-- Created by IntelliJ IDEA.
-- User: Комерад
-- Date: 8/1/2018
-- Time: 8:41 AM
-- To change this template use File | Settings | File Templates.
--

function util.CreateExplosion(pos,dmg,radius,inflictor,attacker)
	radius = radius or 260
	dmg = dmg or 85
	local ang = Angle(0,0,0)
	local entParticle = ents.Create("info_particle_system")
	entParticle:SetKeyValue("start_active", "1")
--	entParticle:SetKeyValue("effect_name", "dusty_explosion_rockets")--//svl_explosion")
	entParticle:SetKeyValue("effect_name", "rocket_fx")--//svl_explosion")
	entParticle:SetPos(pos)
	entParticle:SetAngles(ang)
	entParticle:Spawn()
	entParticle:Activate()
	timer.Simple(1, function() if IsValid(entParticle) then entParticle:Remove() end end)
	sound.Play("weapons/explode" .. math.random(7,9) .. ".wav", pos, 110, 100)
	util.BlastDamage(inflictor,attacker or inflictor, pos, radius, dmg)
	util.ScreenShake(pos, 5, dmg, math.Clamp(dmg /100, 0.1, 2), radius *2)

	local iDistMin = 26
	local tr
	for i = 1, 6 do
		local posEnd = pos
		if i == 1 then posEnd = posEnd +Vector(0,0,25)
		elseif i == 2 then posEnd = posEnd -Vector(0,0,25)
		elseif i == 3 then posEnd = posEnd +Vector(0,25,0)
		elseif i == 4 then posEnd = posEnd -Vector(0,25,0)
		elseif i == 5 then posEnd = posEnd +Vector(25,0,0)
		elseif i == 6 then posEnd = posEnd -Vector(25,0,0) end
		local tracedata = {
			start = pos,
			endpos = posEnd,
			filter = {inflictor,attacker}
		}
		local trace = util.TraceLine(tracedata)
		local iDist = pos:Distance(trace.HitPos)
		if trace.HitWorld and iDist < iDistMin then
			iDistMin = iDist
			tr = trace
		end
	end
	if tr then
		util.Decal("Scorch",tr.HitPos +tr.HitNormal,tr.HitPos -tr.HitNormal)
	end
end

---------------------------------- All ServerSide Gamemode Utillity Functions ----------------------------------

--function GetMapTimeLeft()
--    if timer.Exists('RAM_TimerMapEnd') then
--        return timer.TimeLeft('RAM_TimerMapEnd')
--    end
--end

--function GetPrepTimeLeft()
--    if timer.Exists('RAM_TimerPrepEnd') then
--        return timer.TimeLeft('RAM_TimerPrepEnd')
--    end
--end

function ram_dynamic_status_update(team_index, message, status, specific_player)
    -- Status can be: 'warning', 'success', 'error', voting, kidnap
    if team_index ~= nil then
        for k, ply in pairs(player.GetAll()) do
            if IsValid(ply) and ply:Team() == team_index then
                net.Start("RAM_dynamic_notification")
                net.WriteString(message)
                net.WriteString(status)
                net.Send(ply)
            end
        end
    elseif specific_player ~= nil and specific_player:IsValid() and team_index == nil then
        net.Start("RAM_dynamic_notification")
        net.WriteString(message)
        net.WriteString(status)
        net.Send(specific_player)
        print("We sent player: "..specific_player:Nick().." A dynamic update!")
    else
        net.Start("RAM_dynamic_notification")
        net.WriteString(message)
        net.WriteString(status)
        net.Broadcast()
        if team_index ~= nil then
            print("We sent team"..team_index.." A dynamic update!")
        end
    end
end

function ram_print_to_team(teamIndex, stringMsg)
    for k, ply in pairs(player.GetAll()) do
        if ply:Team() == teamIndex then
            net.Start("RAM_print_to_team")
            net.WriteString(stringMsg)
            net.Send(ply)
        end
    end
end

function ram_client_status_update(intStatus, intTeam)
    net.Start("RAM_status_update")
    --net.WriteString("some text")
    net.WriteInt(intStatus, 4)
    net.WriteInt(intTeam, 3)
    net.Broadcast()
    -- We did something!
end

function ram_client_status_updateToPlayer(intStatus, intTeam, ply)
    net.Start("RAM_status_update")
    --net.WriteString("some text")
    net.WriteInt(intStatus, 4)
    net.WriteInt(intTeam, 3)
    net.Send(ply)
    -- We did something!
end

function sv_ram_sync_scientists(ply)
    local AllTeams = team.GetAllTeams()
    if ply ~= nil then
        net.Start("RAM_scientist_update")
        net.WriteInt(AllTeams[TEAM_BLUE].Scientists, 4)
        net.WriteInt(AllTeams[TEAM_ORANGE].Scientists, 4)
        net.Send(ply)
    else
        net.Start("RAM_scientist_update")
        net.WriteInt(AllTeams[TEAM_BLUE].Scientists, 4)
        net.WriteInt(AllTeams[TEAM_ORANGE].Scientists, 4)
        net.Broadcast()
    end
end

function sv_ram_capture_scientist(new_team, scientist_name, scientist_cost, scientist_original_team)
    local new_scientist = ents.Create("ram_simple_scientist")
    if (not IsValid(new_scientist)) then return end -- Check whether we successfully made an entity, if not - bail
    local pos = new_scientist:ScientistSelectSpawn(new_team)
    if pos ~= nil then
        new_scientist:SetPos(pos)
        new_scientist:Spawn()
        new_scientist:SetTeam(new_team)
        new_scientist:SetDisplayName(scientist_name)
        new_scientist:SetCost(scientist_cost)
    else
        new_scientist:Remove()
    end

    local AllTeams = team.GetAllTeams()
    AllTeams[new_team].Scientists = AllTeams[new_team].Scientists + 1
    AllTeams[scientist_original_team].Scientists = AllTeams[scientist_original_team].Scientists - 1

    ram_dynamic_status_update(scientist_original_team, 'You have lost one of your scientists to your competitor!', 'kidnap', nil)

    sv_ram_sync_scientists(nil)

end

function ram_sync_status(ply)
    net.Start("RAM_sync_status")
    net.WriteInt(team.GetAllTeams()[TEAM_BLUE].ResearchManager.status, 4)
    net.WriteInt(team.GetAllTeams()[TEAM_ORANGE].ResearchManager.status, 4)
    net.Send(ply)
end

function ram_sync_map_timer(ply)
    local time_left = nil
    if timer.Exists("RAM_TimerMapEnd") then
        time_left = timer.TimeLeft("RAM_TimerMapEnd")
    else
        time_left = 0
    end
    net.Start("RAM_sync_map_timer")
    net.WriteFloat(time_left)
    net.Send(ply)
end

function ram_sync_prep_timer(ply)
    local time_left = nil
    if timer.Exists("RAM_TimerPrepEnd") then
        time_left = timer.TimeLeft("RAM_TimerPrepEnd")
    else
        time_left = 0
    end
    net.Start("RAM_sync_prep_timer")
    net.WriteFloat(time_left)
    net.Send(ply)
end
