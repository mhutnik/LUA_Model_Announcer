--[[
    ---------------------------------------------------------
    
    Model Announcer plays a selcted voicefile when model is
    changed or transmitter powered on. 
    
    Custom voicefiles can be made for free at RC-Thoughts 
    text-To-Speech service at https://www.rc-thoughts.com/tts/
    
    Model Announcer requires firmware 4.22 or newer.
    
    Localisation-file has to be as /Apps/Lang/RCT-MAnn.jsn
    
    ---------------------------------------------------------
    Released under MIT-license by Tero @ RC-Thoughts.com 2017
    ---------------------------------------------------------
--]]
collectgarbage()
--------------------------------------------------------------------------------
-- Locals for application
local delayTime, done, audioFile = 0, false
--------------------------------------------------------------------------------
-- Load translation
local function setLanguage()
    local lng=system.getLocale()
    local file = io.readall("Apps/Lang/RCT-MAnn.jsn")
    local obj = json.decode(file)
    if(obj) then
        trans12 = obj[lng] or obj[obj.default]
    end
    collectgarbage()
end
--------------------------------------------------------------------------------
-- Functions for settings-change
local function audioFileChanged(value)
    audioFile = value
    system.pSave("audioFile", value)
end

local function delayTimeChanged(value)
    delayTime=value
    system.pSave("delayTime", value)
end
--------------------------------------------------
-- Create the main form (Application interface)
local function initForm()
    form.addRow(1)
    form.addLabel({label="---   RC-Thoughts Jeti Tools    ---",font=FONT_BIG})
    
    form.addRow(2)
    form.addLabel({label=trans12.audioFileSel})
    form.addAudioFilebox(audioFile, audioFileChanged)
    
    form.addRow(2)
    form.addLabel({label=trans12.delayTime})
    form.addIntbox(delayTime, 0, 60, 0, 0, 1, delayTimeChanged)
    
    form.addRow(1)
    form.addLabel({label="Powered by RC-Thoughts.com - v."..modAnnVersion.." ", font=FONT_MINI, alignRight=true})
    collectgarbage()
end
--------------------------------------------------------------------------------
-- Time-function for initialization
local function setTime()
    curTime = system.getTime()
    annTime = curTime + delayTime
    done = false
    collectgarbage()
end
--------------------------------------------------------------------------------
-- Runtime loop
local function loop()
    local curTime = system.getTime()
    if(not done and curTime > annTime) then
        if(audioFile ~= "...") then
            system.playFile(audioFile, AUDIO_QUEUE)
        end
        done = true
    end
end
--------------------------------------------------------------------------------
-- App initialization
local function init()
    local pLoad = system.pLoad
    audioFile = pLoad("audioFile", "...")
    delayTime = pLoad("delayTime", 0)
    setTime()
    system.registerForm(1, MENU_APPS, trans12.appName, initForm, nil)
    collectgarbage()
end
--------------------------------------------------------------------------------
modAnnVersion = "1.0"
setLanguage()
return {init=init, loop=loop, author="RC-Thoughts", version=modAnnVersion, name=trans12.appName}