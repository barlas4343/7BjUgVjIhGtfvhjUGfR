local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI Oluşturma
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")

-- GUI Özellikleri
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
print("sub to DuplexScripts")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
Frame.Size = UDim2.new(0, 158, 0, 110)

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 158, 0, 25)

TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.112792775, 0, -0.0151660154, 0)
TextLabel.Size = UDim2.new(0, 121, 0, 26)
TextLabel.Font = Enum.Font.Sarpanch
TextLabel.Text = "Touch Fling"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 25.000

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.113924049, 0, 0.418181807, 0)
TextButton.Size = UDim2.new(0, 121, 0, 37)
TextButton.Font = Enum.Font.SourceSansItalic
TextButton.Text = "OFF"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 20.000

-- Detection nesnesi
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- Fling fonksiyonu
local function fling()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, 0.1
    local active = false -- Toggle kontrolü için boolean (başlangıçta kapalı)

    -- Kapatma sinyali için bağlantı
    local connection
    connection = game:GetService("Players").LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function()
        if not lp.Character or (lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health <= 0) then
            active = false -- Karakter öldüğünde veya kaybolduğunda fling'i durdur
        end
    end)

    -- TextButton toggle mantığı
    local function onToggle()
        active = not active
        TextButton.Text = active and "ON" or "OFF"

        -- Bildirimler
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Touch Fling",
            Text = active and "Fling turned ON" or "Fling turned OFF",
            Duration = 3
        })
    end

    TextButton.MouseButton1Click:Connect(onToggle)

    while true do 
        RunService.Heartbeat:Wait()
        if not active then
            -- Fling kapalıyken bekle, ama coroutine ölmesin
            continue
        end

        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        -- HATA GİDERME: Eğer karakter ölürse veya HumanoidRootPart yoksa, coroutine durdurulur
        if not hrp or (c and c:FindFirstChild("Humanoid") and c.Humanoid.Health <= 0) then
            connection:Disconnect()
            active = false
            TextButton.Text = "OFF"
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Touch Fling",
                Text = "Fling stopped due to character death",
                Duration = 3
            })
            return 
        end

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

-- Draggable frame
local dragScript = Instance.new('LocalScript', Frame)
dragScript.Parent.Active = true
dragScript.Parent.Draggable = true

-- ANA KODA DÖNDÜRÜLECEK FONKSİYON
return coroutine.wrap(fling)