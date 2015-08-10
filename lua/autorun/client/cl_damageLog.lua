textOpen = false

function ADLOpenMenu(logs, int)
	local logString = ""

	local MenuBase = vgui.Create("DFrame")
	MenuBase:SetSize(ScrW()-100, ScrH()-100)
	MenuBase:SetPos(50, 50)
	MenuBase:SetTitle("Advanced Damage Logger")
	MenuBase:SetDeleteOnClose(false)
	MenuBase:SetDraggable(false)
	MenuBase:SetBackgroundBlur(false)
//	MenuBase:Center(true)
	MenuBase:SetVisible(true)
	MenuBase:ShowCloseButton(false)
	MenuBase:MakePopup()

	local cl = vgui.Create("DButton", MenuBase)
	cl:SetSize( 50, 24 )
	cl:SetPos( MenuBase:GetWide() - 51, 1 )
	cl:SetText( "X" )
	cl:SetFont( "CloseCaption_Bold" )
	cl:SetTextColor( Color( 255, 255, 255, 255 ) )
	cl.Paint = function( self, w, h )
		local kcol
		if self.hover then
			kcol = Color( 255, 150, 150, 255 )
		else
			kcol = Color( 175, 100, 100 )
		end
		draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, kcol, false, false, true, true )
	end
	cl.DoClick = function()
		MenuBase:Close()
		textOpen = false
	end
	cl.OnCursorEntered = function( self )
		self.hover = true
	end
	cl.OnCursorExited = function( self )
		self.hover = false
	end

	local ScrollBar = vgui.Create( "DScrollPanel", MenuBase )
	ScrollBar:SetSize( MenuBase:GetWide() - 30, MenuBase:GetTall() - 35 )
	ScrollBar:SetPos( 5,30 )

	local Instructions = vgui.Create("DLabel", ScrollBar)
	Instructions:SetPos(5, 10)
	Instructions:SetText("Click on a log to copy it to your clipboard, you can then ctrl+v to paste it elsewhere")
	Instructions:SizeToContents()

	local timeLeft = vgui.Create("DLabel", ScrollBar)
	timeLeft:SetPos(ScrollBar:GetWide() - 190, 55)
	timeLeft:SetText("Time before log wipe: "..int.." Seconds")
	timeLeft:SizeToContents()

	local admin = false
	if LocalPlayer():IsSuperAdmin() or LocalPlayer():IsAdmin() then admin = true end
	if AdvancedDamageLogger_ulx == true then
		for k,v in pairs(AdvancedDamageLogger_AdminRanks) do
			if LocalPlayer():IsUserGroup(v) then admin = true end
		end
	end

	if (AdvancedDamageLogger_ButtonsAdminOnly == true and admin == true) or AdvancedDamageLogger_ButtonsAdminOnly == false then
		local wipe = vgui.Create("DButton", ScrollBar)
		wipe:SetPos(ScrollBar:GetWide() - 190, 5)
		wipe:SetText("Wipe Logs")
		wipe:SizeToContentsX(10)
		wipe:SizeToContentsY(10)
		wipe.DoClick = function()
			net.Start("WipeAdvancedDamageLogger")
			net.SendToServer()
		end

		local delay = vgui.Create("DButton", ScrollBar)
		delay:SetPos(ScrollBar:GetWide() - 125, 5)
		delay:SetText("Delay Auto Log Wipe")
		delay:SizeToContentsX(10)
		delay:SizeToContentsY(10)
		delay.DoClick = function()
			net.Start("DelayAdvancedDamageLoggerWipe")
			net.SendToServer()
		end
	end

	local refresh = vgui.Create("DButton", ScrollBar)
	refresh:SetPos(ScrollBar:GetWide() - 190, 30)
	refresh:SetText("Refresh")
	refresh:SizeToContentsX(10)
	refresh:SizeToContentsY(10)
	refresh.DoClick = function()
		ADLCloseMenu()
		local posx, posy = input.GetCursorPos()
		LocalPlayer():ConCommand(AdvancedDamageLogger_ConCommand)
		timer.Simple( 0.05, function() input.SetCursorPos(posx, posy) end)
	end

	local consolepr = vgui.Create("DButton", ScrollBar)
	consolepr:SetPos(ScrollBar:GetWide() - 125, 30)
	consolepr:SetText("Print log to console")
	consolepr:SizeToContentsX(10)
	consolepr:SizeToContentsY(10)
	consolepr.DoClick = function()
		local ply = LocalPlayer()
		ply:PrintMessage(2, "\n\n=====DAMAGE LOGS=====\n\n")
		for k,v in pairs(logs) do
			ply:PrintMessage(2, v.."\n")
		end
		ply:PrintMessage(2, "\n=====================\n")
	end

	local location = 30

	for k,v in pairs(logs) do
		local prLog = vgui.Create("DButton", ScrollBar)
		prLog:SetPos(5, location)
		prLog:SetText(v)
		prLog:SizeToContentsX(10)
		prLog:SizeToContentsY(10)
		prLog.DoClick = function()
			LocalPlayer():ChatPrint("Text Copied to clipboard!")
			SetClipboardText(v)
		end
		location = location + 25
	end

	function ADLCloseMenu() MenuBase:Close(); textOpen = false end
end
net.Receive("openAdvancedDamageLogger", function(len,ply)
	local logs 	= net.ReadTable()
	local int 	=	net.ReadInt(32)
	if textOpen == false then ADLOpenMenu(logs, int); textOpen = true else ADLCloseMenu() end
end)

net.Receive("refreshAdvancedDamageLogger", function(len,ply)
	if textOpen == true then
		local logs = net.ReadTable()
		local int 	=	net.ReadInt(32)
		ADLCloseMenu()
		ADLOpenMenu(logs, int)
		textOpen = true
	end
end)
