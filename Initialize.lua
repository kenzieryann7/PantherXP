-- ########################################################################################################
-- PXP Initialization
-- ########################################################################################################

local eventManager = EVENT_MANAGER
local zo_strformat = zo_strformat

-- ########################################################################################################
-- Load saved settings
-- ########################################################################################################
local function LoadSavedVars()
    -- Addon options
    PXP.sv = ZO_SavedVars:NewAccountWide(PXP.svName, PXP.svVersion, nil, PXP.default)

    -- PXP.sv = ZO_SavedVars:NewCharacterIdSettings("PXPSV", PXP.svVersion, nil, PXP.default)

    if PXP.sv.CharacterSpecificSV then
        PXP.sv = ZO_SavedVars:New(PXP.svName, PXP.svVersion, nil, PXP.default)
    end
end

-- ########################################################################################################
-- Loading only PantherXP
-- ########################################################################################################
local function OnAddonOnLoaded(eventCode, addonName)
    if PXP.name ~= addonName then
        return
    end
    eventManager:UnregisterForEvent(addonName, eventCode)

    -- Load saved variables
    LoadSavedVars()

    -- Init Settings menu using LibAddonMenu-2.0
    PXP.initSettings()

    ZO_PreHookHandler(ZO_PlayerProgressBar, 'OnUpdate', PXP.ShowXPBar)

    PXP.ShowXPBar()

end

-- ########################################################################################################
-- Hook initialization
-- ########################################################################################################
eventManager:RegisterForEvent(PXP.name, EVENT_ADD_ON_LOADED, OnAddonOnLoaded)