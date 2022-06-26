-- ########################################################################################################
-- PantherXP
-- Author: Rynzaii
-- The MIT License
--
-- ########################################################################################################


-- ########################################################################################################
-- Initialize PantherXP Settings using LibAddonMenu2
-- Source: https://www.esoui.com/downloads/info7-LibAddonMenu.html
--
-- ########################################################################################################
function PXP.initSettings()
    local LAM = LibAddonMenu2
    if LAM == nil then return end

    local Default = PXP.default
    local Settings = PXP.sv

    -- Get fonts (Local in-game fonts)
    local FontsList = {}
    for f in pairs(PXP.fontsList) do
        table.insert(FontsList, f)
    end

    local panelName = "PXPPanel" 

    local panelData = {
        type = "panel",
        name = "PantherXP Settings",
        author = PXP.author,
        version = PXP.version,
        feedback = PXP.feedback,
        donation = PXP.donation
    }

    local panel = LAM:RegisterAddonPanel(panelName, panelData)

    local optionsData = {
        {
            -- Reload UI Button
            type = "button",
            name = "ReloadUI",
            tooltip = "Click to reload UI",
            func = function() ReloadUI("ingame") end,
            width = "half",
        },
        {
            -- Reset Settings to Default Settings
            type = "button",
            name = "Reset Default",
            tooltip = "Click to reset Settings to Default",
            warning = "After reseting, you must reload the UI for changes to take effect.",
            func = function() PXP.ResetDefaultSettings() end,
            width = "half",
        },
        {
            type = "header",
            name = "XP Bar",
        },
        {
            -- Check to display XP Bar
            type = "checkbox",
            name = "Show XP Bar",
            tooltip = "Always display the XP Bar.",
            getFunc = function() return Settings.showXPBar end,
            setFunc = function(value) Settings.showXPBar = value PXP.UpdateSettings() end,
            width = "full",
            default = Default.showXPBar,
        },
        {
            -- Check to show XP Label
            type = "checkbox",
            name = "Show XP Label [Player XP / Player MaxXP]",
            tooltip = "Displays player's current and max XP values.",
            getFunc = function() return Settings.showXPLabel end,
            setFunc = function(value) Settings.showXPLabel = value PXP.UpdateSettings() end,
            width = "full",
            default = Default.showXPLabel,
        },
        {
            -- Check to display XP Percentage beside the XP Label
            type = "checkbox",
            name = "Show XP Percentage [%]",
            tooltip = "Display XP Percentage to the right of existing XP values.",
            getFunc = function() return Settings.showXPPercentage end,
            setFunc = function(value) Settings.showXPPercentage = value PXP.UpdateSettings() end,
            width = "full",
            default = Default.showXPPercentage,
        },
        {
            -- Check formatting for XP Label
            type = "dropdown",
            name = "XP Label Formatting",
            tooltip = "Select a format for displaying XP values.",
            warning = "Note: Abbreviating Long XP values is a Champion only setting.",
            choices = PXP.labelFormats,
            getFunc = function() return Settings.XPLabelFormat end,
            setFunc = function(value) Settings.XPLabelFormat = value end,
            width = "full",
            default = Default.XPLabelFormat
        },
        {
            -- Check selected Font Size
            type = "slider",
            name = "Font Size",
            tooltip = "Set size of XP Label.",
            min = 10, max = 30, step = 1,
            getFunc = function() return Settings.defaultFontSize end,
            setFunc = function(value) Settings.defaultFontSize = value PXP.SetSeletedFont() end,
            width = "full",
            default = Default.defaultFontSize,
        },
        {
            -- Check selected Font Type
            type = "dropdown",
            scrollable = true,
            name = "Font",
            tooltip = "Select a font from a list of in-game fonts.",
            choices = FontsList,
            sort = "name-up",
            getFunc = function() return Settings.defaultFontName end,
            setFunc = function(var) Settings.defaultFontName = var PXP.SetSeletedFont() end,
            width = "full",
            default = Default.defaultFontName,
        }
    }

    -- Register settings with option data above
    LAM:RegisterOptionControls(panelName, optionsData)
end


-- Setting Functions

-- ########################################################################################################
-- Display XP Bar
--  - Takes a true or false value
--
-- ########################################################################################################
function PXP.ShowXPBar()
    if PXPSV.Default[GetDisplayName()]['$AccountWide'].showXPBar == true then
        SCENE_MANAGER:GetScene("hud"):AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
        SCENE_MANAGER:GetScene("hudui"):AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
        SCENE_MANAGER:GetScene("hud"):AddFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
        SCENE_MANAGER:GetScene("hudui"):AddFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
    else
        SCENE_MANAGER:GetScene("hud"):RemoveFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
        SCENE_MANAGER:GetScene("hudui"):RemoveFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
        SCENE_MANAGER:GetScene("hud"):RemoveFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
        SCENE_MANAGER:GetScene("hudui"):RemoveFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
    end
end


-- ########################################################################################################
-- Get Player's Current XP
--
-- ########################################################################################################
function PXP.GetPlayerXP()
    -- If player is champion, get champion point current XP
	if IsUnitChampion("player") then
		return GetPlayerChampionXP()

    -- If not champion, get normal player current XP
	else
        return GetUnitXP("player")
	end
end


-- ########################################################################################################
-- Get Player's Max XP
--
-- ########################################################################################################
function PXP.GetPlayerXPMax()

    -- If player is champion, get champion point max XP
	if IsUnitChampion("player") then
		local cp = GetUnitChampionPoints("player")

		if cp < GetChampionPointsPlayerProgressionCap() then
			cp = GetChampionPointsPlayerProgressionCap()
		end

		return GetNumChampionXPInChampionPoint(cp)

    -- If not champion, get normal player max XP
	else
        return GetUnitXPMax("player")

	end
end


-- ########################################################################################################
-- Calculate XP Percentage
--  - 100 * (Player_CurrentXP / Player_MaxXP) = Player_PercentageXP
--
-- ########################################################################################################
function PXP.GetPlayerXPPercent(currXP, maxXP)
    local percXP = 0
    
    if maxXP > 0 then
        percXP = 100 * (currXP / maxXP)
    else    
        maxXP = "MAX"
    end

    return percXP
end


-- ########################################################################################################
-- Create XP Label
--  - Clear all existing anchors (will be set during RefreshLabelOnUpdate function)
--  - Draw controls, then set font based on selected font from settings
--
-- ########################################################################################################
function PXP.CreateXPLabel(font)
    if PXPSV.Default[GetDisplayName()]['$AccountWide'].showXPLabel then
        PantherXPText:ClearAnchors()
        PantherXP:SetDrawTier(DT_HIGH)
        PantherXP:SetDrawLayer(DL_OVERLAY)

        -- Check selected font face and font size
        if font == "Default" then
            PantherXPText:SetFont(PXP.fontsList[font] .. "|" .. PXPSV.Default[GetDisplayName()]['$AccountWide'].defaultFontSize .. "|soft-shadow-thin")

        elseif font == "Univers 67" or font == "Trajan Pro" then
            PantherXPText:SetFont(PXP.fontsList[font] .. "|" .. PXPSV.Default[GetDisplayName()]['$AccountWide'].defaultFontSize .. "|soft-shadow-thick")

        else
            PantherXPText:SetFont(PXP.fontsList[font] .. "|" .. PXPSV.Default[GetDisplayName()]['$AccountWide'].defaultFontSize)
        end
    end
end


-- ########################################################################################################
-- Refresh XP text label to reflect updated values when XP Bar updates
--
-- ########################################################################################################
function PXP.RefreshLabelOnUpdate()
    -- Local variables to get player's current XP, max XP, and XP percent values
    local playerPercent = PXP.GetPlayerXPPercent(PXP.GetPlayerXP(), PXP.GetPlayerXPMax()) --PXP.commaSplitter()
    local playerCurrXP
    local playerMaxXP

    -- Check if XP Label should be abbreviated (only available for Champion and if XP Label is not formatted)
    if IsUnitChampion("player") and PXPSV.Default[GetDisplayName()]['$AccountWide'].XPLabelFormat == "Abbreviate Long XP values [Champion only]"  then
        -- Gets XP value rounded to the tenths place
        playerCurrXP = math.floor(PXP.GetPlayerXP() / 100) * 0.1 .. "k"
        playerMaxXP = math.floor(PXP.GetPlayerXPMax() / 100) * 0.1 .. "k"

    elseif PXPSV.Default[GetDisplayName()]['$AccountWide'].XPLabelFormat == "Format with commas" then
        playerCurrXP = PXP.commaSplitter(PXP.GetPlayerXP())
        playerMaxXP = PXP.commaSplitter(PXP.GetPlayerXPMax())
    else
        playerCurrXP = PXP.GetPlayerXP()
        playerMaxXP = PXP.GetPlayerXPMax()
    end

    -- Check if XP Label should be displayed
    if PXPSV.Default[GetDisplayName()]['$AccountWide'].showXPLabel == true then
        PantherXPText:SetHidden(false)

        -- Check if XP percent should be displayed
        if PXPSV.Default[GetDisplayName()]['$AccountWide'].showXPPercentage == true then
            PantherXPText:SetAnchor(CENTER, ZO_PlayerProgressBar, CENTER, 0, -1)
            PantherXPText:SetText(zo_strformat("<<1>> / <<2>> XP [<<3>>%]", playerCurrXP, playerMaxXP, playerPercent))
        
        -- If XP Percentage setting is to not be displayed, do:
        else
            PantherXPText:SetAnchor(CENTER, ZO_PlayerProgressBar, CENTER, 0, -1)
            PantherXPText:SetText(zo_strformat("<<1>> / <<2>> XP", playerCurrXP, playerMaxXP))
        end

    else
        PantherXPText:SetHidden(true)
    end
end


-- ########################################################################################################
-- Update PantherXP Settings on change
--
-- ########################################################################################################
function PXP.UpdateSettings()
    PXP.ShowXPBar()
    PXP.CreateXPLabel(PXPSV.Default[GetDisplayName()]['$AccountWide'].defaultFontName)
    PXP.RefreshLabelOnUpdate()
end


-- ########################################################################################################
-- Reset PantherXP to the Default Settings
--
-- ########################################################################################################
function PXP.SetSeletedFont()
    -- First try setting player's selected font
    local fontName = PXP.fontsList[PXP.defaultFontName]

    -- If font cannot be set, set to default font
    if not fontName or fontName == "" then
        fontName = "Default" -- ZoFontGameBold
    end

    PXP.UpdateSettings()
end


-- ########################################################################################################
-- Reset PantherXP to the Default Settings
--
-- ########################################################################################################
function PXP.ResetDefaultSettings() 
    PXP.sv = ZO_SavedVars:NewAccountWide(PXP.svName, PXP.svVersion - 1, nil, PXP.default)
end


-- ########################################################################################################
-- Format numbers with commas as needed.
--  - Anything passed 1000 --> 1,000
--
-- ########################################################################################################
function PXP.commaSplitter(amount)
    local formatted = amount

    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end

    return formatted
end
