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

local function clearConnections()
	for _, conn in pairs(connections) do
		if conn then conn:Disconnect() end
	end
	connections = {}
end

local function fling()
	local lp = Players.LocalPlayer
	local c, hrp
	
	-- Karakter spawn kontrolü
	local charConn = lp.CharacterAdded:Connect(function(char)
		c = char
		hrp = char:WaitForChild("HumanoidRootPart", 1)
		char:WaitForChild("Humanoid")
	end)
	connections[#connections + 1] = charConn
	
	if lp.Character then
		c = lp.Character
		hrp = c:FindFirstChild("HumanoidRootPart")
	end
	
	-- Ultra hızlı ve güçlü fling sistemi
	local function flingTarget(targetHRP, flingForce)
		-- Network ownership'i ele geçir
		pcall(function()
			targetHRP:SetNetworkOwner(nil)
			targetHRP:SetNetworkOwner(lp)
		end)
		
		-- Güçlü velocity ve assembly manipülasyonu
		targetHRP.Velocity = flingForce
		targetHRP.AssemblyLinearVelocity = flingForce * 1.5
		targetHRP.CFrame = targetHRP.CFrame + (flingForce.Unit * 10)
		
		-- Tüm parçaları fırlat
		local targetAssembly = targetHRP.Parent
		for _, part in pairs(targetAssembly:GetChildren()) do
			if part:IsA("BasePart") and part ~= targetHRP then
				part.Velocity = flingForce * 0.8
				part.AssemblyLinearVelocity = flingForce * 1.2
			end
		end
	end
	
	local function detectAndFling()
		if stopFling or not c or not hrp then return end
		
		local myPos = hrp.Position
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local targetHRP = player.Character.HumanoidRootPart
				local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
				
				if targetHum and targetHum.Health > 0 then
					local distance = (myPos - targetHRP.Position).Magnitude
					
					-- 30 stud mesafede anında fırlat
					if distance <= 30 then
						local flingForce = Vector3.new(
							math.random(-15000, 15000), -- X ekseni rastgele
							20000 + math.random(5000, 10000), -- Y ekseni güçlü yukarı
							math.random(-15000, 15000) -- Z ekseni rastgele
						)
						flingTarget(targetHRP, flingForce)
					end
				end
			end
		end
	end
	
	-- Çift loop ile ultra hızlı detection
	local heartbeatConn = RunService.Heartbeat:Connect(detectAndFling)
	local renderConn = RunService.RenderStepped:Connect(detectAndFling)
	connections[#connections + 1] = heartbeatConn
	connections[#connections + 1] = renderConn
end

return {
	fling = function()
		clearConnections()
		stopFling = false
		return coroutine.create(function()
			fling()
			while not stopFling do
				RunService.Heartbeat:Wait()
			end
			clearConnections()
		end)
	end,
	stop = function()
		stopFling = true
		clearConnections()
	end,
	enableGui = function() end,
	disableGui = function() end
}