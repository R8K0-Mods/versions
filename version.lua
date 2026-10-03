--============================================================--
--                         R8K0 MODS                          --
--                      Version Checker                       --
--============================================================--

local ScriptName = 'R8K0 Test Resource'
local CurrentVersion = '1.0.1'
local VersionFile = 'test-resource.txt'

local VersionBaseURL =
    'https://raw.githubusercontent.com/R8K0-Mods/versions/refs/heads/main/'

local VersionURL = VersionBaseURL .. VersionFile

--============================================================--
--                    VERSION PARSER                           --
--============================================================--

local function ParseVersion(version)
    if not version then
        return nil
    end

    version = tostring(version)
        :gsub('\r', '')
        :gsub('\n', '')
        :gsub('%s+', '')

    local major, minor, patch =
        version:match('^(%d+)%.(%d+)%.(%d+)$')

    if not major or not minor or not patch then
        return nil
    end

    return {
        major = tonumber(major),
        minor = tonumber(minor),
        patch = tonumber(patch)
    }
end

--============================================================--
--                   VERSION COMPARISON                        --
--============================================================--

local function CompareVersions(current, latest)
    local currentVersion = ParseVersion(current)
    local latestVersion = ParseVersion(latest)

    if not currentVersion or not latestVersion then
        return nil
    end

    --  1 = GitHub/public version is newer
    --  0 = Versions are identical
    -- -1 = Installed version is newer

    if latestVersion.major > currentVersion.major then
        return 1
    elseif latestVersion.major < currentVersion.major then
        return -1
    end

    if latestVersion.minor > currentVersion.minor then
        return 1
    elseif latestVersion.minor < currentVersion.minor then
        return -1
    end

    if latestVersion.patch > currentVersion.patch then
        return 1
    elseif latestVersion.patch < currentVersion.patch then
        return -1
    end

    return 0
end

--============================================================--
--                      CONSOLE HEADER                         --
--============================================================--

local function PrintHeader()
    print('^5================================================================^7')
    print('^5                           R8K0 MODS                            ^7')
    print('^5================================================================^7')
    print(('^7Resource: ^5%s^7'):format(ScriptName))
    print(('^7Version:  ^5%s^7'):format(CurrentVersion))
end

--============================================================--
--                      CONSOLE FOOTER                         --
--============================================================--

local function PrintFooter()
    print('^5----------------------------------------------------------------^7')
    print('^7                    Powered by ^5R8K0 Mods^7')
    print('^5================================================================^7')
end

--============================================================--
--                       VERSION CHECK                         --
--============================================================--

local function CheckVersion()

    PerformHttpRequest(VersionURL, function(statusCode, response)

        PrintHeader()

        -- GitHub request failed
        if statusCode ~= 200 or not response then

            print('^1Status: Unable to check for updates.^7')
            print(('^7HTTP Code: ^1%s^7'):format(
                statusCode or 'Unknown'
            ))

            PrintFooter()
            return
        end

        -- Clean GitHub response
        local LatestVersion = tostring(response)
            :gsub('\r', '')
            :gsub('\n', '')
            :gsub('%s+', '')

        -- Validate versions
        if not ParseVersion(CurrentVersion) then

            print('^1Status: Invalid installed version format.^7')
            print(('^7Installed: ^1%s^7'):format(
                CurrentVersion
            ))

            PrintFooter()
            return
        end

        if not ParseVersion(LatestVersion) then

            print('^1Status: Invalid GitHub version format.^7')
            print(('^7GitHub Response: ^1%s^7'):format(
                LatestVersion
            ))

            PrintFooter()
            return
        end

        local comparison =
            CompareVersions(CurrentVersion, LatestVersion)

        --====================================================--
        -- UP TO DATE
        --====================================================--

        if comparison == 0 then

            print('^2Status: Up to date!^7')
            print(('^7Latest:  ^2%s^7'):format(
                LatestVersion
            ))

        --====================================================--
        -- UPDATE AVAILABLE
        --====================================================--

        elseif comparison == 1 then

            print('^3Status: Update available!^7')
            print(('^7Current: ^1%s^7'):format(
                CurrentVersion
            ))
            print(('^7Latest:  ^2%s^7'):format(
                LatestVersion
            ))

        --====================================================--
        -- DEVELOPMENT / NEWER BUILD
        --====================================================--

        elseif comparison == -1 then

            print('^5Status: Development version detected.^7')
            print(('^7Installed: ^5%s^7'):format(
                CurrentVersion
            ))
            print(('^7Public:    ^2%s^7'):format(
                LatestVersion
            ))

        else

            print('^1Status: Unable to compare versions.^7')

        end

        PrintFooter()

    end, 'GET')

end

--============================================================--
--                           START                             --
--============================================================--

CreateThread(function()

    -- Small delay so the version message appears cleanly
    -- after the resource starts.
    Wait(1500)

    CheckVersion()

end)