-- Güvenli local-only 'fling hissi' modülü
-- Orijinal API korunmuştur (fonksiyon adı değiştirilmedi)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local stopFling = false
local connections = {}         -- event bağlantılarını tutar
local perPlayerDebounce = {}   -- diğer oyuncular için hızlı tetiklemeyi sınırlamak
local charRef = { character = nil, hrp = nil }

-- Ayarlar (istediğin gibi ayarla)
local HORIZONTAL_FORCE = 200    -- x/z eksenindeki kuvvet katsayısı (çok güçlü his için arttır)
local UP_FORCE = 220            -- dikey kuvvet
local IMPULSE_DURATION = 0.05   -- kuvvetin "sert" kalma süresi (saniye)
local PLAYER_DEBOUNCE = 0.12    -- aynı oyuncu tekrar tetiklenme süresi (saniye)
local GLOBAL_DEBOUNCE = 0.03    -- global kısa debounce, spamı azaltır

-- karakter referanslarını güncelleyen yardımcı
local function updateCharacterRefs()
    local c = lp and lp.Character
    if c ~= charRef.character then
        charRef.character = c
        if c then
            charRef.hrp = c:FindFirstChild("HumanoidRootPart")
        else
            charRef.hrp = nil
        end
    else
        -- karakter aynıysa hrp var mı kontrolü
        if c then
            charRef.hrp = c:FindFirstChild("HumanoidRootPart") or charRef.hrp
        end
    end
end

-- Temizleme fonksiyonu: tüm bağlantıları kes
local function cleanup()
    for _, con in ipairs(connections) do
        if con and con.Disconnect then
            pcall(function() con:Disconnect() end)
        elseif con and type(con) == "RBXScriptConnection" then
            pcall(function() con:Disconnect() end)
        end
    end
    connections = {}
    perPlayerDebounce = {}
end

-- İç fonksiyon adı 'fling' olarak bırakıldı (API ile aynı)
local function fling()
    stopFling = false
    cleanup()
    perPlayerDebounce = {}

    -- karakter eklendiğinde/yenilendiğinde setup ederiz
    local function onCharacterAdded(char)
        updateCharacterRefs()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        -- Touched için hızlı tepki
        local touchedCon
        touchedCon = hrp.Touched:Connect(function(part)
            if stopFling then return end

            -- part'ın parenti başka bir karakter mi?
            local otherChar = part and part.Parent
            if not otherChar then return end
            local otherPlayer = Players:GetPlayerFromCharacter(otherChar)
            if not otherPlayer then return end

            -- kendine dokunmayı yoksay
            if otherPlayer == lp then return end

            -- debounce: aynı oyuncu çok sık tetiklemesin
            local now = tick()
            local last = perPlayerDebounce[otherPlayer] or 0
            if now - last < PLAYER_DEBOUNCE then return end
            perPlayerDebounce[otherPlayer] = now

            -- global kısa debounce (çok hızlı tekrarları önler)
            if perPlayerDebounce._global and now - perPlayerDebounce._global < GLOBAL_DEBOUNCE then return end
            perPlayerDebounce._global = now

            -- güçlü anlık itiş - yalnızca local karakterin HRP'sine uygulanır
            local myHrp = charRef.hrp or hrp
            if not myHrp then return end

            -- yön hesaplama: other karakterin HRP pozisyonuna göre ters yönde it
            local otherHrp = otherChar:FindFirstChild("HumanoidRootPart")
            local dir = Vector3.new(0,0,0)
            if otherHrp then
                local diff = myHrp.Position - otherHrp.Position
                if diff.Magnitude > 0.1 then
                    dir = diff.Unit
                end
            else
                -- fallback: touching part yönü
                local diff = myHrp.Position - part.Position
                if diff.Magnitude > 0.1 then
                    dir = diff.Unit
                end
            end

            -- hesaplanan kuvvet
            local pushVec = dir * HORIZONTAL_FORCE + Vector3.new(0, UP_FORCE, 0)

            -- önceki hızı sakla
            local prevVel = myHrp.AssemblyLinearVelocity

            -- anlık uygulama
            -- pcall ile hatalara karşı koru (sunucu kısıtlaması olursa hata alabiliriz)
            pcall(function()
                myHrp.AssemblyLinearVelocity = pushVec
            end)

            -- kısa süre sonra önceki hıza veya yumuşatmaya dönüş
            spawn(function()
                -- IMPULSE_DURATION kadar bekle
                wait(IMPULSE_DURATION)
                -- yumuşak geri dönüş: birkaç adımda prevVel'e dön veya sıfırlama
                local steps = 6
                for i = 1, steps do
                    if stopFling then break end
                    RunService.Heartbeat:Wait()
                    local t = i / steps
                    -- Lerp ile prevVel'e yavaşça döndür (bu client-side his sağlar)
                    local target = prevVel
                    local newVel = myHrp.AssemblyLinearVelocity:Lerp(target, t)
                    pcall(function() myHrp.AssemblyLinearVelocity = newVel end)
                end
            end)
        end)

        table.insert(connections, touchedCon)
    end

    -- Karakter hazırsa kur, değilse ekleme eventine bağlan
    if lp.Character then
        onCharacterAdded(lp.Character)
    end

    local charCon = lp.CharacterAdded:Connect(function(char) onCharacterAdded(char) end)
    table.insert(connections, charCon)

    -- Ayrıca heartbeat loop'u: karakter referanslarını güncel tutar ve stopFling kontrolü yapar
    local hbCon = RunService.Heartbeat:Connect(function()
        if stopFling then
            cleanup()
            if hbCon then
                pcall(function() hbCon:Disconnect() end)
            end
            return
        end
        updateCharacterRefs()
    end)
    table.insert(connections, hbCon)

    -- coroutine sonlanana kadar bekle; dışarıdan stop çağrılırsa cleanup yapılacak
    while not stopFling do
        RunService.Heartbeat:Wait()
    end

    cleanup()
end

-- Modül API: orijinal yapıya sadık kalındı (fonksiyon adı değişmedi)
return {
    fling = function()
        stopFling = false
        -- NOT: burada orijinal kodun davranışına sadık kalarak coroutine oluşturuyoruz.
        -- Başlatmak için caller: coroutine.resume(result)
        return coroutine.create(fling)
    end,
    stop = function()
        stopFling = true
    end,
    enableGui = function() end,
    disableGui = function() end
}
