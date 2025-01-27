repeat task.wait() until game:IsLoaded()
task.wait(8)

getgenv().Config = {
  ["Enabled"] = true,
  ["AutoAscend"] = true,
  ["MinSkip"] = 10,
  ["First"] = 1,
  ["Second"] = 2,
  ["Third"] = 3
}

local game = game
plr = game.Players.LocalPlayer
skiplabel = plr.PlayerGui.PlayerUI.Settings.Progression.ScrollingFrame.Renewal.LifeSkip
asclabel = plr.PlayerGui.PlayerUI.Settings.Progression.ScrollingFrame.Ascension.Cost
local ascendremote = game.ReplicatedStorage.Remotes.Ascend
local renew = game.ReplicatedStorage.Remotes.Renew
local loadlayout = game.ReplicatedStorage.Remotes.LoadLayout
local Dir = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
time = 0


Dir.DescendantAdded:Connect(function(Err)
    if Err.Name == "ErrorTitle" then
        Err:GetPropertyChangedSignal("Text"):Connect(function()
            if Err.Text:sub(0, 12) == "Disconnected" then
               rejoin()
           end
       end)
    end
end)

local args = {[1] = 1}
game:GetService("ReplicatedStorage").Remotes.LoadSlot:FireServer(unpack(args))
task.wait(7)
local todel = game:GetService("Players").LocalPlayer.PlayerGui.Intro
todel:Destroy()

-- ANTI AFK --
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

queueonteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/vbjs/OMR.lua/refs/heads/main/Autofarm.lua"))()')

-- REJOIN FUNCTION --
local rejoin = function()
plr:Kick("You just ascended -> rejoining...")
task.wait()
game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end

-- SKIP LABEL DETECTION -- 
game:GetService("RunService").Heartbeat:Connect(function()
    task.wait(1)
    time = time+1
    if skiplabel then
      skip = skiplabel.Text
    else
      skiplabel = plr:WaitForChild("PlayerGui"):WaitForChild("PlayerUI"):WaitForChild("Settings"):WaitForChild("Progression"):WaitForChild("ScrollingFrame"):WaitForChild("Renewal"):WaitForChild("LifeSkip")
      if skiplabel then
        skip = skiplabel.Text
      end
    skip = skiplabel.Text
    end
    if asclabel then
     asc = asclabel.Text 
    else
     asclabel = plr:WaitForChild("PlayerGui"):WaitForChild("PlayerUI"):WaitForChild("Settings"):WaitForChild("Progression"):WaitForChild("ScrollingFrame"):WaitForChild("Ascension"):WaitForChild("Cost")
      if asclabel then asc = asclabel.Text end
    asc = asclabel.Text
    end
    if time >= 1800 then
       rejoin()
    end
end)

-- MAIN LOOP --
while task.wait() do
  if Config.Enabled then
    if plr.Data.Renewal.Value < 100000 then
      task.wait(2)
      local args = {[1] = Config.Second}
      loadlayout:FireServer(unpack(args))
      repeat task.wait() until tonumber(string.match(skip, "%d+")) > Config.MinSkip
      renew:FireServer()
      plr:WaitForChild("PlayerGui"):WaitForChild("PlayerUI"):WaitForChild("Settings"):WaitForChild("Progression"):WaitForChild("ScrollingFrame"):WaitForChild("Renewal"):WaitForChild("LifeSkip").Text = "1"
    elseif plr.Data.Renewal.Value >= 100000 and plr.Data.Renewal.Value < 9999999999999999999999 then
      task.wait(2)
      local args = {[1] = Config.First}
      loadlayout:FireServer(unpack(args))
      repeat task.wait() until tonumber(string.match(skip, "%d+")) > Config.MinSkip
      renew:FireServer()
      plr:WaitForChild("PlayerGui"):WaitForChild("PlayerUI"):WaitForChild("Settings"):WaitForChild("Progression"):WaitForChild("ScrollingFrame"):WaitForChild("Renewal"):WaitForChild("LifeSkip").Text = "1"
    elseif plr.Data.Renewal.Value >= 9999999999999999999999 then
      task.wait(2)
      local args = {[1] = Config.Second}
      loadlayout:FireServer(unpack(args))
      repeat task.wait() until tonumber(string.match(skip, "%d+")) > Config.MinSkip
      plr:WaitForChild("PlayerGui"):WaitForChild("PlayerUI"):WaitForChild("Settings"):WaitForChild("Progression"):WaitForChild("ScrollingFrame"):WaitForChild("Renewal"):WaitForChild("LifeSkip").Text = "1"
      renew:FireServer()
     end
    end
  if Config.AutoAscend then
    if plr.Data.Renewal.Value >= tonumber(string.match(asc, "%d+")) then
      task.wait(1)
      ascendremote:FireServer()
      task.wait(5)
      rejoin()
    end
  end
  end
