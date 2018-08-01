/////////////////////////////////////////////////////////////////
-- Author: Shark_vil
-- Profile: http://steamcommunity.com/id/sharkvil1337/
-- Release: 21.08.2017
/////////////////////////////////////////////////////////////////
local FgRConfig = include("config.lua")
local fgRadio = {}

fgRadio.MyChannel = nil
local RadioOff = false

local History = {"***"}

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

		fgRadio.MyChannel = nil
		return false
	else
		return true
	end
end

fgRadio.GetAllChannel = function (tbl)
	if ( fgRadio.MyChannel ~= nil ) then
		local tbl = { id = "SendAllChannel", channel = fgRadio.MyChannel, OwnerSteamId64 = tbl.OwnerSteamId64, plName = LocalPlayer():Name() }
			net.Start("FGRadio_SendServer")
				net.WriteTable(tbl)
			net.SendToServer()
	else return end
end

fgRadio.GetAllChannelView = function (tbl)
	chat.AddText(tbl.plName,": ",tbl.channel)
end

fgRadio.EnableDisable = function()
	if ( RadioOff == false ) then
		RadioOff = true
		chat.AddText( FgRConfig.ColorTextUse, FgRConfig.Translation[7] )
		surface.PlaySound( FgRConfig.SoundRadioDisable )
		table.insert(History, FgRConfig.Translation[7])
		
		--if FgRConfig.Log then
		local tbl = { id = "FileWriteOnOffRadio", bool = true, name = LocalPlayer():Name() }
			net.Start("FGRadio_SendServer")
				net.WriteTable(tbl)
			net.SendToServer()
		--end
	else
		RadioOff = false
		chat.AddText( FgRConfig.ColorTextUse, FgRConfig.Translation[6] )
		surface.PlaySound( FgRConfig.SoundRadioEnable )
		table.insert(History, FgRConfig.Translation[6])
		
		--if FgRConfig.Log then
		local tbl = { id = "FileWriteOnOffRadio", bool = false, name = LocalPlayer():Name() }
			net.Start("FGRadio_SendServer")
				net.WriteTable(tbl)
			net.SendToServer()
		--end
	end
end

fgRadio.SetChannel = function (tbl)
if RadioOff then return end
	
	if (tbl.access == false) then
		chat.AddText( FgRConfig.ColorTextError, FgRConfig.Translation[8] )
	return
	end
	
	if (tbl.bool == true) then
		fgRadio.MyChannel = tbl.arg
		History = {"***"}
		chat.AddText( FgRConfig.ColorTextUse, FgRConfig.Translation[1], fgRadio.MyChannel )
	else
		chat.AddText( FgRConfig.ColorTextError, FgRConfig.Translation[2]," ",tostring(FgRConfig.MinChannelNumber),".0",FgRConfig.Translation[3]," ",tostring(FgRConfig.MaxChannelNumber) )
	end
end

fgRadio.SendChannelCheck =  function (tbl)
if RadioOff then return end
	
	if ( fgRadio.MyChannel ~= nil ) then
		local tbl = { id = "SendChannelCheckServer", channel = fgRadio.MyChannel, messages = tbl.arg, OwnerName = tbl.plname, OwnerSteamId64 = tbl.plsteamid64 }
		net.Start("FGRadio_SendServer")
			net.WriteTable(tbl)
		net.SendToServer()
	else 
		chat.AddText( FgRConfig.ColorTextError, FgRConfig.Translation[4] )
	end
end

fgRadio.SendChannel = function (tbl)
if RadioOff then return end

	-- if ( string.len( tbl.messages ) > 30 ) then
	-- 	table.insert(History, tbl.name..": "..tbl.messages)
	-- else
		table.insert(History, tbl.name..": "..tbl.messages)
	-- end

	if ( tbl.bool ) then
		if ( tbl.channel == fgRadio.MyChannel ) then
			chat.AddText( FgRConfig.ColorTextTeamBadDistance, tbl.name," ", FgRConfig.Translation[5]," ", tbl.messages )
			surface.PlaySound( table.Random(FgRConfig.SoundEffects) )
		else return end
	else
		if ( tbl.channel == fgRadio.MyChannel ) then
			chat.AddText( FgRConfig.ColorTextGoodDistance, tbl.name," ", FgRConfig.Translation[5]," ", tbl.messages )
			surface.PlaySound( table.Random(FgRConfig.SoundEffects) )
		else
			chat.AddText( FgRConfig.ColorTextTeamGoodDistance, tbl.name," ", FgRConfig.Translation[5]," ", tbl.messages )
			surface.PlaySound( table.Random(FgRConfig.SoundEffects) )
		end
	end
end

fgRadio.DrawHistory = function()
	local G = table.Count( History )
	local i_plus = 9
	local Pos = 150
	local SetPos = Pos
	surface.SetFont( "TextHistory" )
	surface.SetTextColor( 255, 255, 255, 255 )
		
	for key, val in pairs(History) do
		for i=0, i_plus do
			if key == G-i then
				surface.SetTextPos( 185, SetPos ) 
				surface.DrawText( val )
				SetPos = SetPos + 20
			end
		end
	end
end

fgRadio.VGUI = function()
	if not fgRadio.CheckTeamDarkRp(LocalPlayer()) then 
		chat.AddText(Color(255, 0, 0), FgRConfig.Translation[13])
		return
	end

	local xSize, ySize = ScrW()/2, ScrH()/2
	local xPos, yPos = 300, 180
	
	local BadNum = { 10, 20, 30, 40, 50, 60, 70, 80, 90 }
	
	local Body = vgui.Create( "DFrame" )
	Body:SetSize( xSize+80, ySize )
	Body:SetPos( ScrW()/2-xPos, ScrH()/2-yPos )
	Body:SetTitle( "Chat walkie-talkie" )
	Body:SetVisible( true )
	Body:SetDraggable( true )
	Body:ShowCloseButton( true )
	Body:MakePopup()
	Body.Paint = function()
		draw.RoundedBox( 8, 0, 0, Body:GetWide(), Body:GetTall(), Color( 30, 30, 30, 250 ) )
		
		surface.SetFont( "RadioFrequency" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 185, 45 )
		if fgRadio.MyChannel == nil then
			surface.DrawText( "F - NONE" )
		else
			surface.DrawText( "F - "..fgRadio.MyChannel )
		end
		
		fgRadio.DrawHistory()
	end
	
	local OnOffRadio = vgui.Create( "DButton" )
	OnOffRadio:SetParent( Body )
	OnOffRadio:SetText( FgRConfig.Translation[12] )
	OnOffRadio:SetPos( 185, 100 )
	OnOffRadio:SetSize( xSize-ySize+100, 20 )
	OnOffRadio.DoClick = function ()
		LocalPlayer():ConCommand("say "..FgRConfig.Status)
	end

	local SayF = vgui.Create( "DTextEntry", Body )
	SayF:SetPos( 185, 125 )
	SayF:SetTall( 20 )
	SayF:SetWide( xSize-ySize+100 )
	SayF:SetEnterAllowed( true )
	SayF.OnEnter = function()
		LocalPlayer():ConCommand("say "..FgRConfig.SendChannel.." "..SayF:GetValue())
		SayF:SetEnabled(false)
		SayF:SetText( "" )
		timer.Simple(0.3, function()
			SayF:SetEnabled(true)
			SayF:RequestFocus()
		end)
	end
	
	SetFManually = vgui.Create( "DTextEntry", Body )
	SetFManually:SetPos( 24, ySize-50 )
	SetFManually:SetTall( 20 )
	SetFManually:SetWide( 151 )
	SetFManually:SetEnterAllowed( true )
	SetFManually.OnEnter = function()
		LocalPlayer():ConCommand("say "..FgRConfig.SetChannel.." "..SetFManually:GetValue())
		SetFManually:SetEnabled(false)
		timer.Simple(0.3, function() SetFManually:SetEnabled(true) end)
	end
	 
	local List = vgui.Create("DListView")
	List:SetParent(Body)
	List:SetPos(25, 50)
	List:SetSize(150, ySize-100)
	List:SetMultiSelect(false)
	List:SetHideHeaders( false )
	List:AddColumn("Channel")
	List.Paint = function()
		draw.RoundedBox( 0, 0, 0, List:GetWide(), List:GetTall(), Color( 255, 255, 255, 200 ) )
	end
	
	local num_plus = nil
	List:AddLine("None")
	
	for num=FgRConfig.MinChannelNumber, FgRConfig.MaxChannelNumber do
	for _, val in pairs(BadNum) do
		if num == val then
			List:AddLine(num..".0")
		end
	end
	
	num_plus = num
		for i=1, 9 do
			num_plus = num_plus + 0.1
			List:AddLine(tostring(num_plus))
		end
		num_plus = nil
	end
	
	List.OnRowSelected = function( panel , line )
	local select = panel:GetLine(line):GetValue(1)
	
		if select == "None" then
			History = {"***"}
			fgRadio.MyChannel = nil
			SetFManually:SetText("")
			List:SetEnabled(false)
			timer.Simple(0.3, function() List:SetEnabled(true) end)
		else
			History = {"***"}
			fgRadio.MyChannel = select
			LocalPlayer():ConCommand("say "..FgRConfig.SetChannel.." "..select)
			SetFManually:SetText(select)
			timer.Simple(0.3, function() table.insert(History, FgRConfig.Translation[1]..fgRadio.MyChannel) end)
			List:SetEnabled(false)
			timer.Simple(0.3, function() List:SetEnabled(true) end)
		end
	end
	
end
concommand.Add(FgRConfig.OpenVguiConsole,fgRadio.VGUI)

fgRadio.InitializeGamemode = function()
	if engine.ActiveGamemode() == "darkrp" then
		if FgRConfig.TEAMRestriction then
			hook.Add("OnPlayerChangedTeam", nil, function(ply, b, a)
				if not table.HasValue(FgRConfig.TEAMGroup, a) then
					fgRadio.MyChannel = nil
					RadioOff = false
				end
			end)
		end
	end
end
hook.Add( "Initialize", nil, fgRadio.InitializeGamemode )

net.Receive("FGRadio_SendClient", function()
	if not fgRadio.CheckTeamDarkRp(LocalPlayer()) then 
		chat.AddText(Color(255, 0, 0), FgRConfig.Translation[13])
		return
	end

	local read = net.ReadTable()

	if read.id == "SetChannel" then
		fgRadio.SetChannel(read)
	elseif read.id == "SendChannelCheck" then
		fgRadio.SendChannelCheck(read)
	elseif read.id == "SendChannel" then
		fgRadio.SendChannel(read)
	elseif read.id == "EnableDisable" then
		fgRadio.EnableDisable()
	elseif read.id == "GetAllChannel" then
		fgRadio.GetAllChannel(read)
	elseif read.id == "GetAllChannelView" then
		fgRadio.GetAllChannelView(read)
	elseif read.id == "VGUI" then
		fgRadio.VGUI()
	end
end)