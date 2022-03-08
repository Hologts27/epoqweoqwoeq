for i,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "CoreNiggaService" then
        v:Destroy()
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/teppyboy/RbxScripts/master/Misc/UI_Libraries/Zypher/Library.lua"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local main = library:CreateMain({
    projName = "CoreNiggaService",
    Resizable = true,
    MinSize = UDim2.new(0,400,0,400),
    MaxSize = UDim2.new(0,750,0,500),
})

local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()

local reportcat = main:CreateCategory("Report Info")
local reportsec = reportcat:CreateSection("Reports")

local report = plr.PlayerData.Report

reportsec:Create("Textlabel","Welcome "..plr.DisplayName.." re-execute in game to see full menu")
reportsec:Create("Textlabel","------------------------------------------------------------------")
reportsec:Create("Textlabel","You've been reported for hacking "..report.Hacking.Value.." times.")
reportsec:Create("Textlabel","You've been reported for TKing "..report.TeamKilling.Value.." times.")
reportsec:Create("Textlabel","You've been reported for griefing "..report.Griefing.Value.." times.")
reportsec:Create("Textlabel","You've been reported for being toxic "..report.ToxicBehaviour.Value.." times.")
reportsec:Create("Textlabel","------------------------------------------------------------------")
for i,v in pairs(report.PlayersReported:GetChildren()) do
    reportsec:Create("Textlabel","You have reported "..v.Name)
end

mouse.KeyDown:connect(function(key)
    if key == "n" then
        local gui = game:GetService("CoreGui"):FindFirstChild("CoreNiggaService").Motherframe
        if gui.Visible == true then
            gui.Visible = false
        else
            gui.Visible = true
        end
    end
end)
