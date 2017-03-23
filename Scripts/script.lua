local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')


function Init()
    ForkThread(Create_Easter_Eggs)
end


function Create_Easter_Eggs()
    math.randomseed(1)
    
    local ListOfProps = {}
    local posx, posy = GetMapSize()
    local Map_Area = {
        ["x0"] = 0,
        ["y0"] = 0,
        ["x1"] = posx,
        ["y1"] = posy 
    }

    local i = 1
    local allprops = GetReclaimablesInRect(Map_Area)
    local number_of_props = table.getn(allprops)
    
    if number_of_props == 0 then return end
    
    for _, r in allprops or {} do
        local replaceit = 0
        local propbp = r:GetBlueprint()
        if propbp.ScriptClass == 'Tree' then
            replaceit = 0.035
        elseif string.find(propbp.Interface.HelpText, 'Rock') then  
            replaceit = 0.09
        end
        if number_of_props > 0 then
            replaceit = replaceit * 10000/number_of_props
        end
        if (replaceit > 0) then
            if(math.random(100) < 100 * replaceit) then
                local prop = r
                ListOfProps[i] = prop
                r:Destroy()
                i = i + 1
            end
        end
    end

    local colors = {'Star', 'Yellow', 'Band', 'Kinder', 'Creme', 'pink', 'Red', 'Blue', 'FAF'}
    local new_props = {}
    for _, color in colors do
        new_props[table.getn(new_props)+1] = '/mods/Bunny_Time/props/Egg_' .. color .. '/Egg_' .. color .. '_prop.bp'
    end
    new_props[table.getn(new_props)+1] = '/mods/Bunny_Time/props/Bunny/Bunny_prop.bp'
    
    for _, present in ListOfProps or {} do
        local EggType = math.ceil(math.random(table.getn(new_props)))
        local NewEgg = CreateProp( VECTOR3(present:GetPosition()['x'],
                            present:GetPosition()['y'],
                            present:GetPosition()['z'] ),
                            new_props[EggType])
        
        local presbp = present:GetBlueprint().Economy
        NewEgg:SetMaxReclaimValues( presbp.ReclaimTime/5, presbp.ReclaimMassMax, presbp.ReclaimEnergyMax)
        
        local new_size = presbp.ReclaimMassMax + presbp.ReclaimEnergyMax/10 + math.random(25)
        new_size = 0.02 + 0.06*(new_size-3)/135
        if(new_size < 0.02) then
            new_size = 0.02
        elseif (new_size > 0.076) then
            new_size = 0.076
        end
        
        if EggType == 10 then
            local orient = math.random(628)/100-3.14
            local vec = VECTOR3(math.cos(orient),0,math.sin(orient))
            NewEgg:SetOrientation(OrientFromDir( vec ), true)
            NewEgg:SetScale(3*new_size)
        else
            NewEgg:SetScale(9*new_size)
        end
    end
end