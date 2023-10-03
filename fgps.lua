require 'lib.moonloader'
local imgui = require 'imgui'
local encoding = require 'encoding'
local dlstatus = require('moonloader').download_status
encoding.default = 'CP1251'
u8 = encoding.UTF8

local windowState = imgui.ImBool(false)
local x,y = getScreenResolution()

local combo_test = imgui.ImInt(0)
local combo_test2 = imgui.ImInt(0)
local textBuffer = imgui.ImBuffer(256)
local textnewplace = imgui.ImBuffer(256)
local textnewplaceX = imgui.ImFloat(0)
local textnewplaceY = imgui.ImFloat(0)
local textnewplaceZ = imgui.ImFloat(0)

local addplace = false

local filedirect = getWorkingDirectory().."\\config\\fgps.json"
local file = io.open(filedirect, "r")
a = file:read("*a")
file:close()

local decodedJson = decodeJson(a)
local script_version_text = "1"

-- autoupdate test

local filelink = "https://raw.githubusercontent.com/aufexe/autoupdates/main/update.json"
local fileway = getWorkingDirectory().."\\config\\update.json"

--

function main()
    while not isSampAvailable() do wait(0) end
    sampAddChatMessage("Hello Im Updated!", -1)
    sampRegisterChatCommand('fgps', cmd_find)
    sampRegisterChatCommand('fgpsmenu', cmd_findmenu)
    sampRegisterChatCommand('cords', function()
        X, Y, Z = getCharCoordinates(PLAYER_PED)
        setClipboardText(X .." ".. Y .." ".. Z)
    end)
    downloadUrlToFile(filelink,fileway,function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local fileupdate = io.open(fileway, "r")
            b = fileupdate:read("*a")
            fileupdate:close()
            local updatedecoded = decodeJson(b)
            if updatedecoded["currency_script_version"][1] > decodedJson["script_version"][1] then
                sampAddChatMessage("Åñòü îáíîâëåíèå ñêðèïòà, ñêà÷èâàåì...",-1)
                decodedJson["script_version"][1] = updatedecoded["currency_script_version"][1]
                local encodedJson = encodeJson(decodedJson)
                local file = io.open(filedirect, "w")
                file:write(encodedJson)
                file:flush()
                file:close()
            end
        end
    end)
    
    while true do
        wait(0)
        imgui.Process = windowState.v
        
    end
end

function cmd_find(place)
    for i in ipairs(decodedJson["places"]) do
        if place:find(decodedJson["places"][i]) then
            checkpoint = addBlipForCoord(decodedJson["placesX"][i], decodedJson["placesY"][i], decodedJson["placesZ"][i])
            marker = createCheckpoint(1, decodedJson["placesX"][i], decodedJson["placesY"][i], decodedJson["placesZ"][i], 1, 1, 1, 10)
            lua_thread.create(function()
                repeat
                    wait(0)
                    local x,y,z = getCharCoordinates(PLAYER_PED)
                until getDistanceBetweenCoords3d(x,y,z, decodedJson["placesX"][i], decodedJson["placesY"][i], decodedJson["placesZ"][i]) < 10 or not doesBlipExist(checkpoint)
                deleteCheckpoint(marker)
                removeBlip(checkpoint)
            end)
        end
    end
end

function cmd_findmenu()
    windowState.v = not windowState.v
end

function setDarkStyle()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildWindowRounding = 5
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing = imgui.ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

    colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
    colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.ChildWindowBg]          = ImVec4(0.12, 0.12, 0.12, 1.00);
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
    colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
    colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
    colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
    colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
    colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81);
    colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
    colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
    colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.Button]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
    colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
    colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
    colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
    colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
end

function imgui.OnDrawFrame()
    setDarkStyle()
    imgui.SetNextWindowPos(imgui.ImVec2(x / 2, y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(700, 400), imgui.Cond.FirstUseEver)
    imgui.Begin("FGPS", windowState, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
    imgui.BeginChild('', imgui.ImVec2(350, 385), true)
        imgui.Text(u8"Åñëè ó âàñ íå ðàáîòàåò ïîèñê, ââåäèòå íàçâàíèå âàøåãî..")
        imgui.Text(u8".. ìåñòà íà àíãëèéñêîì.")
        imgui.Combo(u8'Ìåñòà', combo_test, decodedJson["places"], decodedJson[#"places"])
        imgui.InputText(u8'Ââåäèòå íàçâàíèå ìåñòà', textBuffer)
        if imgui.Button(u8'Ñîõðàíèòü íàçâàíèå(ïîìåíÿòü)', imgui.ImVec2(350, 20)) then
            decodedJson["places"][combo_test.v + 1] = textBuffer.v
            local encodedJson = encodeJson(decodedJson)
            local file = io.open(filedirect, "w")
            file:write(encodedJson)
            file:flush()
            file:close()
        end
        if imgui.Button(u8'Äîáàâèòü íîâîå ìåñòî', imgui.ImVec2(350, 20)) then
            addplace = true
        end
        if addplace then
            if imgui.Button(u8"Çàêðûòü", imgui.ImVec2(350, 20)) then
                addplace = false
            end
            imgui.InputText(u8'Ââåäèòå íàçâàíèå ìåñòà(îáåçàòåëüíî íà àíãëèéñêîì)', textnewplace)
            imgui.InputFloat(u8"Êîîðäèíàòû X", textnewplaceX,1,1,3)
            imgui.InputFloat(u8'Êîîðäèíàòû Y', textnewplaceY,1,1,3)
            imgui.InputFloat(u8"Êîîðäèíàòû Z", textnewplaceZ,1,1,3)
            if imgui.Button(u8"Âñòàâèòü òåêóøèå êîîðäèíàòû", imgui.ImVec2(350,20)) then
                local x, y, z = getCharCoordinates(PLAYER_PED)
                textnewplaceX.v = x
                textnewplaceY.v = y
                textnewplaceZ.v = z
            end
            if imgui.Button(u8"Ãîòîâî!", imgui.ImVec2(350, 20)) then
                table.insert(decodedJson["places"], textnewplace.v)
                table.insert(decodedJson["placesX"], textnewplaceX.v)
                table.insert(decodedJson["placesY"], textnewplaceY.v)
                table.insert(decodedJson["placesZ"], textnewplaceZ.v)
                addplace = false
            end
        end
    imgui.EndChild()
    imgui.SameLine()
        imgui.BeginChild('Delete', imgui.ImVec2(350, 385), true)
            imgui.Combo('Ìåñòà äëÿ óäàëåíèÿ', combo_test2, decodedJson["places"], decodedJson[#"places"])
            if imgui.Button(u8"Óäàëèòü ìåñòî(êîòîðîå âûáðàíî âûøå)", imgui.ImVec2(350,20)) then
                table.remove(decodedJson["places"], combo_test2.v + 1)
                table.remove(decodedJson["placesX"], combo_test2.v + 1)
                table.remove(decodedJson["placesY"], combo_test2.v + 1)
                table.remove(decodedJson["placesZ"], combo_test2.v + 1)
                local encodedJson = encodeJson(decodedJson)
                local file = io.open(filedirect, "w")
                file:write(encodedJson)
                file:flush()
                file:close()
            end
        imgui.EndChild()
    imgui.End()
end
