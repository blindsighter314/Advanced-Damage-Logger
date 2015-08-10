util.AddNetworkString("openAdvancedDamageLogger")
util.AddNetworkString("refreshAdvancedDamageLogger")
util.AddNetworkString("WipeAdvancedDamageLogger")
util.AddNetworkString("DelayAdvancedDamageLoggerWipe")

AdvancedDamageLogger_Log = {}
AdvancedDamageLogger_TimeBeforeWipe = AdvancedDamageLogger_WipeTime

function ADLLogDamage(victim, dmginfo)
	local attacker 		= dmginfo:GetAttacker()
	local damage			=	math.Round(dmginfo:GetDamage(), 2)

	if victim:IsPlayer() and victim:HasGodMode() == false and GetConVarNumber("sbox_godmode") == 0 then
		if attacker:IsPlayer() then
			local wep 	= string.Replace(attacker:GetActiveWeapon():GetClass(), "weapon_", "") or "UNKNOWN"
			local AName = attacker:Nick()
			local info 	= (victim:Nick().." took "..damage.." damage from "..AName.."( "..attacker:SteamID().." ) Using a "..wep)
			table.insert(AdvancedDamageLogger_Log, (os.date("%I:%M:%S %p: ")..info) )
		else
			local AName	=	tostring(attacker)
			local info 	= (victim:Nick().." took "..damage.." damage from "..AName)
			table.insert(AdvancedDamageLogger_Log, (os.date("%I:%M:%S %p: ")..info))
		end

		if AdvancedDamageLogger_DmgDelay == true then
			local time = AdvancedDamageLogger_TimeBeforeWipe + AdvancedDamageLogger_DmgDelayTime

			if time > AdvancedDamageLogger_WipetimeCap then
				AdvancedDamageLogger_TimeBeforeWipe = AdvancedDamageLogger_WipetimeCap
			else
				AdvancedDamageLogger_TimeBeforeWipe = time
			end
		end
	end
end
hook.Add("EntityTakeDamage", "Advanced Damage Logger Log Damage", ADLLogDamage)

function ADLLogDeath(victim,inflictor,attacker)
	if victim:IsPlayer() then
		if attacker:IsPlayer() then
			local AName = attacker:Nick()
			local wep = string.Replace(attacker:GetActiveWeapon():GetClass(), "weapon_", "")
			local info 	=	(victim:Nick().." was killed by "..AName.."( "..attacker:SteamID().." ) Using a "..wep)
			table.insert(AdvancedDamageLogger_Log, (os.date("%I:%M:%S %p: ")..info))
		end

		if AdvancedDamageLogger_KillDelay == true then
			local time = AdvancedDamageLogger_TimeBeforeWipe + AdvancedDamageLogger_KillDelayTime

			if time > AdvancedDamageLogger_WipetimeCap then
				AdvancedDamageLogger_TimeBeforeWipe = AdvancedDamageLogger_WipetimeCap
			else
				AdvancedDamageLogger_TimeBeforeWipe = time
			end
		end
	end
end
hook.Add("PlayerDeath", "Advanced Damage Logger Log Death", ADLLogDeath)

hook.Add("Initialize", "Advanced Damage Logger Wipe Logs", function()
	timer.Create("AdvancedDamageLogger_Think", 1,0,function()
		if AdvancedDamageLogger_TimeBeforeWipe > 1 then
			AdvancedDamageLogger_TimeBeforeWipe = AdvancedDamageLogger_TimeBeforeWipe - 1
		else
			AdvancedDamageLogger_Log = {}
			AdvancedDamageLogger_TimeBeforeWipe = AdvancedDamageLogger_WipeTime

			if AdvancedDamageLogger_ForceRefresh == true then
				for k,v in pairs(player.GetAll()) do
					net.Start("refreshAdvancedDamageLogger")
						net.WriteTable(AdvancedDamageLogger_Log)
						net.WriteInt(AdvancedDamageLogger_TimeBeforeWipe, 32)
					net.Send(v)
				end
			end
		end
	end)
end)

hook.Add("PlayerSay", "Advanced Damage Logger Chat Command", function(ply, txt, team)
	if txt == AdvancedDamageLogger_ChatCommand then
		ply:ConCommand(AdvancedDamageLogger_ConCommand)
		return ""
	end
end)

concommand.Add(AdvancedDamageLogger_ConCommand, function(ply)
	if AdvancedDamageLogger_AdminOnly == true then
		local admin = false
		if ply:IsSuperAdmin() or ply:IsAdmin() then admin = true end
		if AdvancedDamageLogger_ulx == true then
			for k,v in pairs(AdvancedDamageLogger_AdminRanks) do
				if ply:IsUserGroup(v) then admin = true end
			end
		end

		if admin == true then
			net.Start("openAdvancedDamageLogger")
				net.WriteTable(AdvancedDamageLogger_Log)
				net.WriteInt(AdvancedDamageLogger_TimeBeforeWipe, 32)
			net.Send(ply)
		else
			ply:ChatPrint("Advanced Damage Logs are only accessible to admins")
		end
	else
		net.Start("openAdvancedDamageLogger")
			net.WriteTable(AdvancedDamageLogger_Log)
			net.WriteInt(AdvancedDamageLogger_TimeBeforeWipe, 32)
		net.Send(ply)
	end
end)

concommand.Add("lentesterooni", function(ply)
	for i = 1,100 do table.insert(AdvancedDamageLogger_Log, "Spam") end
end)

net.Receive("WipeAdvancedDamageLogger", function(len,ply)
	AdvancedDamageLogger_Log = {}
	AdvancedDamageLogger_TimeBeforeWipe = AdvancedDamageLogger_WipeTime

	if AdvancedDamageLogger_ForceRefresh == true then
		for k,v in pairs(player.GetAll()) do
			net.Start("refreshAdvancedDamageLogger")
				net.WriteTable(AdvancedDamageLogger_Log)
				net.WriteInt(AdvancedDamageLogger_TimeBeforeWipe, 32)
			net.Send(v)
		end
	end
end)

net.Receive("DelayAdvancedDamageLoggerWipe", function(len, ply)
	AdvancedDamageLogger_TimeBeforeWipe = AdvancedDamageLogger_WipeTime
end)
