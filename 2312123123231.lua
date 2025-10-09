-- Güçlendirilmiş, orijinal API'ye sadık, LOCAL-ONLY "fling hissi" modu
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Orijinal marker korunuyor
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local stopFling = false -- dışarıdan kontrol için
local lp = Players.LocalPlayer

-- Ayarlar (isteğe göre keskinleştir)
local HORIZONTAL_MULT = 280     -- x/z yönündeki kuvvet katsayısı (çok güçlü his için arttır)
local UP_MULT = 340             -- dikey (y) kuvvet
local APPLY_FRAMES = 2          -- kaç RenderStepped frame süresince anlık uygulama yapalım
local SWAP_PERIOD = 0.06        -- movel toggling hızı
local SAFE_CLAMP = 1000         -- maksimum uygulama büyüklüğü (sağlamlık için)

local function safeVectorClamp(v, maxMag)
	if v.Magnitude > maxMag then
		return v.Unit * maxMag
	end
	return v
end

local function fling()
	stopFling = false

	local c = nil
	local hrp = nil
	local movel = 0
	local lastApply = 0

	-- Character referanslarını güncelle
	local function refreshRefs()
		c = lp and lp.Character
		if c then
			hrp = c:FindFirstChild("HumanoidRootPart")
		else
			hrp = nil
		end
	end

	-- Başlangıç refs
	refreshRefs()

	-- Karakter eklendiğinde referans al
	local charCon
	charCon = lp.CharacterAdded:Connect(function(char)
		c = char
		hrp = char:WaitForChild("HumanoidRootPart", 5)
	end)

	-- Ana döngü: orijinal mantığa benzer heartbeat tabanlı döngü
	while not stopFling do
		RunService.Heartbeat:Wait()
		refreshRefs()

		if c and hrp then
			local hum = c:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health <= 0 then
				hrp = nil
			end
		end

		if hrp then
			-- orijinal kodunda vel saklanıp büyük çarpanla setleniyordu; burada AssemblyLinearVelocity ile anlık his veriyoruz
			-- Bu client-side kuvvet daha belirgin olur.
			local prev = hrp.AssemblyLinearVelocity

			-- Çok güçlü anlık itiş: yukarı + ileri (z) karışımı
			-- Burada "ileri" yönünü hrp.CFrame.lookVector kullanarak belirliyoruz
			local forward = hrp.CFrame.LookVector
			local push = forward * HORIZONTAL_MULT + Vector3.new(0, UP_MULT, 0)

			-- güvenlik için clamp
			push = safeVectorClamp(push, SAFE_CLAMP)

			-- anlık uygulama birkaç render frame sürsün (daha sert his için)
			for i = 1, APPLY_FRAMES do
				if stopFling then break end
				-- pcall ile sunucu/istemci kısıtlamalarına dayanıklı yap
				pcall(function()
					hrp.AssemblyLinearVelocity = push
				end)
				RunService.RenderStepped:Wait()
			end

			-- orijinal kodun yaptığı gibi önceki vel geri setleniyor (ya da küçük toggling)
			-- burada önceki hıza yumuşak dönüş yapıyoruz
			pcall(function()
				hrp.AssemblyLinearVelocity = prev
			end)

			-- ek bir küçük zıplama/toggle, orijinalin movel mantığını taklit eder
			hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, movel, 0)
			movel = -movel
			-- toggling için bekle (orijinalin Step/Render kombinasyonuna benzer)
			wait(SWAP_PERIOD)
		end
	end

	-- Döngüden çıkınca cleanup
	if charCon then
		pcall(function() charCon:Disconnect() end)
	end
end

-- API dışarı aktarılıyor (fonksiyon isimleri korunmuştur)
return {
	fling = function()
		stopFling = false
		-- orijinal davranışa sadık kalarak coroutine döndürüyoruz
		return coroutine.create(fling)
	end,
	stop = function()
		stopFling = true
	end,
	enableGui = function() end,
	disableGui = function() end
}
