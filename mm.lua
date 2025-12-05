--// Smooth Walk Recorder by F4
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")

local recorded = {}
local isRecording = false
local isPlaying = false
local index = 1

-- UI ----
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 210)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.Active = true
Frame.Draggable = true
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

local function Btn(text,y)
    local b = Instance.new("TextButton", Frame)
    b.Size = UDim2.new(1,-20,0,30)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    return b
end

local RecBtn = Btn("Start Record",10)
local PlayBtn = Btn("Play",50)
local BackBtn = Btn("<< Back",90)
local ForBtn = Btn("Forward >>",130)
local SaveBtn = Btn("Save Clipboard",170)

-- RECORD ----
RecBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    
    if isRecording then
        recorded = {}
        RecBtn.Text = "Recording..."
        
        while isRecording do
            table.insert(recorded, HRP.CFrame)
            task.wait(0.1)
        end
        
        RecBtn.Text = "Start Record"
    end
end)

-- 🔥 PLAYBACK DENGAN ANIMASI BERJALAN
local function MoveHumanTo(cf)
    local pos = cf.Position
    Hum:MoveTo(pos)
    Hum.MoveToFinished:Wait()
end

PlayBtn.MouseButton1Click:Connect(function()
    if isPlaying or #recorded == 0 then return end
    
    isPlaying = true
    
    for i = 1, #recorded do
        index = i
        
        -- Rotasi diarahkan dengan tween agar smooth
        TweenService:Create(HRP,TweenInfo.new(0.1),
            {CFrame = CFrame.new(HRP.Position, recorded[i].Position)}
        ):Play()
        
        MoveHumanTo(recorded[i])
    end
    
    Hum:MoveTo(HRP.Position) -- stop
    isPlaying = false
end)

-- BACK ----
BackBtn.MouseButton1Click:Connect(function()
    if index > 1 then
        index -= 1
        MoveHumanTo(recorded[index])
    end
end)

-- FORWARD ----
ForBtn.MouseButton1Click:Connect(function()
    if index < #recorded then
        index += 1
        MoveHumanTo(recorded[index])
    end
end)

-- SAVE ----
SaveBtn.MouseButton1Click:Connect(function()
    if #recorded == 0 then return end
    
    local str = "return {\n"
    for _,cf in ipairs(recorded) do
        str = str.."    CFrame.new("..tostring(cf).."),\n"
    end
    str = str.."}"
    
    setclipboard(str)
    SaveBtn.Text = "Saved!"
    task.delay(1, function()
        SaveBtn.Text = "Save Clipboard"
    end)
end)
