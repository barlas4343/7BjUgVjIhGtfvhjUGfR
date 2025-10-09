local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local stopFling = false
local connections = {}
local targetConnections = {}

local function clearConnections()
	for _, conn in pairs(connections) do
		if conn then conn:Disconnect() end
	end
	for _, conn in pairs(targetConnections) do
		if conn then conn:Disconnect() end
	end
	connections = {}
	targetConnections = {}
end

local function fling()
	local lp = Players.LocalPlayer
	local c, hrp
	
	-- Karakter spawn kontrolü
	local charConn = lp.CharacterAdded:Connect(function(char)
		c = char
		hrp = char:WaitForChild("HumanoidRootPart", 2)
		char:WaitForChild("Humanoid")
	end)
	connections[#connections + 1] = charConn
	
	if lp.Character then
		c = lp.Character
		hrp = c:FindFirstChild("HumanoidRootPart")
	end
	
	-- Süper hızlı detection ve fling sistemi
	local lastTargets = {}
	local function detectAndFling()
		if stopFling then return end
		
		local character = lp.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then 
			return 
		end
		
		local myHRP = character.HumanoidRootPart
		local myPos = myHRP.Position
		
		-- Yakındaki tüm oyuncuları tespit et (süper hızlı)
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local targetHRP = player.Character.HumanoidRootPart
				local distance = (myPos - targetHRP.Position).Magnitude
				
				-- 50 stud içinde anında fling
				if distance <= 50 then
					-- Ağır hasar kontrolü
					local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
					if targetHum and targetHum.Health > 0 then
						
						-- MULTI-DIRECTIONAL ULTRA FLING
						local flingForce = Vector3.new(
							(math.random(-10000, 10000) / 100), -- X ekseni rastgele
							5000 + math.random(2000, 8000),      -- Y ekseni yukarı
							(math.random(-10000, 10000) / 100)   -- Z ekseni rastgele
						)
						
						-- Assembly manipülasyonu ile süper güç
						local targetAssembly = targetHRP.Parent
						if targetAssembly then
							-- Velocity + CFrame kombosu
							targetHRP.Velocity = flingForce * 10
							targetHRP.AssemblyLinearVelocity = flingForce * 15
							
							-- CFrame ile ek itme
							targetHRP.CFrame = targetHRP.CFrame + (flingForce.Unit * 50)
							
							-- Network ownership hilesi
							pcall(function()
								targetHRP:SetNetworkOwner(nil)
								wait(0.001)
								targetHRP:SetNetworkOwner(lp)
							end)
							
							-- Ek physics manipülasyonu
							for _, part in pairs(targetAssembly:GetChildren()) do
								if part:IsA("BasePart") and part ~= targetHRP then
									part.Velocity = flingForce * 8
									part.AssemblyLinearVelocity = flingForce * 12
								end
							end
						end
						
						lastTargets[player] = tick()
					end
				end
			end
		end
		
		-- Eski targetları temizle
		for player, time in pairs(lastTargets) do
			if tick() - time > 1 then
				lastTargets[player] = nil
			end
		end
	end
	
	-- ULTRA HIZLI LOOP - Heartbeat + Stepped kombosu
	local heartbeatConn = RunService.Heartbeat:Connect(detectAndFling)
	local steppedConn = RunService.Stepped:Connect(detectAndFling)
	connections[#connections + 1] = heartbeatConn
	connections[#connections + 1] = steppedConn
	
	-- Ek detection için RenderStepped (süper hassas)
	local renderConn = RunService.RenderStepped:Connect(function()
		if stopFling then return end
		detectAndFling()
	end)
	connections[#connections + 1] = renderConn
end

-- API
return {
	fling = function()
		clearConnections()
		stopFling = false
		return coroutine.create(function()
			fling()
			while not stopFling do
				RunService.Heartbeat:Wait()
			end
		end)
	end,
	stop = function()
		stopFling = true
		clearConnections()
	end,
	enableGui = function() end,
	disableGui = function() end
}