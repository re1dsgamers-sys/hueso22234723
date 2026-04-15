repeat
	task.wait()
until game:IsLoaded()

local FOLDER_PATH = "PhntomHub"
local KEY_PATH = FOLDER_PATH.."/Key.txt"

if not isfolder(FOLDER_PATH) then 
    makefolder(FOLDER_PATH)
end

script_key = script_key or (isfile(KEY_PATH) and readfile(KEY_PATH) or nil)

local Cloneref = cloneref or clonereference or function(instance) return instance end
local Players = Cloneref(game:GetService("Players"))
local HttpService = Cloneref(game:GetService("HttpService"))
local Request = http_request or request or syn.request or http

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/acezqqq/moddedfluent/refs/heads/main/main.lua"))()
local API = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()

local games = {
	Rivals = 17625359962,
	Arsebal = 4902182837
}

local GAME_SCRIPTS = {
	Rivals = "111690f677f4dd398f04d54e0e8085b7",
    Arsebal = "d1c8b9e7a0c8f2a5b3e4c6d8f9a1b2c3"
}

local function n()
    local place_id = game.PlaceId 
    
    if place_id == 17625359962 or place_id == 18126510175 or place_id == 71874690745115 or place_id == 117398147513099 then
        return GAME_SCRIPTS["Rivals"]
    end

    for name, universeId in pairs(games) do
        if game.GameId == tonumber(universeId) or game.PlaceId == tonumber(universeId) then
            return GAME_SCRIPTS[name]
        end
    end
    
    return nil
end

local scriptId = n() 

if not scriptId then
    Players.LocalPlayer:Kick("Phantom Hub doesn't support this game | Join our discord for more information")
    return
end

API.script_id = scriptId

local function notify(title, content, duration)
	UI:Notify({ Title = title, Content = content, Duration = duration or 8 })
end

local function openDiscord()
    setclipboard("https://discord.com/invite/p7W2GrUwae")
    notify("Copied To Clipboard", "Discord Server Link has been copied to your clipboard", 16)
    local discordInviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))()
    discordInviter.Join("https://discord.com/invite/p7W2GrUwae")
end

local function checkKey(input_key)
    local key = input_key or script_key
    if not key then return notify("Key Error", "No key provided") end
    
	local status = API.check_key(key)
	
	if status.code == "KEY_VALID" then
		script_key = key
		writefile(KEY_PATH, script_key)
		API.load_script()
        UI:Destroy()
        return true
	elseif status.code:find("KEY_") then
		local messages = {
			KEY_HWID_LOCKED = "Key linked to a different HWID. Please reset it using our bot",
			KEY_INCORRECT = "Key is incorrect",
			KEY_INVALID = "Key is invalid"
		}
		notify("Key Check Failed", messages[status.code] or "Unknown error")
	else
		Players.LocalPlayer:Kick("Key check failed: " .. status.message .. " Code: " .. status.code)
	end
	return false
end

local function createUI()
    local Window = UI:CreateWindow({
        Title = "Scylla",
        SubTitle = "Loader",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 320),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.End
    })

    local Tabs = { Main = Window:AddTab({ Title = "Key", Icon = "" }) }

    local Input = Tabs.Main:AddInput("Key", {
        Title = "Enter Key:",
        Default = script_key or "",
        Placeholder = "Example: agKhRikQP..",
        Numeric = false,
        Finished = false
    })

    Tabs.Main:AddButton({
        Title = "Get Your free Key ",
        Callback = function()
            setclipboard("https://ads.luarmor.net/get_key?for=Checkpoints_Linkvertise-HSVJWPYAuoAP")
            notify("Copied To Clipboard", "Ad Reward Link has been copied to your clipboard", 16)
        end
    })

    Tabs.Main:AddButton({
        Title = "Dont want to watch ads? Buy a Key here",
        Callback = function()
            setclipboard("https://phantomarket.org")
            notify("Copied To Clipboard", "Ad Reward Link has been copied to your clipboard", 16)
        end
    })

    Tabs.Main:AddButton({
        Title = "Check Key",
        Callback = function()
            checkKey(Input.Value)
        end
    })

    Tabs.Main:AddButton({
        Title = "Join Discord",
        Callback = openDiscord
    })

    Window:SelectTab(1)
    notify("Scylla", "Loader Has Loaded Successfully")
    
    return Window
end

if script_key then
    if not checkKey() then
        createUI()
    end
else
    createUI()
end

repeat
    task.wait()
until getgenv().PhantomHubLoaded == true
