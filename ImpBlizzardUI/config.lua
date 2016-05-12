--[[
    ImpBlizzardUI/config.lua
    Handles the various config settings within ImpBlizzardUI and builds the config panes.

    Notes: LoadConfig & ApplyChanges are called for all panels no matter which is in focus at that time.
           SetDefaults is called individually or globally depending on player input
]]

local _, ImpBlizz = ...;

local MiscConfig = {};
local PvPConfig = {};

-- Load Fonts and set the sizes etc
local Font = "Interface\\Addons\\ImpBlizzardUI\\media\\impfont.ttf";
local CheckBoxFontSize = 14;
local CheckBoxOffset = -30;
local HeaderFontSize = 16;

-- Simply checks if any of the options have changed. This is basically a huge if statement
local function ConfigChanged()
    if(Conf_AutoRepair ~= MiscConfig.panel.autoRepair:GetChecked() or Conf_GuildBankRepair ~= MiscConfig.panel.guildRepair:GetChecked()) then
        return true;
    else
        return false;
    end
end

--[[
    Primary Window Config Stuff Begins
]]
-- Reset all options to the default settings
local function SetDefaults_Primary()
    MiscConfig.panel.autoRepair:SetChecked(true);
    MiscConfig.panel.guildRepair:SetChecked(true);
end

-- Loads the already set config options for the Primary window
local function LoadConfig_Primary()
    MiscConfig.panel.autoRepair:SetChecked(Conf_AutoRepair);
    MiscConfig.panel.guildRepair:SetChecked(Conf_GuildBankRepair);
end

-- Applies any changes
local function ApplyChanges_Primary()
    if(ConfigChanged()) then
        Conf_AutoRepair = MiscConfig.panel.autoRepair:GetChecked();
        Conf_GuildBankRepair = MiscConfig.panel.guildRepair:GetChecked();

        ReloadUI();
    end
end

-- Event Handler, Only used for detecting when the addon has finished initialising and trigger config loading
local function HandleEvents(self, event, ...)
    if(event == "ADDON_LOADED" and ... == "ImpBlizzardUI") then
        LoadConfig_Primary();
        LoadConfig_PvP();
    end
end

-- Builds the Primary (Misc Settings) Config Panel - Parent to all other panels
local function BuildWindow_Primary()
    MiscConfig.panel = CreateFrame("Frame", "ImpBlizzardUI_Misc", UIParent);
    MiscConfig.panel.name = "Improved Blizzard UI";
    MiscConfig.panel.okay = ApplyChanges_Primary;
    MiscConfig.panel.cancel = LoadConfig_Primary;
    MiscConfig.panel.default = SetDefaults_Primary;

    -- Register the event handler and addon loaded event
    MiscConfig.panel:SetScript("OnEvent", HandleEvents);
    MiscConfig.panel:RegisterEvent("ADDON_LOADED");

    -- Title
    MiscConfig.panel.titleText = MiscConfig.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    MiscConfig.panel.titleText:SetFont(Font, 18, "OUTLINE");
    MiscConfig.panel.titleText:SetPoint("TOPLEFT", 5, -10);
    MiscConfig.panel.titleText:SetText("|cffffff00 Improved Blizzard UI:- Miscellaneous Config");

    -- Auto Repair Checkbox
    MiscConfig.panel.autoRepair = CreateFrame("CheckButton", "RepairCheckBox", MiscConfig.panel, "UICheckButtonTemplate");
    MiscConfig.panel.autoRepair:ClearAllPoints();
    MiscConfig.panel.autoRepair:SetPoint("TOPLEFT", 5, -250);
    _G[MiscConfig.panel.autoRepair:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[MiscConfig.panel.autoRepair:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["Auto Repair"]);

    -- Guild Bank Repair Checkbox
    MiscConfig.panel.guildRepair = CreateFrame("CheckButton", "GuildRepairCheckBox", MiscConfig.panel, "UICheckButtonTemplate");
    MiscConfig.panel.guildRepair:ClearAllPoints();
    MiscConfig.panel.guildRepair:SetPoint("TOPLEFT", 5, -280);
    _G[MiscConfig.panel.guildRepair:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[MiscConfig.panel.guildRepair:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["Use Guild Bank For Repairs"]);
end
--[[
    Primary Window Config Stuff Ends
]]

--[[
    Primary PvP Config Stuff Begins
]]
local function SetDefaults_PvP()

end

local function LoadConfig_PvP()

end

local function ApplyChanges_PvP()

end

local function BuildWindow_PvP()
    PvPConfig.panel = CreateFrame("Frame", "ImpBlizzardUI_PvP", MiscConfig.panel);
    PvPConfig.panel.name = "PvP";
    PvPConfig.panel.parent = MiscConfig.panel.name;
    PvPConfig.panel.okay = ApplyChanges_PvP;
    PvPConfig.panel.cancel = LoadConfig_PvP;
    PvPConfig.panel.default = SetDefaults_PvP;
end
--[[
    Primary PvP Config Stuff Ends
]]

-- Initialise the Config System
local function Init()
    BuildWindow_Primary();
    BuildWindow_PvP();
end

-- End of File, Call Init and then add the config to the Blizzard Interface Options window
Init();
InterfaceOptions_AddCategory(MiscConfig.panel);
InterfaceOptions_AddCategory(PvPConfig.panel);
