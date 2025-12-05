local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SERENA",
   LoadingTitle = "SERENA Autowalk",
   LoadingSubtitle = "SERENA",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SERENA", 
      FileName = "SERENA"
   },
   KeySystem = false,
})

local AutoWalkTab = Window:CreateTab("AUTO WALK", 4483345998)

-- 1. DAFTAR LINK SCRIPT (Isi link RAW GitHub kamu di sini)
-- Format: ["Nama Map di Dropdown"] = "Link Raw Github"
local MapScripts = {
    ["MT BOTOL"]      = "https://raw.githubusercontent.com/lilyml2222-source/bttll/refs/heads/main/botol.lua",
    ["MT TALI"]         = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_Tali.lua",
    ["MT ZORA"]         = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_Zora.lua",
    ["MT ANEH PRO"]     = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_AnehPro.lua",
    ["MT LONELY"]       = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_Lonely.lua",
    ["MT ENTAH APA"]    = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_EntahApa.lua",
    ["MT ARUNIKA"]      = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_Arunika.lua",
    ["MT DAY ONE"]      = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_DayOne.lua",
    ["MT PENGANGGURAN"] = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_Pengangguran.lua",
    ["MT LEMBAYANA"]    = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_Lembayana.lua",
    ["MT NETIZEN"]      = "https://raw.githubusercontent.com/UsernameMu/Repo/main/Script_Netizen.lua",
    -- Tambahkan map lainnya sesuai kebutuhan...
}

-- 2. MENGAMBIL LIST NAMA MAP DARI TABLE DI ATAS
local MapList = {}
for Name, Link in pairs(MapScripts) do
    table.insert(MapList, Name)
end
-- (Opsional) Mengurutkan nama map sesuai abjad agar rapi
table.sort(MapList)

-- 3. MEMBUAT DROPDOWN
AutoWalkTab:CreateDropdown({
   Name = "Pilih Map",
   Options = MapList, -- Ini otomatis mengambil nama-nama dari daftar di atas
   CurrentOption = {"--"},
   MultipleOptions = false,
   Flag = "MapDropdown",
   Callback = function(Option)
       -- Option[1] adalah nama map yang dipilih user (contoh: "MT FOREVER")
       local SelectedMap = Option[1] 
       local ScriptLink = MapScripts[SelectedMap] -- Mengambil link yang sesuai

       if ScriptLink then
           Rayfield:Notify({
               Title = "Injecting Script",
               Content = "Sedang memuat script: " .. SelectedMap,
               Duration = 3,
               Image = 4483345998,
           })

           -- EKSEKUSI SCRIPT DARI GITHUB
           loadstring(game:HttpGet(ScriptLink))()
           
           print("Berhasil load script untuk: " .. SelectedMap)
       else
           Rayfield:Notify({
               Title = "Error",
               Content = "Link script untuk map ini belum diisi!",
               Duration = 3,
               Image = 4483345998,
           })
       end
   end,
})
