--========================================================--
--                       R8K0 MODS                        --
--                    Version Checker                     --
--========================================================--

local ScriptName = 'R8K0 Version Test'
local CurrentVersion = '1.0.1'
local VersionFile = 'test-resource.txt'

local VersionURL =
    'https://raw.githubusercontent.com/R8K0-Mods/versions/refs/heads/main/'
    .. VersionFile

local function PrintHeader()
    print('^5============================================================^7')
    print('^5                         R8K0 MODS                          ^7')
    print('^5============================================================^7')
    print(('^7Resource: ^5%s^7'):format(ScriptName))
    print(('^7Version:  ^5%s^7'):format(CurrentVersion))
end

local function CheckVersion()
    PerformHttpRequest(VersionURL, function(statusCode, response)
        PrintHeader()

        if statusCode ~= 200 or not response then
            print('^1Status: Unable to check for updates.^7')
            print(('^1HTTP Code: %s^7'):format(statusCode or 'Unknown'))
            print('^5============================================================^7')
            return
        end

        local LatestVersion = response:gsub('%s+', '')

        if LatestVersion == '' then
            print('^1Status: Invalid version response.^7')
            print('^5============================================================^7')
            return
        end

        if CurrentVersion == LatestVersion then
            print('^2Status: Up to date!^7')
        else
            print('^3Status: Update available!^7')
            print(('^7Current: ^1%s^7'):format(CurrentVersion))
            print(('^7Latest:  ^2%s^7'):format(LatestVersion))
        end

        print('^5------------------------------------------------------------^7')
        print('^7                  Powered by ^5R8K0 Mods^7')
        print('^5============================================================^7')
    end, 'GET')
end

CreateThread(function()
    Wait(1000)
    CheckVersion()
end)