local router
    for i, v in next, getgc(true) do
        if type(v) == 'table' and rawget(v, 'get_remote_from_cache') then
            router = v
        end
    end
    
    local function rename(remotename, hashedremote)
        hashedremote.Name = remotename
    end
    table.foreach(debug.getupvalue(router.get_remote_from_cache, 1), rename)


-- Clear any existing global data
_G = _G or {}
_G.HouseData = {}  -- This clears past data

local ClientData = require(game:GetService("ReplicatedStorage").ClientModules.Core.ClientData)
local playerName = game.Players.LocalPlayer.Name

----------------------------------
-- Collect & Store Texture Data --
----------------------------------

local TextureData = ClientData.get_data()[playerName].house_interior.textures
_G.HouseData.TextureData = TextureData

------------------------------------
-- Collect & Store Furniture Data --
------------------------------------

local FurnitureData = ClientData.get_data()[playerName].house_interior.furniture

-- Helper function to rebuild a CFrame
local function rebuildCFrame(cf)
    local comps = {cf:GetComponents()}
    return CFrame.new(unpack(comps))
end

-- Build the furniture args table
local furnitureArgs = { [1] = {} }
local i = 1
for _, item in pairs(FurnitureData) do
    local cframeValue = rebuildCFrame(item.cframe)
    furnitureArgs[1][i] = {
        ["kind"] = item.id,
        ["properties"] = {
            ["scale"] = item.scale,
            ["cframe"] = cframeValue,
            ["colors"] = {}
        }
    }

    for colorIndex, colorValue in pairs(item.colors) do
        furnitureArgs[1][i].properties.colors[colorIndex] = colorValue
    end
    i = i + 1
end

_G.HouseData.FurnitureArgs = furnitureArgs
