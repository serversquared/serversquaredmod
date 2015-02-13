PLUGIN_NAME = "(server)^2 Modification"
PLUGIN_AUTHOR = "server"
PLUGIN_VERSION = "9.0.0" -- In development!

--[[ ################################################################
              Copyright (C) Niko Geil - All Rights Reserved.         
             This work is licensed under the Creative Commons        
         Attribution-NonCommercial-NoDerivatives 4.0 International   
              License. To view a copy of this license, visit         
             http://creativecommons.org/licenses/by-nc-nd/4.0/       
      Please read the software license agreement carefully. By using 
	 all or any portion of the software, you are agreeing to be bound
	 by all the terms and conditions of this agreement. If you do not
	  agree to any terms of this agreement, do not use the software. 
      Written by Niko Geil <server@serversquared.org>, January 2015. 
     ################################################################   ]]

-- $ symbol will be used to mark problems, bugs, things that should be changed, etc.

-- Main table for the Core.
SSCore = {}
SSCore.baseversionCore = "9"			-- Base version of the Core.
SSCore.baseversionAPI = "1"				-- Base version of the Core API. Modules should probably work if they were written for this base version.
SSCore.versionCore = "9.0.0"			-- Version of the Core.
SSCore.versionAPI = "1.0"				-- Version of the Core API.
SSCore.alpha = false					-- True if this build is an alpha build.
SSCore.beta = true						-- True if this build is a beta build.
SSCore.buildDate = "29 January 2015"	-- Build date of this release. Not changed for dev builds.
SSCore.copyright = "2015"				-- Year of Copyright registration.
SSCore.url = "serversquared.org"		-- URL of the (server)^2 website.
SSCore.enableLog = true					-- Turn on or off mod logging.
SSCore.debugMode = false				-- Turn on or off debug (verbose) mode. This WILL write to the log.
SSCore.logInfo = true					-- Turn on or off logging "INFO" level messages.

-- Function to write the log.
function SSCore.log(message, level, sender)
	-- Do not continue if logging is off
	if not SSCore.enableLog then
		return
	end
	-- Log and print message, warn if incorrect syntax.
	if level == 0 and message ~= nil and sender ~= nil and SSCore.debugMode then
		print("[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
	elseif level == 1 and message ~= nil and sender ~= nil and SSCore.debugMode then
		print("[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
	elseif level == 2 and message ~= nil and sender ~= nil and SSCore.logInfo then
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/INFO]: " .. message)
	elseif level == 3 and message ~= nil and sender ~= nil then
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/WARN]: " .. message)
	elseif level == 4 and message ~= nil and sender ~= nil then
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/ERROR]: " .. message)
	elseif level == 20 and message ~= nil and sender ~= nil then
		logline(4, "[" .. os.date("%X") .. "] [" .. sender .. "/FATAL]: " .. message)
	elseif level == 21 and message ~= nil and sender ~= nil then
		logline(2, "[" .. os.date("%X") .. "] [" .. sender .. "/SHUTDOWN]: " .. message)
	elseif level == 22 and message ~= nil and sender ~= nil then
		logline(1, "[" .. os.date("%X") .. "] [" .. sender .. "/CHAT]: " .. message)
	elseif (level == 0 and message ~= nil and sender ~= nil and not SSCore.debugMode) or (level == 1 and message ~= nil and sender ~= nil and not SSCore.debugMode) or (level == 2 and message ~= nil and sender ~= nil and not SSCore.logInfo) then
		return
	else
		logline(3, "[" .. os.date("%X") .. "] [Server Core/WARN]: Log message was sent in the incorrect syntax.")
	end
end

function fileExists(name)
	SSCore.log("Checking if file exists: " .. name, 0, "Server Core")
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		SSCore.log("File exists.", 0, "Server Core")
		return true
	else
		SSCore.log("File does not exist.", 0, "Server Core")
		return false
	end
end

-- Patch the server before the rest of the mod loads if pre-patch is found.
if fileExists("lua/scripts/SSModules/prepatch.ssp") then
	SSCore.log("Pre-patch found, applying...", 2, "Server Core")
	if pcall(dofile, "lua/scripts/SSModules/prepatch.ssp") then
		SSCore.log("Pre-patch applied.", 2, "Server Core")
	else
		SSCore.log("Error applying pre-patch.", 4, "Server Core")
	end
end

function SSCore.patchServer()
	-- Patch the server if patch file exists.
	if fileExists("lua/scripts/SSModules/patch.ssp") then
		SSCore.log("Patch found, applying...", 2, "Server Core")
		if pcall(dofile, "lua/scripts/SSModules/patch.ssp") then
			SSCore.log("Patch applied.", 2, "Server Core")
		else
			SSCore.log("Error applying patch.", 4, "Server Core")
		end
	end
end

-- Define blank to help prevent errors, space to make spaces more readable.
blank = ""
space = " "
baaaby = "and I\'ll write your name"

-- $$$ I feel like the below functions to load up dependencies sucks.

-- Load the AC Server main functions.
function incac_server()
	include("ac_server")
end
if not pcall(incac_server) then
	SSCore.log("Dependency not found: ac_server", 20, "Server Core")
	os.exit()
end
incac_server = nil

-- Load the (server)^2 Handler Extension API
function incSSHandlerExtensionAPI()
	include("SSHandlerExtensionAPI")
end
if not pcall(incSSHandlerExtensionAPI) then
	SSCore.log("Dependency not found: SSHandlerExtensionAPI", 20, "Server Core")
	os.exit()
end
incSSHandlerExtensionAPI = nil

-- Load LuaSocket
function reqsocket()
	socket = require("socket")
	http = require("socket.http")
end
if not pcall(reqsocket) then
	SSCore.log("Dependency not found: socket", 20, "Server Core")
	os.exit()
end
reqsocket = nil

-- Load Lua-Ex
function reqex()
	require("ex")
end
if not pcall(reqex) then
	SSCore.log("Dependency not found: ex", 20, "Server Core")
	os.exit()
end
reqex = nil

-- Load SHA-1
function reqsha1()
	sha1 = require("sha1")
end
if not pcall(reqsha1) then
	SSCore.log("Dependency not found: sha1", 20, "Server Core")
	os.exit()
end
reqsha1 = nil

-- Load ansicolors
function reqansicolors()
	colors = require("ansicolors")
end
if not pcall(reqansicolors) then
	SSCore.log("Dependency not found: ansicolors", 20, "Server Core")
	os.exit()
end
reqansicolors = nil

-- $$$ Yup, that sucked.

-- Send data to (server)^2.
-- Not the most efficient code if you need to send multiple times, as it closes the connection each time you call the function.
function SSCore.sendToServer(data, getReply)
	SSCore.log("Setting socket mode.", 0, "Server Core")
	local udp = socket.udp()
	SSCore.log("Setting peer name.", 0, "Server Core")
	udp:setpeername(SSCore.url, 53472)
	udp:settimeout(5)
	SSCore.log("Sending: " .. data, 0, "Server Core")
	udp:send(data)
	if getReply then
		SSCore.log("Waiting for reply...", 0, "Server Core")
		local data, err = udp:receive()
			if data then
				SSCore.log("Reply received: " .. data, 0, "Server Core")
				return true, data
			elseif err then
				SSCore.log("Network error: " .. err, 4, "Server Core")
				return false, "Network error: " .. tostring(err)
			end
	end
	udp:close()
end

-- Send an HTTP GET request to (server)^2 and return the received data.
function SSCore.getFromServer(file)
	SSCore.log("Setting socket mode.", 0, "Server Core")
	SSCore.log("Setting host.", 0, "Server Core")
	local host = "http://" .. SSCore.url .. (file or blank)
	SSCore.log("Testing connection.", 0, "Server Core")
	local data, reply, head = http.request("http://" .. SSCore.url .. "/test.html")
	if reply == 200 and data == blank then
		SSCore.log("Sending request: GET " .. (file or blank), 0, "Server Core")
		local data, reply, head = http.request(host)
		if reply == 200 and data then
			SSCore.log("HTTP/1.1 " .. reply, 0, "Server Core")
			return data, nil
		else
			SSCore.log("HTTP error: " .. tostring(reply), 4, "Server Core")
			return nil, reply
		end
	else
		SSCore.log("HTTP error: " .. tostring(reply), 4, "Server Core")
		return nil, reply
	end
end

-- Calculate myself.
-- Returns true, hash if completed successfully. False if not.
function SSCore.checkHash()
	SSCore.log("Calculating SHA-1 hash of the Core...", 2, "Server Core")
	if fileExists("lua/scripts/serversquaredmodificationcore.lua") then
		io.input("lua/scripts/serversquaredmodificationcore.lua")
	elseif fileExists("lua/scripts/serversquaredmodificationcore.luac") then
		io.input("lua/scripts/serversquaredmodificationcore.luac")
	else
		SSCore.log("Could not find the Server Core.", 3, "Server Core")
		return false, "Server Core does not exist?"
	end
	local core = io.read("*all")
	io.input(io.stdin)
	local hash = sha1(core)
	SSCore.log("Calculated: " .. hash, 2, "Server Core")
	return true, hash
end

-- Check myself with papa server to make sure no one's harmed me.
-- We're only using UPD because I can't figure out how to use flipping TCP.
-- If you have a sucky Internet connection this might fail.
-- If you have NO Internet connection, I will crash. No idea why.
function SSCore.verify()
	local completed, hash_or_error = SSCore.checkHash()
	if completed then
		SSCore.log("Trying to connect to (server)^2...", 2, "Server Core")
		local received, msg = SSCore.sendToServer("ping", true)
		if received and msg == "pong" then
			SSCore.log("Connection established.", 2, "Server Core")
			local received, msg = SSCore.sendToServer("verify", true)
			if received and msg == "sendChecksum" then
				local received, msg = SSCore.sendToServer(hash_or_error, true)
				if received and msg == SSCore.versionCore then
					SSCore.log("SHA-1 Checksum is Valid.", 2, "Server Core")
				else
					SSCore.log("Could not verify Core: " .. msg, 4, "Server Core")
					SSCore.log("DO NOT SUBMIT BUG REPORTS OR REPORT CRASHES!", 4, "Server Core")
					SSCore.log("YOU CANNOT RECEIVE SUPPORT FOR THIS COPY OF (server)^2 Modification!", 4, "Server Core")
					SSCore.log("DO NOT DISTRIBUTE THIS COPY OR LEGAL ACTION WILL BE TAKEN!", 4, "Server Core")
					socket.sleep(5)
				end
			else
				SCore.log("Could not verify Core: " .. msg, 4, "Server Core")
			end
		else
			SSCore.log("Connection failed: " .. msg, 4, "Server Core")
			SSCore.log("If your copy of (server)^2 Modification is modded, you may not", 4, "Server Core")
			SSCore.log("submit bug reports or crashes. DO NOT DISTRIBUTE, OR LEGAL", 4, "Server Core")
			SSCore.log("ACTION WILL BE TAKEN!", 4, "Server Core")
			socket.sleep(5)
		end
	else
		SSCore.log("Could not calculate SHA-1 Checksum: " .. hash_or_error, 4, "Server Core")
		SSCore.log("If your copy of (server)^2 Modification is modded, you may not", 4, "Server Core")
		SSCore.log("submit bug reports or crashes. DO NOT DISTRIBUTE, OR LEGAL", 4, "Server Core")
		SSCore.log("ACTION WILL BE TAKEN!", 4, "Server Core")
		socket.sleep(5)
	end
end

function SSCore.booleanConvert(stringOrBoolean)
	if type(stringOrBoolean) == "string" then
		if stringOrBoolean == "false" then
			return false
		elseif stringOrBoolean == "true" then
			return true
		end
	elseif type(stringOrBoolean) == "boolean" then
		if not stringOrBoolean then
			return "false"
		elseif stringOrBoolean then
			return "true"
		end
	else
		return
	end
end

function SSCore.loadConfig()
	if not cfg.exists("serversquared.serverconfig") then
		cfg.createfile("serversquared.serverconfig")
		cfg.setvalue("serversquared.serverconfig", "serverName", blank)
		cfg.setvalue("serversquared.serverconfig", "serverMOTD", blank)
		cfg.setvalue("serversquared.serverconfig", "serverWebsite", blank)
		cfg.setvalue("serversquared.serverconfig", "chatEcho", SSCore.booleanConvert(false))			-- Global echo back coloured chat.
		cfg.setvalue("serversquared.serverconfig", "colouredChat", SSCore.booleanConvert(true))			-- Allow or disallow coloured chat.
		cfg.setvalue("serversquared.serverconfig", "useAdminSystem", SSCore.booleanConvert(false))		-- Use an external Administration system.
		cfg.setvalue("serversquared.serverconfig", "useChatFilter", SSCore.booleanConvert(false))		-- Use an external chat filter system.
		cfg.setvalue("serversquared.serverconfig", "serverColours.primary", "\f4")						-- Primary colour.
		cfg.setvalue("serversquared.serverconfig", "serverColours.secondary", "\f3")					-- Secondary colour.
		cfg.setvalue("serversquared.serverconfig", "serverColours.chatPublic", "\f0")					-- Public chat colour.
		cfg.setvalue("serversquared.serverconfig", "serverColours.chatTeam", "\f1")						-- Team chat colour.
	end
	SSCore.chatEcho = SSCore.booleanConvert(cfg.getvalue("serversquared.serverconfig", "chatEcho"))
	SSCore.colouredChat = SSCore.booleanConvert(cfg.getvalue("serversquared.serverconfig", "colouredChat"))
	SSCore.useAdminSystem = SSCore.booleanConvert(cfg.getvalue("serversquared.serverconfig", "useAdminSystem"))
	SSCore.useChatFilter = SSCore.booleanConvert(cfg.getvalue("serversquared.serverconfig", "useChatFilter"))
	SSCore.serverColours.primary = cfg.getvalue("serversquared.serverconfig", "serverColours.primary")
	SSCore.serverColours.secondary = cfg.getvalue("serversquared.serverconfig", "serverColours.secondary")
	SSCore.serverColours.chatPublic = cfg.getvalue("serversquared.serverconfig", "serverColours.chatPublic")
	SSCore.serverColours.chatTeam = cfg.getvalue("serversquared.serverconfig", "serverColours.chatTeam")
end

function SSCore.init()
	SSCore.log("Initializing the Modification.", 2, "Server Core")
	-- Load our variables.
	SSCore.log("Loading Global configuration variables.", 1, "Server Core")
	SSCore.serverColours = {}				-- Table of colours for the server.
	SSCore.loadConfig()

	-- Initialize handlerPlayerSayText
	handlerPlayerSayText = {}

	SSCore.verify()
end

--[[
  ## Once upon a time, a young app named Core lived in
  ## a very small house with his mother and father. One
  ## time, during dinner, he asked, "Papa server, where
  ## do applications come from?"
  ## 
  1# His father looked at his wife, then turned back to
  ## young Core and said, "Core, we hope you never have
  ## to see or go through how they are made."
  ## 
  ## Core became very frightened, and didn't speak of
  ## the matter again.
  ]]

function SSCore.configServer()
	-- Present a friendly message for the server configuration interface.
	SSCore.log("Writing configuration interface.", 1, "Server Core")
	io.write(colors("\n%{reset bright black}       _  ____    ____    _  ___    _    _   ____    _  ___    _   2%{reset}\n"))
	io.write(colors("%{reset bright black}     / / / __/   /  _ \\  | |/ _ \\  | |  | | /  _ \\  | |/ _ \\  \\ \\%{reset}\n"))
	io.write(colors("%{reset bright black}    | |  \\ \\__   | |_| | |  _/ \\_\\ | |  | | | |_| | |  _/ \\_\\  | |%{reset}\n"))
	io.write(colors("%{reset bright black}    | |   \\__ \\  |  __/  | |       | |  | | |  __/  | |        | |%{reset}\n"))
	io.write(colors("%{reset bright black}    | |    __\\ \\ | |___  | |        \\ \\/ /  | |___  | |        | |%{reset}\n"))
	io.write(colors("%{reset bright black}     \\_\\   \\___/  \\___/  |_|         \\__/    \\___/  |_|       /_/%{reset}\n"))
	io.write(colors("\n%{reset bright cyan}Welcome to (server)^2 Modification %{reset bright blue}version " .. SSCore.versionCore .. "%{reset bright cyan}!%{reset}\n"))
	if SSCore.alpha or SSCore.beta then io.write(colors("%{reset red}********************\n%{reset redbg dim black}/!\\ WARNING /!\\%{reset}\n%{reset red}THIS BUILD IS INCOMPLETE AND MAY CAUSE STABILITY ISSUES!%{reset}\n%{reset red}USE AT YOUR OWN RISK!%{reset}\n%{reset red}********************%{reset}\n")) end
	io.write(colors("%{reset dim white}Please report any bugs to the issue tracker at:%{reset}\n"))
	io.write(colors("%{reset blue underline}https://github.com/account3r2/serversquaredmod/issues%{reset}\n"))
	io.write(colors("%{reset bright yellow}By using all or any portion of the software, you are agreeing to be bound%{reset}\n"))
	io.write(colors("%{reset bright yellow}by all the terms and conditions of the license agreement.%{reset}\n"))
	io.write(colors("%{reset bright yellow}See the license file for more information.%{reset}\n"))
	io.write(colors("%{reset bright blue}Let's configure your server.%{reset}\n"))
	io.write(colors("%{reset blue}============================================================%{reset}\n"))
	-- Get current working directory
	SSCore.log("Getting Current Working Directory.", 1, "Server Core")
	SSCore.ACPath = os.currentdir()
	SSCore.log("We are here: " .. SSCore.ACPath, 0, "Server Core")
	-- Determine if we're running on a Unix-like system
	if package.config:sub(1,1) == "/" then
		unix = true
	else
		unix = false
	end
	SSCore.log("We are " .. (unix and "not " or blank) .. "on a Windows NT-based system.", 0, "Server Core")

	-- Automatically start the server if autostart file is present.
	if SSCore.autoLoadServer() then return end

	-- Set input to stdin just in case.
	io.input(io.stdin)
	-- Should we load a configuration file?
	repeat
		io.write("Load from config file? Answer n if you don't have one. (y/n)\n")
		io.write(">")
		configAnswer = io.read()
		if configAnswer == "n" then
			loadFromConfig = false
		elseif configAnswer == blank or configAnswer == "y" then
			if not cfg.exists("serversquared.serverconfig") then
				io.write("Config file does not exist!\n")
			else
				loadFromConfig = true
			end
		end
	until loadFromConfig ~= nil
	-- Finish configuring the server if user answered no.
	if not loadFromConfig then
	SSCore.log("User wants to create a new config.", 1, "Server Core")
		-- What should the server be called?
		io.write("\nWhat would you like your server to be called?\n")
		io.write("Use the server colour codes if desired.\n")
		io.write(">")
		SSCore.serverName = (io.read() or blank)
		-- What should the server MOTD be?
		io.write("\nWhat would you like your MOTD to be?\n")
		io.write("Use the server colour codes if desired.\n")
		io.write(">")
		SSCore.serverMOTD = (io.read() or blank)
		-- Get the user website for our API.
		io.write("\nWhat's your website URL?\n")
		io.write(">")
		SSCore.serverWebsite = (io.read() or blank)
		-- Make it easier on the user and offer a config save.
		repeat
			io.write("\nWould you like to save your configuration?\n")
			io.write(">")
			configAnswer = io.read()
			if configAnswer == "n" then
				SSCore.log("User completed config, and does not want to save to file.", 1, "Server Core")
				configCompleted = true
			elseif configAnswer == blank or configAnswer == "y" then
				SSCore.log("User completed config. Starting write to file.", 1, "Server Core")
				if not cfg.exists("serversquared.serverconfig") then
					SSCore.log("Config does not exist. Creating a new file.", 0, "Server Core")
					cfg.createfile("serversquared.serverconfig")
				end
				SSCore.log("Writing config values to file.", 0, "Server Core")
				cfg.setvalue("serversquared.serverconfig", "serverName", SSCore.serverName)
				cfg.setvalue("serversquared.serverconfig", "serverMOTD", SSCore.serverMOTD)
				cfg.setvalue("serversquared.serverconfig", "serverWebsite", SSCore.serverWebsite)
				SSCore.log("Config saved.", 0, "Server Core")
				io.write("\nConfiguration saved.")
				configCompleted = true
			end
		until configCompleted == true
		
		-- Load configuration if user answered yes previously.
		else
			SSCore.log("Loading configuration from file.", 1, "Server Core")
			SSCore.serverName = cfg.getvalue("serversquared.serverconfig", "serverName")
			SSCore.serverMOTD = cfg.getvalue("serversquared.serverconfig", "serverMOTD")
			SSCore.serverWebsite = cfg.getvalue("serversquared.serverconfig", "serverWebsite")
			SSCore.log("serverName = " .. SSCore.serverName, 0, "Server Core")
			SSCore.log("serverWebsite = " .. SSCore.serverWebsite, 0, "Server Core")
	end
	
	configAnswer = nil
	configCompleted = nil
	
	-- Tell user configuration is complete and we'll take it from here.
	io.write("\nThank you for using (server)^2 Modification!\n")
	io.write("The modification will now continue to load.\n")

	setservname(SSCore.serverName)
	setmotd(SSCore.serverMOTD)
end

function SSCore.autoLoadServer()
	-- Automatically start the server if autoload file exists.
	if fileExists("lua/scripts/SSModules/SSAutoStart.ssp") and cfg.exists("serversquared.serverconfig") then
		SSCore.log("Loading configuration from file.", 1, "Server Core")
		SSCore.serverName = cfg.getvalue("serversquared.serverconfig", "serverName")
		SSCore.serverMOTD = cfg.getvalue("serversquared.serverconfig", "serverMOTD")
		SSCore.serverWebsite = cfg.getvalue("serversquared.serverconfig", "serverWebsite")
		SSCore.log("serverName = " .. SSCore.serverName, 0, "Server Core")
		SSCore.log("serverWebsite = " .. SSCore.serverWebsite, 0, "Server Core")
		SSCore.log("Autostart file found, applying settings.", 2, "Server Core")
		setservname(SSCore.serverName)
		setmotd(SSCore.serverMOTD)
		if pcall(dofile, "lua/scripts/SSModules/SSAutoStart.ssp") then
			SSCore.log("Settings applied.", 2, "Server Core")
			return true
		else
			SSCore.log("Error applying autostart settings.", 4, "Server Core")
			return false
		end
	else
		return false
	end
end

-- Make it easier to talk to the players.
function SSCore.say(text, toCN, excludeCN)
	SSCore.log("Starting say function.", 1, "Server Core")
	if toCN == nil then
		SSCore.log("Recipient was not given, making the message global.", 0, "Server Core")
		toCN = -1
	end
	if excludeCN == nil then
		SSCore.log("Excluded client was not given, making the message global.", 0, "Server Core")
		excludeCN = -1
	end
	if text == nil then
		SSCore.log("Text was not given, sending a blank message.", 0, "Server Core")
		text = blank
	end
	SSCore.log("Printing to " .. toCN .. " excluding " .. excludeCN, 1, "Server Core")
	clientprint(toCN, text, excludeCN)
end

-- Used in commands to determine permissions level.
-- Permission levels: 0 Unregistered, 1 User, 2 Moderator, 3 Admin, 4 Server Master.
function SSCore.requirePerms(level, CN)
	if isadmin(CN) then
		SSCore.log("Client is logged in as AC admin, returning level 4.", 0, "Server Core")
		return true, 4
	end
	if SSCore.useAdminSystem then
		SSCore.log("AdminSystem is enabled, getting permissions from external system.", 0, "Server Core")
		if getPerms ~= nil then
			local hasPerms, hasLevel = getPerms(CN)
			SSCore.log("Received: " .. (hasPerms and "No " or "Has") .. " permissions, level " .. tostring(hasLevel), 0, "Server Core")
			if hasPerms then
				if hasLevel >= level then
					return true, hasLevel
				else
					SSCore.say("\f3Insufficient permissions to use this command.", CN)
					return false, hasLevel
				end
			else
				return false, nil		-- $$$$$ This does not make sense.
			end
		else
			SSCore.log("AdminSystem is enabled but no Admin system was found, disabling.", 3, "Server Core")
			SSCore.useAdminSystem = false
		end
	end
	SSCore.say("\f3Insufficient permissions to use this command.", CN)
	return false, nil
end

-- Run a Module.
-- I'm really proud of this one <3
function SSCore.runModule(moduleName, unloadModule, booleanMode)
	SSCore.log("Starting runModule function.", 1, "Server Core")
	local loadStartTick = getsvtick()
	if unloadModule == nil or moduleName == nil then
		SSCore.log("runModule was called using incorrect syntax, stopping.", 3, "Server Core")
	end
	SSCore.log("Loading Module" .. (unloadModule and " in unload mode" or blank) .. ": " .. moduleName, 2, "Server Core")
	if pcall(dofile, "lua/scripts/SSModules/" .. moduleName .. ".ssm") then
		if unloadModule then
			if onModuleUnload ~= nil then
				onModuleUnload()
			end
			if addCommands ~= nil then
				for commandName in pairs(addCommands) do
					commands[commandName] = nil
				end
			end
		elseif not unloadModule then
			if addCommands ~= nil then
				for commandName,commandFunction in pairs(addCommands) do
					commands[commandName] = commandFunction
				end
			end
			if onModuleLoad ~= nil then
				onModuleLoad()
			end
		end
		onModuleLoad = nil
		onModuleUnload = nil
		local loadTime = (getsvtick() - loadStartTick)
		SSCore.log("Successfully loaded Module in " .. loadTime .. "ms.", 2, "Server Core")
		if unloadModule then
			SSCore.loadedModules[moduleName] = nil
			SSCore.log("Removed module from loadedModules table.", 0, "Server Core")
		else
			SSCore.loadedModules[moduleName] = true
			SSCore.checkModule(moduleName, moduleInfo)
			SSCore.log("Added Module to loadedModules table.", 0, "Server Core")
		end
		if booleanMode ~= nil and booleanMode then
			return true
		end
	else
		SSCore.log("Error loading Module.", 4, "Server Core")
		if booleanMode ~= nil and booleanMode then
			return false
		end
	end
end

-- Check if a Module is built for our API base version.
function SSCore.checkModule(moduleName, moduleInfo)
	if moduleInfo ~= nil then
		if moduleInfo.usesbaseAPI ~= nil and moduleInfo.usesbaseAPI < SSCore.baseversionAPI then
			SSCore.log("Module " .. moduleName .. " is built for old API version " .. moduleInfo.usesAPI .. ". It may have compatibility issues.", 3, "Server Core")
		end
		moduleInfo = nil
	else
		SSCore.log("Module " .. moduleName .. " does not have a config. This may cause issues if the API version is outdated.", 3, "Server Core") 
	end
end

-- Chat printing
function SSCore.printChat(text, CN, chatPrefix, isTeam, isMe)
	print("[" .. os.date("%X") .. "] [" .. getip(CN) .. "] " .. (isTeam and "[TEAM] " or blank) .. (isMe and "[ME] " or blank) .. getname(CN) .. " (" .. CN .. ") says: \"" .. text .. "\"")
	SSCore.log("[" .. getip(CN) .. "] " .. (isTeam and "[TEAM] " or blank) .. (isMe and "[ME] " or blank) .. getname(CN) .. " (" .. CN .. ") says: \"" .. text .. "\"", 22, "Server Core")
	if isTeam then
		for x=0,maxclient(),1 do
			if getteam(CN) == getteam(x) and CN ~= x then
				SSCore.say(SSCore.serverColours.primary .. CN .. "\f3" .. chatPrefix .. SSCore.serverColours.secondary .. "#" .. (isMe and SSCore.serverColours.chatTeam or "\f5") .. getname(CN) .. SSCore.serverColours.chatTeam .. (isMe and space or ": ") .. text, x, (SSCore.chatEcho and -1 or CN))
			end
		end
	else
		SSCore.say(SSCore.serverColours.primary .. CN .. "\f3" .. chatPrefix .. SSCore.serverColours.secondary .. "#" .. (isMe and SSCore.serverColours.chatPublic or "\f5") .. getname(CN) .. SSCore.serverColours.chatPublic .. (isMe and space or ": ") .. text, -1, (SSCore.chatEcho and -1 or CN))
	end
end

-- Chat decoding and processing.
-- Chat and commands will probably break if this is changed by a Module, unless the Module author /really/ knows what they're doing.
-- Module authors: Use the handler extension API to extend this function if desired.
function onPlayerSayText(CN, text, isTeam, isMe)
	SSCore.log("Starting processing client chat.", 1, "Server Core")
	
	-- Run chat extensions (if present)
	SSCore.log("Running chat extensions (if present).", 1, "Server Core")
	for tableName, tableValue in pairs(handlerPlayerSayText) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerSayText[tableName][handlerFunction](CN, text, isTeam, isMe) == false then
				return PLUGIN_BLOCK		-- If the handler extension returns false, chat processing will stop here. This allows for high customizability.
			end
		end
	end
	-- Initialize chatPrefix.
	SSCore.log("Setting chat prefix to blank.", 0, "Server Core")
	local chatPrefix = blank
	
	-- Make a Server Master prefix if using default admin system.
	-- $$$ This needs to be changed. It sucks.
	if isadmin(CN) then
		SSCore.log("Client is logged in as the server administrator, not using modded system. Setting prefix to @.", 0, "Server Core")
		local chatPrefix = "@"
	end
	
	-- Use dynamic prefixes if using our external Administration system.
	-- $$$ This needs to be changed. It sucks.
	if SSCore.useAdminSystem then
		local hasPerms, hasLevel = getPerms(CN)
		SSCore.log("Server is using modded admin system, checking for permissions.", 0, "Server Core")
		if hasPerms and hasLevel == 2 then
			SSCore.log("Client has Moderator permissions. Setting prefix to M.", 0, "Server Core")
			local chatPrefix = "M"
		end
		if hasPerms and hasLevel == 3 then
			SSCore.log("Client has Administrator permissions. Setting prefix to A.", 0, "Server Core")
			local chatPrefix = "A"
		end
		if hasPerms and hasLevel == 4 then
			SSCore.log("Client has Master permissions. Setting prefix to @.", 0, "Server Core")
			local chatPrefix = "@"
		end
	end

	-- Test for profanity if using a filter system.
	-- $$$ Look into seeing if a Module can do this with the chat handler extension API. This function is probably useless.
	if SSCore.useChatFilter then
		SSCore.log("Server is using modded profanity filter, checking for bloked words.", 0, "Server Core")
		if not chatIsClean(text) then
			SSCore.log("Chat contains a blocked word, stopping chat processing.", 0, "Server Core")
			blockChatReason = "Chat contains profanity."
			SSCore.log("Sending chat to filter system to take over chat processing.", 0, "Server Core")
			blockChat(CN, text, isTeam, isMe, blockChatReason)
			return PLUGIN_BLOCK
		end
	end
	
	-- Convert colour codes if enabled on our server.
	if SSCore.colouredChat then
		SSCore.log("Server has coloured text enabled, reprocessing and converting colour codes.", 0, "Server Core")
		local text = string.gsub(text, "\\f", "\f")
	end
	
	-- Split the text into a table.
	SSCore.log("Converting the sent chat into a table for command processing.", 0, "Server Core")
	local array = split(text, " ")
	-- Separate the command from the arguments.
	SSCore.log("Separating the command (first table entry) from the arguments.", 0, "Server Core")
	local command, args = array[1], slice(array, 2)
	-- Check if the text is a command, execute if it is.
	if commands[command] ~= nil then
		SSCore.log("Chat is a command, processing from command list.", 1, "Server Core")
		SSCore.log("[" .. getip(CN) .. "] " .. getname(CN) .. " (" .. CN .. ") called: \"" .. text .. "\"", 22, "Server Core")
		print("[" .. os.date("%X") .. "] [" .. getip(CN) .. "] " .. getname(CN) .. " (" .. CN .. ") called: \"" .. text .. "\"")
		local callback = commands[command][1]
		callback(CN, args)
		return PLUGIN_BLOCK
	elseif string.byte(command,1) == string.byte("!",1) then
		SSCore.log("Chat is not a command but in command notation. Stopping chat processing.", 1, "Server Core")
		SSCore.log("[" .. getip(CN) .. "] " .. getname(CN) .. " (" .. CN .. ") called non-command: \"" .. text .. "\"", 22, "Server Core")
		print("[" .. os.date("%X") .. "] [" .. getip(CN) .. "] " .. getname(CN) .. " (" .. CN .. ") called non-command: \"" .. text .. "\"")
		SSCore.say("\f3(?) Not a command: " .. command, CN)
		return PLUGIN_BLOCK		
	end
	
	-- Chat function
	SSCore.log("Initial chat processing complete, sending to printChat to determine teams and /me.", 1, "Server Core")
	SSCore.printChat(text, CN, chatPrefix, isTeam, isMe)
	return PLUGIN_BLOCK
end

-- Core Commands
commands = {
	["!loadModule"] = {
		function (CN, args)
			if not SSCore.requirePerms(4, CN) then return end
			SSCore.log("loadModule command started.", 1, "Server Core")
			if args[2] ~= nil and  ("remove" or "unload") then
				SSCore.log("Unload mode set.", 0, "Server Core")
				unloadModule = true
			else
				unloadModule = false
			end
			SSCore.log("Calling runModule to load the Module.", 0, "Server Core")
			if SSCore.runModule(args[1], unloadModule, true) then
				SSCore.say("Module was " .. (unloadModule and "un" or blank) .. "loaded successfully.", CN)		-- $$$ I don't think this works because runModule() deletes unloadModule.
			else
				SSCore.say("Module failed to load.", CN)
			end
		end
	},

	["!info"] = {
		function (CN, args)
			SSCore.say(SSCore.serverColours.primary .. "(server)^2 Modification Core " .. SSCore.serverColours.secondary .. "v" .. SSCore.versionCore .. SSCore.serverColours.primary .. " Created by " .. SSCore.serverColours.secondary .. "server", CN)
			SSCore.say(SSCore.serverColours.primary .. "Copyright (C) " .. SSCore.copyright .. " server. All Rights Reserved.", CN)
		end
	},

	["!stop"] = {
		function (CN, args)
			if not SSCore.requirePerms(4, CN) then return end
			SSCore.log("Shutting down the server (Sent from player: " .. getname(CN) .. ")...", 21, "Server Core")
			os.exit()
		end
	}
}

function onInit()
	SSCore.loadedModules = {}		-- Table of Modules that we've loaded.
	SSCore.init()

	-- Patch the server if patch file exists.
	SSCore.patchServer()

	SSCore.log("Done.", 2, "Server Core")
	SSCore.configServer()
end

function onDestroy()
	SSCore.log("The server is being stopped gracefully.", 21, "Server Core")

	-- Let all loaded Modules do anything they need to before the Core stops.
	SSCore.log("Running Module shutdown scripts.", 21, "Server Core")
	for moduleName in pairs(SSCore.loadedModules) do
		SSCore.log("Unloading Module " .. moduleName, 21, "Server Core")
		SSCore.runModule(moduleName, true)
	end

	io.write("Thank you for using (server)^2 Modification.\n")
end
-- I love you, Caitlyn (: