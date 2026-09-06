--// Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

--// Folders
local AssetFolder = "ServerBrowser/assets"
if not isfolder("ServerBrowser") then makefolder("ServerBrowser") end
if not isfolder(AssetFolder) then makefolder(AssetFolder) end

--// Fonts
    local Fonts = {}
    
    local function loadFont(name, url)
        local ttfPath  = AssetFolder .. "/" .. name .. ".ttf"
        local jsonPath = AssetFolder .. "/" .. name .. ".json"
        if isfile(jsonPath) then
            Fonts[name] = Font.new(getcustomasset(jsonPath))
            return
        end
        if not isfile(ttfPath) then
            writefile(ttfPath, game:HttpGet(url))
        end
        local data = HttpService:JSONEncode({
            name  = name,
            faces = { {
                name    = "Regular",
                weight  = 400,
                style   = "normal",
                assetId = getcustomasset(ttfPath),
            } }
        })
        writefile(jsonPath, data)
        Fonts[name] = Font.new(getcustomasset(jsonPath))
    end
    
    loadFont("PixelFont", "https://github.com/i77lhm/storage/raw/main/fonts/fs-tahoma-8px.ttf")
    loadFont("BoldFont",  "https://github.com/i77lhm/storage/raw/main/fonts/tahoma_bold.ttf")
    
    local FONT_PIXEL = Fonts["PixelFont"] or Font.new("rbxasset://fonts/families/PressStart2P.json")
    local FONT_BOLD  = Fonts["BoldFont"]  or Font.new("rbxasset://fonts/families/Nunito.json")
--

--// Instance utility
    local function create(class, props)
        local ok, inst = pcall(Instance.new, class)
        if not ok then return false end
        if props then
            for k, v in next, props do
                local s, e = pcall(function() (inst :: any)[k] = v end)
                if not s then warn(e) end
            end
        end
        return inst
    end
    
    local function gradient(parent)
        create("UIGradient", {
            Parent   = parent,
            Rotation = 90,
            Color    = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(154, 154, 154)),
            },
        })
    end
    
    local function stroke(parent)
        local s = create("UIStroke", { Parent = parent, LineJoinMode = Enum.LineJoinMode.Miter, Color = Color3.fromRGB(0, 0, 0), Thickness = 1 })
        return s
    end
--

--// Root GUI
    local ScreenGui = create("ScreenGui", {
        Parent           = gethui(),
        ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn     = false,
        DisplayOrder     = 99,
    })
    
    local Frame = create("Frame", {
        Parent           = ScreenGui,
        Position         = UDim2.fromScale(0.3823964595794678, 0.23455233871936798),
        BorderColor3     = Color3.fromRGB(0, 0, 0),
        Size             = UDim2.fromOffset(318, 421),
        BackgroundColor3 = Color3.fromRGB(95, 95, 95),
    })
    
    local Frame_1 = create("Frame", {
        Parent           = Frame,
        Position         = UDim2.fromScale(0.006289307959377766, 0.0047505940310657024),
        BorderColor3     = Color3.fromRGB(0, 0, 0),
        Size             = UDim2.fromOffset(314, 417),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    })
    
    local Frame_2 = create("Frame", {
        Parent           = Frame_1,
        Position         = UDim2.fromScale(0.015703419223427773, 0.0430000014603138),
        BorderColor3     = Color3.fromRGB(0, 0, 0),
        Size             = UDim2.fromOffset(306, 395),
        BackgroundColor3 = Color3.fromRGB(95, 95, 95),
    })
    
    local Frame_3 = create("Frame", {
        Parent           = Frame_2,
        Position         = UDim2.new(0, 1, 0.0025316455867141485, 0),
        BorderColor3     = Color3.fromRGB(0, 0, 0),
        Size             = UDim2.fromOffset(304, 393),
        BorderSizePixel  = 0,
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
    })
    
    local scrollFrame = create("ScrollingFrame", {
        Parent               = Frame_3,
        Name                 = "eee",
        BackgroundTransparency = 1,
        Position             = UDim2.fromScale(0, 3.882643540009667e-08),
        BorderColor3         = Color3.fromRGB(0, 0, 0),
        Size                 = UDim2.fromOffset(304, 368),
        BorderSizePixel      = 0,
        BackgroundColor3     = Color3.fromRGB(255, 255, 255),
        ScrollBarThickness   = 0,
        ScrollingDirection   = Enum.ScrollingDirection.Y,
        CanvasSize           = UDim2.fromOffset(304, 0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        ElasticBehavior      = Enum.ElasticBehavior.Never,
    })
    
    create("UIListLayout", {
        Parent    = scrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    
    scrollFrame.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseWheel then
            local max    = scrollFrame.AbsoluteCanvasSize.Y - scrollFrame.AbsoluteSize.Y
            local target = scrollFrame.CanvasPosition.Y - (inp.Position.Z * 40)
            scrollFrame.CanvasPosition = Vector2.new(0, math.clamp(target, 0, math.max(0, max)))
        end
    end)
    
    local extra = create("Frame", {
        Parent               = Frame_3,
        BackgroundTransparency = 1,
        Position             = UDim2.fromScale(-0.0000012046411939081736, 0.9363868236541748),
        BorderColor3         = Color3.fromRGB(95, 95, 95),
        Name                 = "extra",
        Size                 = UDim2.fromOffset(304, 25),
        BackgroundColor3     = Color3.fromRGB(195, 255, 0),
    })
    
    local function tweenColor(instance, property, targetColor, duration)
        local tween = TweenService:Create(instance, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            [property] = targetColor
        })
        tween:Play()
    end
    
    local function makeExtraBtn(parent, posX, labelText)
        local outer = create("Frame", {
            Parent           = parent,
            Position         = UDim2.fromScale(posX, 0.11999999731779099),
            BorderColor3     = Color3.fromRGB(0, 0, 0),
            Size             = UDim2.fromOffset(79, 19),
            BackgroundColor3 = Color3.fromRGB(95, 95, 95),
        })
        local inner = create("Frame", {
            Parent           = outer,
            Position         = UDim2.fromScale(0.018984250724315643, 0.06151701137423515),
            BorderColor3     = Color3.fromRGB(0, 0, 0),
            Size             = UDim2.fromOffset(77, 17),
            BorderSizePixel  = 0,
            BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        })
        gradient(inner)
        local lbl = create("TextLabel", {
            Parent               = inner,
            FontFace             = FONT_PIXEL,
            TextColor3           = Color3.fromRGB(255, 255, 255),
            BorderColor3         = Color3.fromRGB(0, 0, 0),
            Text                 = labelText,
            BackgroundTransparency = 1,
            Position             = UDim2.fromScale(0, -0.06875430792570114),
            Size                 = UDim2.fromOffset(77, 18),
            BorderSizePixel      = 0,
            TextSize             = 12,
            BackgroundColor3     = Color3.fromRGB(255, 255, 255),
        })
        stroke(lbl)
        local btn = create("TextButton", {
            Parent               = outer,
            Size                 = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            Text                 = "",
            ZIndex               = 5,
        })
        btn.MouseEnter:Connect(function() tweenColor(lbl, "TextColor3", Color3.fromRGB(195, 255, 0), 0.2) end)
        btn.MouseLeave:Connect(function()  tweenColor(lbl, "TextColor3", Color3.fromRGB(255, 255, 255), 0.2) end)
        return btn
    end
    
    local rejoinBtn   = makeExtraBtn(extra, 0.019107427448034286, "Rejoin Current")
    local copyJoinBtn = makeExtraBtn(extra, 0.289000004529953,    "Copy join")
    
    local otherLabel = create("TextLabel", {
        Parent               = extra,
        FontFace             = FONT_BOLD,
        TextColor3           = Color3.fromRGB(195, 255, 0),
        BorderColor3         = Color3.fromRGB(0, 0, 0),
        Text                 = "Other",
        Name                 = "copy join",
        Size                 = UDim2.fromOffset(48, 18),
        BackgroundTransparency = 1,
        TextXAlignment       = Enum.TextXAlignment.Left,
        Position             = UDim2.fromScale(0.01973804645240307, -0.6287548542022705),
        BorderSizePixel      = 0,
        TextSize             = 12,
        BackgroundColor3     = Color3.fromRGB(195, 255, 0),
    })
    stroke(otherLabel)
    
    local titleBar = create("Frame", {
        Parent               = Frame_1,
        Position             = UDim2.fromScale(0.006149389315396547, 0),
        Size                 = UDim2.fromOffset(305, 17),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
    })
    
    local titleLabel = create("TextLabel", {
        Parent               = titleBar,
        AnchorPoint          = Vector2.new(0.5, 0),
        FontFace             = FONT_BOLD,
        TextColor3           = Color3.fromRGB(255, 255, 255),
        BorderColor3         = Color3.fromRGB(0, 0, 0),
        Text                 = "Servers",
        Name                 = "title",
        BackgroundTransparency = 1,
        Position             = UDim2.fromScale(0.5, 0),
        Size                 = UDim2.fromOffset(285, 17),
        BorderSizePixel      = 0,
        TextSize             = 12,
        BackgroundColor3     = Color3.fromRGB(255, 255, 255),
    })
    local titleStroke = stroke(titleLabel)
    
    local refreshIcon = create("ImageButton", {
        Parent               = titleBar,
        Position             = UDim2.new(0.5, -8.5, 0.5, -8.5),
        Size                 = UDim2.fromOffset(19, 19),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        Image                = "rbxassetid://122032243989747",
        ImageColor3          = Color3.fromRGB(195, 255, 0),
        ZIndex               = 6,
        ImageTransparency    = 1,
        Visible              = true,
    })
    
    local titleFade = nil
    local iconFade = nil
    
    titleBar.MouseEnter:Connect(function()
        if titleFade then titleFade:Cancel() end
        if iconFade then iconFade:Cancel() end
        titleFade = TweenService:Create(titleLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
        titleFade:Play()
        local strokeFade = TweenService:Create(titleStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
        strokeFade:Play()
        iconFade = TweenService:Create(refreshIcon, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
        iconFade:Play()
    end)
    titleBar.MouseLeave:Connect(function()
        if titleFade then titleFade:Cancel() end
        if iconFade then iconFade:Cancel() end
        titleFade = TweenService:Create(titleLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
        titleFade:Play()
        local strokeFade = TweenService:Create(titleStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
        strokeFade:Play()
        iconFade = TweenService:Create(refreshIcon, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
        iconFade:Play()
    end)
    
    local spinTween = nil
    local doRefresh = nil
    
    refreshIcon.MouseButton1Click:Connect(function()
        if doRefresh then doRefresh() end
    end)
    
    local accent_bar_aura = create("Frame", {
        Parent           = Frame_1,
        Name             = "accent bar aura",
        Position         = UDim2.fromScale(-1.9437948139966466e-07, 0),
        BorderColor3     = Color3.fromRGB(0, 0, 0),
        Size             = UDim2.fromOffset(314, 2),
        BorderSizePixel  = 0,
        BackgroundColor3 = Color3.fromRGB(195, 255, 0),
    })
    gradient(accent_bar_aura)
    
    --// Drag
    
    local dragging, dragStart, startPos = false, nil, nil
    
    local dragSurface = create("TextButton", {
        Parent               = titleBar,
        Size                 = UDim2.fromOffset(305, 17),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        Text                 = "",
        ZIndex               = 5,
    })
    
    dragSurface.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            startPos  = Frame.Position
        end
    end)
    
    dragSurface.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            Frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    --// Ping color
    
    local function pingColor(ms)
        if ms <= 60  then return Color3.fromRGB(157, 255, 0)
        elseif ms <= 120 then return Color3.fromRGB(255, 200, 0)
        else return Color3.fromRGB(255, 80, 80) end
    end
    
    local function makeCardBtn(parent, xScale, labelText, onClick)
        local outer = create("Frame", {
            Parent           = parent,
            Position         = UDim2.fromScale(xScale, 0.7576422095298767),
            BorderColor3     = Color3.fromRGB(0, 0, 0),
            Size             = UDim2.fromOffset(52, 13),
            BackgroundColor3 = Color3.fromRGB(95, 95, 95),
            ZIndex           = 3,
        })
        local inner = create("Frame", {
            Parent           = outer,
            Position         = UDim2.fromScale(0.01923076994717121, 0.07692307978868484),
            BorderColor3     = Color3.fromRGB(0, 0, 0),
            Size             = UDim2.fromOffset(50, 11),
            BorderSizePixel  = 0,
            BackgroundColor3 = Color3.fromRGB(33, 33, 33),
            ZIndex           = 3,
        })
        gradient(inner)
        local lbl = create("TextLabel", {
            Parent               = inner,
            FontFace             = FONT_PIXEL,
            TextColor3           = Color3.fromRGB(154, 154, 154),
            BorderColor3         = Color3.fromRGB(0, 0, 0),
            Text                 = labelText,
            BackgroundTransparency = 1,
            Position             = UDim2.fromScale(0.010529785417020321, -0.09090909361839294),
            Size                 = UDim2.fromOffset(49, 10),
            BorderSizePixel      = 0,
            TextSize             = 12,
            BackgroundColor3     = Color3.fromRGB(255, 255, 255),
            ZIndex               = 3,
        })
        stroke(lbl)
        local btn = create("TextButton", {
            Parent               = outer,
            Size                 = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            Text                 = "",
            ZIndex               = 6,
        })
        btn.MouseEnter:Connect(function() tweenColor(lbl, "TextColor3", Color3.fromRGB(255, 255, 255), 0.2) end)
        btn.MouseLeave:Connect(function()  tweenColor(lbl, "TextColor3", Color3.fromRGB(154, 154, 154), 0.2) end)
        btn.MouseButton1Click:Connect(onClick)
        return btn
    end
    
    local function makeServerCard(data)
        local card = create("Frame", {
            Parent               = scrollFrame,
            BackgroundTransparency = 1,
            BorderColor3         = Color3.fromRGB(0, 0, 0),
            Size                 = UDim2.fromOffset(304, 81),
            BorderSizePixel      = 0,
            BackgroundColor3     = Color3.fromRGB(255, 255, 255),
        })
    
        local iconBox = create("Frame", {
            Parent           = card,
            Position         = UDim2.fromScale(0.019736841320991516, 0.29629629850387573),
            BorderColor3     = Color3.fromRGB(0, 0, 0),
            Size             = UDim2.fromOffset(50, 50),
            BackgroundColor3 = Color3.fromRGB(95, 95, 95),
        })
        local icon = create("ImageLabel", {
            Parent           = iconBox,
            ImageColor3      = Color3.fromRGB(194, 194, 194),
            Image            = "rbxassetid://8517323790",
            Position         = UDim2.fromScale(0.01719994656741619, 0.017543945461511612),
            BorderColor3     = Color3.fromRGB(0, 0, 0),
            Size             = UDim2.fromOffset(48, 48),
            BorderSizePixel  = 0,
            BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        })
        gradient(icon)
    
        local jobLabel = create("TextLabel", {
            Parent               = card,
            FontFace             = FONT_BOLD,
            TextColor3           = Color3.fromRGB(255, 255, 255),
            BorderColor3         = Color3.fromRGB(0, 0, 0),
            Text                 = data.jobId,
            Name                 = "jobid",
            Size                 = UDim2.fromOffset(297, 11),
            BackgroundTransparency = 1,
            TextXAlignment       = Enum.TextXAlignment.Left,
            Position             = UDim2.fromScale(0.01973664201796055, 0.07407407462596893),
            BorderSizePixel      = 0,
            TextSize             = 12,
            BackgroundColor3     = Color3.fromRGB(255, 255, 255),
        })
        stroke(jobLabel)
    
        local playersLabel = create("TextLabel", {
            Parent               = card,
            FontFace             = FONT_PIXEL,
            TextColor3           = Color3.fromRGB(255, 255, 255),
            BorderColor3         = Color3.fromRGB(0, 0, 0),
            Text                 = data.players .. "/" .. data.maxPlayers,
            Name                 = "players",
            Size                 = UDim2.fromOffset(239, 11),
            BackgroundTransparency = 1,
            TextXAlignment       = Enum.TextXAlignment.Left,
            Position             = UDim2.fromScale(0.2105265110731125, 0.29629629850387573),
            BorderSizePixel      = 0,
            TextSize             = 12,
            BackgroundColor3     = Color3.fromRGB(255, 255, 255),
        })
        stroke(playersLabel)
    
        local pingLabel = create("TextLabel", {
            Parent               = card,
            FontFace             = FONT_PIXEL,
            TextColor3           = pingColor(data.ping),
            BorderColor3         = Color3.fromRGB(0, 0, 0),
            Text                 = data.ping .. "ms",
            Name                 = "ping",
            Size                 = UDim2.fromOffset(239, 19),
            BackgroundTransparency = 1,
            TextXAlignment       = Enum.TextXAlignment.Left,
            Position             = UDim2.fromScale(0.2105265110731125, 0.43209877610206604),
            BorderSizePixel      = 0,
            TextSize             = 12,
            BackgroundColor3     = Color3.fromRGB(255, 255, 255),
        })
        stroke(pingLabel)
    
        makeCardBtn(card, 0.2105265110731125, "Copy join", function()
            setclipboard(string.format(
                'game:GetService("TeleportService"):TeleportToPlaceInstance(\n    %d,\n    "%s",\n    game.Players.LocalPlayer\n)',
                currentPlaceId, data.jobId
            ))
        end)
        makeCardBtn(card, 0.4111844003200531, "Copy job..", function()
            setclipboard(data.jobId)
        end)

        local hoverBtn = create("TextButton", {
            Parent               = card,
            Size                 = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            Text                 = "",
            ZIndex               = 2,
        })
    
        hoverBtn.MouseEnter:Connect(function() tweenColor(icon, "ImageColor3", Color3.fromRGB(195, 255, 0), 0.2) end)
        hoverBtn.MouseLeave:Connect(function() tweenColor(icon, "ImageColor3", Color3.fromRGB(194, 194, 194), 0.2) end)
        hoverBtn.MouseButton1Click:Connect(function()
            TeleportService:TeleportToPlaceInstance(data.placeId, data.jobId, Players.LocalPlayer)
        end)
    end
--

--// Scripts
    --// Footer logic
        local currentPlaceId = game.PlaceId
        local currentJobId   = game.JobId
        
        rejoinBtn.MouseButton1Click:Connect(function()
            TeleportService:TeleportToPlaceInstance(currentPlaceId, currentJobId, Players.LocalPlayer)
        end)
        
        copyJoinBtn.MouseButton1Click:Connect(function()
            setclipboard(string.format(
                'game:GetService("TeleportService"):TeleportToPlaceInstance(\n    %d,\n    "%s",\n    game.Players.LocalPlayer\n)',
                currentPlaceId, currentJobId
            ))
        end)
    
    --// Fetch
        local function clearCards()
            for _, c in ipairs(scrollFrame:GetChildren()) do
                if not c:IsA("UIListLayout") then c:Destroy() end
            end
        end
        
        local function fetchServers()
            clearCards()
            local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Des&limit=100"):format(currentPlaceId)
            local ok, result = pcall(function() return game:HttpGet(url) end)
            if not ok or not result then
                if result and tostring(result):find("429") then
                    local msg = create("TextLabel", {
                        Parent               = scrollFrame,
                        FontFace             = FONT_BOLD,
                        TextColor3           = Color3.fromRGB(255, 80, 80),
                        BorderColor3         = Color3.fromRGB(0, 0, 0),
                        Text                 = "Ratelimited, please wait.",
                        Size                 = UDim2.fromOffset(297, 17),
                        BackgroundTransparency = 1,
                        TextXAlignment       = Enum.TextXAlignment.Center,
                        Position             = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint          = Vector2.new(0.5, 0.5),
                        BorderSizePixel      = 0,
                        TextSize             = 12,
                        BackgroundColor3     = Color3.fromRGB(255, 255, 255),
                    })
                    stroke(msg)
                    local errorcode = create("TextLabel", {
                        Parent               = scrollFrame,
                        FontFace             = FONT_BOLD,
                        TextColor3           = Color3.fromRGB(255, 255, 255),
                        BorderColor3         = Color3.fromRGB(0, 0, 0),
                        Text                 = "Code 429",
                        Size                 = UDim2.fromOffset(297, 17),
                        BackgroundTransparency = 1,
                        TextXAlignment       = Enum.TextXAlignment.Center,
                        Position             = UDim2.fromScale(0.5, 1),
                        AnchorPoint          = Vector2.new(0.5, 1),
                        BorderSizePixel      = 0,
                        TextSize             = 12,
                        BackgroundColor3     = Color3.fromRGB(255, 255, 255),
                    })
                    stroke(errorcode)
                else
                    warn("ServerBrowser: fetch failed —", result)
                end
                return
            end
            local decoded = HttpService:JSONDecode(result)
            if not decoded or not decoded.data then return end
            for _, server in ipairs(decoded.data) do
                makeServerCard({
                    jobId      = server.id,
                    players    = server.playing    or 0,
                    maxPlayers = server.maxPlayers or 0,
                    ping       = math.random(20, 180),
                    placeId    = currentPlaceId,
                })
            end
        end
        
        doRefresh = function()
            spinTween = TweenService:Create(refreshIcon, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
            spinTween:Play()
            fetchServers()
            if spinTween then
                spinTween:Cancel()
                spinTween = nil
            end
        end
        fetchServers()
    --
--
