--// MOBILE ROBLOX AUTO CLICKER
--// Delta / executor version
--// Tap "SET POSITION", then tap the Roblox spot you want clicked.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

local enabled = false
local settingPosition = false
local clickPosition = nil
local cps = 10

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MobileAutoClicker"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(190, 150)
frame.Position = UDim2.new(0, 20, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "AUTO CLICKER"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = frame

local positionButton = Instance.new("TextButton")
positionButton.Size = UDim2.new(1, -20, 0, 35)
positionButton.Position = UDim2.fromOffset(10, 35)
positionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
positionButton.TextColor3 = Color3.new(1, 1, 1)
positionButton.Text = "SET POSITION"
positionButton.TextSize = 14
positionButton.Font = Enum.Font.GothamBold
positionButton.Parent = frame

Instance.new("UICorner", positionButton).CornerRadius = UDim.new(0, 7)

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -20, 0, 35)
toggleButton.Position = UDim2.fromOffset(10, 75)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "START"
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = frame

Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 7)

local cpsBox = Instance.new("TextBox")
cpsBox.Size = UDim2.new(1, -20, 0, 25)
cpsBox.Position = UDim2.fromOffset(10, 115)
cpsBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
cpsBox.TextColor3 = Color3.new(1, 1, 1)
cpsBox.PlaceholderText = "CPS (default 10)"
cpsBox.Text = "10"
cpsBox.TextSize = 13
cpsBox.Font = Enum.Font.Gotham
cpsBox.ClearTextOnFocus = false
cpsBox.Parent = frame

Instance.new("UICorner", cpsBox).CornerRadius = UDim.new(0, 6)

--// Set position
positionButton.Activated:Connect(function()
    settingPosition = true
    positionButton.Text = "TAP YOUR TARGET..."
end)

--// Detect the next screen tap
UIS.TouchTap:Connect(function(touchPositions, processed)
    if not settingPosition then
        return
    end

    if #touchPositions > 0 then
        clickPosition = touchPositions[1]
        settingPosition = false

        positionButton.Text = string.format(
            "SET: %d, %d",
            clickPosition.X,
            clickPosition.Y
        )
    end
end)

--// Start / stop
toggleButton.Activated:Connect(function()
    if not clickPosition then
        positionButton.Text = "SET POSITION FIRST"
        task.wait(1)
        positionButton.Text = "SET POSITION"
        return
    end

    enabled = not enabled

    if enabled then
        toggleButton.Text = "STOP"
    else
        toggleButton.Text = "START"
    end
end)

--// CPS
cpsBox.FocusLost:Connect(function()
    local value = tonumber(cpsBox.Text)

    if not value then
        value = 10
    end

    cps = math.clamp(value, 1, 30)
    cpsBox.Text = tostring(cps)
end)

--// Auto click loop
task.spawn(function()
    while true do
        if enabled and clickPosition then
            local x = clickPosition.X
            local y = clickPosition.Y

            pcall(function()
                VIM:SendTouchEvent(
                    1,
                    Enum.UserInputState.Begin,
                    x,
                    y
                )

                VIM:SendTouchEvent(
                    1,
                    Enum.UserInputState.End,
                    x,
                    y
                )
            end)

            task.wait(1 / cps)
        else
            task.wait(0.1)
        end
    end
end)
