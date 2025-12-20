--[[
    EXC FREEMIUM HUB
    Developed by: Exc
    Version: 3.5 (Free Edition)
]]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- [1] ANTI-DETECTION & SECURITY SYSTEM
--------------------------------------------------------------------------------

local function SecureURL(url)
    local key = 69
    local encoded = ""
    for i = 1, #url do
        local byte = string.byte(url, i)
        encoded = encoded .. string.char(bit32.bxor(byte, key))
    end
    return encoded
end

local function DecodeURL(encoded)
    local key = 69
    local decoded = ""
    for i = 1, #encoded do
        local byte = string.byte(encoded, i)
        decoded = decoded .. string.char(bit32.bxor(byte, key))
    end
    return decoded
end

local function SecureLoadScript(encodedURL)
    local url = DecodeURL(encodedURL)
    task.wait(math.random(100, 300) / 1000)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        local func, err = loadstring(result)
        if func then
            task.wait(math.random(50, 150) / 1000)
            return pcall(func)
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- [2] CONFIGURATION
--------------------------------------------------------------------------------

local ScriptLinks = {
    ["Mount Funny"]     = SecureURL("https://raw.githubusercontent.com/exc2222/funny/main/funny.lua"),
    ["Mount Ragon"]     = SecureURL("https://raw.githubusercontent.com/exc2222/ragon/main/ragon.lua"),
    ["Mount Molti"]     = SecureURL("https://raw.githubusercontent.com/exc2222/molti/main/molti.lua"),
    ["Mount Wasabi"]    = SecureURL("https://raw.githubusercontent.com/exc2222/wasabi/main/wasabi.lua"),
    ["Mount Freestyle"] = SecureURL("https://raw.githubusercontent.com/exc2222/freestyle/main/freestyle.lua"),
    ["Mount Gemi"]      = SecureURL("https://raw.githubusercontent.com/exc2222/gemi/main/gemi.lua"),
    ["Mount Aethria"]   = SecureURL("https://raw.githubusercontent.com/exc2222/aethria/main/aethria.lua"),
    ["Mount Velora"]    = SecureURL("https://raw.githubusercontent.com/exc2222/velora/main/velora.lua"),
    ["Mount Age"]       = SecureURL("https://raw.githubusercontent.com/exc2222/age/main/age.lua"),
    ["Mount Runia"]     = SecureURL("https://raw.githubusercontent.com/exc2222/runia/main/runia.lua"),
    ["Mount Tali"]      = SecureURL("https://raw.githubusercontent.com/exc2222/tali/main/tali.lua"),
    ["Mount Yahayuk"]   = SecureURL("https://raw.githubusercontent.com/exc2222/yahayuk/main/yahayuk.lua"),
    ["Mount Antartika"] = SecureURL("https://raw.githubusercontent.com/exc2222/antartika/main/antartika.lua"),
    ["Mount Fells"]     = SecureURL("https://raw.githubusercontent.com/exc2222/fells/main/fells.lua"),
    ["Mount Bagendah"]  = SecureURL("https://raw.githubusercontent.com/exc2222/bagendah/main/bagendah.lua"),
    ["Mount Luna"]      = SecureURL("https://raw.githubusercontent.com/exc2222/luna/main/luna.lua")
}

--------------------------------------------------------------------------------
-- [3] HELPER FUNCTIONS
--------------------------------------------------------------------------------

local function CensorName(name)
    if #name <= 2 then
        return name
    end
    local firstChar = string.sub(name, 1, 1)
    local lastChar = string.sub(name, -1)
    local middleLength = #name - 2
    local censored = string.rep("*", middleLength)
    return firstChar .. censored .. lastChar
end

local function GetAccountAge()
    return LocalPlayer.AccountAge .. " Days"
end

local function GetSortedMountNames()
    local names = {}
    for name, _ in pairs(ScriptLinks) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

local function GetSpawnedPlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(playerNames, player.Name)
            end
        end
    end
    table.sort(playerNames)
    return playerNames
end

--------------------------------------------------------------------------------
-- [4] RAYFIELD UI SETUP
--------------------------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "EXC FREEMIUM | " .. CensorName(LocalPlayer.DisplayName),
    LoadingTitle = "Welcome to Freemium...",
    LoadingSubtitle = "Welcome to Exc Hub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ExcHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false, 
        Invite = "noinvitelink", 
        RememberJoins = true 
    },
    KeySystem = false
})

Rayfield.Theme = "Amethyst" 

--------------------------------------------------------------------------------
-- [5] TABS & FEATURES
--------------------------------------------------------------------------------

local TabMounts = Window:CreateTab("Auto Walk", 4483362458)
TabMounts:CreateSection("Select Mount Location")

local SortedMounts = GetSortedMountNames()

for _, mountName in ipairs(SortedMounts) do
    TabMounts:CreateButton({
        Name = mountName,
        Callback = function()
            local encodedURL = ScriptLinks[mountName]
            
            if encodedURL then
                Rayfield:Notify({
                    Title = "Injecting...",
                    Content = "Loading " .. mountName,
                    Duration = 2,
                    Image = 4483362458,
                })
                
                task.wait(0.5) 
                
                local success = SecureLoadScript(encodedURL)
                
                if success then
                    Rayfield:Notify({Title = "Success", Content = "Script Loaded!", Duration = 3})
                else
                    Rayfield:Notify({Title = "Error", Content = "Failed to load script", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "Error", Content = "Link Config Missing", Duration = 3})
            end
        end,
    })
end

local TabPlayer = Window:CreateTab("Player", 4483362458)
TabPlayer:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 16,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})
TabPlayer:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Callback = function(Value) _G.InfJump = Value end,
})
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
end)
TabPlayer:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value) _G.Noclip = Value end,
})
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
    end
end)

local TabPerf = Window:CreateTab("Performance", 4483362458)
local function Optimize(Level)
    for _, v in pairs(Workspace:GetDescendants()) do
        if Level >= 1 and (v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter")) then 
            if v:IsA("ParticleEmitter") then v.Enabled = false else v:Destroy() end
        end
        if Level >= 2 and v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            Lighting.GlobalShadows = false
        end
        if Level >= 3 and v:IsA("BasePart") then
            v.Color = Color3.new(1, 1, 1)
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        end
    end
end

local function KentangMode()
    -- Hapus semua partikel dan efek visual
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            v.Enabled = false
            v:Destroy()
        end
        if v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v:Destroy()
        end
        if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
            v.Enabled = false
        end
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
            v.Enabled = false
        end
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
        end
    end
    
    -- Hapus semua aura dan efek di player characters
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = false
                    v:Destroy()
                end
                if v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v:Destroy()
                end
                if v:IsA("PointLight") or v:IsA("SpotLight") then
                    v.Enabled = false
                end
                if v:IsA("BillboardGui") then
                    v.Enabled = false
                end
            end
        end
    end
    
    -- Hide player name tags
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            for _, gui in pairs(head:GetChildren()) do
                if gui:IsA("BillboardGui") then
                    gui.Enabled = false
                end
            end
        end
    end
    
    -- Atur lighting untuk grafik terendah
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
    
    -- Disable post effects
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
            effect.Enabled = false
        end
    end
    
    Rayfield:Notify({
        Title = "Kentang Mode Active",
        Content = "Ultra low graphics applied!",
        Duration = 3,
        Image = 4483362458,
    })
end

TabPerf:CreateButton({Name = "Expert (White Mode)", Callback = function() Optimize(3) end})
TabPerf:CreateButton({
    Name = "Kentang Mode 🥔", 
    Callback = function() 
        KentangMode() 
    end
})

local TabMisc = Window:CreateTab("Misc", 4483362458)
TabMisc:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Callback = function(Value)
        _G.AntiAFK = Value
        if Value then
            LocalPlayer.Idled:Connect(function()
                if _G.AntiAFK then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        end
    end,
})
TabMisc:CreateButton({Name = "Rejoin Server", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end})

TabMisc:CreateSection("Teleport to Player")

local SelectedPlayerName = ""

local PlayerDropdown = TabMisc:CreateDropdown({
    Name = "Select Player to Teleport",
    Options = GetSpawnedPlayerList(),
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "TeleportPlayer",
    Callback = function(Option)
        if Option[1] then
            SelectedPlayerName = Option[1]
        end
    end,
})

TabMisc:CreateButton({
    Name = "Teleport to Selected Player",
    Callback = function()
        if SelectedPlayerName == "" then
            Rayfield:Notify({
                Title = "Error",
                Content = "Please select a player first!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        local targetPlayer = Players:FindFirstChild(SelectedPlayerName)
        
        if not targetPlayer then
            Rayfield:Notify({
                Title = "Error",
                Content = "Player not found or left!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "Error",
                Content = "You have no character!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "Error",
                Content = SelectedPlayerName .. " is no longer spawned!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        local success = pcall(function()
            local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(3, 1, 0)
        end)
        
        if success then
            Rayfield:Notify({
                Title = "Teleported",
                Content = "Teleported to " .. SelectedPlayerName,
                Duration = 2,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to teleport!",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

TabMisc:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        local spawnedPlayers = GetSpawnedPlayerList()
        
        Rayfield:Notify({
            Title = "Refreshed",
            Content = "Found " .. #spawnedPlayers .. " spawned players. Reopen dropdown to see list.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

TabMisc:CreateSection("🎵 Boombox Music Player")

local CurrentSound = nil
local BoomboxID = ""

TabMisc:CreateInput({
    Name = "Enter Boombox ID",
    PlaceholderText = "Example: 1837849285",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        BoomboxID = Text
    end,
})

TabMisc:CreateButton({
    Name = "▶️ Play Music",
    Callback = function()
        if BoomboxID == "" or BoomboxID == nil then
            Rayfield:Notify({
                Title = "Error",
                Content = "Please enter a Boombox ID first!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        if CurrentSound then
            CurrentSound:Stop()
            CurrentSound:Destroy()
            CurrentSound = nil
        end
        
        pcall(function()
            CurrentSound = Instance.new("Sound")
            CurrentSound.Parent = LocalPlayer.Character or Workspace
            CurrentSound.SoundId = "rbxassetid://" .. BoomboxID
            CurrentSound.Volume = 0.5
            CurrentSound.Looped = true
            CurrentSound:Play()
            
            Rayfield:Notify({
                Title = "🎵 Music Playing",
                Content = "Playing ID: " .. BoomboxID,
                Duration = 3,
                Image = 4483362458,
            })
        end)
    end,
})

TabMisc:CreateButton({
    Name = "⏸️ Stop Music",
    Callback = function()
        if CurrentSound then
            CurrentSound:Stop()
            CurrentSound:Destroy()
            CurrentSound = nil
            
            Rayfield:Notify({
                Title = "Music Stopped",
                Content = "Music has been stopped",
                Duration = 2,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "No Music",
                Content = "No music is currently playing",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

TabMisc:CreateSlider({
    Name = "🔊 Volume",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.5,
    Callback = function(Value)
        if CurrentSound then
            CurrentSound.Volume = Value
        end
    end,
})

TabMisc:CreateToggle({
    Name = "🔁 Loop Music",
    CurrentValue = true,
    Callback = function(Value)
        if CurrentSound then
            CurrentSound.Looped = Value
        end
    end,
})

TabMisc:CreateSection("🎼 Popular Music IDs")

local PopularSongs = {
    {name = "Tor Monitor", id = "70633665224310"},
    {name = "Hide A Seek But You", id = "106948989756646"},
    {name = "Bintang 5", id = "134435445558993"},
    {name = "DJ 1", id = "139825186779265"},
    {name = "DJ 2", id = "96077163288111"},
}

for _, song in ipairs(PopularSongs) do
    TabMisc:CreateButton({
        Name = "🎵 " .. song.name,
        Callback = function()
            BoomboxID = song.id
            
            if CurrentSound then
                CurrentSound:Stop()
                CurrentSound:Destroy()
                CurrentSound = nil
            end
            
            pcall(function()
                CurrentSound = Instance.new("Sound")
                CurrentSound.Parent = LocalPlayer.Character or Workspace
                CurrentSound.SoundId = "rbxassetid://" .. song.id
                CurrentSound.Volume = 0.5
                CurrentSound.Looped = true
                CurrentSound:Play()
                
                Rayfield:Notify({
                    Title = "🎵 Now Playing",
                    Content = song.name,
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        end,
    })
end

TabMisc:CreateSection("UI Control")
TabMisc:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        if CurrentSound then
            CurrentSound:Stop()
            CurrentSound:Destroy()
        end
        
        Rayfield:Notify({
            Title = "Closing...",
            Content = "UI will be destroyed in 2 seconds",
            Duration = 2,
            Image = 4483362458,
        })
        
        task.wait(2)
        Rayfield:Destroy()
    end,
})

local TabAbout = Window:CreateTab("About", 4483362458)
TabAbout:CreateLabel("EXC FREEMIUM Script")
TabAbout:CreateParagraph({Title = "Credits", Content = "Developed by Exc"})
TabAbout:CreateParagraph({Title = "Version", Content = "Freemium v3.5"})

TabAbout:CreateSection("Join Our Community")
TabAbout:CreateParagraph({
    Title = "Discord Server",
    Content = "Click the button below to copy Discord invite link"
})

local DiscordInvite = "https://discord.gg/yourserver"

TabAbout:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard(DiscordInvite)
        Rayfield:Notify({
            Title = "Success!",
            Content = "Discord link copied to clipboard!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

TabAbout:CreateButton({
    Name = "Join Discord (Browser)",
    Callback = function()
        local success = pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(DiscordInvite)
        end)
        
        if success then
            Rayfield:Notify({
                Title = "Opening...",
                Content = "Opening Discord in browser",
                Duration = 2,
                Image = 4483362458,
            })
        else
            setclipboard(DiscordInvite)
            Rayfield:Notify({
                Title = "Link Copied",
                Content = "Discord link copied to clipboard!",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

local TabDashboard = Window:CreateTab("Dashboard", 4483362458)
TabDashboard:CreateSection("User Info")
TabDashboard:CreateParagraph({Title = "Display Name", Content = CensorName(LocalPlayer.DisplayName)})
TabDashboard:CreateParagraph({Title = "Username", Content = CensorName(LocalPlayer.Name)})
TabDashboard:CreateParagraph({Title = "Account Age", Content = GetAccountAge()})
TabDashboard:CreateParagraph({Title = "Status", Content = "Freemium Active"})

Rayfield:LoadConfiguration()
