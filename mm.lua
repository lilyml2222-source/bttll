-- SIMPLE CFRAME RECORDER + SMOOTH MOVEMENT (by F4)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local HRP = player.Character:WaitForChild("HumanoidRootPart")

local Path = {}        
local Recording = false
local Index = 1        

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local function MakeButton(text, pos)
    local b = Instance.new("TextButton", gui)
    b.Size = UDim2.new(0, 100, 0, 35)
    b.Position = UDim2.new(pos, -50, 0.85, 0)
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    return b
end

local recordBtn    = MakeButton("Record",   0.18)
local stopBtn      = MakeButton("Stop",     0.30)
local backBtn      = MakeButton("◀ Back",   0.45)
local nextBtn      = MakeButton("Next ▶",   0.60)
local playBackBtn  = MakeButton("◀◀ Play",  0.75)
local playNextBtn  = MakeButton("Play ▶▶",  0.90)


---------------------------------------------------------------------
-- SMOOTH MOVE FUNCTION (Tween)
---------------------------------------------------------------------
local function SmoothTo(cf, time)
    local tweenInfo = TweenInfo.new(time or 0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween = TweenService:Create(HRP, tweenInfo, {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end


---------------------------------------------------------------------
-- RECORD
---------------------------------------------------------------------
recordBtn.MouseButton1Click:Connect(function()
    if Recording then return end
    Recording = true
    print("Recording started")

    while Recording do
        table.insert(Path, HRP.CFrame)
        Index = #Path
        task.wait(0.1) -- interval, bisa dibuat 0.05 untuk lebih smooth
    end
end)


---------------------------------------------------------------------
-- STOP
---------------------------------------------------------------------
stopBtn.MouseButton1Click:Connect(function()
    Recording = false
    print("Recording stopped")

    -- Copy ke clipboard
    if setclipboard then
        local data = ""
        for _, cf in ipairs(Path) do
            data = data .. "CFrame.new(" .. tostring(cf) .. "),\n"
        end
        setclipboard(data)
        print("Copied to clipboard!")
    end
end)


---------------------------------------------------------------------
-- STEP BACK
---------------------------------------------------------------------
backBtn.MouseButton1Click:Connect(function()
    if #Path == 0 then return end
    Index = math.clamp(Index - 1, 1, #Path)
    SmoothTo(Path[Index])
    print("Step Back:", Index)
end)


---------------------------------------------------------------------
-- STEP NEXT
---------------------------------------------------------------------
nextBtn.MouseButton1Click:Connect(function()
    if #Path == 0 then return end
    Index = math.clamp(Index + 1, 1, #Path)
    SmoothTo(Path[Index])
    print("Step Next:", Index)
end)


---------------------------------------------------------------------
-- PLAY BACKWARD (SMOOTH)
---------------------------------------------------------------------
playBackBtn.MouseButton1Click:Connect(function()
    if #Path == 0 then return end
    for i = Index, 1, -1 do
        Index = i
        SmoothTo(Path[Index])
    end
end)


---------------------------------------------------------------------
-- PLAY FORWARD (SMOOTH)
---------------------------------------------------------------------
playNextBtn.MouseButton1Click:Connect(function()
    if #Path == 0 then return end
    for i = Index, #Path do
        Index = i
        SmoothTo(Path[Index])
    end
end)
