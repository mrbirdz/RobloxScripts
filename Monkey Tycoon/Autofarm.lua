
-- // made by RVVZ/RomanTrotman helo guyss!! (PRANK!)
-- // btw script itself have a anti-afk thing so dont worry lol

getgenv().SuperSprint = true -- idk why i added it lol i just bored
getgenv().AutoBuyMonkey = true
getgenv().AutoMerge = true

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local AfkRemote = ReplicatedStorage.GTycoonClient.Remotes.TeleportHub
local LocalPlayer = game:GetService('Players').LocalPlayer
local SprintFunc = getsenv(LocalPlayer.PlayerGui.MainUI.Sprint["Click_ControlButton"]).StartSprint

local LocalDataModule = require(ReplicatedStorage.GTycoonClient.Modules.LocalDataCache)
local DropperSettings = require(ReplicatedStorage.Modules.DropperSettings)

LocalPlayer:SetAttribute("AutoCollect", true)

local function getMonkeyPrice()
	local Price = DropperSettings.PricePerDropper * LocalDataModule.Data.DropperCount
	if LocalDataModule.Data.DropperCount + 5 <= DropperSettings.EasyCutoff then
		Price = Price * DropperSettings.EasyMultiplier
	end
	return Price * 5
end

for i, v in pairs(getconnections(LocalPlayer.Idled)) do -- anti afk stuff
    if v["Disable"] then
        v["Disable"](v)
    elseif v["Disconnect"] then
        v["Disconnect"](v)
    end
end

LocalPlayer.leaderstats.Coins.Changed:Connect(function(val)
    if val > getMonkeyPrice() and AutoBuyMonkey then
        ReplicatedStorage.GTycoonClient.Remotes.BuyDropper:FireServer(5)
    end
    if AutoMerge then
        ReplicatedStorage.GTycoonClient.Remotes.MergeDroppers:FireServer()
    end
end)

LocalDataModule.OnChangedEvent("DropperCurrency"):Connect(function(t)
    if t ~= 0 then
        ReplicatedStorage.GTycoonClient.Remotes.DepositDrops:FireServer()
    end
end)

local old
old = hookfunction(SprintFunc, function()
    if SuperSprint then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 65
    end
end)
old = hookmetamethod(game, "__namecall", function(Self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and Self == AfkRemote  then
        return
    end
    
    return old(Self, ...)
end)
