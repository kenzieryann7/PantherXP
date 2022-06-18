-- Source: https://www.esoui.com/downloads/info7-LibAddonMenu.html

-- ########################################################################################################
-- Initialize PantherXP Settings using LibAddonMenu2
-- ########################################################################################################
function PXP.initSettings()
    local LAM = LibAddonMenu2
    if LAM == nil then return end

    local Default = PXP.default
    local Settings = PXP.sv

    local panelName = "PXPPanel" 

    local panelData = {
        type = "panel",
        name = "PantherXP Settings",
        author = PXP.author,
        version = PXP.version,
        feedback = PXP.feedback
    }

    local panel = LAM:RegisterAddonPanel(panelName, panelData)

    local optionsData = {
        -- ReloadUI Button
        {
            type = "button",
            name = "ReloadUI",
            tooltip = "Click to reload UI",
            func = function() ReloadUI("ingame") end,
            width = "half",
        },
        -- XP Bar Options
        {
            type = "description",
            text = "XP BAR - After changing, you must reload the UI.",
            width = "full",
        },
        {
            type = "checkbox",
            name = "Show XP Bar",
            getFunc = function() return Settings.showXPBar end,
            setFunc = function(value) Settings.showXPBar = value end,
            width = "half",
            default = Default.showXPBar,
        }
    }
    LAM:RegisterOptionControls(panelName, optionsData)
end

-- ########################################################################################################
-- Display XP Bar
-- Takes a true or false value
-- ########################################################################################################
function PXP.ShowXPBar()
    if PXPSV.Default[GetDisplayName()]['$AccountWide'].showXPBar == true then
        SCENE_MANAGER:GetScene("hud"):AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
        SCENE_MANAGER:GetScene("hudui"):AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
        SCENE_MANAGER:GetScene("hud"):AddFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
        SCENE_MANAGER:GetScene("hudui"):AddFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
    end
end
