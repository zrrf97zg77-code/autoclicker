--// MOBILE ROBLOX AUTO CLICKER
--// Delta / mobile
--// Set Position -> tap target -> Start

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local enabled = false
local settingPosition = false
local clickPosition = nil
local cps = 10

--==================================================
-- CLEAN OLD GUI
--==================================================

pcall(function()
    local old = player.PlayerGui:FindFirstChild("MobileAutoClicker")
    if old then
        old:Destroy()
    end
end)

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "MobileAutoClicker"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(200, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--==================================================
-- TITLE / DRAG HANDLE
--==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "AUTO CLICKER"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = frame

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPosition = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

--==================================================
-- SET POSITION BUTTON
--==================================================

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

--==================================================
-- START / STOP
--==================================================

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

--==================================================
-- CPS
--==================================================

local cpsBox = Instance.new("TextBox")
cpsBox.Size = UDim2.new(1, -20, 0, 25)
cpsBox.Position = UDim2.fromOffset(10, 120)
cpsBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
cpsBox.TextColor3 = Color3.new(1, 1, 1)
cpsBox.PlaceholderText = "CPS"
cpsBox.Text = "10"
cpsBox.TextSize = 13
cpsBox.Font = Enum.Font.Gotham
cpsBox.ClearTextOnFocus = false
cpsBox.Parent = frame

Instance.new("UICorner", cpsBox).CornerRadius = UDim.new(0, 6)

--==================================================
-- SMALL POSITION MARKER
--==================================================

local marker = Instance.new("Frame")
marker.Name = "ClickMarker"
marker.Size = UDim2.fromOffset(8, 8)
marker.AnchorPoint = Vector2.new(0.5, 0.5)
marker.BackgroundColor3 = Color3.new(1, 1, 1)
marker.BorderSizePixel = 0
marker.Visible = false
marker.ZIndex = 100
marker.Parent = gui

Instance.new("UICorner", marker).CornerRadius = UDim.new(1, 0)

--==================================================
-- FULLSCREEN POSITION PICKER
--==================================================

local picker = Instance.new("TextButton")
picker.Size = UDim2.fromScale(1, 1)
picker.Position = UDim2.fromScale(0, 0)
picker.BackgroundTransparency = 1
picker.Text = ""
picker.Visible = false
picker.AutoButtonColor = false
picker.ZIndex = 90
picker.Parent = gui

--==================================================
-- SET POSITION
--==================================================

positionButton.Activated:Connect(function()
    if settingPosition then
        return
    end

    settingPosition = true
    enabled = false
    toggleButton.Text = "START"

    positionButton.Text = "TAP TARGET..."

    -- Hide GUI temporarily so it can't steal the target tap
    frame.Visible = false
    picker.Visible = true
end)

picker.Activated:Connect(function(inputPosition)
    if not settingPosition then
        return
    end

    -- Activated doesn't reliably provide the touch position,
    -- so use the most recent touch position.
end)

UIS.InputBegan:Connect(function(input, processed)
    if not settingPosition then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end

    local pos = input.Position

    clickPosition = Vector2.new(pos.X, pos.Y)
    settingPosition = false

    -- Tiny white marker
    marker.Position = UDim2.fromOffset(pos.X, pos.Y)
    marker.Visible = true

    picker.Visible = false
    frame.Visible = true

    positionButton.Text = string.format(
        "SET: %d, %d",
        math.floor(pos.X),
        math.floor(pos.Y)
    )
end)

--==================================================
-- START / STOP
--==================================================

toggleButton.Activated:Connect(function()
    if not clickPosition then
        positionButton.Text = "SET POSITION FIRST"

        task.delay(1, function()
            if not settingPosition then
                positionButton.Text = "SET POSITION"
            end
        end)

        return
    end

    enabled = not enabled

    if enabled then
        toggleButton.Text = "STOP"
    else
        toggleButton.Text = "START"
    end
end)

--==================================================
-- CPS
--==================================================

cpsBox.FocusLost:Connect(function()
    local value = tonumber(cpsBox.Text)

    if not value then
        value = 10
    end

    cps = math.clamp(math.floor(value), 1, 30)
    cpsBox.Text = tostring(cps)
end)

--==================================================
-- CLICK FUNCTION
--==================================================

local function performClick(x, y)
    -- Try touch input first
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

    -- Also try mouse input as a fallback
    pcall(function()
        VIM:SendMouseButtonEvent(
            x,
            y,
            0,
            true,
            game,
            0
        )

        VIM:SendMouseButtonEvent(
            x,
            y,
            0,
            false,
            game,
            0
        )
    end)
end

--==================================================
-- AUTO CLICK LOOP
--==================================================

task.spawn(function()
    while task.wait() do
        if enabled and clickPosition then
            performClick(
                clickPosition.X,
                clickPosition.Y
            )

            task.wait(1 / cps)
        else
            task.wait(0.05)
        end
    end
end)
