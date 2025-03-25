local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/rustbuilderz/RBS/refs/heads/main/lib/library.lua", true))()
local Window = Library:Main("ESP Menu")
local ESPTab = Window:NewTab("ESP Settings")

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local ESPEnabled = false

-- UI Toggle
ESPTab:NewToggle("Enable ESP", function(state)
    ESPEnabled = state
end, ESPEnabled)

-- List of items to track
local objectsToTrack = {
    "GoldBar", "Barrel", "Teapot", "SilverPocketWatch", "Molotov", "Chair", "GoldStatue",
    "SilverBar", "Wheel", "Painting", "WantedPoster", "Revolver", "GoldPocketWatch",
    "RifleAmmo", "RevolverAmmo", "Left Arm_Armor", "TurretAmmo", "Shotgun", "SilverCup",
    "Right Arm_Armor", "MaximGun", "Statue", "Torch", "Coal", "GoldPainting", "VaseTwo",
    "Bond", "Crucifix", "Holy", "Vase", "BarbedWire", "Bandage", "Book"
}

-- ESP Storage
local espBoxes = {}

-- Function to create an ESP box
local function CreateESP()
    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 0, 0) -- Red
    box.Thickness = 2
    box.Filled = false
    box.Visible = false
    return box
end

-- Function to update ESP positions
local function UpdateESP()
    if not ESPEnabled then
        for _, box in pairs(espBoxes) do
            box.Visible = false
        end
        return
    end

    for obj, box in pairs(espBoxes) do
        if obj and obj.Parent then
            local position = nil
            if obj:IsA("Model") then
                if obj.PrimaryPart then
                    position = obj.PrimaryPart.Position
                end
            elseif obj:IsA("BasePart") then
                position = obj.Position
            end

            if position then
                local screenPos, onScreen = Camera:WorldToViewportPoint(position)
                if onScreen then
                    local distance = (Camera.CFrame.Position - position).Magnitude
                    local size = math.clamp(3000 / distance, 20, 100)

                    box.Size = Vector2.new(size, size * 1.5)
                    box.Position = Vector2.new(screenPos.X - size / 2, screenPos.Y - size / 2)
                    box.Visible = true
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end

-- Function to find objects and assign ESP
local function TrackObjects()
    local parent = workspace:FindFirstChild("RuntimeItems")
    if parent then
        for _, itemName in ipairs(objectsToTrack) do
            local obj = parent:FindFirstChild(itemName)
            if obj and not espBoxes[obj] then
                espBoxes[obj] = CreateESP()
            end
        end
    end
end

-- Constantly track objects
RunService.RenderStepped:Connect(function()
    TrackObjects()
    UpdateESP()
end)
