local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Benzersiz bir tanımlayıcı oluştur
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

local stopFling = false
local flingPower = 500000 -- Fırlatma gücü (daha yüksek = daha uzağa fırlatır)
local flingUpwardForce = 100000 -- Yukarı yönlü kuvvet

-- Fırlatma fonksiyonu
local function fling()
    local lp = Players.LocalPlayer
    local c, hrp

    -- Karakter yüklendiğinde
    lp.CharacterAdded:Connect(function(char)
        c = char
        hrp = char:WaitForChild("HumanoidRootPart", 5)
        -- Touched eventi ile diğer oyunculara dokunmayı algıla
        hrp.Touched:Connect(function(hit)
            local otherPlayer = Players:GetPlayerFromCharacter(hit.Parent)
            if otherPlayer and otherPlayer ~= lp then
                local otherHrp = hit.Parent:FindFirstChild("HumanoidRootPart")
                local otherHum = hit.Parent:FindFirstChildOfClass("Humanoid")
                if otherHrp and otherHum and otherHum.Health > 0 then
                    -- Fırlatma yönü: Dokunan oyuncudan uzaklaşacak şekilde
                    local direction = (otherHrp.Position - hrp.Position).Unit
                    otherHrp.Velocity = direction * flingPower + Vector3.new(0, flingUpwardForce, 0)
                end
            end
        end)
    end)

    -- Mevcut karakteri kontrol et
    if lp.Character then
        c = lp.Character
        hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Touched:Connect(function(hit)
                local otherPlayer = Players:GetPlayerFromCharacter(hit.Parent)
                if otherPlayer and otherPlayer ~= lp then
                    local otherHrp = hit.Parent:FindFirstChild("HumanoidRootPart")
                    local otherHum = hit.Parent:FindFirstChildOfClass("Humanoid")
                    if otherHrp and otherHum and otherHum.Health > 0 then
                        local direction = (otherHrp.Position - hrp.Position).Unit
                        otherHrp.Velocity = direction * flingPower + Vector3.new(0, flingUpwardForce, 0)
                    end
                end
            end)
        end
    end

    -- Fırlatma döngüsü
    while not stopFling do
        RunService.Heartbeat:Wait()
        if c and hrp then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                hrp = nil
            end
        else
            c = lp.Character
            if c then
                hrp = c:FindFirstChild("HumanoidRootPart")
            end
        end
    end
end

-- API dışarı aktarımı
return {
    fling = function()
        stopFling = false
        return coroutine.create(fling)
    end,
    stop = function()
        stopFling = true
    end,
    enableGui = function()
        -- GUI eklenebilir
    end,
    disableGui = function()
        -- GUI devre dışı bırakılabilir
    end
}