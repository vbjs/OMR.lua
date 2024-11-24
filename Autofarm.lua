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

-- MAIN LOOP --

-- SKIP LABEL DETECTION -- 
game:GetService("RunService").Heartbeat:Connect(function()
    task.wait()
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
end)

-- MAIN LOOP --
while task.wait() do
  if Config.Enabled then
    if plr.Data.Renewal.Value < 250 then
      task.wait(2)
      local args = {[1] = Config.Third}
      loadlayout:FireServer(unpack(args))
      repeat task.wait() until tonumber(string.match(skip, "%d+")) > Config.MinSkip
      renew:FireServer()
      plr:WaitForChild("PlayerGui"):WaitForChild("PlayerUI"):WaitForChild("Settings"):WaitForChild("Progression"):WaitForChild("ScrollingFrame"):WaitForChild("Renewal"):WaitForChild("LifeSkip").Text = "1"
    elseif plr.Data.Renewal.Value >= 250 and plr.Data.Renewal.Value < 750 then
      task.wait(2)
      local args = {[1] = Config.First}
      loadlayout:FireServer(unpack(args))
      repeat task.wait() until tonumber(string.match(skip, "%d+")) > Config.MinSkip
      renew:FireServer()
      plr:WaitForChild("PlayerGui"):WaitForChild("PlayerUI"):WaitForChild("Settings"):WaitForChild("Progression"):WaitForChild("ScrollingFrame"):WaitForChild("Renewal"):WaitForChild("LifeSkip").Text = "1"
    elseif plr.Data.Renewal.Value >= 750 then
      task.wait(2)
      local args = {[1] = Config.Second}
      loadlayout:FireServer(unpack(args))
      repeat task.wait() until tonumber(string.match(skip, "%d+")) > Config.MinSkip
      plr:WaitForChild("PlayerGui"):WaitForChild("PlayerUI"):WaitForChild("Settings"):WaitForChild("Progression"):WaitForChild("ScrollingFrame"):WaitForChild("Renewal"):WaitForChild("LifeSkip").Text = "1"
      renew:FireServer()
     end
    end
  if Config.AutoAscend then
    if plr.Data.Renewal.Value >= (tonumber(string.match(asc, "%d+"))*2) then
      task.wait(1)
      ascendremote:FireServer()
      rejoin()
    end
  end
  end
