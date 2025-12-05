--// Smooth CFrame Recorder by F4
--// UI Simple + Tween Playback

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

local recorded = {}
local index = 1
local isRecording = false
local isPlaying = false

--// UI ---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 180)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true

local function NewBtn(text, posY)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    return btn
end

local RecBtn = NewBtn("Start Record", 10)
local PlayBtn = NewBtn("Play", 50)
local BackBtn = NewBtn("<< Backward", 90)
local ForwardBtn = NewBtn("Forward >>", 130)
local SaveBtn = NewBtn("Save to Clipboard", 170)

Frame.Size = UDim2.new(0, 220, 0, 210)

--// RECORDING --------------------------------------------------

RecBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    if isRecording then
        recorded = {}
        RecBtn.Text = "Recording..."
        task.spawn(function()
            while isRecording do
                table.insert(recorded, HRP.CFrame)
                task.wait(0.05) -- 20 FPS recorder
            end
        end)
    else
        RecBtn.Text = "Start Record"
    end
end)

--// PLAYBACK (smooth) ------------------------------------------

local function TweenTo(cf)
    local tween = TweenService:Create(
        HRP,
        TweenInfo.new(0.05, Enum.EasingStyle.Linear),
        {CFrame = cf}
    )
    tween:Play()
    tween.Completed:Wait()
end

PlayBtn.MouseButton1Click:Connect(function()
    if isPlaying or #recorded == 0 then return end
    isPlaying = true
    for i = 1, #recorded do
        TweenTo(recorded[i])
        index = i
    end
    isPlaying = false
end)

--// BACKWARD ----------------------------------------------------

BackBtn.MouseButton1Click:Connect(function()
    if index > 1 then
        index -= 1
        TweenTo(recorded[index])
    end
end)

--// FORWARD -----------------------------------------------------

ForwardBtn.MouseButton1Click:Connect(function()
    if index < #recorded then
        index += 1
        TweenTo(recorded[index])
    end
end)

--// SAVE TO CLIPBOARD ------------------------------------------

SaveBtn.MouseButton1Click:Connect(function()
    if #recorded == 0 then return end

    local str = "return {\n"
    for _, cf in ipairs(recorded) do
        str = str .. "    CFrame.new(" .. tostring(cf) .. "),\n"
    end
    str = str .. "}"

    setclipboard(str)
    SaveBtn.Text = "Saved!"
    task.delay(1.2, function()
        SaveBtn.Text = "Save to Clipboard"
    end)
end)
