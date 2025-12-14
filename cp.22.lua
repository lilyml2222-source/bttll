--[[
    PREMIUM RAYFIELD HUB - GOOGLE AUTH EDITION
    Developed by: Exc
    Version: 3.5 (Google Apps Script Integrated)
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
-- [1] CONFIGURATION (URL BARU KAMU SUDAH DIPASANG DI SINI)
--------------------------------------------------------------------------------

-- Link Google Apps Script kamu yang baru:
local AuthURL = "https://script.google.com/macros/s/AKfycbywETCfm_HOgMHKZPbE5QHlihNhgro_IDMiOPtf8VEf7it3QpcXUrh1ULSjtdGtl-6t/exec" 

local ScriptLinks = {
    ["Mount Funny"]     = "https://raw.githubusercontent.com/exc2222/funny/main/funny.lua",
    ["Mount Ragon"]     = "https://raw.githubusercontent.com/exc2222/ragon/main/ragon.lua",
    ["Mount Molti"]     = "https://raw.githubusercontent.com/exc2222/molti/main/molti.lua",
    ["Mount Wasabi"]    = "https://raw.githubusercontent.com/exc2222/wasabi/main/wasabi.lua",
    ["Mount Freestyle"] = "https://raw.githubusercontent.com/exc2222/freestyle/main/freestyle.lua",
    ["Mount Gemi"]      = "https://raw.githubusercontent.com/exc2222/gemi/main/gemi.lua",
    ["Mount Aethria"]   = "https://raw.githubusercontent.com/exc2222/aethria/main/aethria.lua",
    ["Mount Velora"]    = "https://raw.githubusercontent.com/exc2222/velora/main/velora.lua",
    ["Mount Age"]       = "https://raw.githubusercontent.com/exc2222/age/main/age.lua",
    ["Mount Runia"]     = "https://raw.githubusercontent.com/exc2222/runia/main/runia.lua",
    ["Mount Tali"]      = "https://raw.githubusercontent.com/exc2222/tali/main/tali.lua",
    ["Mount Yahayuk"]   = "https://raw.githubusercontent.com/exc2222/yahayuk/main/yahayuk.lua",
    ["Mount Antartika"] = "https://raw.githubusercontent.com/exc2222/antartika/main/antartika.lua",
    ["Mount Fells"]     = "https://raw.githubusercontent.com/exc2222/fells/main/fells.lua",
    ["Mount Bagendah"]  = "https://raw.githubusercontent.com/exc2222/bagendah/main/bagendah.lua"
}

--------------------------------------------------------------------------------
-- [2] AUTHENTICATION LOGIC (GOOGLE SYSTEM)
--------------------------------------------------------------------------------
local UserKey = ""

local function GetAuthKey()
    -- Memberi notifikasi sedang mengecek database
    local hint = Instance.new("Hint", Workspace)
    hint.Text = "Menghubungi Server Google untuk verifikasi..."
    
    local success, response = pcall(function()
        -- Mengirim Nama Player ke Google untuk dicek (?username=Nama)
        return game:HttpGet(AuthURL .. "?username=" .. LocalPlayer.Name)
    end)
    
    hint:Destroy()

    -- Jika Gagal Koneksi
    if not success then
        LocalPlayer:Kick("Error: Gagal menghubungi Server Google. Cek internetmu.")
        return nil
    end

    -- Membersihkan spasi (Response cleaning)
    response = string.gsub(response, "^%s*(.-)%s*$", "%1")

    -- Logika Pengecekan
    if response == "TOLAK" or response == "" or string.find(response, "MANA KEYNYA") then
        LocalPlayer:Kick("Akses Ditolak: Username '" .. LocalPlayer.Name .. "' belum terdaftar di Google Database!")
        return nil
    else
        -- Jika sukses, response adalah KEY user
        UserKey = response
        return UserKey
    end
end

-- Jalankan Auth
local ValidKey = GetAuthKey()
if not ValidKey then return end -- Stop script jika key salah

--------------------------------------------------------------------------------
-- [3] RAYFIELD UI SETUP
--------------------------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "EXC V1 | " .. LocalPlayer.DisplayName,
    LoadingTitle = "Verifying Success...",
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
    KeySystem = true, 
    KeySettings = {
        Title = "Security System",
        Subtitle = "Logged in as " .. LocalPlayer.Name,
        Note = "Key otomatis diambil dari Server Google",
        FileName = "ExcKeyAuth", 
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = { ValidKey } -- Key otomatis terisi dari hasil Google tadi
    }
})

Rayfield.Theme = "Amethyst" 

--------------------------------------------------------------------------------
-- [4] TABS & FEATURES
--------------------------------------------------------------------------------

-- == DASHBOARD ==
local TabDashboard = Window:CreateTab("Dashboard", 4483362458)
TabDashboard:CreateSection("User Info")
TabDashboard:CreateParagraph({Title = "Display Name", Content = LocalPlayer.DisplayName})
TabDashboard:CreateParagraph({Title = "Username", Content = LocalPlayer.Name})
TabDashboard:CreateParagraph({Title = "Key Used", Content = ValidKey}) -- Menampilkan Key yang dipakai
TabDashboard:CreateParagraph({Title = "Status", Content = "Premium Active"})

-- == AUTO WALK ==
local TabMounts = Window:CreateTab("Auto Walk", 4483362458)
TabMounts:CreateSection("Select Mount")

local SelectedMount = "Mount Yahayuk" 

TabMounts:CreateDropdown({
    Name = "Mount Location",
    Options = {
        "Mount Funny", "Mount Ragon", "Mount Molti", "Mount Wasabi", 
        "Mount Freestyle", "Mount Gemi", "Mount Aethria", "Mount Velora", 
        "Mount Age", "Mount Runia", "Mount Tali",
        "Mount Yahayuk", "Mount Antartika", "Mount Fells", "Mount Bagendah"
    },
    CurrentOption = {"Mount Yahayuk"},
    MultipleOptions = false,
    Flag = "MountSelect",
    Callback = function(Option)
        SelectedMount = Option[1]
    end,
})

TabMounts:CreateButton({
    Name = "Inject Script",
    Callback = function()
        local targetURL = ScriptLinks[SelectedMount]
        
        if targetURL then
            Rayfield:Notify({
                Title = "Injecting...",
                Content = "Loading " .. SelectedMount,
                Duration = 2,
                Image = 4483362458,
            })
            
            task.wait(1) 
            
            local success, err = pcall(function()
                loadstring(game:HttpGet(targetURL))()
            end)
            
            if success then
                Rayfield:Notify({Title = "Success", Content = "Script Loaded!", Duration = 3})
            else
                Rayfield:Notify({Title = "Error", Content = "Script Not Found (404)", Duration = 3})
            end
        else
            Rayfield:Notify({Title = "Error", Content = "Link Config Missing", Duration = 3})
        end
    end,
})

-- == PLAYER MENU ==
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

-- == FPS BOOSTER ==
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
TabPerf:CreateButton({Name = "Expert (White Mode)", Callback = function() Optimize(3) end})

-- == MISC ==
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

-- == ABOUT ==
local TabAbout = Window:CreateTab("About", 4483362458)
TabAbout:CreateLabel("Premium Script Hub v3.5 (Google Auth)")
TabAbout:CreateParagraph({Title = "Credits", Content = "Developed by Exc"})

Rayfield:LoadConfiguration()

