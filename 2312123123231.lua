local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Detection (gizli kontrol objesi)
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- Fling fonksiyonu (hızlı, güçlü ve optimize edilmiş)
local function fling()
    local lp = Players.LocalPlayer
    local active = true
    local flingForce = 50000 -- Daha güçlü fling için artırıldı
    local verticalBoost = 25000 -- Daha hızlı yukarı fırlatma
    local movel = 0.1
    local c, hrp

    -- Karakter yüklenme olayını optimize et
    lp.CharacterAdded:Connect(function(char)
        c = char
        hrp = char:WaitForChild("HumanoidRootPart", 2) -- Bekleme süresi azaltıldı
    end)

    -- Heartbeat yerine daha hızlı Stepped kullanımı
    RunService.Stepped:Connect(function()
        if not active or not c or not hrp then
            return
        end

        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then
            hrp = nil
            return
        end

        -- Yakındaki oyuncuları tespit et ve anında fırlat
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = player.Character.HumanoidRootPart
                local distance = (hrp.Position - targetHrp.Position).Magnitude

                -- Mesafe kontrolü (çok yakınsa fırlat)
                if distance < 5 then
                    local originalVel = targetHrp.Velocity
                    targetHrp.Velocity = (targetHrp.Position - hrp.Position).Unit * flingForce + Vector3.new(0, verticalBoost, 0)
                    RunService.RenderStepped:Wait() -- Hızlı geri dönüş için
                    targetHrp.Velocity = originalVel
                end
            end
        end

        -- Kendi karakteri için hafif hareket (stabilite için)
        if hrp then
            local vel = hrp.Velocity
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end)
end

-- API sadece fling fonksiyonu döner
return {
    fling = coroutine.wrap(fling)
}