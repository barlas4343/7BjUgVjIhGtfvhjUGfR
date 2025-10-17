-- Hacı, bu kod LocalScript içine s*çılmalı ve StarterPlayerScripts'e konulmalı.
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService") 
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- SÜRÜKLEME DEĞİŞKENLERİ (Sürükleme mantığı için en üst seviyede kalmalı)
local isDragging = false
local dragStart = nil
local startPos = nil 

-- DINAMIK BOYUT GÜNCELLEME FONKSİYONU
local function updateWatermark(watermarkFrame, firstCharLabel, restOfNameLabel, infoLabel)
    local ping = math.floor(Player:GetNetworkPing() * 1000)
    local fps = math.floor(1 / RunService.Heartbeat:Wait()) 
    
    infoLabel.Text = string.format(
        " | %s | PING: %dms | FPS: %d ",
        Player.Name,
        ping,
        fps
    )

    -- Metin boyutlarını ayrı ayrı ölçme boku
    local firstCharSize = firstCharLabel.TextBounds.X 
    local restOfNameSize = restOfNameLabel.TextBounds.X
    local infoTextSize = infoLabel.TextBounds.X 
    
    local padding = 15 -- Sol boşluk + Metinler arası + Sağ boşluk
    
    local totalWidth = firstCharSize + restOfNameSize + infoTextSize + padding + 5 -- Ayırıcı "|" için 5
    
    watermarkFrame.Size = UDim2.new(0, totalWidth, 0, 25)
    
    -- Geri kalan metni ilk harfin hemen sağına ayarla
    restOfNameLabel.Position = UDim2.new(0, 5 + firstCharSize, 0.5, 0) -- İlk harf + 5 piksel boşluk
    restOfNameLabel.Size = UDim2.new(0, restOfNameSize + 5, 1, 0)

    -- Bilgi etiketinin pozisyonunu, geri kalan metnin hemen sağına ayarla
    infoLabel.Position = UDim2.new(0, 5 + firstCharSize + restOfNameSize + 5, 0.5, 0) 
    infoLabel.Size = UDim2.new(0, infoTextSize + 5, 1, 0)
end

-- GUI OLUŞTURMA VE BAĞLANTI FONKSİYONU (YENİDEN DOĞDUĞUNDA BU ÇAĞRILACAK)
local function createWatermark()
    -- ************************************************************
    -- KOD İÇİNE TAŞINAN TANIMLAMALAR
    local MODERN_FONT = Enum.Font.GothamBold 
    local CHEAT_NAME = "Fatalite.xyz" -- Senin istediğin hile adı
    local TARGET_COLOR = Color3.fromHex("#00ffe5") -- Yeni Neon Mavi
    -- ************************************************************
    
    -- Hile Adı parçalama işlemi artık fonksiyon içinde
    local FIRST_LETTER = string.sub(CHEAT_NAME, 1, 1) 
    local REST_OF_NAME = string.sub(CHEAT_NAME, 2) 
    
    -- Mevcut GUI'yi kontrol et ve varsa sil (Temizlik Boku)
    if PlayerGui:FindFirstChild("AllahGPT_Watermark") then
        PlayerGui.AllahGPT_Watermark:Destroy()
    end

    -- 1. Watermark'ın Ana Konteyneri ve Çerçevesi
    local WatermarkGui = Instance.new("ScreenGui")
    WatermarkGui.Name = "AllahGPT_Watermark"
    WatermarkGui.Parent = PlayerGui

    local WatermarkFrame = Instance.new("Frame")
    WatermarkFrame.Name = "DraggableFrame"
    WatermarkFrame.AnchorPoint = Vector2.new(0, 0) -- SOL ÜST KÖŞE YAPILDI
    WatermarkFrame.Position = UDim2.new(0, 250, 0, 20) -- SOLDAN 250 PİKSEL, YUKARIDAN 20 PİKSEL BAŞLATILDI!
    WatermarkFrame.Size = UDim2.new(0, 10, 0, 25) 
    WatermarkFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05) 
    WatermarkFrame.BackgroundTransparency = 0.05 
    WatermarkFrame.BorderSizePixel = 0 
    WatermarkFrame.Parent = WatermarkGui

    -- 2. TEK ÜST ÇİZGİ VE GLOW BOKU
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopGlowLine"
    TopBar.Size = UDim2.new(1, 0, 0, 3) 
    TopBar.Position = UDim2.new(0, 0, 0, 0) 
    TopBar.BackgroundColor3 = TARGET_COLOR 
    TopBar.BackgroundTransparency = 0
    TopBar.BorderSizePixel = 0
    TopBar.Parent = WatermarkFrame

    local GlowStroke = Instance.new("UIStroke")
    GlowStroke.Thickness = 1.5
    GlowStroke.Color = TARGET_COLOR 
    GlowStroke.Transparency = 0.5 
    GlowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
    GlowStroke.Parent = TopBar

    -- 3. Hile Adının İLK HARFİ (FADED VE RENKLİ)
    local FirstCharLabel = Instance.new("TextLabel")
    FirstCharLabel.Name = "FirstCharLabel"
    FirstCharLabel.Position = UDim2.new(0, 5, 0.5, 0) 
    FirstCharLabel.AnchorPoint = Vector2.new(0, 0.5)
    FirstCharLabel.Size = UDim2.new(0, 1, 1, 0) 
    FirstCharLabel.BackgroundTransparency = 1
    FirstCharLabel.Text = FIRST_LETTER 
    FirstCharLabel.TextColor3 = TARGET_COLOR 
    FirstCharLabel.TextTransparency = 0.5 
    FirstCharLabel.Font = MODERN_FONT 
    FirstCharLabel.TextSize = 14
    FirstCharLabel.TextXAlignment = Enum.TextXAlignment.Left 
    FirstCharLabel.Parent = WatermarkFrame

    -- 4. Hile Adının GERİ KALANI (Düz Beyaz)
    local RestOfNameLabel = Instance.new("TextLabel")
    RestOfNameLabel.Name = "RestOfNameLabel"
    RestOfNameLabel.Position = UDim2.new(0, 0, 0.5, 0) 
    RestOfNameLabel.AnchorPoint = Vector2.new(0, 0.5)
    RestOfNameLabel.Size = UDim2.new(0, 1, 1, 0) 
    RestOfNameLabel.BackgroundTransparency = 1
    RestOfNameLabel.Text = REST_OF_NAME
    RestOfNameLabel.TextColor3 = Color3.fromHex("#FFFFFF") 
    RestOfNameLabel.Font = MODERN_FONT 
    RestOfNameLabel.TextSize = 14
    RestOfNameLabel.TextXAlignment = Enum.TextXAlignment.Left 
    RestOfNameLabel.Parent = WatermarkFrame

    -- 5. Sürekli Güncelleme Bilgi Alanı
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Name = "InfoText"
    InfoLabel.Position = UDim2.new(0, 0, 0.5, 0) 
    InfoLabel.AnchorPoint = Vector2.new(0, 0.5)
    InfoLabel.Size = UDim2.new(0, 1, 1, 0) 
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextColor3 = Color3.fromHex("#FFFFFF") 
    InfoLabel.Font = MODERN_FONT 
    InfoLabel.TextSize = 14
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left 
    InfoLabel.Text = "Loading B*k..."
    InfoLabel.Parent = WatermarkFrame

    -- 6. DINAMİK BOYUT GÜNCELLEMESİNİ BAĞLA (WatermarkFrame'i kapatmak için)
    RunService.Heartbeat:Connect(function()
        updateWatermark(WatermarkFrame, FirstCharLabel, RestOfNameLabel, InfoLabel)
    end)

    -- 7. SÜRÜKLEME MEKANİĞİ BAĞLANTILARI (Bu kısım Frame objesine bağlıdır)
    WatermarkFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
            isDragging = true
            dragStart = input.Position
            startPos = WatermarkFrame.Position 
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            local delta = input.Position - dragStart 
            
            WatermarkFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y  
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
            isDragging = false
        end
    end)
    

end

-- ************************************************************
-- * YENİDEN DOĞMA BUG'INI ÇÖZEN ANA ÇÖZÜM BOKU *
-- ************************************************************

-- 1. Karakter ilk kez yüklendiğinde bir kez çalıştır
createWatermark()

-- 2. Karakter her yeniden doğduğunda (ölüp geri geldiğinde) tekrar çalıştır
Player.CharacterAdded:Connect(createWatermark)


