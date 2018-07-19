---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Комерад.
--- DateTime: 5/30/2018 11:00 PM
---

good_hud = { };

local function clr( color ) return color.r, color.g, color.b, color.a; end

function good_hud:PaintBar( x, y, w, h, colors, value )

	self:PaintPanel( x, y, w, h, colors );

	x = x + 1; y = y + 1;
	w = w - 2; h = h - 2;

	local width = w * math.Clamp( value, 0, 1 );
	local shade = 4;

	surface.SetDrawColor( clr( colors.shade ) );
	surface.DrawRect( x, y, width, shade );

	surface.SetDrawColor( clr( colors.fill ) );
	surface.DrawRect( x, y + shade, width, h - shade );

end

function good_hud:PaintPanel( x, y, w, h, colors )

	surface.SetDrawColor( clr( colors.border ) );
	surface.DrawOutlinedRect( x, y, w, h );

	x = x + 1; y = y + 1;
	w = w - 2; h = h - 2;

	surface.SetDrawColor( clr( colors.background ) );
	surface.DrawRect( x, y, w, h );

end

function good_hud:PaintText( x, y, text, font, colors )

	surface.SetFont( font );

	surface.SetTextPos( x + 1, y + 1 );
	surface.SetTextColor( clr( colors.shadow ) );
	surface.DrawText( text );

	surface.SetTextPos( x, y );
	surface.SetTextColor( clr( colors.text ) );
	surface.DrawText( text );

end

function good_hud:TextSize( text, font )

	surface.SetFont( font );
	return surface.GetTextSize( text );

end

local vars =
{

	font = "TargetID",

	padding = 10,
	margin = 35,

	text_spacing = 2,
	bar_spacing = 5,

	bar_height = 16,

	width = 0.25

}

local colors =
{

	background =
	{

		border = Color( 255, 255, 255, 255 ),
		background = Color( 40, 40, 40, 2220 )

	},

	text =
	{

		shadow = Color( 0, 0, 0, 200 ),
		text = Color( 255, 255, 255, 255 )

	},

	health_bar =
	{

		border = Color( 255, 0, 0, 255 ),
		background = Color( 255, 0, 0, 75 ),
		shade = Color( 255, 104, 104, 255 ),
		fill = Color( 232, 0, 0, 255 )

	},

	suit_bar =
	{

		border = Color( 0, 0, 255, 255 ),
		background = Color( 0, 0, 255, 75 ),
		shade = Color( 136, 136, 255, 255 ),
		fill = Color( 0, 0, 219, 255 )

	}

}

local function HUDPaint( )

	client = client or LocalPlayer( );				-- set a shortcut to the client
	if( not client:Alive( ) ) then return; end				-- don't draw if the client is dead

	local _, th = good_hud:TextSize( "TEXT", vars.font );		-- get text size( height in this case )

	local i = 2;							-- shortcut to how many items( bars + text ) we have

	local width = vars.width * ScrW( );				-- calculate width
	local bar_width = width - ( vars.padding * i );			-- calculate bar width and element height
	local height = ( vars.padding * i ) + ( th * i ) + ( vars.text_spacing * i ) + ( vars.bar_height * i ) + vars.bar_spacing;

	local x = vars.margin;						-- get x position of element
	local y = ScrH( ) - vars.margin - height;			-- get y position of element

	local cx = x + vars.padding;					-- get x and y of contents
	local cy = y + vars.padding;

	good_hud:PaintPanel( x, y, width, height, colors.background );	-- paint the background panel

	local by = th + vars.text_spacing;				-- calc text position

	local text = string.format( "Health: %iHP", client:Health( ) );	-- get health text
	good_hud:PaintText( cx, cy, text, vars.font, colors.text );	-- paint health text and health bar
	good_hud:PaintBar( cx, cy + by, bar_width, vars.bar_height, colors.health_bar, client:Health( ) / 100 );

	by = by + vars.bar_height + vars.bar_spacing;			-- increment text position

	local text = string.format( "Suit: %iSP", client:Armor( ) );	-- get suit text
	good_hud:PaintText( cx, cy + by, text, vars.font, colors.text );	-- paint suit text and suit bar
	good_hud:PaintBar( cx, cy + by + th + vars.text_spacing, bar_width, vars.bar_height, colors.suit_bar, client:Armor( ) / 100 );

end
hook.Add( "HUDPaint", "PaintOurHud", HUDPaint );

-- Hide the standard HUD stuff
local hud = {["CHudHealth"] = true, ["CHudBattery"] = true, ["CHudAmmo"] = false, ["CHudSecondaryAmmo"] = true}
function GM:HUDShouldDraw(name)
   if hud[name] then return false end

	-- Allow the weapon to override this
	local ply = LocalPlayer()
	--local team = ply:Team()
	--print(ply:Team())
	--if ply:IsValid() and ply:IsPlayer() then
	--	if team == TEAM_SPECTATOR or team == TEAM_UNASSIGNED or team == TEAM_UNASSIGNED then
	--		--if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_CONNECTING then
	--		return false
	--	end
	--end
	if (IsValid(ply)) then
		local wep = ply:GetActiveWeapon()
		local team = ply:Team()
		if team == TEAM_SPECTATOR or team == TEAM_UNASSIGNED or team == TEAM_UNASSIGNED then
			--if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_CONNECTING then
			return false
		end
		if (IsValid(wep) and wep.HUDShouldDraw ~= nil) then
			return wep.HUDShouldDraw(wep, name)
		end
	end

	return true
end