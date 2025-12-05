--======================================================
--  FADE FUNCTION (Tween)
--======================================================
local TweenService = game:GetService("TweenService")

local function Fade(object, target, duration)
    TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = target}):Play()
end

--======================================================
--  MAIN UI
--======================================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AUTO_WALK_LOADER"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 220)
Frame.Position = UDim2.new(0.5, -175, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true

-- Fade In
Frame.BackgroundTransparency = 1
Fade(Frame, 0, 0.3)

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

--======================================================
--  HEADER + BY F4
--======================================================
local Header = Instance.new("Frame", Frame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

-- Label By F4
local ByF4 = Instance.new("TextLabel", Header)
ByF4.Size = UDim2.new(0, 80, 1, 0)
ByF4.Position = UDim2.new(0, 10, 0, 0)
ByF4.BackgroundTransparency = 1
ByF4.Font = Enum.Font.GothamBold
ByF4.TextSize = 14
ByF4.TextColor3 = Color3.fromRGB(255, 255, 100)
ByF4.Text = "By F4"

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 100, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Auto Walk Loader"

--======================================================
--  MINIMIZE BUTTON
--======================================================
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 30, 0, 25)
MinBtn.Position = UDim2.new(1, -70, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Text = "-"
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

--======================================================
--  CLOSE BUTTON
--======================================================
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

--======================================================
--  CONTENT UI
--======================================================

-- Dropdown Label
local DropLabel = Instance.new("TextLabel", Frame)
DropLabel.Position = UDim2.new(0, 20, 0, 50)
DropLabel.Size = UDim2.new(0, 310, 0, 30)
DropLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DropLabel.Font = Enum.Font.Gotham
DropLabel.TextSize = 15
DropLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DropLabel.Text = "Pilih Gunung"
Instance.new("UICorner", DropLabel).CornerRadius = UDim.new(0, 8)

-- Dropdown Frame
local Dropdown = Instance.new("Frame", Frame)
Dropdown.Position = UDim2.new(0, 20, 0, 85)
Dropdown.Size = UDim2.new(0, 310, 0, 120)
Dropdown.Visible = true
Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 8)

--======================================================
--  LIST GUNUNG
--======================================================

local GunungList = {
    ["Gunung 1"] = "https://raw.githubusercontent.com/lilyml2222-source/bttll/refs/heads/main/botol.lua",
    ["Gunung 2"] = "https://raw.githubusercontent.com/xx/bttll/refs/heads/main/222.lua",
    ["Gunung 3"] = "https://raw.githubusercontent.com/xx/bttll/refs/heads/main/333.lua"
}

for name, url in pairs(GunungList) do
    local Btn = Instance.new("TextButton", Dropdown)
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.Position = UDim2.new(0, 5, 0, (30 * (#Dropdown:GetChildren() - 1)))
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = name
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        DropLabel.Text = "Dipilih: " .. name
        loadstring(game:HttpGet(url))()
    end)
end

--======================================================
--  AUTOWALK BUTTON
--======================================================
local AutoWalk = Instance.new("TextButton", Frame)
AutoWalk.Position = UDim2.new(0, 20, 0, 175)
AutoWalk.Size = UDim2.new(0, 310, 0, 35)
AutoWalk.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
AutoWalk.Font = Enum.Font.GothamBold
AutoWalk.TextSize = 16
AutoWalk.TextColor3 = Color3.new(1, 1, 1)
AutoWalk.Text = "Start Auto Walk"
Instance.new("UICorner", AutoWalk).CornerRadius = UDim.new(0, 8)

local AutoOn = false

AutoWalk.MouseButton1Click:Connect(function()
    AutoOn = not AutoOn

    if AutoOn then
        AutoWalk.Text = "Stop Auto Walk"
        -- MASUKKAN KODE AUTOWALK KAMU DI SINI
    else
        AutoWalk.Text = "Start Auto Walk"
    end
end)

--======================================================
--  MINIMIZE
--======================================================
local Minimized = false

MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized

    if Minimized then
        TweenService:Create(Frame, TweenInfo.new(.3), {Size = UDim2.new(0, 350, 0, 35)}):Play()
        Dropdown.Visible = false
        AutoWalk.Visible = false
        DropLabel.Visible = false
    else
        TweenService:Create(Frame, TweenInfo.new(.3), {Size = UDim2.new(0, 350, 0, 220)}):Play()
        Dropdown.Visible = true
        AutoWalk.Visible = true
        DropLabel.Visible = true
    end
end)

--======================================================
--  CLOSE (FADE OUT)
--======================================================
CloseBtn.MouseButton1Click:Connect(function()
    Fade(Frame, 1, 0.3)
    wait(0.3)
    ScreenGui:Destroy()
end)
