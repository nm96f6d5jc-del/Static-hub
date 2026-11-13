-- STATIC HUB LICENCE CHECK
local __SH_ENV = (type(getgenv) == "function" and getgenv()) or _G
local __SH_KEY = __SH_ENV.StaticHubKey

if type(__SH_KEY) ~= "string" or __SH_KEY == "" then
    warn("Static Hub: Missing key")
    return
end

local __SH_HTTP = game:GetService("HttpService")
local __SH_URL = "https://cfvotmcmpyhsxczptdct.supabase.co/functions/v1/static-hub-license?key="
    .. __SH_HTTP:UrlEncode(__SH_KEY)

local __SH_OK, __SH_RESULT = pcall(function()
    return game:HttpGet(__SH_URL)
end)

if not __SH_OK then
    warn("Static Hub: Server unavailable")
    return
end

local __SH_DECODE_OK, __SH_DATA = pcall(function()
    return __SH_HTTP:JSONDecode(__SH_RESULT)
end)

if not __SH_DECODE_OK or type(__SH_DATA) ~= "table" or __SH_DATA.valid ~= true then
    warn("Static Hub: Invalid key")
    return
end

-- LICENCE VERIFIED

-- Static Hub Duel Script
-- Original source credit: Xlu0 AndPrime

-- STATIC_HUB HUB duplicate-execution guard
local __STATIC_HUB_ENV = (type(getgenv) == "function" and getgenv()) or _G
if __STATIC_HUB_ENV.__STATIC_HUB_HUB_PAID_DUELS_RUNNING then
    return
end
__STATIC_HUB_ENV.__STATIC_HUB_HUB_PAID_DUELS_RUNNING = true

Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
RunService = game:GetService("RunService")
HttpService = game:GetService("HttpService")
Lighting = game:GetService("Lighting")
Workspace = game:GetService("Workspace")
Stats = game:GetService("Stats")
MaterialService = game:GetService("MaterialService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
SoundService = game:GetService("SoundService")
StarterGui = game:GetService("StarterGui")
CoreGui = game:GetService("CoreGui")

_syn = rawget((getgenv and getgenv()) or _G, "syn") or rawget(_G, "syn")

if type(protectgui) ~= "function" and _syn and type(_syn.protect_gui) == "function" then
    protectgui = _syn.protect_gui
end

if type(getcustomasset) ~= "function" then
    if type(getexecutorasset) == "function" then
        getcustomasset = getexecutorasset
    elseif type(getsynasset) == "function" then
        getcustomasset = getsynasset
    elseif _syn and type(_syn.getcustomasset) == "function" then
        getcustomasset = _syn.getcustomasset
    elseif _syn and type(_syn.getsynasset) == "function" then
        getcustomasset = _syn.getsynasset
    end
end

if type(isfile) ~= "function" and _syn and type(_syn.isfile) == "function" then isfile = _syn.isfile end
if type(readfile) ~= "function" and _syn and type(_syn.readfile) == "function" then readfile = _syn.readfile end
if type(writefile) ~= "function" and _syn and type(_syn.writefile) == "function" then writefile = _syn.writefile end
if type(delfile) ~= "function" and _syn and type(_syn.delfile) == "function" then delfile = _syn.delfile end

if type(getconnections) ~= "function" then
    if type(get_signal_cons) == "function" then
        getconnections = get_signal_cons
    elseif type(getconnects) == "function" then
        getconnections = getconnects
    elseif _syn and type(_syn.get_signal_cons) == "function" then
        getconnections = _syn.get_signal_cons
    end
end

function _xluCompatGuiParent()
    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end
    local okCore, core = pcall(function() return CoreGui end)
    if okCore and core then return core end
    return nil
end

LP = Players.LocalPlayer
PlayerGui = LP:WaitForChild("PlayerGui")

-- Static Hub Discord tag: client-side overhead label that follows each player's Head.
local STATIC_HUB_DISCORD_TEXT = "discord.gg/Static Hub"
local STATIC_HUB_DISCORD_TAG = "StaticHubDiscordOverhead"
local function addStaticHubDiscordTag(player, character)
    if not player or not character then return end
    local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 8)
    if not head or not head.Parent then return end
    local oldTag = head:FindFirstChild(STATIC_HUB_DISCORD_TAG)
    if oldTag then oldTag:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = STATIC_HUB_DISCORD_TAG
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Size = UDim2.fromOffset(190, 38)
    billboard.StudsOffset = Vector3.new(0, 2.75, 0)
    billboard.MaxDistance = 250
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Name = "DiscordText"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Position = UDim2.fromScale(0, 0)
    label.Text = STATIC_HUB_DISCORD_TEXT
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.08
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextScaled = false
    label.ZIndex = 3
    label.Parent = billboard

    -- Expanding black outline rings create a looping ripple without moving the tag.
    for rippleIndex = 1, 2 do
        local ripple = Instance.new("Frame")
        ripple.Name = "BlackRipple" .. rippleIndex
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.fromScale(0.5, 0.5)
        ripple.Size = UDim2.fromOffset(18, 18)
        ripple.BackgroundTransparency = 1
        ripple.BorderSizePixel = 0
        ripple.ZIndex = 2
        ripple.Parent = billboard
        local round = Instance.new("UICorner")
        round.CornerRadius = UDim.new(1, 0)
        round.Parent = ripple
        local outline = Instance.new("UIStroke")
        outline.Color = Color3.fromRGB(0, 0, 0)
        outline.Thickness = 1.5
        outline.Transparency = 0.18
        outline.Parent = ripple
        task.spawn(function()
            while ripple.Parent and billboard.Parent do
                ripple.Size = UDim2.fromOffset(18, 18)
                outline.Transparency = 0.18
                local expand = TweenService:Create(ripple, TweenInfo.new(1.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(184, 34)
                })
                local fade = TweenService:Create(outline, TweenInfo.new(1.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 1
                })
                if rippleIndex == 2 then task.wait(0.57) end
                if not ripple.Parent then break end
                expand:Play()
                fade:Play()
                expand.Completed:Wait()
                task.wait(0.05)
            end
        end)
    end
end

local function watchStaticHubPlayer(player)
    if player.Character then task.defer(addStaticHubDiscordTag, player, player.Character) end
    player.CharacterAdded:Connect(function(character)
        task.defer(addStaticHubDiscordTag, player, character)
    end)
end
for _, player in ipairs(Players:GetPlayers()) do watchStaticHubPlayer(player) end
Players.PlayerAdded:Connect(watchStaticHubPlayer)

function getUndetectedGuiParent()

    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end

    if protectgui then
        return game:GetService("CoreGui")
    end

    local cg = game:GetService("CoreGui")
    if cg then return cg end

    return PlayerGui
end

function safeParentGui(gui)
    pcall(function()
        if type(gethui) == "function" then
            local ok, parent = pcall(gethui)
            if ok and parent then
                gui.Parent = parent
                return
            end
        end
        if protectgui then
            gui.Parent = game:GetService("CoreGui")
            pcall(function() protectgui(gui) end)
            return
        end
        gui.Parent = game:GetService("CoreGui")
    end)

    if not gui.Parent then
        pcall(function() gui.Parent = PlayerGui end)
    end
end

ExeAutoMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
_G.ExeIsMobile = ExeAutoMobile
_G.ExeDeviceMode = ExeAutoMobile and "MOBILE" or "PC"

for _, name in ipairs({"ExeDuelsExeReconstruct", "ExeHubPolished", "CyberHub"}) do
old = PlayerGui:FindFirstChild(name)
if old then old:Destroy() end
end
NS = 60
CS = 30
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
currentSpeedMode = "Normal"
speedBoosterEnabled = true
carrySpeedActive = false
laggerModeEnabled = false
laggerCarryActive = false
autoCarrySpeedEnabled = false
setAutoCarrySpeedVisual = nil
_G.ExeAutoCarryWasCarrying = false
_G.ExeAutoCarrySavedMode = nil
autoStealEnabled = false
selectedStealMode = "Auto Steal V3"
autoStealRadius = 63
_G.ExeStealRadii = _G.ExeStealRadii or {["Auto Steal V3"] = 63, Semi = 9}
_G.ExeStealRadii["Auto Steal V3"] = tonumber(_G.ExeStealRadii["Auto Steal V3"] or _G.ExeStealRadii.Normal) or 63
autoStealRadiusBox = nil
selectedAimbotMode = "Normal"
AIMBOT_SPEED = 67.2
LAGGER_AIMBOT_SPEED = 40
-- Speed control for the Sound Hub BAT V2 controller.
BAT_V2_SPEED = tonumber(_G.ExeBatV2Speed) or 58
_G.ExeBatV2On = false
_G.ExeBatV2State = _G.ExeBatV2State or {conn = nil, prevAutoRotate = nil}
_G.ExeAntiBypassAimbotSpeed = _G.ExeAntiBypassAimbotSpeed or 65
if _G.ExeAntiBypassLaggerAimbotSpeed == nil or tonumber(_G.ExeAntiBypassLaggerAimbotSpeed) == 58 then _G.ExeAntiBypassLaggerAimbotSpeed = 40 end
autoSwingEnabled = false
mirrorTPDownEnabled = false
_G.ExeNormalAimbotOn = _G.ExeNormalAimbotOn or false
_G.ExeAntiBypassAimbotOn = _G.ExeAntiBypassAimbotOn or false
antiDesyncAutoSwingEnabled = false
_G.ExeAntiDesyncAimbotOn = _G.ExeAntiDesyncAimbotOn or false
ANTI_DESYNC_AIMBOT_SPEED = 58
batCounterEnabled = false
medCounterEnabled = false
hardHitEnabled = false
hardHitRadius = 10
perfectHitEnabled = false
perfectHitRange = 175
_G.ExePerfectHitEnabled = false
_G.ExeHardHitEnabled = false
_G.ExeHardHitRadius = 10
antiKickEnabled = false
setSafeModeVisual = nil
autoResetOnMedEnabled = false
espEnabled = false
showTracerEnabled = false
ragdollCountdownEnabled = true
fpsBoostEnabled = false
antiLagVisualEnabled = false
nukeOptimiserEnabled = false
fovEnabled = false
fovValue = 70
noCamCollisionEnabled = false
_G.ExeNoPlayerCollisionEnabled = _G.ExeNoPlayerCollisionEnabled or false
customFontVisualEnabled = false
skyTheme = "Night"
setPlayerESPVisual = nil
setTracerESPVisual = nil
setRagdollCountdownVisual = nil
setFPSBoostVisual = nil
setAntiLagVisual = nil
setNukeOptimiserVisual = nil
setFOVVisual = nil
setNoCamCollisionVisual = nil
_G.ExeSetNoPlayerCollisionVisual = _G.ExeSetNoPlayerCollisionVisual or nil
setCustomFontVisual = nil
skyValueLabel = nil
autoLeftEnabled = false
autoRightEnabled = false
DEFAULT_SPEED_KEYBINDS = {
SpeedToggle = Enum.KeyCode.Q,
LaggerToggle = Enum.KeyCode.R,
DropBrainrot = Enum.KeyCode.X,
Aimbot = Enum.KeyCode.E,
AutoLeft = Enum.KeyCode.Z,
AutoRight = Enum.KeyCode.C,
InstaReset = Enum.KeyCode.Unknown,
ToggleUI = Enum.KeyCode.LeftControl,
MB_autoPlay = Enum.KeyCode.Unknown,
MB_laggerCarry = Enum.KeyCode.Unknown,
MB_instaMedusa = Enum.KeyCode.Unknown,
MB_batV2 = Enum.KeyCode.Unknown,
MB_antiBat = Enum.KeyCode.Unknown,
MB_tpBat = Enum.KeyCode.Unknown,
}
-- keybind id -> mobile button key (PC + console keys for the new mobile buttons)
_G.ExeMBKeybindMap = {
MB_autoPlay = "autoPlay", MB_laggerCarry = "laggerCarry", MB_instaMedusa = "instaMedusa",
MB_batV2 = "batV2", MB_antiBat = "antiBat", MB_tpBat = "tpBat",
}
DEFAULT_TP_DOWN_KEYBIND = Enum.KeyCode.F
speedKeybinds = {
SpeedToggle = DEFAULT_SPEED_KEYBINDS.SpeedToggle,
LaggerToggle = DEFAULT_SPEED_KEYBINDS.LaggerToggle,
DropBrainrot = DEFAULT_SPEED_KEYBINDS.DropBrainrot,
Aimbot = DEFAULT_SPEED_KEYBINDS.Aimbot,
AutoLeft = DEFAULT_SPEED_KEYBINDS.AutoLeft,
AutoRight = DEFAULT_SPEED_KEYBINDS.AutoRight,
InstaReset = DEFAULT_SPEED_KEYBINDS.InstaReset,
ToggleUI = DEFAULT_SPEED_KEYBINDS.ToggleUI,
MB_autoPlay = DEFAULT_SPEED_KEYBINDS.MB_autoPlay,
MB_laggerCarry = DEFAULT_SPEED_KEYBINDS.MB_laggerCarry,
MB_instaMedusa = DEFAULT_SPEED_KEYBINDS.MB_instaMedusa,
MB_batV2 = DEFAULT_SPEED_KEYBINDS.MB_batV2,
MB_antiBat = DEFAULT_SPEED_KEYBINDS.MB_antiBat,
MB_tpBat = DEFAULT_SPEED_KEYBINDS.MB_tpBat,
}
speedKeybindButtons = {}
listeningForSpeedKey = nil
autoTPEnabled = false
autoTPHeight = 20
autoTPConn = nil
autoTPLastRun = 0
autoTPClickDebounce = false
tpDownKeybind = Enum.KeyCode.F
tpDownKeybindButton = nil
listeningForTPDownKey = false
keybindListenStartedAt = 0
setAutoTPVisual = nil
function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= (tonumber(autoTPHeight) or 20)) then return end
    end
    local yaw = select(2, hrp.CFrame:ToEulerAnglesYXZ())
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hrp.Velocity = Vector3.zero end)
    pcall(function() hrp.RotVelocity = Vector3.zero end)
end
local function _clearAutoTPConnection()
if autoTPConn then
pcall(function() autoTPConn:Disconnect() end)
pcall(function() task.cancel(autoTPConn) end)
autoTPConn = nil
end
end
local function startAutoTP()
autoTPEnabled = true
_clearAutoTPConnection()
autoTPLastRun = 0
autoTPConn = RunService.Heartbeat:Connect(function()
if not autoTPEnabled then
_clearAutoTPConnection()
return
end
local now = tick()
if now - autoTPLastRun < 0.1 then return end
autoTPLastRun = now
pcall(function() doAutoTPDown(false) end)
end)
if setAutoTPVisual then setAutoTPVisual(true) end
end
local function stopAutoTP()
autoTPEnabled = false
_clearAutoTPConnection()
if setAutoTPVisual then setAutoTPVisual(false) end
end
local function runTPFloor()
pcall(function() doAutoTPDown(true) end)
end
local function toggleAutoTP(on)
if on then
startAutoTP()
else
stopAutoTP()
end
if saveExeConfig then pcall(saveExeConfig) end
end
function _G.ExeStopAutoTPForAction()
if autoTPEnabled then
stopAutoTP()
pcall(function() if setAutoTPVisual then setAutoTPVisual(false) end end)
if saveExeConfig then pcall(saveExeConfig) end
end
end
local dropBrainrotActive = false
local _adaptDropConns = {}

_G.ExeDropMode = "Jump Drop"

-- DROP AFTER: after Drop is pressed, auto turn on the chosen mode in 0.20s
_G.ExeDropAfterModes = {"Off", "Bat Aimbot", "BAT V2", "Anti Bat Bypass"}
_G.ExeDropAfterMode = _G.ExeDropAfterMode or "Off"
_G.ExeDropAfterDelay = 0.20
function _G.ExeRunDropAfter()
    local mode = _G.ExeDropAfterMode
    if mode == nil or mode == "Off" then return end
    task.delay(_G.ExeDropAfterDelay or 0.20, function()
        pcall(function()
            if mode == "Bat Aimbot" then
                if selectedAimbotMode == "Anti Bypass" then
                    if not _G.ExeAntiBypassAimbotOn then
                        if _G.ExeStopNormalAimbot then _G.ExeStopNormalAimbot() end
                        if _G.ExeStartAntiBypassAimbot then _G.ExeStartAntiBypassAimbot() end
                    end
                else
                    if not _G.ExeNormalAimbotOn then
                        if _G.ExeStopAntiBypassAimbot then _G.ExeStopAntiBypassAimbot(false) end
                        if _G.ExeStartNormalAimbot then _G.ExeStartNormalAimbot() end
                    end
                end
                if _G.ExeRefreshAimbotVisual then _G.ExeRefreshAimbotVisual() end
            elseif mode == "BAT V2" then
                if not _G.ExeBatV2On and _G.ExeStartBatV2 then _G.ExeStartBatV2() end
            elseif mode == "Anti Bat Bypass" then
                if not _G.ExeAntiBatBypassOn and _G.ExeStartAntiBatBypass then _G.ExeStartAntiBatBypass() end
            end
        end)
    end)
end

local _xDropLastInvoke = 0
local _xDropConn = nil
local function stopDropBrainrot()
    dropBrainrotActive = false
    if _xDropConn then
        pcall(function() _xDropConn:Disconnect() end)
        _xDropConn = nil
    end
    for _, t in ipairs(_adaptDropConns) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif typeof(t) == "RBXScriptConnection" then pcall(function() t:Disconnect() end) end
    end
    _adaptDropConns = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

_G.ExeJumpDropActive = false
_G.ExeJumpDropAscendDuration = 0.2
_G.ExeJumpDropAscendSpeed = 150
_G.ExeDropAscendDuration = _G.ExeDropAscendDuration or 0.2
_G.ExeDropAscendSpeed    = _G.ExeDropAscendSpeed    or 150

function _G.ExeRunJumpDrop()
if _G.ExeJumpDropActive then return end
if _G.ExeStopAutoTPForAction then pcall(_G.ExeStopAutoTPForAction) end

local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not root then return end

_G.ExeJumpDropActive = true
local startTime = tick()

_G.ExeJumpDropConn = RunService.Heartbeat:Connect(function()
local currentChar = LP.Character
local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")

if not currentChar or not currentRoot then
if _G.ExeJumpDropConn then
pcall(function() _G.ExeJumpDropConn:Disconnect() end)
_G.ExeJumpDropConn = nil
end
_G.ExeJumpDropActive = false
return
end

if tick() - startTime >= _G.ExeJumpDropAscendDuration then
if _G.ExeJumpDropConn then
pcall(function() _G.ExeJumpDropConn:Disconnect() end)
_G.ExeJumpDropConn = nil
end

local rayParams = RaycastParams.new()
rayParams.FilterDescendantsInstances = {currentChar}
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
if rayResult then
local hum = currentChar:FindFirstChildOfClass("Humanoid")
local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
currentRoot.AssemblyLinearVelocity = Vector3.zero
currentRoot.AssemblyAngularVelocity = Vector3.zero
end

_G.ExeJumpDropActive = false
return
end

local _jdCur = currentRoot.AssemblyLinearVelocity
currentRoot.AssemblyLinearVelocity = Vector3.new(
_jdCur.X,
_G.ExeJumpDropAscendSpeed,
_jdCur.Z
)
end)
end

function runDrop()
local wasActive = _G.ExeJumpDropActive
_G.ExeRunJumpDrop()
if not wasActive and _G.ExeRunDropAfter then _G.ExeRunDropAfter() end
end

function runDropBrainrot()
runDrop()
end

local infJumpEnabled = false
local antiRagdollEnabled = false
local antiRagdollConn = nil
_G.ExeAntiRagdollMode = "Zombie Hub"

_G.ExeAntiVoidEnabled = _G.ExeAntiVoidEnabled == true
_G.ExeAntiVoidConnection = _G.ExeAntiVoidConnection or nil
_G.ExeAntiVoidSafeCFrame = _G.ExeAntiVoidSafeCFrame or nil

function _G.ExeAntiVoidSaveSafe()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    if hum.FloorMaterial ~= Enum.Material.Air then
        _G.ExeAntiVoidSafeCFrame = root.CFrame
    end
end

function _G.ExeAntiVoidStop()
    if _G.ExeAntiVoidConnection then
        pcall(function() _G.ExeAntiVoidConnection:Disconnect() end)
        _G.ExeAntiVoidConnection = nil
    end
end

function _G.ExeAntiVoidSet(on)
    _G.ExeAntiVoidEnabled = on == true
    _G.ExeAntiVoidStop()
    if not _G.ExeAntiVoidEnabled then return end

    _G.ExeAntiVoidSaveSafe()

    _G.ExeAntiVoidConnection = RunService.Heartbeat:Connect(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not _G.ExeAntiVoidEnabled or not hum or not root or hum.Health <= 0 then return end

        local voidY = Workspace.FallenPartsDestroyHeight + 30
        if hum.FloorMaterial ~= Enum.Material.Air and root.Position.Y > voidY + 12 then
            _G.ExeAntiVoidSafeCFrame = root.CFrame
        elseif root.Position.Y <= voidY and _G.ExeAntiVoidSafeCFrame then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = _G.ExeAntiVoidSafeCFrame + Vector3.new(0, 4, 0)
            hum.PlatformStand = false
            hum.Sit = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end)
end
local unwalkEnabled = false
local unwalkSavedAnimate = nil
local hitHarderAnimEnabled = false
local hitHarderOriginalAnims = {}
local selectedAnimationPack = "OFF"

local AnimationPacks = {
["Zombie"] = {
idle = {{"rbxassetid://616158929", 1}, {"rbxassetid://616160636", 1}},
walk = "rbxassetid://616168032",
run = "rbxassetid://616163682",
jump = "rbxassetid://616161997",
fall = "rbxassetid://616157476",
climb = "rbxassetid://616156119",
swim = "rbxassetid://616165109",
swimidle = "rbxassetid://616166655",
},
["Ninja"] = {
idle = {{"rbxassetid://656117400", 1}, {"rbxassetid://656117400", 1}},
walk = "rbxassetid://656121766",
run = "rbxassetid://656118852",
jump = "rbxassetid://656117878",
fall = "rbxassetid://656115606",
climb = "rbxassetid://656114359",
},
["Knight"] = {
idle = {{"rbxassetid://657595757", 1}, {"rbxassetid://657595757", 1}},
walk = "rbxassetid://657552124",
run = "rbxassetid://657564596",
jump = "rbxassetid://658409194",
fall = "rbxassetid://657600338",
climb = "rbxassetid://658360781",
},
["Elder"] = {
idle = {{"rbxassetid://845397899", 1}, {"rbxassetid://845397899", 1}},
walk = "rbxassetid://845403856",
run = "rbxassetid://845386501",
jump = "rbxassetid://845398858",
fall = "rbxassetid://845397673",
climb = "rbxassetid://845392038",
},
["Levitate"] = {
idle = {{"rbxassetid://616006778", 1}, {"rbxassetid://616006778", 1}},
walk = "rbxassetid://616013216",
run = "rbxassetid://616013216",
jump = "rbxassetid://616008936",
fall = "rbxassetid://616005863",
climb = "rbxassetid://616003713",
},
["Astronaut"] = {
idle = {{"rbxassetid://891621366", 1}, {"rbxassetid://891621366", 1}},
walk = "rbxassetid://891636393",
run = "rbxassetid://891636393",
jump = "rbxassetid://891627522",
fall = "rbxassetid://891617961",
climb = "rbxassetid://891609353",
},
["Pirate"] = {
idle = {{"rbxassetid://750781874", 1}, {"rbxassetid://750781874", 1}},
walk = "rbxassetid://750785693",
run = "rbxassetid://750783738",
jump = "rbxassetid://750782230",
fall = "rbxassetid://750780242",
climb = "rbxassetid://750779899",
},
["Toy"] = {
idle = {{"rbxassetid://782841498", 1}, {"rbxassetid://782841498", 1}},
walk = "rbxassetid://782843345",
run = "rbxassetid://782842708",
jump = "rbxassetid://782847020",
fall = "rbxassetid://782846423",
climb = "rbxassetid://782843869",
},
["Vampire"] = {
idle = {{"rbxassetid://1083445855", 1}, {"rbxassetid://1083445855", 1}},
walk = "rbxassetid://1083473930",
run = "rbxassetid://1083462077",
jump = "rbxassetid://1083455352",
fall = "rbxassetid://1083443587",
climb = "rbxassetid://1083439238",
},
["Werewolf"] = {
idle = {{"rbxassetid://1083195517", 1}, {"rbxassetid://1083195517", 1}},
walk = "rbxassetid://1083178339",
run = "rbxassetid://1083216690",
jump = "rbxassetid://1083218792",
fall = "rbxassetid://1083189019",
climb = "rbxassetid://1083182000",
},
["Rthro"] = {
idle = {{"rbxassetid://2510196951", 1}, {"rbxassetid://2510196951", 1}},
walk = "rbxassetid://2510202577",
run = "rbxassetid://2510198475",
jump = "rbxassetid://2510197830",
fall = "rbxassetid://2510195892",
climb = "rbxassetid://2510192778",
},
["Stylish"] = {
idle = {{"rbxassetid://616136790", 1}, {"rbxassetid://616136790", 1}},
walk = "rbxassetid://616146177",
run = "rbxassetid://616140816",
jump = "rbxassetid://616139451",
fall = "rbxassetid://616134815",
climb = "rbxassetid://616133594",
},
}

local AnimationPackList = {"OFF","Zombie","Ninja","Knight","Elder","Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish"}
local AnimationPackIndex = 1
local OriginalAnims = {}
local animationPackValueLabel = nil
local refreshAnimationPackRow = nil

_G.ExeAnimationSystem = _G.ExeAnimationSystem or {
    conn = nil,
    original = nil,
    activePack = "OFF",
}

function _G.ExeAnimGetAnimate(char)
    char = char or LP.Character
    return char and char:FindFirstChild("Animate") or nil
end

function _G.ExeAnimReadOriginal(char)
    if _G.ExeAnimationSystem.original then return end
    local animate = _G.ExeAnimGetAnimate(char)
    if not animate then return end

    local function g(obj)
        return obj and obj.AnimationId or nil
    end

    _G.ExeAnimationSystem.original = {
        idle1 = g(animate.idle and animate.idle:FindFirstChild("Animation1")),
        idle2 = g(animate.idle and animate.idle:FindFirstChild("Animation2")),
        walk = g(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
        run = g(animate.run and animate.run:FindFirstChild("RunAnim")),
        jump = g(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
        fall = g(animate.fall and animate.fall:FindFirstChild("FallAnim")),
        climb = g(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
        swim = g(animate.swim and animate.swim:FindFirstChild("Swim")),
        swimidle = g(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle")),
    }
end

function _G.ExeAnimGetPack(packName)
    return AnimationPacks[packName]
end

function _G.ExeAnimApplyPack(char, packName)
    local animate = _G.ExeAnimGetAnimate(char)
    local pack = _G.ExeAnimGetPack(packName)
    if not animate or not pack then return false end

    local function s(obj, id)
        if obj and id then
            obj.AnimationId = tostring(id)
        end
    end

    s(animate.idle and animate.idle:FindFirstChild("Animation1"), pack.idle and pack.idle[1] and pack.idle[1][1])
    s(animate.idle and animate.idle:FindFirstChild("Animation2"), pack.idle and pack.idle[2] and pack.idle[2][1])
    s(animate.walk and animate.walk:FindFirstChild("WalkAnim"), pack.walk)
    s(animate.run and animate.run:FindFirstChild("RunAnim"), pack.run)
    s(animate.jump and animate.jump:FindFirstChild("JumpAnim"), pack.jump)
    s(animate.fall and animate.fall:FindFirstChild("FallAnim"), pack.fall)
    s(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), pack.climb)
    s(animate.swim and animate.swim:FindFirstChild("Swim"), pack.swim)
    s(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle"), pack.swimidle)

    return true
end

function _G.ExeAnimRestore(char)
    local animate = _G.ExeAnimGetAnimate(char)
    local o = _G.ExeAnimationSystem.original
    if not animate or not o then return end

    local function s(obj,id)
        if obj and id then obj.AnimationId = id end
    end

    s(animate.idle and animate.idle:FindFirstChild("Animation1"), o.idle1)
    s(animate.idle and animate.idle:FindFirstChild("Animation2"), o.idle2)
    s(animate.walk and animate.walk:FindFirstChild("WalkAnim"), o.walk)
    s(animate.run and animate.run:FindFirstChild("RunAnim"), o.run)
    s(animate.jump and animate.jump:FindFirstChild("JumpAnim"), o.jump)
    s(animate.fall and animate.fall:FindFirstChild("FallAnim"), o.fall)
    s(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), o.climb)
    s(animate.swim and animate.swim:FindFirstChild("Swim"), o.swim)
    s(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle"), o.swimidle)
end

function _G.ExeAnimStop()
    if _G.ExeAnimationSystem.conn then
        pcall(function() _G.ExeAnimationSystem.conn:Disconnect() end)
        _G.ExeAnimationSystem.conn = nil
    end

    _G.ExeAnimRestore(LP.Character)
    _G.ExeAnimationSystem.activePack = "OFF"
end

function _G.ExeAnimStart(packName)
    if packName == "OFF" then
        _G.ExeAnimStop()
        return
    end

    if _G.ExeAnimationSystem.conn then
        pcall(function() _G.ExeAnimationSystem.conn:Disconnect() end)
        _G.ExeAnimationSystem.conn = nil
    end

    local char = LP.Character
    if not char then return end

    local pack = _G.ExeAnimGetPack(packName)
    if not pack then return end

    _G.ExeAnimReadOriginal(char)
    _G.ExeAnimationSystem.activePack = packName

    task.spawn(function()
        local list = {}
        for _, v in pairs(pack) do
            if type(v) == "string" then
                table.insert(list, v)
            elseif type(v) == "table" then
                for _, a in ipairs(v) do
                    if type(a) == "table" and a[1] then
                        table.insert(list, tostring(a[1]))
                    end
                end
            end
        end
        pcall(function()
            game:GetService("ContentProvider"):PreloadAsync(list)
        end)
    end)

    _G.ExeAnimApplyPack(char, packName)

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    _G.ExeAnimationSystem.conn = RunService.Heartbeat:Connect(function()
        if selectedAnimationPack == "OFF" then return end
        local c = LP.Character
        if c then
            _G.ExeAnimApplyPack(c, selectedAnimationPack)
        end
    end)
end

function syncAnimationPackIndex()
    local found = 1
    for i, name in ipairs(AnimationPackList) do
        if name == selectedAnimationPack then
            found = i
            break
        end
    end
    AnimationPackIndex = found
end

function applyAnimationPack(packName)
    selectedAnimationPack = packName or "OFF"
    syncAnimationPackIndex()

    if selectedAnimationPack == "OFF" then
        _G.ExeAnimStop()
    else
        _G.ExeAnimStart(selectedAnimationPack)
    end

    if refreshAnimationPackRow then
        pcall(refreshAnimationPackRow)
    end
end

-- Vynx-style Unwalk implementation ported to the original STATIC_HUB build.
-- Disable Roblox's Animate LocalScript and stop newly-played tracks while enabled;
-- restore the script when Unwalk is switched off.
local unwalkRuntime = {
    generation = 0,
    animationConn = nil,
    animate = nil,
    disabledByUs = false,
}

local function disconnectUnwalk()
    unwalkRuntime.generation += 1
    if unwalkRuntime.animationConn then
        pcall(function() unwalkRuntime.animationConn:Disconnect() end)
        unwalkRuntime.animationConn = nil
    end
end

local function restoreUnwalkAnimate(force)
    local animate = unwalkRuntime.animate
    local disabledByUs = unwalkRuntime.disabledByUs
    unwalkRuntime.animate = nil
    unwalkRuntime.disabledByUs = false
    unwalkSavedAnimate = nil
    if animate and animate.Parent and disabledByUs and (force or not unwalkEnabled) then
        pcall(function() animate.Disabled = false end)
    end
end

local function applyVynxUnwalk(character)
    local previousAnimate = unwalkRuntime.animate
    local previouslyDisabledByUs = unwalkRuntime.disabledByUs
    disconnectUnwalk()
    if not unwalkEnabled then return end
    character = character or LP.Character
    if not character or character ~= LP.Character then return end

    local generation = unwalkRuntime.generation
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    local animate = character:FindFirstChild("Animate") or character:WaitForChild("Animate", 5)
    if not humanoid or not animate or generation ~= unwalkRuntime.generation
        or not unwalkEnabled or character ~= LP.Character then
        return
    end

    unwalkRuntime.animate = animate
    unwalkSavedAnimate = animate
    unwalkRuntime.disabledByUs = (previousAnimate == animate and previouslyDisabledByUs)
        or (animate:IsA("LocalScript") and not animate.Disabled)
    if animate:IsA("LocalScript") then
        pcall(function() animate.Disabled = true end)
    end

    local function stopAllTracks()
        if generation ~= unwalkRuntime.generation or not unwalkEnabled
            or character ~= LP.Character or humanoid.Parent ~= character then
            return
        end
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
    end

    unwalkRuntime.animationConn = humanoid.AnimationPlayed:Connect(function(track)
        if generation ~= unwalkRuntime.generation or not unwalkEnabled then return end
        pcall(function() track:Stop(0) end)
    end)
    stopAllTracks()
end

enableUnwalk = function()
    unwalkEnabled = true
    selectedAnimationPack = "OFF"
    if type(_G.ExeAnimStop) == "function" then pcall(_G.ExeAnimStop) end
    applyVynxUnwalk(LP.Character)
end

disableUnwalk = function()
    unwalkEnabled = false
    disconnectUnwalk()
    restoreUnwalkAnimate(false)
end

-- Keep Unwalk applied after respawn, after the original animation-pack restore has run.
LP.CharacterAdded:Connect(function(character)
    if not unwalkEnabled then return end
    task.delay(1.05, function()
        if unwalkEnabled and character == LP.Character then
            pcall(function() applyVynxUnwalk(character) end)
        end
    end)
end)

enableHitHarderAnim = function()
    applyAnimationPack("Zombie")
end

disableHitHarderAnim = function()
    applyAnimationPack("OFF")
end

resetAnimations = function()
    applyAnimationPack("OFF")
end

stopCurrentAnimations = function(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
end

getAnimate = function(char)
    return _G.ExeAnimGetAnimate(char)
end

setAnimId = function(obj,id)
    if obj and id then obj.AnimationId = tostring(id) end
end

reloadAnimate = function(animate)
    if not animate then return end
    pcall(function()
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end)
end

backupAnimations = function(char)
    _G.ExeAnimReadOriginal(char)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    _G.ExeAnimationSystem.original = nil
    if selectedAnimationPack and selectedAnimationPack ~= "OFF" then
        _G.ExeAnimStart(selectedAnimationPack)
    end
end)

local antiRagdollResetCooldown = 0

local function forceAntiRagdollReset()
    local char = LP.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        if workspace.CurrentCamera then
            workspace.CurrentCamera.CameraSubject = hum
        end

        local playerScripts = LP:FindFirstChild("PlayerScripts")
        local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModuleObj = playerModule:FindFirstChild("ControlModule")
            if controlModuleObj then
                local ok, controls = pcall(require, controlModuleObj)
                if ok and controls and controls.Enable then
                    pcall(function() controls:Enable() end)
                end
            end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollEnabled = true
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown)
        if not root then return end

        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end
        if ragdolled then
            local now = tick()
            if now - (antiRagdollResetCooldown or 0) > 0.15 then
                antiRagdollResetCooldown = now

                pcall(function()
                    LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
                end)

                for _, d in ipairs(char:GetDescendants()) do
                    if d:IsA("BallSocketConstraint") or
                       (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                        d:Destroy()
                    end
                end

                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Motor6D") and not obj.Enabled then
                        obj.Enabled = true
                    end
                end
                if hum.Health > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                workspace.CurrentCamera.CameraSubject = hum
                root.Anchored = false
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end)
end

local function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local function setAntiRagdoll(on)
    if on then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
end

_G.ExeInfJumpMode = "Hold"

local _xIJBoosting   = false
local _xIJLastBoost  = 0
local _xIJForce      = 25
local _xIJFrames     = 2
local _xIJCooldown   = 0.12
local _xJumpHeld     = false
local _xHoldIJConn   = nil

local function _xApplyInfJumpBoost(root)
    if not root or _xIJBoosting then return end
    local now = tick()
    if now - _xIJLastBoost < _xIJCooldown then return end
    _xIJLastBoost  = now
    _xIJBoosting   = true
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.P        = 1250
    local cur   = root.AssemblyLinearVelocity
    bv.Velocity = Vector3.new(cur.X, _xIJForce, cur.Z)
    bv.Parent   = root
    local frames = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if frames < _xIJFrames then
            frames = frames + 1
            if bv and bv.Parent then
                bv.Velocity = bv.Velocity + Vector3.new(0, 0.01, 0)
            end
        else
            if bv then pcall(function() bv:Destroy() end) end
            if conn then conn:Disconnect() end
            _xIJBoosting = false
        end
    end)
end

task.spawn(function()
    local pg = LP:WaitForChild("PlayerGui", 10)
    if not pg then return end
    local function hookBtn(btn)
        if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("XluIJHooked") then
            btn:SetAttribute("XluIJHooked", true)
            btn.MouseButton1Down:Connect(function() if infJumpEnabled then _xJumpHeld = true end end)
            btn.MouseButton1Up:Connect(function()  _xJumpHeld = false end)
            btn.MouseLeave:Connect(function()      _xJumpHeld = false end)
        end
    end
    for _, d in ipairs(pg:GetDescendants()) do hookBtn(d) end
    pg.DescendantAdded:Connect(hookBtn)
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and _G.ExeInfJumpMode == "Tap" then
        _xJumpHeld = true
        task.delay(0.08, function() _xJumpHeld = false end)
    end
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    -- Keyboard Space and the standard Roblox gamepad jump mapping.
    -- ButtonA maps to Xbox A and PlayStation Cross on supported controllers.
    local isKeyboardJump = inp.UserInputType == Enum.UserInputType.Keyboard
        and inp.KeyCode == Enum.KeyCode.Space
    local isGamepadJump = (inp.UserInputType == Enum.UserInputType.Gamepad1
        or inp.UserInputType == Enum.UserInputType.Gamepad2
        or inp.UserInputType == Enum.UserInputType.Gamepad3
        or inp.UserInputType == Enum.UserInputType.Gamepad4)
        and inp.KeyCode == Enum.KeyCode.ButtonA

    if infJumpEnabled and (isKeyboardJump or isGamepadJump) then
        _xJumpHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    local isKeyboardJump = inp.UserInputType == Enum.UserInputType.Keyboard
        and inp.KeyCode == Enum.KeyCode.Space
    local isGamepadJump = (inp.UserInputType == Enum.UserInputType.Gamepad1
        or inp.UserInputType == Enum.UserInputType.Gamepad2
        or inp.UserInputType == Enum.UserInputType.Gamepad3
        or inp.UserInputType == Enum.UserInputType.Gamepad4)
        and inp.KeyCode == Enum.KeyCode.ButtonA

    if isKeyboardJump or isGamepadJump then
        _xJumpHeld = false
    end
end)

RunService.Heartbeat:Connect(function()
    if not infJumpEnabled or _G.ExeInfJumpMode ~= "Tap" then return end
    if not _xJumpHeld then return end
    local char = LP.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    _xApplyInfJumpBoost(root)
end)

local function _xStartHoldIJ()
    if _xHoldIJConn then _xHoldIJConn:Disconnect() end
    _xHoldIJConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled or _G.ExeInfJumpMode ~= "Hold" then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local gamepadHeld = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad2, Enum.KeyCode.ButtonA)
            or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad3, Enum.KeyCode.ButtonA)
            or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad4, Enum.KeyCode.ButtonA)
        local held = UserInputService:IsKeyDown(Enum.KeyCode.Space) or gamepadHeld or _xJumpHeld
        local vel  = root.AssemblyLinearVelocity
        if held and vel.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
        end
        vel = root.AssemblyLinearVelocity
        if vel.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -120, vel.Z)
        end
    end)
end
_xStartHoldIJ()

setInfJumpInternal = function(on)
    infJumpEnabled = on and true or false
    if not infJumpEnabled then
        _xJumpHeld   = false
        _xIJBoosting = false
    end
end

_G.ExeAntiResetEnabled = _G.ExeAntiResetEnabled == true

-- ============================================================
-- ANTI DIE (full god-mode from Green Duels V3)
-- SetStateEnabled Dead false + heal on HealthChanged + death
-- revival via Died event + BreakJoints=false hook
-- ============================================================
_G.ExeAntiDie = { enabled = false, conns = {} }

function _G.ExeApplyAntiReset()
    pcall(function()
        StarterGui:SetCore("ResetButtonCallback", false)
    end)
end

function _G.ExeRestoreReset()
    pcall(function()
        StarterGui:SetCore("ResetButtonCallback", true)
    end)
end

local function adaptApplyGodMode(character)
    if not character or not character.Parent then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)

    local healConn
    healConn = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not _G.ExeAntiDie.enabled then return end
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    table.insert(_G.ExeAntiDie.conns, healConn)

    local deathConn
    deathConn = humanoid.Died:Connect(function()
        if not _G.ExeAntiDie.enabled then return end
        deathConn:Disconnect()
        task.wait(0.05)
        if humanoid and humanoid.Parent then
            humanoid.Health = humanoid.MaxHealth
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            deathConn = humanoid.Died:Connect(function()
                if not _G.ExeAntiDie.enabled then return end
                task.wait(0.05)
                if humanoid and humanoid.Parent then
                    humanoid.Health = humanoid.MaxHealth
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end)
    table.insert(_G.ExeAntiDie.conns, deathConn)

    local breakConn
    pcall(function()
        breakConn = character:GetPropertyChangedSignal("BreakJoints"):Connect(function()
            if not _G.ExeAntiDie.enabled then return end
            if character.BreakJoints then character.BreakJoints = false end
        end)
    end)
    if breakConn then table.insert(_G.ExeAntiDie.conns, breakConn) end
end

function _G.ExeHookAntiDieCharacter(char)
    if not _G.ExeAntiDie.enabled then return end
    adaptApplyGodMode(char)
end

function _G.ExeSetAntiReset(on)
    _G.ExeAntiResetEnabled = on == true
    _G.ExeAntiDie.enabled = on == true

    if _G.ExeAntiResetEnabled then

        task.spawn(function()
            for _ = 1, 12 do
                if not _G.ExeAntiResetEnabled then return end
                _G.ExeApplyAntiReset()
                task.wait(0.25)
            end
        end)

        for _, c in ipairs(_G.ExeAntiDie.conns) do
            pcall(function() c:Disconnect() end)
        end
        _G.ExeAntiDie.conns = {}

        if LP.Character then
            task.spawn(function()
                task.wait(0.1)
                adaptApplyGodMode(LP.Character)
            end)
        end
    else
        for _, c in ipairs(_G.ExeAntiDie.conns) do
            pcall(function() c:Disconnect() end)
        end
        _G.ExeAntiDie.conns = {}
        _G.ExeRestoreReset()
    end
end

if _G.ExeAntiDieCharConn then
    pcall(function() _G.ExeAntiDieCharConn:Disconnect() end)
end
_G.ExeAntiDieCharConn = LP.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    if _G.ExeAntiDie.enabled then
        adaptApplyGodMode(char)
    end

    if _G.ExeRestoreAntiDieAfterReset then
        _G.ExeRestoreAntiDieAfterReset = false
        task.wait(0.35)
        _G.ExeSetAntiReset(true)
        if _G.ExeAntiResetVisual then
            pcall(function() _G.ExeAntiResetVisual(true) end)
        end
        if saveExeConfig then pcall(saveExeConfig) end
    end
end)

if LP.Character and _G.ExeAntiResetEnabled then
    task.defer(function()
        _G.ExeAntiDie.enabled = true
        adaptApplyGodMode(LP.Character)
    end)
end

-- ==================== ANTI E01 ERROR ====================
_G.ExeAntiE01Enabled = _G.ExeAntiE01Enabled == true
local _e01WasCarrying = false
local _e01CurrentUI = nil
local _e01Connection = nil
local _e01LoopThread = nil

local function _e01IsCarrying()
    local char = LP.Character
    if not char then return false end

    for _, child in pairs(char:GetChildren()) do
        local name = string.lower(child.Name)
        if name:find("brainrot") or name:find("brain") or name:find("animal") or
           name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then
            return true
        end
    end

    for attrName, attrValue in pairs(char:GetAttributes()) do
        local name = string.lower(tostring(attrName))
        if (name:find("carrying") or name:find("carry") or name:find("stealing") or
            name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
            return true
        end
    end

    local okSteal, stealVal = pcall(function() return LP:GetAttribute("Stealing") end)
    if okSteal and stealVal == true then return true end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
        return true
    end

    return false
end

local function _e01CleanupUI()
    if _e01Connection then
        pcall(function() _e01Connection:Disconnect() end)
        _e01Connection = nil
    end
    if _e01CurrentUI then
        pcall(function() _e01CurrentUI:Destroy() end)
        _e01CurrentUI = nil
    end
end

local function _e01ShowCarryWarning()
    _e01CleanupUI()

    local playerGui = PlayerGui or LP:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CarryWarningUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if type(safeParentGui) == "function" then
        safeParentGui(screenGui)
    end
    if not screenGui.Parent then
        screenGui.Parent = playerGui
    end
    _e01CurrentUI = screenGui

    local frame = Instance.new("Frame")
    frame.Name = "WarningFrame"
    frame.Parent = screenGui
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, -50)
    frame.Size = UDim2.new(0, 340, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(28, 3, 8)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ZIndex = 300

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Parent = frame
    uiStroke.Color = Color3.fromRGB(235, 25, 55)
    uiStroke.Thickness = 2
    uiStroke.Transparency = 0.05

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 10, 0, 4)
    textLabel.Size = UDim2.new(1, -20, 1, -8)
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.TextColor3 = Color3.fromRGB(255, 225, 230)
    textLabel.TextStrokeColor3 = Color3.fromRGB(100, 0, 20)
    textLabel.TextStrokeTransparency = 0.35
    textLabel.TextScaled = false
    textLabel.TextSize = 9
    textLabel.TextWrapped = true
    textLabel.ZIndex = 301
    textLabel.Text = "3.00 SECONDS REMAINING"

    local scale = Instance.new("UIScale")
    scale.Parent = frame
    scale.Scale = 0.9

    local slideIn = TweenService:Create(
        frame,
        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = UDim2.new(0.5, 0, 0, 8) }
    )
    local scaleIn = TweenService:Create(
        scale,
        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Scale = 1 }
    )
    slideIn:Play()
    scaleIn:Play()

    local duration = 3.0
    local startTime = tick()
    local finished = false

    _e01Connection = RunService.RenderStepped:Connect(function()
        if finished or not frame.Parent or not _G.ExeAntiE01Enabled then
            if _e01Connection then
                pcall(function() _e01Connection:Disconnect() end)
                _e01Connection = nil
            end
            return
        end

        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)

        if remaining > 0 then
            textLabel.Text = string.format("%.2f SECONDS REMAINING", remaining)
            textLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            uiStroke.Color = Color3.fromRGB(235, 25, 55)
        else
            finished = true
            if _e01Connection then
                pcall(function() _e01Connection:Disconnect() end)
                _e01Connection = nil
            end

            textLabel.Text = "SAFE - STEAL NOW!"
            textLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            uiStroke.Color = Color3.fromRGB(0, 255, 100)

            local bounce = TweenService:Create(
                frame,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 360, 0, 48) }
            )
            bounce:Play()
            task.delay(0.3, function()
                if not frame or not frame.Parent then return end
                local bounceBack = TweenService:Create(
                    frame,
                    TweenInfo.new(0.2),
                    { Size = UDim2.new(0, 340, 0, 44) }
                )
                bounceBack:Play()
            end)

            task.delay(3, function()
                if not frame or not frame.Parent then return end
                local slideOut = TweenService:Create(
                    frame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {
                        Position = UDim2.new(0.5, 0, 0, -50),
                        BackgroundTransparency = 1
                    }
                )
                local fadeText = TweenService:Create(
                    textLabel,
                    TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    { TextTransparency = 1, TextStrokeTransparency = 1 }
                )
                slideOut:Play()
                fadeText:Play()
                slideOut.Completed:Connect(function()
                    if screenGui then
                        pcall(function() screenGui:Destroy() end)
                        if _e01CurrentUI == screenGui then
                            _e01CurrentUI = nil
                        end
                    end
                end)
            end)
        end
    end)
end

local function _e01StopLoop()
    if _e01LoopThread then
        pcall(function() task.cancel(_e01LoopThread) end)
        _e01LoopThread = nil
    end
    _e01CleanupUI()
    _e01WasCarrying = false
end

local function _e01StartLoop()
    _e01StopLoop()
    _e01LoopThread = task.spawn(function()
        while _G.ExeAntiE01Enabled do
            task.wait(0.1)
            if not _G.ExeAntiE01Enabled then break end
            local currentlyCarrying = false
            pcall(function() currentlyCarrying = _e01IsCarrying() end)
            if not _e01WasCarrying and currentlyCarrying then
                pcall(_e01ShowCarryWarning)
            end
            _e01WasCarrying = currentlyCarrying
        end
    end)
end

function _G.ExeSetAntiE01(on)
    _G.ExeAntiE01Enabled = on == true
    _e01StopLoop()
    if _G.ExeAntiE01Enabled then
        _e01StartLoop()
    end
    if _G.ExeAntiE01Visual then pcall(_G.ExeAntiE01Visual, _G.ExeAntiE01Enabled) end
    if saveExeConfig then pcall(saveExeConfig) end
end

if _G.ExeAntiE01Enabled then
    task.defer(function()
        if _G.ExeSetAntiE01 then _G.ExeSetAntiE01(true) end
    end)
end

-- ==================== ANTI DROP ====================
_G.ExeAntiDropEnabled = _G.ExeAntiDropEnabled == true
local _antiDropActive = false
local _antiDropMt = nil
local _antiDropOldIdx = nil
local _antiDropOldNewIdx = nil
local _antiDropSpoofedVelocity = Vector3.zero

local function _exeStartAntiDrop()
    if _antiDropActive then return end
    local ok, mt = pcall(function()
        if type(getrawmetatable) ~= "function" then return nil end
        return getrawmetatable(game)
    end)
    if not ok or not mt then return end
    if type(setreadonly) ~= "function" or type(newcclosure) ~= "function" then return end
    if type(checkcaller) ~= "function" then return end

    _antiDropMt = mt
    _antiDropOldIdx = mt.__index
    _antiDropOldNewIdx = mt.__newindex

    pcall(function() setreadonly(mt, false) end)

    mt.__index = newcclosure(function(self, key)
        if not checkcaller()
            and (key == "AssemblyLinearVelocity" or key == "Velocity")
            and typeof(self) == "Instance"
            and self:IsA("BasePart")
            and self.Name == "HumanoidRootPart"
            and LP.Character
            and self:IsDescendantOf(LP.Character)
        then
            return _antiDropSpoofedVelocity
        end
        return _antiDropOldIdx(self, key)
    end)

    mt.__newindex = newcclosure(function(self, key, value)
        if not checkcaller()
            and (key == "AssemblyLinearVelocity" or key == "Velocity")
            and typeof(self) == "Instance"
            and self:IsA("BasePart")
            and self.Name == "HumanoidRootPart"
            and LP.Character
            and self:IsDescendantOf(LP.Character)
        then
            _antiDropSpoofedVelocity = value
            return
        end
        return _antiDropOldNewIdx(self, key, value)
    end)

    pcall(function() setreadonly(mt, true) end)
    _antiDropActive = true
end

local function _exeStopAntiDrop()
    if not _antiDropActive then return end
    if _antiDropMt and _antiDropOldIdx then
        pcall(function()
            setreadonly(_antiDropMt, false)
            _antiDropMt.__index = _antiDropOldIdx
            _antiDropMt.__newindex = _antiDropOldNewIdx
            setreadonly(_antiDropMt, true)
        end)
        _antiDropOldIdx = nil
        _antiDropOldNewIdx = nil
        _antiDropMt = nil
    end
    _antiDropActive = false
end

function _G.ExeSetAntiDrop(on)
    _G.ExeAntiDropEnabled = on == true
    -- Always stop first so re-execute / re-toggle rehooks cleanly
    _exeStopAntiDrop()
    if _G.ExeAntiDropEnabled then
        _exeStartAntiDrop()
    end
    if _G.ExeAntiDropVisual then pcall(_G.ExeAntiDropVisual, _G.ExeAntiDropEnabled) end
    if saveExeConfig then pcall(saveExeConfig) end
end

if _G.ExeAntiDropEnabled then
    task.defer(function()
        if _G.ExeSetAntiDrop then _G.ExeSetAntiDrop(true) end
    end)
end

_G.ExeHeadlessEnabled = _G.ExeHeadlessEnabled == true
_G.ExeKorbloxEnabled = _G.ExeKorbloxEnabled == true
_G.ExeHeadlessMeshId = "rbxassetid://1095708"
_G.ExeKorbloxMeshId = "rbxassetid://101851696"
_G.ExeKorbloxTextureId = "rbxassetid://101851254"

function _G.ExeApplyHeadless(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        local face = head:FindFirstChild("face")
        if face then face:Destroy() end

        local old = head:FindFirstChild("ExeHeadlessMesh")
        if old then old:Destroy() end

        local mesh = Instance.new("SpecialMesh")
        mesh.Name = "ExeHeadlessMesh"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = _G.ExeHeadlessMeshId
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Parent = head
    else
        head.Transparency = 0
        head.CanCollide = true
        local old = head:FindFirstChild("ExeHeadlessMesh")
        if old then old:Destroy() end
    end
end

function _G.ExeApplyKorblox(char, enabled)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if hum.RigType == Enum.HumanoidRigType.R6 then
        local leg = char:FindFirstChild("Right Leg")
        if not leg then return end

        local old = leg:FindFirstChild("ExeKorbloxMesh")
        if old then old:Destroy() end

        if enabled then
            leg.Color = Color3.fromRGB(64,64,64)
            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "ExeKorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = _G.ExeKorbloxMeshId
            mesh.TextureId = _G.ExeKorbloxTextureId
            mesh.Scale = Vector3.new(1,1,1)
            mesh.Parent = leg
        else
            leg.Color = Color3.fromRGB(255,255,255)
        end
    else
        local upper = char:FindFirstChild("RightUpperLeg")
        local lower = char:FindFirstChild("RightLowerLeg")
        local foot = char:FindFirstChild("RightFoot")
        if not upper then return end

        local oldLeg = char:FindFirstChild("ExeKorbloxLeg")
        if oldLeg then oldLeg:Destroy() end

        if enabled then
            upper.Transparency = 1
            if lower then lower.Transparency = 1 end
            if foot then foot.Transparency = 1 end

            local kleg = Instance.new("Part")
            kleg.Name = "ExeKorbloxLeg"
            kleg.Size = Vector3.new(1,2,1)
            kleg.Anchored = false
            kleg.CanCollide = false
            kleg.Massless = true
            kleg.Color = Color3.fromRGB(64,64,64)
            kleg.Parent = char

            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "ExeKorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = _G.ExeKorbloxMeshId
            mesh.TextureId = _G.ExeKorbloxTextureId
            mesh.Scale = Vector3.new(1,1,1)
            mesh.Parent = kleg

            local weld = Instance.new("Weld")
            weld.Name = "ExeKorbloxWeld"
            weld.Part0 = upper
            weld.Part1 = kleg
            weld.C0 = CFrame.new(0,-0.8,0)
            weld.Parent = kleg
        else
            upper.Transparency = 0
            if lower then lower.Transparency = 0 end
            if foot then foot.Transparency = 0 end
        end
    end
end

function _G.ExeApplyCharacterVisuals(char)
    char = char or LP.Character
    if not char then return end
    pcall(function() _G.ExeApplyHeadless(char, _G.ExeHeadlessEnabled) end)
    pcall(function() _G.ExeApplyKorblox(char, _G.ExeKorbloxEnabled) end)
end

_G.ExeBodyLockEnabled = _G.ExeBodyLockEnabled == true
_G.ExeBodyLockRadius = tonumber(_G.ExeBodyLockRadius) or 60
_G.ExeBodyLockConn = _G.ExeBodyLockConn or nil

function _G.ExeGetNearestBodyLockTarget()
local character = LP.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
if not root then return nil end

local nearest = nil
local shortest = math.huge

for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tr = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tr and hum and hum.Health > 0 then
local d = (tr.Position - root.Position).Magnitude
if d <= (_G.ExeBodyLockRadius or 60) and d < shortest then
shortest = d
nearest = plr
end
end
end
end

return nearest
end

function _G.ExeStartBodyLock()
if _G.ExeBodyLockConn then return end
_G.ExeBodyLockEnabled = true

_G.ExeBodyLockConn = RunService.Heartbeat:Connect(function()
if not _G.ExeBodyLockEnabled then return end

local character = LP.Character
local myRoot = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not myRoot or not humanoid or humanoid.Health <= 0 then return end

local target = _G.ExeGetNearestBodyLockTarget()
if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
local targetPos = target.Character.HumanoidRootPart.Position
local myPos = myRoot.Position
local offset = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos

if offset.Magnitude > 0.1 then
humanoid.AutoRotate = false
local lookDir = offset.Unit
local currentDir = myRoot.CFrame.LookVector
local cross = currentDir:Cross(lookDir)
local currentVel = myRoot.AssemblyAngularVelocity
myRoot.AssemblyAngularVelocity = Vector3.new(currentVel.X, cross.Y * 40, currentVel.Z)
end
else
humanoid.AutoRotate = true
end
end)
end

function _G.ExeStopBodyLock()
_G.ExeBodyLockEnabled = false

if _G.ExeBodyLockConn then
pcall(function() _G.ExeBodyLockConn:Disconnect() end)
_G.ExeBodyLockConn = nil
end

local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum then
hum.AutoRotate = true
end
end

function _G.ExeSetBodyLock(on)
_G.ExeBodyLockEnabled = on == true
if _G.ExeBodyLockEnabled then
_G.ExeStartBodyLock()
else
_G.ExeStopBodyLock()
end

if _G.ExeBodyLockVisual then
pcall(function() _G.ExeBodyLockVisual(_G.ExeBodyLockEnabled) end)
end
end

LP.CharacterAdded:Connect(function()
if _G.ExeBodyLockEnabled then
task.wait(0.3)
_G.ExeStopBodyLock()
_G.ExeStartBodyLock()
end
end)

local currentBackground = 0
local aceGuiScaleValue = ExeAutoMobile and 0.67 or 1.00
local aceProgressBarScaleValue = ExeAutoMobile and 0.83 or 1.00
CONFIG_FILE = "ExeDuels_MainGUI_Config_DefaultsV2.json"
KEYBINDS_CONFIG_FILE = "ExeDuels_Keybinds_DefaultsV2.json"
_ace_isfile = isfile or (syn and syn.isfile) or function(path)
local ok, result = pcall(function() return readfile(path) end)
return ok and result ~= nil
end
_ace_readfile = readfile or (syn and syn.readfile)
_ace_writefile = writefile or (syn and syn.writefile)
canSaveConfig = (type(_ace_readfile) == "function" and type(_ace_writefile) == "function")

-- Intro system and intro music helpers removed by request.

savedConfig = {}
_G.ExeGuiLocked = _G.ExeGuiLocked == true
if _G.ExeHideMobileButtons == nil then
_G.ExeHideMobileButtons = not ExeAutoMobile
else
_G.ExeHideMobileButtons = _G.ExeHideMobileButtons == true
_G.ExeMobileButtonScale = tonumber(_G.ExeMobileButtonScale) or 0.75
end
_G.ExeMobileButtonScale = tonumber(_G.ExeMobileButtonScale) or (ExeAutoMobile and 0.90 or 1.00)
_G.ExeMobileButtonPositions = _G.ExeMobileButtonPositions or {}
_G.ExeMobileButtonImage = _G.ExeMobileButtonImage or "rbxassetid://110350353403289"
_G.ExeMobileButtonShape = _G.ExeMobileButtonShape or "ROUNDED"
_G.ExeStealUIImage = _G.ExeStealUIImage or ""
savedMainPositionTable = nil
savedMiniPositionTable = nil
function udim2ToTable(u)
return {xs = u.X.Scale, xo = u.X.Offset, ys = u.Y.Scale, yo = u.Y.Offset}
end
function tableToUDim2(t, fallback)
if type(t) == "table" then
return UDim2.new(tonumber(t.xs) or 0, tonumber(t.xo) or 0, tonumber(t.ys) or 0, tonumber(t.yo) or 0)
end
return fallback
end
function collectExeMobileButtonPositions()
local out = {}
for key, entry in pairs(_G.ExeMobileButtonRefs or {}) do
local holder = entry and entry.holder
if holder then out[key] = udim2ToTable(holder.Position) end
end
if next(out) == nil and type(_G.ExeMobileButtonPositions) == "table" then
return _G.ExeMobileButtonPositions
end
_G.ExeMobileButtonPositions = out
return out
end
-- layout v3: AUTO LEFT/RIGHT above DROP/AIMBOT; laggers under TP/CARRY
_G.ExeMobileLayoutV = _G.ExeMobileLayoutV or 0
if _G.ExeMobileLayoutV < 6 then
    _G.ExeMobileLayoutV = 6
    _G.ExeMobileButtonPositions = {}
end
function getSavedMobileButtonPosition(key, fallback)
if type(_G.ExeMobileButtonPositions) == "table" then
local t = _G.ExeMobileButtonPositions[key]
if type(t) == "table" then
return tableToUDim2(t, fallback)
end
end
return fallback
end
function saveMobileButtonPosition(key, pos)
if not key then return end
_G.ExeMobileButtonPositions = _G.ExeMobileButtonPositions or {}
_G.ExeMobileButtonPositions[key] = udim2ToTable(pos)
if type(saveExeConfig) == "function" then
pcall(saveExeConfig)
end
end
function keyToString(key)
if not key then return "None" end
return tostring(key):gsub("Enum.KeyCode.", "")
end
function stringToKeyCode(value)
if type(value) ~= "string" or value == "" or value == "None" then return nil end
return Enum.KeyCode[value]
end
function keybindsToTable()
local out = {}
for keyId in pairs(DEFAULT_SPEED_KEYBINDS) do
out[keyId] = keyToString(speedKeybinds[keyId])
end
for keyId, key in pairs(speedKeybinds) do
out[keyId] = keyToString(key)
end
return out
end
function collectExeKeybindConfig()
return {
keybinds = keybindsToTable(),
tpDownKeybind = keyToString(tpDownKeybind),
}
end
function applySavedKeybinds(t)
if type(t) ~= "table" then return end
for keyId in pairs(speedKeybinds) do
if t[keyId] ~= nil then
speedKeybinds[keyId] = stringToKeyCode(t[keyId])
end
end
end
function applyDefaultExeKeybinds()
for keyId, key in pairs(DEFAULT_SPEED_KEYBINDS) do
speedKeybinds[keyId] = key
end
tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND
end
function collectExeConfig()
return {
mainPosition = savedMainPositionTable,
miniPosition = savedMiniPositionTable,
keybinds = keybindsToTable(),
tpDownKeybind = keyToString(tpDownKeybind),
NS = NS,
CS = CS,
LAGGER_SPEED = LAGGER_SPEED,
LAGGER_CARRY_SPEED = LAGGER_CARRY_SPEED,
currentSpeedMode = currentSpeedMode,
dropMode = _G.ExeDropMode,
dropAfterMode = _G.ExeDropAfterMode,
autoCarrySpeedEnabled = autoCarrySpeedEnabled == true,
autoTPEnabled = autoTPEnabled,
autoTPHeight = autoTPHeight,
infJumpEnabled = infJumpEnabled,
infJumpMode = _G.ExeInfJumpMode,
antiRagdollEnabled = antiRagdollEnabled,
antiRagdollMode = _G.ExeAntiRagdollMode,
antiVoidEnabled = _G.ExeAntiVoidEnabled == true,
antiResetEnabled = _G.ExeAntiResetEnabled == true,
antiE01Enabled = _G.ExeAntiE01Enabled == true,
antiDropEnabled = _G.ExeAntiDropEnabled == true,
selectedAnimationPack = selectedAnimationPack,
selectedMoreAnimationBundle = _G.ExeSelectedMoreAnimationBundle,
unwalkEnabled = unwalkEnabled == true,
currentOutfitIndex = tonumber(_G.ExeOutfitIndex) or 1,
selectedStealMode = selectedStealMode,
autoStealEnabled = autoStealEnabled,
autoStealRadius = autoStealRadius,
aceStealRadii = _G.ExeStealRadii,
selectedAimbotMode = selectedAimbotMode,
AIMBOT_SPEED = AIMBOT_SPEED,
LAGGER_AIMBOT_SPEED = LAGGER_AIMBOT_SPEED,
BAT_V2_SPEED = tonumber(BAT_V2_SPEED) or 58,
ANTI_BYPASS_AIMBOT_SPEED = _G.ExeAntiBypassAimbotSpeed,
ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.ExeAntiBypassLaggerAimbotSpeed,
ANTI_DESYNC_AIMBOT_SPEED = ANTI_DESYNC_AIMBOT_SPEED,
autoSwingEnabled = autoSwingEnabled,
mirrorTPDownEnabled = mirrorTPDownEnabled,
normalAimbotEnabled = _G.ExeNormalAimbotOn == true,
antiBypassAimbotEnabled = _G.ExeAntiBypassAimbotOn == true,
antiDesyncAutoSwingEnabled = antiDesyncAutoSwingEnabled,
antiDesyncAimbotEnabled = _G.ExeAntiDesyncAimbotOn == true,
antiTpBatEnabled = _G.ExeAntiTpBatEnabled == true,
batCounterEnabled = batCounterEnabled,
medCounterEnabled = medCounterEnabled,
hardHitEnabled = hardHitEnabled == true,
hardHitRadius = tonumber(hardHitRadius) or 10,
perfectHitEnabled = perfectHitEnabled == true,
perfectHitRange = tonumber(perfectHitRange) or 175,
safeMode = antiKickEnabled == true,
autoResetOnMedEnabled = autoResetOnMedEnabled,
espEnabled = espEnabled,
showTracerEnabled = showTracerEnabled,
ragdollCountdownEnabled = ragdollCountdownEnabled,
fpsBoostEnabled = fpsBoostEnabled,
antiLagVisualEnabled = antiLagVisualEnabled,
nukeOptimiserEnabled = nukeOptimiserEnabled,
fovEnabled = fovEnabled,
fovValue = fovValue,
noCamCollisionEnabled = noCamCollisionEnabled,
noPlayerCollisionEnabled = _G.ExeNoPlayerCollisionEnabled,
skyTheme = skyTheme,
autoLeftEnabled = autoLeftEnabled,
autoRightEnabled = autoRightEnabled,
currentBackground = currentBackground,
bodyLockEnabled = _G.ExeBodyLockEnabled == true,
bodyLockRadius = tonumber(_G.ExeBodyLockRadius) or 60,
tpBatVersion = (_G.ExeTpBatSelected == "V2") and "V2" or "V1",
mobileButtonScale = tonumber(_G.ExeMobileButtonScale) or 0.75,
guiScaleValue = tonumber(_G.ExeGuiScaleValue) or tonumber(adaptGuiScaleValue) or tonumber(aceGuiScaleValue) or 0.52,
stealUiScaleValue = tonumber(_G.ExeProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or 0.83,
headlessEnabled = _G.ExeHeadlessEnabled == true,
korbloxEnabled = _G.ExeKorbloxEnabled == true,
currentThemeName = "BLUE",
aceGuiScaleValue = aceGuiScaleValue,
aceProgressBarScaleValue = aceProgressBarScaleValue,
guiLocked = _G.ExeGuiLocked == true,
stealBarPosition = _G.ExeStealBarPosition,
hideMobileButtons = _G.ExeHideMobileButtons == true,
hiddenMobileButtons = _G.ExeHiddenMobileButtons or {},
aceMobileButtonScale = _G.ExeMobileButtonScale,
mobileButtonPositions = collectExeMobileButtonPositions(),
mobileButtonImage = _G.ExeMobileButtonImage or "",
mobileButtonShape = _G.ExeMobileButtonShape or "ROUNDED",
mobileButtonColor = tostring(_G.ExeMobileButtonColor or "WHITE"),
stealUIImage = _G.ExeStealUIImage or "",
autoStealV3Radius = tonumber((_G.ExeStealRadii and _G.ExeStealRadii["Auto Steal V3"]) or autoStealRadius) or 63,
aceStealRadii = {
    ["Auto Steal V3"] = tonumber((_G.ExeStealRadii and _G.ExeStealRadii["Auto Steal V3"]) or autoStealRadius) or 63,
    Semi = tonumber((_G.ExeStealRadii and _G.ExeStealRadii.Semi) or 9) or 9,
},
duelMode = _G.ExeDuelMode or "half",
autoMoveSpeed = tonumber(_G.ExeAutoMoveSpeed) or 60,
autoMoveCarrySpeed = tonumber(_G.ExeAutoMoveCarrySpeed) or 30,
stretchValue = tonumber(_G.ExeStretchValue) or 0.7,
stretchPreset = _G.ExeStretchPreset or "Medium",
avatarChangerUserId = (_G.ExeAvatarChangerCleared and 0) or ((_G.ExeAvatarChangerState and _G.ExeAvatarChangerState.lastUserId) or 0),
avatarChangerUsername = (_G.ExeAvatarChangerCleared and "") or ((_G.ExeAvatarChangerState and _G.ExeAvatarChangerState.lastUsername) or ""),
}
end
function _STATIC_HUBSanitize(v, depth)
depth = depth or 0
local t = type(v)
if t == "number" then
if v ~= v or v == math.huge or v == -math.huge then return 0 end
return v
elseif t == "string" or t == "boolean" then
return v
elseif t == "table" and depth < 8 then
local out = {}
local n = #v
local isArr = n > 0
if isArr then
for k in pairs(v) do
if type(k) ~= "number" then isArr = false break end
end
end
if isArr then
for i = 1, n do out[i] = _STATIC_HUBSanitize(v[i], depth + 1) end
else
for k, val in pairs(v) do
local s = _STATIC_HUBSanitize(val, depth + 1)
if s ~= nil then out[tostring(k)] = s end
end
end
return out
end
return nil
end
function saveExeConfig()
if not canSaveConfig then return end
-- each file is saved on its own, so one bad value can never block every other setting
pcall(function()
local cfg = collectExeConfig()
local json = HttpService:JSONEncode(_STATIC_HUBSanitize(cfg))
if json and json ~= _G.__STATIC_HUBLastCfgJson then
_ace_writefile(CONFIG_FILE, json)
_G.__STATIC_HUBLastCfgJson = json
end
end)
pcall(function()
local json = HttpService:JSONEncode(_STATIC_HUBSanitize(collectExeKeybindConfig()))
if json and json ~= _G.__STATIC_HUBLastKbJson then
_ace_writefile(KEYBINDS_CONFIG_FILE, json)
_G.__STATIC_HUBLastKbJson = json
end
end)
end
-- autosave: anything that changed gets written every few seconds (starts after the hub finished loading)
task.spawn(function()
task.wait(20)
while true do
task.wait(5)
pcall(saveExeConfig)
end
end)
function loadExeConfig()
_G.ExeManualSaveConfig = saveExeConfig
if _G.ExeGuiScaleValue then
pcall(function()
if adaptGuiScaleValue ~= nil then adaptGuiScaleValue = tonumber(_G.ExeGuiScaleValue) or adaptGuiScaleValue end
if aceGuiScaleValue ~= nil then aceGuiScaleValue = tonumber(_G.ExeGuiScaleValue) or aceGuiScaleValue end
end)
end
if _G.ExeProgressBarScaleValue then
pcall(function()
if adaptProgressBarScaleValue ~= nil then adaptProgressBarScaleValue = tonumber(_G.ExeProgressBarScaleValue) or adaptProgressBarScaleValue end
if aceProgressBarScaleValue ~= nil then aceProgressBarScaleValue = tonumber(_G.ExeProgressBarScaleValue) or aceProgressBarScaleValue end
end)
end
if not canSaveConfig or not _ace_isfile(CONFIG_FILE) then return end
local ok, data = pcall(function()
return HttpService:JSONDecode(_ace_readfile(CONFIG_FILE))
end)
if not ok or type(data) ~= "table" then return end
savedConfig = data
local keybindData = data
pcall(function()
if _ace_isfile(KEYBINDS_CONFIG_FILE) then
local kb = HttpService:JSONDecode(_ace_readfile(KEYBINDS_CONFIG_FILE))
if type(kb) == "table" then keybindData = kb end
end
end)
savedMainPositionTable = type(data.mainPosition) == "table" and data.mainPosition or nil -- Restore user-saved main GUI position
savedMiniPositionTable = type(data.miniPosition) == "table" and data.miniPosition or nil
_G.ExeGuiLocked = data.guiLocked == true
if type(data.stealBarPosition) == "table" then _G.ExeStealBarPosition = data.stealBarPosition end
_G.ExeHiddenMobileButtons = {}
if type(data.hiddenMobileButtons) == "table" then
for k, v in pairs(data.hiddenMobileButtons) do
if v == true then _G.ExeHiddenMobileButtons[tostring(k)] = true end
end
end
if data.hideMobileButtons ~= nil then
_G.ExeHideMobileButtons = data.hideMobileButtons == true
elseif _G.ExeHideMobileButtons == nil then
_G.ExeHideMobileButtons = not ExeAutoMobile
end
_G.ExeMobileButtonScale = tonumber(data.mobileButtonScale) or (ExeAutoMobile and 0.90 or 1.00)
_G.ExeMobileButtonPositions = {}
if type(data.mobileButtonPositions) == "table" then
    for k, v in pairs(data.mobileButtonPositions) do
        if type(v) == "table" then
            _G.ExeMobileButtonPositions[tostring(k)] = v
        end
    end
end
_G.ExeMobileButtonImage = tostring(data.mobileButtonImage or "")
_G.ExeMobileButtonShape = tostring(data.mobileButtonShape or "ROUNDED"):upper()
if _G.ExeMobileButtonShape ~= "CIRCLE" and _G.ExeMobileButtonShape ~= "SQUARE" and _G.ExeMobileButtonShape ~= "ROUNDED" then
_G.ExeMobileButtonShape = "ROUNDED"
end
_G.ExeStealUIImage = tostring(data.stealUIImage or "")
if data.autoStealV3Radius ~= nil then
    _G.ExeStealRadii = _G.ExeStealRadii or {}
    _G.ExeStealRadii["Auto Steal V3"] = tonumber(data.autoStealV3Radius) or 63
    if selectedStealMode == "Auto Steal V3" then
        autoStealRadius = _G.ExeStealRadii["Auto Steal V3"]
        if autoStealRadiusBox then
            autoStealRadiusBox.Text = tostring(autoStealRadius)
        end
    end
end

_G.ExeDuelMode = (tostring(data.duelMode or "half") == "full") and "full" or "half"
_G.ExeAutoMoveSpeed = tonumber(data.autoMoveSpeed) or _G.ExeAutoMoveSpeed or 60
_G.ExeAutoMoveCarrySpeed = tonumber(data.autoMoveCarrySpeed) or _G.ExeAutoMoveCarrySpeed or 30
_G.ExeStretchValue = tonumber(data.stretchValue) or _G.ExeStretchValue or 0.7
_G.ExeStretchPreset = tostring(data.stretchPreset or _G.ExeStretchPreset or "Medium")
_G.ExeSavedAvatarChangerUserId = tonumber(data.avatarChangerUserId)
if _G.ExeSavedAvatarChangerUserId == 0 then _G.ExeSavedAvatarChangerUserId = nil; _G.ExeAvatarChangerCleared = true else _G.ExeAvatarChangerCleared = false end
_G.ExeSavedAvatarChangerUsername = tostring(data.avatarChangerUsername or "")
applySavedKeybinds(keybindData.keybinds)
if keybindData.tpDownKeybind ~= nil then
if tostring(keybindData.tpDownKeybind) == "None" then
tpDownKeybind = nil
else
tpDownKeybind = stringToKeyCode(keybindData.tpDownKeybind) or DEFAULT_TP_DOWN_KEYBIND
end
end
for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
local savedKeys = keybindData and keybindData.keybinds
if (not savedKeys or savedKeys[keyId] == nil) and speedKeybinds[keyId] == nil then
speedKeybinds[keyId] = defaultKey
end
end
NS = tonumber(data.NS) or NS
CS = tonumber(data.CS) or CS
LAGGER_SPEED = tonumber(data.LAGGER_SPEED) or LAGGER_SPEED
LAGGER_CARRY_SPEED = tonumber(data.LAGGER_CARRY_SPEED) or LAGGER_CARRY_SPEED
currentSpeedMode = data.currentSpeedMode or currentSpeedMode
carrySpeedActive = (currentSpeedMode == "Carry")
laggerModeEnabled = (currentSpeedMode == "Lagger")
laggerCarryActive = (currentSpeedMode == "Lagger Carry")
_G.ExeDropMode = "Jump Drop"
do
local m = data.dropAfterMode
_G.ExeDropAfterMode = "Off"
for _, v in ipairs(_G.ExeDropAfterModes or {}) do if v == m then _G.ExeDropAfterMode = m end end
end
_G.ExeTpBatSelected = (data.tpBatVersion == "V2") and "V2" or "V1"
if currentSpeedMode ~= "Normal" and currentSpeedMode ~= "Carry" and currentSpeedMode ~= "Lagger" and currentSpeedMode ~= "Lagger Carry" then currentSpeedMode = "Normal" end
carrySpeedActive = (currentSpeedMode == "Carry")
laggerModeEnabled = (currentSpeedMode == "Lagger")
laggerCarryActive = (currentSpeedMode == "Lagger Carry")
autoCarrySpeedEnabled = data.autoCarrySpeedEnabled == true
autoTPEnabled = data.autoTPEnabled == true
autoTPHeight = tonumber(data.autoTPHeight) or autoTPHeight
infJumpEnabled = data.infJumpEnabled == true
_G.ExeInfJumpMode = "Hold"
antiRagdollEnabled = data.antiRagdollEnabled == true
_G.ExeAntiRagdollMode = (data.antiRagdollMode == "V2") and "V2" or "V1"
_G.ExeAntiVoidEnabled = true
_G.ExeAntiResetEnabled = true
_G.ExeAntiE01Enabled = true
_G.ExeAntiDropEnabled = true
do
    local pbScale = tonumber(data.stealUiScaleValue) or tonumber(data.aceProgressBarScaleValue)
    if pbScale then
        aceProgressBarScaleValue = pbScale
        _G.ExeProgressBarScaleValue = pbScale
    end
    local guiScale = tonumber(data.guiScaleValue) or tonumber(data.aceGuiScaleValue)
    if guiScale then
        aceGuiScaleValue = guiScale
        _G.ExeGuiScaleValue = guiScale
    end
end
selectedAnimationPack = data.selectedAnimationPack or selectedAnimationPack
_G.ExeSelectedMoreAnimationBundle = data.selectedMoreAnimationBundle
unwalkEnabled = data.unwalkEnabled == true
if unwalkEnabled then
    selectedAnimationPack = "OFF"
    _G.ExeSelectedMoreAnimationBundle = nil
end
_G.ExeOutfitIndex = math.max(1, math.floor(tonumber(data.currentOutfitIndex) or 1))
selectedStealMode = data.selectedStealMode or selectedStealMode
if selectedStealMode == "Auto Steal V3" then selectedStealMode = "Auto Steal V3" end
if selectedStealMode ~= "Semi" then selectedStealMode = "Auto Steal V3" end
autoStealEnabled = data.autoStealEnabled == true
if type(data.aceStealRadii) == "table" then
_G.ExeStealRadii["Auto Steal V3"] = tonumber(
    data.aceStealRadii["Auto Steal V3"]
    or data.aceStealRadii.Normal
    or data.autoStealV3Radius
) or _G.ExeStealRadii["Auto Steal V3"] or 63
_G.ExeStealRadii.Semi = tonumber(data.aceStealRadii.Semi) or _G.ExeStealRadii.Semi or 9
end
autoStealRadius = tonumber(data.autoStealRadius) or autoStealRadius
_G.ExeStealRadii = _G.ExeStealRadii or {["Auto Steal V3"] = 63, Semi = 9}

if selectedStealMode == "Auto Steal V3" then
    autoStealRadius = tonumber(
        data.autoStealV3Radius
        or _G.ExeStealRadii["Auto Steal V3"]
        or autoStealRadius
        or 63
    ) or 63
    _G.ExeStealRadii["Auto Steal V3"] = autoStealRadius
else
    autoStealRadius = tonumber(_G.ExeStealRadii.Semi) or 9
end
selectedAimbotMode = data.selectedAimbotMode or selectedAimbotMode
if selectedAimbotMode ~= "Anti Bypass" then selectedAimbotMode = "Normal" end
AIMBOT_SPEED = tonumber(data.AIMBOT_SPEED) or AIMBOT_SPEED
LAGGER_AIMBOT_SPEED = tonumber(data.LAGGER_AIMBOT_SPEED) or LAGGER_AIMBOT_SPEED
BAT_V2_SPEED = math.clamp(tonumber(data.BAT_V2_SPEED) or tonumber(_G.ExeBatV2Speed) or BAT_V2_SPEED or 58, 1, 120)
_G.ExeBatV2Speed = BAT_V2_SPEED
_G.ExeAntiBypassAimbotSpeed = tonumber(data.ANTI_BYPASS_AIMBOT_SPEED) or _G.ExeAntiBypassAimbotSpeed or 65
if data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED == nil or tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) == 58 then
_G.ExeAntiBypassLaggerAimbotSpeed = 40
else
_G.ExeAntiBypassLaggerAimbotSpeed = tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) or 40
end
ANTI_DESYNC_AIMBOT_SPEED = tonumber(data.ANTI_DESYNC_AIMBOT_SPEED) or ANTI_DESYNC_AIMBOT_SPEED or 58
autoSwingEnabled = data.autoSwingEnabled == true
mirrorTPDownEnabled = data.mirrorTPDownEnabled == true
_G.ExeNormalAimbotOn = data.normalAimbotEnabled == true
_G.ExeAntiBypassAimbotOn = data.antiBypassAimbotEnabled == true
antiDesyncAutoSwingEnabled = data.antiDesyncAutoSwingEnabled == true
_G.ExeAntiDesyncAimbotOn = false
_G.ExeAntiTpBatEnabled = false
batCounterEnabled = data.batCounterEnabled == true
medCounterEnabled = data.medCounterEnabled == true
hardHitEnabled = data.hardHitEnabled == true
hardHitRadius = tonumber(data.hardHitRadius) or 10
_G.ExeHardHitRadius = hardHitRadius
if _G.ExeHardHitState then _G.ExeHardHitState.radius = hardHitRadius end
perfectHitEnabled = data.perfectHitEnabled == true
perfectHitRange = tonumber(data.perfectHitRange) or 175
if _G.ExePerfectHitState then _G.ExePerfectHitState.range = perfectHitRange end
antiKickEnabled = false
autoResetOnMedEnabled = false
espEnabled = data.espEnabled == true
showTracerEnabled = false
ragdollCountdownEnabled = true
fpsBoostEnabled = data.fpsBoostEnabled == true
antiLagVisualEnabled = data.antiLagVisualEnabled == true
nukeOptimiserEnabled = data.nukeOptimiserEnabled == true
fovEnabled = data.fovEnabled == true
fovValue = tonumber(data.fovValue) or fovValue
noCamCollisionEnabled = data.noCamCollisionEnabled == true
_G.ExeNoPlayerCollisionEnabled = true
skyTheme = (type(data.skyTheme) == "string" and data.skyTheme) or skyTheme
autoLeftEnabled = data.autoLeftEnabled == true
autoRightEnabled = data.autoRightEnabled == true
if autoLeftEnabled and autoRightEnabled then autoRightEnabled = false end
end
loadExeConfig()

-- Re-apply Anti Toggles after config load (fixes re-execute with toggles saved on)
task.defer(function()
    pcall(function()
        if _G.ExeAntiVoidEnabled == true and type(_G.ExeAntiVoidSet) == "function" then
            _G.ExeAntiVoidSet(true)
        end
    end)
    pcall(function()
        if _G.ExeAntiResetEnabled == true and type(_G.ExeSetAntiReset) == "function" then
            _G.ExeSetAntiReset(true)
        end
    end)
    pcall(function()
        if _G.ExeAntiE01Enabled == true and type(_G.ExeSetAntiE01) == "function" then
            _G.ExeSetAntiE01(true)
        end
    end)
    pcall(function()
        if _G.ExeAntiDropEnabled == true and type(_G.ExeSetAntiDrop) == "function" then
            _G.ExeSetAntiDrop(true)
        end
    end)
end)

local function syncAnimationPackIndex()
for i, name in ipairs(AnimationPackList) do
if name == selectedAnimationPack then
AnimationPackIndex = i
return
end
end
selectedAnimationPack = "OFF"
AnimationPackIndex = 1
end
local function applySavedAnimationPackToCharacter(char)
syncAnimationPackIndex()
if refreshAnimationPackRow then pcall(refreshAnimationPackRow) end
if not char then char = LP.Character end
if not char then return end
local animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 6)
if not animate then return end
task.wait(0.2)
OriginalAnims = {}
unwalkSavedAnimate = nil
if selectedAnimationPack and selectedAnimationPack ~= "OFF" then
    pcall(function() applyAnimationPack(selectedAnimationPack) end)
elseif _G.ExeSelectedMoreAnimationBundle and applyFullAnimationBundle then

    task.wait(0.15)
    pcall(function()
        applyFullAnimationBundle(_G.ExeSelectedMoreAnimationBundle)
    end)
elseif unwalkEnabled then
    pcall(function() enableUnwalk() end)
else
    pcall(function() resetAnimations() end)
end
end
syncAnimationPackIndex()
task.defer(function()
applySavedAnimationPackToCharacter(LP.Character)
end)
LP.CharacterAdded:Connect(function(char)
task.wait(0.65)
task.defer(function()
task.wait(0.2)
_G.ExeApplyCharacterVisuals(char)
end)
if _G.ExeAntiVoidEnabled then pcall(_G.ExeAntiVoidSaveSafe) end
applySavedAnimationPackToCharacter(char)

if _G.ExeSelectedMoreAnimationBundle then
    task.delay(1.25, function()
        if char == LP.Character and char.Parent and applyFullAnimationBundle then
            pcall(function()
                applyFullAnimationBundle(_G.ExeSelectedMoreAnimationBundle)
            end)
        end
    end)
end
end)
_G.ExeAutoResetOnMed = _G.ExeAutoResetOnMed or {}
_G.ExeAutoResetOnMed.conns = _G.ExeAutoResetOnMed.conns or {}
_G.ExeAutoResetOnMed.enabled = autoResetOnMedEnabled == true
_G.ExeAutoResetOnMed.medTriggered = false
_G.ExeAutoResetOnMed.lastFire = _G.ExeAutoResetOnMed.lastFire or 0
_G.ExeAutoResetOnMed.cooldown = 1.0
_G.ExeAutoResetOnMed.charAddedConn = _G.ExeAutoResetOnMed.charAddedConn

function _G.ExeAutoResetShouldFire(part)
local state = _G.ExeAutoResetOnMed
if not state or not state.enabled then return false end
if state.medTriggered then return false end
if tick() - (state.lastFire or 0) < (state.cooldown or 1.0) then return false end
if not part or not part.Parent then return false end
if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then
return false
end
return part.Anchored and (part.Transparency == 1 or part.Name == "HumanoidRootPart")
end
function _G.ExeAutoResetFireOnce(part)
if not _G.ExeAutoResetShouldFire(part) then return end
local state = _G.ExeAutoResetOnMed
state.medTriggered = true
state.lastFire = tick()
-- reset after 0.70 seconds
local hitChar = LP.Character
task.delay(0.70, function()
if not state.enabled then return end
pcall(function()
local c = LP.Character
if not c or c ~= hitChar then return end
for _, d in ipairs(c:GetDescendants()) do
if d:IsA("BasePart") and d.Anchored then pcall(function() d.Anchored = false end) end
end
local h = c:FindFirstChildOfClass("Humanoid")
if h then
pcall(function() h.Health = 0 end)
pcall(function() h:ChangeState(Enum.HumanoidStateType.Dead) end)
end
c:BreakJoints()
end)
end)
end
function _G.ExeAutoResetOnAnchorChanged(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
_G.ExeAutoResetFireOnce(part)
end)
end
function _G.ExeStopAutoResetOnMed()
local state = _G.ExeAutoResetOnMed
if not state then return end
for _, conn in ipairs(state.conns or {}) do
pcall(function()
conn:Disconnect()
end)
end
state.conns = {}
state.medTriggered = false
end
function _G.ExeStartAutoResetOnMed(char)
local state = _G.ExeAutoResetOnMed
if not state then return end
_G.ExeStopAutoResetOnMed()
state.medTriggered = false
char = char or LP.Character
if not char then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
table.insert(state.conns, _G.ExeAutoResetOnAnchorChanged(part))
_G.ExeAutoResetFireOnce(part)
end
end
table.insert(state.conns, char.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then
table.insert(state.conns, _G.ExeAutoResetOnAnchorChanged(part))
_G.ExeAutoResetFireOnce(part)
end
end))
table.insert(state.conns, char.AncestryChanged:Connect(function(_, parent)
if not parent then
state.medTriggered = false
end
end))
end
function _G.ExeEnableAutoResetOnMed()
autoResetOnMedEnabled = true
_G.ExeAutoResetOnMed.enabled = true
_G.ExeStartAutoResetOnMed(LP.Character)
end
function _G.ExeDisableAutoResetOnMed()
autoResetOnMedEnabled = false
_G.ExeAutoResetOnMed.enabled = false
_G.ExeStopAutoResetOnMed()
end
function _G.ExeSetAutoResetOnMed(state, noSave)
autoResetOnMedEnabled = state == true
if autoResetOnMedEnabled then
_G.ExeEnableAutoResetOnMed()
else
_G.ExeDisableAutoResetOnMed()
end
if setAutoResetOnMedVisual then
setAutoResetOnMedVisual(autoResetOnMedEnabled)
end
if not noSave and saveExeConfig then pcall(saveExeConfig) end
end
function enableAutoResetOnMed()
_G.ExeSetAutoResetOnMed(true)
end
function disableAutoResetOnMed()
_G.ExeSetAutoResetOnMed(false)
end
function toggleAutoResetOnMed(on)
_G.ExeSetAutoResetOnMed(on == true)
end
if not _G.ExeAutoResetOnMed.charAddedConn then
_G.ExeAutoResetOnMed.charAddedConn = LP.CharacterAdded:Connect(function(char)
if _G.ExeAutoResetOnMed and _G.ExeAutoResetOnMed.enabled then
task.wait(0.25)
_G.ExeStartAutoResetOnMed(char)
end
end)
end
_G.ExeCounterState = _G.ExeCounterState or {}
_G.ExeCounterState.batConn = nil
_G.ExeCounterState.batDebounce = false
_G.ExeCounterState.medConns = _G.ExeCounterState.medConns or {}
_G.ExeCounterState.medDebounce = false
_G.ExeCounterState.medLastUsed = _G.ExeCounterState.medLastUsed or 0
_G.ExeMedusaCooldown = 25
function _G.ExeFindMedusa()
local c = LP.Character
if not c then return nil end
for _, t in ipairs(c:GetChildren()) do
if t:IsA("Tool") then
local n = t.Name:lower()
if n:find("medusa") or n:find("head") or n:find("stone") then return t end
end
end
local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
if bp then
for _, t in ipairs(bp:GetChildren()) do
if t:IsA("Tool") then
local n = t.Name:lower()
if n:find("medusa") or n:find("head") or n:find("stone") then return t end
end
end
end
return nil
end
function _G.ExeUseMedusaCounter()
if not medCounterEnabled then return end
if _G.ExeCounterState.medDebounce then return end
if tick() - (_G.ExeCounterState.medLastUsed or 0) < _G.ExeMedusaCooldown then return end
local c = LP.Character
if not c then return end
_G.ExeCounterState.medDebounce = true
local med = _G.ExeFindMedusa()
if not med then
_G.ExeCounterState.medDebounce = false
return
end
if med.Parent ~= c then
local hum = c:FindFirstChildOfClass("Humanoid")
if hum then pcall(function() hum:EquipTool(med) end) end
task.wait(0.05)
end
if med.Parent == c then pcall(function() med:Activate() end) end
_G.ExeCounterState.medLastUsed = tick()
_G.ExeCounterState.medDebounce = false
end
function _G.ExeInstaMedusa()
local c = LP.Character
if not c then return false end
local med = _G.ExeFindMedusa()
if not med then return false end
if med.Parent ~= c then
local hum = c:FindFirstChildOfClass("Humanoid")
if hum then pcall(function() hum:EquipTool(med) end) end
local t0 = tick()
while med.Parent ~= c and tick() - t0 < 0.25 do task.wait() end
end
if med.Parent == c then pcall(function() med:Activate() end) end
return true
end
function _G.ExeOnMedusaAnchorChanged(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
if medCounterEnabled and part.Anchored and part.Transparency == 1 then
_G.ExeUseMedusaCounter()
end
end)
end
function _G.ExeStartMedCounter(char)
_G.ExeStopMedCounter()
char = char or LP.Character
if not char then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
table.insert(_G.ExeCounterState.medConns, _G.ExeOnMedusaAnchorChanged(part))
end
end
table.insert(_G.ExeCounterState.medConns, char.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then
table.insert(_G.ExeCounterState.medConns, _G.ExeOnMedusaAnchorChanged(part))
end
end))
end
function _G.ExeStopMedCounter()
for _, c in pairs(_G.ExeCounterState.medConns or {}) do
pcall(function() c:Disconnect() end)
end
_G.ExeCounterState.medConns = {}
_G.ExeCounterState.medDebounce = false
end
_G.ExeBatCounterSlapList = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
function _G.ExeFindBatForCounter()
local c = LP.Character
if not c then return nil end
local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
for _, name in ipairs(_G.ExeBatCounterSlapList) do
local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
if t then return t end
end
for _, ch in ipairs(c:GetChildren()) do
if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
end
if bp then
for _, ch in ipairs(bp:GetChildren()) do
if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
end
end
return nil
end
-- ===== BAT COUNTER (S2 HUB version) =====
_G.ExeBatCounterLockActive = false
function _G.ExeFaceAttackerHold(char, durationSec)
if _G.ExeBatCounterLockActive then return end
local root = char:FindFirstChild("HumanoidRootPart")
local hum2 = char:FindFirstChildOfClass("Humanoid")
if not root or not hum2 then return end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
if tRoot and tHum and tHum.Health > 0 then
local dist = (tRoot.Position - root.Position).Magnitude
if dist < minDist then minDist = dist; closest = tRoot end
end
end
end
if not closest then return end
root.CFrame = CFrame.new(root.Position, Vector3.new(closest.Position.X, root.Position.Y, closest.Position.Z))
_G.ExeBatCounterLockActive = true
hum2.AutoRotate = false
local deadline = tick() + durationSec
local conn
conn = RunService.RenderStepped:Connect(function()
pcall(function()
if tick() >= deadline or not closest.Parent then
conn:Disconnect(); _G.ExeBatCounterLockActive = false
local c2 = LP.Character
local hum3 = c2 and c2:FindFirstChildOfClass("Humanoid")
local root3 = c2 and c2:FindFirstChild("HumanoidRootPart")
if hum3 then hum3.AutoRotate = true end
if root3 then root3.AssemblyAngularVelocity = Vector3.zero end
return
end
local c2 = LP.Character
if not c2 then return end
local root2 = c2:FindFirstChild("HumanoidRootPart")
if not root2 then return end
local toTarget = closest.Position - root2.Position
if toTarget.Magnitude > 0.1 then
local goalCF = CFrame.lookAt(root2.Position, closest.Position)
local diffCF = root2.CFrame:Inverse() * goalCF
local _, ry, _ = diffCF:ToEulerAnglesXYZ()
ry = math.clamp(ry, -2.5, 2.5)
root2.AssemblyAngularVelocity = root2.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
end
end)
end)
end
function _G.ExeSwingBatForCounter(bat, char)
if not bat or not char then return end
local hum2 = char:FindFirstChildOfClass("Humanoid")
_G.ExeFaceAttackerHold(char, 1)
if bat.Parent ~= char then
if hum2 then pcall(function() hum2:EquipTool(bat) end) end
task.wait(0.02)
end
local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
if remote and remote:IsA("RemoteEvent") then
pcall(function() remote:FireServer() end)
task.wait(0.15)
pcall(function() remote:FireServer() end)
else
pcall(function() bat:Activate() end)
task.wait(0.15)
pcall(function() bat:Activate() end)
end
end
function _G.ExeCounterIsRagdoll(hum)
if not hum then return false end
local st = hum:GetState()
return st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
or hum.PlatformStand == true
end
function _G.ExeStartBatCounter()
if _G.ExeCounterState.batConn then
pcall(function() _G.ExeCounterState.batConn:Disconnect() end)
_G.ExeCounterState.batConn = nil
end
_G.ExeCounterState.batDebounce = false
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hum then return end
_G.ExeCounterState.batConn = hum.StateChanged:Connect(function(_, newState)
if not batCounterEnabled or _G.ExeCounterState.batDebounce then return end
local isRagdolled = newState == Enum.HumanoidStateType.Physics
or newState == Enum.HumanoidStateType.Ragdoll
or newState == Enum.HumanoidStateType.FallingDown
if not isRagdolled then return end
_G.ExeCounterState.batDebounce = true
task.spawn(function()
local c = LP.Character
local bat = _G.ExeFindBatForCounter()
if bat and c then _G.ExeSwingBatForCounter(bat, c) end
task.wait(0.2)
_G.ExeCounterState.batDebounce = false
end)
end)
end
function _G.ExeStopBatCounter()
if _G.ExeCounterState.batConn then
pcall(function() _G.ExeCounterState.batConn:Disconnect() end)
_G.ExeCounterState.batConn = nil
end
_G.ExeCounterState.batDebounce = false
end
startBatCounter = _G.ExeStartBatCounter
stopBatCounter = _G.ExeStopBatCounter
setupMedusaCounter = _G.ExeStartMedCounter
stopMedusaCounter = _G.ExeStopMedCounter

_G.ExeHardHitState = _G.ExeHardHitState or {
ring = nil,
conn = nil,
enabled = false,
radius = 10,
}
local HH = _G.ExeHardHitState
function _G.ExeHideHardHitRing()
if HH.ring then
pcall(function() HH.ring:Destroy() end)
HH.ring = nil
end
end
function _G.ExeShowHardHitRing()
local char = LP.Character
if not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
if HH.ring and HH.ring.Parent then return end
local cyl = Instance.new("CylinderHandleAdornment")
cyl.Name = "ExeHardHitRing"
cyl.Adornee = hrp
cyl.Color3 = Color3.fromRGB(255, 255, 255)
cyl.AlwaysOnTop = true
cyl.ZIndex = 5
cyl.Transparency = 0.25
local r = tonumber(HH.radius) or 10
cyl.Radius = r
cyl.InnerRadius = math.max(0.1, r - 0.35)
cyl.Height = 0.15
cyl.CFrame = CFrame.new(0, -3, 0)
cyl.Parent = hrp
HH.ring = cyl
end
function _G.ExeStartHardHit()
HH.enabled = true
hardHitEnabled = true
_G.ExeHardHitEnabled = true
if HH.conn then return end
HH.conn = RunService.Heartbeat:Connect(function()
if not HH.enabled then return end
local char = LP.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return end
if not HH.ring or not HH.ring.Parent then
_G.ExeShowHardHitRing()
end
if HH.ring then
local r = tonumber(HH.radius) or 10
HH.ring.Radius = r
HH.ring.InnerRadius = math.max(0.1, r - 0.35)
if HH.ring.Adornee ~= root then
HH.ring.Adornee = root
HH.ring.Parent = root
end
end
end)
_G.ExeShowHardHitRing()
end
function _G.ExeStopHardHit()
HH.enabled = false
hardHitEnabled = false
_G.ExeHardHitEnabled = false
if HH.conn then
pcall(function() HH.conn:Disconnect() end)
HH.conn = nil
end
_G.ExeHideHardHitRing()
end
function _G.ExeSetHardHitRadius(v)
local n = tonumber(v)
if not n then return end
HH.radius = math.clamp(n, 1, 100)
hardHitRadius = HH.radius
_G.ExeHardHitRadius = HH.radius
if HH.ring then
HH.ring.Radius = HH.radius
HH.ring.InnerRadius = math.max(0.1, HH.radius - 0.35)
end
if saveExeConfig then pcall(saveExeConfig) end
end

_G.ExePerfectHitState = _G.ExePerfectHitState or {
enabled = false,
conn = nil,
cd = false,
range = 175,
}
local PH = _G.ExePerfectHitState
function _G.ExePerfectHitTryHit()
if not PH.enabled then return end
if PH.cd then return end
PH.cd = true
local char = LP.Character
if char then
local bat = _G.ExeFindBatForCounter and _G.ExeFindBatForCounter() or nil
if bat then
_G.ExeSwingBatForCounter(bat, char)
end
end
task.delay(0.045, function() PH.cd = false end)
end
function _G.ExePerfectHitGetTarget()
local char = LP.Character
if not char then return nil end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local nearest = nil
local shortest = math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tr = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tr and hum and hum.Health > 0 then
local d = (tr.Position - root.Position).Magnitude
if d <= (tonumber(PH.range) or 175) and d < shortest then
shortest = d
nearest = tr
end
end
end
end
return nearest
end
function _G.ExeStartPerfectHit()
PH.enabled = true
perfectHitEnabled = true
_G.ExePerfectHitEnabled = true
if PH.conn then return end
PH.conn = RunService.Heartbeat:Connect(function()
if not PH.enabled then return end
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return end
if _G.ExeCounterIsRagdoll then
if _G.ExeCounterIsRagdoll(hum) then return end
end
local target = _G.ExePerfectHitGetTarget()
if target then
_G.ExePerfectHitTryHit()
end
end)
end
function _G.ExeStopPerfectHit()
PH.enabled = false
perfectHitEnabled = false
_G.ExePerfectHitEnabled = false
if PH.conn then
pcall(function() PH.conn:Disconnect() end)
PH.conn = nil
end
PH.cd = false
end
function _G.ExeSetPerfectHitRange(v)
local n = tonumber(v)
if not n then return end
PH.range = math.clamp(n, 10, 500)
perfectHitRange = PH.range
if saveExeConfig then pcall(saveExeConfig) end
end

_G.ExeNoPlayerCollisionState = _G.ExeNoPlayerCollisionState or {connections = {}}
function _G.ExeSetOtherPlayerCollision(state)
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") then
pcall(function() part.CanCollide = state end)
end
end
end
end
end
function enableNoPlayerCollision()
if _G.ExeNoPlayerCollisionState.running then return end
_G.ExeNoPlayerCollisionEnabled = true
_G.ExeNoPlayerCollisionState.running = true
for _, conn in ipairs(_G.ExeNoPlayerCollisionState.connections or {}) do
pcall(function() conn:Disconnect() end)
end
_G.ExeNoPlayerCollisionState.connections = {}
_G.ExeSetOtherPlayerCollision(false)
table.insert(_G.ExeNoPlayerCollisionState.connections, LP.CharacterAdded:Connect(function()
task.wait(0.5)
if _G.ExeNoPlayerCollisionEnabled then _G.ExeSetOtherPlayerCollision(false) end
end))
table.insert(_G.ExeNoPlayerCollisionState.connections, Players.PlayerAdded:Connect(function(plr)
local c = plr.CharacterAdded:Connect(function()
task.wait(0.5)
if _G.ExeNoPlayerCollisionEnabled then _G.ExeSetOtherPlayerCollision(false) end
end)
table.insert(_G.ExeNoPlayerCollisionState.connections, c)
end))
local collisionScanElapsed = 0
table.insert(_G.ExeNoPlayerCollisionState.connections, RunService.Heartbeat:Connect(function(dt)
if not _G.ExeNoPlayerCollisionEnabled then return end
collisionScanElapsed = collisionScanElapsed + (dt or 0)
if collisionScanElapsed < 0.25 then return end
collisionScanElapsed = 0
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide == true then
pcall(function() part.CanCollide = false end)
end
end
end
end
end))
end
function disableNoPlayerCollision()
if not _G.ExeNoPlayerCollisionState.running then
_G.ExeNoPlayerCollisionEnabled = false
return
end
_G.ExeNoPlayerCollisionEnabled = false
_G.ExeNoPlayerCollisionState.running = false
for _, conn in ipairs(_G.ExeNoPlayerCollisionState.connections or {}) do
pcall(function() conn:Disconnect() end)
end
_G.ExeNoPlayerCollisionState.connections = {}
_G.ExeSetOtherPlayerCollision(true)
end
function _G.ExeSafeModeGetCountdownLabel()
local ok, label = pcall(function()
return LP.PlayerGui
and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
end)
return (ok and label) or nil
end
function _G.ExeSafeModeCountdownNumber(text)
local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
if t == "GO" or t == "START" or t == "READY" then return true end
local n = tonumber(t)
return n ~= nil and n >= 0 and n <= 10
end
function _G.ExeSafeModeInDuelCountdown()
local label = _G.ExeSafeModeGetCountdownLabel()
return label and _G.ExeSafeModeCountdownNumber(label.Text) or false
end
_G.ExeSafeModeBlockedTools = {
bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}
function _G.ExeSafeModeIsCarryableTool(tool)
if not tool or not tool:IsA("Tool") then return false end
local name = tool.Name:lower()
for word in pairs(_G.ExeSafeModeBlockedTools) do
if name:find(word, 1, true) then return false end
end
return true
end
function _G.ExeSafeModeHoldingBrainrot()
local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
if ok and val == true then return true end
local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
if ok2 and val2 == true then return true end
local char = LP.Character
if not char then return false end
local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
if ok3 and val3 == true then return true end
if _G.AutoCarrySpeed and type(_G.AutoCarrySpeed.IsCarryingBrainrot) == "function" then
local okCarry, carrying = pcall(function() return _G.AutoCarrySpeed.IsCarryingBrainrot(char) end)
if okCarry and carrying then return true end
end
for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
local v = char:FindFirstChild(name, true)
if v then
if v:IsA("BoolValue") and v.Value then return true end
if v:IsA("ObjectValue") and v.Value then return true end
if v:IsA("StringValue") and v.Value ~= "" then return true end
end
end
for _, child in ipairs(char:GetChildren()) do
if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
local n = child.Name:lower()
if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
return true
end
end
end
return false
end
function _G.ExeSafeModeIsLocked()
antiKickEnabled = false
do return false end
return _G.ExeSafeModeInDuelCountdown() or _G.ExeSafeModeHoldingBrainrot()
end
function _G.ExeSafeModeForceStop(reason)
local stopped = false
if _G.ExeNormalAimbotOn and _G.ExeStopNormalAimbot then _G.ExeStopNormalAimbot(); stopped = true end
if _G.ExeAntiBypassAimbotOn and _G.ExeStopAntiBypassAimbot then _G.ExeStopAntiBypassAimbot(false); stopped = true end
if _G.ExeAntiDesyncAimbotOn and _G.ExeStopAntiDesyncAimbot then _G.ExeStopAntiDesyncAimbot(); stopped = true end
if autoLeftEnabled then
autoLeftEnabled = false
if _G.ExeSetAutoLeftVisual then _G.ExeSetAutoLeftVisual(false) end
if _G.ExeStopAutoLeft then _G.ExeStopAutoLeft() end
stopped = true
end
if autoRightEnabled then
autoRightEnabled = false
if _G.ExeSetAutoRightVisual then _G.ExeSetAutoRightVisual(false) end
if _G.ExeStopAutoRight then _G.ExeStopAutoRight() end
stopped = true
end
if stopped and showActionNotification then pcall(function() showActionNotification(reason or "SAFE MODE LOCK") end) end
end
function _G.ExeSafeModeTryStart()
if _G.ExeSafeModeIsLocked and _G.ExeSafeModeIsLocked() then
_G.ExeSafeModeForceStop("SAFE MODE LOCK")
return false
end
return true
end
_G.ExeSafeModeMonitorStarted = _G.ExeSafeModeMonitorStarted or false
if not _G.ExeSafeModeMonitorStarted then
_G.ExeSafeModeMonitorStarted = true
RunService.Heartbeat:Connect(function()
if antiKickEnabled and _G.ExeSafeModeIsLocked and _G.ExeSafeModeIsLocked() then
_G.ExeSafeModeForceStop("SAFE MODE LOCK")
end
end)
end
LP.CharacterAdded:Connect(function(char)
task.wait(0.5)
if medCounterEnabled then _G.ExeStartMedCounter(char) end
if batCounterEnabled then _G.ExeStartBatCounter() end
if hardHitEnabled then _G.ExeStartHardHit() end
if perfectHitEnabled then _G.ExeStartPerfectHit() end
end)
_G.ExeNormalAimbot = _G.ExeNormalAimbot or {conn = nil, target = nil, swingCooldown = false}
function _G.ExeFindAimbotBat()
local char = LP.Character
if not char then return nil end
for _, tool in ipairs(char:GetChildren()) do
if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
return tool
end
end
local bp = LP:FindFirstChild("Backpack")
if bp then
for _, tool in ipairs(bp:GetChildren()) do
if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
return tool
end
end
end
return nil
end
function _G.ExeGetClosestAimbotTarget()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tRoot and hum and hum.Health > 0 then
local dist = (tRoot.Position - root.Position).Magnitude
if dist < minDist then
minDist = dist
closest = tRoot
end
end
end
end
return closest
end
function _G.ExeGetNormalAimbotSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return tonumber(LAGGER_AIMBOT_SPEED) or 40
end
return tonumber(AIMBOT_SPEED) or 58
end
function _G.ExeGetAntiBypassAimbotSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return tonumber(_G.ExeAntiBypassLaggerAimbotSpeed) or 40
end
return tonumber(_G.ExeAntiBypassAimbotSpeed) or 58
end
function _G.ExeGetSelectedAimbotSpeedValues()
if selectedAimbotMode == "Anti Bypass" then
return tonumber(_G.ExeAntiBypassAimbotSpeed) or 58, tonumber(_G.ExeAntiBypassLaggerAimbotSpeed) or 40
end
return tonumber(AIMBOT_SPEED) or 58, tonumber(LAGGER_AIMBOT_SPEED) or 40
end
function _G.ExeSetSelectedAimbotSpeedValues(normalValue, laggerValue)
if selectedAimbotMode == "Anti Bypass" then
if normalValue then _G.ExeAntiBypassAimbotSpeed = normalValue end
if laggerValue then _G.ExeAntiBypassLaggerAimbotSpeed = laggerValue end
else
if normalValue then AIMBOT_SPEED = normalValue end
if laggerValue then LAGGER_AIMBOT_SPEED = laggerValue end
end
end
function _G.ExeRefreshAimbotSpeedBoxes()
local n, l = _G.ExeGetSelectedAimbotSpeedValues()
if _G.ExeAimbotSpeedBox then _G.ExeAimbotSpeedBox.Text = tostring(n) end
if _G.ExeLaggerAimbotSpeedBox then _G.ExeLaggerAimbotSpeedBox.Text = tostring(l) end
end

_G.ExeNormalAimbot = _G.ExeNormalAimbot or {
    conn = nil,
    target = nil,
    lastScan = 0,
    attachment = nil,
    linearVelocity = nil,
}

local function _ExeAimbotEnsureLinearVelocity(root)
    local S = _G.ExeNormalAimbot

    if S.linearVelocity
        and S.linearVelocity.Parent
        and S.attachment
        and S.attachment.Parent == root then
        S.linearVelocity.Enabled = true
        return S.linearVelocity
    end

    if S.linearVelocity then
        pcall(function() S.linearVelocity:Destroy() end)
    end
    if S.attachment then
        pcall(function() S.attachment:Destroy() end)
    end

    local att = Instance.new("Attachment")
    att.Name = "ExeAimbotAttachment"
    att.Parent = root

    local lv = Instance.new("LinearVelocity")
    lv.Name = "ExeAimbotLinearVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.ForceLimitMode = Enum.ForceLimitMode.Magnitude
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Enabled = true
    lv.Parent = att

    S.attachment = att
    S.linearVelocity = lv
    return lv
end

local function _ExeAimbotReleaseLinearVelocity()
    local S = _G.ExeNormalAimbot
    if S.linearVelocity and S.linearVelocity.Parent then
        S.linearVelocity.VectorVelocity = Vector3.zero
        S.linearVelocity.Enabled = false
    end
end

function _G.ExeStartNormalAimbot()
    if _G.ExeSafeModeTryStart and not _G.ExeSafeModeTryStart() then
        return false
    end
    if _G.ExeStopTpBat then pcall(_G.ExeStopTpBat) end
    if _G.ExeAntiBatBypassOn and _G.ExeStopAntiBatBypass then pcall(_G.ExeStopAntiBatBypass) end
if _G.ExeAutoPlayOn and _G.ExeStopAutoPlay then pcall(_G.ExeStopAutoPlay) end

    if _G.ExeStopAntiBypassAimbot then
        _G.ExeStopAntiBypassAimbot(false)
    end
    _G.ExeAntiBypassAimbotOn = false

    if _G.ExeNormalAimbot.conn then
        pcall(function() _G.ExeNormalAimbot.conn:Disconnect() end)
        _G.ExeNormalAimbot.conn = nil
    end

    _G.ExeNormalAimbotAutoTPWasEnabled = false
    if autoTPEnabled then
        _G.ExeNormalAimbotAutoTPWasEnabled = true
        stopAutoTP()
        if setAutoTPVisual then setAutoTPVisual(false) end
    end

    _G.ExeNormalAimbotOn = true
    _G.ExeNormalAimbot.target = nil

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    -- Envy aimbot logic: predict target position, chase with AssemblyLinearVelocity Lerp,
    -- rotate via AssemblyAngularVelocity using CFrame.lookAt delta
    _G.ExeNormalAimbot.conn = RunService.RenderStepped:Connect(function()
        if not _G.ExeNormalAimbotOn or selectedAimbotMode ~= "Normal" then
            return
        end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root or hum.Health <= 0 then
            return
        end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = _G.ExeFindAimbotBat()
            if bat then
                pcall(function() hum:EquipTool(bat) end)
            end
        end

        local target = _G.ExeGetClosestAimbotTarget()
        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end
        _G.ExeNormalAimbot.target = target

        local targetHum = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
        if not targetHum or targetHum.Health <= 0 then
            _G.ExeNormalAimbot.target = nil
            return
        end

        hum.AutoRotate = false

        local targetVel = target.AssemblyLinearVelocity
        local myPos     = root.Position
        local targetPos = target.Position

        -- Envy prediction
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3

        local direction  = predictPos - myPos
        local flatDir    = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.zero
        end

        local chaseSpeed = _G.ExeGetNormalAimbotSpeed()

        -- Envy height control
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

        -- Envy rotation via CFrame.lookAt + AssemblyAngularVelocity
        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local curCF  = root.CFrame
            local diffCF = curCF:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            local tiltSpeed = 42
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
            )
        else
            root.AssemblyAngularVelocity = Vector3.zero
        end

        if autoSwingEnabled then
            local bat = char:FindFirstChildOfClass("Tool") or _G.ExeFindAimbotBat()
            if bat and bat:IsA("Tool") then
                if bat.Parent ~= char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(bat) end) end
                end
                if bat.Parent == char then
                    pcall(function() bat:Activate() end)
                end
            end
        end
    end)

    if _G.ExeRefreshAimbotVisual then
        _G.ExeRefreshAimbotVisual()
    end

    return true
end

function _G.ExeStopNormalAimbot()
    _G.ExeNormalAimbotOn = false

    if _G.ExeNormalAimbot and _G.ExeNormalAimbot.conn then
        pcall(function() _G.ExeNormalAimbot.conn:Disconnect() end)
        _G.ExeNormalAimbot.conn = nil
    end

    if _G.ExeNormalAimbot then
        _G.ExeNormalAimbot.target = nil
    end

    _ExeAimbotReleaseLinearVelocity()

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if root then
        root.AssemblyLinearVelocity  = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    if hum then
        hum.AutoRotate = true
    end

    if _G.ExeNormalAimbotAutoTPWasEnabled then
        _G.ExeNormalAimbotAutoTPWasEnabled = false
        autoTPEnabled = true
        if setAutoTPVisual then setAutoTPVisual(true) end
        startAutoTP()
    end

    if _G.ExeRefreshAimbotVisual then
        _G.ExeRefreshAimbotVisual()
    end
end
_G.ExeAntiBypassAimbot = _G.ExeAntiBypassAimbot or {conn = nil, swingCooldown = false, prevAutoRotate = nil}
_G.ExeAntiBypassSettings = {
SPEED = 63,
VERT_SPEED = 52,
DISTANCE = -2.8,
HEIGHT = 4.75,
V_OFFSET = 1,
TURN_SPEED = 285,
MAX_TURN_RATE = 28,
AUTO_SWING = true,
}
_G.ExeAntiBypassSlapList = _G.ExeAntiBypassSlapList or {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function _G.ExeAntiBypassFindBat()
local char = LP.Character
if not char then return nil end
for _, tool in ipairs(char:GetChildren()) do
if tool:IsA("Tool") then
local name = tool.Name:lower()
if name:find("bat") or name:find("slap") then return tool end
end
end
local bp = LP:FindFirstChildOfClass("Backpack")
if bp then
for _, tool in ipairs(bp:GetChildren()) do
if tool:IsA("Tool") then
local name = tool.Name:lower()
if name:find("bat") or name:find("slap") then return tool end
end
end
end
return nil
end
function _G.ExeAntiBypassEnsureBat()
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not char or not hum then return nil end
local equipped = char:FindFirstChildOfClass("Tool")
if equipped then return equipped end
local bat = _G.ExeAntiBypassFindBat()
if bat then pcall(function() hum:EquipTool(bat) end) end
return bat
end
function _G.ExeAntiBypassTrySwing()
if _G.ExeAntiBypassAimbot.swingCooldown then return end
_G.ExeAntiBypassAimbot.swingCooldown = true
pcall(function()
local bat = _G.ExeAntiBypassEnsureBat()
if bat and bat:IsA("Tool") and bat.Parent == LP.Character then bat:Activate() end
end)
task.delay(0.3, function()
if _G.ExeAntiBypassAimbot then _G.ExeAntiBypassAimbot.swingCooldown = false end
end)
end
function _G.ExeAntiBypassGetClosest()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil, math.huge end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tRoot and hum and hum.Health > 0 then
local dist = (tRoot.Position - root.Position).Magnitude
if dist < minDist then minDist, closest = dist, tRoot end
end
end
end
return closest, minDist
end
function _G.ExeStartAntiBypassAimbot()
if _G.ExeSafeModeTryStart and not _G.ExeSafeModeTryStart() then return false end
if _G.ExeStopTpBat then pcall(_G.ExeStopTpBat) end
if _G.ExeAntiBatBypassOn and _G.ExeStopAntiBatBypass then pcall(_G.ExeStopAntiBatBypass) end
if _G.ExeAutoPlayOn and _G.ExeStopAutoPlay then pcall(_G.ExeStopAutoPlay) end
if _G.ExeStopAutoTPForAction then _G.ExeStopAutoTPForAction() end
if _G.ExeStopNormalAimbot then _G.ExeStopNormalAimbot() end
_G.ExeAntiBypassAimbotOn = true
selectedAimbotMode = "Anti Bypass"
if _G.ExeAntiBypassAimbot.conn then _G.ExeAntiBypassAimbot.conn:Disconnect() end
local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum0 then
_G.ExeAntiBypassAimbot.prevAutoRotate = hum0.AutoRotate
hum0.AutoRotate = false
end
_G.ExeAntiBypassAimbot.conn = RunService.Heartbeat:Connect(function()
if not _G.ExeAntiBypassAimbotOn or selectedAimbotMode ~= "Anti Bypass" then return end
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root or hum.Health <= 0 then return end
local S = _G.ExeAntiBypassSettings
hum.AutoRotate = false
_G.ExeAntiBypassEnsureBat()
local target, targetDist = _G.ExeAntiBypassGetClosest()
if not target then
root.AssemblyAngularVelocity = Vector3.zero
return
end
local aimTargetPos = target.Position + Vector3.new(0, S.V_OFFSET, 0)
local look = aimTargetPos - root.Position
local flatLook = Vector3.new(look.X, 0, look.Z)
if flatLook.Magnitude > 0.01 then
local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
local yawRate = math.clamp(yawDelta * 8, -S.MAX_TURN_RATE, S.MAX_TURN_RATE)
root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0)
else
root.AssemblyAngularVelocity = Vector3.zero
end
if look.Magnitude > 0.01 then
local dir = look.Unit
local standPos = aimTargetPos - (dir * S.DISTANCE) + Vector3.new(0, S.HEIGHT, 0)
local moveDir = standPos - root.Position
local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
local hVel = hDir.Magnitude > 0.1 and hDir.Unit * (tonumber(_G.ExeGetAntiBypassAimbotSpeed and _G.ExeGetAntiBypassAimbotSpeed()) or S.SPEED) or Vector3.zero
local vVel = Vector3.new(0, math.clamp(moveDir.Y * 3, -S.VERT_SPEED, S.VERT_SPEED), 0)
root.AssemblyLinearVelocity = hVel + vVel
if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
end
if S.AUTO_SWING and autoSwingEnabled and targetDist < 5 then _G.ExeAntiBypassTrySwing() end
end)
if _G.ExeRefreshAimbotVisual then _G.ExeRefreshAimbotVisual() end
return true
end
function _G.ExeStopAntiBypassAimbot(keepVisual)
_G.ExeAntiBypassAimbotOn = false
if _G.ExeAntiBypassAimbot and _G.ExeAntiBypassAimbot.conn then
_G.ExeAntiBypassAimbot.conn:Disconnect()
_G.ExeAntiBypassAimbot.conn = nil
end
if _G.ExeAntiBypassAimbot then _G.ExeAntiBypassAimbot.swingCooldown = false end
local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if root then
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end
if hum then
hum.AutoRotate = (_G.ExeAntiBypassAimbot.prevAutoRotate == nil) and true or _G.ExeAntiBypassAimbot.prevAutoRotate
end
_G.ExeAntiBypassAimbot.prevAutoRotate = nil
if keepVisual ~= false and _G.ExeRefreshAimbotVisual then _G.ExeRefreshAimbotVisual() end
end
function _G.ExeToggleSelectedAimbot()
if selectedAimbotMode == "Anti Bypass" then
if _G.ExeAntiBypassAimbotOn then
if _G.ExeStopAntiBypassAimbot then _G.ExeStopAntiBypassAimbot() else _G.ExeAntiBypassAimbotOn = false end
else
if _G.ExeStopNormalAimbot then _G.ExeStopNormalAimbot() end
if _G.ExeStartAntiBypassAimbot then _G.ExeStartAntiBypassAimbot() else _G.ExeAntiBypassAimbotOn = true end
end
else
if _G.ExeNormalAimbotOn then
_G.ExeStopNormalAimbot()
else
if _G.ExeStopAntiBypassAimbot then _G.ExeStopAntiBypassAimbot(false) else _G.ExeAntiBypassAimbotOn = false end
_G.ExeStartNormalAimbot()
end
end
if _G.ExeRefreshAimbotVisual then _G.ExeRefreshAimbotVisual() end
if saveExeConfig then pcall(saveExeConfig) end
end
function _G.ExeRefreshAimbotVisual()
if _G.ExeAimbotSetVisual then
if selectedAimbotMode == "Anti Bypass" then
_G.ExeAimbotSetVisual(_G.ExeAntiBypassAimbotOn == true)
else
_G.ExeAimbotSetVisual(_G.ExeNormalAimbotOn == true)
end
end
end
_G.ExeNormalAimbotStart = _G.ExeStartNormalAimbot
_G.ExeNormalAimbotStop = _G.ExeStopNormalAimbot
_G.ExeAntiBypassStart = _G.ExeStartAntiBypassAimbot
_G.ExeAntiBypassStop = _G.ExeStopAntiBypassAimbot

-- Sound Hub's BAT V2 anti-bypass controller.
do
    local V2 = _G.ExeBatV2State
    V2.conn = nil
    V2.prevAutoRotate = nil
    V2.character = nil
    V2.wasAutoTP = false
    V2.wasAutoLeft = false
    V2.wasAutoRight = false
    V2.swingCooldown = false

    local function stopOtherAimModes()
        if _G.ExeNormalAimbotOn and _G.ExeStopNormalAimbot then pcall(_G.ExeStopNormalAimbot) end
        if _G.ExeAntiBypassAimbotOn and _G.ExeStopAntiBypassAimbot then pcall(function() _G.ExeStopAntiBypassAimbot(false) end) end
        if _G.ExeAntiDesyncAimbotOn and _G.ExeStopAntiDesyncAimbot then pcall(_G.ExeStopAntiDesyncAimbot) end
        if _G.ExeStopTpBat then pcall(_G.ExeStopTpBat) end
        if _G.ExeAntiBatBypassOn and _G.ExeStopAntiBatBypass then pcall(_G.ExeStopAntiBatBypass) end
if _G.ExeAutoPlayOn and _G.ExeStopAutoPlay then pcall(_G.ExeStopAutoPlay) end
    end

    local function pauseConflictingActions(state)
        state.wasAutoTP = autoTPEnabled == true
        if state.wasAutoTP then pcall(stopAutoTP) end
        state.wasAutoLeft = autoLeftEnabled == true
        if state.wasAutoLeft and _G.ExeSetAutoLeft then pcall(function() _G.ExeSetAutoLeft(false, true) end) end
        state.wasAutoRight = autoRightEnabled == true
        if state.wasAutoRight and _G.ExeSetAutoRight then pcall(function() _G.ExeSetAutoRight(false, true) end) end
    end
    local function restoreConflictingActions(state)
        if state.wasAutoTP then state.wasAutoTP = false; pcall(startAutoTP) end
        if state.wasAutoLeft then state.wasAutoLeft = false; if _G.ExeSetAutoLeft then pcall(function() _G.ExeSetAutoLeft(true, true) end) end end
        if state.wasAutoRight then state.wasAutoRight = false; if _G.ExeSetAutoRight then pcall(function() _G.ExeSetAutoRight(true, true) end) end end
    end

    function _G.ExeStopBatV2()
        local wasOn = _G.ExeBatV2On == true
        if not wasOn and not V2.conn then return end
        _G.ExeBatV2On = false
        if V2.conn then pcall(function() V2.conn:Disconnect() end); V2.conn = nil end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root then
            pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
        if hum then
            hum.AutoRotate = (V2.prevAutoRotate == nil) and true or V2.prevAutoRotate
            hum.PlatformStand = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
        V2.prevAutoRotate = nil
        V2.character = nil
        V2.swingCooldown = false
        if wasOn then restoreConflictingActions(V2) end
        if saveExeConfig then pcall(saveExeConfig) end
    end

    function _G.ExeStartBatV2()
        if _G.ExeSafeModeTryStart and not _G.ExeSafeModeTryStart() then return false end
        if _G.ExeBatV2On then return true end
        stopOtherAimModes()
        pauseConflictingActions(V2)
        if V2.conn then pcall(function() V2.conn:Disconnect() end); V2.conn = nil end
        _G.ExeBatV2On = true

        local HEIGHT, VERT_OFFSET, HIT_DIST = 4.75, 1, 9
        local BYP = {
            VelocityCap = 95,
            TeleportThreshold = 8,
            MaxAccelPerSec = 140,
            MaxPredictOffset = 8,
            lastPos = nil,
            lastAt = nil,
            velocityAt = nil,
            stableVel = Vector3.zero,
        }
        local lockedCharacter, noTargetSince = nil, nil
        local function resetPrediction()
            BYP.lastPos = nil
            BYP.lastAt = nil
            BYP.velocityAt = nil
            BYP.stableVel = Vector3.zero
        end
        local function validCharacter(char)
            if not char or not char.Parent then return false end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            return hum ~= nil and root ~= nil and hum.Health > 0
        end
        local function stableVelocity(targetRoot, now)
            local raw = targetRoot.AssemblyLinearVelocity
            if raw.Magnitude > BYP.VelocityCap then raw = raw.Unit * BYP.VelocityCap end
            local previous = BYP.stableVel
            local dt = math.max((BYP.velocityAt and (now - BYP.velocityAt)) or 0.016, 0.008)
            local acceleration = (raw - previous) / dt
            if acceleration.Magnitude > BYP.MaxAccelPerSec then acceleration = acceleration.Unit * BYP.MaxAccelPerSec end
            local stable = previous + acceleration * dt
            BYP.stableVel = stable
            BYP.velocityAt = now
            return stable
        end

        V2.conn = RunService.Heartbeat:Connect(function()
            if not _G.ExeBatV2On then return end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not char.Parent or not root or not hum or hum.Health <= 0 then return end
            if V2.character ~= char then
                V2.character = char
                V2.prevAutoRotate = hum.AutoRotate
                resetPrediction()
                lockedCharacter = nil
            end
            hum.AutoRotate = false
            local bat = _G.ExeFindAimbotBat and _G.ExeFindAimbotBat()
            if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
            hum:Move(Vector3.zero, false)

            if lockedCharacter and not validCharacter(lockedCharacter) then lockedCharacter = nil end
            local targetRoot = nil
            if lockedCharacter then
                targetRoot = lockedCharacter:FindFirstChild("HumanoidRootPart")
            else
                targetRoot = _G.ExeGetClosestAimbotTarget and _G.ExeGetClosestAimbotTarget()
                lockedCharacter = targetRoot and targetRoot.Parent or nil
            end
            local targetChar = targetRoot and targetRoot.Parent
            if targetRoot and targetChar and targetRoot.Parent and validCharacter(targetChar) then
                noTargetSince = nil
                local now = tick()
                local pos = targetRoot.Position
                if BYP.lastPos and BYP.lastAt then
                    local sampleDt = now - BYP.lastAt
                    if sampleDt > 0 and sampleDt < 0.5 then
                        local jump = (pos - BYP.lastPos).Magnitude
                        if jump > (BYP.TeleportThreshold + BYP.VelocityCap * sampleDt) then
                            BYP.lastPos, BYP.lastAt = pos, now
                            root.AssemblyLinearVelocity = Vector3.zero
                            resetPrediction()
                            return
                        end
                    end
                end
                BYP.lastPos, BYP.lastAt = pos, now
                local targetVelocity = stableVelocity(targetRoot, now)
                local predictTime = math.clamp(targetVelocity.Magnitude / 150, 0.05, 0.2)
                local predicted = pos + targetVelocity * predictTime
                local predictionOffset = predicted - pos
                if predictionOffset.Magnitude > BYP.MaxPredictOffset then predicted = pos + predictionOffset.Unit * BYP.MaxPredictOffset end
                local standPos = predicted + Vector3.new(0, HEIGHT + VERT_OFFSET, 0)
                local moveDir = standPos - root.Position
                local lookTarget = Vector3.new(predicted.X, root.Position.Y, predicted.Z)
                if (lookTarget - root.Position).Magnitude > 0.1 then
                    root.CFrame = CFrame.lookAt(root.Position, lookTarget)
                end
                if moveDir.Magnitude > 1 then
                    root.AssemblyLinearVelocity = moveDir.Unit * math.clamp(tonumber(BAT_V2_SPEED) or 58, 1, 120)
                else
                    root.AssemblyLinearVelocity = targetVelocity
                end
                if bat and (targetRoot.Position - root.Position).Magnitude <= HIT_DIST and not V2.swingCooldown then
                    V2.swingCooldown = true
                    pcall(function() bat:Activate() end)
                    task.delay(0.08, function() V2.swingCooldown = false end)
                end
            else
                if not noTargetSince then noTargetSince = tick() end
                if tick() - noTargetSince > 1.5 then
                    lockedCharacter = nil
                    resetPrediction()
                    if root and root.Parent then root.AssemblyLinearVelocity = Vector3.zero end
                end
            end
        end)
        if saveExeConfig then pcall(saveExeConfig) end
        return true
    end

    function _G.ExeToggleBatV2()
        if _G.ExeBatV2On then _G.ExeStopBatV2(); return false end
        return _G.ExeStartBatV2()
    end
end

-- AUTO PLAY (S2 HUB): finds your plot, then walks your side's path automatically.
do
    _G.ExeAutoPlayOn = false
    local AP = {conn = nil, phase = 1}
    _G.ExeAutoPlay = AP
    local AP_L1, AP_L2 = Vector3.new(-476.47, -6.28, 92.73), Vector3.new(-483.12, -4.95, 94.81)
    local AP_R1, AP_R2 = Vector3.new(-476.16, -6.52, 25.62), Vector3.new(-483.06, -5.03, 25.48)
    local PLOT_POSITIONS = {
        [3] = Vector3.new(-476.7524719238281, 10.464664459228516, 7.107429504394531),
        [7] = Vector3.new(-476.7524719238281, 10.464664459228516, 114.10742950439453),
    }

    local function getPlotOwner(part)
        for _, c in ipairs(part:GetDescendants()) do
            if c:IsA("SurfaceGui") then
                for _, l in ipairs(c:GetDescendants()) do
                    if l:IsA("TextLabel") and l.Text ~= "" then return l.Text end
                end
            end
        end
        return nil
    end

    local function checkMyPlot()
        local scanRoot = workspace:FindFirstChild("Plots") or workspace
        for plotNum, pos in pairs(PLOT_POSITIONS) do
            for _, obj in ipairs(scanRoot:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "PlotSign" and (obj.Position - pos).Magnitude < 5 then
                    local owner = getPlotOwner(obj)
                    if owner and (owner:find(LP.Name, 1, true) or owner:find(LP.DisplayName, 1, true)) then return plotNum end
                end
            end
        end
        return nil
    end

    local function apVisual()
        if _G.ExeAutoPlaySetVisual then pcall(_G.ExeAutoPlaySetVisual, _G.ExeAutoPlayOn == true) end
    end

    function _G.ExeStopAutoPlay()
        if AP.conn then pcall(function() AP.conn:Disconnect() end); AP.conn = nil end
        AP.phase = 1
        if _G.ExeAutoPlayOn then
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum then hum:Move(Vector3.zero, false); hum.WalkSpeed = 16 end
            if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
        end
        _G.ExeAutoPlayOn = false
        apVisual()
    end

    function _G.ExeStartAutoPlay()
        if _G.ExeAutoPlayOn then return true end
        -- only one mode at a time
        if _G.ExeNormalAimbotOn and _G.ExeStopNormalAimbot then pcall(_G.ExeStopNormalAimbot) end
        if _G.ExeAntiBypassAimbotOn and _G.ExeStopAntiBypassAimbot then pcall(function() _G.ExeStopAntiBypassAimbot(false) end) end
        if _G.ExeAntiDesyncAimbotOn and _G.ExeStopAntiDesyncAimbot then pcall(_G.ExeStopAntiDesyncAimbot) end
        if _G.ExeBatV2On and _G.ExeStopBatV2 then pcall(_G.ExeStopBatV2) end
        if _G.ExeStopTpBat then pcall(_G.ExeStopTpBat) end
        if _G.ExeAntiBatBypassOn and _G.ExeStopAntiBatBypass then pcall(_G.ExeStopAntiBatBypass) end
if _G.ExeAutoPlayOn and _G.ExeStopAutoPlay then pcall(_G.ExeStopAutoPlay) end

        _G.ExeAutoPlayOn = true
        if AP.conn then pcall(function() AP.conn:Disconnect() end); AP.conn = nil end
        AP.phase = 1
        local p1, p2 = nil, nil
        local p2t, checkT = 0, 0
        AP.conn = RunService.Heartbeat:Connect(function(dt)
            if not _G.ExeAutoPlayOn then return end
            if not p1 then
                checkT = checkT + dt
                if checkT < 0.1 then return end
                checkT = 0
                local plotNum = checkMyPlot()
                if plotNum == 3 then p1, p2 = AP_L1, AP_L2
                elseif plotNum == 7 then p1, p2 = AP_R1, AP_R2
                else return end
            end
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end
            local spd = (_G.ExeAutoPathSpeed and _G.ExeAutoPathSpeed()) or NS
            hum.WalkSpeed = spd
            local dFinal = Vector3.new(p2.X - hrp.Position.X, 0, p2.Z - hrp.Position.Z)
            if dFinal.Magnitude < 1 or (AP.phase == 2 and p2t > 3) then
                hum:Move(Vector3.zero, false)
                hum.WalkSpeed = 16
                hrp.AssemblyLinearVelocity = Vector3.zero
                if AP.conn then AP.conn:Disconnect(); AP.conn = nil end
                AP.phase = 1
                _G.ExeAutoPlayOn = false
                apVisual()
                return
            end
            if AP.phase == 1 then
                local d = Vector3.new(p1.X - hrp.Position.X, 0, p1.Z - hrp.Position.Z)
                if d.Magnitude < 1 then AP.phase = 2; p2t = 0; return end
                local md = d.Unit
                hum:Move(md, false)
                hrp.AssemblyLinearVelocity = Vector3.new(md.X * spd, hrp.AssemblyLinearVelocity.Y, md.Z * spd)
            else
                p2t = p2t + dt
                local md = dFinal.Unit
                hum:Move(md, false)
                hrp.AssemblyLinearVelocity = Vector3.new(md.X * spd, hrp.AssemblyLinearVelocity.Y, md.Z * spd)
            end
        end)
        apVisual()
        return true
    end

    function _G.ExeToggleAutoPlay()
        if _G.ExeAutoPlayOn then _G.ExeStopAutoPlay(); return false end
        return _G.ExeStartAutoPlay()
    end
    LP.CharacterAdded:Connect(function()
        if _G.ExeAutoPlayOn then _G.ExeStopAutoPlay() end
    end)
end

-- ANTI BAT BYPASS (S2 HUB): chases the nearest player at the bat aimbot speed and swings when close.
do
    _G.ExeAntiBatBypassOn = false
    local AB = {conn = nil, swingCooldown = false, prevAutoRotate = nil,
        wasAutoTP = false, wasAutoLeft = false, wasAutoRight = false}
    _G.ExeAntiBatBypass = AB

    local function abFindBat()
        local char = LP.Character
        if not char then return nil end
        local function isBat(t)
            if not t:IsA("Tool") then return false end
            local n = t.Name:lower()
            return n:find("bat") ~= nil or n:find("slap") ~= nil
        end
        for _, t in ipairs(char:GetChildren()) do if isBat(t) then return t end end
        local bp = LP:FindFirstChild("Backpack")
        if bp then for _, t in ipairs(bp:GetChildren()) do if isBat(t) then return t end end end
        return nil
    end

    local function abTrySwing()
        if AB.swingCooldown then return end
        AB.swingCooldown = true
        pcall(function()
            local char = LP.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool") or abFindBat()
            if tool then
                if tool.Parent ~= char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(tool) end) end
                end
                pcall(function() tool:Activate() end)
            end
        end)
        task.delay(0.35, function() AB.swingCooldown = false end)
    end

    local function abClosest()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local closest, minDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if tRoot and hum and hum.Health > 0 then
                    local d = (tRoot.Position - root.Position).Magnitude
                    if d < minDist then minDist = d; closest = tRoot end
                end
            end
        end
        return closest
    end

    local function abRefreshVisual()
        if _G.ExeAntiBatBypassSetVisual then pcall(_G.ExeAntiBatBypassSetVisual, _G.ExeAntiBatBypassOn == true) end
    end

    function _G.ExeStopAntiBatBypass()
        local wasOn = _G.ExeAntiBatBypassOn == true
        _G.ExeAntiBatBypassOn = false
        if AB.conn then pcall(function() AB.conn:Disconnect() end); AB.conn = nil end
        AB.swingCooldown = false
        if wasOn then
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
            if hum then
                hum.AutoRotate = (AB.prevAutoRotate == nil) and true or AB.prevAutoRotate
                hum.PlatformStand = false
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
            AB.prevAutoRotate = nil
            if AB.wasAutoTP then AB.wasAutoTP = false; pcall(startAutoTP) end
            if AB.wasAutoLeft then AB.wasAutoLeft = false; if _G.ExeSetAutoLeft then pcall(function() _G.ExeSetAutoLeft(true, true) end) end end
            if AB.wasAutoRight then AB.wasAutoRight = false; if _G.ExeSetAutoRight then pcall(function() _G.ExeSetAutoRight(true, true) end) end end
        end
        abRefreshVisual()
    end

    function _G.ExeStartAntiBatBypass()
        if _G.ExeAntiBatBypassOn then return true end
        -- only one bat mode at a time
        if _G.ExeNormalAimbotOn and _G.ExeStopNormalAimbot then pcall(_G.ExeStopNormalAimbot) end
        if _G.ExeAntiBypassAimbotOn and _G.ExeStopAntiBypassAimbot then pcall(function() _G.ExeStopAntiBypassAimbot(false) end) end
        if _G.ExeAntiDesyncAimbotOn and _G.ExeStopAntiDesyncAimbot then pcall(_G.ExeStopAntiDesyncAimbot) end
        if _G.ExeBatV2On and _G.ExeStopBatV2 then pcall(_G.ExeStopBatV2) end
        if _G.ExeStopTpBat then pcall(_G.ExeStopTpBat) end
        if _G.ExeAutoPlayOn and _G.ExeStopAutoPlay then pcall(_G.ExeStopAutoPlay) end

        AB.wasAutoTP = autoTPEnabled == true
        if AB.wasAutoTP then pcall(stopAutoTP) end
        AB.wasAutoLeft = autoLeftEnabled == true
        if AB.wasAutoLeft and _G.ExeSetAutoLeft then pcall(function() _G.ExeSetAutoLeft(false, true) end) end
        AB.wasAutoRight = autoRightEnabled == true
        if AB.wasAutoRight and _G.ExeSetAutoRight then pcall(function() _G.ExeSetAutoRight(false, true) end) end

        if AB.conn then pcall(function() AB.conn:Disconnect() end); AB.conn = nil end
        _G.ExeAntiBatBypassOn = true
        local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum0 then
            if AB.prevAutoRotate == nil then AB.prevAutoRotate = hum0.AutoRotate end
            hum0.AutoRotate = false
        end

        AB.conn = RunService.Heartbeat:Connect(function()
            if not _G.ExeAntiBatBypassOn then return end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not root or not hum then return end
            if not char:FindFirstChildOfClass("Tool") then
                local bat = abFindBat()
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end
            local targetRoot = abClosest()
            if not targetRoot then
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
                if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
                return
            end
            local targetVel = targetRoot.AssemblyLinearVelocity
            local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
            local desiredPos = targetRoot.Position + moveDir * 1.0 + Vector3.new(0, 1.5, 0)
            local toTarget = desiredPos - root.Position
            if toTarget.Magnitude > 0.5 then
                local speed = tonumber(_G.ExeGetNormalAimbotSpeed and _G.ExeGetNormalAimbotSpeed()) or 45
                root.AssemblyLinearVelocity = toTarget.Unit * speed
            else
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
            end
            if (root.Position - targetRoot.Position).Magnitude <= 4.5 then abTrySwing() end
        end)
        abRefreshVisual()
        return true
    end

    function _G.ExeToggleAntiBatBypass()
        if _G.ExeAntiBatBypassOn then _G.ExeStopAntiBatBypass(); return false end
        return _G.ExeStartAntiBatBypass()
    end
    LP.CharacterAdded:Connect(function()
        if _G.ExeAntiBatBypassOn then _G.ExeStopAntiBatBypass() end
    end)
end

-- TP BAT (V1 / V2) -- teleports to the nearest player and swings.
-- No speed setting on purpose: movement stays on your manual speed.
do
    _G.ExeTpBatV1On = false
    _G.ExeTpBatV2On = false
    local TPB = {thread = nil, version = nil, hitCooldown = false}
    _G.ExeTpBat = TPB

    local TP_HIT_DELAY = 0.08
    local TP_CONFIGS = {
        V1 = {
            range = 250,
            tpOffset = Vector3.new(0, 0, 0),
            loopDelay = 0.08,
            smartRotation = true,
            resetVelocity = true,
            predictMovement = true,
            predictionFactor = 0.15,
            behindTarget = false,
            behindDistance = 4,
            antiFling = true,
            sideOffset = 2.5,
        },
        V2 = {
            range = 250,
            tpOffset = Vector3.new(0, 3, 0),
            loopDelay = 0.08,
            smartRotation = false,
            resetVelocity = true,
            predictMovement = false,
            predictionFactor = 0,
            behindTarget = false,
            behindDistance = 0,
            antiFling = false,
            sideOffset = 0,
        },
    }

    local function tpRefreshVisual()
        if _G.ExeTpBatSetVisual then pcall(_G.ExeTpBatSetVisual) end
    end

    local function tpGetBat()
        local char = LP.Character
        if not char then return nil end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then return tool end
        local bat = _G.ExeFindAimbotBat and _G.ExeFindAimbotBat()
        if not bat then
            local backpack = LP:FindFirstChild("Backpack")
            bat = backpack and backpack:FindFirstChild("Bat")
        end
        if bat and hum then pcall(function() hum:EquipTool(bat) end) end
        return bat
    end

    local function tpHit()
        if TPB.hitCooldown then return end
        TPB.hitCooldown = true
        pcall(function()
            local bat = tpGetBat()
            if bat then
                bat:Activate()
                local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
                if remote then remote:FireServer() end
            end
        end)
        task.delay(TP_HIT_DELAY, function() TPB.hitCooldown = false end)
    end

    local function tpNearestEnemy(cfg)
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local best, bestDist = nil, cfg.range
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and tRoot and hum.Health > 0 then
                    local d = (tRoot.Position - root.Position).Magnitude
                    if d < bestDist then best, bestDist = tRoot, d end
                end
            end
        end
        return best
    end

    local function tpTeleport(cfg, targetRoot)
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root then return end

        local targetPos = targetRoot.Position
        if cfg.predictMovement then
            targetPos = targetPos + targetRoot.AssemblyLinearVelocity * cfg.predictionFactor
        end

        local finalPos
        if cfg.behindTarget then
            local dir = (targetPos - root.Position)
            dir = dir.Magnitude > 0.01 and dir.Unit or Vector3.new(0, 0, -1)
            finalPos = targetPos + dir * -cfg.behindDistance + Vector3.new(0, 2, 0)
        elseif cfg.sideOffset and cfg.sideOffset > 0 then
            local dir = root.Position - targetPos
            dir = Vector3.new(dir.X, 0, dir.Z)
            dir = dir.Magnitude < 0.1 and Vector3.new(1, 0, 0) or dir.Unit
            finalPos = targetPos + dir * cfg.sideOffset
        else
            finalPos = targetPos + cfg.tpOffset
        end

        if cfg.smartRotation then
            root.CFrame = CFrame.new(finalPos, targetPos)
        else
            root.CFrame = CFrame.new(finalPos)
        end

        if cfg.resetVelocity then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        if cfg.antiFling and hum then
            hum.PlatformStand = false
            hum.Sit = false
        end
    end

    local function stopOtherBatModes()
        if _G.ExeNormalAimbotOn and _G.ExeStopNormalAimbot then pcall(_G.ExeStopNormalAimbot) end
        if _G.ExeAntiBypassAimbotOn and _G.ExeStopAntiBypassAimbot then pcall(function() _G.ExeStopAntiBypassAimbot(false) end) end
        if _G.ExeAntiDesyncAimbotOn and _G.ExeStopAntiDesyncAimbot then pcall(_G.ExeStopAntiDesyncAimbot) end
        if _G.ExeBatV2On and _G.ExeStopBatV2 then pcall(_G.ExeStopBatV2) end
        if _G.ExeAntiBatBypassOn and _G.ExeStopAntiBatBypass then pcall(_G.ExeStopAntiBatBypass) end
if _G.ExeAutoPlayOn and _G.ExeStopAutoPlay then pcall(_G.ExeStopAutoPlay) end
    end

    function _G.ExeStopTpBat()
        _G.ExeTpBatV1On = false
        _G.ExeTpBatV2On = false
        TPB.version = nil
        if TPB.thread then
            pcall(function() task.cancel(TPB.thread) end)
            TPB.thread = nil
        end
        TPB.hitCooldown = false
        tpRefreshVisual()
    end

    function _G.ExeStartTpBat(version)
        version = (version == "V2") and "V2" or "V1"
        if TPB.version == version and TPB.thread then return true end
        _G.ExeStopTpBat()
        stopOtherBatModes()
        if _G.ExeStopAutoTPForAction then pcall(_G.ExeStopAutoTPForAction) end
        TPB.version = version
        _G.ExeTpBatSelected = version
        if _G.ExeTpBatMobileRefresh then pcall(_G.ExeTpBatMobileRefresh) end
        _G.ExeTpBatV1On = (version == "V1")
        _G.ExeTpBatV2On = (version == "V2")
        TPB.thread = task.spawn(function()
            while TPB.version == version do
                local cfg = TP_CONFIGS[version]
                local target = tpNearestEnemy(cfg)
                if target then
                    pcall(tpTeleport, cfg, target)
                    tpHit()
                end
                task.wait(cfg.loopDelay)
            end
        end)
        tpRefreshVisual()
        return true
    end

    function _G.ExeToggleTpBat(version)
        version = (version == "V2") and "V2" or "V1"
        if TPB.version == version then
            _G.ExeStopTpBat()
            return false
        end
        return _G.ExeStartTpBat(version)
    end
end

local MIRROR_TP_DROP_THRESHOLD = 3
local MIRROR_TP_DOWN_Y = -7.00
local mirrorTPPreviousY = {}
local mirrorTPLastTeleport = 0

local function mirrorTPAimbotActive()
return (_G.ExeNormalAimbotOn == true) or (_G.ExeAntiBypassAimbotOn == true)
end

local function mirrorTPTeleportDown()
local character = LP.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 then return end

local now = tick()
if now - (mirrorTPLastTeleport or 0) < 0.08 then return end
mirrorTPLastTeleport = now

local _, yaw = root.CFrame:ToEulerAnglesYXZ()
local y = (MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
root.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
end

RunService.Heartbeat:Connect(function()
if not mirrorTPDownEnabled or not mirrorTPAimbotActive() then
if next(mirrorTPPreviousY) then
table.clear(mirrorTPPreviousY)
end
return
end

for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local root = plr.Character:FindFirstChild("HumanoidRootPart")
if root then
local currentY = root.Position.Y
local previousY = mirrorTPPreviousY[plr.UserId]
if previousY and previousY - currentY >= (MIRROR_TP_DROP_THRESHOLD or 3) then
pcall(mirrorTPTeleportDown)
table.clear(mirrorTPPreviousY)
return
end
mirrorTPPreviousY[plr.UserId] = currentY
end
end
end
end)

function _G.ExeSetMirrorTPDown(enabled)
mirrorTPDownEnabled = enabled == true
if not mirrorTPDownEnabled then
table.clear(mirrorTPPreviousY)
end
if _G.ExeMirrorTPDownSetVisual then
_G.ExeMirrorTPDownSetVisual(mirrorTPDownEnabled)
end
end

_G.ExeAntiDesync = _G.ExeAntiDesync or {
    conn = nil,
    hittingCooldown = false,
    h = nil,
    hrp = nil
}

local XLU0_TP_BAT_NAMES = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap"
}

function _G.ExeAntiDesyncGetBat()
    local char = LP.Character
    if not char then return nil end

    for _, name in ipairs(XLU0_TP_BAT_NAMES) do
        local tool = char:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            return tool
        end
    end

    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(XLU0_TP_BAT_NAMES) do
            local tool = bp:FindFirstChild(name)
            if tool and tool:IsA("Tool") then
                tool.Parent = char
                return tool
            end
        end
    end

    return nil
end

function _G.ExeAntiDesyncTrySwing()
    if _G.ExeAntiDesync.hittingCooldown then return end
    _G.ExeAntiDesync.hittingCooldown = true

    pcall(function()
        local bat = _G.ExeAntiDesyncGetBat()
        if not bat then return end

        if bat.Parent == LP.Character then
            bat:Activate()
        else
            return
        end
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then ev:FireServer() end
    end)

    task.delay(0.08, function()
        if _G.ExeAntiDesync then
            _G.ExeAntiDesync.hittingCooldown = false
        end
    end)
end

function _G.ExeAntiDesyncGetClosestPlayer()
    local hrp = _G.ExeAntiDesync and _G.ExeAntiDesync.hrp
    if not hrp then return nil end

    local closest, bestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    closest = player
                end
            end
        end
    end

    return closest, bestDist
end

function _G.ExeAntiDesyncSetupChar(char)
    task.wait(0.2)
    if not _G.ExeAntiDesync then return end
    _G.ExeAntiDesync.h = char and char:FindFirstChildOfClass("Humanoid") or nil
    _G.ExeAntiDesync.hrp = char and char:FindFirstChild("HumanoidRootPart") or nil

    if _G.ExeAntiDesyncAimbotOn and not _G.ExeAntiDesync.conn then
        _G.ExeStartAntiDesyncAimbot()
    end
end

LP.CharacterAdded:Connect(function(char)
    pcall(function() _G.ExeAntiDesyncSetupChar(char) end)
end)

if LP.Character then
    task.spawn(function()
        pcall(function() _G.ExeAntiDesyncSetupChar(LP.Character) end)
    end)
end

function _G.ExeStartAntiDesyncAimbot()
    if _G.ExeSafeModeTryStart and not _G.ExeSafeModeTryStart() then
        return false
    end

    if _G.ExeAntiDesync.conn then
        _G.ExeAntiDesync.conn:Disconnect()
        _G.ExeAntiDesync.conn = nil
    end

    _G.ExeAntiDesyncAimbotOn = true

    local char = LP.Character
    if char then
        _G.ExeAntiDesync.h = char:FindFirstChildOfClass("Humanoid")
        _G.ExeAntiDesync.hrp = char:FindFirstChild("HumanoidRootPart")
    end

    _G.ExeAntiDesync.conn = RunService.Heartbeat:Connect(function()
        if not _G.ExeAntiDesyncAimbotOn then return end

        if not _G.ExeAntiDesync.h or not _G.ExeAntiDesync.hrp then
            local currentChar = LP.Character
            if not currentChar then return end
            _G.ExeAntiDesync.h = currentChar:FindFirstChildOfClass("Humanoid")
            _G.ExeAntiDesync.hrp = currentChar:FindFirstChild("HumanoidRootPart")
            if not _G.ExeAntiDesync.h or not _G.ExeAntiDesync.hrp then return end
        end

        local target = _G.ExeAntiDesyncGetClosestPlayer()
        _aimbotTargetPlr = target
        _G.ExeCurrentAimbotTarget = target
        _G.ExeAntiDesyncBatTarget = target

        if not target or not target.Character then return end

        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end

        if sethiddenproperty then
            pcall(sethiddenproperty, _G.ExeAntiDesync.hrp, "PhysicsRepRootPart", targetRoot)
        end

        local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
        if (_G.ExeAntiDesync.hrp.Position - targetPos).Magnitude > 8 then
            _G.ExeAntiDesync.hrp.CFrame = CFrame.new(targetPos)
        end

        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position)
        end

        _G.ExeAntiDesyncTrySwing()
    end)

    if _G.ExeAntiDesyncSetVisual then
        _G.ExeAntiDesyncSetVisual(true)
    end

    return true
end

function _G.ExeStopAntiDesyncAimbot()
    _G.ExeAntiDesyncAimbotOn = false

    if _G.ExeAntiDesync and _G.ExeAntiDesync.conn then
        _G.ExeAntiDesync.conn:Disconnect()
        _G.ExeAntiDesync.conn = nil
    end

    if _G.ExeAntiDesync then
        _G.ExeAntiDesync.hittingCooldown = false
    end

    _G.ExeAntiDesyncBatTarget = nil
    if _G.ExeCurrentAimbotTarget == _aimbotTargetPlr then
        _G.ExeCurrentAimbotTarget = nil
    end
    _aimbotTargetPlr = nil

    if _G.ExeAntiDesyncSetVisual then
        _G.ExeAntiDesyncSetVisual(false)
    end
end

function _G.ExeToggleAntiDesyncAimbot()
    if _G.ExeAntiDesyncAimbotOn then
        _G.ExeStopAntiDesyncAimbot()
    else
        _G.ExeStartAntiDesyncAimbot()
    end
end

_G.__ExeSetupNormalAutoSteal = function()
local getconnections_v3 = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
_G.ExeGalaxyV3 = _G.ExeGalaxyV3 or {
conn=nil, active=false, progress=0, paused=false, pauseTime=nil,
startTime=nil, progressConn=nil, dataCache={}, enabled=false,
StealRadius=63, StealDuration=1.3, TriggerRadius=10
}
local GS = _G.ExeGalaxyV3

local function getHRP()
local c=LP.Character
return c and c:FindFirstChild("HumanoidRootPart")
end

local function isMyPlot(plotName)
local plots=workspace:FindFirstChild("Plots")
if not plots then return false end
local plot=plots:FindFirstChild(plotName)
if not plot then return false end
local sign=plot:FindFirstChild("PlotSign")
if sign then
local yb=sign:FindFirstChild("YourBase")
if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end
end
return false
end

local function findPrompt()
local hrp=getHRP()
if not hrp then return nil,nil end
local plots=workspace:FindFirstChild("Plots")
if not plots then return nil,nil end
local bestPrompt,bestDist,bestSpawn=nil,math.huge,nil

for _,plot in ipairs(plots:GetChildren()) do
if not plot:IsA("Model") then continue end
if isMyPlot(plot.Name) then continue end
local pods=plot:FindFirstChild("AnimalPodiums")
if not pods then continue end

for _,pod in ipairs(pods:GetChildren()) do
pcall(function()
local base=pod:FindFirstChild("Base")
local spawn=base and base:FindFirstChild("Spawn")
if not spawn then return end
local dist=(spawn.Position-hrp.Position).Magnitude
if dist>=bestDist or dist>GS.StealRadius then return end

local function tryPrompt(container)
for _,ch in ipairs(container:GetChildren()) do
if ch:IsA("ProximityPrompt") and ch.Enabled then
bestPrompt=ch
bestDist=dist
bestSpawn=spawn
return true
end
end
end

local att=spawn:FindFirstChild("PromptAttachment")
if not (att and tryPrompt(att)) then
for _,ch in ipairs(spawn:GetDescendants()) do
if ch:IsA("ProximityPrompt") and ch.Enabled then
bestPrompt=ch
bestDist=dist
bestSpawn=spawn
break
end
end
end
end)
end
end
return bestPrompt,bestSpawn
end

local function distToSpawn(spawnPart)
local hrp=getHRP()
if not hrp then return math.huge end
if not spawnPart or not spawnPart.Parent then
local _,ns=findPrompt()
return ns and (hrp.Position-ns.Position).Magnitude or math.huge
end
return (hrp.Position-spawnPart.Position).Magnitude
end

local function updateBar(p,state)
if _G.StealBar then
pcall(function()
_G.StealBar.SetProgress(p or 0)
if state then _G.StealBar.SetState(state) end
end)
end
end

local function execute(prompt,spawnPart)
if GS.active then return end

if not GS.dataCache[prompt] then
local data={hold={},trigger={},ready=true}
if getconnections_v3 then
pcall(function()
for _,c in ipairs(getconnections_v3(prompt.PromptButtonHoldBegan)) do
if c.Function then table.insert(data.hold,c.Function) end
end
for _,c in ipairs(getconnections_v3(prompt.Triggered)) do
if c.Function then table.insert(data.trigger,c.Function) end
end
end)
end
GS.dataCache[prompt]=data
end

local data=GS.dataCache[prompt]
if not data.ready then return end

data.ready=false
GS.active=true
GS.paused=false
GS.startTime=tick()-(GS.progress*GS.StealDuration)
local pauseArmed=true
local PAUSE_AT=0.75
local PAUSE_WAIT=3.0
local PAUSE_RELEASE_BEFORE=0.3

if GS.progressConn then GS.progressConn:Disconnect() end
updateBar(GS.progress,"STEALING")

local function isLocalRagdolled()
local c=LP.Character
if not c then return false end
local hum=c:FindFirstChildOfClass("Humanoid")
if not hum then return false end
if _G.ExeCounterIsRagdoll then return _G.ExeCounterIsRagdoll(hum) end
local st=hum:GetState()
return st==Enum.HumanoidStateType.Physics
or st==Enum.HumanoidStateType.Ragdoll
or st==Enum.HumanoidStateType.FallingDown
or hum.PlatformStand==true
end

GS.progressConn=RunService.Heartbeat:Connect(function()
if not GS.active then
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
return
end

if not GS.enabled or not autoStealEnabled or selectedStealMode~="Auto Steal V3" then
GS.active=false
GS.progress=0
GS.paused=false
data.ready=true
updateBar(0,autoStealEnabled and "READY" or "IDLE")
return
end

if GS.paused then
local dist=distToSpawn(spawnPart)
local waited=tick()-(GS.pauseTime or tick())
if dist<=GS.TriggerRadius then
GS.paused=false
GS.pauseTime=nil
GS.startTime=tick()-(PAUSE_AT*GS.StealDuration)
else
if not GS.pauseTime then
GS.pauseTime=tick()
elseif waited>=PAUSE_WAIT then
GS.pauseTime=nil
GS.paused=false
GS.active=false
GS.progress=0
data.ready=true
pauseArmed=true
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
updateBar(0,autoStealEnabled and "READY" or "IDLE")
return
end
GS.progress=PAUSE_AT
updateBar(PAUSE_AT,"STEALING")
if PAUSE_WAIT-waited<=PAUSE_RELEASE_BEFORE then
GS.paused=false
GS.pauseTime=nil
GS.startTime=tick()-(PAUSE_AT*GS.StealDuration)
end
return
end
end

local elapsed=tick()-GS.startTime
local prog=math.clamp(elapsed/GS.StealDuration,0,1)
GS.progress=prog

if pauseArmed and prog>=PAUSE_AT then
if isLocalRagdolled() then
GS.paused=true
pauseArmed=false
GS.progress=PAUSE_AT
GS.pauseTime=tick()
updateBar(PAUSE_AT,"STEALING")
return
else
pauseArmed=false
end
end

updateBar(prog,"STEALING")

if prog>=1 then
GS.active=false
GS.progress=0
GS.paused=false
pauseArmed=true
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end

for _,fn in ipairs(data.trigger) do
task.spawn(function() pcall(fn) end)
end

data.ready=true
updateBar(0,autoStealEnabled and "READY" or "IDLE")
end
end)

for _,fn in ipairs(data.hold) do
task.spawn(function() pcall(fn) end)
end
end

_G.ExeNormalAutoStealSetRadius=function(v)
GS.StealRadius=tonumber(v) or GS.StealRadius or 63
end

_G.ExeNormalAutoStealStart=function()
if GS.conn then GS.conn:Disconnect();GS.conn=nil end
GS.enabled=true
GS.StealRadius=tonumber(autoStealRadius) or 63
GS.StealDuration=1.4
GS.TriggerRadius=10
GS.conn=RunService.Heartbeat:Connect(function()
if not GS.enabled or GS.active then return end
if not autoStealEnabled or selectedStealMode~="Auto Steal V3" then return end
local prompt,spawnPart=findPrompt()
if prompt then execute(prompt,spawnPart) end
end)
updateBar(0,"READY")
end

_G.ExeNormalAutoStealStop=function()
GS.enabled=false
if GS.conn then GS.conn:Disconnect();GS.conn=nil end
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
GS.active=false
GS.progress=0
GS.paused=false
GS.pauseTime=nil
GS.dataCache={}
updateBar(0,autoStealEnabled and "READY" or "IDLE")
end

_G.ExeNormalAutoStealSync=function()
if autoStealEnabled and selectedStealMode=="Auto Steal V3" then
_G.ExeNormalAutoStealStart()
else
_G.ExeNormalAutoStealStop()
end
end
end
_G.__ExeSetupNormalAutoSteal()
_G.__ExeSetupSemiAutoSteal = function()
local A = _G.ExeSemiSteal
if not A then
A = {
enabled = false,
conn = nil,
scanThread = nil,
syncReady = false,
plots = nil,
animalsData = {},
syncRemotes = nil,
plotSync = {caches = {}, connections = {}},
animals = {},
promptCache = {},
internalCache = {},
radius = 9,
primeRange = 80,
holdMin = 1.3,
holdMax = 2.6,
entryDelay = 0.2, 
cooldown = 0.05,
state = {
active = false,
startTime = 0,
phase = "idle",
label = "",
lastResult = "",
lastResultTime = 0,
totalSteals = 0,
failedSteals = 0,
},
}
_G.ExeSemiSteal = A
end
local function rootPart()
local char = LP.Character
return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
end
local function barSet(pct, status)
pct = math.clamp(pct or 0, 0, 1)

if _G.StealBar then
    _G.StealBar.SetProgress(pct)
    _G.StealBar.SetState(status or "STEALING")
end
end
local function barReset()
if _G.StealBar then
    _G.StealBar.SetProgress(0)
    _G.StealBar.SetState(autoStealEnabled and "READY" or "IDLE")
end
end
local function splitSyncPath(path)
if typeof(path) == "table" then return path end
local out = {}
for part in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(part) or part) end
return out
end
local function resolveSyncPath(path, root)
local current, parent, key = root, nil, nil
for _, part in ipairs(splitSyncPath(path)) do
parent, key = current, part
current = current and current[part] or nil
end
return current, parent, key
end
local function applyPlotSyncDiff(channelName, packet)
local cache = A.plotSync.caches[channelName]
if typeof(cache) ~= "table" then return end
local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
local current, parent, key = resolveSyncPath(path, cache)
if action == "Changed" then
if parent ~= nil then parent[key] = a end
elseif action == "ArrayInsert" then
if current ~= nil then table.insert(current, b, a) end
elseif action == "ArrayRemoved" then
if current ~= nil then table.remove(current, b) end
elseif action == "DictionaryInsert" then
if current ~= nil then current[b] = a end
elseif action == "DictionaryRemoved" then
if current ~= nil then current[b] = nil end
end
end
local function attachPlotChannel(remote)
if not A.syncRemotes or A.plotSync.connections[remote] then return end
local channelName = tostring(remote.Name)
if not A.plots:FindFirstChild(channelName) then return end
if A.syncRemotes.requestData and A.plotSync.caches[channelName] == nil then
local ok, data = pcall(function() return A.syncRemotes.requestData:InvokeServer(channelName) end)
A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
elseif A.plotSync.caches[channelName] == nil then
A.plotSync.caches[channelName] = {}
end
A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
end)
end
local function ensureSync()
if A.syncReady then return true end
local ok = pcall(function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
A.plots = workspace:WaitForChild("Plots")
local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
if not Packages or not Datas then return end
A.animalsData = require(Datas:WaitForChild("Animals"))
local folder = Packages:WaitForChild("Synchronizer")
A.syncRemotes = {
channelFolder = folder:WaitForChild("Channel"),
routeRemote = folder:WaitForChild("CommunicationRoute"),
requestData = folder:FindFirstChild("RequestData"),
}
for _, child in ipairs(A.syncRemotes.channelFolder:GetChildren()) do
if child:IsA("RemoteEvent") then attachPlotChannel(child) end
end
A.syncRemotes.channelFolder.ChildAdded:Connect(function(child)
if child:IsA("RemoteEvent") then attachPlotChannel(child) end
end)
A.syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
for _, actionData in ipairs(actions) do
local kind, channelName = actionData[1], tostring(actionData[2])
if A.plots:FindFirstChild(channelName) then
if kind == "ListenerAdded" then
local remote = A.syncRemotes.channelFolder:FindFirstChild(channelName)
if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
elseif kind == "ListenerRemoved" then
for remote, conn in pairs(A.plotSync.connections) do
if tostring(remote.Name) == channelName then
conn:Disconnect()
A.plotSync.connections[remote] = nil
A.plotSync.caches[channelName] = nil
break
end
end
end
end
end
end)
A.syncReady = true
end)
return ok and A.syncReady == true
end
local function getPlotOwner(plot)
local sign = plot and plot:FindFirstChild("PlotSign")
local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
local label = frame and frame:FindFirstChild("TextLabel")
if not label or label.Text == "Empty Base" then return nil end
return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end
local function isMyBaseAnimal(animalData)
if not animalData or not animalData.plot or not A.plots then return false end
local plot = A.plots:FindFirstChild(animalData.plot)
if not plot then return false end
local owner = getPlotOwner(plot)
return owner == LP.DisplayName or owner == LP.Name
end
local function podiumFor(animalData)
local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
local podiums = plot and plot:FindFirstChild("AnimalPodiums")
return podiums and podiums:FindFirstChild(animalData.slot) or nil
end
local function animalPos(animalData)
local podium = podiumFor(animalData)
return podium and podium:GetPivot().Position or nil
end
local function distToAnimal(animalData)
local root = rootPart()
local pos = animalPos(animalData)
return root and pos and (root.Position - pos).Magnitude or math.huge
end
local function findPromptForAnimal(animalData)
if not animalData then return nil end
local cached = A.promptCache[animalData.uid]
if cached and cached.Parent then return cached end
local podium = podiumFor(animalData)
local base = podium and podium:FindFirstChild("Base")
local spawn = base and base:FindFirstChild("Spawn")
local attach = spawn and spawn:FindFirstChild("PromptAttachment")
if not attach then return nil end
for _, prompt in ipairs(attach:GetChildren()) do
if prompt:IsA("ProximityPrompt") then
A.promptCache[animalData.uid] = prompt
return prompt
end
end
return nil
end
local function scanAllPlots()
if not ensureSync() then return 0 end
local newCache = {}
for _, plot in ipairs(A.plots:GetChildren()) do
local cache = A.plotSync.caches[plot.Name]
local animalList = cache and cache.AnimalList
if typeof(animalList) == "table" then
for slot, animalData in pairs(animalList) do
if type(animalData) == "table" then
local animalName = animalData.Index
local info = A.animalsData and A.animalsData[animalName]
if info then
table.insert(newCache, {
name = info.DisplayName or animalName,
plot = plot.Name,
slot = tostring(slot),
uid = plot.Name .. "_" .. tostring(slot),
})
end
end
end
end
end
A.animals = newCache
return #newCache
end
local function pickClosest()
local root = rootPart()
if not root then return nil end
local best, bestDist = nil, math.huge
for _, animalData in ipairs(A.animals) do
if not isMyBaseAnimal(animalData) then
local pos = animalPos(animalData)
local dist = pos and (root.Position - pos).Magnitude or math.huge
if dist <= (A.primeRange or 80) and dist < bestDist then
best, bestDist = animalData, dist
end
end
end
return best
end
local function buildStealCallbacks(prompt)
if A.internalCache[prompt] then return end
local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
local ok1, conns1 = false, nil
if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
if ok1 and type(conns1) == "table" then
for _, conn in ipairs(conns1) do
if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
end
end
local ok2, conns2 = false, nil
if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
if ok2 and type(conns2) == "table" then
for _, conn in ipairs(conns2) do
if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
end
end
if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
end
local function executeCandySemi(prompt, animalData)
if not prompt or not prompt.Parent or not animalData then return false end
buildStealCallbacks(prompt)
local data = A.internalCache[prompt]
if not data or not data.ready then return false end
data.ready = false
local label = animalData.name or "Animal"
A.state.active = true
A.state.startTime = tick()
A.state.phase = "holding"
A.state.label = label
task.spawn(function()
for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
local holdStart = A.state.startTime
while A.enabled and selectedStealMode == "Semi" and tick() - holdStart < (A.holdMin or 1.3) do
barSet((tick() - holdStart) / (A.holdMax or 2.6), "STEALING")
task.wait()
end
A.state.phase = "waitingRange"
local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 9)
local fired = false
while A.enabled and selectedStealMode == "Semi" do
local elapsed = tick() - A.state.startTime
if elapsed > (A.holdMax or 2.6) or not prompt.Parent then break end
barSet(elapsed / (A.holdMax or 2.6), "WAITING RANGE")
if distToAnimal(animalData) <= (tonumber(A.radius) or 9) then
if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
if A.enabled and selectedStealMode == "Semi" then
for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
fired = true
end
break
end
task.wait()
end
if fired then
A.state.totalSteals = (A.state.totalSteals or 0) + 1
A.state.lastResult = "Stole " .. label
A.state.phase = "success"
barSet(1, "SUCCESS")
else
A.state.failedSteals = (A.state.failedSteals or 0) + 1
A.state.lastResult = "Missed window: " .. label
A.state.phase = "failed"
barSet(1, "FAILED")
end
A.state.active = false
A.state.lastResultTime = tick()
task.wait(A.cooldown or 0.05)
data.ready = true
task.delay(0.8, function()
if not A.state.active then barReset() end
end)
end)
return true
end
local function ensureScanThread()
if A.scanThread then return end
A.scanThread = task.spawn(function()
while _G.ExeSemiSteal do
if A.enabled or selectedStealMode == "Semi" then pcall(scanAllPlots) end
task.wait(5)
end
end)
end
_G.ExeSemiAutoStealSetRadius = function(v)
local n = tonumber(v)
if n then A.radius = n end
end
_G.ExeSemiAutoStealStop = function()
A.enabled = false
if A.conn then A.conn:Disconnect(); A.conn = nil end
A.state.active = false
A.state.phase = "idle"
barReset()
end
_G.ExeSemiAutoStealStart = function()
A.radius = tonumber(autoStealRadius) or A.radius or 9
A.enabled = true
if not ensureSync() then return end
ensureScanThread()
pcall(scanAllPlots)
if A.conn then A.conn:Disconnect(); A.conn = nil end
A.conn = RunService.Heartbeat:Connect(function()
if not A.enabled then return end
if selectedStealMode ~= "Semi" then _G.ExeSemiAutoStealStop(); return end
if A.state.active then return end
local target = pickClosest()
if not target then return end
local prompt = A.promptCache[target.uid]
if not prompt or not prompt.Parent then prompt = findPromptForAnimal(target) end
if prompt then executeCandySemi(prompt, target) end
end)
end
_G.ExeSemiAutoStealSync = function()
if selectedStealMode == "Semi" and autoStealEnabled then
_G.ExeSemiAutoStealStart()
else
_G.ExeSemiAutoStealStop()
end
end
end
_G.__ExeSetupSemiAutoSteal()
_G.ExeAutoStealSync = function()
if not autoStealEnabled then
if _G.ExeNormalAutoStealStop then _G.ExeNormalAutoStealStop() end
if _G.ExeSemiAutoStealStop then _G.ExeSemiAutoStealStop() end
return
end
if selectedStealMode == "Auto Steal V3" then
if _G.ExeSemiAutoStealStop then _G.ExeSemiAutoStealStop() end
if _G.ExeNormalAutoStealSync then _G.ExeNormalAutoStealSync() end
elseif selectedStealMode == "Semi" then
if _G.ExeNormalAutoStealStop then _G.ExeNormalAutoStealStop() end
if _G.ExeSemiAutoStealSync then _G.ExeSemiAutoStealSync() end
end
end
task.spawn(function()
while task.wait(30) do
do end
end
end)
local lastMoveDir = Vector3.new(0, 0, 0)
local _moveDt = 1/60
local _speedActive = false
local _lastHorizSpeed = 0
local _actualSpeed = 0
local _lastPos = nil
local _lastPosT = 0
local _lastGroundNormalY = 1

local function getActiveMoveSpeed()
    if laggerCarryActive then return LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end

local function getCurrentSpeedValue()
    return getActiveMoveSpeed()
end

local function getAutoPathSpeed()
    if laggerModeEnabled then return LAGGER_SPEED
    else return NS end
end

local refreshSpeedModeRows = nil

local function syncCurrentSpeedMode()
    if laggerCarryActive then
        currentSpeedMode = "Lagger Carry"
    elseif laggerModeEnabled then
        currentSpeedMode = "Lagger"
    elseif carrySpeedActive then
        currentSpeedMode = "Carry"
    else
        currentSpeedMode = "Normal"
    end
end

local function refreshSpeedModeLabel()
    syncCurrentSpeedMode()
    if refreshSpeedModeRows then pcall(refreshSpeedModeRows) end
end

local function setSpeedMode(mode)
    if mode ~= "Normal" and mode ~= "Carry" and mode ~= "Lagger" and mode ~= "Lagger Carry" then
        mode = "Normal"
    end
    carrySpeedActive = (mode == "Carry")
    laggerModeEnabled = (mode == "Lagger")
    laggerCarryActive = (mode == "Lagger Carry")
    if mode == "Normal" then
        carrySpeedActive = false
        laggerModeEnabled = false
        laggerCarryActive = false
    end
    syncCurrentSpeedMode()
    if refreshSpeedModeRows then refreshSpeedModeRows() end
    if saveExeConfig then pcall(saveExeConfig) end
end

toggleCarryMode = function()
    carrySpeedActive = not carrySpeedActive
    if carrySpeedActive then
        laggerModeEnabled = false
        laggerCarryActive = false
    end
    refreshSpeedModeLabel()
    if saveExeConfig then pcall(saveExeConfig) end
end

toggleLaggerMode = function()
    laggerModeEnabled = not laggerModeEnabled
    if laggerModeEnabled then
        carrySpeedActive = false
        laggerCarryActive = false
    end
    refreshSpeedModeLabel()
    if saveExeConfig then pcall(saveExeConfig) end
end

toggleLaggerCarryMode = function()
    laggerCarryActive = not laggerCarryActive
    if laggerCarryActive then
        carrySpeedActive = false
        laggerModeEnabled = false
    end
    refreshSpeedModeLabel()
    if saveExeConfig then pcall(saveExeConfig) end
end

local function applyImpulseVel(part, targetVel)
    if not part or not part.Parent then return end
    pcall(function()
        local mass = part.AssemblyMass
        if not mass or mass ~= mass or mass <= 0 then mass = 1 end
        local current = part.AssemblyLinearVelocity
        local delta = targetVel - current
        part:ApplyImpulse(delta * mass)
    end)
end

local function applyVel(part, targetVel)
    applyImpulseVel(part, targetVel)
end

local function applyAngVel(part, targetAng)
    if not part or not part.Parent then return end
    pcall(function()
        local mass = part.AssemblyMass
        if not mass or mass <= 0 then mass = 1 end
        local current = part.AssemblyAngularVelocity
        local target = targetAng or Vector3.zero
        part:ApplyAngularImpulse((target - current) * mass * 0.35)
    end)
end

local function sampleGround(hrp)
    local ok, res = pcall(function()
        local origin = hrp.Position + Vector3.new(0, 2, 0)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local char = hrp.Parent
        if char then params.FilterDescendantsInstances = {char} end
        params.IgnoreWater = true
        local hit = workspace:Raycast(origin, Vector3.new(0, -8, 0), params)
        if hit and hit.Normal then
            return {ny = hit.Normal.Y, grounded = (hit.Distance < 4.2)}
        end
        return {ny = 1, grounded = false}
    end)
    if ok and type(res) == "table" and type(res.ny) == "number" then
        _lastGroundNormalY = res.ny
        return res.ny, res.grounded == true
    end
    return _lastGroundNormalY, false
end

local function setSpeedConstraint(hrp, horizVel)
    if not hrp or not hrp.Parent then return end
    local hx, hz = horizVel.X, horizVel.Z
    local mag = math.sqrt(hx * hx + hz * hz)
    _lastHorizSpeed = mag
    _speedActive = mag > 0.05
    if mag < 0.05 then return end

    -- Set horizontal velocity exactly to target so actual speed matches NS/CS/LAGGER values
    pcall(function()
        local v = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(hx, v.Y, hz)
    end)
end

local function brakeHorizontal(hrp)
    if not hrp or not hrp.Parent then return end
    pcall(function()
        local ny, grounded = sampleGround(hrp)
        if not grounded then return end
        local v = hrp.AssemblyLinearVelocity
        local hx, hz = v.X, v.Z
        local hMag = math.sqrt(hx * hx + hz * hz)
        if hMag < 0.8 then
            if hMag > 0.05 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
            end
            return
        end
        local mass = hrp.AssemblyMass
        if not mass or mass ~= mass or mass <= 0 then mass = 1 end
        local target = Vector3.new(0, v.Y, 0)
        hrp:ApplyImpulse((target - v) * mass * 0.92)
    end)
end

local function applyCFrameMove(part, dirUnit, spd, dt)
    if not part or not part.Parent then return end
    if not dirUnit or dirUnit.Magnitude < 0.01 then return end
    _moveDt = dt or _moveDt
    setSpeedConstraint(part, Vector3.new(dirUnit.X, 0, dirUnit.Z).Unit * spd)
end

local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
end

State = State or {}
State.normalSpeed = NS
State.carrySpeed = CS
State.laggerSpeed = LAGGER_SPEED
State.speedToggled = (currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry")
State.laggerEnabled = (currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
toggleRefs = toggleRefs or {}
function setCarry(on)
if on then
setSpeedMode("Carry")
else
if currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Normal")
end
end
State.speedToggled = on == true
end
function setLagger(on)
if on then
setSpeedMode("Lagger")
else
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Normal")
end
end
State.laggerEnabled = on == true
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
State = State or {}
State.normalSpeed = State.normalSpeed or 60
State.carrySpeed = State.carrySpeed or 30
State.laggerSpeed = State.laggerSpeed or 60
State.speedToggled = State.speedToggled or false
State.laggerEnabled = State.laggerEnabled or false
State._autoCarryFromSteal = State._autoCarryFromSteal or false
State._autoCarryGraceUntil = State._autoCarryGraceUntil or 0
State._waitingForCarryPickup = State._waitingForCarryPickup or false
State._carryPickupWatchUntil = State._carryPickupWatchUntil or 0
State._autoCarryReturnMode = State._autoCarryReturnMode or nil
toggleRefs = toggleRefs or {}
local function safeSaveConfig()
if type(saveExeConfig) == "function" then
task.spawn(saveExeConfig)
elseif type(saveConfig) == "function" then
task.spawn(saveConfig)
end
end
local function isCarryName(name)
    local n = tostring(name or ""):lower()
    return n:find("brainrot")
        or n:find("animal")
        or n:find("carry")
        or n:find("grab")
        or n:find("steal")
        or n:find("hold")
end

local function isIgnoredCarryTool(name)
    local n = tostring(name or ""):lower()
    return n:find("bat")
        or n:find("slap")
        or n:find("medusa")
        or n:find("head")
        or n:find("stone")
end

local function isCarryingBrainrot(char)
    if not char then return false end

    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
                return true
            end
            if isCarryName(child.Name) then
                return true
            end
        elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
            return true
        end
    end

    return false
end

local function setCarrySpeedMode(on)
    State.speedToggled = on
    if toggleRefs.carryMode then
        toggleRefs.carryMode(on)
    end
    if type(setCarry) == "function" then
        setCarry(on)
    end
end

local function setLaggerMode(on)
    State.laggerEnabled = on
    if toggleRefs.laggerMode then
        toggleRefs.laggerMode(on)
    end
    if type(setLagger) == "function" then
        setLagger(on)
    end
end

local function enableCarrySpeedForSteal()
    State._waitingForCarryPickup = false
    State._carryPickupWatchUntil = 0

    if not State._autoCarryFromSteal then
        State._autoCarryReturnMode = currentSpeedMode
    end

    State._autoCarryFromSteal = true
    State._autoCarryGraceUntil = tick() + 0.75

    local wasLagger = (
        State._autoCarryReturnMode == "Lagger"
        or State._autoCarryReturnMode == "Lagger Carry"
        or currentSpeedMode == "Lagger"
        or currentSpeedMode == "Lagger Carry"
    )

    if wasLagger then
        State.laggerEnabled = true
        State.speedToggled = true
        if toggleRefs.laggerMode then toggleRefs.laggerMode(true) end
        if toggleRefs.carryMode then toggleRefs.carryMode(true) end
        setSpeedMode("Lagger Carry")
    else
        setLaggerMode(false)
        setCarrySpeedMode(true)
    end

    safeSaveConfig()
end

local function disableAutoCarrySpeed()
    if not State._autoCarryFromSteal and not State._waitingForCarryPickup then
        return
    end

    local wasAutoApplied = State._autoCarryFromSteal == true
    local returnMode = State._autoCarryReturnMode

    State._autoCarryFromSteal = false
    State._waitingForCarryPickup = false
    State._autoCarryGraceUntil = 0
    State._carryPickupWatchUntil = 0
    State._autoCarryReturnMode = nil

    if not wasAutoApplied then
        return
    end

    if returnMode == "Lagger" or returnMode == "Lagger Carry" then
        State.laggerEnabled = true
        State.speedToggled = false
        if toggleRefs.laggerMode then toggleRefs.laggerMode(true) end
        if toggleRefs.carryMode then toggleRefs.carryMode(false) end
        setSpeedMode("Lagger")
    elseif returnMode == "Carry" then
        State.laggerEnabled = false
        State.speedToggled = true
        if toggleRefs.laggerMode then toggleRefs.laggerMode(false) end
        if toggleRefs.carryMode then toggleRefs.carryMode(true) end
        setSpeedMode("Carry")
    else
        setLaggerMode(false)
        setCarrySpeedMode(false)
    end

    safeSaveConfig()
end

local function startAutoCarryPickupWatch(seconds)
    if autoCarrySpeedEnabled ~= true then return end
    State._waitingForCarryPickup = true
    State._carryPickupWatchUntil = tick() + (seconds or 1.25)
end

local _stealAttrWasActive = false
RunService.RenderStepped:Connect(function()
    if autoCarrySpeedEnabled ~= true then
        disableAutoCarrySpeed()
        return
    end

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root then
        disableAutoCarrySpeed()
        _stealAttrWasActive = false
        return
    end

    local st = hum:GetState()
    local gotHit = st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown

    local stealingAttr = LP:GetAttribute("Stealing") == true
    local carryingBrainrot = isCarryingBrainrot(char)

    if stealingAttr and not _stealAttrWasActive then
        _stealAttrWasActive = true
        enableCarrySpeedForSteal()
    elseif not stealingAttr then
        _stealAttrWasActive = false
    end

    if State._waitingForCarryPickup then
        if gotHit or tick() > (State._carryPickupWatchUntil or 0) then
            State._waitingForCarryPickup = false
            State._carryPickupWatchUntil = 0
        elseif carryingBrainrot then
            enableCarrySpeedForSteal()
        end
    end

    if carryingBrainrot and not State._autoCarryFromSteal then
        enableCarrySpeedForSteal()
    end

    if State._autoCarryFromSteal then
        local graceDone = tick() > (State._autoCarryGraceUntil or 0)
        if gotHit or (graceDone and not carryingBrainrot and not stealingAttr) then
            disableAutoCarrySpeed()
        end
    end
end)

_G.AutoCarrySpeed = {
    IsCarryingBrainrot = isCarryingBrainrot,
    Enable = enableCarrySpeedForSteal,
    Disable = disableAutoCarrySpeed,
    WatchPickup = startAutoCarryPickupWatch,
}

_G.ExeAutoPathState = _G.ExeAutoPathState or {leftConn=nil,rightConn=nil,leftPhase=1,rightPhase=1}
_G.ExeAutoPathPoints = _G.ExeAutoPathPoints or {
L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), LFace=Vector3.new(-482.25,-4.96,92.09),
R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), RFace=Vector3.new(-482.06,-6.93,35.47),
}
function _G.ExeAutoPathSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return LAGGER_SPEED
end
return NS
end
function _G.ExeStopAutoLeft()
local S=_G.ExeAutoPathState
if S.leftConn then S.leftConn:Disconnect(); S.leftConn=nil end
S.leftPhase=1
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if hum then hum:Move(Vector3.zero,false) end
if hrp then hrp.AssemblyLinearVelocity=Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0) end
end
function _G.ExeStopAutoRight()
local S=_G.ExeAutoPathState
if S.rightConn then S.rightConn:Disconnect(); S.rightConn=nil end
S.rightPhase=1
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if hum then hum:Move(Vector3.zero,false) end
if hrp then hrp.AssemblyLinearVelocity=Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0) end
end
function _G.ExeSetAutoLeft(on, skipSave)
if on and _G.ExeSafeModeTryStart and not _G.ExeSafeModeTryStart() then
autoLeftEnabled = false
if _G.ExeSetAutoLeftVisual then _G.ExeSetAutoLeftVisual(false) end
if not skipSave and saveExeConfig then pcall(saveExeConfig) end
return false
end
autoLeftEnabled = on and true or false
if _G.ExeSetAutoLeftVisual then _G.ExeSetAutoLeftVisual(autoLeftEnabled) end
if autoLeftEnabled then
autoRightEnabled=false
if _G.ExeSetAutoRightVisual then _G.ExeSetAutoRightVisual(false) end
if _G.ExeStopAutoRight then _G.ExeStopAutoRight() end
if _G.ExeStartAutoLeft then _G.ExeStartAutoLeft() end
else
if _G.ExeStopAutoLeft then _G.ExeStopAutoLeft() end
end
if not skipSave and saveExeConfig then pcall(saveExeConfig) end
end
function _G.ExeSetAutoRight(on, skipSave)
if on and _G.ExeSafeModeTryStart and not _G.ExeSafeModeTryStart() then
autoRightEnabled = false
if _G.ExeSetAutoRightVisual then _G.ExeSetAutoRightVisual(false) end
if not skipSave and saveExeConfig then pcall(saveExeConfig) end
return false
end
autoRightEnabled = on and true or false
if _G.ExeSetAutoRightVisual then _G.ExeSetAutoRightVisual(autoRightEnabled) end
if autoRightEnabled then
autoLeftEnabled=false
if _G.ExeSetAutoLeftVisual then _G.ExeSetAutoLeftVisual(false) end
if _G.ExeStopAutoLeft then _G.ExeStopAutoLeft() end
if _G.ExeStartAutoRight then _G.ExeStartAutoRight() end
else
if _G.ExeStopAutoRight then _G.ExeStopAutoRight() end
end
if not skipSave and saveExeConfig then pcall(saveExeConfig) end
end

_G.ExeZombieMove = _G.ExeZombieMove or {
    leftConn = nil,
    rightConn = nil,
    leftPhase = 1,
    rightPhase = 1,
    attachment = nil,
    linearVelocity = nil,
}

_G.ExeAutoMoveSpeed = tonumber(_G.ExeAutoMoveSpeed) or 60
_G.ExeAutoMoveCarrySpeed = tonumber(_G.ExeAutoMoveCarrySpeed) or 30
_G.ExeDuelMode = (_G.ExeDuelMode == "full") and "full" or "half"

_G.ExeZombieMovePoints = _G.ExeZombieMovePoints or {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    LFace = Vector3.new(-482.25, -4.96, 92.09),

    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
    RFace = Vector3.new(-482.06, -6.93, 35.47),

    FullLeft = {
        Vector3.new(-474.0, -7.3, 90.2),
        Vector3.new(-484.9, -5.1, 97.2),
        Vector3.new(-473.6, -7.3, 93.5),
        Vector3.new(-473.0, -7.3, 27.6),
        Vector3.new(-487.2, -5.3, 20.9),
    },

    FullRight = {
        Vector3.new(-472.5, -7.3, 30.9),
        Vector3.new(-483.8, -5.4, 25.5),
        Vector3.new(-472.4, -7.3, 30.5),
        Vector3.new(-472.0, -7.3, 93.6),
        Vector3.new(-482.8, -5.4, 97.8),
    }
}

function _G.ExeZombieEnsureLinearVelocity(hrp)
    local S = _G.ExeZombieMove

    if S.linearVelocity and S.linearVelocity.Parent and S.attachment and S.attachment.Parent == hrp then
        return S.linearVelocity
    end

    if S.linearVelocity then
        pcall(function() S.linearVelocity:Destroy() end)
    end
    if S.attachment then
        pcall(function() S.attachment:Destroy() end)
    end

    local att = Instance.new("Attachment")
    att.Name = "ExeZombieMoveAttachment"
    att.Parent = hrp

    local lv = Instance.new("LinearVelocity")
    lv.Name = "ExeZombieMoveVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
    lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
    lv.VectorVelocity = Vector3.zero
    lv.Parent = att

    S.attachment = att
    S.linearVelocity = lv
    return lv
end

function _G.ExeZombieStopVelocity()
    local S = _G.ExeZombieMove
    if S.linearVelocity and S.linearVelocity.Parent then
        S.linearVelocity.VectorVelocity = Vector3.zero
        S.linearVelocity.MaxAxesForce = Vector3.zero
        S.linearVelocity.Enabled = false
    end
end

function _G.ExeStopAutoLeft()
    local S = _G.ExeZombieMove
    if S.leftConn then
        S.leftConn:Disconnect()
        S.leftConn = nil
    end
    S.leftPhase = 1

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    _G.ExeZombieStopVelocity()

    if _G.ExeSetAutoLeftVisual then
        pcall(function() _G.ExeSetAutoLeftVisual(false) end)
    end
end

function _G.ExeStopAutoRight()
    local S = _G.ExeZombieMove
    if S.rightConn then
        S.rightConn:Disconnect()
        S.rightConn = nil
    end
    S.rightPhase = 1

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    _G.ExeZombieStopVelocity()

    if _G.ExeSetAutoRightVisual then
        pcall(function() _G.ExeSetAutoRightVisual(false) end)
    end
end

function _G.ExeZombieMoveIsFull()
    return (_G.ExeDuelMode == "full")
        or (_G.ExeDuelMode == "Full")
        or (typeof(State) == "table" and State.duelMode == "full")
end

function _G.ExeStartAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        _G.ExeStopAutoRight()
    end

    local S = _G.ExeZombieMove
    if S.leftConn then S.leftConn:Disconnect() end
    S.leftPhase = 1

    S.leftConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        if dropBrainrotActive then return end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local st = hum:GetState()
        if hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false)
            _G.ExeZombieStopVelocity()
            return
        end

        local lv = _G.ExeZombieEnsureLinearVelocity(hrp)
        lv.Enabled = true
        lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
        local P = _G.ExeZombieMovePoints
        local spd = tonumber(_G.ExeAutoMoveSpeed) or NS or 60

        if _G.ExeZombieMoveIsFull() then
            local points = P.FullLeft
            if S.leftPhase > #points then
                _G.ExeZombieStopVelocity()
                local prev = points[#points - 1] or points[#points]
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(prev.X, hrp.Position.Y, prev.Z))
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                hum:Move(Vector3.zero, false)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                autoLeftEnabled = false
                if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
                S.leftPhase = 1
                if _G.ExeSetAutoLeftVisual then _G.ExeSetAutoLeftVisual(false) end
                return
            end

            local tgt = points[S.leftPhase]
            local flat = Vector3.new(tgt.X, hrp.Position.Y, tgt.Z)
            if (flat - hrp.Position).Magnitude < 1 then
                S.leftPhase += 1
                return
            end

            local dir = (flat - hrp.Position).Unit
            local fspd = (S.leftPhase <= 2)
                and (tonumber(_G.ExeAutoMoveSpeed) or 60)
                or (tonumber(_G.ExeAutoMoveCarrySpeed) or 30)

            lv.VectorVelocity = Vector3.new(dir.X * fspd, 0, dir.Z * fspd)
        else
            if S.leftPhase == 1 then
                local tgt = Vector3.new(P.L1.X, hrp.Position.Y, P.L1.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    S.leftPhase = 2
                    return
                end

                local d = P.L1 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            else
                local tgt = Vector3.new(P.L2.X, hrp.Position.Y, P.L2.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    hum:Move(Vector3.zero, false)
                    _G.ExeZombieStopVelocity()
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    hum:Move(Vector3.zero, false)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    autoLeftEnabled = false
                    if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
                    S.leftPhase = 1
                    if _G.ExeSetAutoLeftVisual then _G.ExeSetAutoLeftVisual(false) end
                    if P.LFace and (P.LFace - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.LFace.X, hrp.Position.Y, P.LFace.Z))
                    end
                    return
                end

                local d = P.L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            end
        end
    end)
end

function _G.ExeStartAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        _G.ExeStopAutoLeft()
    end

    local S = _G.ExeZombieMove
    if S.rightConn then S.rightConn:Disconnect() end
    S.rightPhase = 1

    S.rightConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        if dropBrainrotActive then return end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local st = hum:GetState()
        if hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false)
            _G.ExeZombieStopVelocity()
            return
        end

        local lv = _G.ExeZombieEnsureLinearVelocity(hrp)
        lv.Enabled = true
        lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
        local P = _G.ExeZombieMovePoints
        local spd = tonumber(_G.ExeAutoMoveSpeed) or NS or 60

        if _G.ExeZombieMoveIsFull() then
            local points = P.FullRight
            if S.rightPhase > #points then
                _G.ExeZombieStopVelocity()
                local prev = points[#points - 1] or points[#points]
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(prev.X, hrp.Position.Y, prev.Z))
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                hum:Move(Vector3.zero, false)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                autoRightEnabled = false
                if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
                S.rightPhase = 1
                if _G.ExeSetAutoRightVisual then _G.ExeSetAutoRightVisual(false) end
                return
            end

            local tgt = points[S.rightPhase]
            local flat = Vector3.new(tgt.X, hrp.Position.Y, tgt.Z)
            if (flat - hrp.Position).Magnitude < 1 then
                S.rightPhase += 1
                return
            end

            local dir = (flat - hrp.Position).Unit
            local fspd = (S.rightPhase <= 2)
                and (tonumber(_G.ExeAutoMoveSpeed) or 60)
                or (tonumber(_G.ExeAutoMoveCarrySpeed) or 30)

            lv.VectorVelocity = Vector3.new(dir.X * fspd, 0, dir.Z * fspd)
        else
            if S.rightPhase == 1 then
                local tgt = Vector3.new(P.R1.X, hrp.Position.Y, P.R1.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    S.rightPhase = 2
                    return
                end

                local d = P.R1 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            else
                local tgt = Vector3.new(P.R2.X, hrp.Position.Y, P.R2.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    hum:Move(Vector3.zero, false)
                    _G.ExeZombieStopVelocity()
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    hum:Move(Vector3.zero, false)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    autoRightEnabled = false
                    if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
                    S.rightPhase = 1
                    if _G.ExeSetAutoRightVisual then _G.ExeSetAutoRightVisual(false) end
                    if P.RFace and (P.RFace - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.RFace.X, hrp.Position.Y, P.RFace.Z))
                    end
                    return
                end

                local d = P.R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            end
        end
    end)
end

function _G.ExeSetAutoLeft(on, skipSave)
    autoLeftEnabled = on == true
    if autoLeftEnabled then
        autoRightEnabled = false
        _G.ExeStopAutoRight()
        _G.ExeStartAutoLeft()
    else
        _G.ExeStopAutoLeft()
    end
    if _G.ExeSetAutoLeftVisual then _G.ExeSetAutoLeftVisual(autoLeftEnabled) end
end

function _G.ExeSetAutoRight(on, skipSave)
    autoRightEnabled = on == true
    if autoRightEnabled then
        autoLeftEnabled = false
        _G.ExeStopAutoLeft()
        _G.ExeStartAutoRight()
    else
        _G.ExeStopAutoRight()
    end
    if _G.ExeSetAutoRightVisual then _G.ExeSetAutoRightVisual(autoRightEnabled) end
end

-- Auto Left / Auto Right removed (replaced by Auto Play)
function _G.ExeSetAutoLeft() autoLeftEnabled = false; return false end
function _G.ExeSetAutoRight() autoRightEnabled = false; return false end
autoLeftEnabled = false
autoRightEnabled = false

LP.CharacterAdded:Connect(function()
task.wait(0.5)
if autoLeftEnabled and _G.ExeStartAutoLeft then _G.ExeStartAutoLeft() end
if autoRightEnabled and _G.ExeStartAutoRight then _G.ExeStartAutoRight() end
end)
local overheadGui = nil
local overheadSpeedLabel = nil
speedLabel = nil

local function addShimmerToLabel(lbl, color1, color2)
    local gr = Instance.new("UIGradient", lbl)
    gr.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(0.5, color2 or Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, color1 or Color3.fromRGB(200, 200, 200))
    })
    gr.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3, 0),
        NumberSequenceKeypoint.new(0.5, 0, 0),
        NumberSequenceKeypoint.new(1, 0.3, 0)
    })
    return gr
end

local function getSpeedThemeColors()
    local accent = Color3.fromRGB(255, 255, 255)
    local accent2 = Color3.fromRGB(200, 200, 200)
    local gray = Color3.fromRGB(170, 170, 175)
    return accent, accent2, gray
end

local function applySpeedIndicatorTheme()
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local bb = head:FindFirstChild("EXESpeedBB")
    if not bb then return end

    local accent, accent2, gray = getSpeedThemeColors()

    for _, lbl in ipairs(bb:GetChildren()) do
        if lbl:IsA("TextLabel") then
            if lbl.Name == "DiscordLbl" then
                lbl.TextColor3 = gray
                local gr = lbl:FindFirstChildOfClass("UIGradient")
                if gr then
                    gr.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, gray),
                        ColorSequenceKeypoint.new(0.5, accent),
                        ColorSequenceKeypoint.new(1, gray)
                    })
                end
            else
                lbl.TextColor3 = accent
                local gr = lbl:FindFirstChildOfClass("UIGradient")
                if gr then
                    gr.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, accent2),
                        ColorSequenceKeypoint.new(0.5, accent),
                        ColorSequenceKeypoint.new(1, accent2)
                    })
                end
            end
        end
    end
end

local function setupSpeedIndicator(char)
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end

    pcall(function()
        local old = head:FindFirstChild("EXESpeedBB")
        if old then old:Destroy() end
        local old2 = head:FindFirstChild("ExeDuelsOverheadInfo")
        if old2 then old2:Destroy() end
    end)

    if overheadGui then
        pcall(function() overheadGui:Destroy() end)
        overheadGui = nil
    end
    speedLabel = nil
    overheadSpeedLabel = nil

    local accent, accent2, gray = getSpeedThemeColors()

    local bb = Instance.new("BillboardGui")
    bb.Name = "EXESpeedBB"
    bb.Size = UDim2.new(0, 130, 0, 48)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 80
    bb.Parent = head
    overheadGui = bb

    local discordLabel = Instance.new("TextLabel", bb)
    discordLabel.Name = "DiscordLbl"
    discordLabel.Size = UDim2.new(1, 0, 0.38, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "discord.gg/YF8vD7w6m"
    discordLabel.TextColor3 = gray
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextScaled = true
    discordLabel.TextStrokeTransparency = 0.4

    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Name = "SpeedLbl"
    speedLabel.Size = UDim2.new(1, 0, 0.55, 0)
    speedLabel.Position = UDim2.new(0, 0, 0.38, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0.0"
    speedLabel.TextColor3 = accent
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0.35
    overheadSpeedLabel = speedLabel

    local gr1 = addShimmerToLabel(speedLabel, accent2, accent)
    local gr2 = addShimmerToLabel(discordLabel, gray, accent)

    task.spawn(function()
        local t = 0
        while bb and bb.Parent do
            t = t + 0.03
            pcall(function()
                gr1.Offset = Vector2.new(math.sin(t) * 0.4, 0)
                gr2.Offset = Vector2.new(math.sin(t) * 0.4, 0)
            end)
            task.wait(0.05)
        end
    end)
end

local function setupOverheadInfo(char)
    setupSpeedIndicator(char)
end

-- keep ragdoll countdown helpers (label is optional/nil-safe)
ragdollCountdownLabel = nil
local ragdollCountdownConn = nil
local ragdollCountdownCharConn = nil
local ragdollCountdownEndTime = 0
local RAGDOLL_COUNTDOWN_SECONDS = 3.0

local function isRagdollStateForCountdown()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local st = hum:GetState()
    if hum.PlatformStand then return true end
    if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
        return true
    end
    local endTime = LP:GetAttribute("RagdollEndTime")
    if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
        return true
    end
    return false
end

local function beginCountdown()
    ragdollCountdownEndTime = tick() + RAGDOLL_COUNTDOWN_SECONDS
end

local function hookRagdollCountdown(char)
    if ragdollCountdownConn then
        pcall(function() ragdollCountdownConn:Disconnect() end)
        ragdollCountdownConn = nil
    end
    if not ragdollCountdownEnabled then return end
    beginCountdown()
    ragdollCountdownConn = RunService.Heartbeat:Connect(function()
        if not ragdollCountdownEnabled then return end
        if isRagdollStateForCountdown() and ragdollCountdownEndTime < tick() then
            beginCountdown()
        end
    end)
end

local function stopRagdollCountdown()
    if ragdollCountdownConn then
        pcall(function() ragdollCountdownConn:Disconnect() end)
        ragdollCountdownConn = nil
    end
end

if LP.Character then
    task.spawn(function()
        setupSpeedIndicator(LP.Character)
        task.wait(0.05)
        if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) end
    end)
end
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupSpeedIndicator(char)
    if ragdollCountdownEnabled then hookRagdollCountdown(char) end
end)

-- K7-style impulse speed booster (no BodyForce)
RunService.Heartbeat:Connect(function(dt)
    _moveDt = dt
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if isRagdollState(hum) then
        lastMoveDir = Vector3.new(0, 0, 0)
        _speedActive = false
        _lastHorizSpeed = 0
        brakeHorizontal(hrp)
        return
    end

    if not speedBoosterEnabled then
        return
    end

    local spd = getActiveMoveSpeed()
    local autoBatEnabled = (_G.ExeNormalAimbotOn == true) or (_G.ExeAntiBypassAimbotOn == true)
        or (_G.ExeBatV2On == true)
        or (_G.ExeAntiBatBypassOn == true) or (_G.ExeAutoPlayOn == true)
    local tpBatEnabled = (_G.ExeAntiDesyncAimbotOn == true)
    local controlled = not autoBatEnabled and not tpBatEnabled
        and not autoLeftEnabled and not autoRightEnabled

    pcall(function()
        if hum.CameraOffset.Magnitude > 0.05 then
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end
    end)

    if controlled then
        local md = hum.MoveDirection
        if md.Magnitude > 0.05 then
            lastMoveDir = Vector3.new(md.X, 0, md.Z).Unit
            setSpeedConstraint(hrp, lastMoveDir * spd)
        else
            _speedActive = false
            _lastHorizSpeed = 0
            brakeHorizontal(hrp)
        end
    elseif not autoBatEnabled then
        brakeHorizontal(hrp)
    end
    -- while any bat aimbot / auto play is on, it owns the velocity and runs only at the
    -- speed set in its own speed setting (no running-speed / brake interference)

    if speedLabel or overheadSpeedLabel then
        local lbl = speedLabel or overheadSpeedLabel
        local display = 0
        if controlled and lastMoveDir and lastMoveDir.Magnitude > 0.05 and speedBoosterEnabled then
            display = getActiveMoveSpeed()
        else
            local v = hrp.AssemblyLinearVelocity
            display = Vector3.new(v.X, 0, v.Z).Magnitude
        end
        local rounded = math.floor(display * 10 + 0.5) / 10
        lbl.Text = string.format("%.1f", rounded)
    end
end)
local COLORS = {
bg = Color3.fromRGB(5, 10, 24),
row = Color3.fromRGB(10, 22, 42),
row2 = Color3.fromRGB(17, 34, 59),
stroke = Color3.fromRGB(145, 205, 255),
strokeSoft = Color3.fromRGB(55, 115, 180),
white = Color3.fromRGB(248, 252, 255),
textDim = Color3.fromRGB(175, 210, 245),
toggleBg = Color3.fromRGB(20, 43, 72),
knob = Color3.fromRGB(245, 250, 255),
accent = Color3.fromRGB(105, 185, 255),
accentSoft = Color3.fromRGB(205, 235, 255),
}
function corner(parent, radius)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, radius or 8)
c.Parent = parent
return c
end
function stroke(parent, color, thickness, transparency)
local s = Instance.new("UIStroke")
s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
s.Color = color or COLORS.accent or COLORS.stroke
s.Thickness = thickness or 1.2
s.Transparency = transparency or 0.25
s.Parent = parent
return s
end
function tween(obj, props, time)
TweenService:Create(obj, TweenInfo.new(time or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function _G.ExeAddMovingEdgeLight(btn)
if not btn or not btn:IsA("GuiButton") then return end
if btn.Name ~= "ArrowButton" then return end
if btn:FindFirstChild("ExeMovingEdge") then return end

local edge = Instance.new("UIStroke")
edge.Name = "ExeMovingEdge"
edge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
edge.Color = Color3.fromRGB(255,255,255)
edge.Thickness = 1.35
edge.Transparency = 0.24
edge.LineJoinMode = Enum.LineJoinMode.Round
edge.Parent = btn

local grad = Instance.new("UIGradient")
grad.Name = "MovingLight"
grad.Rotation = 0
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0.00, Color3.fromRGB(95,95,95)),
ColorSequenceKeypoint.new(0.38, Color3.fromRGB(125,125,125)),
ColorSequenceKeypoint.new(0.46, Color3.fromRGB(235,235,235)),
ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.54, Color3.fromRGB(235,235,235)),
ColorSequenceKeypoint.new(0.62, Color3.fromRGB(125,125,125)),
ColorSequenceKeypoint.new(1.00, Color3.fromRGB(95,95,95))
})
grad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0.00, 0.90),
NumberSequenceKeypoint.new(0.37, 0.82),
NumberSequenceKeypoint.new(0.45, 0.28),
NumberSequenceKeypoint.new(0.50, 0.00),
NumberSequenceKeypoint.new(0.55, 0.28),
NumberSequenceKeypoint.new(0.63, 0.82),
NumberSequenceKeypoint.new(1.00, 0.90)
})
grad.Parent = edge

local info = TweenInfo.new(1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0)
pcall(function()
TweenService:Create(grad, info, {Rotation = 360}):Play()
end)
end

function _G.ExeApplyMovingEdgeLights(root)
root = root or PlayerGui
if not root then return end

for _, obj in ipairs(root:GetDescendants()) do
if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Name == "ArrowButton" then
pcall(function() _G.ExeAddMovingEdgeLight(obj) end)
end
end

root.DescendantAdded:Connect(function(obj)
if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Name == "ArrowButton" then
task.defer(function()
task.wait()
pcall(function() _G.ExeAddMovingEdgeLight(obj) end)
end)
end
end)
end

function makeDraggable(frame)
local dragging = false
local dragStart
local startPos
local dragInput
frame.InputBegan:Connect(function(input)
if _G.ExeGuiLocked == true then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = frame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)
frame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)
UserInputService.InputChanged:Connect(function(input)
if _G.ExeGuiLocked == true then return end
if input == dragInput and dragging then
local delta = input.Position - dragStart
frame.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)
end
end)
end
local Gui = Instance.new("ScreenGui")
Gui.Name = "StaticHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 999
safeParentGui(Gui)
local FULL_MAIN_SIZE = UDim2.new(0, 480, 0, 520)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = FULL_MAIN_SIZE
Main.Position = tableToUDim2(savedMainPositionTable, UDim2.new(0.5, 0, 0.5, 0))
savedMainPositionTable = savedMainPositionTable or udim2ToTable(Main.Position)

-- ExeOpenMainUI / ExeCloseMainUI defined after MiniFrame

Main.BackgroundColor3 = Color3.fromRGB(4, 3, 8)
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = false
Main.Parent = Gui
corner(Main, 22)
stroke(Main, Color3.fromRGB(139, 75, 220), 1.5, 0.08)

-- STATIC DUELS: blue-chrome starfield background.
-- To show Gojo, upload your chosen Gojo artwork to Roblox and set GOJO_IMAGE_ID
-- to its numeric asset ID below. No external/local image can render directly in a Roblox GUI.
local GOJO_IMAGE_ID = 0 -- Example: 1234567890 (replace with your uploaded Roblox image asset ID)
local GojoBackdrop = Instance.new("ImageLabel")
GojoBackdrop.Name = "GojoBackdrop"
GojoBackdrop.BackgroundTransparency = 1
GojoBackdrop.BorderSizePixel = 0
GojoBackdrop.Size = UDim2.new(1, 0, 1, 0)
GojoBackdrop.Position = UDim2.new(0, 0, 0, 0)
GojoBackdrop.ImageTransparency = 0.78
GojoBackdrop.ScaleType = Enum.ScaleType.Crop
GojoBackdrop.ZIndex = 1
GojoBackdrop.Parent = Main
if GOJO_IMAGE_ID > 0 then
    GojoBackdrop.Image = "rbxassetid://" .. tostring(GOJO_IMAGE_ID)
end

local Starfield = Instance.new("Frame")
Starfield.Name = "ChromeStarfield"
Starfield.BackgroundTransparency = 1
Starfield.BorderSizePixel = 0
Starfield.Size = UDim2.new(1, 0, 1, 0)
Starfield.Position = UDim2.new(0, 0, 0, 0)
Starfield.ClipsDescendants = true
Starfield.ZIndex = 2
Starfield.Parent = Main
-- Black, sharp lightning streaks sit behind the interface content.
local lightningRng = Random.new(38104)
for streakIndex = 1, 7 do
    local x = lightningRng:NextNumber(0.04, 0.88)
    local y = lightningRng:NextNumber(0.08, 0.88)
    local baseRotation = lightningRng:NextInteger(-28, 28)
    for segmentIndex = 1, 3 do
        local segment = Instance.new("Frame")
        segment.Name = "BlackLightning_" .. streakIndex .. "_" .. segmentIndex
        segment.AnchorPoint = Vector2.new(0.5, 0.5)
        segment.Position = UDim2.new(x + (segmentIndex - 1) * 0.012, 0, y + (segmentIndex - 1) * 0.025, 0)
        segment.Size = UDim2.new(0, lightningRng:NextInteger(24, 54), 0, lightningRng:NextInteger(2, 3))
        segment.Rotation = baseRotation + ((segmentIndex % 2 == 0) and 38 or -24)
        segment.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        segment.BackgroundTransparency = lightningRng:NextNumber(0.18, 0.38)
        segment.BorderSizePixel = 0
        segment.ZIndex = 3
        segment.Parent = Starfield
    end
end
local starRng = Random.new(61427)
for i = 1, 42 do
    local star = Instance.new("TextLabel")
    star.Name = "ChromeStar" .. i
    star.BackgroundTransparency = 1
    star.BorderSizePixel = 0
    star.Text = (i % 7 == 0) and "✦" or "·"
    star.Font = Enum.Font.GothamBold
    star.TextColor3 = (i % 3 == 0) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(174, 112, 255)
    star.TextTransparency = (i % 4 == 0) and 0.18 or 0.42
    star.TextSize = starRng:NextInteger(9, 18)
    star.Size = UDim2.new(0, 20, 0, 20)
    star.Position = UDim2.new(starRng:NextNumber(0.02, 0.94), 0, starRng:NextNumber(0.02, 0.94), 0)
    star.ZIndex = 2
    star.Parent = Starfield
end

-- UI idle transparency: after 5s without interaction, toggles fade a bit
_G.ExeUILastInteract = tick()
_G.ExeUIIdleTransparent = false
local function _exeSetUIIdle(transparent)
    if _G.ExeUIIdleTransparent == transparent then return end
    _G.ExeUIIdleTransparent = transparent
    local targetRowT = transparent and 0.82 or 0.3
    local targetStrokeT = transparent and 0.78 or 0.38
    local targetToggleT = transparent and 0.72 or 0.2
    pcall(function()
        for _, obj in ipairs(Main:GetDescendants()) do
            if obj:IsA("Frame") and obj:FindFirstChild("ToggleButton") then
                TweenService:Create(obj, TweenInfo.new(0.35), {BackgroundTransparency = targetRowT}):Play()
                local st = obj:FindFirstChildOfClass("UIStroke")
                if st then
                    TweenService:Create(st, TweenInfo.new(0.35), {Transparency = targetStrokeT}):Play()
                end
                local track = obj:FindFirstChild("Track", true)
                if track and track:IsA("Frame") then
                    TweenService:Create(track, TweenInfo.new(0.35), {BackgroundTransparency = targetToggleT}):Play()
                end
            elseif obj:IsA("Frame") and obj.Name ~= "Main" and obj.Parent and (obj.Parent.Name == "MOVEMENT" or obj.Parent.Name == "COMBAT" or obj.Parent.Name == "UTILITY" or obj.Parent.Name == "SETTINGS" or obj.Parent.Name == "KEYBINDS" or obj.Parent.Name == "MENU CUSTOMIZE" or obj.Parent == Main) then
                -- fade general setting rows slightly
                if obj:FindFirstChild("Label") and not obj:FindFirstChild("ToggleButton") then
                    local baseT = obj:GetAttribute("ExeBaseTransparency")
                    if baseT == nil then
                        obj:SetAttribute("ExeBaseTransparency", obj.BackgroundTransparency)
                        baseT = obj.BackgroundTransparency
                    end
                    local t = transparent and math.min(0.9, (baseT or 0.3) + 0.45) or (baseT or 0.3)
                    TweenService:Create(obj, TweenInfo.new(0.35), {BackgroundTransparency = t}):Play()
                end
            end
        end
    end)
end
function _G.ExeUIWake()
    _G.ExeUILastInteract = tick()
    _exeSetUIIdle(false)
end
task.spawn(function()
    while Main and Main.Parent do
        if tick() - (_G.ExeUILastInteract or tick()) >= 5 then
            _exeSetUIIdle(true)
        end
        task.wait(0.25)
    end
end)
Main.InputBegan:Connect(function()
    if _G.ExeUIWake then _G.ExeUIWake() end
end)
-- Attach idle-wake signals only to properties that exist on each UI class.
-- TextBox is not a GuiButton, so it has no MouseButton1Down signal.
local function _exeAttachUIWake(d)
    if not d or not (d:IsA("GuiButton") or d:IsA("TextBox")) then return end
    if d:GetAttribute("ExeUIWakeHooked") then return end
    d:SetAttribute("ExeUIWakeHooked", true)

    if d:IsA("GuiButton") then
        d.Activated:Connect(function()
            if _G.ExeUIWake then _G.ExeUIWake() end
        end)
    elseif d:IsA("TextBox") then
        d.Focused:Connect(function()
            if _G.ExeUIWake then _G.ExeUIWake() end
        end)
        d.FocusLost:Connect(function()
            if _G.ExeUIWake then _G.ExeUIWake() end
        end)
    end
end

pcall(function()
    Main.DescendantAdded:Connect(_exeAttachUIWake)
    for _, d in ipairs(Main:GetDescendants()) do
        _exeAttachUIWake(d)
    end
end)

makeDraggable(Main)
local _exeMainSaveToken = 0
Main:GetPropertyChangedSignal("Position"):Connect(function()
    if tick() < (_G.__STATIC_HUBMainTweenUntil or 0) then return end
    savedMainPositionTable = udim2ToTable(Main.Position)
    -- Debounce position persistence so dragging/tweens save the final location, not every frame.
    _exeMainSaveToken = _exeMainSaveToken + 1
    local thisToken = _exeMainSaveToken
    task.delay(0.65, function()
        if thisToken ~= _exeMainSaveToken then return end
        if type(saveExeConfig) == "function" then
            pcall(saveExeConfig)
        end
    end)
end)
local MiniFrame = Instance.new("TextButton")
MiniFrame.Name = "MiniFrame"
local _mobileBtnBase = math.floor((tonumber(_G.ExeMobileButtonScale) or 1) * 58)
-- Compact Static Hub launcher. Upload the Gojo background to Roblox and set MENU_BG_IMAGE_ID.
local miniBtnWidth = math.clamp(math.floor(_mobileBtnBase * 2.55), 112, 148)
local miniBtnHeight = math.clamp(math.floor(_mobileBtnBase * 0.82), 42, 52)
local MENU_BG_IMAGE_ID = 0 -- Replace 0 with the Roblox asset ID for the Gojo image
MiniFrame.Size = UDim2.new(0, miniBtnWidth, 0, miniBtnHeight)
local MINI_DEFAULT_POSITION = UDim2.new(0, 20, 0.5, -miniBtnHeight / 2)
MiniFrame.Position = MINI_DEFAULT_POSITION
MiniFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiniFrame.BackgroundTransparency = 0
MiniFrame.BorderSizePixel = 0
MiniFrame.Text = "STATIC HUB"
MiniFrame.TextColor3 = Color3.fromRGB(0, 0, 0)
MiniFrame.Font = Enum.Font.GothamBlack
MiniFrame.TextSize = math.clamp(math.floor(miniBtnHeight * 0.36), 15, 19)
MiniFrame.AutoButtonColor = false
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.ZIndex = 100
MiniFrame.Parent = Gui
corner(MiniFrame, math.floor(miniBtnHeight * 0.35))
local MiniBackdrop = Instance.new("ImageLabel")
MiniBackdrop.Name = "GojoMenuBackground"
MiniBackdrop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiniBackdrop.BackgroundTransparency = 1
MiniBackdrop.Visible = false
MiniBackdrop.BorderSizePixel = 0
MiniBackdrop.Size = UDim2.fromScale(1, 1)
MiniBackdrop.Position = UDim2.fromScale(0, 0)
MiniBackdrop.ScaleType = Enum.ScaleType.Crop
MiniBackdrop.ImageTransparency = 0.08
MiniBackdrop.ZIndex = 99
MiniBackdrop.Parent = MiniFrame
if MENU_BG_IMAGE_ID > 0 then
    MiniBackdrop.Image = "rbxassetid://" .. tostring(MENU_BG_IMAGE_ID)
end
corner(MiniBackdrop, math.floor(miniBtnHeight * 0.35))
local miniChrome = Instance.new("UIGradient")
miniChrome.Rotation = 0
miniChrome.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(62, 91, 255)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(128, 91, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 190, 255)),
})
miniChrome.Parent = MiniFrame
miniChrome.Enabled = false
MiniFrame.BackgroundTransparency = 0
MiniFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiniFrame.TextColor3 = Color3.fromRGB(0, 0, 0)
function _STATIC_HUBClampMini(pos)
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
    local x = pos.X.Scale * vp.X + pos.X.Offset
    local y = pos.Y.Scale * vp.Y + pos.Y.Offset
    x = math.clamp(x, 0, math.max(0, vp.X - miniBtnWidth))
    y = math.clamp(y, 0, math.max(0, vp.Y - miniBtnHeight))
    return UDim2.new(0, x, 0, y)
end
if type(savedMiniPositionTable) == "table" then
    MiniFrame.Position = _STATIC_HUBClampMini(tableToUDim2(savedMiniPositionTable, MINI_DEFAULT_POSITION))
end
local MiniExeStroke = Instance.new("UIStroke")
MiniExeStroke.Color = Color3.fromRGB(0, 0, 0)
MiniExeStroke.Thickness = 1.6
MiniExeStroke.Transparency = 0.04
MiniExeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MiniExeStroke.Parent = MiniFrame
MiniFrame.ClipsDescendants = true
local miniLightning = Instance.new("Frame")
miniLightning.Name = "MiniBlackLightning"
miniLightning.BackgroundTransparency = 1
miniLightning.BorderSizePixel = 0
miniLightning.Size = UDim2.fromScale(1, 1)
miniLightning.ClipsDescendants = true
miniLightning.ZIndex = 101
miniLightning.Parent = MiniFrame
for i = 1, 3 do
    local slash = Instance.new("Frame")
    slash.Name = "MiniLightningStreak" .. i
    slash.AnchorPoint = Vector2.new(0.5, 0.5)
    slash.Position = UDim2.new((i - 1) * 0.34 + 0.18, 0, (i % 2 == 0) and 0.22 or 0.78, 0)
    slash.Size = UDim2.new(0, math.max(16, math.floor(miniBtnWidth * 0.28)), 0, 2)
    slash.Rotation = (i % 2 == 0) and -24 or 24
    slash.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    slash.BackgroundTransparency = 0.12
    slash.BorderSizePixel = 0
    slash.ZIndex = 102
    slash.Parent = miniLightning
end

-- keep MiniButton alias for any old refs
local MiniButton = MiniFrame

do
    local mdn, mds, msp = false, nil, nil
    local miniMoved = false
    local DRAG_DEADZONE = 6

    MiniFrame.InputBegan:Connect(function(i)
        if _G.ExeGuiLocked == true then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            mdn = true
            miniMoved = false
            mds = i.Position
            msp = MiniFrame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    mdn = false
                    if miniMoved then
                        savedMiniPositionTable = udim2ToTable(MiniFrame.Position)
                        if saveExeConfig then pcall(saveExeConfig) end
                    end
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if not mdn then return end
        if _G.ExeGuiLocked == true then mdn = false return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement
        and i.UserInputType ~= Enum.UserInputType.Touch then return end
        if not mds or not msp then return end
        local dx = i.Position.X - mds.X
        local dy = i.Position.Y - mds.Y
        if not miniMoved and (math.abs(dx) > DRAG_DEADZONE or math.abs(dy) > DRAG_DEADZONE) then
            miniMoved = true
        end
        if miniMoved then
            MiniFrame.Position = _STATIC_HUBClampMini(UDim2.new(
                msp.X.Scale, msp.X.Offset + dx,
                msp.Y.Scale, msp.Y.Offset + dy
            ))
        end
    end)

    MiniFrame.MouseButton1Click:Connect(function()
        if miniMoved then miniMoved = false return end
        if _G.ExeOpenMainUI then
            _G.ExeOpenMainUI()
        else
            Main.Visible = true
            MiniFrame.Visible = false
            Main.Size = FULL_MAIN_SIZE
            _G.__ExeDuelsMinimized = false
        end
        if saveExeConfig then pcall(saveExeConfig) end
    end)
end

-- Open / close with side glide (after MiniFrame exists)
local _exeUITween = nil
function _G.ExeOpenMainUI()
    local targetPos = Main.Position
    if savedMainPositionTable then
        pcall(function()
            targetPos = tableToUDim2(savedMainPositionTable, targetPos)
        end)
    end
    Main.Size = FULL_MAIN_SIZE
    if MiniFrame then MiniFrame.Visible = false end
    _G.__ExeDuelsMinimized = false
    local startPos = UDim2.new(
        targetPos.X.Scale,
        targetPos.X.Offset - 460,
        targetPos.Y.Scale,
        targetPos.Y.Offset
    )
    _G.__STATIC_HUBMainTweenUntil = tick() + 0.5
    Main.Position = startPos
    Main.Visible = true
    if _exeUITween then pcall(function() _exeUITween:Cancel() end) end
    _exeUITween = TweenService:Create(
        Main,
        TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Position = targetPos }
    )
    _exeUITween:Play()
    savedMainPositionTable = udim2ToTable(targetPos)
end

function _G.ExeCloseMainUI()
    local curPos = Main.Position
    if savedMainPositionTable then
        pcall(function()
            curPos = tableToUDim2(savedMainPositionTable, curPos)
        end)
    end
    -- remember where it should return
    savedMainPositionTable = udim2ToTable(curPos)
    local outPos = UDim2.new(
        curPos.X.Scale,
        curPos.X.Offset - 460,
        curPos.Y.Scale,
        curPos.Y.Offset
    )
    _G.__STATIC_HUBMainTweenUntil = tick() + 0.5
    if _exeUITween then pcall(function() _exeUITween:Cancel() end) end
    _exeUITween = TweenService:Create(
        Main,
        TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        { Position = outPos }
    )
    _exeUITween:Play()
    _exeUITween.Completed:Connect(function()
        Main.Visible = false
        Main.Position = curPos -- restore logical position for next open
        savedMainPositionTable = udim2ToTable(curPos)
        if type(saveExeConfig) == "function" then pcall(saveExeConfig) end
        if MiniFrame then
            MiniFrame.Visible = true
            -- keep MENU button on left center if no saved pos
            if savedMiniPositionTable then
                MiniFrame.Position = _STATIC_HUBClampMini(tableToUDim2(savedMiniPositionTable, MINI_DEFAULT_POSITION))
            else
                MiniFrame.Position = MINI_DEFAULT_POSITION
            end
        end
        _G.__ExeDuelsMinimized = true
    end)
end

local RandomImageIDs = {
"86947414982221",
}
local BackgroundIDs = RandomImageIDs
local ButtonImageIDs = RandomImageIDs

local function pickRandomImageId()
    return "86947414982221"
end
local _randomBgId = "86947414982221"
_G.ExeMobileButtonImage = ""
_G.ExeStealUIImage = ""

_G.ExeThemeColors = {
PURPLE = Color3.fromRGB(180, 180, 255),
BLUE   = Color3.fromRGB(45, 130, 255),
RED    = Color3.fromRGB(120, 170, 255),
PINK   = Color3.fromRGB(150, 190, 255),
YELLOW = Color3.fromRGB(100, 160, 255),
GREY   = Color3.fromRGB(90, 120, 170),
WHITE  = Color3.fromRGB(220, 235, 255),
FOREST = Color3.fromRGB(40, 100, 190),
}

_G.ExeThemeName = "PURPLE"
currentBackground = tonumber(savedConfig.currentBackground) or currentBackground
_G.ExeBodyLockEnabled = savedConfig.bodyLockEnabled == true
_G.ExeBodyLockRadius = tonumber(savedConfig.bodyLockRadius) or _G.ExeBodyLockRadius or 60
if savedConfig.mobileButtonScale ~= nil then _G.ExeMobileButtonScale = tonumber(savedConfig.mobileButtonScale) or _G.ExeMobileButtonScale or 0.75 end
if savedConfig.guiScaleValue ~= nil then _G.ExeGuiScaleValue = tonumber(savedConfig.guiScaleValue) or _G.ExeGuiScaleValue end
if savedConfig.stealUiScaleValue ~= nil then _G.ExeProgressBarScaleValue = tonumber(savedConfig.stealUiScaleValue) or _G.ExeProgressBarScaleValue end
_G.ExeHeadlessEnabled = savedConfig.headlessEnabled == true
_G.ExeKorbloxEnabled = savedConfig.korbloxEnabled == true
local BgImage = nil
function applyBackground(index)
Main.BackgroundColor3 = Color3.fromRGB(4, 3, 8)
currentBackground = 0
return "None"
end
applyBackground(0)
-- Static Hub header: clean black starfield, purple/white bold lettering.
local HeaderBar = Instance.new("Frame")
HeaderBar.Name = "HeaderBar"
HeaderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeaderBar.BackgroundTransparency = 0.02
HeaderBar.BorderSizePixel = 0
HeaderBar.Size = UDim2.new(1, -20, 0, 56)
HeaderBar.Position = UDim2.new(0, 10, 0, 10)
HeaderBar.ZIndex = 8
HeaderBar.Parent = Main
corner(HeaderBar, 14)
stroke(HeaderBar, Color3.fromRGB(0, 0, 0), 1.4, 0.02)

local HEADER_BG_IMAGE_ID = 0 -- Replace 0 with the Roblox asset ID for the cat image
local HeaderPhoto = Instance.new("ImageLabel")
HeaderPhoto.Name = "CatHeaderBackground"
HeaderPhoto.BackgroundTransparency = 1
HeaderPhoto.BorderSizePixel = 0
HeaderPhoto.Size = UDim2.fromScale(1, 1)
HeaderPhoto.Position = UDim2.fromScale(0, 0)
HeaderPhoto.ScaleType = Enum.ScaleType.Crop
HeaderPhoto.ImageTransparency = 1
HeaderPhoto.ZIndex = 8
HeaderPhoto.Parent = HeaderBar
if HEADER_BG_IMAGE_ID > 0 then
    HeaderPhoto.Image = "rbxassetid://" .. tostring(HEADER_BG_IMAGE_ID)
end
corner(HeaderPhoto, 14)

local HeaderStars = Instance.new("Frame")
HeaderStars.Name = "HeaderStars"
HeaderStars.BackgroundTransparency = 1
HeaderStars.BorderSizePixel = 0
HeaderStars.Size = UDim2.new(1, 0, 1, 0)
HeaderStars.ClipsDescendants = true
HeaderStars.ZIndex = 9
HeaderStars.Visible = false
HeaderStars.Parent = HeaderBar
local headerStarRng = Random.new(82631)
for i = 1, 22 do
    local star = Instance.new("TextLabel")
    star.Name = "HeaderStar" .. i
    star.BackgroundTransparency = 1
    star.BorderSizePixel = 0
    star.Text = (i % 6 == 0) and "✦" or "·"
    star.Font = Enum.Font.GothamBold
    star.TextColor3 = (i % 3 == 0) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(174, 112, 255)
    star.TextTransparency = 0.3
    star.TextSize = headerStarRng:NextInteger(8, 14)
    star.Size = UDim2.new(0, 16, 0, 16)
    star.Position = UDim2.new(headerStarRng:NextNumber(0.02, 0.96), 0, headerStarRng:NextNumber(0.05, 0.85), 0)
    star.ZIndex = 9
    star.Parent = HeaderStars
end

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -34, 1, -4)
Title.Position = UDim2.new(0, 22, 0, 2)
Title.Text = "STATIC HUB"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.TextStrokeColor3 = Color3.fromRGB(145, 70, 220)
Title.TextStrokeTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 29
Title.TextScaled = false
Title.TextTruncate = Enum.TextTruncate.AtEnd
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = HeaderBar

local TitleChromeGradient = Instance.new("UIGradient")
TitleChromeGradient.Name = "PurpleWhiteLettering"
TitleChromeGradient.Rotation = 90
TitleChromeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(221, 194, 255)),
    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(158, 93, 230)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(250, 245, 255))
})
TitleChromeGradient.Enabled = false
TitleChromeGradient.Parent = Title

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.BackgroundTransparency = 1
SubTitle.Size = UDim2.new(0, 200, 0, 14)
SubTitle.Position = UDim2.new(0, 24, 0, 30)
SubTitle.Text = "discord.gg/YF8vD7w6m"
SubTitle.TextColor3 = Color3.fromRGB(190, 155, 235)
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 12
SubTitle.Parent = HeaderBar
SubTitle.Visible = false

-- Main logo removed (Calcium-style header text only)
local ExeLogoAsset = nil

local TitleSweepText = Title:Clone()
TitleSweepText.Name = "TitleSweepText"
TitleSweepText.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleSweepText.TextTransparency = 0
TitleSweepText.TextStrokeTransparency = 1
TitleSweepText.BackgroundTransparency = 1
TitleSweepText.ZIndex = Title.ZIndex + 1
TitleSweepText.Visible = false -- logo sweep disabled
TitleSweepText.Parent = Main

local SweepGradient = Instance.new("UIGradient")
SweepGradient.Rotation = 12
SweepGradient.Offset = Vector2.new(-1.25, 0)
SweepGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.00, 1),
    NumberSequenceKeypoint.new(0.43, 1),
    NumberSequenceKeypoint.new(0.49, 0.55),
    NumberSequenceKeypoint.new(0.50, 0.00),
    NumberSequenceKeypoint.new(0.51, 0.55),
    NumberSequenceKeypoint.new(0.57, 1),
    NumberSequenceKeypoint.new(1.00, 1)
})
SweepGradient.Parent = TitleSweepText

task.spawn(function()
    while false do
        SweepGradient.Offset = Vector2.new(-1.25, 0)
        local sweepTween = TweenService:Create(
            SweepGradient,
            TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Offset = Vector2.new(1.25, 0)}
        )
        sweepTween:Play()
        sweepTween.Completed:Wait()
        task.wait(1.2)
    end
end)
-- Line separator under discord link
local HeaderDivider = Instance.new("Frame")
HeaderDivider.Name = "HeaderDivider"
HeaderDivider.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
HeaderDivider.BackgroundTransparency = 0.05
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Size = UDim2.new(1, -32, 0, 1)
HeaderDivider.Position = UDim2.new(0, 16, 0, 58)
HeaderDivider.ZIndex = 7
HeaderDivider.Visible = false
HeaderDivider.Parent = Main
local HeaderDividerGrad = Instance.new("UIGradient")
HeaderDividerGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.85),
    NumberSequenceKeypoint.new(0.12, 0.15),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(0.88, 0.15),
    NumberSequenceKeypoint.new(1, 0.85),
})
HeaderDividerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})
HeaderDividerGrad.Parent = HeaderDivider
-- Soft glow under the line for extra visibility
local HeaderDividerGlow = Instance.new("Frame")
HeaderDividerGlow.Name = "HeaderDividerGlow"
HeaderDividerGlow.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
HeaderDividerGlow.BackgroundTransparency = 0.82
HeaderDividerGlow.BorderSizePixel = 0
HeaderDividerGlow.Size = UDim2.new(1, -48, 0, 4)
HeaderDividerGlow.Position = UDim2.new(0, 24, 0, 56)
HeaderDividerGlow.ZIndex = 6
HeaderDividerGlow.Visible = false
HeaderDividerGlow.Parent = Main
local HeaderDividerGlowGrad = Instance.new("UIGradient")
HeaderDividerGlowGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 1),
})
HeaderDividerGlowGrad.Parent = HeaderDividerGlow
local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Close.BackgroundTransparency = 0
Close.BorderSizePixel = 0
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(220, 220, 225)
Close.TextSize = 12
Close.Font = Enum.Font.GothamBold
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -40, 0.5, -14)
Close.AutoButtonColor = false
Close.ZIndex = 12
Close.Parent = HeaderBar
corner(Close, 999)
stroke(Close, Color3.fromRGB(60, 60, 65), 1.0, 0.35)

local LockBtn = Instance.new("TextButton")
LockBtn.Name = "LockBtn"
LockBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LockBtn.BorderSizePixel = 0
LockBtn.Text = "UNLOCKED"
LockBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
LockBtn.TextSize = 9
LockBtn.Font = Enum.Font.GothamBold
LockBtn.Size = UDim2.new(0, 72, 0, 28)
LockBtn.Position = UDim2.new(1, -118, 0.5, -14)
LockBtn.AutoButtonColor = false
LockBtn.ZIndex = 12
LockBtn.Parent = HeaderBar
corner(LockBtn, 999)
local LockBtnStroke = Instance.new("UIStroke")
LockBtnStroke.Color = Color3.fromRGB(120, 120, 120)
LockBtnStroke.Thickness = 1.0
LockBtnStroke.Transparency = 0.25
LockBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
LockBtnStroke.Parent = LockBtn
local function refreshLockBtn()
    local locked = _G.ExeGuiLocked == true
    LockBtn.Text = locked and "LOCKED" or "UNLOCKED"
    LockBtn.Size = UDim2.new(0, 72, 0, 28)
    LockBtn.Position = UDim2.new(1, -118, 0.5, -14)
    if locked then
        -- locked = gray filled
        LockBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        LockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        LockBtnStroke.Color = Color3.fromRGB(180, 180, 180)
        LockBtnStroke.Transparency = 0.1
    else
        -- unlocked = black
        LockBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        LockBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        LockBtnStroke.Color = Color3.fromRGB(120, 120, 120)
        LockBtnStroke.Transparency = 0.25
    end
end
function ExeUpdateGuiLockVisual()
    refreshLockBtn()
    if setLockGuiVisual then
        pcall(setLockGuiVisual, _G.ExeGuiLocked == true)
    end
end
_G.ExeUpdateGuiLockVisual = ExeUpdateGuiLockVisual
refreshLockBtn()
LockBtn.MouseButton1Click:Connect(function()
    _G.ExeGuiLocked = not (_G.ExeGuiLocked == true)
    refreshLockBtn()
    if setLockGuiVisual then pcall(setLockGuiVisual, _G.ExeGuiLocked == true) end
    if saveExeConfig then pcall(saveExeConfig) end
end)
-- Nine Duels style: profile in header, horizontal tabs, full-width content
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.Visible = false
Sidebar.Size = UDim2.new(0, 0, 0, 0)
Sidebar.Parent = Main

-- Profile in header (right of title, left of lock)
local ProfileCard = Instance.new("Frame")
ProfileCard.Name = "ProfileCard"
ProfileCard.BackgroundTransparency = 1
ProfileCard.BorderSizePixel = 0
ProfileCard.Size = UDim2.new(0, 140, 0, 40)
ProfileCard.Position = UDim2.new(1, -270, 0.5, -20)
ProfileCard.ZIndex = 12
ProfileCard.Parent = HeaderBar
ProfileCard.Visible = false -- header avatar/profile removed by request

local Avatar = Instance.new("ImageLabel")
Avatar.Name = "Avatar"
Avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Avatar.BackgroundTransparency = 0
Avatar.BorderSizePixel = 0
Avatar.Size = UDim2.new(0, 32, 0, 32)
Avatar.Position = UDim2.new(1, -32, 0.5, -16)
Avatar.ZIndex = 13
Avatar.ScaleType = Enum.ScaleType.Crop
Avatar.Parent = ProfileCard
corner(Avatar, 999)
stroke(Avatar, Color3.fromRGB(180, 180, 185), 1.4, 0.2)

local ProfileUser = Instance.new("TextLabel")
ProfileUser.Name = "ProfileUser"
ProfileUser.BackgroundTransparency = 1
ProfileUser.Size = UDim2.new(1, -40, 0, 14)
ProfileUser.Position = UDim2.new(0, 0, 0, 4)
ProfileUser.Text = tostring(LP.DisplayName or LP.Name or "Player")
ProfileUser.TextColor3 = Color3.fromRGB(245, 245, 245)
ProfileUser.Font = Enum.Font.GothamBold
ProfileUser.TextSize = 11
ProfileUser.TextXAlignment = Enum.TextXAlignment.Right
ProfileUser.TextTruncate = Enum.TextTruncate.AtEnd
ProfileUser.ZIndex = 13
ProfileUser.Parent = ProfileCard

local ProfileName = Instance.new("TextLabel")
ProfileName.Name = "ProfileName"
ProfileName.BackgroundTransparency = 1
ProfileName.Size = UDim2.new(1, -40, 0, 12)
ProfileName.Position = UDim2.new(0, 0, 0, 20)
ProfileName.Text = "@" .. tostring(LP.Name or "player")
ProfileName.TextColor3 = Color3.fromRGB(130, 130, 135)
ProfileName.Font = Enum.Font.Gotham
ProfileName.TextSize = 9
ProfileName.TextXAlignment = Enum.TextXAlignment.Right
ProfileName.TextTruncate = Enum.TextTruncate.AtEnd
ProfileName.ZIndex = 13
ProfileName.Parent = ProfileCard

-- Horizontal tab bar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
TabBar.BackgroundTransparency = 0.1
TabBar.BorderSizePixel = 0
TabBar.Size = UDim2.new(1, -20, 0, 40)
TabBar.Position = UDim2.new(0, 10, 0, 74)
TabBar.ZIndex = 6
TabBar.Parent = Main
corner(TabBar, 12)
stroke(TabBar, Color3.fromRGB(40, 40, 45), 1.0, 0.35)

local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.BackgroundTransparency = 1
Tabs.BorderSizePixel = 0
Tabs.Size = UDim2.new(1, -12, 1, -8)
Tabs.Position = UDim2.new(0, 6, 0, 4)
Tabs.ZIndex = 7
Tabs.Parent = TabBar

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 12, 0, 122)
Content.Size = UDim2.new(1, -24, 1, -134)
Content.ZIndex = 3
Content.Parent = Main

task.spawn(function()
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(
            LP.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)
    if ok and url and Avatar and Avatar.Parent then
        Avatar.Image = url
    end
end)

do
local IDLE_DELAY = 5
local FADE_TIME = 0.45
local idleToken = 0
local idleCollapsed = false
local savedTransparency = setmetatable({}, {__mode = "k"})
local activeTweens = setmetatable({}, {__mode = "k"})

local function rememberObject(obj)
    if savedTransparency[obj] then return end
    local data = {}
    if obj:IsA("GuiObject") then
        data.BackgroundTransparency = obj.BackgroundTransparency
    end
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        data.TextTransparency = obj.TextTransparency
        data.TextStrokeTransparency = obj.TextStrokeTransparency
    end
    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        data.ImageTransparency = obj.ImageTransparency
    end
    if obj:IsA("UIStroke") then
        data.Transparency = obj.Transparency
    end
    savedTransparency[obj] = data
end

local function tweenObject(obj, collapsed)
    rememberObject(obj)
    local base = savedTransparency[obj]
    if not base then return end

    if activeTweens[obj] then
        pcall(function() activeTweens[obj]:Cancel() end)
        activeTweens[obj] = nil
    end

    local goal = {}
    if base.BackgroundTransparency ~= nil then
        goal.BackgroundTransparency = collapsed and math.max(base.BackgroundTransparency, 0.92) or base.BackgroundTransparency
    end
    if base.TextTransparency ~= nil then
        goal.TextTransparency = collapsed and math.max(base.TextTransparency, 0.78) or base.TextTransparency
    end
    if base.TextStrokeTransparency ~= nil then
        goal.TextStrokeTransparency = collapsed and math.max(base.TextStrokeTransparency, 0.92) or base.TextStrokeTransparency
    end
    if base.ImageTransparency ~= nil then
        goal.ImageTransparency = collapsed and math.max(base.ImageTransparency, 0.85) or base.ImageTransparency
    end
    if base.Transparency ~= nil then
        goal.Transparency = collapsed and math.max(base.Transparency, 0.88) or base.Transparency
    end

    if next(goal) then
        local tw = TweenService:Create(
            obj,
            TweenInfo.new(FADE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            goal
        )
        activeTweens[obj] = tw
        tw:Play()
    end
end

local restoreToken = 0

local function forceOriginalTransparency()
    for obj, base in pairs(savedTransparency) do
        if obj and obj.Parent and base then
            if activeTweens[obj] then
                pcall(function() activeTweens[obj]:Cancel() end)
                activeTweens[obj] = nil
            end
            pcall(function()
                if base.BackgroundTransparency ~= nil then obj.BackgroundTransparency = base.BackgroundTransparency end
                if base.TextTransparency ~= nil then obj.TextTransparency = base.TextTransparency end
                if base.TextStrokeTransparency ~= nil then obj.TextStrokeTransparency = base.TextStrokeTransparency end
                if base.ImageTransparency ~= nil then obj.ImageTransparency = base.ImageTransparency end
                if base.Transparency ~= nil then obj.Transparency = base.Transparency end
            end)
        end
    end
end

local function setMenuIdleCollapsed(state)
    local newState = state == true
    restoreToken += 1
    local myRestoreToken = restoreToken

    if newState and not idleCollapsed then
        savedTransparency = setmetatable({}, {__mode = "k"})
        for _, root in ipairs({Content, Tabs, Close, HeaderDivider}) do
            rememberObject(root)
            for _, obj in ipairs(root:GetDescendants()) do
                rememberObject(obj)
            end
        end
    end

    idleCollapsed = newState

    Content.Visible = true
    Tabs.Visible = true
    Close.Visible = true
    HeaderDivider.Visible = true

    for _, root in ipairs({Content, Tabs, Close, HeaderDivider}) do
        tweenObject(root, idleCollapsed)
        for _, obj in ipairs(root:GetDescendants()) do
            tweenObject(obj, idleCollapsed)
        end
    end

    if not newState then

        task.delay(FADE_TIME + 0.08, function()
            if myRestoreToken ~= restoreToken or idleCollapsed then return end

            local untilTime = tick() + 1.5
            repeat
                if myRestoreToken ~= restoreToken or idleCollapsed then return end
                forceOriginalTransparency()
                RunService.RenderStepped:Wait()
            until tick() >= untilTime
            forceOriginalTransparency()

        end)
    end
end

local function cancelIdleAndRestore()
    idleToken += 1
    if idleCollapsed then
        setMenuIdleCollapsed(false)
    elseif next(savedTransparency) then

        forceOriginalTransparency()
    end
end

local function scheduleIdleCollapse()

    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    idleToken += 1
    local myToken = idleToken
    task.delay(IDLE_DELAY, function()
        if myToken ~= idleToken then return end
        if not Main or not Main.Parent or not Main.Visible then return end
        setMenuIdleCollapsed(true)
    end)
end

Main.MouseEnter:Connect(cancelIdleAndRestore)
Main.MouseLeave:Connect(scheduleIdleCollapse)

RunService.RenderStepped:Connect(function()
    if not Main or not Main.Parent or not Main.Visible then return end
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    local mousePos = UserInputService:GetMouseLocation()
    local pos = Main.AbsolutePosition
    local size = Main.AbsoluteSize
    local inside = mousePos.X >= pos.X and mousePos.X <= pos.X + size.X
        and mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y
    if inside then
        if idleCollapsed then
            cancelIdleAndRestore()
        else

            for _, root in ipairs({Content, Tabs, Close, HeaderDivider}) do
                if root:IsA("TextLabel") or root:IsA("TextButton") or root:IsA("TextBox") then
                    root.TextTransparency = 0
                end
                for _, obj in ipairs(root:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        if obj.Visible then
                            obj.TextTransparency = 0
                        end
                    end
                end
            end
        end
    end
end)

Main.DescendantAdded:Connect(function(obj)

    if idleCollapsed then
        task.defer(function()
            if obj and obj.Parent then
                savedTransparency[obj] = nil
                tweenObject(obj, true)
            end
        end)
    end
end)

task.defer(scheduleIdleCollapse)
end

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Parent = Tabs
local pages = {}
local tabButtons = {}
local tabUnderline = {}
local tabNames = {"MOVEMENT", "COMBAT", "VISUALS", "KEYBINDS", "SETTINGS"}
local activeTab = "MOVEMENT"
-- MENU page kept for controller binds compatibility
local _extraPages = {"MENU"}
function addPage(name)
local page = Instance.new("ScrollingFrame")
page.Name = name
page.BackgroundTransparency = 1
page.BorderSizePixel = 0
page.ScrollBarThickness = 0
page.ScrollBarImageTransparency = 1
page.CanvasSize = UDim2.new(0, 0, 0, 0)
page.AutomaticCanvasSize = Enum.AutomaticSize.Y
page.Size = UDim2.new(1, 0, 1, 0)
page.ZIndex = 3
page.Visible = false
page.Parent = Content
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = page
pages[name] = page
return page
end
function setTab(name)
activeTab = name
for pageName, page in pairs(pages) do
page.Visible = pageName == name
end
for tabName, btn in pairs(tabButtons) do
local on = tabName == name
btn.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 145)
btn.BackgroundColor3 = on and Color3.fromRGB(22, 22, 26) or Color3.fromRGB(14, 14, 16)
btn.BackgroundTransparency = on and 0.05 or 0.45
local st = btn:FindFirstChildOfClass("UIStroke")
if st then
st.Color = on and Color3.fromRGB(200, 200, 205) or Color3.fromRGB(40, 40, 45)
st.Thickness = on and 1.1 or 0.8
st.Transparency = on and 0.25 or 0.6
end
local ul = tabUnderline[tabName]
if ul then ul.Visible = on end
end
end
for _, name in ipairs(_extraPages or {}) do
addPage(name)
end
for _, name in ipairs(tabNames) do
addPage(name)
local btn = Instance.new("TextButton")
btn.Name = name
btn.Size = UDim2.new(0, 82, 0, 30)
btn.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
btn.BackgroundTransparency = 0.45
btn.BorderSizePixel = 0
btn.Text = name
btn.LayoutOrder = ({MOVEMENT=1, COMBAT=2, VISUALS=3, KEYBINDS=4, SETTINGS=5})[name] or 99
btn.TextColor3 = Color3.fromRGB(140, 140, 145)
btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
btn.TextStrokeTransparency = 1
btn.TextSize = 11
btn.TextScaled = false
btn.TextWrapped = false
btn.Font = Enum.Font.GothamBold
btn.AutoButtonColor = false
btn.ZIndex = 6
btn.Parent = Tabs
corner(btn, 10)
local ul = Instance.new("Frame")
ul.Name = "Underline"
ul.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ul.BorderSizePixel = 0
ul.Size = UDim2.new(0.55, 0, 0, 2)
ul.Position = UDim2.new(0.225, 0, 1, -3)
ul.ZIndex = 8
ul.Visible = false
ul.Parent = btn
corner(ul, 1)
tabUnderline[name] = ul
corner(btn, 8)
stroke(btn, Color3.fromRGB(70, 70, 70), 1.0, 0.5)
tabButtons[name] = btn
local targetTabName = name
btn.MouseButton1Click:Connect(function()
setTab(targetTabName)
end)
end
function section(parent, text, order)
local holder = Instance.new("Frame")
holder.Name = text
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1, -4, 0, 22)
holder.LayoutOrder = order
holder.ZIndex = 8
holder.Parent = parent
local accent = Instance.new("Frame")
accent.Name = "Accent"
accent.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
accent.BorderSizePixel = 0
accent.Size = UDim2.new(0, 3, 0, 12)
accent.Position = UDim2.new(0, 2, 0.5, -6)
accent.ZIndex = 9
accent.Parent = holder
corner(accent, 2)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = text
label.TextColor3 = Color3.fromRGB(245, 245, 245)
label.TextStrokeTransparency = 1
label.TextSize = 11
label.Font = Enum.Font.GothamBold
label.TextXAlignment = Enum.TextXAlignment.Left
label.Size = UDim2.new(1, -50, 1, 0)
label.Position = UDim2.new(0, 12, 0, 0)
label.ZIndex = 9
label.Parent = holder
local line = Instance.new("Frame")
line.Name = "Line"
line.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
line.BackgroundTransparency = 0.3
line.BorderSizePixel = 0
line.Size = UDim2.new(1, -120, 0, 1)
line.Position = UDim2.new(0, 100, 0.5, 0)
line.ZIndex = 8
line.Parent = holder
return holder
end
function baseRow(parent, labelText, order)
local row = Instance.new("Frame")
row.Name = labelText
row.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
row.BackgroundTransparency = 0.15
row.Size = UDim2.new(1, -4, 0, 38)
row.BorderSizePixel = 0
row.LayoutOrder = order
row.ZIndex = 4
row.Parent = parent
corner(row, 12)
stroke(row, Color3.fromRGB(40, 40, 45), 1.0, 0.4)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = labelText
label.TextColor3 = Color3.fromRGB(245, 245, 245)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 12
label.Font = Enum.Font.GothamMedium
label.TextXAlignment = Enum.TextXAlignment.Left
label.Position = UDim2.new(0, 12, 0, 0)
label.Size = UDim2.new(1, -132, 1, 0)
label.ZIndex = 5
label.Parent = row

return row
end
function textboxRow(parent, labelText, value, order)
local row = baseRow(parent, labelText, order)
local box = Instance.new("TextBox")
box.Name = "ValueBox"
box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
box.BackgroundTransparency = 0.18
box.Text = tostring(value or "")
box.TextColor3 = COLORS.white
box.TextSize = 12
box.Font = Enum.Font.GothamMedium
box.ClearTextOnFocus = false
box.Size = UDim2.new(0, 58, 0, 24)
box.Position = UDim2.new(1, -68, 0.5, -12)
box.BorderSizePixel = 0
box.ZIndex = 6
box.Parent = row
corner(box, 7)
stroke(box, COLORS.strokeSoft, 1, 0.45)
return row, box
end
function toggleRow(parent, labelText, default, order)
local row = baseRow(parent, labelText, order)
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.BackgroundTransparency = 1
button.Text = ""
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.AutoButtonColor = false
button.ZIndex = 7
button.Parent = row
-- Pill toggle: white when on, dark gray when off
local track = Instance.new("Frame")
track.Name = "Track"
track.BackgroundColor3 = default and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(40, 40, 40)
track.BackgroundTransparency = 0
track.Size = UDim2.new(0, 40, 0, 20)
track.Position = UDim2.new(1, -50, 0.5, -10)
track.BorderSizePixel = 0
track.ZIndex = 5
track.Parent = button
corner(track, 999)
stroke(track, default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90), 1.1, 0.35)
local circle = Instance.new("Frame")
circle.Name = "Knob"
circle.BackgroundColor3 = default and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(220, 220, 220)
circle.Size = UDim2.new(0, 16, 0, 16)
circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
circle.BorderSizePixel = 0
circle.ZIndex = 6
circle.Parent = track
corner(circle, 999)
local circleStroke = track:FindFirstChildOfClass("UIStroke")
local rowStroke = row:FindFirstChildOfClass("UIStroke")
local state = default and true or false
local function setVisual(on)
state = on and true or false
tween(track, {
BackgroundColor3 = state and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(40, 40, 40),
})
tween(circle, {
Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
BackgroundColor3 = state and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(220, 220, 220),
})
if circleStroke then
tween(circleStroke, {
Color = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90),
Transparency = state and 0.15 or 0.4,
})
end
if rowStroke then
tween(rowStroke, {
Color = state and Color3.fromRGB(220, 220, 220) or COLORS.strokeSoft,
Transparency = state and 0.2 or 0.38,
})
end
row.BackgroundTransparency = 0.25
end
setVisual(state)
button.Activated:Connect(function()
end)
return row, setVisual
end
_G.ExeSyncToggleVisuals = function()
pcall(function() if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end end)
pcall(function() if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end end)
pcall(function() if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end end)
pcall(function() if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end end)
pcall(function() if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end end)
pcall(function() if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled == true) end end)
end
_G.ExeActionToggleRow = function(parent, labelText, default, order)
local row = baseRow(parent, labelText, order)
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.BackgroundTransparency = 1
button.Text = ""
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.AutoButtonColor = false
button.ZIndex = 7
button.Parent = row
-- Pill toggle: white when on, dark gray when off
local track = Instance.new("Frame")
track.Name = "Track"
track.BackgroundColor3 = default and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(40, 40, 40)
track.BackgroundTransparency = 0
track.Size = UDim2.new(0, 40, 0, 20)
track.Position = UDim2.new(1, -50, 0.5, -10)
track.BorderSizePixel = 0
track.ZIndex = 5
track.Parent = button
corner(track, 999)
stroke(track, default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90), 1.1, 0.35)
local circle = Instance.new("Frame")
circle.Name = "Knob"
circle.BackgroundColor3 = default and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(220, 220, 220)
circle.Size = UDim2.new(0, 16, 0, 16)
circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
circle.BorderSizePixel = 0
circle.ZIndex = 6
circle.Parent = track
corner(circle, 999)
local circleStroke = track:FindFirstChildOfClass("UIStroke")
local rowStroke = row:FindFirstChildOfClass("UIStroke")
local function setVisual(on)
local state = on and true or false
tween(track, {
BackgroundColor3 = state and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(40, 40, 40),
})
tween(circle, {
Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
BackgroundColor3 = state and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(220, 220, 220),
})
if circleStroke then
tween(circleStroke, {
Color = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90),
Transparency = state and 0.15 or 0.4,
})
end
if rowStroke then
tween(rowStroke, {
Color = state and Color3.fromRGB(220, 220, 220) or COLORS.strokeSoft,
Transparency = state and 0.2 or 0.38,
})
end
row.BackgroundTransparency = 0.25
end
setVisual(default)
return row, setVisual, button
end

function dropdownRow(parent, labelText, value, order)
local row = baseRow(parent, labelText, order)
local select = Instance.new("TextButton")
select.Name = "Dropdown"
select.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
select.BackgroundTransparency = 0.18
select.Text = tostring(value or "None") .. "  v"
select.TextColor3 = COLORS.white
select.TextSize = 11
select.Font = Enum.Font.GothamMedium
select.Size = UDim2.new(0, 70, 0, 24)
select.Position = UDim2.new(1, -80, 0.5, -12)
select.BorderSizePixel = 0
select.ZIndex = 6
select.Parent = row
corner(select, 7)
stroke(select, COLORS.strokeSoft, 1, 0.45)
return row, select
end
function refreshAnimationPackRow()
local displayName = tostring(selectedAnimationPack or "OFF")

if animationPackValueLabel and animationPackValueLabel.Parent then
animationPackValueLabel.Text = displayName
end

pcall(function()
    if pages and pages.VISUALS then
        for _, obj in ipairs(pages.VISUALS:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Name == "AnimationPackValue" then
                obj.Text = displayName
            end
        end
    end
end)
end
function animationPackRow(parent, order)
local row = baseRow(parent, "Animation Pack", order)
row.Size = UDim2.new(1,-4,0,52)
row.BackgroundTransparency = 1
local animRowStroke = row:FindFirstChildOfClass("UIStroke")
if animRowStroke then animRowStroke.Transparency = 1 end
local label = row:FindFirstChild("Label")
if label then
label.Text = "Animation Pack"
label.Position = UDim2.new(0,2,0,0)
label.Size = UDim2.new(1,0,0,16)
label.TextSize = 12
label.Font = Enum.Font.GothamBlack
end
local left = Instance.new("TextButton")
left.Name = "LeftArrow"
left.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
left.BackgroundTransparency = 0.18
left.Text = "<"
left.TextColor3 = COLORS.white
left.TextSize = 12
left.Font = Enum.Font.GothamMedium
left.Size = UDim2.new(0,44,0,25)
left.Position = UDim2.new(0,0,0,22)
left.BorderSizePixel = 0
left.ZIndex = 6
left.Parent = row
corner(left, 7)
stroke(left, COLORS.strokeSoft, 1, 0.45)
animationPackValueLabel = Instance.new("TextLabel")
animationPackValueLabel.Name = "AnimationPackValue"
animationPackValueLabel.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
animationPackValueLabel.BackgroundTransparency = 0.18
animationPackValueLabel.BorderSizePixel = 0
animationPackValueLabel.Text = selectedAnimationPack
animationPackValueLabel.TextColor3 = COLORS.white
animationPackValueLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
animationPackValueLabel.TextStrokeTransparency = 1
animationPackValueLabel.TextSize = 11
animationPackValueLabel.Font = Enum.Font.GothamMedium
animationPackValueLabel.TextXAlignment = Enum.TextXAlignment.Center
animationPackValueLabel.Size = UDim2.new(1,-96,0,28)
animationPackValueLabel.Position = UDim2.new(0,48,0,22)
animationPackValueLabel.ZIndex = 6
animationPackValueLabel.Parent = row
corner(animationPackValueLabel,7)
stroke(animationPackValueLabel,COLORS.strokeSoft,1,0.45)

local rowAnimationPackValueLabel = animationPackValueLabel

local more = Instance.new("TextButton")
more.Name = "MoreAnimations"
more.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
more.BackgroundTransparency = 0.18
more.Text = "MORE"
more.TextColor3 = COLORS.white
more.TextSize = 9
more.Font = Enum.Font.GothamMedium
more.Size = UDim2.new(0, 52, 0, 28)
more.Position = UDim2.new(0, 116, 0.5, -14)
more.BorderSizePixel = 0
more.ZIndex = 6
more.Parent = row
more.Visible = false
corner(more, 8)
stroke(more, COLORS.strokeSoft, 1, 0.45)

local function getPackThumb(packName)
    if packName == "OFF" then
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(
                LP.UserId,
                Enum.ThumbnailType.AvatarBust,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if ok then return img end
        return ""
    end
    if packName == "Unwalk" then
        return "rbxassetid://71408678974152"
    end
    local pack = AnimationPacks[packName]
    local idle = pack and pack.idle and pack.idle[1] and pack.idle[1][1]
    local id = idle and tostring(idle):match("(%d+)")
    if id then
        return "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
    end
    return ""
end

local function resolveBundleMappings(bundledItems)
    local mappings = {}
    if type(bundledItems) ~= "table" then return mappings end

    for _, assetIds in pairs(bundledItems) do
        if type(assetIds) == "table" then
            for _, assetId in pairs(assetIds) do
                local success, objects = pcall(function()
                    return game:GetObjects("rbxassetid://" .. tostring(assetId))
                end)
                if success and objects then
                    local function searchTree(parent, parentPath)
                        for _, child in pairs(parent:GetChildren()) do
                            if child:IsA("Animation") then
                                local animationPath = parentPath .. "." .. child.Name
                                local pathParts = animationPath:split(".")
                                table.insert(mappings, {
                                    category = pathParts[#pathParts - 1],
                                    name = pathParts[#pathParts],
                                    animationId = child.AnimationId
                                })
                            elseif #child:GetChildren() > 0 then
                                searchTree(child, parentPath .. "." .. child.Name)
                            end
                        end
                    end

                    for _, obj in pairs(objects) do
                        searchTree(obj, obj.Name)
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end
    return mappings
end

applyFullAnimationBundle = function(animationData)
    local char = LP.Character
    local animate = char and char:FindFirstChild("Animate")
    if not char or not animate then return end

    backupAnimations(char)
    if unwalkEnabled then
        disableUnwalk()
        animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 2)
        if not animate then return end
    end

    local mappings = resolveBundleMappings(animationData.bundledItems)
    if #mappings == 0 then
        if showActionNotification then
            pcall(function() showActionNotification("ANIMATION DATA NOT FOUND") end)
        end
        return
    end

    stopCurrentAnimations(char)

    for _, m in ipairs(mappings) do
        local cat = tostring(m.category or ""):lower()
        local name = tostring(m.name or "")
        local folder = animate:FindFirstChild(cat)
        if folder then
            local target = folder:FindFirstChild(name)
            if not target then
                if cat == "walk" then target = folder:FindFirstChild("WalkAnim")
                elseif cat == "run" then target = folder:FindFirstChild("RunAnim")
                elseif cat == "jump" then target = folder:FindFirstChild("JumpAnim")
                elseif cat == "fall" then target = folder:FindFirstChild("FallAnim")
                elseif cat == "climb" then target = folder:FindFirstChild("ClimbAnim")
                elseif cat == "swim" then target = folder:FindFirstChild("Swim")
                elseif cat == "swimidle" then target = folder:FindFirstChild("SwimIdle")
                elseif cat == "idle" then
                    target = folder:FindFirstChild(name) or folder:FindFirstChild("Animation1")
                end
            end
            setAnimId(target, m.animationId)
        end
    end

    reloadAnimate(animate)

    _G.ExeSelectedMoreAnimationBundle = {
        id = animationData.id,
        name = animationData.name,
        bundledItems = animationData.bundledItems
    }

    selectedAnimationPack = "OFF"
    syncAnimationPackIndex()
    if refreshAnimationPackRow then refreshAnimationPackRow() end
    if saveExeConfig then pcall(saveExeConfig) end

    if showActionNotification then
        pcall(function() showActionNotification("ANIMATION - " .. tostring(animationData.name or animationData.id)) end)
    end
end

local function openAnimationGallery()
    local existing = PlayerGui:FindFirstChild("ExeAnimationGallery")
    if existing then existing:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "ExeAnimationGallery"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 99999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    safeParentGui(sg)

    local shade = Instance.new("TextButton")
    shade.Text = ""
    shade.AutoButtonColor = false
    shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shade.BackgroundTransparency = 0.25
    shade.Size = UDim2.fromScale(1,1)
    shade.ZIndex = 1
    shade.Parent = sg

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.Position = UDim2.fromScale(0.5,0.5)
    panel.Size = UDim2.new(0, 540, 0, 480)
    panel.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
    panel.BackgroundTransparency = 0.04
    panel.BorderSizePixel = 0
    panel.ZIndex = 2
    panel.Parent = sg
    corner(panel,16)
    stroke(panel,COLORS.strokeSoft,1.2,0.15)

    pcall(function()
        local selectedColor = (_G.ExeThemeColors and _G.ExeThemeColors[_G.ExeThemeName])
            or Color3.fromRGB(255,255,255)

        panel.BackgroundColor3 = selectedColor:Lerp(Color3.fromRGB(8, 8, 8), 0.78)

        local exactImage = nil
        local exactColor = selectedColor
        local exactTransparency = 0

        if BgImage and BgImage.Parent and BgImage.Visible and BgImage.Image and BgImage.Image ~= "" then
            exactImage = BgImage.Image
            exactColor = BgImage.ImageColor3
            exactTransparency = BgImage.ImageTransparency
        elseif currentBackground and tonumber(currentBackground) and tonumber(currentBackground) > 0
            and BackgroundIDs and BackgroundIDs[tonumber(currentBackground)] then
            exactImage = "rbxassetid://" .. tostring(BackgroundIDs[tonumber(currentBackground)])
        end

        if exactImage and exactImage ~= "" then
            local image = Instance.new("ImageLabel")
            image.Name = "ThemeBackground"
            image.BackgroundTransparency = 1
            image.Size = UDim2.fromScale(1,1)
            image.Position = UDim2.fromScale(0,0)
            image.Image = exactImage
            image.ImageColor3 = exactColor
            image.ImageTransparency = exactTransparency
            image.ScaleType = Enum.ScaleType.Crop
            image.ZIndex = 2
            image.Parent = panel
            corner(image,16)

            local wash = Instance.new("Frame")
            wash.Name = "BackgroundWash"
            wash.BackgroundColor3 = Color3.fromRGB(0,0,0)
            wash.BackgroundTransparency = 0.52
            wash.BorderSizePixel = 0
            wash.Size = UDim2.fromScale(1,1)
            wash.ZIndex = 2
            wash.Parent = panel
            corner(wash,16)
        end
    end)

    if UserInputService.TouchEnabled then
        panel.Size = UDim2.new(0.95,0,0.80,0)
    end

    do
        local dragging = false
        local dragStart = nil
        local startPos = nil

        local function updateDrag(input)
            if not dragging or not dragStart or not startPos then return end
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        panel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = panel.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                updateDrag(input)
            end
        end)
    end

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = "ALL ANIMATION BUNDLES"
    title.TextColor3 = COLORS.white
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0,16,0,10)
    title.Size = UDim2.new(1,-60,0,28)
    title.ZIndex = 3
    title.Parent = panel

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Text = "Online + Offsale animation bundles"
    sub.TextColor3 = Color3.fromRGB(176, 176, 176)
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Position = UDim2.new(0,16,0,34)
    sub.Size = UDim2.new(1,-60,0,20)
    sub.ZIndex = 3
    sub.Parent = panel

    local close = Instance.new("TextButton")
    close.Text = "X"
    close.Font = Enum.Font.GothamMedium
    close.TextSize = 12
    close.TextColor3 = COLORS.white
    close.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
    close.BackgroundTransparency = 0.08
    close.Size = UDim2.fromOffset(32,32)
    close.Position = UDim2.new(1,-42,0,8)
    close.BorderSizePixel = 0
    close.ZIndex = 4
    close.Parent = panel
    corner(close,9)

    local searchBox = Instance.new("TextBox")
    searchBox.PlaceholderText = "Search bundle / ID..."
    searchBox.Text = ""
    searchBox.ClearTextOnFocus = false
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextSize = 12
    searchBox.TextColor3 = COLORS.white
    searchBox.PlaceholderColor3 = Color3.fromRGB(136, 136, 136)
    searchBox.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
    searchBox.BackgroundTransparency = 0.06
    searchBox.BorderSizePixel = 0
    searchBox.Position = UDim2.new(0,14,0,60)
    searchBox.Size = UDim2.new(1,-28,0,32)
    searchBox.ZIndex = 3
    searchBox.Parent = panel
    corner(searchBox,9)
    stroke(searchBox,COLORS.strokeSoft,1,0.5)

    local scroll = Instance.new("ScrollingFrame")
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.new(0,10,0,102)
    scroll.Size = UDim2.new(1,-20,1,-116)
    scroll.ScrollBarThickness = 4
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ZIndex = 3
    scroll.Parent = panel

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.fromOffset(122,145)
    grid.CellPadding = UDim2.fromOffset(8,8)
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = scroll

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(161, 161, 161)
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Position = UDim2.new(0,16,1,-27)
    status.Size = UDim2.new(1,-32,0,20)
    status.ZIndex = 4
    status.Parent = panel

    local allAnimations = {}

    local function clearCards()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("GuiButton") then child:Destroy() end
        end
    end

    local function addCard(item, order)
        local card = Instance.new("TextButton")
        card.Text = ""
        card.AutoButtonColor = false
        card.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        card.BackgroundTransparency = 0.07
        card.BorderSizePixel = 0
        card.LayoutOrder = order
        card.ZIndex = 4
        card.Parent = scroll
        corner(card,11)
        stroke(card,COLORS.strokeSoft,1,0.55)

        local img = Instance.new("ImageLabel")
        img.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
        img.BackgroundTransparency = 0.12
        img.BorderSizePixel = 0
        img.Image = "rbxthumb://type=BundleThumbnail&id=" .. tostring(item.id) .. "&w=150&h=150"
        img.ScaleType = Enum.ScaleType.Fit
        img.Position = UDim2.new(0,7,0,7)
        img.Size = UDim2.new(1,-14,0,92)
        img.ZIndex = 5
        img.Parent = card
        corner(img,8)

        local name = Instance.new("TextLabel")
        name.BackgroundTransparency = 1
        name.Text = tostring(item.name or ("Animation " .. tostring(item.id)))
        name.TextColor3 = COLORS.white
        name.Font = Enum.Font.GothamMedium
        name.TextSize = 10
        name.TextWrapped = true
        name.TextYAlignment = Enum.TextYAlignment.Top
        name.Position = UDim2.new(0,6,0,104)
        name.Size = UDim2.new(1,-12,0,32)
        name.ZIndex = 5
        name.Parent = card

        card.MouseButton1Click:Connect(function()
            applyFullAnimationBundle(item)
            if sg and sg.Parent then
                sg:Destroy()
            end
        end)
    end

    local function render()
        clearCards()
        local q = (searchBox.Text or ""):lower()
        local count = 0
        for _, item in ipairs(allAnimations) do
            local match = q == "" or tostring(item.id) == q or tostring(item.name or ""):lower():find(q,1,true)
            if match then
                count += 1
                addCard(item,count)
            end
        end
        status.Text = tostring(count) .. " animation bundles"
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        task.defer(render)
    end)

    close.MouseButton1Click:Connect(function() sg:Destroy() end)

    task.spawn(function()
        local seen = {}
        local urls = {
            "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json",
            "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniperoffsale.json"
        }

        for _, url in ipairs(urls) do
            local ok, body = pcall(function() return game:HttpGet(url) end)
            if ok and body and body ~= "" then
                local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
                if ok2 and data then
                    for _, item in pairs(data.data or {}) do
                        local id = tonumber(item.id)
                        if id and id > 0 and not seen[id] and item.bundledItems then
                            seen[id] = true
                            table.insert(allAnimations, {
                                id = id,
                                name = item.name or ("Animation_" .. tostring(id)),
                                bundledItems = item.bundledItems
                            })
                        end
                    end
                end
            end
        end

        table.sort(allAnimations,function(a,b)
            return tostring(a.name or ""):lower() < tostring(b.name or ""):lower()
        end)
        render()
    end)
end

more.MouseButton1Click:Connect(openAnimationGallery)

local right = Instance.new("TextButton")
right.Name = "RightArrow"
right.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
right.BackgroundTransparency = 0.18
right.Text = ">"
right.TextColor3 = COLORS.white
right.TextSize = 12
right.Font = Enum.Font.GothamMedium
right.Size = UDim2.new(0,44,0,25)
right.Position = UDim2.new(1,-44,0,22)
right.BorderSizePixel = 0
right.ZIndex = 6
right.Parent = row
corner(right, 7)
stroke(right, COLORS.strokeSoft, 1, 0.45)
local function setPackIndex(nextIndex)
if nextIndex < 1 then nextIndex = #AnimationPackList end
if nextIndex > #AnimationPackList then nextIndex = 1 end

AnimationPackIndex = nextIndex
local chosenPack = AnimationPackList[AnimationPackIndex] or "OFF"
_G.ExeSelectedMoreAnimationBundle = nil

selectedAnimationPack = chosenPack

if rowAnimationPackValueLabel and rowAnimationPackValueLabel.Parent then
    rowAnimationPackValueLabel.Text = chosenPack
end
refreshAnimationPackRow()

applyAnimationPack(chosenPack)

task.defer(function()
    if rowAnimationPackValueLabel and rowAnimationPackValueLabel.Parent then
        rowAnimationPackValueLabel.Text = chosenPack
    end
    if selectedAnimationPack == chosenPack then
        refreshAnimationPackRow()
    end
end)

if saveExeConfig then pcall(saveExeConfig) end
end
left.MouseButton1Click:Connect(function()
setPackIndex(AnimationPackIndex - 1)
end)
right.MouseButton1Click:Connect(function()
setPackIndex(AnimationPackIndex + 1)
end)
return row
end
function keyName(key)
if not key then return "None" end
local name = tostring(key):gsub("Enum.KeyCode.", "")
name = name:gsub("Button", "BTN ")
name = name:gsub("DPad", "DPad ")
return name
end
function refreshSpeedKeybindButton(keyId)
local btn = speedKeybindButtons[keyId]
if btn then
if listeningForSpeedKey == keyId then
btn.Text = "Press..."
else
btn.Text = keyName(speedKeybinds[keyId])
end
end
end
function refreshAllSpeedKeybinds()
for keyId in pairs(speedKeybindButtons) do
refreshSpeedKeybindButton(keyId)
end
end
function refreshTPDownKeybind()
if tpDownKeybindButton then
tpDownKeybindButton.Text = listeningForTPDownKey and "Press..." or keyName(tpDownKeybind)
end
end
function tpDownKeybindRow(parent, order)
local row = baseRow(parent, "TP Down", order)
local btn = Instance.new("TextButton")
btn.Name = "TPDownKeybindButton"
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.BackgroundTransparency = 0.18
btn.Text = keyName(tpDownKeybind)
btn.TextColor3 = COLORS.white
btn.TextSize = 11
btn.Font = Enum.Font.GothamMedium
btn.Size = UDim2.new(0, 56, 0, 24)
btn.Position = UDim2.new(1, -64, 0.5, -12)
btn.BorderSizePixel = 0
btn.ZIndex = 6
btn.AutoButtonColor = false
btn.Parent = row
corner(btn, 14)
stroke(btn, COLORS.strokeSoft, 1, 0.45)
local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearKeybindButton"
clearBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
clearBtn.BackgroundTransparency = 0.18
clearBtn.Text = "×"
clearBtn.TextColor3 = COLORS.white
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.GothamMedium
clearBtn.Size = UDim2.new(0, 22, 0, 24)
clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
clearBtn.BorderSizePixel = 0
clearBtn.ZIndex = 6
clearBtn.AutoButtonColor = false
clearBtn.Parent = row
corner(clearBtn, 7)
stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
tpDownKeybindButton = btn
btn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = true
keybindListenStartedAt = tick()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
end)
clearBtn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = false
tpDownKeybind = nil
if tpDownKeybindButton then tpDownKeybindButton.Text = "None" end
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if saveExeConfig then pcall(saveExeConfig) end
end)
return row, btn
end
function speedKeybindRow(parent, labelText, keyId, order)
local row = baseRow(parent, labelText, order)
local btn = Instance.new("TextButton")
btn.Name = "KeybindButton"
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.BackgroundTransparency = 0.18
btn.Text = keyName(speedKeybinds[keyId])
btn.TextColor3 = COLORS.white
btn.TextSize = 11
btn.Font = Enum.Font.GothamMedium
btn.Size = UDim2.new(0, 56, 0, 24)
btn.Position = UDim2.new(1, -64, 0.5, -12)
btn.BorderSizePixel = 0
btn.ZIndex = 6
btn.AutoButtonColor = false
btn.Parent = row
corner(btn, 14)
stroke(btn, COLORS.strokeSoft, 1, 0.45)
local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearKeybindButton"
clearBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
clearBtn.BackgroundTransparency = 0.18
clearBtn.Text = "×"
clearBtn.TextColor3 = COLORS.white
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.GothamMedium
clearBtn.Size = UDim2.new(0, 22, 0, 24)
clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
clearBtn.BorderSizePixel = 0
clearBtn.ZIndex = 6
clearBtn.AutoButtonColor = false
clearBtn.Parent = row
corner(clearBtn, 7)
stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
speedKeybindButtons[keyId] = btn
btn.Activated:Connect(function()
listeningForSpeedKey = keyId
listeningForTPDownKey = false
keybindListenStartedAt = tick()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
end)
clearBtn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = false
speedKeybinds[keyId] = nil
if speedKeybindButtons[keyId] then speedKeybindButtons[keyId].Text = "None" end
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if saveExeConfig then pcall(saveExeConfig) end
end)
return row, btn
end
local normalModeValueLabel = nil
local laggerModeValueLabel = nil
local aimbotButtonLabel = nil
local aimbotSpeedLabel = nil
local laggerAimbotSpeedLabel = nil
local combatAimbotKeybindLabel = nil
function getAimbotModeDisplay()
if selectedAimbotMode == "Anti Bypass" or selectedAimbotMode == "Bypass" then
return "Anti Bypass"
end
return "Normal"
end
function refreshAimbotButtonLabel()
if aimbotButtonLabel then
aimbotButtonLabel.Text = getAimbotModeDisplay() .. " Aimbot"
end
end
function refreshAimbotModeLabels()
local modeName = getAimbotModeDisplay()
if aimbotSpeedLabel then
aimbotSpeedLabel.Text = modeName .. " Aimbot Speed"
end
if laggerAimbotSpeedLabel then
laggerAimbotSpeedLabel.Text = modeName .. " Lagger Aimbot Speed"
end
if combatAimbotKeybindLabel then
combatAimbotKeybindLabel.Text = modeName .. " Aimbot"
end
refreshAimbotButtonLabel()
end
refreshSpeedModeRows = function()
if normalModeValueLabel then
normalModeValueLabel.Text = (currentSpeedMode == "Carry") and "Carry" or "Normal"
end
if laggerModeValueLabel then
laggerModeValueLabel.Text = (currentSpeedMode == "Lagger Carry") and "Lagger Carry" or "Lagger"
end
end
function modeDisplayRow(parent, order, side)
local row = baseRow(parent, "Mode", order)
row.Size = UDim2.new(1, -4, 0, 34)
row.BackgroundTransparency = 0.3
local label = row:FindFirstChild("Label")
if label then
label.Text = "Mode"
label.TextSize = 11
label.Size = UDim2.new(1, -132, 1, 0)
label.Position = UDim2.new(0, 12, 0, 0)
label.TextColor3 = Color3.fromRGB(245, 245, 245)
end
local value = Instance.new("TextLabel")
value.Name = "ModeValue"
value.BackgroundTransparency = 1
value.Text = side == "Normal" and "Normal" or "Lagger"
value.TextColor3 = Color3.fromRGB(255, 255, 255)
value.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
value.TextStrokeTransparency = 1
value.TextSize = 12
value.Font = Enum.Font.GothamMedium
value.TextXAlignment = Enum.TextXAlignment.Right
value.Position = UDim2.new(1, -150, 0, 0)
value.Size = UDim2.new(0, 138, 1, 0)
value.ZIndex = 6
value.Parent = row
local click = Instance.new("TextButton")
click.Name = "ModeClick"
click.BackgroundTransparency = 1
click.Text = ""
click.Size = UDim2.new(1, 0, 1, 0)
click.Position = UDim2.new(0, 0, 0, 0)
click.AutoButtonColor = false
click.ZIndex = 8
click.Parent = row
if side == "Normal" then
normalModeValueLabel = value
click.MouseButton1Click:Connect(function()
setSpeedMode(currentSpeedMode == "Normal" and "Carry" or "Normal")
end)
else
laggerModeValueLabel = value
click.MouseButton1Click:Connect(function()
setSpeedMode(currentSpeedMode == "Lagger" and "Lagger Carry" or "Lagger")
end)
end
refreshSpeedModeRows()
return row, value
end
function aimbotModeButtonRow(parent, order)
local row, setVisual = toggleRow(parent, tostring(selectedAimbotMode) .. " Aimbot", false, order)
aimbotButtonLabel = row and row:FindFirstChild("Label")
_G.ExeAimbotSetVisual = setVisual
refreshAimbotButtonLabel()
if _G.ExeRefreshAimbotVisual then _G.ExeRefreshAimbotVisual() end

local toggleBtn = row and row:FindFirstChild("ToggleButton")
if toggleBtn then
toggleBtn.Size = UDim2.new(0, 54, 1, 0)
toggleBtn.Position = UDim2.new(1, -54, 0, 0)
toggleBtn.Activated:Connect(function()
if _G.ExeToggleSelectedAimbot then
_G.ExeToggleSelectedAimbot()
end
end)
end

local arrow = Instance.new("TextButton")
arrow.Name = "ArrowButton"
arrow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
arrow.BackgroundTransparency = 0.18
arrow.BorderSizePixel = 0
arrow.Text = "v"
arrow.TextColor3 = COLORS.white
arrow.TextSize = 18
arrow.Font = Enum.Font.GothamBlack
arrow.AutoButtonColor = false
arrow.Size = UDim2.new(0, 38, 0, 26)
arrow.Position = UDim2.new(1, -100, 0.5, -13)
arrow.ZIndex = 20
arrow.Parent = row
corner(arrow, 7)
stroke(arrow, COLORS.strokeSoft, 1.2, 0.25)

return row, setVisual, arrow
end
_G.ExeAimbotSelectorRow = function(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Aimbot Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)
local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)
local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(236, 236, 236)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide
local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 47, 47)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide
local normalText = Instance.new("TextLabel")
normalText.Name = "NormalText"
normalText.BackgroundTransparency = 1
normalText.Text = "NORMAL"
normalText.TextColor3 = COLORS.white
normalText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
normalText.TextStrokeTransparency = 1
normalText.TextSize = 9
normalText.TextScaled = true
normalText.TextWrapped = false
normalText.Font = Enum.Font.GothamBold
normalText.TextXAlignment = Enum.TextXAlignment.Center
normalText.Size = UDim2.new(0.5, -8, 1, 0)
normalText.Position = UDim2.new(0, 4, 0, 0)
normalText.Position = UDim2.new(0, 0, 0, 0)
normalText.ZIndex = 8
normalText.Parent = holder
local bypassText = Instance.new("TextLabel")
bypassText.Name = "BypassText"
bypassText.BackgroundTransparency = 1
bypassText.Text = "BYPASS"
bypassText.TextColor3 = COLORS.white
bypassText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
bypassText.TextStrokeTransparency = 1
bypassText.TextSize = 10
bypassText.Font = Enum.Font.GothamMedium
bypassText.TextXAlignment = Enum.TextXAlignment.Center
bypassText.Size = UDim2.new(0.5, 0, 1, 0)
bypassText.Position = UDim2.new(0.5, 0, 0, 0)
bypassText.ZIndex = 8
bypassText.Parent = holder
local normalClick = Instance.new("TextButton")
normalClick.Name = "NormalClick"
normalClick.BackgroundTransparency = 1
normalClick.Text = ""
normalClick.AutoButtonColor = false
normalClick.Size = UDim2.new(0.5, 0, 1, 0)
normalClick.Position = UDim2.new(0, 0, 0, 0)
normalClick.ZIndex = 10
normalClick.Parent = holder
local bypassClick = Instance.new("TextButton")
bypassClick.Name = "BypassClick"
bypassClick.BackgroundTransparency = 1
bypassClick.Text = ""
bypassClick.AutoButtonColor = false
bypassClick.Size = UDim2.new(0.5, 0, 1, 0)
bypassClick.Position = UDim2.new(0.5, 0, 0, 0)
bypassClick.ZIndex = 10
bypassClick.Parent = holder
local function setMode(mode)
if mode == "Bypass" then
mode = "Anti Bypass"
elseif mode ~= "Anti Bypass" then
mode = "Normal"
end
selectedAimbotMode = mode
refreshAimbotModeLabels()
if _G.ExeRefreshAimbotSpeedBoxes then _G.ExeRefreshAimbotSpeedBoxes() end
if _G.ExeRefreshAimbotVisual then _G.ExeRefreshAimbotVisual() end
if saveExeConfig then pcall(saveExeConfig) end
local onBypass = selectedAimbotMode == "Anti Bypass"
tween(slide, {
Position = onBypass and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(normalText, {
TextTransparency = onBypass and 0.18 or 0,
TextStrokeTransparency = onBypass and 0.38 or 0.2
}, 0.14)
tween(bypassText, {
TextTransparency = onBypass and 0 or 0.18,
TextStrokeTransparency = onBypass and 0.2 or 0.38
}, 0.14)
end
normalClick.MouseButton1Click:Connect(function()
setMode("Normal")
end)
bypassClick.MouseButton1Click:Connect(function()
setMode("Anti Bypass")
end)
setMode(selectedAimbotMode)
return holder, setMode
end
function autoStealSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Auto Steal Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)
local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)
local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(236, 236, 236)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide
local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 47, 47)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide
local normalText = Instance.new("TextLabel")
normalText.Name = "NormalText"
normalText.BackgroundTransparency = 1
normalText.Text = "AUTO STEAL V3"
normalText.TextColor3 = COLORS.white
normalText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
normalText.TextStrokeTransparency = 1
normalText.TextSize = 9
normalText.TextScaled = true
normalText.TextWrapped = false
normalText.Font = Enum.Font.GothamBold
normalText.TextXAlignment = Enum.TextXAlignment.Center
normalText.Size = UDim2.new(0.5, -8, 1, 0)
normalText.Position = UDim2.new(0, 4, 0, 0)
normalText.Position = UDim2.new(0, 0, 0, 0)
normalText.ZIndex = 8
normalText.Parent = holder
local normalTextConstraint = Instance.new("UITextSizeConstraint")
normalTextConstraint.MinTextSize = 7
normalTextConstraint.MaxTextSize = 10
normalTextConstraint.Parent = normalText
local semiText = Instance.new("TextLabel")
semiText.Name = "SemiText"
semiText.BackgroundTransparency = 1
semiText.Text = "SEMI"
semiText.TextColor3 = COLORS.white
semiText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
semiText.TextStrokeTransparency = 1
semiText.TextSize = 9
semiText.TextScaled = true
semiText.TextWrapped = false
semiText.Font = Enum.Font.GothamBold
semiText.TextXAlignment = Enum.TextXAlignment.Center
semiText.Size = UDim2.new(0.5, -8, 1, 0)
semiText.Position = UDim2.new(0.5, 4, 0, 0)
semiText.ZIndex = 8
semiText.Parent = holder
local semiTextConstraint = Instance.new("UITextSizeConstraint")
semiTextConstraint.MinTextSize = 7
semiTextConstraint.MaxTextSize = 10
semiTextConstraint.Parent = semiText
local normalClick = Instance.new("TextButton")
normalClick.Name = "NormalClick"
normalClick.BackgroundTransparency = 1
normalClick.Text = ""
normalClick.AutoButtonColor = false
normalClick.Size = UDim2.new(0.5, 0, 1, 0)
normalClick.Position = UDim2.new(0, 0, 0, 0)
normalClick.ZIndex = 10
normalClick.Parent = holder
local semiClick = Instance.new("TextButton")
semiClick.Name = "SemiClick"
semiClick.BackgroundTransparency = 1
semiClick.Text = ""
semiClick.AutoButtonColor = false
semiClick.Size = UDim2.new(0.5, 0, 1, 0)
semiClick.Position = UDim2.new(0.5, 0, 0, 0)
semiClick.ZIndex = 10
semiClick.Parent = holder
local function setMode(mode)
if mode ~= "Semi" then
mode = "Auto Steal V3"
end
_G.ExeStealRadii = _G.ExeStealRadii or {Normal = 62, Semi = 9}
_G.ExeStealRadii[selectedStealMode] = tonumber(autoStealRadius) or _G.ExeStealRadii[selectedStealMode]
selectedStealMode = mode
autoStealRadius = _G.ExeStealRadii[selectedStealMode] or ((selectedStealMode == "Semi") and 9 or 63)
if autoStealRadiusBox then
autoStealRadiusBox.Text = tostring(autoStealRadius)
end
if saveExeConfig then pcall(saveExeConfig) end
if _G.ExeNormalAutoStealSetRadius then _G.ExeNormalAutoStealSetRadius(_G.ExeStealRadii.Normal or 62) end
if _G.ExeSemiAutoStealSetRadius then _G.ExeSemiAutoStealSetRadius(_G.ExeStealRadii.Semi or 9) end
if _G.ExeAutoStealSync then _G.ExeAutoStealSync() end
local onSemi = selectedStealMode == "Semi"
tween(slide, {
Position = onSemi and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(normalText, {
TextTransparency = onSemi and 0.18 or 0,
TextStrokeTransparency = onSemi and 0.38 or 0.2
}, 0.14)
tween(semiText, {
TextTransparency = onSemi and 0 or 0.18,
TextStrokeTransparency = onSemi and 0.2 or 0.38
}, 0.14)
end
normalClick.MouseButton1Click:Connect(function()
setMode("Auto Steal V3")
end)
semiClick.MouseButton1Click:Connect(function()
setMode("Semi")
end)
setMode(selectedStealMode)
return holder, setMode
end

function infiniteJumpSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Infinite Jump Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(1, -8, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(236, 236, 236)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide

local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 47, 47)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22)),
})
slideGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.08),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide

local automaticText = Instance.new("TextLabel")
automaticText.Name = "AutomaticText"
automaticText.BackgroundTransparency = 1
automaticText.Text = "AUTOMATIC"
automaticText.TextColor3 = COLORS.white
automaticText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
automaticText.TextStrokeTransparency = 0.2
automaticText.TextSize = 10
automaticText.Font = Enum.Font.GothamMedium
automaticText.TextXAlignment = Enum.TextXAlignment.Center
automaticText.Size = UDim2.new(1, 0, 1, 0)
automaticText.Position = UDim2.new(0, 0, 0, 0)
automaticText.ZIndex = 8
automaticText.Parent = holder

local automaticClick = Instance.new("TextButton")
automaticClick.Name = "AutomaticClick"
automaticClick.BackgroundTransparency = 1
automaticClick.Text = ""
automaticClick.AutoButtonColor = false
automaticClick.Size = UDim2.new(1, 0, 1, 0)
automaticClick.Position = UDim2.new(0, 0, 0, 0)
automaticClick.ZIndex = 10
automaticClick.Parent = holder

local function setMode(_mode)
    _G.ExeInfJumpMode = "Hold"
    if _G.ExeStopNormalInfJumpHoldState then
        _G.ExeStopNormalInfJumpHoldState()
    end
    if saveExeConfig then pcall(saveExeConfig) end
end

automaticClick.MouseButton1Click:Connect(function()
    setMode("Hold")
end)

setMode("Hold")
return holder, setMode
end

function antiRagdollSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Anti Ragdoll Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(59, 59, 59)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(236, 236, 236)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide

local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 47, 47)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22)),
})
slideGradient.Parent = slide

local v1Text = Instance.new("TextLabel")
v1Text.BackgroundTransparency = 1
v1Text.Text = "ANTI RAGDOLL V1"
v1Text.TextColor3 = COLORS.white
v1Text.TextSize = 9
v1Text.Font = Enum.Font.GothamMedium
v1Text.Size = UDim2.new(0.5, 0, 1, 0)
v1Text.ZIndex = 8
v1Text.Parent = holder

local v2Text = Instance.new("TextLabel")
v2Text.BackgroundTransparency = 1
v2Text.Text = "ANTI RAGDOLL V2"
v2Text.TextColor3 = COLORS.white
v2Text.TextSize = 9
v2Text.Font = Enum.Font.GothamMedium
v2Text.Size = UDim2.new(0.5, 0, 1, 0)
v2Text.Position = UDim2.new(0.5, 0, 0, 0)
v2Text.ZIndex = 8
v2Text.Parent = holder

local v1Click = Instance.new("TextButton")
v1Click.BackgroundTransparency = 1
v1Click.Text = ""
v1Click.AutoButtonColor = false
v1Click.Size = UDim2.new(0.5, 0, 1, 0)
v1Click.ZIndex = 10
v1Click.Parent = holder

local v2Click = Instance.new("TextButton")
v2Click.BackgroundTransparency = 1
v2Click.Text = ""
v2Click.AutoButtonColor = false
v2Click.Size = UDim2.new(0.5, 0, 1, 0)
v2Click.Position = UDim2.new(0.5, 0, 0, 0)
v2Click.ZIndex = 10
v2Click.Parent = holder

local function setMode(mode)
_G.ExeAntiRagdollMode = (mode == "V2") and "V2" or "V1"

local onV2 = _G.ExeAntiRagdollMode == "V2"
tween(slide, {
Position = onV2 and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)

tween(v1Text, {
TextTransparency = onV2 and 0.18 or 0,
TextStrokeTransparency = onV2 and 0.38 or 0.2
}, 0.14)

tween(v2Text, {
TextTransparency = onV2 and 0 or 0.18,
TextStrokeTransparency = onV2 and 0.2 or 0.38
}, 0.14)

if antiRagdollEnabled then
setAntiRagdoll(true)
end

if saveExeConfig then pcall(saveExeConfig) end
end

v1Click.MouseButton1Click:Connect(function()
setMode("V1")
end)

v2Click.MouseButton1Click:Connect(function()
setMode("V2")
end)

setMode(_G.ExeAntiRagdollMode)
return holder, setMode
end

task.wait()
Movement = pages.MOVEMENT

section(Movement, "AUTO SPEED", -2)
_, setAutoCarrySpeedVisual = toggleRow(Movement, "Auto Carry Speed", autoCarrySpeedEnabled, -1)
do
local row = Movement:FindFirstChild("Auto Carry Speed")
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
autoCarrySpeedEnabled = not autoCarrySpeedEnabled
if autoCarrySpeedEnabled ~= true and _G.AutoCarrySpeed and _G.AutoCarrySpeed.Disable then
_G.AutoCarrySpeed.Disable()
end
if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
section(Movement, "NORMAL SPEED", 1)
_, normalSpeedBox = textboxRow(Movement, "Normal Speed", tostring(NS), 2)
normalSpeedBox.FocusLost:Connect(function()
local v = tonumber(normalSpeedBox.Text)
if v and v > 0 and v <= 250 then
NS = v
if saveExeConfig then pcall(saveExeConfig) end
end
normalSpeedBox.Text = tostring(NS)
end)
_, carrySpeedBox = textboxRow(Movement, "Carry Speed", tostring(CS), 3)
carrySpeedBox.FocusLost:Connect(function()
local v = tonumber(carrySpeedBox.Text)
if v and v > 0 and v <= 250 then
CS = v
if saveExeConfig then pcall(saveExeConfig) end
end
carrySpeedBox.Text = tostring(CS)
end)
modeDisplayRow(Movement, 4, "Normal")
section(Movement, "LAGGER SPEED", 5)
_, laggerSpeedBox = textboxRow(Movement, "Lagger Speed", tostring(LAGGER_SPEED), 6)
laggerSpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerSpeedBox.Text)
if v and v > 0 and v <= 250 then
LAGGER_SPEED = v
if saveExeConfig then pcall(saveExeConfig) end
end
laggerSpeedBox.Text = tostring(LAGGER_SPEED)
end)
_, laggerCarrySpeedBox = textboxRow(Movement, "Lagger Carry Speed", tostring(LAGGER_CARRY_SPEED), 7)
laggerCarrySpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerCarrySpeedBox.Text)
if v and v > 0 and v <= 250 then
LAGGER_CARRY_SPEED = v
if saveExeConfig then pcall(saveExeConfig) end
end
laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED)
end)
modeDisplayRow(Movement, 8, "Lagger")
section(Movement, "TELEPORT", 9)
autoTPRow = nil
autoTPRow, setAutoTPVisual = toggleRow(Movement, "Auto TP Down", autoTPEnabled, 10)
do
local autoTPButton = autoTPRow and autoTPRow:FindFirstChild("ToggleButton")
if autoTPButton then
autoTPButton.MouseButton1Click:Connect(function()
if autoTPClickDebounce then return end
autoTPClickDebounce = true
local nextState = not autoTPEnabled
toggleAutoTP(nextState)
task.delay(0.15, function()
autoTPClickDebounce = false
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled) end
end)
end)
end
if autoTPEnabled then
startAutoTP()
else
stopAutoTP()
end
end
_, autoTPHeightBox = textboxRow(Movement, "Auto TP Height", tostring(autoTPHeight), 11)
autoTPHeightBox.FocusLost:Connect(function()
local v = tonumber(autoTPHeightBox.Text)
if v and v >= -500 and v <= 500 then
autoTPHeight = v
end
autoTPHeightBox.Text = tostring(autoTPHeight)
if saveExeConfig then pcall(saveExeConfig) end
end)
section(Movement, "JUMP", 15)
_, setInfJumpVisual = toggleRow(Movement, "Infinite Jump", infJumpEnabled, 16)

_G.ExeInfJumpMainRow = Movement:FindFirstChild("Infinite Jump")
_G.ExeInfJumpToggleBtn = _G.ExeInfJumpMainRow and _G.ExeInfJumpMainRow:FindFirstChild("ToggleButton")
if _G.ExeInfJumpToggleBtn then
_G.ExeInfJumpToggleBtn.Size = UDim2.new(0, 54, 1, 0)
_G.ExeInfJumpToggleBtn.Position = UDim2.new(1, -54, 0, 0)
end

_G.ExeInfJumpArrow = Instance.new("TextButton")
_G.ExeInfJumpArrow.Name = "ArrowButton"
_G.ExeInfJumpArrow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.ExeInfJumpArrow.BackgroundTransparency = 0.18
_G.ExeInfJumpArrow.BorderSizePixel = 0
_G.ExeInfJumpArrow.Text = "v"
_G.ExeInfJumpArrow.TextColor3 = COLORS.white
_G.ExeInfJumpArrow.TextSize = 18
_G.ExeInfJumpArrow.Font = Enum.Font.GothamBlack
_G.ExeInfJumpArrow.AutoButtonColor = false
_G.ExeInfJumpArrow.Size = UDim2.new(0, 38, 0, 26)
_G.ExeInfJumpArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.ExeInfJumpArrow.ZIndex = 20
_G.ExeInfJumpArrow.Parent = _G.ExeInfJumpMainRow
corner(_G.ExeInfJumpArrow, 7)
stroke(_G.ExeInfJumpArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.ExeInfJumpSelector = infiniteJumpSelectorRow(Movement, 16.1)
_G.ExeInfJumpSelector.Visible = false
_G.ExeInfJumpSelector.Size = UDim2.new(1, -4, 0, 0)
_G.ExeInfJumpExpanded = false

_G.ExeInfJumpArrow.MouseButton1Click:Connect(function()
_G.ExeInfJumpExpanded = not _G.ExeInfJumpExpanded
if _G.ExeInfJumpExpanded then
_G.ExeInfJumpSelector.Visible = true
tween(_G.ExeInfJumpSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(_G.ExeInfJumpArrow, {Rotation = 180}, 0.15)
else
tween(_G.ExeInfJumpArrow, {Rotation = 0}, 0.15)
tween(_G.ExeInfJumpSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.ExeInfJumpExpanded then
_G.ExeInfJumpSelector.Visible = false
end
end)
end
end)

do
local row = Movement:FindFirstChild("Infinite Jump")
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
setInfJumpInternal(not infJumpEnabled)
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
_, setAntiRagdollVisual = toggleRow(Movement, "Anti Ragdoll", antiRagdollEnabled, 17)
do
    local row = Movement:FindFirstChild("Anti Ragdoll")
    local btn = row and row:FindFirstChild("ToggleButton")
    if btn then
        btn.Activated:Connect(function()
            setAntiRagdoll(not antiRagdollEnabled)
            if setAntiRagdollVisual then
                setAntiRagdollVisual(antiRagdollEnabled == true)
            end
        end)
    end
end

refreshSpeedModeRows()
task.wait()
Combat = pages.COMBAT
section(Combat, "AUTO STEAL", 1)

_aceRow, setAutoStealVisual = toggleRow(Combat, "Auto Steal", autoStealEnabled, 2)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Size = UDim2.new(0, 54, 1, 0)
_aceBtn.Position = UDim2.new(1, -54, 0, 0)
_aceBtn.Activated:Connect(function()
autoStealEnabled = not autoStealEnabled
if setAutoStealVisual then
setAutoStealVisual(autoStealEnabled)
end
if _G.ExeAutoStealSync then _G.ExeAutoStealSync() end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end

_G.ExeStealArrow = Instance.new("TextButton")
_G.ExeStealArrow.Name = "ArrowButton"
_G.ExeStealArrow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.ExeStealArrow.BackgroundTransparency = 0.18
_G.ExeStealArrow.BorderSizePixel = 0
_G.ExeStealArrow.Text = "v"
_G.ExeStealArrow.TextColor3 = COLORS.white
_G.ExeStealArrow.TextSize = 18
_G.ExeStealArrow.Font = Enum.Font.GothamBlack
_G.ExeStealArrow.AutoButtonColor = false
_G.ExeStealArrow.Size = UDim2.new(0, 38, 0, 26)
_G.ExeStealArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.ExeStealArrow.ZIndex = 20
_G.ExeStealArrow.Parent = _aceRow
corner(_G.ExeStealArrow, 7)
stroke(_G.ExeStealArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.ExeStealSelector = autoStealSelectorRow(Combat, 2.1)
_G.ExeStealSelector.Visible = false
_G.ExeStealSelector.Size = UDim2.new(1, -4, 0, 0)
_G.ExeStealExpanded = false

_G.ExeStealArrow.MouseButton1Click:Connect(function()
_G.ExeStealExpanded = not _G.ExeStealExpanded
if _G.ExeStealExpanded then
_G.ExeStealSelector.Visible = true
tween(_G.ExeStealSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(_G.ExeStealArrow, {Rotation = 180}, 0.15)
else
tween(_G.ExeStealArrow, {Rotation = 0}, 0.15)
tween(_G.ExeStealSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.ExeStealExpanded then
_G.ExeStealSelector.Visible = false
end
end)
end
end)

_, radiusBox = textboxRow(Combat, "Radius", tostring(autoStealRadius), 3)
autoStealRadiusBox = radiusBox
radiusBox.FocusLost:Connect(function()
local v = tonumber(radiusBox.Text)
if v and v > 0 and v <= 500 then
autoStealRadius = v
if selectedStealMode == "Auto Steal V3" then
    _G.ExeStealRadii = _G.ExeStealRadii or {}
    _G.ExeStealRadii["Auto Steal V3"] = v
end
end
_G.ExeStealRadii = _G.ExeStealRadii or {Normal = 62, Semi = 9}
_G.ExeStealRadii[selectedStealMode] = autoStealRadius
radiusBox.Text = tostring(autoStealRadius)
if _G.ExeNormalAutoStealSetRadius then _G.ExeNormalAutoStealSetRadius(_G.ExeStealRadii.Normal or 62) end
if _G.ExeSemiAutoStealSetRadius then _G.ExeSemiAutoStealSetRadius(_G.ExeStealRadii.Semi or 9) end
if _G.ExeAutoStealSync then _G.ExeAutoStealSync() end
if saveExeConfig then
    pcall(saveExeConfig)
end
do end
end)
local aimbotMainRow, _, aimbotArrow = aimbotModeButtonRow(Combat, 5)
local aimbotSelector = _G.ExeAimbotSelectorRow(Combat, 5.1)
aimbotSelector.Visible = false
aimbotSelector.Size = UDim2.new(1, -4, 0, 0)

local aimbotExpanded = false
if aimbotArrow then
aimbotArrow.MouseButton1Click:Connect(function()
aimbotExpanded = not aimbotExpanded
if aimbotExpanded then
aimbotSelector.Visible = true
tween(aimbotSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(aimbotArrow, {Rotation = 180}, 0.15)
else
tween(aimbotArrow, {Rotation = 0}, 0.15)
tween(aimbotSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not aimbotExpanded then
aimbotSelector.Visible = false
end
end)
end
end)
end

if _G.ExeRefreshAimbotVisual then
_G.ExeRefreshAimbotVisual()
end
_G.ExeNormalAutoSwingRow, _G.ExeNormalAutoSwingSetVisual, _G.ExeNormalAutoSwingBtn = _G.ExeActionToggleRow(Combat, "Auto Swing", autoSwingEnabled, 7)
do
if _G.ExeNormalAutoSwingBtn then
_G.ExeNormalAutoSwingBtn.MouseButton1Click:Connect(function()
if _G.ExeAutoSwingClickBusy then return end
_G.ExeAutoSwingClickBusy = true
autoSwingEnabled = not autoSwingEnabled
if _G.ExeNormalAutoSwingSetVisual then _G.ExeNormalAutoSwingSetVisual(autoSwingEnabled) end
if saveExeConfig then pcall(saveExeConfig) end
task.delay(0.12, function() _G.ExeAutoSwingClickBusy = false end)
end)
end
end
_G.ExeMirrorTPDownRow, _G.ExeMirrorTPDownSetVisual, _G.ExeMirrorTPDownBtn = _G.ExeActionToggleRow(Combat, "Mirror TP Down (Recommended)", mirrorTPDownEnabled, 7.1)
local mirrorTPDownLabel = _G.ExeMirrorTPDownRow and _G.ExeMirrorTPDownRow:FindFirstChild("Label")
if mirrorTPDownLabel then mirrorTPDownLabel.TextSize = 10 end
if _G.ExeMirrorTPDownBtn then
_G.ExeMirrorTPDownBtn.MouseButton1Click:Connect(function()
if _G.ExeMirrorTPDownClickBusy then return end
_G.ExeMirrorTPDownClickBusy = true
_G.ExeSetMirrorTPDown(not mirrorTPDownEnabled)
if saveExeConfig then pcall(saveExeConfig) end
task.delay(0.12, function() _G.ExeMirrorTPDownClickBusy = false end)
end)
end
aimbotSpeedRow, aimbotSpeedBox = textboxRow(Combat, "Normal Aimbot Speed", tostring(AIMBOT_SPEED), 8)
_G.ExeAimbotSpeedBox = aimbotSpeedBox
aimbotSpeedLabel = aimbotSpeedRow and aimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
aimbotSpeedBox.FocusLost:Connect(function()
local v = tonumber(aimbotSpeedBox.Text)
if v and v > 0 and v <= 250 then
_G.ExeSetSelectedAimbotSpeedValues(v, nil)
end
if _G.ExeRefreshAimbotSpeedBoxes then _G.ExeRefreshAimbotSpeedBoxes() else aimbotSpeedBox.Text = tostring(AIMBOT_SPEED) end
if saveExeConfig then pcall(saveExeConfig) end
end)
laggerAimbotSpeedRow, laggerAimbotSpeedBox = textboxRow(Combat, "Normal Lagger Aimbot Speed", tostring(LAGGER_AIMBOT_SPEED), 9)
_G.ExeLaggerAimbotSpeedBox = laggerAimbotSpeedBox
laggerAimbotSpeedLabel = laggerAimbotSpeedRow and laggerAimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
if _G.ExeRefreshAimbotSpeedBoxes then _G.ExeRefreshAimbotSpeedBoxes() end
laggerAimbotSpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerAimbotSpeedBox.Text)
if v and v > 0 and v <= 250 then
_G.ExeSetSelectedAimbotSpeedValues(nil, v)
end
if _G.ExeRefreshAimbotSpeedBoxes then _G.ExeRefreshAimbotSpeedBoxes() else laggerAimbotSpeedBox.Text = tostring(LAGGER_AIMBOT_SPEED) end
if saveExeConfig then pcall(saveExeConfig) end
end)

do
    local row = baseRow(Combat, "Drop After", 10.8)
    _G.ExeDropAfterRow = row
    local lbl = row:FindFirstChild("Label")
    if lbl then
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.AnchorPoint = Vector2.new(0.5, 0)
        lbl.Position = UDim2.new(0.5, 0, 0, 0)
        lbl.Size = UDim2.new(1, -24, 1, 0)
    end
    function _G.ExeRefreshDropAfterLabel()
        if lbl then lbl.Text = "Drop After: " .. tostring(_G.ExeDropAfterMode or "Off") end
    end
    local clickBtn = Instance.new("TextButton")
    clickBtn.Name = "DropAfterClick"
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.AutoButtonColor = false
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.ZIndex = 15
    clickBtn.Parent = row
    clickBtn.MouseButton1Click:Connect(function()
        local list = _G.ExeDropAfterModes
        local idx = 1
        for i, v in ipairs(list) do if v == _G.ExeDropAfterMode then idx = i end end
        _G.ExeDropAfterMode = list[(idx % #list) + 1]
        _G.ExeRefreshDropAfterLabel()
        if saveExeConfig then pcall(saveExeConfig) end
    end)
    _G.ExeRefreshDropAfterLabel()
end

local batV2SpeedRow, batV2SpeedBox = textboxRow(Combat, "BAT V2 Speed", tostring(BAT_V2_SPEED), 9.5)
_G.ExeBatV2SpeedBox = batV2SpeedBox
batV2SpeedBox.FocusLost:Connect(function()
    local value = tonumber(batV2SpeedBox.Text)
    if value and value >= 1 and value <= 120 then
        BAT_V2_SPEED = value
        _G.ExeBatV2Speed = value
    end
    batV2SpeedBox.Text = tostring(BAT_V2_SPEED)
    if saveExeConfig then pcall(saveExeConfig) end
end)

;(function()
local antiBatRow, antiBatSetVisual, antiBatBtn = _G.ExeActionToggleRow(Combat, "Anti Bat Bypass", false, 10.7)
_G.ExeAntiBatBypassSetVisual = function(on)
    if antiBatSetVisual then antiBatSetVisual(on == true) end
end
if antiBatBtn then
    antiBatBtn.MouseButton1Click:Connect(function()
        if _G.ExeToggleAntiBatBypass then _G.ExeToggleAntiBatBypass() end
    end)
end

section(Combat, "TP BAT", 11)
_G.ExeTpBatSelected = (_G.ExeTpBatSelected == "V2") and "V2" or "V1"
local tpBatRow, tpBatSetVisual, tpBatBtn = _G.ExeActionToggleRow(Combat, "TP Bat", false, 11.1)
local tpBatVerRow = baseRow(Combat, "TP Bat Version", 11.2)
local tpBatVerBtns = {}
local function tpBatRefreshVersionUI()
    for name, b in pairs(tpBatVerBtns) do
        local on = (_G.ExeTpBatSelected == name)
        b.BackgroundColor3 = on and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(20, 20, 20)
        b.BackgroundTransparency = on and 0.05 or 0.18
    end
end
for i, name in ipairs({"V1", "V2"}) do
    local b = Instance.new("TextButton")
    b.Name = "Ver_" .. name
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextColor3 = COLORS.white
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Size = UDim2.new(0, 50, 0, 24)
    b.Position = UDim2.new(1, -118 + (i - 1) * 56, 0.5, -12)
    b.ZIndex = 7
    b.Parent = tpBatVerRow
    corner(b, 7)
    tpBatVerBtns[name] = b
    b.MouseButton1Click:Connect(function()
        _G.ExeTpBatSelected = name
        if (_G.ExeTpBatV1On == true) or (_G.ExeTpBatV2On == true) then
            if _G.ExeStartTpBat then _G.ExeStartTpBat(name) end
        end
        tpBatRefreshVersionUI()
        if _G.ExeTpBatMobileRefresh then pcall(_G.ExeTpBatMobileRefresh) end
        if saveExeConfig then pcall(saveExeConfig) end
    end)
end
tpBatRefreshVersionUI()
_G.ExeTpBatSetVisual = function()
    if tpBatSetVisual then tpBatSetVisual((_G.ExeTpBatV1On == true) or (_G.ExeTpBatV2On == true)) end
    tpBatRefreshVersionUI()
end
if tpBatBtn then
    tpBatBtn.MouseButton1Click:Connect(function()
        if (_G.ExeTpBatV1On == true) or (_G.ExeTpBatV2On == true) then
            if _G.ExeStopTpBat then _G.ExeStopTpBat() end
        else
            if _G.ExeStartTpBat then _G.ExeStartTpBat(_G.ExeTpBatSelected) end
        end
    end)
end
end)()

_, _G.ExeBodyLockVisual = toggleRow(Combat, "Body Lock", _G.ExeBodyLockEnabled, 6.5)

_G.ExeBodyLockMainRow = Combat:FindFirstChild("Body Lock")
_G.ExeBodyLockToggleBtn = _G.ExeBodyLockMainRow and _G.ExeBodyLockMainRow:FindFirstChild("ToggleButton")
if _G.ExeBodyLockToggleBtn then
_G.ExeBodyLockToggleBtn.Size = UDim2.new(0, 54, 1, 0)
_G.ExeBodyLockToggleBtn.Position = UDim2.new(1, -54, 0, 0)
end

_G.ExeBodyLockArrow = Instance.new("TextButton")
_G.ExeBodyLockArrow.Name = "ArrowButton"
_G.ExeBodyLockArrow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.ExeBodyLockArrow.BackgroundTransparency = 0.18
_G.ExeBodyLockArrow.BorderSizePixel = 0
_G.ExeBodyLockArrow.Text = "v"
_G.ExeBodyLockArrow.TextColor3 = COLORS.white
_G.ExeBodyLockArrow.TextSize = 18
_G.ExeBodyLockArrow.Font = Enum.Font.GothamBlack
_G.ExeBodyLockArrow.AutoButtonColor = false
_G.ExeBodyLockArrow.Size = UDim2.new(0, 38, 0, 26)
_G.ExeBodyLockArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.ExeBodyLockArrow.ZIndex = 20
_G.ExeBodyLockArrow.Parent = _G.ExeBodyLockMainRow
corner(_G.ExeBodyLockArrow, 7)
stroke(_G.ExeBodyLockArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.ExeBodyLockSettings = baseRow(Combat, "Lock Radius", 6.6)
_G.ExeBodyLockSettings.Visible = false
_G.ExeBodyLockSettings.Size = UDim2.new(1, -4, 0, 0)
_G.ExeBodyLockSettings.ClipsDescendants = true

_G.ExeBodyLockRadiusBox = Instance.new("TextBox")
_G.ExeBodyLockRadiusBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_G.ExeBodyLockRadiusBox.BackgroundTransparency = 0.18
_G.ExeBodyLockRadiusBox.Text = tostring(_G.ExeBodyLockRadius)
_G.ExeBodyLockRadiusBox.TextColor3 = COLORS.white
_G.ExeBodyLockRadiusBox.TextSize = 11
_G.ExeBodyLockRadiusBox.Font = Enum.Font.GothamMedium
_G.ExeBodyLockRadiusBox.ClearTextOnFocus = false
_G.ExeBodyLockRadiusBox.Size = UDim2.new(0, 76, 0, 28)
_G.ExeBodyLockRadiusBox.Position = UDim2.new(1, -88, 0.5, -14)
_G.ExeBodyLockRadiusBox.BorderSizePixel = 0
_G.ExeBodyLockRadiusBox.ZIndex = 7
_G.ExeBodyLockRadiusBox.Parent = _G.ExeBodyLockSettings
corner(_G.ExeBodyLockRadiusBox, 7)
stroke(_G.ExeBodyLockRadiusBox, COLORS.strokeSoft, 1, 0.35)

_G.ExeBodyLockRadiusBox.FocusLost:Connect(function()
local n = tonumber(_G.ExeBodyLockRadiusBox.Text)
if n then
_G.ExeBodyLockRadius = math.clamp(n, 5, 200)
end
_G.ExeBodyLockRadiusBox.Text = tostring(_G.ExeBodyLockRadius)
end)

_G.ExeBodyLockExpanded = false
_G.ExeBodyLockArrow.MouseButton1Click:Connect(function()
_G.ExeBodyLockExpanded = not _G.ExeBodyLockExpanded

if _G.ExeBodyLockExpanded then
_G.ExeBodyLockArrow.Text = "^"
_G.ExeBodyLockSettings.Visible = true
tween(_G.ExeBodyLockSettings, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
else
_G.ExeBodyLockArrow.Text = "v"
tween(_G.ExeBodyLockSettings, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.ExeBodyLockExpanded and _G.ExeBodyLockSettings then
_G.ExeBodyLockSettings.Visible = false
end
end)
end
end)

_G.ExeBodyLockButton = _G.ExeBodyLockToggleBtn
if _G.ExeBodyLockButton then
_G.ExeBodyLockButton.Activated:Connect(function()
_G.ExeSetBodyLock(not _G.ExeBodyLockEnabled)
if _G.ExeBodyLockVisual then
_G.ExeBodyLockVisual(_G.ExeBodyLockEnabled)
end
end)
end

task.defer(function()
task.wait(0.5)
if _G.ExeBodyLockEnabled then
_G.ExeStartBodyLock()
end
if _G.ExeBodyLockVisual then
_G.ExeBodyLockVisual(_G.ExeBodyLockEnabled)
end
end)

_G.ExeAntiDesyncSetVisual = function(_) end
_G.ExeAntiTpBatSetVisual = function(_) end

section(Combat, "COUNTERS", 13)
_aceRow, setBatCounterVisual = _G.ExeActionToggleRow(Combat, "Bat Counter", batCounterEnabled, 14)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
batCounterEnabled = not batCounterEnabled
if setBatCounterVisual then
setBatCounterVisual(batCounterEnabled)
end
if batCounterEnabled then
if _G.ExeStartBatCounter then _G.ExeStartBatCounter() end
else
if _G.ExeStopBatCounter then _G.ExeStopBatCounter() end
end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
_aceRow, setMedCounterVisual = _G.ExeActionToggleRow(Combat, "Med Counter", medCounterEnabled, 15)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
medCounterEnabled = not medCounterEnabled
if setMedCounterVisual then
setMedCounterVisual(medCounterEnabled)
end
if medCounterEnabled then
if _G.ExeStartMedCounter then _G.ExeStartMedCounter(LP.Character) end
else
if _G.ExeStopMedCounter then _G.ExeStopMedCounter() end
end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
section(Combat, "HARD HIT", 15.2)
_aceRow, setHardHitVisual = _G.ExeActionToggleRow(Combat, "Hard Hit", hardHitEnabled == true, 15.3)
_G.ExeHardHitVisual = setHardHitVisual
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
hardHitEnabled = not hardHitEnabled
if setHardHitVisual then
setHardHitVisual(hardHitEnabled)
end
if hardHitEnabled then
if _G.ExeStartHardHit then _G.ExeStartHardHit() end
else
if _G.ExeStopHardHit then _G.ExeStopHardHit() end
end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
_, hardHitRadiusBox = textboxRow(Combat, "Hard Hit Range", tostring(hardHitRadius or 10), 15.4)
hardHitRadiusBox.FocusLost:Connect(function()
local v = tonumber(hardHitRadiusBox.Text)
if v and v >= 1 and v <= 100 then
if _G.ExeSetHardHitRadius then _G.ExeSetHardHitRadius(v) end
end
hardHitRadiusBox.Text = tostring(hardHitRadius or 10)
if saveExeConfig then
    pcall(saveExeConfig)
end
end)
section(Combat, "PERFECT HIT", 15.5)
_aceRow, setPerfectHitVisual = _G.ExeActionToggleRow(Combat, "Perfect Hit", perfectHitEnabled == true, 15.6)
_G.ExePerfectHitVisual = setPerfectHitVisual
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
perfectHitEnabled = not perfectHitEnabled
if setPerfectHitVisual then
setPerfectHitVisual(perfectHitEnabled)
end
if perfectHitEnabled then
if _G.ExeStartPerfectHit then _G.ExeStartPerfectHit() end
else
if _G.ExeStopPerfectHit then _G.ExeStopPerfectHit() end
end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
_, perfectHitRangeBox = textboxRow(Combat, "Perfect Hit Range", tostring(perfectHitRange or 175), 15.7)
perfectHitRangeBox.FocusLost:Connect(function()
local v = tonumber(perfectHitRangeBox.Text)
if v and v >= 10 and v <= 500 then
if _G.ExeSetPerfectHitRange then _G.ExeSetPerfectHitRange(v) end
end
perfectHitRangeBox.Text = tostring(perfectHitRange or 175)
if saveExeConfig then
    pcall(saveExeConfig)
end
end)

section(Combat, "ANTI TOGGLES", 15.8)
_, _G.ExeAntiResetVisual = toggleRow(Combat, "Anti Die", _G.ExeAntiResetEnabled, 15.85)
_G.ExeAntiResetRow = Combat:FindFirstChild("Anti Die")
_G.ExeAntiResetButton = _G.ExeAntiResetRow and _G.ExeAntiResetRow:FindFirstChild("ToggleButton")
if _G.ExeAntiResetButton then
_G.ExeAntiResetButton.Activated:Connect(function()
_G.ExeSetAntiReset(not _G.ExeAntiResetEnabled)
if _G.ExeAntiResetVisual then _G.ExeAntiResetVisual(_G.ExeAntiResetEnabled == true) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end

_, _G.ExeAntiVoidVisual = toggleRow(Combat, "Anti Void", _G.ExeAntiVoidEnabled, 15.9)
_G.ExeAntiVoidRow = Combat:FindFirstChild("Anti Void")
_G.ExeAntiVoidButton = _G.ExeAntiVoidRow and _G.ExeAntiVoidRow:FindFirstChild("ToggleButton")
if _G.ExeAntiVoidButton then
_G.ExeAntiVoidButton.Activated:Connect(function()
_G.ExeAntiVoidSet(not _G.ExeAntiVoidEnabled)
if _G.ExeAntiVoidVisual then _G.ExeAntiVoidVisual(_G.ExeAntiVoidEnabled == true) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end

_, _G.ExeAntiE01Visual = toggleRow(Combat, "Anti E01 Error", _G.ExeAntiE01Enabled == true, 15.95)
do
local row = Combat:FindFirstChild("Anti E01 Error")
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
if _G.ExeSetAntiE01 then
_G.ExeSetAntiE01(not (_G.ExeAntiE01Enabled == true))
else
_G.ExeAntiE01Enabled = not (_G.ExeAntiE01Enabled == true)
if _G.ExeAntiE01Visual then _G.ExeAntiE01Visual(_G.ExeAntiE01Enabled == true) end
if saveExeConfig then pcall(saveExeConfig) end
end
end)
end
end

_, _G.ExeAntiDropVisual = toggleRow(Combat, "Anti Drop", _G.ExeAntiDropEnabled == true, 15.97)
do
local row = Combat:FindFirstChild("Anti Drop")
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
if _G.ExeSetAntiDrop then
_G.ExeSetAntiDrop(not (_G.ExeAntiDropEnabled == true))
else
_G.ExeAntiDropEnabled = not (_G.ExeAntiDropEnabled == true)
if _G.ExeAntiDropVisual then _G.ExeAntiDropVisual(_G.ExeAntiDropEnabled == true) end
if saveExeConfig then pcall(saveExeConfig) end
end
end)
end
end

-- Sync anti toggle visuals + force-start if saved on
task.defer(function()
    if _G.ExeAntiResetVisual then pcall(_G.ExeAntiResetVisual, _G.ExeAntiResetEnabled == true) end
    if _G.ExeAntiVoidVisual then pcall(_G.ExeAntiVoidVisual, _G.ExeAntiVoidEnabled == true) end
    if _G.ExeAntiE01Visual then pcall(_G.ExeAntiE01Visual, _G.ExeAntiE01Enabled == true) end
    if _G.ExeAntiDropVisual then pcall(_G.ExeAntiDropVisual, _G.ExeAntiDropEnabled == true) end
    if _G.ExeAntiVoidEnabled == true and _G.ExeAntiVoidSet then pcall(_G.ExeAntiVoidSet, true) end
    if _G.ExeAntiResetEnabled == true and _G.ExeSetAntiReset then pcall(_G.ExeSetAntiReset, true) end
    if _G.ExeAntiE01Enabled == true and _G.ExeSetAntiE01 then pcall(_G.ExeSetAntiE01, true) end
    if _G.ExeAntiDropEnabled == true and _G.ExeSetAntiDrop then pcall(_G.ExeSetAntiDrop, true) end
end)

_aceRow, _G.ExeSetNoPlayerCollisionVisual = _G.ExeActionToggleRow(Combat, "No Player Collision", _G.ExeNoPlayerCollisionEnabled, 16)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
_G.ExeNoPlayerCollisionEnabled = not _G.ExeNoPlayerCollisionEnabled
if _G.ExeSetNoPlayerCollisionVisual then _G.ExeSetNoPlayerCollisionVisual(_G.ExeNoPlayerCollisionEnabled) end
if _G.ExeNoPlayerCollisionEnabled then
if enableNoPlayerCollision then enableNoPlayerCollision() end
else
if disableNoPlayerCollision then disableNoPlayerCollision() end
end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
-- ANTI TOGGLES are hidden and always ON (forced at execute, re-enabled if anything turns them off)
function _G.ExeForceAntiToggles(all)
    if all or _G.ExeAntiResetEnabled ~= true then
        _G.ExeAntiResetEnabled = true
        if _G.ExeSetAntiReset then pcall(_G.ExeSetAntiReset, true) end
    end
    if all or _G.ExeAntiVoidEnabled ~= true then
        _G.ExeAntiVoidEnabled = true
        if _G.ExeAntiVoidSet then pcall(_G.ExeAntiVoidSet, true) end
    end
    if all or _G.ExeAntiE01Enabled ~= true then
        _G.ExeAntiE01Enabled = true
        if _G.ExeSetAntiE01 then pcall(_G.ExeSetAntiE01, true) end
    end
    if all or _G.ExeAntiDropEnabled ~= true then
        _G.ExeAntiDropEnabled = true
        if _G.ExeSetAntiDrop then pcall(_G.ExeSetAntiDrop, true) end
    end
    if all or _G.ExeNoPlayerCollisionEnabled ~= true then
        _G.ExeNoPlayerCollisionEnabled = true
        if enableNoPlayerCollision then pcall(enableNoPlayerCollision) end
    end
end
task.spawn(function()
    task.wait(1)
    pcall(_G.ExeForceAntiToggles, true)
    while Gui and Gui.Parent do
        task.wait(1)
        pcall(_G.ExeForceAntiToggles, false)
    end
end)

_G.ExeDropModeMainRow = baseRow(Combat, "Drop", 18.5)
do
local _dropLbl = _G.ExeDropModeMainRow and _G.ExeDropModeMainRow:FindFirstChild("Label")
if _dropLbl then
    _dropLbl.TextXAlignment = Enum.TextXAlignment.Center
    _dropLbl.AnchorPoint = Vector2.new(0.5, 0)
    _dropLbl.Position = UDim2.new(0.5, 0, 0, 0)
    _dropLbl.Size = UDim2.new(1, -24, 1, 0)
end
end

_G.ExeDropAction = Instance.new("TextButton")
_G.ExeDropAction.Name = "DropAction"
_G.ExeDropAction.BackgroundTransparency = 1
_G.ExeDropAction.Text = ""
_G.ExeDropAction.AutoButtonColor = false
_G.ExeDropAction.Size = UDim2.new(1, 0, 1, 0)
_G.ExeDropAction.Position = UDim2.new(0, 0, 0, 0)
_G.ExeDropAction.ZIndex = 15
_G.ExeDropAction.Parent = _G.ExeDropModeMainRow

_G.ExeDropSelector = nil
_G.ExeDropExpanded = false

_G.ExeDropAction.MouseButton1Click:Connect(function()
pcall(runDrop)
end)

-- Anti Void moved under ANTI TOGGLES

section(Movement, "AUTO PLAY", 100)

do
    __SH_duelModeRow = baseRow(Movement, "Duel Mode", 101)
    __SH_duelModeRow.Size = UDim2.new(1,-4,0,42)

    __SH_duelModeLabel = __SH_duelModeRow:FindFirstChild("Label")
    if __SH_duelModeLabel then
        __SH_duelModeLabel.Text = "Duel Mode"
        __SH_duelModeLabel.Size = UDim2.new(0.35,0,1,0)
    end

    __SH_halfBtn = Instance.new("TextButton")
    __SH_halfBtn.Name = "HalfButton"
    __SH_halfBtn.Size = UDim2.new(0,58,0,28)
    __SH_halfBtn.Position = UDim2.new(1,-134,0.5,-14)
    __SH_halfBtn.BackgroundTransparency = 1
    __SH_halfBtn.BorderSizePixel = 0
    __SH_halfBtn.Text = "HALF"
    __SH_halfBtn.Font = Enum.Font.GothamMedium
    __SH_halfBtn.TextSize = 10
    __SH_halfBtn.ZIndex = 20
    __SH_halfBtn.Parent = __SH_duelModeRow
    corner(__SH_halfBtn,6)
    stroke(__SH_halfBtn,COLORS.strokeSoft,1,0.45)

    __SH_fullBtn = Instance.new("TextButton")
    __SH_fullBtn.Name = "FullButton"
    __SH_fullBtn.Size = UDim2.new(0,58,0,28)
    __SH_fullBtn.Position = UDim2.new(1,-70,0.5,-14)
    __SH_fullBtn.BackgroundTransparency = 1
    __SH_fullBtn.BorderSizePixel = 0
    __SH_fullBtn.Text = "FULL"
    __SH_fullBtn.Font = Enum.Font.GothamMedium
    __SH_fullBtn.TextSize = 10
    __SH_fullBtn.ZIndex = 20
    __SH_fullBtn.Parent = __SH_duelModeRow
    corner(__SH_fullBtn,6)
    stroke(__SH_fullBtn,COLORS.strokeSoft,1,0.45)

    function __SH_refreshDuelBtns()
        __SH_halfBtn.TextColor3 = (_G.ExeDuelMode == "half")
            and Color3.fromRGB(255,255,255)
            or Color3.fromRGB(140,140,140)

        __SH_fullBtn.TextColor3 = (_G.ExeDuelMode == "full")
            and Color3.fromRGB(255,255,255)
            or Color3.fromRGB(140,140,140)

        if _G.ExeAutoMoveCarrySpeedBox then
            local row = _G.ExeAutoMoveCarrySpeedBox.Parent
            if row then
                row.Visible = (_G.ExeDuelMode == "full")
            end
        end
    end

    _G.ExeRefreshDuelModeButtons = __SH_refreshDuelBtns

    __SH_halfBtn.MouseButton1Click:Connect(function()
        _G.ExeDuelMode = "half"
        __SH_refreshDuelBtns()
        if saveExeConfig then pcall(saveExeConfig) end
    end)

    __SH_fullBtn.MouseButton1Click:Connect(function()
        _G.ExeDuelMode = "full"
        __SH_refreshDuelBtns()
        if saveExeConfig then pcall(saveExeConfig) end
    end)

    __SH_refreshDuelBtns()
end

task.wait()
MenuCustomize = pages.MENU

task.wait()
Keybinds = pages.KEYBINDS
section(Keybinds, "MOVEMENT KEYBINDS", 1)
speedKeybindRow(Keybinds, "Speed Key", "SpeedToggle", 2)
speedKeybindRow(Keybinds, "Lagger Mode Key", "LaggerToggle", 3)
tpDownKeybindRow(Keybinds, 4)
speedKeybindRow(Keybinds, "Drop Brainrot", "DropBrainrot", 5)
section(Keybinds, "COMBAT KEYBINDS", 6)
aimbotKeybindRow = speedKeybindRow(Keybinds, "Normal Aimbot", "Aimbot", 7)
combatAimbotKeybindLabel = aimbotKeybindRow and aimbotKeybindRow:FindFirstChild("Label")
refreshAimbotModeLabels()
speedKeybindRow(Keybinds, "Auto Left", "AutoLeft", 9)
speedKeybindRow(Keybinds, "Auto Right", "AutoRight", 10)
speedKeybindRow(Keybinds, "Insta Reset", "InstaReset", 11)
speedKeybindRow(Keybinds, "Lagger Carry", "MB_laggerCarry", 3.5)
speedKeybindRow(Keybinds, "Auto Play", "MB_autoPlay", 11.1)
speedKeybindRow(Keybinds, "Bat V2", "MB_batV2", 11.2)
speedKeybindRow(Keybinds, "Anti Bat Bypass", "MB_antiBat", 11.3)
speedKeybindRow(Keybinds, "TP Bat", "MB_tpBat", 11.4)
speedKeybindRow(Keybinds, "Insta Medusa", "MB_instaMedusa", 11.5)
do
THEME_ACCENT = Color3.fromRGB(255, 255, 255)
THEME_ACCENT_DIM = Color3.fromRGB(160, 160, 160)
PlayerESP = PlayerESP or {enabled=false, playerData={}, conns={}, discordText="discord.gg/YF8vD7w6m"}
BoxedESPOptions = BoxedESPOptions or {box=false, tracer=false}
BoxedESPData = BoxedESPData or {}
BoxedESPConn = BoxedESPConn or nil
stretchRezConn = stretchRezConn or nil
antiLagDescConn = antiLagDescConn or nil
noCamCollisionConn = noCamCollisionConn or nil
noCamCollisionParts = noCamCollisionParts or {}
_aceNukeConns = _aceNukeConns or {}
_aceNukeOn = _aceNukeOn or false
_aceCustomFontOrig = _aceCustomFontOrig or {}
_aceCustomFontConn = _aceCustomFontConn or nil
_aceCustomFont = _aceCustomFont or nil
function startPlayerESP()
if PlayerESP.enabled then return end
PlayerESP.enabled = true
function cleanup(plr)
local d=PlayerESP.playerData[plr]; if not d then return end
pcall(function() if d.highlight then d.highlight:Destroy() end end)
pcall(function() if d.billboard then d.billboard:Destroy() end end)
if d.conns then for _,c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
PlayerESP.playerData[plr]=nil
end
function setup(plr,char)
if not PlayerESP.enabled or plr==LP then return end
cleanup(plr)
local hrp=char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5))
local head=char and (char:FindFirstChild("Head") or char:WaitForChild("Head",5))
if not hrp or not head then return end
local hl=Instance.new("Highlight")
hl.Name="ExeDuelsESP"; hl.Adornee=char; hl.FillColor=(_G.ExeThemeColors and _G.ExeThemeColors[_G.ExeThemeName]) or THEME_ACCENT; hl.FillTransparency=0.72
hl.OutlineColor=(_G.ExeThemeColors and _G.ExeThemeColors[_G.ExeThemeName]) or THEME_ACCENT; hl.OutlineTransparency=0; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=char
local bb=Instance.new("BillboardGui")
bb.Name="ExeDuelsESPTag"; bb.Adornee=head; bb.Size=UDim2.new(0,170,0,42); bb.StudsOffset=Vector3.new(0,2.8,0); bb.AlwaysOnTop=true; bb.LightInfluence=0; bb.Parent=head
local box=Instance.new("Frame",bb); box.Size=UDim2.new(1,0,1,0); box.BackgroundTransparency=1; box.BorderSizePixel=0
Instance.new("UICorner",box).CornerRadius=UDim.new(0,9)
local n=Instance.new("TextLabel",box); n.Size=UDim2.new(1,-8,0,19); n.Position=UDim2.new(0,4,0,1); n.BackgroundTransparency=1; n.TextColor3=Color3.fromRGB(255,255,255); n.TextStrokeColor3=Color3.fromRGB(0,0,0); n.Font=Enum.Font.GothamBlack; n.TextSize=13; n.TextStrokeTransparency=0.08
local sub=Instance.new("TextLabel",box); sub.Size=UDim2.new(1,-8,0,17); sub.Position=UDim2.new(0,4,0,19); sub.BackgroundTransparency=1; sub.TextColor3=Color3.fromRGB(255,255,255); sub.TextStrokeColor3=Color3.fromRGB(0,0,0); sub.Font=Enum.Font.GothamBlack; sub.TextSize=11; sub.TextStrokeTransparency=0.08
local conn=RunService.Heartbeat:Connect(function()
if not PlayerESP.enabled or not hrp.Parent then return end
local v=hrp.AssemblyLinearVelocity or hrp.Velocity
n.Text=string.format("Speed: %.1f", Vector3.new(v.X,0,v.Z).Magnitude); sub.Text=plr.Name
end)
PlayerESP.playerData[plr]={highlight=hl,billboard=bb,conns={conn}}
end
for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then if plr.Character then setup(plr,plr.Character) end; table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end
table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr) if plr~=LP then table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end))
table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanup))
end
function stopPlayerESP()
PlayerESP.enabled=false
for _,c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end
PlayerESP.conns={}
for plr,d in pairs(PlayerESP.playerData or {}) do pcall(function() if d.highlight then d.highlight:Destroy() end end); pcall(function() if d.billboard then d.billboard:Destroy() end end) end
PlayerESP.playerData={}
end
function _aceEspColor()
return THEME_ACCENT or Color3.fromRGB(230,230,230)
end
function _safeDrawing(kind, props)
if not Drawing or not Drawing.new then return nil end
local ok, obj = pcall(function() return Drawing.new(kind) end)
if not ok or not obj then return nil end
for k,v in pairs(props or {}) do pcall(function() obj[k]=v end) end
return obj
end
function _cleanupBoxedESPPlayer(player)
local data = BoxedESPData[player]
if not data then return end
for _,obj in pairs(data) do
pcall(function()
obj.Visible = false
if obj.Remove then obj:Remove() end
end)
end
BoxedESPData[player] = nil
end
function _cleanupBoxedESP()
for player,_ in pairs(BoxedESPData) do _cleanupBoxedESPPlayer(player) end
end
function _updateBoxedESP()
local cam = workspace.CurrentCamera
if not cam then return end
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if not anyOn then
_cleanupBoxedESP()
return
end
for _,player in ipairs(Players:GetPlayers()) do
if player == LP then continue end
local char = player.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local head = char and char:FindFirstChild("Head")
if not root or not head then
_cleanupBoxedESPPlayer(player)
continue
end
local rootPos,onScreen = cam:WorldToViewportPoint(root.Position)
local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.55,0))
local data = BoxedESPData[player]
if not data then
data = {
box = _safeDrawing("Square",{Thickness=2,Filled=false,Transparency=1,Color=_aceEspColor()}),
tracer = _safeDrawing("Line",{Thickness=2,Transparency=1,Color=_aceEspColor()}),
}
BoxedESPData[player] = data
end
local color = _aceEspColor()
local height = math.abs(headPos.Y - rootPos.Y) * 2.15
if height < 20 or height ~= height then height = 65 end
local width = height / 2.15
local view = cam.ViewportSize
local centerX, centerY = view.X/2, view.Y/2
local targetX, targetY = rootPos.X, rootPos.Y + height/2
local targetVisible = onScreen and rootPos.Z > 0
if not targetVisible then
local dx = rootPos.X - centerX
local dy = rootPos.Y - centerY
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
if math.abs(dx) < 1 and math.abs(dy) < 1 then
local rel = cam.CFrame:PointToObjectSpace(root.Position)
dx = rel.X
dy = -rel.Y
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
end
local edgePad = 10
local scaleX = (dx ~= 0) and ((view.X/2 - edgePad) / math.abs(dx)) or math.huge
local scaleY = (dy ~= 0) and ((view.Y/2 - edgePad) / math.abs(dy)) or math.huge
local scale = math.min(scaleX, scaleY)
if scale == math.huge or scale ~= scale then scale = 1 end
targetX = math.clamp(centerX + dx * scale, edgePad, view.X - edgePad)
targetY = math.clamp(centerY + dy * scale, edgePad, view.Y - edgePad)
end
if data.box then
data.box.Color = color
data.box.Size = Vector2.new(width,height)
data.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
data.box.Visible = false
end
if data.tracer then
data.tracer.Color = color
local localChar = LP.Character
local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
local localHead = localChar and localChar:FindFirstChild("Head")
local fromX, fromY
if localRoot then
local localScreen = cam:WorldToViewportPoint(localRoot.Position)
fromX = localScreen.X
fromY = localScreen.Y + 15
end
if not fromX or not fromY then
fromX = cam.ViewportSize.X/2
fromY = cam.ViewportSize.Y - 88
end
data.tracer.From = Vector2.new(fromX, fromY)
data.tracer.To = Vector2.new(targetX, targetY)
data.tracer.Visible = BoxedESPOptions.tracer == true
end
end
end
function refreshBoxedESP()
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if anyOn and not BoxedESPConn then
BoxedESPConn = RunService.RenderStepped:Connect(_updateBoxedESP)
elseif (not anyOn) and BoxedESPConn then
BoxedESPConn:Disconnect()
BoxedESPConn = nil
_cleanupBoxedESP()
end
end
Players.PlayerRemoving:Connect(_cleanupBoxedESPPlayer)
SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

local function _vC3(t)
    return Color3.fromRGB(t[1], t[2], t[3])
end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_ExeDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_ExeDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()

    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end

    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true

    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2

    if preset.outAmb then
        Lighting.OutdoorAmbient = _vC3(preset.outAmb)
    end

    if preset.ambient then
        Lighting.Ambient = _vC3(preset.ambient)
    end

    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_ExeDuelsSky", true)

        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end

        skyInst.Parent = Lighting
    end

    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_ExeDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_ExeDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end

    skyTheme = mode
end

_G.ExeStretchValue = 0.70
_G.ExeStretchPreset = "Medium"

_G.ExeStretchPresets = {
    ["Light"] = 0.85,
    ["Medium"] = 0.70,
    ["Strong"] = 0.55,
    ["Extreme"] = 0.40,
}

function enableStretchRez()
    fpsBoostEnabled = true
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end

    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not fpsBoostEnabled then
            if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end
            return
        end

        local cam = Workspace.CurrentCamera or workspace.CurrentCamera
        if cam then
            local sv = 0.70

            cam.CFrame = cam.CFrame * CFrame.new(
                0,0,0,
                1,0,0,
                0,sv,0,
                0,0,1
            )
        end
    end)
end

function disableStretchRez()
    fpsBoostEnabled = false
    if stretchRezConn then
        stretchRezConn:Disconnect()
        stretchRezConn = nil
    end
end

function _G.ExeSetStretchPreset(name)
    local v = _G.ExeStretchPresets[name]
    if not v then return end
    _G.ExeStretchPreset = name
    _G.ExeStretchValue = v
end

function enableCustomFov() fovEnabled=true; workspace.CurrentCamera.FieldOfView=fovValue; if customFovConn then customFovConn:Disconnect() end; customFovConn=RunService.RenderStepped:Connect(function() if not fovEnabled then customFovConn:Disconnect(); customFovConn=nil; return end; workspace.CurrentCamera.FieldOfView=fovValue end) end
function disableCustomFov() fovEnabled=false; if customFovConn then customFovConn:Disconnect(); customFovConn=nil end; workspace.CurrentCamera.FieldOfView=fpsBoostEnabled and 107 or 70 end
_G.ExeZombieAntiLag = _G.ExeZombieAntiLag or {
    conn=nil,
    active=false,
    defBrightness=nil,
    defFog=nil,
    defDiffuse=nil,
    defSpecular=nil,
}

function _applyAntiLagObj(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("Fire")
            or obj:IsA("Smoke")
            or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _,tr in ipairs(obj:GetPlayingAnimationTracks()) do
                pcall(function() tr:Stop(0) end)
            end
        end
    end)
end

function enableAntiLag()
    antiLagVisualEnabled = true
    local S = _G.ExeZombieAntiLag
    S.active = true
    S.defBrightness = S.defBrightness or Lighting.Brightness
    S.defFog = S.defFog or Lighting.FogEnd
    S.defDiffuse = S.defDiffuse or Lighting.EnvironmentDiffuseScale
    S.defSpecular = S.defSpecular or Lighting.EnvironmentSpecularScale

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _,e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect")
                or e:IsA("SunRaysEffect")
                or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect")
                or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end

    for _,obj in ipairs(workspace:GetDescendants()) do
        _applyAntiLagObj(obj)
    end

    if S.conn then S.conn:Disconnect() end
    S.conn = workspace.DescendantAdded:Connect(function(obj)
        if S.active then _applyAntiLagObj(obj) end
    end)
    antiLagDescConn = S.conn
end

function disableAntiLag()
    antiLagVisualEnabled = false
    local S = _G.ExeZombieAntiLag
    S.active = false

    if S.conn then
        S.conn:Disconnect()
        S.conn = nil
    end
    antiLagDescConn = nil

    pcall(function()
        Lighting.GlobalShadows = true
        if S.defBrightness then Lighting.Brightness = S.defBrightness end
        if S.defFog then Lighting.FogEnd = S.defFog end
        if S.defDiffuse then Lighting.EnvironmentDiffuseScale = S.defDiffuse end
        if S.defSpecular then Lighting.EnvironmentSpecularScale = S.defSpecular end

        for _,e in pairs(Lighting:GetChildren()) do
            pcall(function()
                if e:IsA("BlurEffect")
                    or e:IsA("SunRaysEffect")
                    or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect")
                    or e:IsA("DepthOfFieldEffect") then
                    e.Enabled = true
                end
            end)
        end
    end)
end

function applyKTMOptimization()
    enableAntiLag()
end

function enableNukeOptimizer()
nukeOptimiserEnabled=true; _aceNukeOn=true; applyKTMOptimization(); applyCustomSky("Off")
for _,c in ipairs(_aceNukeConns) do pcall(function() c:Disconnect() end) end; _aceNukeConns={}
table.insert(_aceNukeConns, workspace.DescendantAdded:Connect(function(o) if nukeOptimiserEnabled then _applyAntiLagObj(o) end end))
task.spawn(function() while nukeOptimiserEnabled do pcall(function() setfpscap(240) end); task.wait(3) end end)
end
function disableNukeOptimizer() nukeOptimiserEnabled=false; _aceNukeOn=false; for _,c in ipairs(_aceNukeConns) do pcall(function() c:Disconnect() end) end; _aceNukeConns={} end
function enableNoCamCollision()
noCamCollisionEnabled=true; if noCamCollisionConn then noCamCollisionConn:Disconnect() end
noCamCollisionConn=RunService.RenderStepped:Connect(function()
if not noCamCollisionEnabled then return end
local cam=workspace.CurrentCamera; local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not cam or not hrp then return end
local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances=workspace.CurrentCamera and workspace.CurrentCamera:FindFirstChild("_ExeAvatarOverlay") and {char,workspace.CurrentCamera:FindFirstChild("_ExeAvatarOverlay")} or {char}; params.IgnoreWater=true
local res=workspace:Raycast(cam.CFrame.Position,(hrp.Position+Vector3.new(0,1.5,0))-cam.CFrame.Position,params)
local hit={}
if res and res.Instance and res.Instance:IsA("BasePart") then hit[res.Instance]=true; if noCamCollisionParts[res.Instance]==nil then noCamCollisionParts[res.Instance]=res.Instance.LocalTransparencyModifier end; res.Instance.LocalTransparencyModifier=1 end
for part,orig in pairs(noCamCollisionParts) do if not hit[part] then pcall(function() if part and part.Parent then part.LocalTransparencyModifier=orig end end); noCamCollisionParts[part]=nil end end
end)
end
function disableNoCamCollision() noCamCollisionEnabled=false; if noCamCollisionConn then noCamCollisionConn:Disconnect(); noCamCollisionConn=nil end; for p,orig in pairs(noCamCollisionParts) do pcall(function() if p and p.Parent then p.LocalTransparencyModifier=orig end end) end; noCamCollisionParts={} end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
end
V = V or {}
V.skyTheme = skyTheme or V.skyTheme or "Off"
V.nukeOptEnabled = nukeOptimiserEnabled == true
V.customFontEnabled = false
V.potatoGraphicsEnabled = V.potatoGraphicsEnabled or false
function enableNoCamCollision()
noCamCollisionEnabled = true
if noCamCollisionConn then noCamCollisionConn:Disconnect() end
noCamCollisionConn = RunService.RenderStepped:Connect(function()
if not noCamCollisionEnabled then
if noCamCollisionConn then noCamCollisionConn:Disconnect();noCamCollisionConn=nil end
return
end
local cam = workspace.CurrentCamera
local char = LP.Character
if not cam or not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local camPos = cam.CFrame.Position
local charPos = hrp.Position + Vector3.new(0,1.5,0)
local toChar = charPos - camPos
if toChar.Magnitude < 0.3 then return end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = workspace.CurrentCamera and workspace.CurrentCamera:FindFirstChild("_ExeAvatarOverlay") and {char, workspace.CurrentCamera:FindFirstChild("_ExeAvatarOverlay")} or {char}
params.IgnoreWater = true
local hit = {}
local origin = camPos
local remaining = toChar
for _ = 1,12 do
if remaining.Magnitude < 0.2 then break end
local res = workspace:Raycast(origin,remaining,params)
if not res then break end
local part = res.Instance
if part and part:IsA("BasePart") and not part:IsDescendantOf(char) then
hit[part] = true
if noCamCollisionParts[part] == nil then noCamCollisionParts[part] = part.LocalTransparencyModifier end
part.LocalTransparencyModifier = 1
end
origin = res.Position + remaining.Unit * 0.02
remaining = charPos - origin
end
for part,orig in pairs(noCamCollisionParts) do
if not hit[part] then
pcall(function() if part and part.Parent then part.LocalTransparencyModifier = orig end end)
noCamCollisionParts[part] = nil
end
end
end)
end
function disableNoCamCollision()
noCamCollisionEnabled = false
if noCamCollisionConn then noCamCollisionConn:Disconnect();noCamCollisionConn=nil end
for part,orig in pairs(noCamCollisionParts) do
pcall(function() if part and part.Parent then part.LocalTransparencyModifier = orig end end)
end
noCamCollisionParts = {}
end
SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Tech","Sakura","Pink Night",
"Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse",
"Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
SKY_PRESETS = {
["Off"] = {kind = "off"},
["Night"] = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
["Aurora"] = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
["Sunset"] = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
["Galaxy"] = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
["Tech"] = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
["Sakura"] = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
["Pink Night"] = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
["Blood Moon"] = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
["Emerald Dawn"] = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
["Volcanic"] = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
["Arctic"] = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
["Midnight Ocean"] = {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
["Vaporwave"] = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
["Toxic"] = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
["Hellscape"] = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
["Heaven"] = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
["Storm"] = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
["Sunrise"] = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
["Deep Space"] = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
["Lavender Dream"] = {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
["Inferno"] = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
["Mint Sky"] = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end
function _v4mpClearSky()
for _, v in ipairs(Lighting:GetChildren()) do
if v:GetAttribute("_ExeDuelsSky") then pcall(function() v:Destroy() end) end
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
for _, v in ipairs(terrain:GetChildren()) do
if v:GetAttribute("_ExeDuelsSky") then pcall(function() v:Destroy() end) end
end
end
end
function applyCustomSky(mode)
_v4mpClearSky()
local preset = SKY_PRESETS[mode]
if not preset or preset.kind == "off" then
Lighting.FogEnd = 100000; Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(192,192,192)
Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = true
V.skyTheme = "Off"
return
end
Lighting.FogEnd = 100000; Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(200,200,200)
Lighting.GlobalShadows = true
Lighting.ClockTime = preset.clock or 14
Lighting.Brightness = preset.brightness or 2
if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
if preset.sky then
local sky = Instance.new("Sky")
sky:SetAttribute("_ExeDuelsSky", true)
if preset.sky.stars then sky.StarCount = preset.sky.stars end
if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
sky.Parent = Lighting
end
if preset.atm then
local atm = Instance.new("Atmosphere")
atm:SetAttribute("_ExeDuelsSky", true)
atm.Density = preset.atm.dens or 0.3
atm.Color = _vC3(preset.atm.color)
atm.Decay = _vC3(preset.atm.decay)
atm.Glare = preset.atm.glare or 1
atm.Haze = preset.atm.haze or 1
atm.Parent = Lighting
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if preset.clouds and terrain then
local clouds = Instance.new("Clouds")
clouds:SetAttribute("_ExeDuelsSky", true)
clouds.Cover = preset.clouds.cover or 0.5
clouds.Density = preset.clouds.dens or 0.5
clouds.Color = _vC3(preset.clouds.color)
clouds.Parent = terrain
end
V.skyTheme = mode
end
function enableUltraMode()
V.ultraModeEnabled = true
applyKTMOptimization()
end
function disableUltraMode()
V.ultraModeEnabled = false
end
function enableRemoveAccessories()
V.removeAccessoriesEnabledSep = true
removeAccessoriesEnabled = true
removeAllAccessories()
if V.removeAccConn then V.removeAccConn:Disconnect() end
V.removeAccConn = Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function(char)
task.wait(0.5)
if V.removeAccessoriesEnabledSep or removeAccessoriesEnabled then
for _,obj in ipairs(char:GetDescendants()) do processAntiLagDescendant(obj) end
end
end)
end)
if antiLagDescConn then antiLagDescConn:Disconnect() end
antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
if antiLagEnabled or V.ultraModeEnabled or removeAccessoriesEnabled or V.removeAccessoriesEnabledSep then
processAntiLagDescendant(obj)
end
end)
end
function disableRemoveAccessories()
V.removeAccessoriesEnabledSep = false
removeAccessoriesEnabled = false
if V.removeAccConn then V.removeAccConn:Disconnect(); V.removeAccConn = nil end
if not antiLagEnabled and not V.ultraModeEnabled and antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
end
_nukeOptimizerOn = false
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
function enableNukeOptimizer()
if _nukeOptimizerOn then return end
_nukeOptimizerOn = true
nukeOptimiserEnabled = true
V.nukeOptEnabled = true
local MaterialService = game:GetService("MaterialService")
local XMin, XMax = -560, -240
local ClothingClasses = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory","FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory"}
local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}
function SafeDestroy(obj)
if obj and obj.Name == "Overhead" then return end
pcall(function() obj:Destroy() end)
end
function IsClothing(obj)
for _, className in ipairs(ClothingClasses) do
if obj:IsA(className) then return true end
end
return false
end
function IsCharacterPart(obj)
for _, plr in ipairs(Players:GetPlayers()) do
if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
end
return false
end
function IsOutOfRange(obj)
if obj:IsA("BasePart") then
local x = obj.Position.X
return x < XMin or x > XMax
end
return false
end
function IsBase(obj)
if not obj:IsA("BasePart") then return false end
local nl = obj.Name:lower()
for _, n in ipairs(BASE_NAMES) do
if nl:find(n, 1, true) then return true end
end
return false
end
function IsInBase(obj)
local p = obj.Parent
while p and p ~= workspace do
if IsBase(p) then return true end
p = p.Parent
end
return false
end
function MakeTransparent(obj)
pcall(function()
if IsBase(obj) and not IsCharacterPart(obj) then
obj.Transparency = 1
obj.CastShadow = false
end
end)
end
function StripObject(obj)
pcall(function()
if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
SafeDestroy(obj)
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
pcall(function() obj.Enabled = false end)
SafeDestroy(obj)
elseif obj:IsA("SurfaceAppearance") then
SafeDestroy(obj)
elseif obj:IsA("BasePart") then
obj.CastShadow = false
obj.Material = Enum.Material.Plastic
obj.MaterialVariant = ""
obj.Reflectance = 0
end
end)
end
function CleanObject(obj)
pcall(function()
if obj:IsA("SurfaceAppearance") then
SafeDestroy(obj)
elseif obj:IsA("Decal") or obj:IsA("Texture") then
if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then SafeDestroy(obj) end
elseif obj:IsA("SpecialMesh") then
obj.TextureId = ""
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
SafeDestroy(obj)
elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
SafeDestroy(obj)
elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
SafeDestroy(obj)
elseif obj:IsA("Animation") or obj:IsA("AnimationController") then
SafeDestroy(obj)
elseif obj:IsA("BasePart") then
obj.CastShadow = false
obj.Material = Enum.Material.Plastic
obj.MaterialVariant = ""
obj.Reflectance = 0
end
end)
end
function ApplyGreySky()
pcall(function()
for _, obj in ipairs(Lighting:GetChildren()) do
if obj:IsA("Sky") then obj:Destroy() end
end
local sky = Instance.new("Sky")
sky.SkyboxBk = ""; sky.SkyboxDn = ""; sky.SkyboxFt = ""
sky.SkyboxLf = ""; sky.SkyboxRt = ""; sky.SkyboxUp = ""
sky.CelestialBodiesShown = false
sky.Name = "_ExeDuelsNukeSky"
sky.Parent = Lighting
end)
end
function OptimizeLighting()
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.Brightness = 1.5
Lighting.Ambient = Color3.fromRGB(60,60,60)
for _, v in ipairs(Lighting:GetChildren()) do
if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") or v:IsA("Clouds") then
v:Destroy()
end
end
ApplyGreySky()
end)
end
function ApplyTerrain()
pcall(function()
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
terrain.Decoration = false
terrain.WaterWaveSize = 0
terrain.WaterWaveSpeed = 0
terrain.WaterReflectance = 0
terrain.WaterTransparency = 1
end
end)
end
function OptimizeCharacter(char)
if not char then return end
task.spawn(function()
task.wait(0.3)
if not _nukeOptimizerOn then return end
for _, obj in ipairs(char:GetDescendants()) do
if IsClothing(obj) then SafeDestroy(obj) else CleanObject(obj) end
end
end)
end
pcall(function()
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)
pcall(function() if setfpscap then setfpscap(999) end end)
table.insert(_nukeOptimizerThreads, task.spawn(function()
if not game:IsLoaded() then game.Loaded:Wait() end
OptimizeLighting()
ApplyTerrain()
for _, obj in ipairs(workspace:GetDescendants()) do
if not _nukeOptimizerOn then return end
if IsBase(obj) then
MakeTransparent(obj)
elseif IsClothing(obj) then
SafeDestroy(obj)
elseif IsInBase(obj) then
elseif IsCharacterPart(obj) then
elseif IsOutOfRange(obj) then
SafeDestroy(obj)
else
CleanObject(obj)
StripObject(obj)
end
end
for _, obj in ipairs(workspace:GetDescendants()) do MakeTransparent(obj) end
end))
table.insert(_nukeOptimizerConns, workspace.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
task.defer(function()
if not _nukeOptimizerOn then return end
if IsBase(obj) then MakeTransparent(obj); return end
if IsClothing(obj) then
SafeDestroy(obj)
elseif IsInBase(obj) then
elseif IsCharacterPart(obj) then
elseif IsOutOfRange(obj) then
SafeDestroy(obj)
else
CleanObject(obj)
StripObject(obj)
end
end)
end))
table.insert(_nukeOptimizerConns, Lighting.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then SafeDestroy(obj) end
end))
table.insert(_nukeOptimizerConns, MaterialService.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
SafeDestroy(obj)
end))
for _, plr in ipairs(Players:GetPlayers()) do
OptimizeCharacter(plr.Character)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end
table.insert(_nukeOptimizerConns, Players.PlayerAdded:Connect(function(plr)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end))
table.insert(_nukeOptimizerThreads, task.spawn(function()
while _nukeOptimizerOn do
task.wait(15)
pcall(function() collectgarbage("collect") end)
end
end))
end
function disableNukeOptimizer()
_nukeOptimizerOn = false
nukeOptimiserEnabled = false
V.nukeOptEnabled = false
for _, c in ipairs(_nukeOptimizerConns) do pcall(function() c:Disconnect() end) end
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
__ace_src_enableNoCamCollision = enableNoCamCollision
function enableNoCamCollision()
__ace_src_enableNoCamCollision()
noCamCollisionEnabled = true
end
__ace_src_disableNoCamCollision = disableNoCamCollision
function disableNoCamCollision()
__ace_src_disableNoCamCollision()
noCamCollisionEnabled = false
end

_G.ExeInstallAvatarChanger = function()
    local XAC = {
        model = nil,
        renderConn = nil,
        fpConn = nil,
        hideConn = nil,
        hideEnforceConn = nil,
        motorPairs = {},
        fpHidden = {},
        hiddenParts = {},
        paused = false,
        lastUserId = nil,
        lastUsername = nil,
    }
    _G.ExeAvatarChangerState = XAC

    local function getFolder()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local folder = cam:FindFirstChild("_ExeAvatarOverlay")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "_ExeAvatarOverlay"
            folder.Parent = cam
        end
        return folder
    end

    local function stopConn(name)
        local c = XAC[name]
        if c then pcall(function() c:Disconnect() end) end
        XAC[name] = nil
    end

    local function restoreReal()
        for inst, old in pairs(XAC.hiddenParts) do
            if inst and inst.Parent then
                pcall(function()
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = old
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = old
                    end
                end)
            end
        end
        table.clear(XAC.hiddenParts)
    end

    local function setRealHidden(on)
        stopConn("hideConn")
        stopConn("hideEnforceConn")
        restoreReal()
        if not on then return end

        local function hideOne(inst)
            if inst:IsA("BasePart") then
                if XAC.hiddenParts[inst] == nil then
                    XAC.hiddenParts[inst] = inst.LocalTransparencyModifier
                end
                inst.LocalTransparencyModifier = 1
            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if XAC.hiddenParts[inst] == nil then
                    XAC.hiddenParts[inst] = inst.Transparency
                end
                inst.Transparency = 1
            end
        end

        local char = LP.Character
        if not char then return end
        for _, inst in ipairs(char:GetDescendants()) do pcall(hideOne, inst) end

        XAC.hideConn = char.DescendantAdded:Connect(function(inst)
            task.defer(function()
                if inst and inst.Parent then pcall(hideOne, inst) end
            end)
        end)

        XAC.hideEnforceConn = RunService.RenderStepped:Connect(function()
            local c = LP.Character
            if not c or not XAC.model then return end
            for _, inst in ipairs(c:GetDescendants()) do pcall(hideOne, inst) end
        end)
    end

    local function restoreOverlay()
        for inst, old in pairs(XAC.fpHidden) do
            if inst and inst.Parent then
                pcall(function()
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = old
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = old
                    end
                end)
            end
        end
        table.clear(XAC.fpHidden)
    end

    local function hideOverlay()
        if not XAC.model then return end
        for _, inst in ipairs(XAC.model:GetDescendants()) do
            if inst:IsA("BasePart") then
                if XAC.fpHidden[inst] == nil then
                    XAC.fpHidden[inst] = inst.LocalTransparencyModifier
                end
                inst.LocalTransparencyModifier = 1
            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if XAC.fpHidden[inst] == nil then
                    XAC.fpHidden[inst] = inst.Transparency
                end
                inst.Transparency = 1
            end
        end
    end

    local function startFirstPerson()
        stopConn("fpConn")
        local hidden = false
        XAC.fpConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local char = LP.Character
            local head = char and char:FindFirstChild("Head")
            if not XAC.model or not cam or not head then return end

            local d = (cam.CFrame.Position - head.Position).Magnitude
            local lockFP = LP.CameraMode == Enum.CameraMode.LockFirstPerson

            if hidden then
                if not lockFP and d > 1.15 then hidden = false end
            else
                if lockFP or d <= 0.95 then hidden = true end
            end

            if hidden then

                hideOverlay()
                for _, inst in ipairs(XAC.model:GetDescendants()) do
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = 1
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = 1
                    end
                end
            elseif next(XAC.fpHidden) ~= nil then
                restoreOverlay()
            end
        end)
    end

    local function destroyOverlay()
        stopConn("renderConn")
        stopConn("fpConn")
        restoreOverlay()
        if XAC.model then pcall(function() XAC.model:Destroy() end) end
        XAC.model = nil
        XAC.paused = false
    end

    local function prepare(model)
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") then
                d.Disabled = true
            elseif d:IsA("BasePart") then
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
                d.Massless = true
            end
        end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = true
            hum.AutoRotate = false
            hum.Sit = true
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.NameDisplayDistance = 0
            hum.HealthDisplayDistance = 0
        end
        return model
    end

    local function motorKey(m)
        return m.Name .. "|" ..
            ((m.Part0 and m.Part0.Name) or "nil") .. ">" ..
            ((m.Part1 and m.Part1.Name) or "nil")
    end

    local function buildPairs(srcChar, target)
        table.clear(XAC.motorPairs)
        local a, b = {}, {}
        for _, d in ipairs(srcChar:GetDescendants()) do
            if d:IsA("Motor6D") then a[motorKey(d)] = d end
        end
        for _, d in ipairs(target:GetDescendants()) do
            if d:IsA("Motor6D") then b[motorKey(d)] = d end
        end
        for k, src in pairs(a) do
            if b[k] then table.insert(XAC.motorPairs, {src = src, tgt = b[k]}) end
        end
    end

    local function startMirror()
        stopConn("renderConn")
        XAC.renderConn = RunService.RenderStepped:Connect(function()
            if XAC.paused or not XAC.model then return end
            for _, pair in ipairs(XAC.motorPairs) do
                if pair.src and pair.tgt and pair.src.Parent and pair.tgt.Parent then
                    pair.tgt.Transform = pair.src.Transform
                end
            end
        end)
    end

    local function resolve(value)
        value = tostring(value or ""):gsub("^%s+",""):gsub("%s+$","")
        if value == "" then return false, "ENTER USERNAME / USER ID" end
        local n = tonumber(value)
        if n then
            local uid = math.floor(n)
            local ok, name = pcall(function() return Players:GetNameFromUserIdAsync(uid) end)
            if not ok or not name then return false, "USER NOT FOUND" end
            return true, uid, name
        end
        local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(value) end)
        if not ok or not uid then return false, "USER NOT FOUND" end
        return true, uid, value
    end

    local function spawnAvatar(uid, username, status)
        status = status or function() end
        status("SPAWNING...")
        destroyOverlay()

        local ok, model = pcall(function()
            return Players:CreateHumanoidModelFromUserIdAsync(uid)
        end)
        if not ok or typeof(model) ~= "Instance" then
            status("FAILED")
            return
        end

        model = prepare(model)
        model.Name = "ExeAvatarOverlay_" .. tostring(uid)

        local folder = getFolder()
        local char = LP.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        local oHRP = model:FindFirstChild("HumanoidRootPart")
        if not folder or not myHRP or not oHRP then
            model:Destroy()
            status("HRP NOT READY")
            return
        end

        model.Parent = folder
        model:PivotTo(myHRP.CFrame)

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = oHRP
        weld.Part1 = myHRP
        weld.Parent = oHRP

        XAC.model = model
        XAC.lastUserId = uid
        XAC.lastUsername = username
        _G.ExeAvatarChangerCleared = false
        XAC.paused = false

        pcall(function()
            if _G.ExeApplyHeadless then
                _G.ExeApplyHeadless(model, _G.ExeHeadlessEnabled == true)
            end
            if _G.ExeApplyKorblox then
                _G.ExeApplyKorblox(model, _G.ExeKorbloxEnabled == true)
            end
        end)

        setRealHidden(true)
        buildPairs(char, model)
        startMirror()
        startFirstPerson()
        status("ACTIVE - " .. tostring(username))
    end

    _G.ExeAvatarChangerSpawn = spawnAvatar
    _G.ExeAvatarChangerRemove = function()
        destroyOverlay()
        setRealHidden(false)
        XAC.lastUserId = nil
        XAC.lastUsername = nil
        _G.ExeAvatarChangerCleared = true
    end
    _G.ExeAvatarChangerResolve = resolve

    _G.ExeOpenAvatarChanger = function()
        local old = PlayerGui:FindFirstChild("ExeAvatarChangerGallery")
        if old then old:Destroy() end

        local sg = Instance.new("ScreenGui")
        sg.Name = "ExeAvatarChangerGallery"
        sg.IgnoreGuiInset = true
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 99999
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        safeParentGui(sg)

        local shade = Instance.new("TextButton")
        shade.Text = ""
        shade.AutoButtonColor = false
        shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
        shade.BackgroundTransparency = 0.25
        shade.Size = UDim2.fromScale(1,1)
        shade.ZIndex = 1
        shade.Parent = sg

        local panel = Instance.new("Frame")
        panel.AnchorPoint = Vector2.new(0.5,0.5)
        panel.Position = UDim2.fromScale(0.5,0.5)
        panel.Size = UDim2.new(0, 620, 0, 500)
        panel.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
        panel.BackgroundTransparency = 0.04
        panel.BorderSizePixel = 0
        panel.ZIndex = 2
        panel.Parent = sg
        corner(panel,16)
        stroke(panel,COLORS.strokeSoft,1.2,0.15)

        pcall(function()
            local bg = Main and Main:FindFirstChild("CustomBackground")
            if bg and bg:IsA("ImageLabel") and bg.Visible and bg.Image ~= "" then
                local pbg = bg:Clone()
                pbg.Name = "PanelBackground"
                pbg.Size = UDim2.fromScale(1,1)
                pbg.Position = UDim2.fromScale(0,0)
                pbg.ZIndex = 2
                pbg.ImageTransparency = math.max(bg.ImageTransparency,0.18)
                pbg.Parent = panel
                corner(pbg,16)
            end
        end)

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Text = "ADAPT AVATAR CHANGER (NOT WORKING)"
        title.TextColor3 = COLORS.white
        title.Font = Enum.Font.GothamMedium
        title.TextSize = 19
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Position = UDim2.new(0,18,0,10)
        title.Size = UDim2.new(1,-70,0,38)
        title.ZIndex = 4
        title.Parent = panel

        local close = Instance.new("TextButton")
        close.Text = "X"
        close.Font = Enum.Font.GothamMedium
        close.TextSize = 11
        close.TextColor3 = COLORS.white
        close.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        close.Size = UDim2.fromOffset(34,30)
        close.Position = UDim2.new(1,-46,0,14)
        close.ZIndex = 5
        close.Parent = panel
        corner(close,9)
        stroke(close,COLORS.strokeSoft,1,0.45)

        local input = Instance.new("TextBox")
        input.PlaceholderText = "SEARCH ANY ROBLOX USER..."
        input.ClearTextOnFocus = false
        input.Text = ""
        input.Font = Enum.Font.GothamMedium
        input.TextSize = 11
        input.TextColor3 = COLORS.white
        input.PlaceholderColor3 = Color3.fromRGB(141, 141, 141)
        input.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        input.BackgroundTransparency = 0.06
        input.Position = UDim2.new(0,18,0,58)
        input.Size = UDim2.new(1,-36,0,36)
        input.ZIndex = 4
        input.Parent = panel
        corner(input,9)
        stroke(input,COLORS.strokeSoft,1,0.5)

        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = "FEATURED"
        sectionLabel.TextColor3 = COLORS.white
        sectionLabel.Font = Enum.Font.GothamMedium
        sectionLabel.TextSize = 10
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Position = UDim2.new(0,18,0,98)
        sectionLabel.Size = UDim2.new(1,-36,0,20)
        sectionLabel.ZIndex = 4
        sectionLabel.Parent = panel

        local status = Instance.new("TextLabel")
        status.BackgroundTransparency = 1
        status.Text = "LOADING FEATURED..."
        status.TextColor3 = Color3.fromRGB(181, 181, 181)
        status.Font = Enum.Font.GothamMedium
        status.TextSize = 9
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Position = UDim2.new(0,18,1,-28)
        status.Size = UDim2.new(1,-36,0,20)
        status.ZIndex = 4
        status.Parent = panel
        status.Size = UDim2.new(1,-190,0,20)

        local removeAvatarBtn = Instance.new("TextButton")
        removeAvatarBtn.Name = "RemoveAvatarButton"
        removeAvatarBtn.Text = "REMOVE AVATAR"
        removeAvatarBtn.Font = Enum.Font.GothamMedium
        removeAvatarBtn.TextSize = 9
        removeAvatarBtn.TextColor3 = Color3.fromRGB(255,255,255)
        removeAvatarBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        removeAvatarBtn.BackgroundTransparency = 0
        removeAvatarBtn.BorderSizePixel = 0
        removeAvatarBtn.Position = UDim2.new(1,-168,1,-34)
        removeAvatarBtn.Size = UDim2.new(0,150,0,26)
        removeAvatarBtn.ZIndex = 6
        removeAvatarBtn.Parent = panel
        corner(removeAvatarBtn,8)
        stroke(removeAvatarBtn,Color3.fromRGB(123, 123, 123),1,0.15)

        removeAvatarBtn.MouseButton1Click:Connect(function()
            if _G.ExeAvatarChangerRemove then
                pcall(_G.ExeAvatarChangerRemove)
                status.Text = "AVATAR REMOVED"
            else
                status.Text = "REMOVE FAILED"
            end
        end)

        local scroll = Instance.new("ScrollingFrame")
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.Position = UDim2.new(0,12,0,122)
        scroll.Size = UDim2.new(1,-24,1,-160)
        scroll.ScrollBarThickness = 4
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.ZIndex = 4
        scroll.Parent = panel

        local grid = Instance.new("UIGridLayout")
        grid.CellSize = UDim2.fromOffset(132,160)
        grid.CellPadding = UDim2.fromOffset(10,10)
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        grid.Parent = scroll

        local famousSeeds = {
            "Roblox","Builderman","KreekCraft","Flamingo","ItsFunneh",
            "DenisDaily","RussoTalks","MeganPlays","LeahAshe","Thinknoodles",
            "SharkBlox","InquisitorMaster","GamingWithKev","Sketch","Bandites",
            "TanqR","DVPlays","NightFoxx","iamSanna","Temprist",
            "MiniToon","asimo3089","badcc","NewFissy","Coeptus",
            "Wolfpaq","BelowNatural","callmehbob"
        }

        local featuredUsers = {}
        local searchResults = {}
        local searchToken = 0

        local function clearCards()
            for _, child in ipairs(scroll:GetChildren()) do
                if child:IsA("GuiButton") then child:Destroy() end
            end
        end

        local function addCard(userData, order)
            local card = Instance.new("TextButton")
            card.Text = ""
            card.AutoButtonColor = false
            card.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
            card.BackgroundTransparency = 0.07
            card.BorderSizePixel = 0
            card.LayoutOrder = order
            card.ZIndex = 5
            card.Parent = scroll
            corner(card,11)
            stroke(card,COLORS.strokeSoft,1,0.55)

            local thumb = Instance.new("ImageLabel")
            thumb.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            thumb.BackgroundTransparency = 0.08
            thumb.BorderSizePixel = 0
            thumb.Position = UDim2.new(0,8,0,8)
            thumb.Size = UDim2.new(1,-16,0,108)
            thumb.ScaleType = Enum.ScaleType.Crop
            thumb.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userData.id) .. "&w=150&h=150"
            thumb.ZIndex = 6
            thumb.Parent = card
            corner(thumb,9)

            if userData.hasVerifiedBadge == true then
                local verified = Instance.new("TextLabel")
                verified.BackgroundColor3 = Color3.fromRGB(255,255,255)
                verified.BackgroundTransparency = 0.08
                verified.Text = "✓"
                verified.TextColor3 = Color3.fromRGB(11, 11, 11)
                verified.Font = Enum.Font.GothamMedium
                verified.TextSize = 12
                verified.Size = UDim2.fromOffset(20,20)
                verified.Position = UDim2.new(1,-26,0,14)
                verified.ZIndex = 8
                verified.Parent = card
                corner(verified,999)
            end

            local display = Instance.new("TextLabel")
            display.BackgroundTransparency = 1
            display.Text = tostring(userData.displayName or userData.name)
            display.TextColor3 = COLORS.white
            display.Font = Enum.Font.GothamMedium
            display.TextSize = 9
            display.TextWrapped = true
            display.TextXAlignment = Enum.TextXAlignment.Center
            display.Position = UDim2.new(0,5,0,119)
            display.Size = UDim2.new(1,-10,0,17)
            display.ZIndex = 6
            display.Parent = card

            local username = Instance.new("TextLabel")
            username.BackgroundTransparency = 1
            username.Text = "@" .. tostring(userData.name)
            username.TextColor3 = Color3.fromRGB(162, 162, 162)
            username.Font = Enum.Font.GothamMedium
            username.TextSize = 9
            username.TextXAlignment = Enum.TextXAlignment.Center
            username.Position = UDim2.new(0,5,0,137)
            username.Size = UDim2.new(1,-10,0,15)
            username.ZIndex = 6
            username.Parent = card

            card.MouseButton1Click:Connect(function()
                spawnAvatar(userData.id, userData.name, function(v)
                    status.Text = tostring(v)
                end)
                task.defer(function()
                    if sg and sg.Parent then
                        sg:Destroy()
                    end
                end)
            end)
        end

        local function renderFeatured()
            clearCards()
            sectionLabel.Text = "FEATURED"
            local count = 0
            for _, u in ipairs(featuredUsers) do
                count += 1
                addCard(u, count)
            end
            status.Text = tostring(count) .. " FEATURED AVATARS"
        end

        local function renderSearch()
            clearCards()
            sectionLabel.Text = "SEARCH RESULTS"
            local count = 0
            for _, u in ipairs(searchResults) do
                count += 1
                addCard(u, count)
            end
            status.Text = tostring(count) .. " RESULTS"
        end

        local function searchAnyUser(query)
            query = tostring(query or ""):gsub("^%s+",""):gsub("%s+$","")
            searchToken += 1
            local myToken = searchToken

            if query == "" then
                searchResults = {}
                renderFeatured()
                return
            end

            status.Text = "SEARCHING..."
            sectionLabel.Text = "SEARCH RESULTS"

            task.spawn(function()
                local results = {}

                local okId, uid = pcall(function()
                    return Players:GetUserIdFromNameAsync(query)
                end)

                if myToken ~= searchToken then return end

                if okId and uid and uid > 0 then
                    local okInfo, body = pcall(function()
                        return game:HttpGet("https://users.roblox.com/v1/users/" .. tostring(uid))
                    end)
                    if okInfo and body and body ~= "" then
                        local okJson, data = pcall(function()
                            return HttpService:JSONDecode(body)
                        end)
                        if okJson and type(data) == "table" then
                            table.insert(results, {
                                id = tonumber(data.id) or uid,
                                name = tostring(data.name or query),
                                displayName = tostring(data.displayName or data.name or query),
                                hasVerifiedBadge = data.hasVerifiedBadge == true
                            })
                        end
                    end
                end

                local encoded = HttpService:UrlEncode(query)
                local okSearch, body = pcall(function()
                    return game:HttpGet(
                        "https://users.roblox.com/v1/users/search?keyword=" ..
                        encoded .. "&limit=20"
                    )
                end)

                if myToken ~= searchToken then return end

                if okSearch and body and body ~= "" then
                    local okJson, data = pcall(function()
                        return HttpService:JSONDecode(body)
                    end)
                    if okJson and type(data) == "table" and type(data.data) == "table" then
                        local seen = {}
                        for _, r in ipairs(results) do seen[r.id] = true end

                        for _, item in ipairs(data.data) do
                            local id = tonumber(item.id)
                            if id and not seen[id] then
                                seen[id] = true
                                table.insert(results, {
                                    id = id,
                                    name = tostring(item.name or id),
                                    displayName = tostring(item.displayName or item.name or id),
                                    hasVerifiedBadge = item.hasVerifiedBadge == true
                                })
                            end
                        end
                    end
                end

                if myToken ~= searchToken then return end
                searchResults = results
                renderSearch()
            end)
        end

        input:GetPropertyChangedSignal("Text"):Connect(function()
            local current = input.Text
            task.delay(0.18, function()
                if input.Text == current then
                    searchAnyUser(current)
                end
            end)
        end)

        close.MouseButton1Click:Connect(function()
            sg:Destroy()
        end)

        task.spawn(function()
            local pending = #famousSeeds
            local seen = {}

            if pending == 0 then
                status.Text = "NO FEATURED USERS"
                return
            end

            for _, seedName in ipairs(famousSeeds) do
                task.spawn(function()
                    local okId, uid = pcall(function()
                        return Players:GetUserIdFromNameAsync(seedName)
                    end)

                    if okId and uid and uid > 0 and not seen[uid] then
                        seen[uid] = true

                        local okInfo, body = pcall(function()
                            return game:HttpGet("https://users.roblox.com/v1/users/" .. tostring(uid))
                        end)

                        if okInfo and body and body ~= "" then
                            local okJson, data = pcall(function()
                                return HttpService:JSONDecode(body)
                            end)

                            if okJson and type(data) == "table" then

                                table.insert(featuredUsers, {
                                    id = tonumber(data.id) or uid,
                                    name = tostring(data.name or seedName),
                                    displayName = tostring(data.displayName or data.name or seedName),
                                    hasVerifiedBadge = data.hasVerifiedBadge == true
                                })

                                table.sort(featuredUsers, function(a,b)
                                    return string.lower(a.displayName or a.name)
                                        < string.lower(b.displayName or b.name)
                                end)

                                if input.Text == "" and sg.Parent then
                                    renderFeatured()
                                end
                            end
                        end
                    end

                    pending -= 1
                    if pending <= 0 and input.Text == "" and sg.Parent then
                        renderFeatured()
                    end
                end)
            end
        end)
    end

    LP.CharacterAdded:Connect(function()
        task.wait(0.35)
        if XAC.lastUserId then
            local uid, name = XAC.lastUserId, XAC.lastUsername
            task.defer(function()
                spawnAvatar(uid,name or tostring(uid),function() end)
            end)
        end
    end)

    task.defer(function()
        task.wait(0.5)
        if XAC.lastUserId and LP.Character then
            spawnAvatar(XAC.lastUserId, XAC.lastUsername or tostring(XAC.lastUserId), function() end)
        end
    end)
end

_G.ExeInstallAvatarChanger()
_G.ExeInstallAvatarChanger = nil

if _G.ExeAvatarChangerState then
    _G.ExeAvatarChangerState.lastUserId = _G.ExeSavedAvatarChangerUserId
    _G.ExeAvatarChangerState.lastUsername = (_G.ExeSavedAvatarChangerUsername ~= "" and _G.ExeSavedAvatarChangerUsername) or nil
end

do
    local originalApplyHeadless = _G.ExeApplyHeadless
    local originalApplyKorblox = _G.ExeApplyKorblox
    local originalApplyCharacterVisuals = _G.ExeApplyCharacterVisuals

    if originalApplyHeadless then
        _G.ExeApplyHeadless = function(char, enabled)
            originalApplyHeadless(char, enabled)

            local state = _G.ExeAvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    originalApplyHeadless(overlay, enabled)
                end)
            end
        end
    end

    if originalApplyKorblox then
        _G.ExeApplyKorblox = function(char, enabled)
            originalApplyKorblox(char, enabled)

            local state = _G.ExeAvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    originalApplyKorblox(overlay, enabled)
                end)
            end
        end
    end

    if originalApplyCharacterVisuals then
        _G.ExeApplyCharacterVisuals = function(char)
            originalApplyCharacterVisuals(char)

            local state = _G.ExeAvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    if originalApplyHeadless then
                        originalApplyHeadless(overlay, _G.ExeHeadlessEnabled == true)
                    end
                    if originalApplyKorblox then
                        originalApplyKorblox(overlay, _G.ExeKorbloxEnabled == true)
                    end
                end)
            end
        end
    end
end

-- Custom font changer and picker removed by request.
-- Music player subsystem removed by request.

function __ExeDuelsSetupVisualsUI()
local Utility = pages.VISUALS
local skyThemes = SKY_PRESETS_LIST or {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Tech", "Sakura"}
local skyIndex = 1
for i, name in ipairs(skyThemes) do if name == skyTheme then skyIndex = i break end end
function skyThemeSelectorRow(parent, order)
local row = Instance.new("Frame")
row.Name = "Sky Theme"
row.ZIndex = 4
row.Size = UDim2.new(1,-4,0,52)
row.BackgroundTransparency = 1
row.BorderSizePixel = 0
row.LayoutOrder = order
row.Parent = parent

local label = Instance.new("TextLabel")
label.Name = "Label"
label.ZIndex = 5
label.Position = UDim2.new(0,2,0,0)
label.Size = UDim2.new(1,0,0,16)
label.BackgroundTransparency = 1
label.Text = "Sky Theme"
label.TextColor3 = Color3.fromRGB(255,255,255)
label.TextSize = 12
label.Font = Enum.Font.GothamBlack
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = row

local left = Instance.new("TextButton")
left.Name = "SkyLeft"
left.ZIndex = 6
left.Position = UDim2.new(0,0,0,22)
left.Size = UDim2.new(0,44,0,25)
left.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
left.BackgroundTransparency = 0.18
left.BorderSizePixel = 0
left.Text = "<"
left.TextColor3 = Color3.fromRGB(255,255,255)
left.TextSize = 12
left.Font = Enum.Font.GothamMedium
left.AutoButtonColor = false
left.Parent = row
corner(left,7)
stroke(left,COLORS.strokeSoft,1,0.45)

local value = Instance.new("TextButton")
value.Name = "SkyValue"
value.ZIndex = 6
value.Position = UDim2.new(0,48,0,22)
value.Size = UDim2.new(1,-96,0,28)
value.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
value.BackgroundTransparency = 0.18
value.BorderSizePixel = 0
value.Text = skyThemes[skyIndex]
value.TextColor3 = Color3.fromRGB(255,255,255)
value.TextSize = 12
value.Font = Enum.Font.GothamMedium
value.AutoButtonColor = false
value.Parent = row
corner(value,7)
stroke(value,COLORS.strokeSoft,1,0.45)
skyValueLabel = value

local right = Instance.new("TextButton")
right.Name = "SkyRight"
right.ZIndex = 6
right.Position = UDim2.new(1,-44,0,22)
right.Size = UDim2.new(0,44,0,25)
right.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
right.BackgroundTransparency = 0.18
right.BorderSizePixel = 0
right.Text = ">"
right.TextColor3 = Color3.fromRGB(255,255,255)
right.TextSize = 12
right.Font = Enum.Font.GothamMedium
right.AutoButtonColor = false
right.Parent = row
corner(right,7)
stroke(right,COLORS.strokeSoft,1,0.45)

local function setSkyIndex(nextIndex)
if nextIndex < 1 then nextIndex = #skyThemes end
if nextIndex > #skyThemes then nextIndex = 1 end
skyIndex = nextIndex
skyTheme = skyThemes[skyIndex]
if applyCustomSky then applyCustomSky(skyTheme) end
if skyValueLabel then skyValueLabel.Text = skyTheme end
end

left.Activated:Connect(function() setSkyIndex(skyIndex - 1) end)
right.Activated:Connect(function() setSkyIndex(skyIndex + 1) end)
return row
end


-- Static Hub visual preview panel removed by request.



section(Utility, "CHARACTER VISUALS", -3)

_, _G.ExeHeadlessVisual = toggleRow(Utility, "Headless", _G.ExeHeadlessEnabled, -2)
_G.ExeHeadlessRow = Utility:FindFirstChild("Headless")
_G.ExeHeadlessButton = _G.ExeHeadlessRow and _G.ExeHeadlessRow:FindFirstChild("ToggleButton")
if _G.ExeHeadlessButton then
_G.ExeHeadlessButton.Activated:Connect(function()
_G.ExeHeadlessEnabled = not _G.ExeHeadlessEnabled
_G.ExeApplyHeadless(LP.Character, _G.ExeHeadlessEnabled)
if _G.ExeHeadlessVisual then _G.ExeHeadlessVisual(_G.ExeHeadlessEnabled) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end

_, _G.ExeKorbloxVisual = toggleRow(Utility, "Korblox", _G.ExeKorbloxEnabled, -1)
_G.ExeKorbloxRow = Utility:FindFirstChild("Korblox")
_G.ExeKorbloxButton = _G.ExeKorbloxRow and _G.ExeKorbloxRow:FindFirstChild("ToggleButton")
if _G.ExeKorbloxButton then
_G.ExeKorbloxButton.Activated:Connect(function()
_G.ExeKorbloxEnabled = not _G.ExeKorbloxEnabled
_G.ExeApplyKorblox(LP.Character, _G.ExeKorbloxEnabled)
if _G.ExeKorbloxVisual then _G.ExeKorbloxVisual(_G.ExeKorbloxEnabled) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end

-- ===== OUTFITS PACK (from S2 HUB) =====
do
local OUTFIT_TAG = "LocalOutfit_"
local function loadObjs(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end
local function clearTagged(char)
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #OUTFIT_TAG) == OUTFIT_TAG then pcall(function() d:Destroy() end) end
    end
end
local function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1; head.CanCollide = false; head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face"); if face then face.Transparency = 1 end
    end
    pcall(function() local neck = char:FindFirstChild("Neck"); if neck then neck.Enabled = false end end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then v.Parent = nil end
            end
        end
    end
    local targetPart = char:FindFirstChild("RightUpperLeg")
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
        end
        local ok, objects = pcall(function() return game:GetObjects("rbxassetid://139607718") end)
        if ok and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end
local function applyKorbloxOnly(char)
    local targetPart = char and char:FindFirstChild("RightUpperLeg")
    if not targetPart then return end
    local oldAsset = char:FindFirstChild("Korblox_RightLeg")
    if oldAsset then oldAsset:Destroy() end
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName)
        if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
    end
    local objs = loadObjs(139607718)
    if objs and objs[1] then
        local assetModel = objs[1]
        assetModel.Name = "Korblox_RightLeg"
        local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
        if mainMesh then
            mainMesh.CanCollide = false; mainMesh.Massless = true
            mainMesh.CFrame = targetPart.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh
            assetModel.Parent = char
        end
    end
end
local function applyHomero(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10); char:WaitForChild("Head", 10)
    task.wait(0.4)
    clearTagged(char)
    local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
    local skin = Color3.fromRGB(234, 184, 146)
    bc.HeadColor3 = Color3.fromRGB(0, 0, 0); bc.TorsoColor3 = skin
    bc.LeftArmColor3 = skin; bc.RightArmColor3 = skin; bc.LeftLegColor3 = skin; bc.RightLegColor3 = skin
    bc.Parent = char
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then local h = a:FindFirstChild("Handle"); if h then h.Transparency = 1 end end
    end
    local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
    p.Name = "Pants"; p.PantsTemplate = "rbxassetid://78591690208112"; p.Parent = char
    local function weldClone(orig, srcPart)
        local c = srcPart:Clone(); c.Name = OUTFIT_TAG .. "body_" .. srcPart.Name
        c.CanCollide = false; c.Anchored = false; c.Massless = true
        c.Size = orig.Size; c.CFrame = orig.CFrame; c.Parent = char
        local w = Instance.new("WeldConstraint"); w.Part0 = orig; w.Part1 = c; w.Parent = c
        orig.Transparency = 1
    end
    for _, id in ipairs({103227869700418, 84952305140948, 122465238537030}) do
        local objs = loadObjs(id)
        if objs then
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then
                    local orig = char:FindFirstChild(o.Name)
                    if orig and orig:IsA("BasePart") then weldClone(orig, o) end
                end
                for _, d in ipairs(o:GetDescendants()) do
                    if d:IsA("BasePart") then
                        local orig = char:FindFirstChild(d.Name)
                        if orig and orig:IsA("BasePart") then weldClone(orig, d) end
                    end
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
end
local function applyNo(char)
    if not char then char = LP.Character end
    if not char then return end
    clearTagged(char)
    local oldAcc = char:FindFirstChild("AuFfitAccessory"); if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldK = char:FindFirstChild("Korblox_RightLeg"); if oldK then pcall(function() oldK:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then pcall(function() d:Destroy() end) end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0; head.CanCollide = true; head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face"); if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh"); if sm then pcall(function() sm:Destroy() end) end
    end
    pcall(function() local neck = char:FindFirstChild("Neck"); if neck then neck.Enabled = true end end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName); if limb then limb.Transparency = 0 end
    end
    local shirt = char:FindFirstChildWhichIsA("Shirt"); if shirt then pcall(function() shirt:Destroy() end) end
    local pants = char:FindFirstChildWhichIsA("Pants"); if pants then pcall(function() pants:Destroy() end) end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then local h = a:FindFirstChild("Handle"); if h then h.Transparency = 0 end end
    end
    -- keep STATIC_HUB Headless / Korblox toggles working after reset
    pcall(function() if _G.ExeApplyCharacterVisuals then _G.ExeApplyCharacterVisuals(char) end end)
end

local OUTFIT_LIST = {
    {label = "No", customApply = applyNo},
    {label = "Outfit 1", accessory = 10159600649, offset = Vector3.new(0, 1, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", headlessKorblox = true},
    {label = "Outfit 2", accessory = 1744060292, offset = Vector3.new(0, 1.3, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", headlessKorblox = true},
    {label = "Outfit 3", accessory = 8349240186, offset = Vector3.new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=11926549070", pants = "http://www.roblox.com/asset/?id=13189494471", headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747", headlessKorblox = true},
    {label = "Outfit 4", accessory = 121097973925756, offset = Vector3.new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=123181702116947", pants = "http://www.roblox.com/asset/?id=93330291631062", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", headlessKorblox = true},
    {label = "Homero Chino", customApply = applyHomero},
    {label = "Outfit 5", accessory = 306969564, offset = Vector3.new(0, 0.3, 0), shirt = "http://www.roblox.com/asset/?id=10632503795", pants = "http://www.roblox.com/asset/?id=123161592384863", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", korblox = true, hideAccessories = true},
    {label = "Outfit 6", accessory = 1744060292, offset = Vector3.new(0, 1.4, -0.2), shirt = "http://www.roblox.com/asset/?id=11526718530", pants = "http://www.roblox.com/asset/?id=93710523210027", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", korblox = true, hideAccessories = true},
    {label = "Outfit 7", accessory = 112564966849233, offset = Vector3.new(0, 0.6, 0), shirt = "http://www.roblox.com/asset/?id=11849088376", pants = "http://www.roblox.com/asset/?id=16534673928", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", korblox = true, hideAccessories = true},
}
_G.ExeOutfitIndex = math.clamp(tonumber(_G.ExeOutfitIndex) or 1, 1, #OUTFIT_LIST)
local outfitValueLabel = nil
local applyToken = 0

local function applyOutfitByIndex(index)
    local cfg = OUTFIT_LIST[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    if cfg.customApply then
        cfg.customApply(char)
        return
    end
    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    clearTagged(char)
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then pcall(function() d:Destroy() end) end
    end
    local done = false
    if head:IsA("MeshPart") then
        done = pcall(function()
            head.MeshId = cfg.headMesh
            if cfg.headTexture then head.TextureID = cfg.headTexture end
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
        sm.Parent = head; sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh; sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = cfg.shirt; s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = cfg.pants; p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory")
    if old then old:Destroy() end
    if cfg.accessory then
        local objs = loadObjs(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"; h.CanCollide = false; h.Anchored = false; h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head; weld.Part1 = h; weld.C0 = CFrame.new(cfg.offset); weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    -- reset anything a previous outfit changed
    local oldK2 = char:FindFirstChild("Korblox_RightLeg"); if oldK2 then oldK2:Destroy() end
    do
        local h2 = char:FindFirstChild("Head")
        if h2 then
            h2.Transparency = 0; h2.CanCollide = true; h2.LocalTransparencyModifier = 0
            local f2 = h2:FindFirstChild("face"); if f2 then f2.Transparency = 0 end
        end
        pcall(function() local neck = char:FindFirstChild("Neck"); if neck then neck.Enabled = true end end)
        for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
            local limb = char:FindFirstChild(partName); if limb then limb.Transparency = 0 end
        end
        for _, a in ipairs(char:GetChildren()) do
            if a:IsA("Accessory") then local hd = a:FindFirstChild("Handle"); if hd then hd.Transparency = cfg.hideAccessories and 1 or 0 end end
        end
    end
    if cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    elseif cfg.korblox then
        applyKorbloxOnly(char)
    end
end
_G.ExeApplyOutfitByIndex = applyOutfitByIndex

local function runOutfit(index, delayT)
    applyToken = applyToken + 1
    local my = applyToken
    task.spawn(function()
        if delayT and delayT > 0 then task.wait(delayT) end
        if my ~= applyToken then return end
        pcall(applyOutfitByIndex, index)
    end)
end

-- re-apply saved outfit after every respawn (after STATIC_HUB visuals finished)
LP.CharacterAdded:Connect(function()
    if (_G.ExeOutfitIndex or 1) > 1 then runOutfit(_G.ExeOutfitIndex, 1.6) end
end)
-- re-apply saved outfit on execute / rejoin
if (_G.ExeOutfitIndex or 1) > 1 then runOutfit(_G.ExeOutfitIndex, 2.2) end

-- UI row (same style as Sky Theme selector)
local function makeBtn(parent, name, text, pos, size)
    local b = Instance.new("TextButton")
    b.Name = name; b.ZIndex = 6; b.Position = pos; b.Size = size
    b.BackgroundColor3 = Color3.fromRGB(8, 8, 8); b.BackgroundTransparency = 0.18
    b.BorderSizePixel = 0; b.Text = text; b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 12; b.Font = Enum.Font.GothamMedium; b.AutoButtonColor = false
    b.Parent = parent
    corner(b, 7); stroke(b, COLORS.strokeSoft, 1, 0.45)
    return b
end
local row = Instance.new("Frame")
row.Name = "Outfits"; row.ZIndex = 4; row.Size = UDim2.new(1, -4, 0, 52)
row.BackgroundTransparency = 1; row.BorderSizePixel = 0; row.LayoutOrder = 0
row.Parent = Utility
local lbl = Instance.new("TextLabel")
lbl.Name = "Label"; lbl.ZIndex = 5; lbl.Position = UDim2.new(0, 2, 0, 0)
lbl.Size = UDim2.new(1, 0, 0, 16); lbl.BackgroundTransparency = 1; lbl.Text = "Outfits"
lbl.TextColor3 = Color3.fromRGB(255, 255, 255); lbl.TextSize = 12
lbl.Font = Enum.Font.GothamBlack; lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.Parent = row
local left = makeBtn(row, "OutfitLeft", "<", UDim2.new(0, 0, 0, 22), UDim2.new(0, 44, 0, 25))
local value = makeBtn(row, "OutfitValue", OUTFIT_LIST[_G.ExeOutfitIndex].label, UDim2.new(0, 48, 0, 22), UDim2.new(1, -96, 0, 28))
local right = makeBtn(row, "OutfitRight", ">", UDim2.new(1, -44, 0, 22), UDim2.new(0, 44, 0, 25))
outfitValueLabel = value

local function setOutfit(nextIndex)
    if nextIndex < 1 then nextIndex = #OUTFIT_LIST end
    if nextIndex > #OUTFIT_LIST then nextIndex = 1 end
    _G.ExeOutfitIndex = nextIndex
    outfitValueLabel.Text = OUTFIT_LIST[nextIndex].label
    runOutfit(nextIndex, 0)
    if saveExeConfig then pcall(saveExeConfig) end
end
left.Activated:Connect(function() setOutfit((_G.ExeOutfitIndex or 1) - 1) end)
right.Activated:Connect(function() setOutfit((_G.ExeOutfitIndex or 1) + 1) end)
value.Activated:Connect(function() setOutfit((_G.ExeOutfitIndex or 1) + 1) end)
end
-- ===== END OUTFITS PACK =====

task.defer(function()
task.wait(0.8)
_G.ExeApplyCharacterVisuals(LP.Character)
if _G.ExeHeadlessVisual then _G.ExeHeadlessVisual(_G.ExeHeadlessEnabled) end
if _G.ExeKorbloxVisual then _G.ExeKorbloxVisual(_G.ExeKorbloxEnabled) end
end)

section(Utility, "ESP", 1)
do
local espRow, setESPVisual = toggleRow(Utility, "ESP", espEnabled, 2)
setPlayerESPVisual = setESPVisual
_aceBtn = espRow and espRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
espEnabled = not espEnabled
if espEnabled then
if startPlayerESP then startPlayerESP() end
if BoxedESPOptions then BoxedESPOptions.box = false end
else
if stopPlayerESP then stopPlayerESP() end
if BoxedESPOptions then BoxedESPOptions.box = false end
end
if refreshBoxedESP then refreshBoxedESP() end
if setESPVisual then setESPVisual(espEnabled) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
section(Utility, "SKY THEME", 5)
skyThemeSelectorRow(Utility, 6)

animationPackRow(Utility, 7)

section(Utility, "PERFORMANCE", 8)
do
local row, setVisual = toggleRow(Utility, "Stretch Rez", fpsBoostEnabled, 8)
setFPSBoostVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
fpsBoostEnabled = not fpsBoostEnabled
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
if setVisual then setVisual(fpsBoostEnabled) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end

do
local row, setVisual = toggleRow(Utility, "Anti Lag", antiLagVisualEnabled, 10)
setAntiLagVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if antiLagVisualEnabled then disableAntiLag() else enableAntiLag() end
if setVisual then setVisual(antiLagVisualEnabled) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
do
local row, setVisual = _G.ExeActionToggleRow(Utility, "Nuke Optimiser", nukeOptimiserEnabled, 11)
setNukeOptimiserVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if nukeOptimiserEnabled then disableNukeOptimizer() else enableNukeOptimizer() end
if setVisual then setVisual(nukeOptimiserEnabled) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
section(Utility, "CAMERA", 12)
do
local row, setVisual = toggleRow(Utility, "FOV", fovEnabled, 13)
setFOVVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if fovEnabled then disableCustomFov() else enableCustomFov() end
if setVisual then setVisual(fovEnabled) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
do
local _, box = textboxRow(Utility, "FOV Value", tostring(fovValue), 14)
box.FocusLost:Connect(function()
local v = tonumber(box.Text)
if v and v >= 30 and v <= 120 then
fovValue = v
if fovEnabled and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovValue end
end
box.Text = tostring(fovValue)
if saveExeConfig then pcall(saveExeConfig) end
end)
end
do
local row, setVisual = toggleRow(Utility, "No Cam Collision", noCamCollisionEnabled, 15)
setNoCamCollisionVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if noCamCollisionEnabled then disableNoCamCollision() else enableNoCamCollision() end
if setVisual then setVisual(noCamCollisionEnabled) end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
-- ==================== TOOL SKINS (VISUAL TAB) ====================
-- Client-side visual overlays only. Defaults restore the original tool appearance.
do
    local BAT_SKIN_OPTIONS = {
        "Default", "Diamond Sword", "Katana", "Abyss Blue", "Venom Green",
        "Royal Gold", "Velvet Rose", "Crimson Night", "RGB",
        "Cursed Katana", "Cursed Scythe", "Cursed Ban Hammer"
    }
    local MEDUSA_SKIN_OPTIONS = { "Default", "Skull", "Golden Desert Eagle" }

    local MESH_SKINS = {
        ["Diamond Sword"] = {
            category = "Bat", mesh = "rbxassetid://8827558932", texture = "rbxassetid://8827558969",
            scale = Vector3.new(0.2, 0.2, 0.2),
            c0 = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), math.rad(300)),
        },
        ["Katana"] = {
            category = "Bat", mesh = "rbxassetid://13528902482", texture = "rbxassetid://13528902373",
            scale = Vector3.new(1.4, 1.4, 1.4),
            c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
        },
        ["Skull"] = {
            category = "Medusa", mesh = "rbxassetid://2050312704", texture = "rbxassetid://2050313393",
            scale = Vector3.new(1, 1, 1),
            c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
        },
        ["Golden Desert Eagle"] = {
            category = "Medusa", mesh = "rbxassetid://430251413", texture = "rbxassetid://435840335",
            scale = Vector3.new(0.01, 0.01, 0.01),
            c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
        },
    }
    local BAT_SKIN_ASSET_ID = "rbxassetid://18566246244"
    local BAT_SKIN_COLORS = {
        ["Abyss Blue"] = Color3.fromRGB(0, 40, 150),
        ["Venom Green"] = Color3.fromRGB(20, 255, 50),
        ["Royal Gold"] = Color3.fromRGB(255, 200, 0),
        ["Velvet Rose"] = Color3.fromRGB(220, 20, 100),
        ["Crimson Night"] = Color3.fromRGB(90, 0, 20),
    }

    _G.ExeSelectedBatSkin = tostring(_G.ExeSelectedBatSkin or "Default")
    _G.ExeSelectedMedusaSkin = tostring(_G.ExeSelectedMedusaSkin or "Default")
    local trackedTools = setmetatable({}, { __mode = "k" })
    local watchedContainers = setmetatable({}, { __mode = "k" })
    local batVisualSource = nil
    local batVisualLoading = false

    -- ==================== SKIN SOUNDS + CURSED HUB BAT SKINS ====================
    -- Hit sounds (Sound Hub) for Bat / Medusa skins, and Cursed Hub bat skins with their swing sounds.
    local CURSED_RED = Color3.fromRGB(200, 0, 0)
    local CURSED_RED_LIGHT = Color3.fromRGB(255, 100, 100)
    local CURSED_RED_DARK = Color3.fromRGB(140, 0, 0)
    local CURSED_SWING_KATANA = "rbxassetid://111808555599832"
    local CURSED_SWING_BAN_HAMMER = "rbxassetid://137964779511233"
    local CURSED_SKINS = {
        ["Cursed Katana"] = {
            assetId = "47562480", swing = CURSED_SWING_KATANA,
            adjust = { x = 0.09, y = 0.5, z = 0.55, rx = 18, ry = -180, rz = 95, scale = 5.5 },
        },
        ["Cursed Scythe"] = {
            assetId = "8699386664", swing = CURSED_SWING_KATANA,
            adjust = { x = 0.09, y = -1, z = -0.8, rx = 5, ry = -90, rz = 0, scale = 6 },
        },
        ["Cursed Ban Hammer"] = {
            assetId = "14701192921", swing = CURSED_SWING_BAN_HAMMER, banHammer = true,
            adjust = { x = 0, y = -1, z = 0, rx = 0, ry = 180, rz = 0, scale = 4 },
        },
    }
    local cursedAssetCache = {}

    local function skinSoundsEnabled()
        return _G.ExeCustomSoundEnabled ~= false
    end

    -- ---------- Sound Hub hit sounds (Bat / Medusa) ----------
    local CSND = {
        sounds = {
            Bat = { id = "rbxassetid://5713085119", skip = 0.2 },
            Medusa = { id = "rbxassetid://3102797479", doublePlay = true, delay = 0.5 },
        },
        tracked = setmetatable({}, { __mode = "k" }),
    }

    local function csPlay(entry)
        local snd = entry and entry.custom
        local d = entry and entry.data
        if not snd or not snd.Parent or not d or not skinSoundsEnabled() then return end
        local now = tick()
        if entry.lastPlay and (now - entry.lastPlay) < 0.09 then return end
        entry.lastPlay = now
        if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
        task.spawn(function()
            if not skinSoundsEnabled() or not snd or not snd.Parent then return end
            pcall(function()
                if not snd.IsLoaded then
                    game:GetService("ContentProvider"):PreloadAsync({ snd })
                end
            end)
            if not skinSoundsEnabled() or not snd.Parent then return end
            pcall(function()
                snd:Stop()
                snd.TimePosition = d.skip or 0
                snd.Volume = 1
                snd:Play()
            end)
        end)
        if d.doublePlay and d.delay then
            entry.timer = task.delay(d.delay, function()
                entry.timer = nil
                if not skinSoundsEnabled() or not snd or not snd.Parent then return end
                pcall(function()
                    snd:Stop()
                    snd.TimePosition = d.skip or 0
                    snd.Volume = 1
                    snd:Play()
                end)
            end)
        end
    end

    local function csHookSound(entry, snd)
        if not snd or not snd:IsA("Sound") or snd.Name == "STATIC_HUB_CustomSound" then return end
        if entry.hooked[snd] ~= nil then return end
        entry.hooked[snd] = snd.Volume
        local function trigger()
            if not skinSoundsEnabled() then return end
            if snd.Playing then
                pcall(function() snd.Volume = 0; snd:Stop() end)
                csPlay(entry)
            end
        end
        entry.conns[#entry.conns + 1] = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
        if snd.Playing then trigger() end
    end

    local function csTeardown(tool)
        local entry = CSND.tracked[tool]
        if not entry then return end
        CSND.tracked[tool] = nil
        if entry.timer then pcall(task.cancel, entry.timer) end
        for _, c in ipairs(entry.conns) do pcall(function() c:Disconnect() end) end
        if entry.custom then pcall(function() entry.custom:Destroy() end) end
        for snd, vol in pairs(entry.hooked) do
            if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
        end
    end

    local function csSetup(tool, category)
        if not skinSoundsEnabled() or not tool then return end
        local data = CSND.sounds[category]
        if not data or not data.id then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then return end
        csTeardown(tool)
        local old = handle:FindFirstChild("STATIC_HUB_CustomSound")
        if old then pcall(function() old:Destroy() end) end
        local custom = Instance.new("Sound")
        custom.Name = "STATIC_HUB_CustomSound"
        custom.SoundId = data.id
        custom.Volume = 1
        custom.Looped = false
        custom.RollOffMode = Enum.RollOffMode.Inverse
        custom.MaxDistance = 1000
        custom.MinDistance = 1000
        custom.Parent = handle
        local entry = { custom = custom, data = data, conns = {}, hooked = {}, timer = nil }
        CSND.tracked[tool] = entry
        for _, d in ipairs(tool:GetDescendants()) do csHookSound(entry, d) end
        entry.conns[#entry.conns + 1] = tool.DescendantAdded:Connect(function(d)
            if CSND.tracked[tool] == entry then csHookSound(entry, d) end
        end)
    end

    -- ---------- Cursed Hub swing sounds ----------
    local function applyCursedSwingSound(tool, skinName)
        local data = CURSED_SKINS[skinName]
        if not tool or not data or not skinSoundsEnabled() then return end
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("Sound") and obj.Name ~= "STATIC_HUB_CustomSound" then
                local n = string.lower(obj.Name or "")
                pcall(function()
                    if n == "" or n:find("swing") or n:find("slash") or n:find("bat") or n:find("slap")
                        or n:find("lunge") or n:find("attack") then
                        if obj:GetAttribute("STATIC_HUB_OrigSoundId") == nil then
                            obj:SetAttribute("STATIC_HUB_OrigSoundId", obj.SoundId)
                            obj:SetAttribute("STATIC_HUB_OrigVolume", obj.Volume)
                            obj:SetAttribute("STATIC_HUB_OrigSpeed", obj.PlaybackSpeed)
                        end
                        if obj.SoundId ~= data.swing then obj.SoundId = data.swing end
                        obj.Volume = 0.7
                        obj.PlaybackSpeed = 1
                        if data.banHammer and not obj:GetAttribute("STATIC_HUB_BanHammerCutoff") then
                            obj:SetAttribute("STATIC_HUB_BanHammerCutoff", true)
                            obj.Played:Connect(function()
                                task.delay(0.4, function()
                                    if obj and obj.Parent and obj.Playing
                                        and _G.ExeSelectedBatSkin == "Cursed Ban Hammer" and skinSoundsEnabled() then
                                        pcall(function() obj:Stop() end)
                                    end
                                end)
                            end)
                        end
                    end
                end)
            end
        end
    end

    local function restoreSwingSounds(tool)
        if not tool then return end
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("Sound") then
                pcall(function()
                    local orig = obj:GetAttribute("STATIC_HUB_OrigSoundId")
                    if orig ~= nil then
                        obj.SoundId = orig
                        local vol = obj:GetAttribute("STATIC_HUB_OrigVolume")
                        if vol ~= nil then obj.Volume = vol end
                        local spd = obj:GetAttribute("STATIC_HUB_OrigSpeed")
                        if spd ~= nil then obj.PlaybackSpeed = spd end
                        obj:SetAttribute("STATIC_HUB_OrigSoundId", nil)
                        obj:SetAttribute("STATIC_HUB_OrigVolume", nil)
                        obj:SetAttribute("STATIC_HUB_OrigSpeed", nil)
                    end
                end)
            end
        end
    end

    -- ---------- Cursed Hub skin visuals (red VFX) ----------
    local function forceRedVFX(model)
        if not model then return end
        for _, obj in ipairs(model:GetDescendants()) do
            local objName = string.lower(obj.Name or "")
            if obj:IsA("ParticleEmitter") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, CURSED_RED_LIGHT),
                        ColorSequenceKeypoint.new(0.5, CURSED_RED),
                        ColorSequenceKeypoint.new(1, CURSED_RED_DARK)
                    })
                    obj.LightEmission = math.max(obj.LightEmission or 0, 0.6)
                    pcall(function() obj.Texture = "rbxasset://textures/particles/sparkles_main.dds" end)
                end)
            elseif obj:IsA("Trail") or obj:IsA("Beam") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = ColorSequence.new(CURSED_RED, CURSED_RED_DARK)
                    obj.LightEmission = math.max(obj.LightEmission or 0, 0.5)
                    pcall(function() obj.Texture = "" end)
                end)
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = CURSED_RED
                end)
            elseif obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Smoke") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = CURSED_RED
                    if obj:IsA("Fire") then obj.SecondaryColor = CURSED_RED_LIGHT end
                end)
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                pcall(function() obj.Color3 = CURSED_RED end)
            elseif obj:IsA("BasePart") then
                local c = obj.Color
                local redDominant = (c.R > 0.38 and c.R > (c.B * 1.03) and c.G < 0.50)
                local orangeOrYellowVFX = (c.R > 0.50 and c.G > 0.20 and c.B < 0.28)
                local looksLikeVFX = obj.Material == Enum.Material.Neon
                    or objName:find("vfx") or objName:find("effect") or objName:find("trail")
                    or objName:find("aura") or objName:find("glow") or objName:find("fire")
                    or objName:find("flame") or objName:find("slash") or objName:find("spark")
                    or objName:find("red") or objName:find("orange") or objName:find("yellow")
                if redDominant or orangeOrYellowVFX or looksLikeVFX then
                    pcall(function() obj.Color = CURSED_RED end)
                end
            end
        end
    end

    local function addRedWeaponVFX(model)
        if not model then return end
        for _, obj in ipairs(model:GetDescendants()) do
            if obj.Name == "STATIC_HUB_CursedExtraVFX" then
                pcall(function() obj:Destroy() end)
            end
        end
        local bestPart, bestLen = nil, 0
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("BasePart") then
                local s = obj.Size
                local len = math.max(s.X, s.Y, s.Z)
                if len > bestLen then bestLen = len; bestPart = obj end
            end
        end
        if not bestPart then return end
        local a0 = Instance.new("Attachment")
        a0.Name = "STATIC_HUB_CursedExtraVFX"
        a0.Position = Vector3.new(0, bestLen * 0.42, 0)
        a0.Parent = bestPart
        local a1 = Instance.new("Attachment")
        a1.Name = "STATIC_HUB_CursedExtraVFX"
        a1.Position = Vector3.new(0, -bestLen * 0.42, 0)
        a1.Parent = bestPart
        local trail = Instance.new("Trail")
        trail.Name = "STATIC_HUB_CursedExtraVFX"
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Color = ColorSequence.new(CURSED_RED_LIGHT, CURSED_RED_DARK)
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
        trail.Lifetime = 0.18
        trail.LightEmission = 0.55
        trail.Parent = bestPart
        local pe = Instance.new("ParticleEmitter")
        pe.Name = "STATIC_HUB_CursedExtraVFX"
        pe.Color = ColorSequence.new(CURSED_RED, CURSED_RED_LIGHT)
        pe.LightEmission = 0.55
        pe.Rate = 14
        pe.Lifetime = NumberRange.new(0.25, 0.45)
        pe.Speed = NumberRange.new(0.2, 0.7)
        pe.SpreadAngle = Vector2.new(12, 12)
        pe.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.08),
            NumberSequenceKeypoint.new(1, 0)
        })
        pcall(function() pe.Texture = "rbxasset://textures/particles/sparkles_main.dds" end)
        pe.Parent = bestPart
    end

    -- Returns true (built), false (asset failed) or "stale" (a newer apply replaced this one).
    local function makeCursedOverlay(tool, handle, skinName, entry)
        local data = CURSED_SKINS[skinName]
        if not data or not handle or not handle.Parent then return false end
        local src = cursedAssetCache[data.assetId]
        if not src then
            local ok, objects = pcall(function() return game:GetObjects("rbxassetid://" .. data.assetId) end)
            if not ok or type(objects) ~= "table" or not objects[1] then return false end
            src = objects[1]
            cursedAssetCache[data.assetId] = src
        end
        if trackedTools[tool] ~= entry or not tool.Parent then return "stale" end

        local clone = src:Clone()
        clone.Name = "STATIC_HUB_CursedAsset"
        if clone:IsA("Script") or clone:IsA("LocalScript") or clone:IsA("ModuleScript") then
            pcall(function() clone:Destroy() end)
            return false
        end
        for _, obj in ipairs(clone:GetDescendants()) do
            local n = string.lower(obj.Name or "")
            if n:find("sheath") or n:find("scabbard") or n:find("saya") or n:find("case") or n:find("cover") then
                pcall(function() obj:Destroy() end)
            end
        end
        for _, obj in ipairs(clone:GetDescendants()) do
            local objName = string.lower(obj.Name or "")
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript")
                or obj:IsA("ScreenGui") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("SurfaceAppearance") or obj:IsA("MaterialVariant") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("ParticleEmitter") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, CURSED_RED_LIGHT),
                        ColorSequenceKeypoint.new(0.5, CURSED_RED),
                        ColorSequenceKeypoint.new(1, CURSED_RED_DARK)
                    })
                    obj.LightEmission = math.max(obj.LightEmission or 0, 0.55)
                    pcall(function() obj.Texture = "rbxasset://textures/particles/sparkles_main.dds" end)
                end)
            elseif obj:IsA("Trail") or obj:IsA("Beam") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, CURSED_RED_LIGHT),
                        ColorSequenceKeypoint.new(1, CURSED_RED_DARK)
                    })
                    obj.LightEmission = math.max(obj.LightEmission or 0, 0.45)
                    pcall(function() obj.Texture = "" end)
                end)
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = CURSED_RED
                    obj.Brightness = math.min(math.max(obj.Brightness, 0.8), 2)
                    obj.Range = math.min(math.max(obj.Range, 4), 10)
                end)
            elseif obj:IsA("Fire") or obj:IsA("Sparkles") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = CURSED_RED
                    if obj:IsA("Fire") then obj.SecondaryColor = CURSED_RED_LIGHT end
                end)
            elseif obj:IsA("Smoke") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = CURSED_RED
                end)
            elseif obj:IsA("SpecialMesh") then
                pcall(function() obj.VertexColor = Vector3.new(0.85, 0.1, 0.1) end)
            elseif obj:IsA("BasePart") then
                obj.Anchored = false
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = false
                obj.Massless = true
                obj.CastShadow = false
                local c = obj.Color
                local redDominant = (c.R > 0.38 and c.R > (c.B * 1.05) and c.G < 0.45)
                local orangeOrYellowVFX = (c.R > 0.50 and c.G > 0.20 and c.B < 0.25)
                local looksLikeVFX = obj.Material == Enum.Material.Neon
                    or objName:find("vfx") or objName:find("effect") or objName:find("trail")
                    or objName:find("aura") or objName:find("glow") or objName:find("fire")
                    or objName:find("flame") or objName:find("slash") or objName:find("spark")
                    or objName:find("red") or objName:find("orange") or objName:find("yellow")
                if redDominant or orangeOrYellowVFX or looksLikeVFX then
                    pcall(function() obj.Color = CURSED_RED end)
                end
            end
        end
        if clone:IsA("BasePart") then
            pcall(function()
                local c = clone.Color
                if (c.R > 0.38 and c.R > (c.B * 1.05) and c.G < 0.45) or (c.R > 0.50 and c.G > 0.20 and c.B < 0.25) then
                    clone.Color = CURSED_RED
                end
                clone.Anchored = false
                clone.CanCollide = false
                clone.CanTouch = false
                clone.CanQuery = false
                clone.Massless = true
                clone.CastShadow = false
            end)
        end

        local folder = Instance.new("Folder")
        folder.Name = "STATIC_HUB_SkinOverlay"
        folder.Parent = tool

        local model
        if clone:IsA("Model") then
            model = clone
            model.Parent = folder
        else
            if not clone:IsA("BasePart") and not clone:FindFirstChildWhichIsA("BasePart", true) then
                clone:Destroy()
                folder:Destroy()
                return false
            end
            model = Instance.new("Model")
            model.Name = "STATIC_HUB_CursedAssetModel"
            model.Parent = folder
            clone.Parent = model
        end

        local parts = {}
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("BasePart") then table.insert(parts, obj) end
        end
        if #parts == 0 then
            folder:Destroy()
            return false
        end

        local adjust = data.adjust
        local _, size = model:GetBoundingBox()
        local longest = math.max(size.X, size.Y, size.Z)
        if longest > 0 then
            local scale = math.clamp((adjust.scale or 5) / longest, 0.15, 8)
            pcall(function() model:ScaleTo(scale) end)
        end
        local _, size2 = model:GetBoundingBox()
        local axis = "Y"
        if size2.X > size2.Y and size2.X > size2.Z then axis = "X" end
        if size2.Z > size2.Y and size2.Z > size2.X then axis = "Z" end
        local rot = CFrame.new()
        if axis == "X" then
            rot = CFrame.Angles(0, 0, math.rad(90))
        elseif axis == "Z" then
            rot = CFrame.Angles(math.rad(90), 0, 0)
        end
        local desired = handle.CFrame
            * CFrame.new(adjust.x or 0, adjust.y or 0, adjust.z or 0)
            * rot
            * CFrame.Angles(math.rad(adjust.rx or 0), math.rad(adjust.ry or 0), math.rad(adjust.rz or 0))
        pcall(function() model:PivotTo(desired) end)
        for _, part in ipairs(parts) do
            part.Anchored = false
            local weld = Instance.new("WeldConstraint")
            weld.Name = "STATIC_HUB_CursedWeld"
            weld.Part0 = handle
            weld.Part1 = part
            weld.Parent = part
        end
        forceRedVFX(model)
        addRedWeaponVFX(model)
        task.delay(0.25, function()
            if model and model.Parent then
                forceRedVFX(model)
                addRedWeaponVFX(model)
            end
        end)
        return true
    end
    -- ==================== END SKIN SOUNDS + CURSED SKINS ====================

    local function skinToolCategory(tool)
        if not tool or not tool:IsA("Tool") then return nil end
        local name = tostring(tool.Name or ""):lower()
        if name:find("medusa", 1, true) or name:find("stone", 1, true) then return "Medusa" end
        if name:find("bat", 1, true) or name:find("slap", 1, true) then return "Bat" end
        return nil
    end

    local function getSelectedSkin(category)
        return category == "Bat" and _G.ExeSelectedBatSkin or _G.ExeSelectedMedusaSkin
    end

    local function isOverlayObject(entry, object)
        local current = object
        while current and current ~= entry.tool do
            if current.Name == "STATIC_HUB_SkinOverlay" then return true end
            current = current.Parent
        end
        return false
    end

    local function hideOriginalObject(entry, object)
        if not object or not object.Parent or isOverlayObject(entry, object) then return end
        local canHide = object:IsA("BasePart") or object:IsA("Decal") or object:IsA("Texture")
            or object:IsA("SpecialMesh") or object:IsA("Mesh")
        if not canHide then return end
        local ok, transparency = pcall(function() return object.Transparency end)
        if not ok then return end
        if entry.original[object] == nil then entry.original[object] = transparency end
        pcall(function() object.Transparency = 1 end)
    end

    local function restoreToolSkin(tool)
        pcall(csTeardown, tool)
        pcall(restoreSwingSounds, tool)
        local entry = trackedTools[tool]
        if entry then
            trackedTools[tool] = nil
            if entry.descendantConn then pcall(function() entry.descendantConn:Disconnect() end) end
            if entry.ancestryConn then pcall(function() entry.ancestryConn:Disconnect() end) end
            for object, transparency in pairs(entry.original) do
                if object and object.Parent then pcall(function() object.Transparency = transparency end) end
            end
        end
        if tool and tool.Parent then
            local overlay = tool:FindFirstChild("STATIC_HUB_SkinOverlay")
            if overlay then pcall(function() overlay:Destroy() end) end
        end
    end

    local function getBatVisualSource()
        if batVisualSource then return batVisualSource end
        if batVisualLoading then return nil end
        batVisualLoading = true
        local ok, objects = pcall(function() return game:GetObjects(BAT_SKIN_ASSET_ID) end)
        if ok and type(objects) == "table" and #objects > 0 then
            local root = objects[1]
            if root and root:IsA("BasePart") then
                batVisualSource = root
            elseif root then
                batVisualSource = root:FindFirstChildWhichIsA("BasePart", true)
            end
        end
        batVisualLoading = false
        return batVisualSource
    end

    local function tintBatVisual(visual, color)
        if not visual or not color then return end
        pcall(function() visual.Color = color end)
        if visual:IsA("UnionOperation") then pcall(function() visual.UsePartColor = true end) end
        local mesh = visual:FindFirstChildWhichIsA("SpecialMesh")
        if mesh then pcall(function() mesh.VertexColor = Vector3.new(color.R, color.G, color.B) end) end
    end

    local function makeMeshOverlay(tool, handle, skinName)
        local data = MESH_SKINS[skinName]
        if not data or not handle or not handle.Parent then return false end
        local model = Instance.new("Model")
        model.Name = "STATIC_HUB_SkinOverlay"
        local part = Instance.new("Part")
        part.Name = "SkinMeshPart"
        part.Size = Vector3.new(1, 1, 1)
        part.Transparency = 0
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
        part.Anchored = false
        part.Parent = model

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = data.mesh
        mesh.TextureId = data.texture
        mesh.Scale = data.scale
        mesh.Parent = part

        local motor = Instance.new("Motor6D")
        motor.Name = "STATIC_HUB_SkinMotor"
        motor.Part0 = handle
        motor.Part1 = part
        motor.C0 = data.c0
        motor.Parent = part
        model.Parent = tool
        return true
    end

    local function makeColorBatOverlay(tool, handle, skinName)
        local source = getBatVisualSource()
        if not source then return false end
        local visual = source:Clone()
        visual.Name = "STATIC_HUB_SkinOverlay"
        pcall(function()
            visual.CanCollide = false
            visual.CanTouch = false
            visual.CanQuery = false
            visual.Massless = true
            visual.Anchored = false
        end)
        pcall(function()
            local scaleModel = Instance.new("Model")
            visual.Parent = scaleModel
            scaleModel.PrimaryPart = visual
            scaleModel:ScaleTo(2)
            visual.Parent = nil
            scaleModel:Destroy()
        end)
        if skinName == "RGB" then
            tintBatVisual(visual, Color3.fromHSV((tick() % 3) / 3, 1, 1))
        else
            tintBatVisual(visual, BAT_SKIN_COLORS[skinName])
        end
        visual.CFrame = handle.CFrame * CFrame.new(-0.02, -0.52, -0.2) * CFrame.Angles(math.rad(45), 0, math.rad(5))
        visual.Parent = tool
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = visual
        weld.Parent = visual
        return true
    end

    local function applyToolSkin(tool)
        local category = skinToolCategory(tool)
        if not category then return end
        local skinName = getSelectedSkin(category)
        if not skinName or skinName == "Default" then
            restoreToolSkin(tool)
            return
        end
        local handle = tool:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then
            task.delay(0.35, function()
                if tool and tool.Parent then applyToolSkin(tool) end
            end)
            return
        end

        restoreToolSkin(tool)
        local entry = { tool = tool, category = category, original = {}, descendantConn = nil, ancestryConn = nil }
        trackedTools[tool] = entry
        for _, object in ipairs(tool:GetDescendants()) do hideOriginalObject(entry, object) end
        entry.descendantConn = tool.DescendantAdded:Connect(function(object)
            task.defer(function()
                if trackedTools[tool] == entry then hideOriginalObject(entry, object) end
            end)
        end)
        entry.ancestryConn = tool.AncestryChanged:Connect(function(_, parent)
            if parent == nil then restoreToolSkin(tool) end
        end)

        local made = false
        if category == "Bat" and CURSED_SKINS[skinName] then
            local ok, result = pcall(makeCursedOverlay, tool, handle, skinName, entry)
            if ok and result == "stale" then return end
            made = ok and result == true
            if made then pcall(applyCursedSwingSound, tool, skinName) end
        elseif category == "Medusa" and MESH_SKINS[skinName] and MESH_SKINS[skinName].category == "Medusa" then
            local ok, result = pcall(makeMeshOverlay, tool, handle, skinName)
            made = ok and result == true
        elseif category == "Bat" and MESH_SKINS[skinName] and MESH_SKINS[skinName].category == "Bat" then
            local ok, result = pcall(makeMeshOverlay, tool, handle, skinName)
            made = ok and result == true
        elseif category == "Bat" and BAT_SKIN_COLORS[skinName] or (category == "Bat" and skinName == "RGB") then
            local ok, result = pcall(makeColorBatOverlay, tool, handle, skinName)
            made = ok and result == true
        end
        if not made then
            -- If the selected mesh asset is unavailable, restore the real tool instead of hiding it.
            restoreToolSkin(tool)
            warn("[Static Hub] Skin asset could not be loaded: " .. tostring(skinName))
        elseif not CURSED_SKINS[skinName] then
            -- Bat / Medusa hit sound for the equipped custom skin.
            pcall(csSetup, tool, category)
        end
    end

    local function scanSkinContainer(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then task.defer(applyToolSkin, child) end
        end
    end

    local function watchSkinContainer(container)
        if not container or watchedContainers[container] then return end
        watchedContainers[container] = true
        scanSkinContainer(container)
        local connection = container.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then task.defer(applyToolSkin, child) end
        end)
        -- Keep a reference to make cleanup deterministic if the container is removed.
        table.insert(_G.ExeToolSkinConnections, connection)
        container.AncestryChanged:Connect(function(_, parent)
            if parent == nil then watchedContainers[container] = nil end
        end)
    end

    _G.ExeToolSkinConnections = _G.ExeToolSkinConnections or {}
    local function reapplyCategory(category)
        local tools = {}
        for tool, entry in pairs(trackedTools) do
            if entry.category == category then tools[tool] = true end
        end
        local character = LP.Character
        local backpack = LP:FindFirstChildOfClass("Backpack")
        for _, container in ipairs({ character, backpack }) do
            if container then
                for _, child in ipairs(container:GetChildren()) do
                    if child:IsA("Tool") and skinToolCategory(child) == category then tools[child] = true end
                end
            end
        end
        for tool in pairs(tools) do
            if tool and tool.Parent then task.defer(applyToolSkin, tool) end
        end
    end

    local function setBatSkin(mode)
        for _, option in ipairs(BAT_SKIN_OPTIONS) do
            if option == mode then _G.ExeSelectedBatSkin = mode; break end
        end
        reapplyCategory("Bat")
        return _G.ExeSelectedBatSkin
    end
    local function setMedusaSkin(mode)
        for _, option in ipairs(MEDUSA_SKIN_OPTIONS) do
            if option == mode then _G.ExeSelectedMedusaSkin = mode; break end
        end
        reapplyCategory("Medusa")
        return _G.ExeSelectedMedusaSkin
    end

    _G.ExeSetBatSkin = setBatSkin
    _G.ExeSetMedusaSkin = setMedusaSkin
    _G.ExeBatSkinOptions = BAT_SKIN_OPTIONS
    _G.ExeMedusaSkinOptions = MEDUSA_SKIN_OPTIONS

    -- Watch the current character, backpack and respawns.
    watchSkinContainer(LP.Character)
    watchSkinContainer(LP:FindFirstChildOfClass("Backpack"))
    table.insert(_G.ExeToolSkinConnections, LP.CharacterAdded:Connect(function(character)
        task.wait(0.35)
        watchSkinContainer(character)
        watchSkinContainer(LP:FindFirstChildOfClass("Backpack"))
        scanSkinContainer(character)
        scanSkinContainer(LP:FindFirstChildOfClass("Backpack"))
    end))
    table.insert(_G.ExeToolSkinConnections, LP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then watchSkinContainer(child); scanSkinContainer(child) end
    end))
    table.insert(_G.ExeToolSkinConnections, RunService.RenderStepped:Connect(function()
        if _G.ExeSelectedBatSkin ~= "RGB" then return end
        local character = LP.Character
        local tool = character and character:FindFirstChild("Bat")
        local visual = tool and tool:FindFirstChild("STATIC_HUB_SkinOverlay")
        if visual and visual:IsA("BasePart") then
            tintBatVisual(visual, Color3.fromHSV((tick() % 3) / 3, 1, 1))
        end
    end))

    local function toolSkinSelectorRow(parent, rowName, title, options, getValue, onSelect, order)
        local row = Instance.new("Frame")
        row.Name = rowName
        row.ZIndex = 4
        row.Size = UDim2.new(1, -4, 0, 52)
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.LayoutOrder = order
        row.Parent = parent

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.ZIndex = 5
        label.Position = UDim2.new(0, 2, 0, 0)
        label.Size = UDim2.new(1, 0, 0, 16)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.Font = Enum.Font.GothamBlack
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local left = Instance.new("TextButton")
        left.Name = "Previous"
        left.ZIndex = 6
        left.Position = UDim2.new(0, 0, 0, 22)
        left.Size = UDim2.new(0, 38, 0, 25)
        left.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        left.BackgroundTransparency = 0.18
        left.BorderSizePixel = 0
        left.Text = "<"
        left.TextColor3 = Color3.fromRGB(255, 255, 255)
        left.TextSize = 12
        left.Font = Enum.Font.GothamBold
        left.AutoButtonColor = false
        left.Parent = row
        corner(left, 7)
        stroke(left, COLORS.strokeSoft, 1, 0.45)

        local value = Instance.new("TextButton")
        value.Name = "SkinValue"
        value.ZIndex = 6
        value.Position = UDim2.new(0, 42, 0, 22)
        value.Size = UDim2.new(1, -84, 0, 25)
        value.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        value.BackgroundTransparency = 0.18
        value.BorderSizePixel = 0
        value.TextColor3 = Color3.fromRGB(255, 255, 255)
        value.TextSize = 11
        value.Font = Enum.Font.GothamMedium
        value.AutoButtonColor = false
        value.Parent = row
        corner(value, 7)
        stroke(value, COLORS.strokeSoft, 1, 0.45)

        local right = Instance.new("TextButton")
        right.Name = "Next"
        right.ZIndex = 6
        right.Position = UDim2.new(1, -38, 0, 22)
        right.Size = UDim2.new(0, 38, 0, 25)
        right.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        right.BackgroundTransparency = 0.18
        right.BorderSizePixel = 0
        right.Text = ">"
        right.TextColor3 = Color3.fromRGB(255, 255, 255)
        right.TextSize = 12
        right.Font = Enum.Font.GothamBold
        right.AutoButtonColor = false
        right.Parent = row
        corner(right, 7)
        stroke(right, COLORS.strokeSoft, 1, 0.45)

        local function refresh()
            value.Text = tostring(getValue())
        end
        local function change(delta)
            local current = 1
            local chosen = getValue()
            for i, option in ipairs(options) do if option == chosen then current = i; break end end
            current = ((current - 1 + delta) % #options) + 1
            onSelect(options[current])
            refresh()
        end
        left.Activated:Connect(function() change(-1) end)
        right.Activated:Connect(function() change(1) end)
        value.Activated:Connect(function() change(1) end)
        refresh()
        return row
    end

    section(Utility, "TOOL SKINS", 16)
    toolSkinSelectorRow(Utility, "Bat Skin Selector", "CUSTOM BAT SKIN", BAT_SKIN_OPTIONS,
        function() return _G.ExeSelectedBatSkin end,
        function(mode) setBatSkin(mode); if saveExeConfig then pcall(saveExeConfig) end end, 17)
    toolSkinSelectorRow(Utility, "Medusa Skin Selector", "CUSTOM MEDUSA SKIN", MEDUSA_SKIN_OPTIONS,
        function() return _G.ExeSelectedMedusaSkin end,
        function(mode) setMedusaSkin(mode); if saveExeConfig then pcall(saveExeConfig) end end, 18)

    -- Skin sounds toggle (bat hit / medusa hit / Cursed swing sounds)
    do
        local soundRow, soundVisual = toggleRow(Utility, "Skin Sounds", skinSoundsEnabled(), 19)
        local soundBtn = soundRow and soundRow:FindFirstChild("ToggleButton")
        if soundBtn then
            soundBtn.Activated:Connect(function()
                _G.ExeCustomSoundEnabled = not skinSoundsEnabled()
                if soundVisual then soundVisual(skinSoundsEnabled()) end
                reapplyCategory("Bat")
                reapplyCategory("Medusa")
                if saveExeConfig then pcall(saveExeConfig) end
            end)
        end
    end

    -- Keep skin sounds applied if the game recreates / resets the tool sounds.
    task.spawn(function()
        while task.wait(0.75) do
            pcall(function()
                if not skinSoundsEnabled() then return end
                for tool, entry in pairs(trackedTools) do
                    if tool and tool.Parent then
                        local skinName = getSelectedSkin(entry.category)
                        if CURSED_SKINS[skinName] then
                            applyCursedSwingSound(tool, skinName)
                        else
                            local csEntry = CSND.tracked[tool]
                            if csEntry then
                                for _, d in ipairs(tool:GetDescendants()) do csHookSound(csEntry, d) end
                            end
                        end
                    end
                end
            end)
        end
    end)
end
-- ==================== END TOOL SKINS ====================

-- Music player toggle removed by request.

end
task.wait()
__ExeDuelsSetupVisualsUI()

-- Custom font changer removed by request.

Settings = pages.SETTINGS

aceGuiScaleValue = ExeAutoMobile and 0.67 or 1.00
aceGuiScaleValue = math.clamp(aceGuiScaleValue, 0.50, 1.50)
_G.ExeGuiScaleValue = tonumber(_G.ExeGuiScaleValue) or aceGuiScaleValue
aceProgressBarScaleValue = tonumber(_G.ExeProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or (ExeAutoMobile and 0.83 or 1.00)
_G.ExeProgressBarScaleValue = aceProgressBarScaleValue
aceMainScale = Main:FindFirstChild("ExeMainScale") or Instance.new("UIScale")
aceMainScale.Name = "ExeMainScale"
aceMainScale.Scale = aceGuiScaleValue
aceMainScale.Parent = Main
local function applyExeProgressBarScale()
local scaleVal = tonumber(_G.ExeProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or 1
aceProgressBarScaleValue = scaleVal
_G.ExeProgressBarScaleValue = scaleVal
local function applyTo(bar)
    if not bar then return end
    local sc = bar:FindFirstChild("ExeProgressBarScale")
    if not sc then
        sc = Instance.new("UIScale")
        sc.Name = "ExeProgressBarScale"
        sc.Parent = bar
    end
    sc.Scale = scaleVal
end
-- Search common parents for StealBarGui
local parents = {}
pcall(function() table.insert(parents, PlayerGui) end)
pcall(function() table.insert(parents, LP:FindFirstChild("PlayerGui")) end)
pcall(function() if typeof(gethui) == "function" then table.insert(parents, gethui()) end end)
pcall(function() if typeof(get_hidden_gui) == "function" then table.insert(parents, get_hidden_gui()) end end)
for _, parent in ipairs(parents) do
    if parent then
        local sg = parent:FindFirstChild("StealBarGui")
        if sg then
            applyTo(sg:FindFirstChild("StealBar"))
            -- also any nested scale
            for _, d in ipairs(sg:GetDescendants()) do
                if d.Name == "ExeProgressBarScale" and d:IsA("UIScale") then
                    d.Scale = scaleVal
                end
            end
        end
    end
end
end
_G.ExeApplyProgressBarScale = applyExeProgressBarScale
_G.__ExeDuelsSetupSettingsUI = function()
section(MenuCustomize, "MENU CUSTOMIZE", 1)
-- Background Image Picker removed: random asset applied on execute
function updateBackgroundButtons() end
function makeNoneButton() end
function makeImageButton() end

function stepperRow(parent, labelText, defaultValue, order, callback, minValue, maxValue)
local row = Instance.new("Frame")
row.Name = labelText
row.BackgroundColor3 = COLORS.row
row.BackgroundTransparency = 0.22
row.Size = UDim2.new(1, -4, 0, 42)
row.BorderSizePixel = 0
row.LayoutOrder = order
row.ZIndex = 4
row.Parent = parent
corner(row, 10)
stroke(row, COLORS.strokeSoft, 1.15, 0.32)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = labelText
label.TextColor3 = Color3.fromRGB(245, 245, 245)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 11
label.Font = Enum.Font.GothamMedium
label.TextXAlignment = Enum.TextXAlignment.Left
label.Position = UDim2.new(0, 12, 0, 0)
label.Size = UDim2.new(1, -155, 1, 0)
label.ZIndex = 5
label.Parent = row
local value = defaultValue
local minus = Instance.new("TextButton")
minus.Name = "Minus"
minus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
minus.BackgroundTransparency = 0.1
minus.BorderSizePixel = 0
minus.Text = "-"
minus.TextColor3 = Color3.fromRGB(245, 245, 245)
minus.TextSize = 14
minus.Font = Enum.Font.GothamMedium
minus.AutoButtonColor = false
minus.Size = UDim2.new(0, 28, 0, 26)
minus.Position = UDim2.new(1, -118, 0.5, -13)
minus.ZIndex = 6
minus.Parent = row
corner(minus, 7)
stroke(minus, COLORS.strokeSoft, 1, 0.5)
local valueBox = Instance.new("TextLabel")
valueBox.Name = "Value"
valueBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
valueBox.BackgroundTransparency = 0.05
valueBox.BorderSizePixel = 0
valueBox.Text = string.format("%.2f", value)
valueBox.TextColor3 = Color3.fromRGB(245, 245, 245)
valueBox.TextSize = 13
valueBox.Font = Enum.Font.GothamMedium
valueBox.TextXAlignment = Enum.TextXAlignment.Center
valueBox.Size = UDim2.new(0, 48, 0, 26)
valueBox.Position = UDim2.new(1, -84, 0.5, -13)
valueBox.ZIndex = 6
valueBox.Parent = row
corner(valueBox, 7)
stroke(valueBox, COLORS.strokeSoft, 1, 0.5)
local plus = Instance.new("TextButton")
plus.Name = "Plus"
plus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
plus.BackgroundTransparency = 0.1
plus.BorderSizePixel = 0
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(245, 245, 245)
plus.TextSize = 14
plus.Font = Enum.Font.GothamMedium
plus.AutoButtonColor = false
plus.Size = UDim2.new(0, 28, 0, 26)
plus.Position = UDim2.new(1, -30, 0.5, -13)
plus.ZIndex = 6
plus.Parent = row
corner(plus, 7)
stroke(plus, COLORS.strokeSoft, 1, 0.5)
local function setValue(nextValue)
value = math.clamp(math.floor((nextValue * 100) + 0.5) / 100, minValue or 0.50, maxValue or 1.50)
valueBox.Text = string.format("%.2f", value)
if callback then callback(value) end
end
minus.MouseButton1Click:Connect(function()
setValue(value - 0.05)
end)
plus.MouseButton1Click:Connect(function()
setValue(value + 0.05)
end)
return row
end
makeNoneButton(0, 8, 8)
for index = 1, #BackgroundIDs do
local slot = index
local column = slot % 5
local rowIndex = math.floor(slot / 5)
makeImageButton(index, 8 + (column * 61), 8 + (rowIndex * 48))
end
updateBackgroundButtons()

-- Fixed blue GUI theme
local function applyThemeColor()
local tint = Color3.fromRGB(45, 130, 255)
local dim = Color3.fromRGB(25, 78, 155)
_G.ExeThemeName = "BLUE"
pcall(function()
if BgImage then BgImage.ImageColor3 = tint end
-- logo removed
if TitleSweepText then TitleSweepText.TextColor3 = tint end
THEME_ACCENT = tint
THEME_ACCENT_DIM = dim
end)
end
applyThemeColor()

stepperRow(Settings, "GUI Scale", tonumber(_G.ExeGuiScaleValue) or aceGuiScaleValue or 1, 6, function(v)
aceGuiScaleValue = v
_G.ExeGuiScaleValue = v
if aceMainScale then aceMainScale.Scale = v end
if saveExeConfig then pcall(saveExeConfig) end
end, 0.40, 1.50)
section(MenuCustomize, "STEAL UI", 20)
stepperRow(MenuCustomize, "Progress Bar Size", tonumber(_G.ExeProgressBarScaleValue) or aceProgressBarScaleValue or 1, 7, function(v)
aceProgressBarScaleValue = v
_G.ExeProgressBarScaleValue = v
applyExeProgressBarScale()
if saveExeConfig then pcall(saveExeConfig) end
end, 0.40, 1.75)
speedKeybindRow(Settings, "Toggle UI", "ToggleUI", 8)
section(Settings, "MOBILE BUTTONS", 4)
do
local row, setVisual = _G.ExeActionToggleRow(Settings, "Lock GUI", _G.ExeGuiLocked == true, 9)
setLockGuiVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_G.ExeGuiLocked = not (_G.ExeGuiLocked == true)
if setVisual then setVisual(_G.ExeGuiLocked == true) end
if ExeUpdateGuiLockVisual then ExeUpdateGuiLockVisual() end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
do
local row, setVisual = _G.ExeActionToggleRow(Settings, "Hide Mobile Buttons", _G.ExeHideMobileButtons == true, 10)
setHideMobileButtonsVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_G.ExeHideMobileButtons = not (_G.ExeHideMobileButtons == true)
if setVisual then setVisual(_G.ExeHideMobileButtons == true) end
if _G.ExeApplyMobileButtonsHidden then _G.ExeApplyMobileButtonsHidden() end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
do
_G.ExeHiddenMobileButtons = _G.ExeHiddenMobileButtons or {}
_G.ExeMobileButtonList = {
{"drop","DROP BR"},{"autoPlay","AUTO PLAY"},{"aimbot","BAT AIMBOT"},{"laggerNormal","LAGGER NORM"},
{"laggerCarry","LAGGER CARRY"},{"tp","TP DOWN"},{"carry","CARRY SPEED"},{"instantReset","INSTA RESET"},
{"instaMedusa","INSTA MEDUSA"},{"batV2","BAT V2"},{"antiBat","ANTI BAT BYPASS"},{"tpBat","TP BAT"},
}
section(Settings, "HIDE EACH BUTTON", 10.5)
local setters = {}
for i, item in ipairs(_G.ExeMobileButtonList) do
local key, label = item[1], item[2]
local row, setV = _G.ExeActionToggleRow(Settings, "Hide " .. label, _G.ExeHiddenMobileButtons[key] == true, 10.5 + i * 0.01)
setters[key] = setV
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_G.ExeHiddenMobileButtons[key] = not (_G.ExeHiddenMobileButtons[key] == true) or nil
if setV then setV(_G.ExeHiddenMobileButtons[key] == true) end
if _G.ExeApplyHiddenMobileButtons then _G.ExeApplyHiddenMobileButtons() end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
end
function _G.ExeRefreshHideEachRows()
for key, setV in pairs(setters) do
if setV then pcall(setV, _G.ExeHiddenMobileButtons[key] == true) end
end
end
end
stepperRow(Settings, "Mobile Buttons Size", tonumber(_G.ExeMobileButtonScale) or 1.00, 11, function(v)
_G.ExeMobileButtonScale = math.clamp(tonumber(v) or 0.35, 0.30, 1.35)
if _G.ExeApplyMobileButtonSize then _G.ExeApplyMobileButtonSize() end
if saveExeConfig then pcall(saveExeConfig) end
end, 0.30, 1.35)
do
local row = baseRow(Settings, "Mobile Button Shape", 12)
local shapeButton = Instance.new("TextButton")
shapeButton.Name = "MobileButtonShapeSelector"
shapeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
shapeButton.BackgroundTransparency = 0.05
shapeButton.BorderSizePixel = 0
shapeButton.TextColor3 = Color3.fromRGB(245, 245, 245)
shapeButton.TextSize = 10
shapeButton.Font = Enum.Font.GothamMedium
shapeButton.AutoButtonColor = false
shapeButton.Size = UDim2.new(0, 112, 0, 27)
shapeButton.Position = UDim2.new(1, -122, 0.5, -13)
shapeButton.ZIndex = 7
shapeButton.Parent = row
corner(shapeButton, 7)
stroke(shapeButton, COLORS.strokeSoft, 1, 0.45)
local shapeOrder = {"CIRCLE", "ROUNDED", "SQUARE"}
local shapeDisplay = {CIRCLE = "CIRCLE", ROUNDED = "ROUNDED", SQUARE = "SQUARE"}
local function refreshShapeText()
shapeButton.Text = shapeDisplay[_G.ExeMobileButtonShape] or "ROUNDED"
end
shapeButton.MouseButton1Click:Connect(function()
local currentIndex = 1
for i, shape in ipairs(shapeOrder) do
if shape == _G.ExeMobileButtonShape then currentIndex = i break end
end
currentIndex = (currentIndex % #shapeOrder) + 1
_G.ExeMobileButtonShape = shapeOrder[currentIndex]
refreshShapeText()
if _G.ExeApplyMobileButtonShape then _G.ExeApplyMobileButtonShape() end
if saveExeConfig then pcall(saveExeConfig) end
end)
refreshShapeText()
end
do
function createHorizontalImagePicker(parent, name, layoutOrder, selectedGetter, selectedSetter, assetIds)
assetIds = assetIds or BackgroundIDs

local pickerRow = Instance.new("Frame")
pickerRow.Name = name
pickerRow.ZIndex = 4
pickerRow.Size = UDim2.new(1,-4,0,52)
pickerRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
pickerRow.BackgroundTransparency = 0.3
pickerRow.BorderSizePixel = 0
pickerRow.LayoutOrder = layoutOrder
pickerRow.Parent = parent
corner(pickerRow,11)
stroke(pickerRow,Color3.fromRGB(255,255,255),1.25,0.45)

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "PickerScroll"
scroll.ZIndex = 5
scroll.Size = UDim2.new(1,-56,1,0)
scroll.Position = UDim2.new(0.5,0,0,0)
scroll.AnchorPoint = Vector2.new(0.5,0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.ScrollBarImageTransparency = 1
scroll.ScrollingDirection = Enum.ScrollingDirection.X
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
scroll.Parent = pickerRow

local list = Instance.new("UIListLayout")
list.FillDirection = Enum.FillDirection.Horizontal
list.Padding = UDim.new(0,4)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.VerticalAlignment = Enum.VerticalAlignment.Center
list.Parent = scroll

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0,4)
pad.PaddingRight = UDim.new(0,4)
pad.Parent = scroll

local buttons = {}

local function selectedIndex()
    local current = tostring(selectedGetter() or "")
    local id = current:match("(%d+)")
    if not id then return 0 end
    for i,assetId in ipairs(assetIds) do
        if tostring(assetId) == tostring(id) then return i end
    end
    return 0
end

local function updateButtons()
    local selected = selectedIndex()
    for index,thumb in pairs(buttons) do
        local on = index == selected
        local st = thumb:FindFirstChildOfClass("UIStroke")
        if st then
            st.Color = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(81, 81, 81)
            st.Transparency = on and 0 or 0.4
            st.Thickness = on and 1.25 or 1
        end
        thumb.ImageTransparency = on and 0 or 0.22
    end
end

local function choose(index)
    selectedSetter(index == 0 and "" or ("rbxassetid://" .. tostring(assetIds[index])))
    updateButtons()
end

local function makeThumb(index,assetId)
    local thumb = Instance.new("ImageButton")
    thumb.Name = "Thumb" .. tostring(index)
    thumb.ZIndex = 5
    thumb.LayoutOrder = index + 1
    thumb.Size = UDim2.new(0,42,0,34)
    thumb.BackgroundColor3 = Color3.fromRGB(0,0,0)
    thumb.BorderSizePixel = 0
    thumb.Image = assetId and ("rbxassetid://" .. tostring(assetId)) or ""
    thumb.ImageTransparency = 0.22
    thumb.ScaleType = Enum.ScaleType.Crop
    thumb.AutoButtonColor = false
    thumb.Parent = scroll
    corner(thumb,9)
    stroke(thumb,Color3.fromRGB(81, 81, 81),1,0.4)

    if index == 0 then
        local none = Instance.new("TextLabel")
        none.Name = "NoneLabel"
        none.ZIndex = 6
        none.Size = UDim2.new(1,0,1,0)
        none.BackgroundTransparency = 1
        none.Text = "NONE"
        none.TextColor3 = COLORS.white
        none.TextSize = 9
        none.Font = Enum.Font.GothamMedium
        none.Parent = thumb
    end

    buttons[index] = thumb
    thumb.MouseButton1Click:Connect(function() choose(index) end)
end

makeThumb(0,nil)
for i,id in ipairs(assetIds) do
    makeThumb(i,id)
end

local left = Instance.new("TextButton")
left.ZIndex = 8
left.Position = UDim2.new(0,3,0.5,-17)
left.Size = UDim2.new(0,22,0,34)
left.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
left.BackgroundTransparency = 0.05
left.BorderSizePixel = 0
left.Text = "<"
left.TextColor3 = COLORS.white
left.TextSize = 18
left.Font = Enum.Font.GothamMedium
left.AutoButtonColor = false
left.Parent = pickerRow
corner(left,7)

local right = Instance.new("TextButton")
right.ZIndex = 8
right.Position = UDim2.new(1,-25,0.5,-17)
right.Size = UDim2.new(0,22,0,34)
right.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
right.BackgroundTransparency = 0.05
right.BorderSizePixel = 0
right.Text = ">"
right.TextColor3 = COLORS.white
right.TextSize = 18
right.Font = Enum.Font.GothamMedium
right.AutoButtonColor = false
right.Parent = pickerRow
corner(right,7)

left.MouseButton1Click:Connect(function()
    local pos = scroll.CanvasPosition
    TweenService:Create(scroll,TweenInfo.new(0.2),{
        CanvasPosition = Vector2.new(math.max(0,pos.X-50),0)
    }):Play()
end)

right.MouseButton1Click:Connect(function()
    local pos = scroll.CanvasPosition
    TweenService:Create(scroll,TweenInfo.new(0.2),{
        CanvasPosition = Vector2.new(pos.X+50,0)
    }):Play()
end)

updateButtons()
return pickerRow
end

-- Image pickers removed: random assets applied on execute
end

do
local row = baseRow(Settings, "Reset Mobile Buttons", 15)
local button = Instance.new("TextButton")
button.Name = "ResetMobileButtons"
button.BackgroundColor3 = Color3.fromRGB(233, 233, 233)
button.BackgroundTransparency = 0
button.BorderSizePixel = 0
button.Text = "RESET"
button.TextColor3 = Color3.fromRGB(0, 0, 0)
button.TextSize = 11
button.Font = Enum.Font.GothamMedium
button.AutoButtonColor = false
button.Size = UDim2.new(0, 78, 0, 26)
button.Position = UDim2.new(1, -88, 0.5, -13)
button.ZIndex = 7
button.Parent = row
corner(button, 8)
stroke(button, Color3.fromRGB(255, 255, 255), 1, 0.18)
button.Activated:Connect(function()
if _G.ExeResetMobileButtons then
_G.ExeResetMobileButtons()
else
_G.ExeMobileButtonScale = ExeAutoMobile and 0.90 or 1.00
_G.ExeHideMobileButtons = false
if _G.ExeApplyMobileButtonsHidden then _G.ExeApplyMobileButtonsHidden() end
if _G.ExeApplyMobileButtonSize then _G.ExeApplyMobileButtonSize() end
if saveExeConfig then pcall(saveExeConfig) end
end
end)
end

-- INTRO UI REMOVED

section(Settings, "SETTINGS", 999)
local resetHolder = Instance.new("Frame")
resetHolder.Name = "Reset All Settings Holder"
resetHolder.BackgroundTransparency = 1
resetHolder.BorderSizePixel = 0
resetHolder.Size = UDim2.new(1,-4,0,34)
resetHolder.LayoutOrder = 1000
resetHolder.ZIndex = 5
resetHolder.Parent = Settings
local resetBtn = Instance.new("TextButton")
resetBtn.Name = "Reset All Settings"
resetBtn.BackgroundColor3 = COLORS.row
resetBtn.BackgroundTransparency = 0.3
resetBtn.BorderSizePixel = 0
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.TextColor3 = COLORS.white
resetBtn.TextStrokeTransparency = 1
resetBtn.TextSize = 12
resetBtn.Font = Enum.Font.GothamMedium
resetBtn.AutoButtonColor = false
resetBtn.Size = UDim2.new(1,0,1,0)
resetBtn.Position = UDim2.new(0,0,0,0)
resetBtn.ZIndex = 6
resetBtn.Parent = resetHolder
corner(resetBtn,9)
local resetStroke = Instance.new("UIStroke")
resetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
resetStroke.Color = Color3.fromRGB(255, 255, 255)
resetStroke.Thickness = 1
resetStroke.Transparency = 0.12
resetStroke.Parent = resetBtn
local resetDefaultBg = COLORS.row
local resetHoverBg = COLORS.row
local resetConfirmBg = COLORS.row
local resetDoneBg = COLORS.row
local resetDefaultText = COLORS.white
local resetConfirmText = COLORS.white
local resetDoneText = COLORS.white
local confirmState = false
local confirmTimer = nil
function setResetDefaultTheme()
confirmState = false
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.TextColor3 = resetDefaultText
tween(resetBtn, {BackgroundColor3 = resetDefaultBg}, 0.18)
tween(resetStroke, {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.12, Thickness = 1}, 0.18)
end
function setResetConfirmTheme()
resetBtn.Text = "CLICK AGAIN TO CONFIRM"
resetBtn.TextColor3 = resetConfirmText
tween(resetBtn, {BackgroundColor3 = resetConfirmBg}, 0.18)
tween(resetStroke, {Color = resetConfirmText, Transparency = 0.02, Thickness = 1.4}, 0.18)
end
function setResetDoneTheme()
resetBtn.Text = "DONE - REJOINING..."
resetBtn.TextColor3 = resetDoneText
tween(resetBtn, {BackgroundColor3 = resetDoneBg}, 0.18)
tween(resetStroke, {Color = resetDoneText, Transparency = 0.02, Thickness = 1.4}, 0.18)
end
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.MouseEnter:Connect(function()
if not confirmState then
tween(resetBtn, {BackgroundColor3 = resetHoverBg}, 0.12)
end
end)

local saveHolder = Instance.new("Frame")
saveHolder.Name = "Save Config Holder"
saveHolder.BackgroundTransparency = 1
saveHolder.BorderSizePixel = 0
saveHolder.Size = UDim2.new(1,-4,0,34)
saveHolder.LayoutOrder = 1001
saveHolder.ZIndex = 5
saveHolder.Parent = Settings

local saveBtn = Instance.new("TextButton")
saveBtn.Name = "Save Config"
saveBtn.BackgroundColor3 = COLORS.row
saveBtn.BackgroundTransparency = 0.3
saveBtn.BorderSizePixel = 0
saveBtn.Text = "SAVE SETTINGS"
saveBtn.TextColor3 = resetDefaultText
saveBtn.TextStrokeTransparency = 1
saveBtn.TextSize = 12
saveBtn.Font = Enum.Font.GothamMedium
saveBtn.AutoButtonColor = false
saveBtn.Size = UDim2.new(1,0,1,0)
saveBtn.Position = UDim2.new(0,0,0,0)
saveBtn.ZIndex = 6
saveBtn.Parent = saveHolder
corner(saveBtn,9)

local saveStroke = Instance.new("UIStroke")
saveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
saveStroke.Color = Color3.fromRGB(255, 255, 255)
saveStroke.Thickness = 1
saveStroke.Transparency = 0.12
saveStroke.Parent = saveBtn

saveBtn.MouseEnter:Connect(function()
tween(saveBtn, {BackgroundColor3 = COLORS.row}, 0.12)
end)

saveBtn.MouseLeave:Connect(function()
tween(saveBtn, {BackgroundColor3 = COLORS.row}, 0.12)
end)

saveBtn.MouseButton1Click:Connect(function()
if _G.ExeManualSaveConfig then
local ok = pcall(_G.ExeManualSaveConfig)
if ok then
saveBtn.Text = "SAVED"
saveBtn.TextColor3 = resetDoneText
tween(saveBtn, {BackgroundColor3 = resetDoneBg}, 0.18)
tween(saveStroke, {Color = resetDoneText, Transparency = 0.02, Thickness = 1.4}, 0.18)
task.delay(0.8, function()
if saveBtn and saveBtn.Parent then
saveBtn.Text = "SAVE SETTINGS"
saveBtn.TextColor3 = resetDefaultText
tween(saveBtn, {BackgroundColor3 = COLORS.row}, 0.18)
tween(saveStroke, {Color = Color3.fromRGB(255,255,255), Transparency = 0.12, Thickness = 1}, 0.18)
end
end)
else
saveBtn.Text = "SAVE FAILED"
task.delay(0.8, function()
if saveBtn and saveBtn.Parent then
saveBtn.Text = "SAVE SETTINGS"
saveBtn.TextColor3 = resetDefaultText
end
end)
end
end
end)

resetBtn.MouseLeave:Connect(function()
if not confirmState then
tween(resetBtn, {BackgroundColor3 = resetDefaultBg}, 0.12)
end
end)
resetBtn.MouseButton1Click:Connect(function()
if not confirmState then
confirmState = true
setResetConfirmTheme()
if confirmTimer then task.cancel(confirmTimer) end
confirmTimer = task.delay(3, function()
setResetDefaultTheme()
end)
return
end
if confirmTimer then
task.cancel(confirmTimer)
confirmTimer = nil
end
resetBtn.Text = "RESETTING..."
pcall(function()
local files = {
CONFIG_FILE,
KEYBINDS_CONFIG_FILE,
"ExeDuels_MainGUI_Config.json",
"ExeDuelsConfig.json",
"ExeDuels_Settings.json",
"ExeDuels_Keybinds.json",
"ExeDuels_GUI.json",
}
for _, fname in ipairs(files) do
pcall(function()
if fname and isfile and isfile(fname) and delfile then
delfile(fname)
end
end)
end
end)
pcall(function()
if _G.ExeStopBatV2 then pcall(_G.ExeStopBatV2) end
aceGuiScaleValue = ExeAutoMobile and 0.67 or 1.00
aceProgressBarScaleValue = ExeAutoMobile and 0.83 or 1.00
NS = 60; CS = 30; LAGGER_SPEED = 29; LAGGER_CARRY_SPEED = 15
currentSpeedMode = "Normal"
autoCarrySpeedEnabled = false
autoTPHeight = 20
autoStealEnabled = false; selectedStealMode = "Auto Steal V3"; autoStealRadius = 63
_G.ExeStealRadii = {Normal = 62, Semi = 9}
selectedAnimationPack = "OFF"; selectedAimbotMode = "Normal"
AIMBOT_SPEED = 67.2; LAGGER_AIMBOT_SPEED = 40
BAT_V2_SPEED = 58; _G.ExeBatV2Speed = 58
_G.ExeDropAfterMode = "Off"; if _G.ExeRefreshDropAfterLabel then pcall(_G.ExeRefreshDropAfterLabel) end
_G.ExeAntiBypassAimbotSpeed = 65; _G.ExeAntiBypassLaggerAimbotSpeed = 40; ANTI_DESYNC_AIMBOT_SPEED = 58
autoSwingEnabled = false; mirrorTPDownEnabled = false; antiDesyncAutoSwingEnabled = false
_G.ExeNormalAimbotOn = false; _G.ExeAntiBypassAimbotOn = false; _G.ExeAntiDesyncAimbotOn = false
if _G.ExeStopTpBat then pcall(_G.ExeStopTpBat) end
antiRagdollEnabled = false; infJumpEnabled = false; autoTPEnabled = false
batCounterEnabled = false; medCounterEnabled = false; antiKickEnabled = false; autoResetOnMedEnabled = false
espEnabled = false; showTracerEnabled = false; ragdollCountdownEnabled = false
fpsBoostEnabled = false; antiLagVisualEnabled = false; nukeOptimiserEnabled = false
fovEnabled = false; fovValue = 70; noCamCollisionEnabled = false; _G.ExeNoPlayerCollisionEnabled = false
skyTheme = "Off"; currentBackground = 0
autoLeftEnabled = false; autoRightEnabled = false
_G.ExeGuiLocked = false; _G.ExeHideMobileButtons = false; _G.ExeMobileButtonScale = ExeAutoMobile and 0.90 or 1.00; _G.ExeMobileButtonShape = "ROUNDED"
_G.ExeMobileButtonImage = ""
_G.ExeStealUIImage = ""
aceMainScale.Scale = aceGuiScaleValue
applyExeProgressBarScale()
applyBackground(0)
updateBackgroundButtons()
applyDefaultExeKeybinds()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if stopAutoTP then stopAutoTP() end
if stopAntiRagdoll then stopAntiRagdoll() end
if normalSpeedBox then normalSpeedBox.Text = tostring(NS) end
if carrySpeedBox then carrySpeedBox.Text = tostring(CS) end
if laggerSpeedBox then laggerSpeedBox.Text = tostring(LAGGER_SPEED) end
if laggerCarrySpeedBox then laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED) end
if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
if radiusBox then radiusBox.Text = tostring(autoStealRadius) end
if _G.ExeRefreshAimbotSpeedBoxes then _G.ExeRefreshAimbotSpeedBoxes() end
if batV2SpeedBox then batV2SpeedBox.Text = tostring(BAT_V2_SPEED) end
if type(applyCustomSky) == "function" then applyCustomSky("Off") end
if skyValueLabel then skyValueLabel.Text = "Off" end
if _G.ExeResetMobileButtons then _G.ExeResetMobileButtons() end
pcall(function() if _G.ExeApplyMobileButtonImage then _G.ExeApplyMobileButtonImage() end end)
pcall(function() if _G.ExeApplyStealUIImage then _G.ExeApplyStealUIImage() end end)
if _G.ExeDuelsApplySavedGameplayStates then _G.ExeDuelsApplySavedGameplayStates() end
if saveExeConfig then pcall(saveExeConfig) end
end)
task.wait(0.35)
setResetDoneTheme()
task.wait(0.6)
pcall(function()
local TeleportService = game:GetService("TeleportService")
TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
end)
end)
end
task.wait()
_G.__ExeDuelsSetupSettingsUI()
if ExeUpdateGuiLockVisual then ExeUpdateGuiLockVisual() end
if _G.ExeApplyMobileButtonsHidden then _G.ExeApplyMobileButtonsHidden() end

task.defer(function()
task.wait(0.05)
pcall(function()
    local function hideAll(page)
        if not page then return end
        for _,o in ipairs(page:GetChildren()) do
            if not o:IsA("UIListLayout") and not o:IsA("UIPadding") then
                o.Visible = false
            end
        end
    end
    local function showObj(o, order, labelText)
        if not o then return end
        o.Visible = true
        if order then o.LayoutOrder = order end
        if labelText then
            if o:IsA("TextLabel") then o.Text = labelText end
            local lbl = o:FindFirstChild("Label")
            if lbl then lbl.Text = labelText end
        end
    end
    local function byName(page, name)
        return page and page:FindFirstChild(name)
    end
    local function showNamed(page, name, order, labelText)
        showObj(byName(page,name), order, labelText)
    end

    if _G.ExeDropModeMainRow then
        _G.ExeDropModeMainRow.Parent = Movement
        _G.ExeDropModeMainRow.LayoutOrder = 10
    end
    if _G.ExeDropSelector then
        _G.ExeDropSelector.Parent = Movement
        _G.ExeDropSelector.LayoutOrder = 10.1
    end

    if not byName(Movement,"DROP BRAINROT") then section(Movement,"DROP BRAINROT",9) end

    if not byName(Movement,"TP Down") then
        local r,setV = _G.ExeActionToggleRow(Movement,"TP Down",false,12)
        local b = r and r:FindFirstChild("ToggleButton")
        if b then
            b.Activated:Connect(function()
                if runTPFloor then pcall(runTPFloor) end
                if setV then
                    setV(true)
                    task.delay(0.12,function() pcall(setV,false) end)
                end
            end)
        end
    end

    if not byName(Movement,"Unwalk") then
        local r,setV = toggleRow(Movement,"Unwalk",unwalkEnabled,18)
        local b = r and r:FindFirstChild("ToggleButton")
        if b then
            b.Activated:Connect(function()
                unwalkEnabled = not unwalkEnabled
                if unwalkEnabled then
                    if enableUnwalk then pcall(enableUnwalk) end
                else
                    if disableUnwalk then pcall(disableUnwalk) end
                end
                if setV then setV(unwalkEnabled) end
                if saveExeConfig then pcall(saveExeConfig) end
            end)
        end
    end

    hideAll(Movement)
    showNamed(Movement,"AUTO SPEED",0)
    showNamed(Movement,"Auto Carry Speed",0.5)
    showNamed(Movement,"NORMAL SPEED",1,"SPEED CONFIGURATION")
    showNamed(Movement,"Normal Speed",2)
    showNamed(Movement,"Carry Speed",3)

    local modeCount = 0
    for _,o in ipairs(Movement:GetChildren()) do
        if o.Name == "Mode" then
            modeCount = modeCount + 1
            showObj(o, modeCount == 1 and 4 or 8)
        end
    end

    showNamed(Movement,"LAGGER SPEED",5,"LAGGER CONFIGURATION")
    showNamed(Movement,"Lagger Speed",6,"Lagger Normal Speed")
    showNamed(Movement,"Lagger Carry Speed",7)
    showNamed(Movement,"DROP BRAINROT",9)
    showNamed(Movement,"Drop",10)
    if _G.ExeDropSelector then _G.ExeDropSelector.Visible = _G.ExeDropExpanded == true end
    showNamed(Movement,"TELEPORT",11,"TP DOWN")
    showNamed(Movement,"TP Down",12)
    showNamed(Movement,"Auto TP Down",13)
    showNamed(Movement,"Auto TP Height",14)
    showNamed(Movement,"JUMP",15)
    showNamed(Movement,"Infinite Jump",16)
    if _G.ExeInfJumpSelector then _G.ExeInfJumpSelector.LayoutOrder=16.1 end
    showNamed(Movement,"Anti Ragdoll",17)
    if _G.ExeAntiRagdollSelector then
        _G.ExeAntiRagdollSelector.Visible = false
        _G.ExeAntiRagdollSelector.Size = UDim2.new(1,-4,0,0)
    end
    if _G.ExeAntiRagdollArrow then
        _G.ExeAntiRagdollArrow.Visible = false
    end
    showNamed(Movement,"Unwalk",18)

    if not byName(Combat,"SEMI Range") then
        local r,b = textboxRow(Combat,"SEMI Range",tostring((_G.ExeStealRadii and _G.ExeStealRadii.Semi) or 9),3)
        b.FocusLost:Connect(function()
            _G.ExeStealRadii = _G.ExeStealRadii or {}
            local n = tonumber(b.Text)
            if n then _G.ExeStealRadii.Semi = math.clamp(n,1,500) end
            b.Text = tostring(_G.ExeStealRadii.Semi or 9)
            if _G.ExeSemiAutoStealSetRadius then
                pcall(_G.ExeSemiAutoStealSetRadius,_G.ExeStealRadii.Semi or 9)
            end
        end)
    end

    if not byName(Combat,"BAT AIMBOT") then section(Combat,"BAT AIMBOT",5) end
    if aimbotMainRow then
        aimbotMainRow.LayoutOrder = 6
        local l = aimbotMainRow:FindFirstChild("Label")
        if l then l.Text = "Bat Aimbot" end
    end
    if aimbotSpeedRow then
        aimbotSpeedRow.LayoutOrder = 7
        local l = aimbotSpeedRow:FindFirstChild("Label")
        if l then l.Text = "Auto Bat Speed" end
    end
    if _G.ExeNormalAutoSwingRow then _G.ExeNormalAutoSwingRow.LayoutOrder = 8 end
    if _G.ExeMirrorTPDownRow then
        _G.ExeMirrorTPDownRow.LayoutOrder = 9
        local l = _G.ExeMirrorTPDownRow:FindFirstChild("Label")
        if l then l.Text = "Mirror TP" end
    end

    if not byName(Combat,"AUTO PLAY") then section(Combat,"AUTO PLAY",12) end
    if not byName(Combat,"Auto Play") then
        local r,setV,btn = _G.ExeActionToggleRow(Combat,"Auto Play",false,13)
        _G.ExeAutoPlaySetVisual = function(on) if setV then setV(on == true) end end
        if btn then btn.MouseButton1Click:Connect(function()
            if _G.ExeToggleAutoPlay then _G.ExeToggleAutoPlay() end
        end) end
    end

    if not byName(Combat,"BODY LOCK") then section(Combat,"BODY LOCK",19) end

    hideAll(Combat)
    showNamed(Combat,"AUTO STEAL",1,"STEAL CONFIGURATION")
    showNamed(Combat,"Radius",2)
    showNamed(Combat,"SEMI Range",3)
    showNamed(Combat,"Auto Steal",4)
    if _G.ExeStealSelector then _G.ExeStealSelector.LayoutOrder=4.1 end

    showNamed(Combat,"BAT AIMBOT",5)
    showObj(aimbotMainRow,6)
    if aimbotSelector then aimbotSelector.LayoutOrder=6.1 end
    showObj(aimbotSpeedRow,7)
    showObj(laggerAimbotSpeedRow,7.5)
    showObj(_G.ExeNormalAutoSwingRow,8)
    showObj(_G.ExeMirrorTPDownRow,9)
    showObj(batV2SpeedRow,9.5)
    showNamed(Combat,"Anti Bat Bypass",10.7)
    showNamed(Combat,"TP BAT",11)
    showNamed(Combat,"TP Bat",11.1)
    showNamed(Combat,"TP Bat Version",11.2)

    showNamed(Combat,"AUTO PLAY",12)
    showNamed(Combat,"Auto Play",13)
    showNamed(Combat,"COUNTERS",15)
    showNamed(Combat,"Bat Counter",16)
    showNamed(Combat,"Med Counter",17,"Medusa Counter")
        showNamed(Combat,"BODY LOCK",19)
    showNamed(Combat,"Body Lock",20)
    if _G.ExeBodyLockSettings then
        _G.ExeBodyLockSettings.LayoutOrder=21
        local l=_G.ExeBodyLockSettings:FindFirstChild("Label")
        if l then l.Text="Lock Radius" end
    end

    showNamed(Combat,"HARD HIT",22)
    showNamed(Combat,"Hard Hit",23)
    showNamed(Combat,"Hard Hit Range",24)
    showNamed(Combat,"Hard Hit Stage+",25)
    showNamed(Combat,"Stage+ Impulse",26)

    showNamed(Combat,"PERFECT HIT",27)
    showNamed(Combat,"Perfect Hit",28)
    showNamed(Combat,"Perfect Hit Range",29)

    -- Anti toggles + No Player Collision stay hidden (always ON in background)
    showNamed(Combat,"ANTI TOGGLES",29.5,"DROP AFTER")
    showObj(_G.ExeDropAfterRow,29.6)
    hideAll(Keybinds)
    showNamed(Keybinds,"MOVEMENT KEYBINDS",1)
    showNamed(Keybinds,"Speed Key",2)
    showNamed(Keybinds,"Lagger Mode Key",3)
    showNamed(Keybinds,"Drop Brainrot",4,"Drop Key")
    showNamed(Keybinds,"TP Down",5,"TP Down Key")
    showNamed(Keybinds,"COMBAT KEYBINDS",6)
    showNamed(Keybinds,"Normal Aimbot",7,"Bat Aimbot Key")
    showNamed(Keybinds,"Lagger Carry",3.5,"Lagger Carry Key")
    showNamed(Keybinds,"Bat V2",7.1,"Bat V2 Key")
    showNamed(Keybinds,"Anti Bat Bypass",7.2,"Anti Bat Bypass Key")
    showNamed(Keybinds,"TP Bat",7.3,"TP Bat Key")
    showNamed(Keybinds,"Insta Medusa",7.4,"Insta Medusa Key")
    showNamed(Keybinds,"Insta Reset",7.5,"Insta Reset Key")
    showNamed(Keybinds,"Auto Play",7.6,"Auto Play Key")
    
    if not byName(Keybinds,"INTERFACE KEYBINDS") then section(Keybinds,"INTERFACE KEYBINDS",12) end
    showNamed(Keybinds,"INTERFACE KEYBINDS",12)

    local uiToggleRow = byName(Settings,"Toggle UI")
    if uiToggleRow then
        uiToggleRow.Parent = Keybinds
        uiToggleRow.LayoutOrder = 13
        uiToggleRow.Visible = true
        local l=uiToggleRow:FindFirstChild("Label")
        if l then l.Text="UI Toggle Key" end
    end

    -- ColorThemePicker removed
    local barSize = byName(MenuCustomize,"Progress Bar Size") or byName(Settings,"Progress Bar Size")
    if barSize then
        barSize.Parent = Settings
        barSize.LayoutOrder = 18
        barSize.Visible = true
    end

    hideAll(MenuCustomize)

    local controllerBindButtons = {}
    local function ctrlBind(label, order)
        local r=baseRow(MenuCustomize,label,order)

        local b=Instance.new("TextButton")
        b.Name="ControllerKeybindButton"
        b.BackgroundColor3=Color3.fromRGB(8, 8, 8)
        b.BackgroundTransparency=0.18
        b.BorderSizePixel=0
        b.Text="NONE"
        b.TextColor3=COLORS.white
        b.TextSize=12
        b.Font=Enum.Font.GothamMedium
        b.AutoButtonColor=false
        b.Size=UDim2.new(0,56,0,22)
        b.Position=UDim2.new(1,-64,0.5,-11)
        b.ZIndex=8
        b.Parent=r
        corner(b,7)
        stroke(b,COLORS.strokeSoft,1,0.45)

        local clear=Instance.new("TextButton")
        clear.Name="ClearControllerKeybindButton"
        clear.BackgroundColor3=Color3.fromRGB(8, 8, 8)
        clear.BackgroundTransparency=0.08
        clear.BorderSizePixel=0
        clear.Text=""
        clear.AutoButtonColor=false
        clear.Size=UDim2.new(0,18,0,18)
        clear.Position=UDim2.new(1,-86,0.5,-9)
        clear.ZIndex=9
        clear.Parent=r
        corner(clear,999)
        stroke(clear,COLORS.strokeSoft,1,0.45)

        clear.MouseButton1Click:Connect(function()
            b.Text="NONE"
        end)

        table.insert(controllerBindButtons,b)
        return r,b
    end

    local resetCtrl=baseRow(MenuCustomize,"RESET ALL CONTROLLER",1)
    resetCtrl:FindFirstChild("Label").Text="RESET ALL CONTROLLER"
    local resetCtrlClick=Instance.new("TextButton")
    resetCtrlClick.Size=UDim2.new(1,0,1,0)
    resetCtrlClick.BackgroundTransparency=1
    resetCtrlClick.Text=""
    resetCtrlClick.ZIndex=20
    resetCtrlClick.Parent=resetCtrl
    resetCtrlClick.MouseButton1Click:Connect(function()
        for _,b in ipairs(controllerBindButtons) do b.Text="NONE" end
    end)

    section(MenuCustomize,"MOVEMENT CONTROLLER",2)
    ctrlBind("Speed Key",3); ctrlBind("Lagger Mode Key",4); ctrlBind("Drop Key",5); ctrlBind("TP Down Key",6)
    section(MenuCustomize,"COMBAT CONTROLLER",7)
    ctrlBind("Bat Aimbot Key",8)
    section(MenuCustomize,"INTERFACE CONTROLLER",13)
    ctrlBind("UI Toggle Key",14)

    if not byName(Utility,"Animation Pack") then
        animationPackRow(Utility,7)
    end

    if not byName(Utility,"Show Tracer") then
        local r,setV=toggleRow(Utility,"Show Tracer",showTracerEnabled,3)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            showTracerEnabled=not showTracerEnabled
            if BoxedESPOptions then BoxedESPOptions.tracer=showTracerEnabled end
            if refreshBoxedESP then pcall(refreshBoxedESP) end
            if setV then setV(showTracerEnabled) end
        end) end
        setTracerESPVisual=setV
    end

    if not byName(Utility,"Ragdoll Countdown") then
        local r,setV=toggleRow(Utility,"Ragdoll Countdown",ragdollCountdownEnabled,4)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            ragdollCountdownEnabled=not ragdollCountdownEnabled
            if ragdollCountdownEnabled then pcall(hookRagdollCountdown,LP.Character) else pcall(stopRagdollCountdown) end
            if setV then setV(ragdollCountdownEnabled) end
        end) end
        setRagdollCountdownVisual=setV
    end

    if not byName(Utility,"Try Hard Animation") then
        local r,setV=toggleRow(Utility,"Try Hard Animation",hitHarderAnimEnabled,8)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            hitHarderAnimEnabled=not hitHarderAnimEnabled
            if hitHarderAnimEnabled then pcall(enableHitHarderAnim) else pcall(disableHitHarderAnim) end
            if setV then setV(hitHarderAnimEnabled) end
        end) end
    end

    hideAll(Utility)
    showNamed(Utility,"ESP",1,"PLAYERS")

    for _,o in ipairs(Utility:GetChildren()) do
        if o.Name=="ESP" then o.Visible=true end
    end
    showNamed(Utility,"Show Tracer",3)
    showNamed(Utility,"Ragdoll Countdown",4)
    if not byName(Utility,"VISUAL") then section(Utility,"VISUAL",5) end
    showNamed(Utility,"VISUAL",5)
    showNamed(Utility,"Sky Theme",6,"Custom Sky")
    showNamed(Utility,"Animation Pack",7,"Anim Pack")
    showNamed(Utility,"Try Hard Animation",8)
    showNamed(Utility,"PERFORMANCE",9)
    showNamed(Utility,"Stretch Rez",10,"Stretch Res")
    showNamed(Utility,"Anti Lag",11,"Anti-Lag")
    showNamed(Utility,"FOV",12,"FOV Change")
    showNamed(Utility,"FOV Value",13)

    if not byName(Settings,"Circle Buttons") then
        local r,setV=_G.ExeActionToggleRow(Settings,"Circle Buttons",_G.ExeMobileButtonShape=="CIRCLE",2)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            _G.ExeMobileButtonShape=(_G.ExeMobileButtonShape=="CIRCLE") and "ROUNDED" or "CIRCLE"
            if _G.ExeApplyMobileButtonShape then _G.ExeApplyMobileButtonShape() end
            if setV then setV(_G.ExeMobileButtonShape=="CIRCLE") end
        end) end
    end

    if not byName(Settings,"Move Buttons") then
        local r,setV=_G.ExeActionToggleRow(Settings,"Move Buttons",_G.ExeGuiLocked~=true,5)
        local b=r and r:FindFirstChild("ToggleButton")
        if b then b.Activated:Connect(function()
            _G.ExeGuiLocked=not (_G.ExeGuiLocked==true)
            if setV then setV(_G.ExeGuiLocked~=true) end
            if ExeUpdateGuiLockVisual then ExeUpdateGuiLockVisual() end
            if saveExeConfig then pcall(saveExeConfig) end
        end) end
    end

    if not byName(Settings,"Background Color") then
        toggleRow(Settings,"Background Color",false,15)
    end

    hideAll(Settings)
    showNamed(Settings,"MOBILE BUTTONS",1)
    showNamed(Settings,"Circle Buttons",2)
    showNamed(Settings,"Hide Mobile Buttons",3,"Hide Mob Buttons")
    showNamed(Settings,"HIDE EACH BUTTON",3.5)
    for i, item in ipairs(_G.ExeMobileButtonList or {}) do
        showNamed(Settings,"Hide " .. item[2],3.5 + i * 0.01)
    end
    showNamed(Settings,"Mobile Buttons Size",4,"Button Size %")
    showNamed(Settings,"Mobile Button Color",4.5)
    showNamed(Settings,"Move Buttons",5)
    showNamed(Settings,"Reset Mobile Buttons",6,"Reset Buttons")

    if not byName(Settings,"INTERFACE") then section(Settings,"INTERFACE",7) end
    showNamed(Settings,"INTERFACE",7)

    if colorPicker then showObj(colorPicker,14) end
    showNamed(Settings,"Background Color",15)

    if not byName(Settings,"UI SCALE") then section(Settings,"UI SCALE",16) end
    showNamed(Settings,"UI SCALE",16)
    showNamed(Settings,"GUI Scale",17,"UI Scale")
    showNamed(Settings,"Progress Bar Size",18,"Steal Bar Size")
    if barSize then
        barSize.Parent = Settings
        barSize.LayoutOrder = 18
        barSize.Visible = true
        local lbl = barSize:FindFirstChild("Label")
        if lbl then lbl.Text = "Steal Bar Size" end
    end
    showNamed(Settings,"Save Config Holder",19)
    showNamed(Settings,"Reset All Settings Holder",20)
end)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
local isControllerInput = tostring(input.UserInputType):find("Gamepad") ~= nil
if gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and not listeningForSpeedKey and not listeningForTPDownKey then return end
if UserInputService:GetFocusedTextBox() then return end
if input.UserInputType ~= Enum.UserInputType.Keyboard and not isControllerInput then return end
if input.KeyCode == Enum.KeyCode.Unknown then return end
if speedKeybinds.ToggleUI and input.KeyCode == speedKeybinds.ToggleUI then
if Main.Visible then
if _G.ExeCloseMainUI then _G.ExeCloseMainUI() else
Main.Visible = false
MiniFrame.Visible = true
_G.__ExeDuelsMinimized = true
end
else
if _G.ExeOpenMainUI then _G.ExeOpenMainUI() else
Main.Visible = true
MiniFrame.Visible = false
Main.Size = FULL_MAIN_SIZE
_G.__ExeDuelsMinimized = false
end
end
if saveExeConfig then pcall(saveExeConfig) end
return
end
if listeningForSpeedKey then
if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
local targetKey = listeningForSpeedKey
if input.KeyCode == Enum.KeyCode.Escape then
listeningForSpeedKey = nil
refreshAllSpeedKeybinds()
return
end
if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
speedKeybinds[targetKey] = nil
else
for otherKeyId, boundKey in pairs(speedKeybinds) do
if otherKeyId ~= targetKey and boundKey == input.KeyCode then
speedKeybinds[otherKeyId] = nil
end
end
if tpDownKeybind == input.KeyCode then
tpDownKeybind = nil
refreshTPDownKeybind()
end
speedKeybinds[targetKey] = input.KeyCode
end
listeningForSpeedKey = nil
refreshAllSpeedKeybinds()
if saveExeConfig then pcall(saveExeConfig) end
return
end
if listeningForTPDownKey then
if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
if input.KeyCode == Enum.KeyCode.Escape then
listeningForTPDownKey = false
refreshTPDownKeybind()
return
end
if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
tpDownKeybind = nil
else
for keyId, boundKey in pairs(speedKeybinds) do
if boundKey == input.KeyCode then
speedKeybinds[keyId] = nil
end
end
tpDownKeybind = input.KeyCode
end
listeningForTPDownKey = false
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if saveExeConfig then pcall(saveExeConfig) end
return
end
if speedKeybinds.SpeedToggle and input.KeyCode == speedKeybinds.SpeedToggle then
toggleCarryMode()
return
end
if speedKeybinds.LaggerToggle and input.KeyCode == speedKeybinds.LaggerToggle then
toggleLaggerMode()
return
end
if speedKeybinds.Aimbot and input.KeyCode == speedKeybinds.Aimbot then
if _G.ExeSafeModeIsLocked and _G.ExeSafeModeIsLocked() then
if _G.ExeSafeModeForceStop then _G.ExeSafeModeForceStop("SAFE MODE LOCK") end
return
end
if _G.ExeToggleSelectedAimbot then
_G.ExeToggleSelectedAimbot()
elseif selectedAimbotMode == "Anti Bypass" and _G.ExeStartAntiBypassAimbot and _G.ExeStopAntiBypassAimbot then
if _G.ExeAntiBypassAimbotOn then _G.ExeStopAntiBypassAimbot() else _G.ExeStartAntiBypassAimbot() end
elseif _G.ExeStartNormalAimbot and _G.ExeStopNormalAimbot then
if _G.ExeNormalAimbotOn then _G.ExeStopNormalAimbot() else _G.ExeStartNormalAimbot() end
end
if _G.ExeRefreshAimbotVisual then _G.ExeRefreshAimbotVisual() end
return
end
if speedKeybinds.DropBrainrot and input.KeyCode == speedKeybinds.DropBrainrot then
runDropBrainrot()
return
end
if speedKeybinds.AutoLeft and input.KeyCode == speedKeybinds.AutoLeft then
if _G.ExeSetAutoLeft then _G.ExeSetAutoLeft(not autoLeftEnabled) end
return
end
if speedKeybinds.AutoRight and input.KeyCode == speedKeybinds.AutoRight then
if _G.ExeSetAutoRight then _G.ExeSetAutoRight(not autoRightEnabled) end
return
end
if speedKeybinds.InstaReset and speedKeybinds.InstaReset ~= Enum.KeyCode.Unknown
    and input.KeyCode == speedKeybinds.InstaReset then
if _G.ExeInstaResetRun then _G.ExeInstaResetRun() end
return
end
for kbId, btnKey in pairs(_G.ExeMBKeybindMap or {}) do
local kb = speedKeybinds[kbId]
if kb and kb ~= Enum.KeyCode.Unknown and input.KeyCode == kb then
if _G.ExeFireMobileButton then _G.ExeFireMobileButton(btnKey) end
return
end
end
if tpDownKeybind and input.KeyCode == tpDownKeybind then
runTPFloor()
return
end
end)
task.defer(function()
task.wait(0.15)
pcall(function()
for _, pageName in ipairs({"MOVEMENT","COMBAT"}) do
local page = pages[pageName]
if page then
for _, holder in ipairs(page:GetDescendants()) do
if holder:IsA("Frame") and holder:FindFirstChild("SelectedSlide") then
holder.Size = UDim2.new(1,-4,0,34)
holder.BackgroundColor3 = Color3.fromRGB(0,0,0)
holder.BackgroundTransparency = 0.3

local slide = holder:FindFirstChild("SelectedSlide")
if slide then
slide.Size = UDim2.new(0.5,-4,1,-8)
slide.BackgroundColor3 = Color3.fromRGB(255,255,255)
slide.BackgroundTransparency = 0.85
local s = slide:FindFirstChildOfClass("UIStroke")
if s then
s.Color = Color3.fromRGB(255,255,255)
s.Thickness = 1
s.Transparency = 0.2
end
end

for _, child in ipairs(holder:GetChildren()) do
if child:IsA("TextLabel") or child:IsA("TextButton") then
child.Font = Enum.Font.GothamMedium
child.TextSize = 12
end
end
end
end

for _, obj in ipairs(page:GetDescendants()) do
if obj:IsA("TextButton") and obj.Name == "ArrowButton" then
obj.Position = UDim2.new(1,-108,0.5,-13)
obj.Size = UDim2.new(0,38,0,26)
obj.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
obj.BackgroundTransparency = 0.18
obj.Text = "v"
obj.TextColor3 = Color3.fromRGB(255,255,255)
obj.TextSize = 22
obj.Font = Enum.Font.GothamBlack
local c = obj:FindFirstChildOfClass("UICorner")
if c then c.CornerRadius = UDim.new(0,7) end
end
end
end
end
end)
end)

setTab("MOVEMENT")
_G.__ExeDuelsSetupStealBar = function()
local RunService = game:GetService("RunService")
local UIS = UserInputService
local TS = TweenService
local Stats = game:GetService("Stats")
local existingStealBar = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("StealBarGui")
if existingStealBar then existingStealBar:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "StealBarGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeParentGui(gui)

local function drag(frame)
    local dragging, dragStart, startPos = false, nil, nil
    frame.InputBegan:Connect(function(input)
        if _G.ExeGuiLocked == true then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    _G.ExeStealBarPosition = udim2ToTable(frame.Position)
                    if saveExeConfig then pcall(saveExeConfig) end
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Pink Static Duels progress card; progress/state functions remain unchanged.
local pbFrame = Instance.new("Frame", gui)
pbFrame.Name = "StealBar"
pbFrame.Size = UDim2.new(0, 420, 0, 72)
local defaultStealPos = UDim2.new(0.5, -210, 1, -90)
pbFrame.Position = tableToUDim2(_G.ExeStealBarPosition, defaultStealPos)
pbFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
pbFrame.BackgroundTransparency = 0.02
pbFrame.BorderSizePixel = 0
pbFrame.Active = true
pbFrame.ClipsDescendants = true
Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 18)

local pbSt = Instance.new("UIStroke", pbFrame)
pbSt.Color = Color3.fromRGB(235, 235, 235)
pbSt.Thickness = 2.2
pbSt.Transparency = 0.02

local pbGrad = Instance.new("UIGradient", pbFrame)
pbGrad.Rotation = 90
pbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 245, 245)),
})

drag(pbFrame)

local pbScale = Instance.new("UIScale")
pbScale.Name = "ExeProgressBarScale"
pbScale.Scale = tonumber(_G.ExeProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or 1
pbScale.Parent = pbFrame

-- Avatar (left)
local stealAvatar = Instance.new("ImageLabel", pbFrame)
stealAvatar.Name = "StealAvatar"
stealAvatar.Size = UDim2.new(0, 40, 0, 40)
stealAvatar.Position = UDim2.new(0, 14, 0, 8)
stealAvatar.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
stealAvatar.BorderSizePixel = 0
stealAvatar.ScaleType = Enum.ScaleType.Crop
stealAvatar.ZIndex = 5
stealAvatar.Visible = false
Instance.new("UICorner", stealAvatar).CornerRadius = UDim.new(1, 0)
local avStroke = Instance.new("UIStroke", stealAvatar)
avStroke.Color = Color3.fromRGB(210, 210, 215)
avStroke.Thickness = 1.5
avStroke.Transparency = 0.2
task.spawn(function()
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and url and stealAvatar.Parent then
        stealAvatar.Image = url
    end
end)

-- Date / time (top near %)
local timeLbl = Instance.new("TextLabel", pbFrame)
timeLbl.Name = "TimeLabel"
timeLbl.BackgroundTransparency = 1
timeLbl.Size = UDim2.new(0, 160, 0, 12)
timeLbl.Position = UDim2.new(0, 68, 0, 8)
timeLbl.Font = Enum.Font.GothamMedium
timeLbl.TextSize = 10
timeLbl.TextColor3 = Color3.fromRGB(75, 75, 80)
timeLbl.TextXAlignment = Enum.TextXAlignment.Left
timeLbl.ZIndex = 5
timeLbl.Text = ""
timeLbl.Visible = false

-- Big percent
local progressPct = Instance.new("TextLabel", pbFrame)
progressPct.Name = "Percent"
progressPct.BackgroundTransparency = 1
progressPct.Size = UDim2.new(0, 72, 0, 26)
progressPct.Position = UDim2.new(0, 18, 0, 10)
progressPct.Font = Enum.Font.GothamBlack
progressPct.TextSize = 20
progressPct.TextColor3 = Color3.fromRGB(20, 20, 20)
progressPct.TextXAlignment = Enum.TextXAlignment.Left
progressPct.ZIndex = 5
progressPct.Text = "0%"

-- FPS
local fpsLbl = Instance.new("TextLabel", pbFrame)
fpsLbl.Name = "FPS"
fpsLbl.BackgroundTransparency = 1
fpsLbl.Size = UDim2.new(0, 82, 0, 16)
fpsLbl.Position = UDim2.new(1, -190, 0, 18)
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextSize = 11
fpsLbl.TextColor3 = Color3.fromRGB(75, 75, 80)
fpsLbl.TextXAlignment = Enum.TextXAlignment.Left
fpsLbl.ZIndex = 5
fpsLbl.Text = "FPS: --"

-- Mode name (center)
local modeLbl = Instance.new("TextLabel", pbFrame)
modeLbl.Name = "Mode"
modeLbl.BackgroundTransparency = 1
modeLbl.Size = UDim2.new(0, 112, 0, 18)
modeLbl.Position = UDim2.new(0.5, -56, 0, 16)
modeLbl.Font = Enum.Font.GothamBold
modeLbl.TextSize = 10
modeLbl.TextScaled = true
modeLbl.TextWrapped = false
modeLbl.TextColor3 = Color3.fromRGB(25, 25, 25)
modeLbl.TextXAlignment = Enum.TextXAlignment.Center
modeLbl.ZIndex = 5
modeLbl.Text = "AUTO GRAB"

-- Ping (right)
local pingLbl = Instance.new("TextLabel", pbFrame)
pingLbl.Name = "Ping"
pingLbl.BackgroundTransparency = 1
pingLbl.Size = UDim2.new(0, 92, 0, 16)
pingLbl.Position = UDim2.new(1, -104, 0, 18)
pingLbl.Font = Enum.Font.GothamBold
pingLbl.TextSize = 11
pingLbl.TextColor3 = Color3.fromRGB(75, 75, 80)
pingLbl.TextXAlignment = Enum.TextXAlignment.Right
pingLbl.ZIndex = 5
pingLbl.Text = "PING: --ms"

-- STEAL BAR label under headshot
local stealBarTag = Instance.new("TextLabel", pbFrame)
stealBarTag.Name = "StealBarTag"
stealBarTag.BackgroundTransparency = 1
stealBarTag.Size = UDim2.new(0, 56, 0, 12)
stealBarTag.Position = UDim2.new(0, 6, 0, 50)
stealBarTag.Font = Enum.Font.GothamBold
stealBarTag.TextSize = 8
stealBarTag.TextColor3 = Color3.fromRGB(80, 80, 85)
stealBarTag.TextXAlignment = Enum.TextXAlignment.Center
stealBarTag.ZIndex = 5
stealBarTag.Text = "STEAL BAR"
stealBarTag.Visible = false

-- Progress track
local pbg = Instance.new("Frame", pbFrame)
pbg.Name = "Track"
pbg.Size = UDim2.new(1, -36, 0, 9)
pbg.Position = UDim2.new(0, 18, 1, -20)
pbg.BackgroundColor3 = Color3.fromRGB(24, 13, 32)
pbg.BorderSizePixel = 0
pbg.ClipsDescendants = true
pbg.ZIndex = 4
Instance.new("UICorner", pbg).CornerRadius = UDim.new(1, 0)
local pbgStroke = Instance.new("UIStroke", pbg)
pbgStroke.Color = Color3.fromRGB(225, 225, 225)
pbgStroke.Transparency = 0.08
pbgStroke.Thickness = 1

local progressFill = Instance.new("Frame", pbg)
progressFill.Name = "Fill"
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progressFill.BackgroundTransparency = 0.02
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 5
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
local fillGrad = Instance.new("UIGradient", progressFill)
fillGrad.Rotation = 0
fillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(245, 245, 245)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 225, 225)),
})

function _G.ExeApplyStealUIImage() end

local barState = "IDLE"
local function setBarState(state)
    barState = state
    if state == "STEALING" then
        TS:Create(pbSt, TweenInfo.new(0.2), {Color = Color3.fromRGB(235, 235, 235), Transparency = 0.02, Thickness = 2.2}):Play()
        TS:Create(progressPct, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        TS:Create(modeLbl, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    elseif state == "READY" then
        TS:Create(pbSt, TweenInfo.new(0.2), {Color = Color3.fromRGB(225, 225, 225), Transparency = 0.05, Thickness = 2.0}):Play()
        TS:Create(progressPct, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        TS:Create(modeLbl, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    else
        TS:Create(pbSt, TweenInfo.new(0.2), {Color = Color3.fromRGB(210, 210, 210), Transparency = 0.12, Thickness = 1.8}):Play()
        TS:Create(progressPct, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        TS:Create(modeLbl, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    end
end

-- Live FPS / ping / time / mode
task.spawn(function()
    local lastFrame = tick()
    local fpsSamples = {}
    local fpsAvg = 60
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - lastFrame
        lastFrame = now
        if dt > 0 then
            table.insert(fpsSamples, 1 / dt)
            if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
            local sum = 0
            for _, v in ipairs(fpsSamples) do sum = sum + v end
            fpsAvg = sum / math.max(1, #fpsSamples)
        end
    end)
    while pbFrame and pbFrame.Parent do
        local ping = 0
        pcall(function()
            local stat = Stats.Network.ServerStatsItem["Data Ping"]
            if stat then ping = tonumber(stat:GetValue()) or 0 end
        end)
        fpsLbl.Text = string.format("FPS: %d", math.floor(fpsAvg + 0.5))
        pingLbl.Text = string.format("PING: %dms", math.floor(ping + 0.5))
        local stealModeName = tostring(selectedStealMode or "Auto Steal V3")
        modeLbl.Text = (stealModeName == "Semi") and "SEMI" or "AUTO V3"
        pcall(function()
            timeLbl.Text = os.date("%a %b %d  %I:%M:%S %p")
        end)
        task.wait(0.35)
    end
end)

local StealBar = {}
function StealBar.SetProgress(p)
    p = math.clamp(p, 0, 1)
    progressFill.Size = UDim2.new(p, 0, 1, 0)
    progressPct.Text = math.floor(p * 100 + 0.5) .. "%"
    if barState == "STEALING" then
        progressFill.BackgroundTransparency = 0.05
        pbSt.Transparency = math.max(0.02, 0.2 - (p * 0.15))
    end
end
function StealBar.Reset()
    StealBar.SetProgress(0)
    setBarState("IDLE")
end
function StealBar.SetState(state)
    setBarState(state)
end
setBarState("IDLE")
_G.StealBar = StealBar
end
_G.__ExeDuelsSetupStealBar()
pcall(function()
    if applyExeProgressBarScale then applyExeProgressBarScale() end
    if _G.ExeApplyProgressBarScale then _G.ExeApplyProgressBarScale() end
end)
if _G.ExeAutoStealSync then task.defer(_G.ExeAutoStealSync) end
_G.__ExeDuelsSetupMinimizeToggle = function()
_G.__ExeDuelsMinimized = false
Close.MouseButton1Click:Connect(function()
if _G.ExeCloseMainUI then
_G.ExeCloseMainUI()
else
_G.__ExeDuelsMinimized = true
Main.Visible = false
MiniFrame.Visible = true
end
if saveExeConfig then pcall(saveExeConfig) end
end)
end
_G.__ExeDuelsSetupMinimizeToggle()

-- Static Hub simple white theme: white surfaces, bold black text, grey buttons.
pcall(function()
    Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    for _, obj in ipairs(Main:GetDescendants()) do
        if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
            if obj.BackgroundTransparency < 1 and not obj.Name:find("BlackLightning") then
                obj.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
            local outline = obj:FindFirstChildOfClass("UIStroke")
            if outline then outline.Color = Color3.fromRGB(150, 150, 150) end
        elseif obj:IsA("TextLabel") then
            obj.TextColor3 = Color3.fromRGB(0, 0, 0)
            obj.Font = (obj.Name == "Title") and Enum.Font.GothamBlack or Enum.Font.GothamBold
        elseif obj:IsA("TextButton") then
            obj.TextColor3 = Color3.fromRGB(0, 0, 0)
            obj.Font = Enum.Font.GothamBold
            obj.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
        elseif obj:IsA("TextBox") then
            obj.TextColor3 = Color3.fromRGB(0, 0, 0)
            obj.Font = Enum.Font.GothamBold
            obj.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        end
    end
end)

-- Static Hub intro removed by request; main GUI opens normally.

_G.ExeDuelsForceSyncLoadedButtons = function()
pcall(function()
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled) end
if autoTPEnabled then startAutoTP() else stopAutoTP() end
end)
pcall(function()
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled) end
if setInfJumpInternal then setInfJumpInternal(infJumpEnabled) end
end)
pcall(function()
if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled) end
setAntiRagdoll(antiRagdollEnabled)
end)
pcall(function()
if _G.ExeSetAutoLeft then _G.ExeSetAutoLeft(autoLeftEnabled, true) end
if _G.ExeSetAutoRight then _G.ExeSetAutoRight(autoRightEnabled, true) end
end)
pcall(function()
if setAutoStealVisual then setAutoStealVisual(autoStealEnabled) end
if _G.ExeAutoStealSync then _G.ExeAutoStealSync() end
end)
pcall(function()
if _G.ExeNormalAutoSwingSetVisual then _G.ExeNormalAutoSwingSetVisual(autoSwingEnabled) end
if _G.ExeMirrorTPDownSetVisual then _G.ExeMirrorTPDownSetVisual(mirrorTPDownEnabled) end
if _G.ExeStopAntiDesyncAimbot then
pcall(_G.ExeStopAntiDesyncAimbot)
end
_G.ExeAntiDesyncAimbotOn = false
end)
pcall(function()
if selectedAimbotMode == "Anti Bypass" then
if _G.ExeNormalAimbotStop then _G.ExeNormalAimbotStop() end
if _G.ExeAntiBypassAimbotOn and _G.ExeAntiBypassStart then
_G.ExeAntiBypassStart()
elseif _G.ExeAntiBypassStop then
_G.ExeAntiBypassStop()
end
else
if _G.ExeAntiBypassStop then _G.ExeAntiBypassStop() end
if _G.ExeNormalAimbotOn and _G.ExeNormalAimbotStart then
_G.ExeNormalAimbotStart()
elseif _G.ExeNormalAimbotStop then
_G.ExeNormalAimbotStop()
end
end
if _G.ExeRefreshAimbotVisual then _G.ExeRefreshAimbotVisual() end
end)
pcall(function()
if setBatCounterVisual then setBatCounterVisual(batCounterEnabled) end
if setMedCounterVisual then setMedCounterVisual(medCounterEnabled) end
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled) end
if batCounterEnabled then
if _G.ExeStartBatCounter then _G.ExeStartBatCounter() end
else
if _G.ExeStopBatCounter then _G.ExeStopBatCounter() end
end
if medCounterEnabled then
if _G.ExeStartMedCounter then _G.ExeStartMedCounter(LP.Character) end
else
if _G.ExeStopMedCounter then _G.ExeStopMedCounter() end
end
if _G.ExeSetNoPlayerCollisionVisual then _G.ExeSetNoPlayerCollisionVisual(_G.ExeNoPlayerCollisionEnabled) end
if _G.ExeNoPlayerCollisionEnabled then
if enableNoPlayerCollision then enableNoPlayerCollision() end
else
if disableNoPlayerCollision then disableNoPlayerCollision() end
end
if _G.ExeSetAutoResetOnMed then
_G.ExeSetAutoResetOnMed(autoResetOnMedEnabled, true)
else
if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
end
end)
pcall(function()
if setPlayerESPVisual then setPlayerESPVisual(espEnabled) end
if espEnabled then if startPlayerESP then startPlayerESP() end; if BoxedESPOptions then BoxedESPOptions.box = false end else if stopPlayerESP then stopPlayerESP() end; if BoxedESPOptions then BoxedESPOptions.box = false end end
if setTracerESPVisual then setTracerESPVisual(showTracerEnabled) end
if BoxedESPOptions then BoxedESPOptions.tracer = false end
if refreshBoxedESP then refreshBoxedESP() end
if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled) end
if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) else stopRagdollCountdown() end
if setFPSBoostVisual then setFPSBoostVisual(fpsBoostEnabled) end
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
if setAntiLagVisual then setAntiLagVisual(antiLagVisualEnabled) end
if antiLagVisualEnabled then enableAntiLag() else disableAntiLag() end
if setNukeOptimiserVisual then setNukeOptimiserVisual(nukeOptimiserEnabled) end
if nukeOptimiserEnabled then enableNukeOptimizer() else disableNukeOptimizer() end
if setFOVVisual then setFOVVisual(fovEnabled) end
if fovEnabled then enableCustomFov() else disableCustomFov() end
if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled) end
if noCamCollisionEnabled then enableNoCamCollision() else disableNoCamCollision() end
if type(applyCustomSky) == "function" then
applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off")
end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
if saveExeConfig then pcall(saveExeConfig) end
end
task.defer(function()
task.wait(0.35)
if type(applyCustomSky) == "function" then
pcall(function() applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off") end)
end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
task.defer(_G.ExeDuelsForceSyncLoadedButtons)
task.delay(1, function()
if _G.ExeDuelsForceSyncLoadedButtons then _G.ExeDuelsForceSyncLoadedButtons() end
end)
task.defer(function()
task.wait(0.2)
if _G.ExeSyncToggleVisuals then _G.ExeSyncToggleVisuals() end
end)
_G.ExeDuelsApplySavedGameplayStates = function()
pcall(function()
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end
if autoTPEnabled then startAutoTP() else stopAutoTP() end
end)
pcall(function()
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
if setInfJumpInternal then setInfJumpInternal(infJumpEnabled == true) end
end)
pcall(function()
if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end
if setAntiRagdoll then setAntiRagdoll(antiRagdollEnabled == true) end
end)
pcall(function()
if _G.ExeAntiVoidVisual then _G.ExeAntiVoidVisual(_G.ExeAntiVoidEnabled == true) end
_G.ExeAntiVoidSet(_G.ExeAntiVoidEnabled == true)
end)
pcall(function()
if _G.ExeAntiResetVisual then _G.ExeAntiResetVisual(_G.ExeAntiResetEnabled == true) end
_G.ExeSetAntiReset(_G.ExeAntiResetEnabled == true)
end)
pcall(function()
if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end
if _G.ExeAutoStealSync then _G.ExeAutoStealSync() end
end)
pcall(function()
if setBatCounterVisual then setBatCounterVisual(batCounterEnabled == true) end
if batCounterEnabled and _G.ExeStartBatCounter then _G.ExeStartBatCounter() elseif _G.ExeStopBatCounter then _G.ExeStopBatCounter() end
end)
pcall(function()
if setMedCounterVisual then setMedCounterVisual(medCounterEnabled == true) end
if medCounterEnabled and _G.ExeStartMedCounter then _G.ExeStartMedCounter(LP.Character) elseif _G.ExeStopMedCounter then _G.ExeStopMedCounter() end
end)
pcall(function()
if setHardHitVisual then setHardHitVisual(hardHitEnabled == true) end
if hardHitEnabled and _G.ExeStartHardHit then _G.ExeStartHardHit() elseif _G.ExeStopHardHit then _G.ExeStopHardHit() end
end)
pcall(function()
if setPerfectHitVisual then setPerfectHitVisual(perfectHitEnabled == true) end
if perfectHitEnabled and _G.ExeStartPerfectHit then _G.ExeStartPerfectHit() elseif _G.ExeStopPerfectHit then _G.ExeStopPerfectHit() end
end)
pcall(function()
if _G.ExeSetNoPlayerCollisionVisual then _G.ExeSetNoPlayerCollisionVisual(_G.ExeNoPlayerCollisionEnabled == true) end
if _G.ExeNoPlayerCollisionEnabled then enableNoPlayerCollision() else disableNoPlayerCollision() end
end)
pcall(function()
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled == true) end
end)
pcall(function()
if _G.ExeSetAutoResetOnMed then _G.ExeSetAutoResetOnMed(autoResetOnMedEnabled == true, true) end
end)
pcall(function()
if setPlayerESPVisual then setPlayerESPVisual(espEnabled == true) end
if espEnabled then if startPlayerESP then startPlayerESP() end else if stopPlayerESP then stopPlayerESP() end end
end)
pcall(function()
if setTracerESPVisual then setTracerESPVisual(showTracerEnabled == true) end
if BoxedESPOptions then BoxedESPOptions.tracer = showTracerEnabled == true end
if refreshBoxedESP then refreshBoxedESP() end
end)
pcall(function()
if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled == true) end
if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) else stopRagdollCountdown() end
end)
pcall(function()
if setFPSBoostVisual then setFPSBoostVisual(fpsBoostEnabled == true) end
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
end)
pcall(function()
if setAntiLagVisual then setAntiLagVisual(antiLagVisualEnabled == true) end
if antiLagVisualEnabled then enableAntiLag() else disableAntiLag() end
end)
pcall(function()
if setNukeOptimiserVisual then setNukeOptimiserVisual(nukeOptimiserEnabled == true) end
if nukeOptimiserEnabled then enableNukeOptimizer() else disableNukeOptimizer() end
end)
pcall(function()
if setFOVVisual then setFOVVisual(fovEnabled == true) end
if fovEnabled then enableCustomFov() else disableCustomFov() end
end)
pcall(function()
if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled == true) end
if noCamCollisionEnabled then enableNoCamCollision() else disableNoCamCollision() end
end)
pcall(function()
if type(applyCustomSky) == "function" then applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off") end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
pcall(function()
if syncAnimationPackIndex then syncAnimationPackIndex() end
if refreshAnimationPackRow then refreshAnimationPackRow() end
if applySavedAnimationPackToCharacter then applySavedAnimationPackToCharacter(LP.Character) end
end)
end
task.defer(function()
task.wait(0.25)
if _G.ExeDuelsApplySavedGameplayStates then _G.ExeDuelsApplySavedGameplayStates() end
end)
task.delay(1.25, function()
if _G.ExeDuelsApplySavedGameplayStates then _G.ExeDuelsApplySavedGameplayStates() end
end)
task.delay(3, function()
if antiLagVisualEnabled and type(applyKTMOptimization) == "function" then pcall(applyKTMOptimization) end
if nukeOptimiserEnabled and type(applyKTMOptimization) == "function" then pcall(applyKTMOptimization) end
end)
_G.ExeAutoTPRestoreWanted = _G.ExeAutoTPRestoreWanted or false
_G.ExeAutoTPRestoreBlockedUntil = _G.ExeAutoTPRestoreBlockedUntil or 0
function aceAnyAimbotActive()
return (_G.ExeNormalAimbotOn == true) or (_G.ExeAntiBypassAimbotOn == true) or (_G.ExeAntiDesyncAimbotOn == true) or (_G.ExeAntiDesyncAimbotOn == true)
end
_G.ExeStopAutoTPForAction = function()
if autoTPEnabled then
_G.ExeAutoTPRestoreWanted = true
_G.ExeAutoTPRestoreBlockedUntil = tick() + 0.35
stopAutoTP()
if setAutoTPVisual then setAutoTPVisual(false) end
end
end
function aceTryRestoreAutoTP()
if not _G.ExeAutoTPRestoreWanted then return end
if tick() < (_G.ExeAutoTPRestoreBlockedUntil or 0) then return end
if aceAnyAimbotActive() then return end
if dropBrainrotActive then return end
_G.ExeAutoTPRestoreWanted = false
startAutoTP()
if setAutoTPVisual then setAutoTPVisual(true) end
if saveExeConfig then pcall(saveExeConfig) end
end
RunService.Heartbeat:Connect(aceTryRestoreAutoTP)
_G._oldExeStopNormalAimbot = _G.ExeStopNormalAimbot
_G.ExeStopNormalAimbot = function(...)
local r = {_G._oldExeStopNormalAimbot(...)}
_G.ExeAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
_G.ExeNormalAimbotStop = _G.ExeStopNormalAimbot
_G._oldExeStopAntiBypassAimbot = _G.ExeStopAntiBypassAimbot
_G.ExeStopAntiBypassAimbot = function(...)
local r = {_G._oldExeStopAntiBypassAimbot(...)}
_G.ExeAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
_G.ExeAntiBypassStop = _G.ExeStopAntiBypassAimbot
_G._oldExeStopAntiDesyncAimbot = _G.ExeStopAntiDesyncAimbot
_G.ExeStopAntiDesyncAimbot = function(...)
local r = {_G._oldExeStopAntiDesyncAimbot(...)}
_G.ExeAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
task.spawn(function()
local wasDropping = false
while task.wait(0.05) do
if dropBrainrotActive then
wasDropping = true
elseif wasDropping then
wasDropping = false
_G.ExeAutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
end
end
end)
function aceRepairKeybinds()
for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
if speedKeybinds[keyId] == nil or speedKeybinds[keyId] == Enum.KeyCode.Unknown then
speedKeybinds[keyId] = defaultKey
end
end
if tpDownKeybind == Enum.KeyCode.Unknown then tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND end
if refreshAllSpeedKeybinds then refreshAllSpeedKeybinds() end
if refreshTPDownKeybind then refreshTPDownKeybind() end
end
_G._oldSaveExeConfigStable = saveExeConfig
saveExeConfig = function()
aceRepairKeybinds()
return _G._oldSaveExeConfigStable()
end
aceRepairKeybinds()
task.defer(function()
task.wait(0.2)
aceRepairKeybinds()
do end
end)
task.defer(function()
task.wait(0.35)
local TS = game:GetService("TweenService")
for _, oldName in ipairs({"ExeMobileButtons", "ExeMobileButtons"}) do
local old = PlayerGui:FindFirstChild(oldName)
if old then old:Destroy() end
end
local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "ExeMobileButtons"
mobileGui.ResetOnSpawn = false
mobileGui.IgnoreGuiInset = true
mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mobileGui.DisplayOrder = 1000
safeParentGui(mobileGui)
mobileGui.Enabled = not (_G.ExeHideMobileButtons == true)
_G.ExeMobileButtonRefs = {}
local mobileButtons = _G.ExeMobileButtonRefs
function _G.ExeApplyMobileButtonsHidden()
local shouldHide = (_G.ExeHideMobileButtons == true)

local g = nil
pcall(function()
    g = PlayerGui:FindFirstChild("ExeMobileButtons")
end)

if not g then
    pcall(function()
        local cg = game:GetService("CoreGui")
        g = cg and cg:FindFirstChild("ExeMobileButtons")
    end)
end

if not g and gethui then
    pcall(function()
        local hui = gethui()
        g = hui and hui:FindFirstChild("ExeMobileButtons")
    end)
end

if not g and mobileGui and mobileGui.Parent then
    g = mobileGui
end

if g then
    g.Enabled = not shouldHide
end

if setHideMobileButtonsVisual then
    pcall(setHideMobileButtonsVisual, shouldHide)
end
end
function _G.ExeApplyHiddenMobileButtons()
for key, entry in pairs(mobileButtons) do
if entry and entry.holder then
entry.holder.Visible = not (_G.ExeHiddenMobileButtons and _G.ExeHiddenMobileButtons[key] == true)
end
end
end
function _G.ExeFireMobileButton(key)
local a = _G.ExeMobileActions and _G.ExeMobileActions[key]
if a and a.onPress then pcall(a.onPress, a.btn) end
end
local function normalizeMobileImage(value)
value = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
if value == "" then return "" end
local id = value:match("^(%d+)$")
if id then return "rbxassetid://" .. id end
local embedded = value:match("[?&]id=(%d+)") or value:match("/(%d+)[/%?]?")
if embedded then return "rbxassetid://" .. embedded end
return value
end
function _G.ExeApplyMobileButtonImage() end

function _G.ExeApplyMobileButtonShape()
local shape = tostring(_G.ExeMobileButtonShape or "ROUNDED"):upper()
if shape ~= "CIRCLE" and shape ~= "SQUARE" and shape ~= "ROUNDED" then shape = "ROUNDED" end
_G.ExeMobileButtonShape = shape
for key, entry in pairs(mobileButtons) do
local btn = entry and entry.btn
local holder = entry and entry.holder
if btn and holder then
holder.Size = UDim2.new(0,70,0,70)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 12
local textOverlay = btn:FindFirstChild("MobileButtonText")
if textOverlay then
textOverlay.Font = Enum.Font.GothamBold
textOverlay.TextSize = 12
end
local radius = UDim.new(0,12)
if shape == "CIRCLE" then radius = UDim.new(1,0) end
local c = btn:FindFirstChildOfClass("UICorner")
if c then c.CornerRadius = radius end
local noneBg = btn:FindFirstChild("ButtonNoneBackground")
local nc = noneBg and noneBg:FindFirstChildOfClass("UICorner")
if nc then nc.CornerRadius = radius end
local glow = holder:FindFirstChild("Glow")
local gc = glow and glow:FindFirstChildOfClass("UICorner")
if gc then gc.CornerRadius = radius end
local dot = btn:FindFirstChild("Dot")
if dot then dot.Visible = false end
end
end
end
function _G.ExeApplyMobileButtonSize()
_G.ExeMobileButtonScale = math.clamp(tonumber(_G.ExeMobileButtonScale) or 1.00, 0.30, 1.35)
for _, entry in pairs(mobileButtons) do
local holder = entry and entry.holder
if holder then
local sc = holder:FindFirstChild("MobileButtonScale") or Instance.new("UIScale")
sc.Name = "MobileButtonScale"
sc.Scale = _G.ExeMobileButtonScale
sc.Parent = holder
end
end
pcall(function()
local gui = PlayerGui:FindFirstChild("ExeDuelsExeReconstruct") or PlayerGui:FindFirstChild("ExeHubPolished") or PlayerGui:FindFirstChild("CyberHub")
local root = gui or PlayerGui
for _, obj in ipairs(root:GetDescendants()) do
if obj.Name == "Mobile Buttons Size" then
local valueBox = obj:FindFirstChild("Value")
if valueBox and valueBox:IsA("TextLabel") then
valueBox.Text = string.format("%.2f", _G.ExeMobileButtonScale)
end
end
end
end)
end
local function setActive(btn, state)
if not btn then return end
local pressed = btn:GetAttribute("ExeMobilePressed") == true
-- The requested mobile style is white at rest and black only during a press.
state = pressed
local visualState = state and "pressed" or "rest"
if btn:GetAttribute("ExeMobileVisualState") == visualState then return end
btn:SetAttribute("ExeMobileVisualState", visualState)
local holder = btn.Parent
local glow = holder and holder:FindFirstChild("Glow")
local st = btn:FindFirstChildOfClass("UIStroke")
local textOverlay = btn:FindFirstChild("MobileButtonText")
local noneBg = btn:FindFirstChild("ButtonNoneBackground")
local noneGrad = noneBg and noneBg:FindFirstChild("ButtonNoneGradient")
local dot = btn:FindFirstChild("Dot")
-- Screenshot style: solid black off | solid medium-gray on
if noneGrad then
    noneGrad.Enabled = false
end
if noneBg then
    noneBg.BackgroundTransparency = 0
    if noneBg:IsA("ImageLabel") then
        noneBg.Image = ""
        noneBg.ImageTransparency = 1
    end
    local targetBg = state and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    TS:Create(noneBg, TweenInfo.new(0.12), {BackgroundColor3 = targetBg}):Play()
end
if textOverlay then
    TS:Create(textOverlay, TweenInfo.new(0.12), {
        TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0),
    }):Play()
end
if st then
    st.Enabled = false
    st.Transparency = 1
end
if dot then dot.Visible = false end
if glow then
    glow.Visible = false
    glow.BackgroundTransparency = 1
    local gs = glow:FindFirstChildOfClass("UIStroke")
    if gs then gs.Transparency = 1 end
end
end
local function pulse(btn)
if not btn then return end
btn:SetAttribute("ExeMobilePressed", true)
setActive(btn, true)
task.delay(0.18, function()
if btn and btn.Parent then
btn:SetAttribute("ExeMobilePressed", false)
setActive(btn, false)
end
end)
end
local function makeButton(key, label, pos, onPress, customSize)
local holder = Instance.new("Frame")
holder.Name = "MBH_" .. key
holder.Size = customSize or UDim2.new(0,70,0,70)
holder.Position = getSavedMobileButtonPosition(key, pos)
holder.BackgroundTransparency = 1
holder.BorderSizePixel = 0
holder.ZIndex = 1000
holder.Active = true
holder.Parent = mobileGui
local glow = Instance.new("Frame", holder)
glow.Name = "Glow"
glow.Size = UDim2.new(1, 0, 1, 0)
glow.Position = UDim2.new(0, 0, 0, 0)
glow.BackgroundTransparency = 1
glow.BorderSizePixel = 0
glow.ZIndex = 1000
glow.Visible = false
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 14)
local btn = Instance.new("TextButton", holder)
btn.Name = "MB_" .. key
btn.Size = UDim2.new(1, 0, 1, 0)
btn.Position = UDim2.new(0, 0, 0, 0)
btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
btn.BackgroundTransparency = 1
btn.BorderSizePixel = 0
btn.Text = label
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 12
btn.TextWrapped = true
btn.AutoButtonColor = false
btn.ZIndex = 1002
btn.Active = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

local noneBg = Instance.new("Frame", btn)
noneBg.Name = "ButtonNoneBackground"
noneBg.Size = UDim2.new(1,0,1,0)
noneBg.Position = UDim2.new(0,0,0,0)
noneBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
noneBg.BorderSizePixel = 0
noneBg.ZIndex = btn.ZIndex
noneBg.Parent = btn
Instance.new("UICorner", noneBg).CornerRadius = UDim.new(0,12)

local noneGrad = Instance.new("UIGradient", noneBg)
noneGrad.Name = "ButtonNoneGradient"
noneGrad.Enabled = false
noneGrad.Rotation = 0
noneGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})

local textOverlay = Instance.new("TextLabel", btn)
textOverlay.Name = "MobileButtonText"
textOverlay.BackgroundTransparency = 1
textOverlay.Size = UDim2.new(1, -10, 1, -10)
textOverlay.Position = UDim2.new(0, 5, 0, 5)
textOverlay.Text = label
textOverlay.TextColor3 = Color3.fromRGB(0,0,0)
textOverlay.TextStrokeColor3 = Color3.fromRGB(0,0,0)
textOverlay.TextStrokeTransparency = 1
textOverlay.Font = Enum.Font.GothamBold
textOverlay.TextSize = 12
textOverlay.TextWrapped = true
textOverlay.TextXAlignment = Enum.TextXAlignment.Center
textOverlay.TextYAlignment = Enum.TextYAlignment.Center
textOverlay.ZIndex = btn.ZIndex + 1
btn.TextTransparency = 1
local stroke = Instance.new("UIStroke", btn)
stroke.Color = Color3.fromRGB(0,0,0)
stroke.Thickness = 0
stroke.Transparency = 1
stroke.Enabled = false
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local pressing, dragging = false, false
local pressPos, holderStart = nil, nil
btn.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
pressing = true
dragging = false
pressPos = i.Position
holderStart = holder.Position
btn:SetAttribute("ExeMobilePressed", true)
setActive(btn, true)
pcall(function()
TS:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = UDim2.new(0, 0, 0, 4),
Size = UDim2.new(1, 0, 1, -4)
}):Play()
end)
end
end)
btn.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
if pressing and not dragging then pcall(onPress, btn) end
if dragging then do end end
pressing = false
dragging = false
btn:SetAttribute("ExeMobilePressed", false)
pcall(function()
TS:Create(btn, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = UDim2.new(0, 0, 0, 0),
Size = UDim2.new(1, 0, 1, 0)
}):Play()
end)
task.delay(0.08, function()
if btn and btn.Parent then
local keepOn = false
if key == "autoPlay" then keepOn = _G.ExeAutoPlayOn == true
elseif key == "aimbot" then keepOn = (_G.ExeNormalAimbotOn == true) or (_G.ExeAntiBypassAimbotOn == true)
elseif key == "batV2" then keepOn = _G.ExeBatV2On == true
elseif key == "antiBat" then keepOn = _G.ExeAntiBatBypassOn == true
elseif key == "tpBat" then keepOn = (_G.ExeTpBatV1On == true) or (_G.ExeTpBatV2On == true)
elseif key == "carry" then keepOn = carrySpeedActive == true
elseif key == "laggerNormal" then keepOn = laggerModeEnabled == true
elseif key == "laggerCarry" then keepOn = laggerCarryActive == true
end
setActive(btn, keepOn)
end
end)
end
end)
UserInputService.InputChanged:Connect(function(i)
if _G.ExeGuiLocked == true or not pressing then return end
if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
local delta = i.Position - pressPos
if not dragging and (math.abs(delta.X) > 6 or math.abs(delta.Y) > 6) then dragging = true end
if dragging then
holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + delta.X, holderStart.Y.Scale, holderStart.Y.Offset + delta.Y)
saveMobileButtonPosition(key, holder.Position)
end
end)
setActive(btn, false)
_G.ExeMobileActions = _G.ExeMobileActions or {}
_G.ExeMobileActions[key] = {onPress = onPress, btn = btn}
if _G.ExeHiddenMobileButtons and _G.ExeHiddenMobileButtons[key] then holder.Visible = false end
mobileButtons[key] = {holder = holder, btn = btn, setActive = function(state) setActive(btn, state) end}
return btn
end

do
-- S2 HUB reset (button stays named INSTA RESET)
local RESET_MAX_DURATION = 0.05
local _resetCooldown = false
local _resetThread = nil
local _resetCameraLocked = false
local _resetLockedCFrame = nil

local function stopS2Reset()
    _resetCooldown = false
    if _resetThread then pcall(function() task.cancel(_resetThread) end); _resetThread = nil end
    _resetCameraLocked = false
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.HipHeight = 2
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = true end
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end
                end
            end)
        end
    end
end

_G.ExeInstaResetRun = function()
    if _resetCooldown then return false end
    _resetCooldown = true

    local char = LP.Character
    if not char then _resetCooldown = false; return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then _resetCooldown = false; return false end

    local camera = workspace.CurrentCamera
    if camera then
        _resetLockedCFrame = camera.CFrame
        _resetCameraLocked = true
    end

    local isRespawning = false
    _resetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 40
        local originalHipHeight = hum.HipHeight
        local resetSuccessful = false

        while char and char.Parent and hum and hum.Health > 0 and not isRespawning do
            if LP.Character ~= char then isRespawning = true; break end
            pcall(function()
                hum.HipHeight = 1e30
                hum.AutoRotate = true
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = false end
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
                end
            end)
            if not char or not char.Parent or not hum or hum.Health <= 0 or LP.Character ~= char then
                resetSuccessful = true; break
            end
            attempts = attempts + 1
            if attempts >= maxAttempts then break end
            task.wait(RESET_MAX_DURATION)
        end

        if not resetSuccessful then
            if char and char.Parent and hum and hum.Health > 0 and not isRespawning then
                pcall(function() hum.Health = 0 end)
                task.wait(0.1)
                if not char.Parent or hum.Health <= 0 then resetSuccessful = true end
            end
        end

        if not resetSuccessful and char and char.Parent and hum then
            pcall(function()
                hum.HipHeight = originalHipHeight
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = true end
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end
                end
            end)
        end

        _resetCameraLocked = false
        _resetCooldown = false
        _resetThread = nil
    end)
    return true
end

RunService.Heartbeat:Connect(function()
    if not _resetCameraLocked or not _resetLockedCFrame then return end
    local camera = workspace.CurrentCamera
    if camera then camera.CFrame = _resetLockedCFrame end
end)
LP.CharacterAdded:Connect(function() stopS2Reset() end)

_G.ExeInstantReset = _G.ExeInstaResetRun
_G.ExeStopInstantReset = stopS2Reset
end

-- ==================== ANTI TP BAT ====================
do
    local FAKE_ROOT_Y = 1e8
    local _antiTpEnabled = false
    local _antiTpRuntime = {
        character = nil,
        rootPart = nil,
        fakeRoot = nil,
        stepConn = nil,
        alive = true,
    }
    local sethidden = sethiddenproperty or set_hidden_property
    local gethidden = gethiddenproperty or get_hidden_property

    local function setHidden(inst, prop, val)
        if sethidden then
            local ok = pcall(sethidden, inst, prop, val)
            if ok then return true end
        end
        return pcall(function() inst[prop] = val end)
    end

    local function isBasePart(inst)
        local ok, r = pcall(function() return inst:IsA("BasePart") end)
        return ok and r
    end

    local function getRoot(char)
        char = char or LP.Character
        if not char then return nil end
        local ok, root = pcall(function() return char:FindFirstChild("HumanoidRootPart") end)
        if ok and isBasePart(root) then return root end
        return nil
    end

    local function createFakeRoot(rootPart)
        if _antiTpRuntime.fakeRoot then
            pcall(function() _antiTpRuntime.fakeRoot:Destroy() end)
            _antiTpRuntime.fakeRoot = nil
        end
        if not isBasePart(rootPart) then return nil end
        local fake = Instance.new("Part")
        fake.Name = "ExeAntiTpFakeRepRoot"
        fake.Size = Vector3.new(2, 2, 1)
        fake.Transparency = 1
        fake.Anchored = true
        fake.CanCollide = false
        fake.CanQuery = false
        fake.CanTouch = false
        fake.Massless = true
        fake.CFrame = CFrame.new(rootPart.Position.X, FAKE_ROOT_Y, rootPart.Position.Z)
        fake.Parent = workspace
        _antiTpRuntime.fakeRoot = fake
        return fake
    end

    local function assignFakeRepRoot(rootPart, fake)
        if not isBasePart(rootPart) or not isBasePart(fake) then return end
        setHidden(rootPart, "PhysicsRepRootPart", fake)
    end

    local function restoreReplicationRoot()
        local root = _antiTpRuntime.rootPart
        if isBasePart(root) then
            setHidden(root, "PhysicsRepRootPart", root)
        end
    end

    local function stepDesync()
        if not _antiTpEnabled or not _antiTpRuntime.alive then return end
        local root = _antiTpRuntime.rootPart
        if not isBasePart(root) or not root.Parent then
            root = getRoot(_antiTpRuntime.character)
            _antiTpRuntime.rootPart = root
            if not root then return end
        end
        if not isBasePart(_antiTpRuntime.fakeRoot) or not _antiTpRuntime.fakeRoot.Parent then
            local fake = createFakeRoot(root)
            if fake then assignFakeRepRoot(root, fake) end
            return
        end
        local fake = _antiTpRuntime.fakeRoot
        local ok, rootPos, fakePos = pcall(function()
            return root.Position, fake.Position
        end)
        if ok and (math.abs(rootPos.X - fakePos.X) > 0.01
                or math.abs(rootPos.Z - fakePos.Z) > 0.01
                or math.abs(fakePos.Y - FAKE_ROOT_Y) > 0.01) then
            pcall(function()
                fake.CFrame = CFrame.new(rootPos.X, FAKE_ROOT_Y, rootPos.Z)
            end)
        end
        pcall(function()
            fake.Anchored = true
            fake.AssemblyLinearVelocity = Vector3.zero
        end)
        local got, current = nil, nil
        if gethidden then
            got, current = pcall(gethidden, root, "PhysicsRepRootPart")
        end
        if not got or current ~= fake then
            setHidden(root, "PhysicsRepRootPart", fake)
        end
    end

    local function setAntiTpEnabled(on)
        on = on == true
        _antiTpEnabled = on
        _G.ExeAntiTpBatEnabled = on
        if on then
            local root = getRoot(LP.Character)
            _antiTpRuntime.character = LP.Character
            _antiTpRuntime.rootPart = root
            if not root then
                _antiTpEnabled = false
                _G.ExeAntiTpBatEnabled = false
                return false
            end
            local fake = createFakeRoot(root)
            assignFakeRepRoot(root, fake)
            if _antiTpRuntime.stepConn then _antiTpRuntime.stepConn:Disconnect() end
            _antiTpRuntime.stepConn = RunService.Stepped:Connect(stepDesync)
        else
            if _antiTpRuntime.stepConn then
                _antiTpRuntime.stepConn:Disconnect()
                _antiTpRuntime.stepConn = nil
            end
            restoreReplicationRoot()
            if _antiTpRuntime.fakeRoot then
                pcall(function() _antiTpRuntime.fakeRoot:Destroy() end)
                _antiTpRuntime.fakeRoot = nil
            end
        end
        return _antiTpEnabled
    end

    local function bindCharacter(char)
        _antiTpRuntime.character = char
        _antiTpRuntime.rootPart = getRoot(char)
        if _antiTpEnabled and _antiTpRuntime.rootPart then
            local fake = createFakeRoot(_antiTpRuntime.rootPart)
            assignFakeRepRoot(_antiTpRuntime.rootPart, fake)
            if _antiTpRuntime.stepConn then _antiTpRuntime.stepConn:Disconnect() end
            _antiTpRuntime.stepConn = RunService.Stepped:Connect(stepDesync)
        end
    end

    LP.CharacterAdded:Connect(function(char)
        task.defer(bindCharacter, char)
    end)
    if LP.Character then bindCharacter(LP.Character) end

    _G.ExeSetAntiTpBat = setAntiTpEnabled
    _G.ExeToggleAntiTpBat = function()
        return setAntiTpEnabled(not (_G.ExeAntiTpBatEnabled == true))
    end
    _G.ExeAntiTpBatEnabled = _G.ExeAntiTpBatEnabled == true
end

local defaults = {
-- Original positions:
-- AUTO LEFT above DROP BR | AUTO RIGHT above AIMBOT
-- LAGGER under TP / CARRY
autoLeft     = UDim2.new(1, -132, 0.5, -161),
autoRight    = UDim2.new(1, -66,  0.5, -161),
drop         = UDim2.new(1, -132, 0.5, -95),
aimbot       = UDim2.new(1, -66,  0.5, -95),
tp           = UDim2.new(1, -132, 0.5, -29),
carry        = UDim2.new(1, -66,  0.5, -29),
laggerNormal = UDim2.new(1, -132, 0.5, 37),
laggerCarry  = UDim2.new(1, -66,  0.5, 37),
instantReset = UDim2.new(1, -198, 0.5, -161),
instaMedusa = UDim2.new(1, -198, 0.5, -29),
batV2      = UDim2.new(1, -198, 0.5, -95),
tpBat      = UDim2.new(1, -198, 0.5, 37),
antiBat    = UDim2.new(1, -198, 0.5, 103),
}

function _G.ExeResetMobileButtons()
_G.ExeHiddenMobileButtons = {}
if _G.ExeRefreshHideEachRows then pcall(_G.ExeRefreshHideEachRows) end
if _G.ExeApplyHiddenMobileButtons then pcall(_G.ExeApplyHiddenMobileButtons) end
_G.ExeMobileButtonScale = ExeAutoMobile and 0.90 or 1.00
_G.ExeMobileButtonImage = ""
_G.ExeHideMobileButtons = false
_G.ExeMobileButtonShape = "ROUNDED"
_G.ExeMobileButtonPositions = {}
_G.ExeMobileLayoutV = 6
for key, defaultPos in pairs(defaults) do
local entry = mobileButtons[key]
local holder = entry and entry.holder
if holder then
holder.Position = defaultPos
end
end
_G.ExeApplyMobileButtonSize()
_G.ExeApplyMobileButtonsHidden()
_G.ExeApplyMobileButtonShape()
_G.ExeApplyMobileButtonImage()
_G.ExeApplyMobileButtonShape()
if type(saveExeConfig) == "function" then pcall(saveExeConfig) end
end

makeButton("drop", "DROP BR", defaults.drop, function(btn)
if runDropBrainrot then runDropBrainrot() elseif runDrop then runDrop() end
pulse(btn)
end)

makeButton("autoPlay", "AUTO\nPLAY", defaults.autoLeft, function(btn)
if _G.ExeToggleAutoPlay then _G.ExeToggleAutoPlay() end
task.delay(0.03, function()
if btn and btn.Parent then setActive(btn, _G.ExeAutoPlayOn == true) end
end)
end)

makeButton("aimbot", "BAT\nAIMBOT", defaults.aimbot, function(btn)
if _G.ExeSafeModeIsLocked and _G.ExeSafeModeIsLocked() then return end
selectedAimbotMode = "Normal"
if _G.ExeToggleSelectedAimbot then _G.ExeToggleSelectedAimbot() end
task.delay(0.03, function()
setActive(btn, _G.ExeNormalAimbotOn == true)
end)
end)

makeButton("laggerNormal", "LAGGER\nNORM", defaults.laggerNormal, function(btn)
if toggleLaggerMode then toggleLaggerMode() end
task.delay(0.03,function()
setActive(btn, laggerModeEnabled == true)
end)
end)

makeButton("laggerCarry", "LAGGER\nCARRY", defaults.laggerCarry, function(btn)
if toggleLaggerCarryMode then toggleLaggerCarryMode() end
task.delay(0.03, function()
setActive(btn, laggerCarryActive == true)
end)
end)

makeButton("tp", "TP DOWN", defaults.tp, function(btn)
if runTPFloor then runTPFloor() end
pulse(btn)
end)

makeButton("carry", "CARRY\nSPEED", defaults.carry, function()
if toggleCarryMode then toggleCarryMode() end
end)

makeButton("instantReset", "INSTA\nRESET", defaults.instantReset, function(btn)
if _G.ExeInstaResetRun then _G.ExeInstaResetRun() end
pulse(btn)
end)

makeButton("instaMedusa", "INSTA\nMEDUSA", defaults.instaMedusa, function(btn)
task.spawn(function() if _G.ExeInstaMedusa then _G.ExeInstaMedusa() end end)
pulse(btn)
end)

makeButton("batV2", "BAT V2", defaults.batV2, function(btn)
    if _G.ExeToggleBatV2 then _G.ExeToggleBatV2() end
    task.delay(0.03, function()
        if btn and btn.Parent then setActive(btn, _G.ExeBatV2On == true) end
    end)
end)

-- ANTI BAT BYPASS mobile button (black, white text) - runs the S2 anti bat bypass logic
makeButton("antiBat", "ANTI BAT\nBYPASS", defaults.antiBat, function(btn)
    if _G.ExeToggleAntiBatBypass then _G.ExeToggleAntiBatBypass() end
    task.delay(0.03, function()
        if btn and btn.Parent then setActive(btn, _G.ExeAntiBatBypassOn == true) end
    end)
end)

-- TP BAT mobile button: tap = on/off, small arrow = pick V1 / V2
_G.ExeTpBatSelected = (_G.ExeTpBatSelected == "V2") and "V2" or "V1"
do
    local tpHolderBtn = makeButton("tpBat", "TP BAT", defaults.tpBat, function(btn)
        if (_G.ExeTpBatV1On == true) or (_G.ExeTpBatV2On == true) then
            if _G.ExeStopTpBat then _G.ExeStopTpBat() end
        else
            if _G.ExeStartTpBat then _G.ExeStartTpBat(_G.ExeTpBatSelected) end
        end
        task.delay(0.03, function()
            if btn and btn.Parent then setActive(btn, (_G.ExeTpBatV1On == true) or (_G.ExeTpBatV2On == true)) end
        end)
    end)
    local entry = mobileButtons.tpBat
    local holder = entry and entry.holder
    if holder then
        local txt = tpHolderBtn:FindFirstChild("MobileButtonText")
        if txt then
            txt.Position = UDim2.new(0, 5, 0, 4)
            txt.Size = UDim2.new(1, -10, 1, -26)
        end

        local arrow = Instance.new("TextButton")
        arrow.Name = "TpBatArrow"
        arrow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        arrow.BackgroundTransparency = 0.1
        arrow.BorderSizePixel = 0
        arrow.AutoButtonColor = false
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 11
        arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
        arrow.Size = UDim2.new(0, 46, 0, 18)
        arrow.Position = UDim2.new(0.5, -23, 1, -23)
        arrow.ZIndex = 1010
        arrow.Parent = holder
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 8)

        local picker = Instance.new("Frame")
        picker.Name = "TpBatPicker"
        picker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        picker.BorderSizePixel = 0
        picker.Size = UDim2.new(0, 60, 0, 70)
        picker.Position = UDim2.new(0, -66, 0, 0)
        picker.Visible = false
        picker.ZIndex = 1020
        picker.Parent = holder
        Instance.new("UICorner", picker).CornerRadius = UDim.new(0, 10)
        local pst = Instance.new("UIStroke", picker)
        pst.Color = Color3.fromRGB(120, 120, 120)
        pst.Thickness = 1
        pst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local opts = {}
        local function refresh()
            local sel = (_G.ExeTpBatSelected == "V2") and "V2" or "V1"
            arrow.Text = sel .. (picker.Visible and "  ^" or "  v")
            for name, b in pairs(opts) do
                b.BackgroundColor3 = (name == sel) and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(30, 30, 30)
            end
        end
        _G.ExeTpBatMobileRefresh = refresh

        for i, name in ipairs({"V1", "V2"}) do
            local b = Instance.new("TextButton")
            b.Name = "Opt_" .. name
            b.Text = name
            b.Font = Enum.Font.GothamBold
            b.TextSize = 13
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Size = UDim2.new(1, -10, 0, 29)
            b.Position = UDim2.new(0, 5, 0, 4 + (i - 1) * 32)
            b.ZIndex = 1021
            b.Parent = picker
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
            opts[name] = b
            b.MouseButton1Click:Connect(function()
                _G.ExeTpBatSelected = name
                picker.Visible = false
                -- if TP bat is running, switch to the picked version right away
                if (_G.ExeTpBatV1On == true) or (_G.ExeTpBatV2On == true) then
                    if _G.ExeStartTpBat then _G.ExeStartTpBat(name) end
                end
                refresh()
                if _G.ExeTpBatSetVisual then pcall(_G.ExeTpBatSetVisual) end
                if saveExeConfig then pcall(saveExeConfig) end
            end)
        end

        arrow.MouseButton1Click:Connect(function()
            picker.Visible = not picker.Visible
            refresh()
        end)
        refresh()
    end
end

pcall(function() if _G.ExeApplyMobileButtonImage then _G.ExeApplyMobileButtonImage() end end)

_G.ExeApplyMobileButtonSize()
_G.ExeApplyMobileButtonsHidden()

task.defer(function()
    task.wait(0.15)
    if mobileGui then
        mobileGui.Enabled = not (_G.ExeHideMobileButtons == true)
    end
    pcall(_G.ExeApplyMobileButtonsHidden)
end)

RunService.Heartbeat:Connect(function()
if mobileButtons.autoPlay then mobileButtons.autoPlay.setActive(_G.ExeAutoPlayOn == true) end
if mobileButtons.aimbot then mobileButtons.aimbot.setActive(_G.ExeNormalAimbotOn == true or _G.ExeAntiBypassAimbotOn == true) end
if mobileButtons.batV2 then mobileButtons.batV2.setActive(_G.ExeBatV2On == true) end
if mobileButtons.antiBat then mobileButtons.antiBat.setActive(_G.ExeAntiBatBypassOn == true) end
if mobileButtons.tpBat then mobileButtons.tpBat.setActive((_G.ExeTpBatV1On == true) or (_G.ExeTpBatV2On == true)) end
if mobileButtons.carry then mobileButtons.carry.setActive(carrySpeedActive == true) end
if mobileButtons.laggerNormal then mobileButtons.laggerNormal.setActive(laggerModeEnabled == true) end
if mobileButtons.laggerCarry then mobileButtons.laggerCarry.setActive(laggerCarryActive == true) end
end)
end)

task.defer(function()
task.wait(1)
pcall(function()
_G.ExeApplyMovingEdgeLights(PlayerGui)
end)
end)

pcall(function()
if hookfunction and newcclosure then
local _xKickRemote = nil
local _xOldFire
_xOldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
if not _xKickRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
_xKickRemote = self
end
return _xOldFire(self, ...)
end))
end
end)
