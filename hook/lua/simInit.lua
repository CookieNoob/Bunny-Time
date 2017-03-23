local oldBeginSession = BeginSession
function BeginSession()
    oldBeginSession()
    import('/mods/Bunny_Time/Scripts/script.lua').Init()
end