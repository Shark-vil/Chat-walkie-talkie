/////////////////////////////////////////////////////////////////
-- Author: Shark_vil
-- Profile: http://steamcommunity.com/id/sharkvil1337/
-- Release: 21.08.2017
/////////////////////////////////////////////////////////////////

util.AddNetworkString( "FGRadio_SendServer" )
util.AddNetworkString( "FGRadio_SendClient" )

/*----------------------------------------------------------*/
/////////////////////// File create /////////////////////////
/*----------------------------------------------------------*/

local FgRConfig = include("config.lua")
local fileid = os.time()
local fgRadio = {}
local fdate = os.date( "========[ %d/%m/%Y ]========" , fileid )
local filedate = os.date( "( %d.%m.%Y )" , fileid )
local newFileCreated = false

fgRadio.CheckTeamDarkRp = function(ply)
	if engine.ActiveGamemode() == "darkrp" then
		if FgRConfig.TEAMRestriction then
			for _, team in pairs(FgRConfig.TEAMGroup) do
				-- if RPExtraTeams[ply:Team()].category == team then
				if ply:Team() == team then
					return true
				end
			end
		else
			return true
		end

		ply.fgRadio_Array = {
			RadioOff = nil, 
			VoiceChannel = nil,
		}
		
		return false
	else
		return true
	end
end

fgRadio.CreateDataFile = function()
	if not newFileCreated then
		file.CreateDir( FgRConfig.DirName )
		file.Write( FgRConfig.DirName.."/info_"..fileid.."_"..filedate..".txt", fdate)
		newFileCreated = true
	end
end

/*----------------------------------------------------------*/	
fgRadio.GiveTimeOS = function ()
	OsTime = os.time()
	Time = os.date( "(%H:%M:%S)" , OsTime )
	return Time
end

fgRadio.PlayerInitialSpawn = function(ply)
	ply.fgRadio_Array = {
		RadioOff = nil, 
		VoiceChannel = nil,
	}
end
hook.Add("PlayerInitialSpawn", "fgRadio.PlayerInitialSpawn", fgRadio.PlayerInitialSpawn)

fgRadio.PlayerSay = function(ply, text)
	local command = text
	local strStart = text:len()
	if ply.fgRadio_Array.RadioOff == nil then
		ply.fgRadio_Array.RadioOff = false
	end

	for i=1, text:len() do
		if (text[i] == " ") then
			command = string.sub(text:lower(), 1, i-1)
			strStart = i
			break
		end
	end

	if ( command == string.lower(FgRConfig.SetChannel) ) then
		local Cha = string.sub( text, string.len(FgRConfig.SetChannel)+1, string.len(FgRConfig.SetChannel)+5 )
		local BadNum = string.sub( text, string.len(FgRConfig.SetChannel)+4, string.len(FgRConfig.SetChannel)+4 )
		local NumCheck = tonumber(Cha)
		local tblset = {}
		
		if isstring(NumCheck) or NumCheck == nil then return "" end

		if FgRConfig.ULXRestriction then
			local teamAc = true
				for _, group in pairs(FgRConfig.ULXGroup) do
					if ply:IsUserGroup(group) then
						teamAc = false
					end
				end
			if teamAc then return "" end
		end
		
		if (BadNum ~= "." or BadNum == nil) then
			local tbl = {
				id = "SetChannel",
				access = false,
			}
			net.Start("FGRadio_SendClient")
				net.WriteTable(tbl)
			net.Send(ply)
			return ""
		end
		
		if (NumCheck >= FgRConfig.MinChannelNumber and NumCheck <= FgRConfig.MaxChannelNumber) then
			local tbl = { id = "SetChannel", arg =  Cha, bool = true, access = true }
			net.Start("FGRadio_SendClient")
				net.WriteTable(tbl)
			net.Send(ply)
			
			ply.fgRadio_Array.VoiceChannel = NumCheck
			
			if FgRConfig.Log then
				fgRadio.CreateDataFile()
				local read = file.Read( FgRConfig.DirName.."/info_"..fileid.."_"..filedate..".txt" )
				file.Write( FgRConfig.DirName.."/info_"..fileid.."_"..filedate..".txt", read.."\n"..fgRadio.GiveTimeOS()..": "..ply:Name().." "..FgRConfig.Translation[9]..Cha)
			end
		else
			local tbl = { id = "SetChannel", arg =  Cha, bool = false, access = false }
			net.Start("FGRadio_SendClient")
				net.WriteTable(tbl)
			net.Send(ply)
		end
		
		return ""
	end
	
	if ( command == string.lower(FgRConfig.SendChannel) ) then
		local Messages = string.sub( text, string.len(FgRConfig.SendChannel)+1 )
		local tbl = { id = "SendChannelCheck", arg = Messages, plname = ply:Name(), plsteamid64 = ply:SteamID64() } 
		net.Start("FGRadio_SendClient")
			net.WriteTable(tbl)
		net.Send(ply)
			
		return ""
	end
	
	if ( command == string.lower(FgRConfig.Status) ) then	
		local tbl = { id = "EnableDisable" }
		net.Start("FGRadio_SendClient")
			net.WriteTable(tbl)
		net.Send(ply)
		
		return ""
	end
	
	if ( command == string.lower(FgRConfig.OpenVgui) ) then
		local tbl = { id = "VGUI" }
		net.Start("FGRadio_SendClient")
			net.WriteTable(tbl)
		net.Send(ply)
		
		return ""
	end
	
	if FgRConfig.GetAllChannelOnlyAdmin then
	local isulx = ulx
		if isulx ~= nil then
			for _, group in pairs(FgRConfig.ULXGroupAccess) do
				if ( ply:IsUserGroup(group) ) then
					if ( command == string.lower(FgRConfig.GetAllChannel) ) then
					
						local tbl = { id = "GetAllChannel", OwnerSteamId64 = ply:SteamID64() }
						net.Start("FGRadio_SendClient")
							net.WriteTable(tbl)
						net.Broadcast()
						
						return ""
					end
				end
			end
		else
			if ( ply:IsAdmin() or ply:IsSuperAdmin() ) then
				if ( command == string.lower(FgRConfig.GetAllChannel) ) then
						
					local tbl = { id = "GetAllChannel", OwnerSteamId64 = ply:SteamID64() }
					net.Start("FGRadio_SendClient")
						net.WriteTable(tbl)
					net.Broadcast()
							
					return ""
				end
			end
		end
	else
		if ( command == string.lower(FgRConfig.GetAllChannel) ) then
			
			local tbl = { id = "GetAllChannel", OwnerSteamId64 = ply:SteamID64() }
			net.Start("FGRadio_SendClient")
				net.WriteTable(tbl)
			net.Broadcast()
				
			return ""
		end
	end
end
hook.Add( "PlayerSay", "fgRadio.PlayerSay", fgRadio.PlayerSay)


fgRadio.SendAllChannel = function (tbl)
	for k,v in ipairs(player.GetAll()) do
		if ( v:SteamID64() == tbl.OwnerSteamId64 ) then
		local tbl = { id = "GetAllChannelView", channel = tbl.channel, plName = tbl.plName }
			net.Start("FGRadio_SendClient")
				net.WriteTable(tbl)
			net.Send(v)
		end
	end
end

fgRadio.SendChannelCheckServer = function (tbl)
	local ownermes = nil
	local ownerstid = nil
	
	if FgRConfig.Log then
		fgRadio.CreateDataFile()
		local read = file.Read( FgRConfig.DirName.."/info_"..fileid.."_"..filedate..".txt" )
		file.Write( FgRConfig.DirName.."/info_"..fileid.."_"..filedate..".txt", read.."\n"..fgRadio.GiveTimeOS()..": ".."("..tbl.channel.." ) "..tbl.OwnerName..": "..tbl.messages)
	end

	for k,v in ipairs(player.GetAll()) do
		if ( v:SteamID64() == tbl.OwnerSteamId64 ) then 
			ownermes = v:GetPos() 
			ownerstid = v:SteamID64()
		end 
	end
	
	for k,v in ipairs(player.GetAll()) do
		local plPos = v:GetPos()
		local dist = Vector( plPos ):Distance( Vector( ownermes ) )
		if ( dist <= FgRConfig.MaxDistanceVisibility and v:SteamID64() ~= ownerstid ) then
		local tbl = { id = "SendChannel", channel = tbl.channel, messages = tbl.messages, name = tbl.OwnerName, bool = false  }
			net.Start("FGRadio_SendClient")
				net.WriteTable(tbl)
			net.Send(v)
		else
		local tbl = { id = "SendChannel", channel = tbl.channel, messages = tbl.messages, name = tbl.OwnerName, bool = true  }
			net.Start("FGRadio_SendClient")
				net.WriteTable(tbl)
			net.Send(v)
		end
	end
	
end

hook.Add( "PlayerCanHearPlayersVoice", "FG.Radio.SendChannelCheckServer", function( listener, talker )	
	if FgRConfig.VoiceTalkie then
		if ( listener.fgRadio_Array.VoiceChannel != nil and talker.fgRadio_Array.VoiceChannel != nil ) then
			if ( !listener.fgRadio_Array.RadioOff and !talker.fgRadio_Array.RadioOff ) then
				if ( listener:GetPos():Distance( talker:GetPos() ) <= FgRConfig.MaxDistanceVisibility ) then
					return true
				elseif ( listener.fgRadio_Array.VoiceChannel == talker.fgRadio_Array.VoiceChannel ) then
					return true
				else
					return false
				end
			end
		end
	end
end)

fgRadio.FileWriteOnOffRadio = function (tbl)
	if FgRConfig.Log then
		fgRadio.CreateDataFile()
		if tbl.bool then
		local read = file.Read( FgRConfig.DirName.."/info_"..fileid.."_"..filedate..".txt" )
			file.Write( FgRConfig.DirName.."/info_"..fileid.."_"..filedate..".txt", read.."\n"..fgRadio.GiveTimeOS()..": "..tbl.name..": "..FgRConfig.Translation[10])
		else
		local read = file.Read( FgRConfig.DirName.."/info_"..fileid.."_"..filedate..".txt" )
			file.Write( FgRConfig.DirName.."/info_"..fileid.."_"..filedate..".txt", read.."\n"..fgRadio.GiveTimeOS()..": "..tbl.name..": "..FgRConfig.Translation[11])
		end
	end
end



net.Receive("FGRadio_SendServer", function(l, ply)
	if not fgRadio.CheckTeamDarkRp(ply) then return end

	local read = net.ReadTable()

	ply.fgRadio_Array.RadioOff = read.bool

	if read.id == "SendAllChannel" then
		fgRadio.SendAllChannel(read)
	elseif read.id == "SendChannelCheckServer" then
		fgRadio.SendChannelCheckServer(read)
	elseif read.id == "FileWriteOnOffRadio" then
		fgRadio.FileWriteOnOffRadio(read)
	end
end)

fgRadio.InitializeGamemode = function()
	if engine.ActiveGamemode() == "darkrp" then
		if FgRConfig.TEAMRestriction then
			hook.Add("OnPlayerChangedTeam", "hook.fgRadio.OnPlayerChangedTeam", function(ply, b, a)
				if not table.HasValue(FgRConfig.TEAMGroup, a) then
					ply.fgRadio_Array = {
						RadioOff = nil, 
						VoiceChannel = nil,
					}
				end
			end)
		end
	end
end
hook.Add( "Initialize", "hook.fgRadio.InitializeGamemode", fgRadio.InitializeGamemode )