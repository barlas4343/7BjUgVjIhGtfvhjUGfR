local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Detection (gizli kontrol objesi)
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- Sabitler
local FLING_MULTIPLIER_HORIZONTAL = 50000  -- Yatay hızı kat kat artırır
local FLING_FORCE_VERTICAL = 75000        -- Aşırı güçlü dikey fırlatma kuvveti

-- Fling fonksiyonu
local function fling()
    local lp = Players.LocalPlayer
    local active = true
    
    -- Karakter Yüklenmesini Bekle
    local c = lp.Character or lp.CharacterAdded:Wait()
    local hrp = c:WaitForChild("HumanoidRootPart")

    -- Karakter her yeniden yüklendiğinde HumanoidRootPart'ı güncelle
    lp.CharacterAdded:Connect(function(char)
        c = char
        hrp = char:WaitForChild("HumanoidRootPart", 5)
    end)

    local function applyFling()
        -- Eğer fling kapalıysa veya karakter/HRP yoksa devam etme
        if not active or not hrp or not c then
            return
        end

        local hum = c:FindFirstChildOfClass("Humanoid")
        
        -- Karakter ölüyse HRP'yi sıfırla ve bekle
        if hum and hum.Health <= 0 then
            hrp = nil
            return
        end

        -- Mevcut Hızı Al
        local currentVel = hrp.AssemblyLinearVelocity or hrp.Velocity
        
        -- Aşırı Güçlü Fırlatma Uygula
        -- Yere yapışmayı engellemek ve havaya uçurmak için anlık ve sürekli kuvvet uygular
        local newVel = currentVel * FLING_MULTIPLIER_HORIZONTAL + Vector3.new(0, FLING_FORCE_VERTICAL, 0)
        
        -- Velocity'yi doğrudan atamak yerine, fizik motorunun her adımında itme kuvveti uygulamak daha stabil bir sonuç verebilir.
        -- Ancak doğrudan Velocity ataması anlık etki için daha iyidir.

        hrp.Velocity = newVel
    end

    -- Ana Döngü: Çok daha hızlı aktivasyon için Stepped kullan
    -- Stepped, fizik motorunun simülasyonundan hemen önce çalışır, bu da daha hızlı tepki demektir.
    RunService.Stepped:Connect(applyFling)
end

-- API sadece fling fonksiyonu döner
return {
    fling = coroutine.wrap(fling)
}