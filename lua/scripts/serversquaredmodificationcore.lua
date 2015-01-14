PLUGIN_NAME = "(server)^2 Modification"
PLUGIN_AUTHOR = "server"
PLUGIN_VERSION = "9.0.0" -- In development!
ALPHA = true
BETA = false
BUILD_DATE = "13 January 2015"
COPYRIGHT_REGISTRATION_YEAR = "2015"
SS_SITE = "serversquared.noip.me"

--[[ ################################################################
Copyright (C) server - All Rights Reserved.
Unauthorized copying of this file, via any medium, is strictly prohibited.
This is closed-source, non-free software.
Proprietary and confidential.
Written by server <serversquaredmain@gmail.com>, January 2015.
     ################################################################   ]]

-- Define blank to help prevent errors, space to make spaces more readable.
blank = ""
space = " "

-- Include the AssaultCube server core.
include("ac_server")

-- Present a friendly message for the server configuration interface.
io.write("\nWelcome to (server)^2 Modification version " .. PLUGIN_VERSION .. "!")
if ALPHA or BETA then io.write("\n********************\n/!\\ WARNING /!\\\nTHIS BUILD IS INCOMPLETE AND MAY CAUSE STABILITY ISSUES!\nUSE AT YOUR OWN RISK!\n********************") end
io.write("\nPlease report any bugs immediately!")
io.write("\nLet's configure your server.")
io.write("\n============================================================")
-- Determine if we're running on a UNIX-based system
if package.config:sub(1,1) == "/" then
	unix = true
else
	unix = false -- Ew.
end
-- Get current working directory
if unix then
	local handle = io.popen("pwd")
	ACPath = handle:read("*a")
	handle:close()
	ACPath = string.gsub(ACPath, "\n", "")
else
	local handle = io.popen("cd")
	ACPath = handle:read("*a")
	handle:close()
	ACPath = string.gsub(ACPath, "\n", "")
end
-- Should we load a configuration file?
repeat
	io.write("\nLoad from config file? Answer n if you don't have one. (y/n)")
	io.write("\n>")
	configAnswer = io.read()
	if configAnswer == "n" then
		loadFromConfig = false
	elseif configAnswer == blank or "y" then
		loadFromConfig = true
	end
until loadFromConfig ~= nil
-- Finish configuring the server if user answered no.
if not loadFromConfig then
	-- What should the server be called?
	io.write("\nWhat would you like your server to be called?")
	io.write("\nUse the server colour codes if desired.")
	io.write("\n>")
	serverName = (io.read() or blank)
	-- Get the user website for our API.
	io.write("\nWhat's your website URL?")
	io.write("\n>")
	serverWebsite = (io.read() or blank)
	-- Make it easier on the user and offer a config save.
	repeat
		io.write("\nWould you like to save your configuration?")
		io.write("\n>")
		configAnswer = io.read()
		if configAnswer == "n" then
			configCompleted = true
		elseif configAnswer == blank or "y" then
			if not cfg.exists("serversquared.serverconfig") then
				cfg.createfile("serversquared.serverconfig")
			end
			cfg.setvalue("serversquared.serverconfig", "ACPath", ACPath)
			cfg.setvalue("serversquared.serverconfig", "serverName", serverName)
			cfg.setvalue("serversquared.serverconfig", "serverWebsite", serverWebsite)
			io.write("\nConfiguration saved.")
			configCompleted = true
		end
	until configCompleted == true
	
	-- Load configuration if user answered yes previously.
	else
		ACPath = cfg.getvalue("serversquared.serverconfig", "ACPath")
		serverName = cfg.getvalue("serversquared.serverconfig", "serverName")
		serverWebsite = cfg.getvalue("serversquared.serverconfig", "serverWebsite")
end
-- Tell user configuration is complete and we'll take it from here.
io.write("\nThank you for using (server)^2 Modification!")
io.write("\nThe modification will now continue to load.\n")

-- Load our variables.
restartMessage = false			-- Notify if the server was restarted.
textEcho = false				-- Global echo back coloured text.
colouredText = true				-- Allow or disallow coloured chat.
useAdminSystem = false			-- Use an external Administration system.
useMuteSystem = false			-- Use an external player muting system.
-- Initialize our tables.
loadedModules = {}				-- Table of Modules that we've loaded.
serverColour = {				-- Table of colours for the server.
"\f4",							-- Primary colour.
"\f3",							-- Secondary colour.
"\f0",							-- Public chat colour.
"\f1",							-- Team chat colour.
}

-- Core functions.

-- Make it easier to talk to the players.
function say(text, toCN, excludeCN)
	if toCN == nil then
		toCN = -1
	end
	if excludeCN == nil then
		excludeCN = -1
	end
	if text == nil then
		text = blank
	end
	clientprint(toCN, text, excludeCN)
end

-- Chat decoding and processing. Chat and commands will probably break if this is changed.
function onPlayerSayText(CN, text, isTeam, isMe)
	-- Initialize chatPrefix.
	chatPrefix = blank
	
	-- Make a Server Master prefix if using default admin system.
	if isadmin(CN) then
		chatPrefix = "@"
	end
	
	-- Use dynamic prefixes if using our external Administration system.
	if useAdminSystem then
		if modModerator[getip(CN)] then
			chatPrefix = "M"
		end
		if modAdministrator[getip(CN)] then
			chatPrefix = "A"
		end
		if modMaster[getip(CN)] then
			chatPrefix = "@"
		end
	end
	
	-- Block muted clients if using our external Muting system.
	if useMuteSystem then
		if isMuted[getip(CN)] then
			blockChatReason = "Client is muted."
			blockChat(CN, text, isTeam, isMe, blockChatReason)
			return PLUGIN_BLOCK
		end
	end
	
	-- -- Test for profanity, if list is present.
	-- if not chatIsClean(text) then
		-- blockChatReason = "Chat contains profanity."
		-- blockChat(CN, text, isTeam, isMe, blockChatReason)
		-- return PLUGIN_BLOCK
	-- end
	
	-- Convert colour codes if enabled on our server.
	if colouredText then
		text = string.gsub(text, "\\f", "\f")
	end
	
	-- Split the text into an array.
	local array = split(text, " ")
	-- Separate the command from the arguments.
	local command, args = array[1], slice(array, 2)
	-- Check if the text is a command, execute if it is.
	if commands[command] ~= nil then
		local params, callback = commands[command][1], commands[command][2]
		callback(CN, args)
		return PLUGIN_BLOCK
	elseif string.byte(command,1) == string.byte("!",1) then
		return PLUGIN_BLOCK		
	end
	
	-- Chat function
	printChat(text, CN, chatPrefix, isTeam, isMe)
	return PLUGIN_BLOCK
	
end

commands = {}

-- Chat printing
function printChat(text, CN, chatPrefix, isTeam, isMe)
	if isTeam then
		for x=0,maxclient(),1 do
			if getteam(CN) == getteam(x) and CN ~= x then
				say(serverColour[1] .. CN .. "\f3" .. chatPrefix .. serverColour[2] .. "#" .. (isMe and serverColour[4] or "\f5") .. getname(CN) .. serverColour[4] .. (isMe and space or ": ") .. text, x, (textEcho and -1 or CN))
			end
		end
	else
		say(serverColour[1] .. CN .. "\f3" .. chatPrefix .. serverColour[2] .. "#" .. (isMe and serverColour[3] or "\f5") .. getname(CN) .. serverColour[3] .. (isMe and space or ": ") .. text, -1, (textEcho and -1 or CN))
	end
end