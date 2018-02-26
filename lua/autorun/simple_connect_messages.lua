-- Simple connection messages addon
-- by daunknownman2010


-- Serverside only
if ( SERVER ) then

-- Create the server convars
local scm_enabled = CreateConVar( "scm_enabled", 1, { FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Enable Simple Connect Messages." )
local scm_request_client_info = CreateConVar( "scm_request_client_info", 1, { FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Requests client information when the player initially spawns in." )
local scm_server_name = CreateConVar( "scm_server_name", "", { FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Sets the #svname format with the given string (eg. [My Server])." )
local scm_connect_message = CreateConVar( "scm_connect_message", "$green #svname $white Player $211,211,211 #name $white has joined the game", FCVAR_ARCHIVE, "Set the player connect message." )
local scm_connect_sound = CreateConVar( "scm_connect_sound", "", FCVAR_ARCHIVE, "Set the player cpnnect sound." )
local scm_loaded_message = CreateConVar( "scm_loaded_message", "$green #svname $white Player $211,211,211 #name $white has finished loading", FCVAR_ARCHIVE, "Set the player loaded message." )
local scm_loaded_sound = CreateConVar( "scm_loaded_sound", "", FCVAR_ARCHIVE, "Set the player loaded sound." )
local scm_disconnect_message = CreateConVar( "scm_disconnect_message", "$green #svname $white Player $211,211,211 #name $white left the game #reason", FCVAR_ARCHIVE, "Set the player disconnect message." )
local scm_disconnect_sound = CreateConVar( "scm_disconnect_sound", "", FCVAR_ARCHIVE, "Set the player disconnect sound." )


-- Create the net tables
util.AddNetworkString( "SCMRequestClientInformation" )
util.AddNetworkString( "SCMSendClientInformation" )
util.AddNetworkString( "SCMDisplayText" )


-- Color names (rainbow + white&black is default)
local COLOR_NAMES = {
	white = "255 255 255",
	red = "255 0 0",
	orange = "255 165 0",
	yellow = "255 255 0",
	green = "0 128 0",
	blue = "0 0 255",
	indigo = "75 0 130",
	violet = "127 0 255",
	black = "0 0 0"
}


-- Player connected
function SCMPlayerConnect( data )

	-- Store the message in this variable
	local msgTable = {}

	-- Begin the message table
	table.insert( msgTable, Color( 255, 255, 255 ) )
	table.insert( msgTable, "" )

	-- Process the message
	for k, v in pairs( string.Explode( " ", scm_connect_message:GetString() ) ) do
	
		-- Process string formats
		if ( string.find( v, "#svname" ) ) then
		
			if ( scm_server_name:GetString() != "" ) then
			
				-- #svname server name
				local svName = "["..scm_server_name:GetString().."]"
			
				-- Add to the message table
				table.insert( msgTable, svName.." " )
			
			end
		
		elseif ( string.find( v, "#name" ) ) then
		
			-- Add to the message table
			table.insert( msgTable, data.name.." " )
		
		elseif ( string.find( v, "#ip" ) ) then
		
			if ( ( data.address != "" ) && ( data.address != "none" ) ) then
			
				-- Add to the message table
				table.insert( msgTable, "<"..data.address.."> " )
			
			end
		
		elseif ( string.find( v, "#id" ) ) then
		
			-- Add to the message table
			table.insert( msgTable, "<"..data.networkid.."> " )
		
		elseif ( string.StartWith( v, "$" ) ) then
		
			-- Store the string here for color conversion
			local colorString = v
		
			-- Replace $ and commas
			colorString = string.Replace( colorString, "$", "" )
			colorString = string.Replace( colorString, ",", " " )
		
			-- Given color names
			for k2, v2 in pairs( COLOR_NAMES ) do
			
				if ( colorString == k2 ) then
				
					colorString = v2
				
				end
			
			end
		
			-- Convert and add to the message table
			table.insert( msgTable, string.ToColor( colorString.." 255" ) )
		
		else
		
			-- Add to the message table
			table.insert( msgTable, v.." " )
		
		end
	
	end

	-- Send the message to all clients
	if ( scm_enabled:GetBool() && ( scm_connect_message:GetString() != "" ) ) then
	
		net.Start( "SCMDisplayText" )
			net.WriteTable( msgTable )
		net.Broadcast()
	
		-- Send a sound
		if ( scm_disconnect_sound:GetString() != "" ) then
		
			BroadcastLua( "surface.PlaySound( \""..scm_connect_sound:GetString().."\" )" )
		
		end
	
	end

end
gameevent.Listen( "player_connect" )
hook.Add( "player_connect", "SCMPlayerConnect", SCMPlayerConnect )


-- Player disconnected
function SCMPlayerDisconnect( data )

	-- Store the message in this variable
	local msgTable = {}

	-- Begin the message table
	table.insert( msgTable, Color( 255, 255, 255 ) )
	table.insert( msgTable, "" )

	-- Process the message
	for k, v in pairs( string.Explode( " ", scm_disconnect_message:GetString() ) ) do
	
		-- Process string formats
		if ( string.find( v, "#svname" ) ) then
		
			if ( scm_server_name:GetString() != "" ) then
			
				-- #svname server name
				local svName = "["..scm_server_name:GetString().."]"
			
				-- Add to the message table
				table.insert( msgTable, svName.." " )
			
			end
		
		elseif ( string.find( v, "#name" ) ) then
		
			-- Add to the message table
			table.insert( msgTable, data.name.." " )
		
		elseif ( string.find( v, "#id" ) ) then
		
			-- Add to the message table
			table.insert( msgTable, "<"..data.networkid.."> " )
		
		elseif ( string.find( v, "#reason" ) ) then
		
			-- Add to the message table
			table.insert( msgTable, "("..data.reason..") " )
		
		elseif ( string.StartWith( v, "$" ) ) then
		
			-- Store the string here for color conversion
			local colorString = v
		
			-- Replace $ and commas
			colorString = string.Replace( colorString, "$", "" )
			colorString = string.Replace( colorString, ",", " " )
		
			-- Given color names
			for k2, v2 in pairs( COLOR_NAMES ) do
			
				if ( colorString == k2 ) then
				
					colorString = v2
				
				end
			
			end
		
			-- Convert and add to the message table
			table.insert( msgTable, string.ToColor( colorString.." 255" ) )
		
		else
		
			-- Add to the message table
			table.insert( msgTable, v.." " )
		
		end
	
	end

	-- Send the message to all clients
	if ( scm_enabled:GetBool() && ( scm_disconnect_message:GetString() != "" ) ) then
	
		net.Start( "SCMDisplayText" )
			net.WriteTable( msgTable )
		net.Broadcast()
	
		-- Send a sound
		if ( scm_disconnect_sound:GetString() != "" ) then
		
			BroadcastLua( "surface.PlaySound( \""..scm_disconnect_sound:GetString().."\" )" )
		
		end
	
	end

end
gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "SCMPlayerDisconnect", SCMPlayerDisconnect )


-- Player's initial spawn
function SCMPlayerInitialSpawn( ply )

	-- Request client info
	if ( scm_enabled:GetBool() && scm_request_client_info:GetBool() ) then
	
		net.Start( "SCMRequestClientInformation" )
		net.Send( ply )
	
	end

end
hook.Add( "PlayerInitialSpawn", "SCMPlayerInitialSpawn", SCMPlayerInitialSpawn )


-- Client sent back information so we should broadcast text
function SCMSendClientInformation( len, ply )

	-- Store operating system string
	local operatingSystem = net.ReadString()

	-- Store the message in this variable
	local msgTable = {}

	-- Begin the message table
	table.insert( msgTable, Color( 255, 255, 255 ) )
	table.insert( msgTable, "" )

	-- Process the message
	for k, v in pairs( string.Explode( " ", scm_loaded_message:GetString() ) ) do
	
		-- Process string formats
		if ( string.find( v, "#svname" ) ) then
		
			if ( scm_server_name:GetString() != "" ) then
			
				-- #svname server name
				local svName = "["..scm_server_name:GetString().."]"
			
				-- Add to the message table
				table.insert( msgTable, svName.." " )
			
			end
		
		elseif ( string.find( v, "#name" ) ) then
		
			-- Add to the message table
			table.insert( msgTable, ply:Nick().." " )
		
		elseif ( string.find( v, "#ip" ) ) then
		
			if ( ( ply:IPAddress() != "" ) && ( ply:IPAddress() != "Error!" ) ) then
			
				-- Add to the message table
				table.insert( msgTable, "<"..ply:IPAddress().."> " )
			
			end
		
		elseif ( string.find( v, "#id" ) ) then
		
			-- Add to the message table
			table.insert( msgTable, "<"..ply:SteamID().."> " )
		
		elseif ( string.find( v, "#system" ) ) then
		
			-- Add to the message table
			table.insert( msgTable, operatingSystem.." " )
		
		elseif ( string.StartWith( v, "$" ) ) then
		
			-- Store the string here for color conversion
			local colorString = v
		
			-- Replace $ and commas
			colorString = string.Replace( colorString, "$", "" )
			colorString = string.Replace( colorString, ",", " " )
		
			-- Given color names
			for k2, v2 in pairs( COLOR_NAMES ) do
			
				if ( colorString == k2 ) then
				
					colorString = v2
				
				end
			
			end
		
			-- Convert and add to the message table
			table.insert( msgTable, string.ToColor( colorString.." 255" ) )
		
		else
		
			-- Add to the message table
			table.insert( msgTable, v.." " )
		
		end
	
	end

	-- Send the message to all clients
	if ( scm_enabled:GetBool() && ( scm_loaded_message:GetString() != "" ) ) then
	
		net.Start( "SCMDisplayText" )
			net.WriteTable( msgTable )
		net.Broadcast()
	
		-- Send a sound
		if ( scm_loaded_sound:GetString() != "" ) then
		
			BroadcastLua( "surface.PlaySound( \""..scm_loaded_sound:GetString().."\" )" )
		
		end
	
	end

end
net.Receive( "SCMSendClientInformation", SCMSendClientInformation )

end


-- Clientside only
if ( CLIENT ) then

-- Requested client information
function SCMRequestClientInformation( len )

	-- OS information
	local operatingSystem = "N/A"	-- Unknown?
	if ( system.IsWindows() ) then
	
		operatingSystem = "Windows"	-- Windows
	
	elseif ( system.IsOSX() ) then
	
		operatingSystem = "macOS"	-- OS X
	
	elseif ( system.IsLinux() ) then
	
		operatingSystem = "Linux"	-- Linux
	
	end

	-- Send back client-specific information
	net.Start( "SCMSendClientInformation" )
		net.WriteString( operatingSystem )
	net.SendToServer()

end
net.Receive( "SCMRequestClientInformation", SCMRequestClientInformation )


-- Display sent text
function SCMDisplayText( len )

	chat.AddText( unpack( net.ReadTable() ) )

end
net.Receive( "SCMDisplayText", SCMDisplayText )

end
