
--[[---------------------------------------------------------
   Name: gamemode:ShowTeam()
   Desc:
-----------------------------------------------------------]]
function GM:ShowTeam()
	if ( IsValid( self.TeamSelectFrame ) ) then return end
	
	 --Simple team selection box
	self.TeamSelectFrame = vgui.Create( "DFrame" )
	self.TeamSelectFrame:SetTitle( "Pick Team" )
	function self.TeamSelectFrame:Paint()
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 230))
	end

	local AllTeams = team.GetAllTeams()
	local y = 80
	for ID, TeamInfo in pairs ( AllTeams ) do
		if ( ID ~= TEAM_CONNECTING and ID ~= TEAM_UNASSIGNED ) then
	
			local Team = vgui.Create( "DButton", self.TeamSelectFrame )
			function Team.DoClick() self:HideTeam() RunConsoleCommand( "changeteam", ID ) RequestStatus() end
			Team:SetPos( 340, y )
			Team:SetSize( 130*2, 20*2 )
			Team:SetText( TeamInfo.Name )
			function Team:Paint()
				draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(230, 230, 230, 200))
			end
			
			if ( IsValid( LocalPlayer() ) and LocalPlayer():Team() == ID ) then
				Team:SetDisabled( true )
			end
			
			y = y + 80*2
		
		end
		
	end

	if ( GAMEMODE.AllowAutoTeam ) then
	
		local Team = vgui.Create( "DButton", self.TeamSelectFrame )
		function Team.DoClick() self:HideTeam() RunConsoleCommand( "autoteam" ) end
		Team:SetPos( 10, y )
		Team:SetSize( 130, 20 )
		Team:SetText( "Auto" )
		y = y + 30
	
	end

	self.TeamSelectFrame:SetSize( ScrW()/1.5, ScrH()/1.5 )
	self.TeamSelectFrame:Center()
	self.TeamSelectFrame:MakePopup()
	self.TeamSelectFrame:SetDraggable( true )
	self.TeamSelectFrame:SetKeyboardInputEnabled( false )

end

--[[---------------------------------------------------------
   Name: gamemode:HideTeam()
   Desc:
-----------------------------------------------------------]]
function GM:HideTeam()

	if ( IsValid(self.TeamSelectFrame) ) then
		self.TeamSelectFrame:Remove()
		self.TeamSelectFrame = nil
	end

end
