local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local character, humanoid

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
end
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

-- Destroy existing GUI if present
local existingGui = player:WaitForChild("PlayerGui"):FindFirstChild("JHUB")
if existingGui then existingGui:Destroy() end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JHUB"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 230)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

mainFrame.Active = true
mainFrame.Draggable = false -- Disable default draggability

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "JHUB Universal Softaim"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Position = UDim2.new(0, 10, 0, 40)
sliderLabel.Size = UDim2.new(0, 200, 0, 20)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Aimbot Strength"
sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 14
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = mainFrame

local sliderBg = Instance.new("Frame")
sliderBg.Position = UDim2.new(0, 10, 0, 65)
sliderBg.Size = UDim2.new(0, 200, 0, 5)
sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = mainFrame

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 10, 0, 20)
sliderKnob.Position = UDim2.new(0, 0, 0, sliderBg.Position.Y.Offset - 7)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = mainFrame

local smoothAimSpeed, draggingStrength = 30, false  -- Increased default strength
local aimbotEnabled = true

sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingStrength = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingStrength = false end
end)

local fovLabel = Instance.new("TextLabel")
fovLabel.Position = UDim2.new(0, 10, 0, 100)
fovLabel.Size = UDim2.new(0, 200, 0, 20)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "Aimbot FOV"
fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 14
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = mainFrame

local fovSliderBg = Instance.new("Frame")
fovSliderBg.Position = UDim2.new(0, 10, 0, 125)
fovSliderBg.Size = UDim2.new(0, 200, 0, 5)
fovSliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fovSliderBg.BorderSizePixel = 0
fovSliderBg.Parent = mainFrame

local fovSliderKnob = Instance.new("Frame")
fovSliderKnob.Size = UDim2.new(0, 10, 0, 20)
fovSliderKnob.Position = UDim2.new(0, 0, 0, fovSliderBg.Position.Y.Offset - 7)
fovSliderKnob.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
fovSliderKnob.BorderSizePixel = 0
fovSliderKnob.Parent = mainFrame

local aimFOV, draggingFOV = 200, false

fovSliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingFOV = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingFOV = false end
end)

local infoLabel = Instance.new("TextLabel")
infoLabel.Position = UDim2.new(0, 10, 0, 155)
infoLabel.Size = UDim2.new(0, 230, 0, 60)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Text = "[3] Toggle Aimbot\n[4/5] Strength +/-\n[6/7] FOV +/-\n[9] Save Config\n[0] Load Config"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = mainFrame

local fovCircle = Instance.new("ImageLabel")
fovCircle.Size = UDim2.new(0, aimFOV * 2, 0, aimFOV * 2)
fovCircle.Position = UDim2.new(0.5, -aimFOV, 0.5, -aimFOV)
fovCircle.BackgroundTransparency = 1
fovCircle.Image = "rbxassetid://6031097864"
fovCircle.ImageColor3 = Color3.fromRGB(255, 255, 255)
fovCircle.ZIndex = 0
fovCircle.Parent = screenGui

local configFileName = "JHUBConfig.json"

local function saveConfig()
    local configData = {
        smoothAimSpeed = smoothAimSpeed,
        aimFOV = aimFOV,
        aimbotEnabled = aimbotEnabled,
    }
    local json = HttpService:JSONEncode(configData)
    if writefile then
        writefile(configFileName, json)
        print("[JHUB] Config saved")
    end
end

local function loadConfig()
    if isfile and isfile(configFileName) then
        local json = readfile(configFileName)
        local data = HttpService:JSONDecode(json)
        smoothAimSpeed = data.smoothAimSpeed or smoothAimSpeed
        aimFOV = data.aimFOV or aimFOV
        aimbotEnabled = data.aimbotEnabled or aimbotEnabled
        print("[JHUB] Config loaded")
    else
        print("[JHUB] No config file found")
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Four then
        smoothAimSpeed = math.clamp(smoothAimSpeed + 1, 1, 100) -- max 100 now
    elseif input.KeyCode == Enum.KeyCode.Five then
        smoothAimSpeed = math.clamp(smoothAimSpeed - 1, 1, 100)
    elseif input.KeyCode == Enum.KeyCode.Six then
        aimFOV = math.clamp(aimFOV + 10, 50, 1000)
    elseif input.KeyCode == Enum.KeyCode.Seven then
        aimFOV = math.clamp(aimFOV - 10, 50, 1000)
    elseif input.KeyCode == Enum.KeyCode.Three or input.KeyCode == Enum.KeyCode.KeypadThree then
        aimbotEnabled = not aimbotEnabled
    elseif input.KeyCode == Enum.KeyCode.Nine then
        saveConfig()
    elseif input.KeyCode == Enum.KeyCode.Zero then
        loadConfig()
    end
end)

RunService.RenderStepped:Connect(function()
    if draggingStrength then
        local mouseX = UserInputService:GetMouseLocation().X
        local sliderStart = sliderBg.AbsolutePosition.X
        local sliderEnd = sliderStart + sliderBg.AbsoluteSize.X
        local clampedX = math.clamp(mouseX, sliderStart, sliderEnd)
        local relativeX = clampedX - sliderStart
        smoothAimSpeed = math.clamp((relativeX / sliderBg.AbsoluteSize.X) * 99 + 1, 1, 100)
    end
    local relativeX = ((smoothAimSpeed - 1) / 99) * sliderBg.AbsoluteSize.X
    sliderKnob.Position = UDim2.new(0, relativeX, 0, sliderBg.Position.Y.Offset - 7)

    if draggingFOV then
        local mouseX = UserInputService:GetMouseLocation().X
        local sliderStart = fovSliderBg.AbsolutePosition.X
        local sliderEnd = sliderStart + fovSliderBg.AbsoluteSize.X
        local clampedX = math.clamp(mouseX, sliderStart, sliderEnd)
        local relativeX = clampedX - sliderStart
        aimFOV = math.clamp((relativeX / fovSliderBg.AbsoluteSize.X) * 950 + 50, 50, 1000)
    end
    local fovRelativeX = ((aimFOV - 50) / 950) * fovSliderBg.AbsoluteSize.X
    fovSliderKnob.Position = UDim2.new(0, fovRelativeX, 0, fovSliderBg.Position.Y.Offset - 7)

    fovCircle.Size = UDim2.new(0, aimFOV * 2, 0, aimFOV * 2)
    fovCircle.Position = UDim2.new(0.5, -aimFOV, 0.5, -aimFOV)
end)

local function getClosestVisiblePlayer()
    local closestPlayer, bestScore = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            local headPos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                -- Screen distance from mouse cursor
                local screenDist = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude

                -- World distance to player head
                local worldDist = (v.Character.Head.Position - Camera.CFrame.Position).Magnitude

                -- Combine distances with weighting
                local score = screenDist + (worldDist / 10)

                if score < bestScore and score <= aimFOV then
                    bestScore = score
                    closestPlayer = v
                end
            end
        end
    end

    return closestPlayer, bestScore
end

RunService.RenderStepped:Connect(function(deltaTime)
    if aimbotEnabled and smoothAimSpeed and character and character:FindFirstChild("Head") then
        local targetPlayer, targetDist = getClosestVisiblePlayer()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local targetHead = targetPlayer.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetHead.Position)
            if onScreen and targetDist < aimFOV then
                local direction = (targetHead.Position - Camera.CFrame.Position).Unit
                local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + direction)
                local strengthFactor = math.clamp(smoothAimSpeed / 2, 0.5, 20)

                if targetDist < (aimFOV * 0.1) then
                    -- Snap instantly if target very close to center
                    Camera.CFrame = newCFrame
                else
                    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, deltaTime * strengthFactor)
                end
            end
        end
    end
end)

local function removeESP(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        for _, gui in pairs(player.Character.Head:GetChildren()) do
            if gui:IsA("BillboardGui") and gui.Name == "JHUBESP" then
                gui:Destroy()
            end
        end
    end
end

local function drawESP(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local head = targetPlayer.Character.Head
        removeESP(targetPlayer)

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "JHUBESP"
        billboard.Size = UDim2.new(1, 0, 1, 0)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.Parent = head

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        frame.Parent = billboard

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.Parent = frame

        billboard.ExtentsOffset = Vector3.new(0, 1, 0)
    end
end

local function setupESPForPlayer(player)
    player.CharacterAdded:Connect(function(char)
        local head = char:WaitForChild("Head", 5)
        if head then
            removeESP(player)
            drawESP(player)
        end
    end)
    if player.Character and player.Character:FindFirstChild("Head") then
        drawESP(player)
    end
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= player then
        setupESPForPlayer(p)
    end
end

Players.PlayerAdded:Connect(function(newPlayer)
    setupESPForPlayer(newPlayer)
end)

loadConfig()

-- Drag functionality
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = input.Position
        local topLeftCorner = mainFrame.AbsolutePosition
        local topRightCorner = mainFrame.AbsolutePosition + Vector2.new(mainFrame.AbsoluteSize.X, 0)
        local bottomLeftCorner = mainFrame.AbsolutePosition + Vector2.new(0, mainFrame.AbsoluteSize.Y)
        local bottomRightCorner = mainFrame.AbsolutePosition + mainFrame.AbsoluteSize

        if mousePos.X >= topLeftCorner.X and mousePos.X <= topRightCorner.X and mousePos.Y >= topLeftCorner.Y and mousePos.Y <= bottomLeftCorner.Y then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)