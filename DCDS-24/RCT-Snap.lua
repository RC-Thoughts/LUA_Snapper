--[[
	---------------------------------------------------------
    Snapper is a easy way to create a Snapper-switch
	
	Possibility to define activation and deactivation points 
	for positive and negative stick-input separately.
	
	Snapper-switch is activated when stick is over activation
	point in either direction. Switch is deactivated when
	stick is returned back over deactivation point.
	
	Localisation-file has to be as /Apps/Lang/RCT-Batt.jsn
	---------------------------------------------------------
	Snapper is part of RC-Thoughts Jeti Tools.
	---------------------------------------------------------
	Released under MIT-license by Tero @ RC-Thoughts.com 2016
	---------------------------------------------------------
--]]
--------------------------------------------------------------------------------
-- Locals for application
local hAct, lAct, hDact, lDact, snapStatus
local hActV, lActV, hDactV, lDactV, uStick
--------------------------------------------------------------------------------
-- Function for translation file-reading
local function readFile(path) 
	local f = io.open(path,"r")
	local lines={}
	if(f) then
		while 1 do 
			local buf=io.read(f,512)
			if(buf ~= "")then 
				lines[#lines+1] = buf
				else
				break   
			end   
		end 
		io.close(f)
		return table.concat(lines,"") 
	end
end 
--------------------------------------------------------------------------------
-- Read translations
local function setLanguage()	
	local lng=system.getLocale();
	local file = readFile("Apps/Lang/RCT-Snap.jsn")
	local obj = json.decode(file)  
	if(obj) then
		trans5 = obj[lng] or obj[obj.default]
	end
end
--------------------------------------------------------------------------------
local function uStickChanged(value)
	uStick = value
	system.pSave("uStick",value)
end
local function hActChanged(value)
	hAct = value
	hActV = (hAct*0.01)
	system.pSave("hAct",value)
end
local function lActChanged(value)
	lAct = value
	lActV = (lAct*0.01)
	system.pSave("lAct",value)
end
local function hDactChanged(value)
	hDact = value
	hDactV = (hDact*0.01)
	system.pSave("hDact",value)
end
local function lDactChanged(value)
	lDact = value
	lDactV = (lDact*0.01)
	system.pSave("lDact",value)
end
--------------------------------------------------------------------------------
-- Draw the main form (Application inteface)
local function initForm()
	form.addRow(1)
	form.addLabel({label="---     RC-Thoughts Jeti Tools      ---",font=FONT_BIG})
	
	form.addRow(2)
	form.addLabel({label=trans5.stk,width=220})
	form.addInputbox(uStick,true,uStickChanged) 
	
	form.addRow(1)
	form.addLabel({label=trans5.stkHelp,width=300,font=FONT_MINI})
	
	form.addRow(2)
	form.addLabel({label=trans5.highAct,width=220})
	form.addIntbox(hAct,-0,100,0,0,1,hActChanged)
	
	form.addRow(2)
	form.addLabel({label=trans5.lowAct,width=220})
	form.addIntbox(lAct,-100,0,0,0,1,lActChanged)
	
	form.addRow(2)
	form.addLabel({label=trans5.highDeAct,width=220})
	form.addIntbox(hDact,-0,100,0,0,1,hDactChanged)
	
	form.addRow(2)
	form.addLabel({label=trans5.lowDeAct,width=220})
	form.addIntbox(lDact,-100,0,0,0,1,lDactChanged)
	
	form.addRow(1)
	form.addLabel({label="Powered by RC-Thoughts.com - v."..snapVersion.." ",font=FONT_MINI, alignRight=true})
end
--------------------------------------------------------------------------------
local function printForm()
	lcd.drawText(203,50,trans5.snapStatus,FONT_MINI)
	lcd.drawText(284,50,snapStatus, FONT_MINI)
end
local function loop()
	if(uStick) then
		stkSnap = system.getInputsVal(uStick)
		if((stkSnap) and stkSnap > -1.0 and stkSnap < 1.0 and (hAct) and (lAct) and (hDact) and (lDact)) then
			if(stkSnap < lActV or stkSnap > hActV) then
				system.setControl(1,1,0,0)
				snapStatus = "On"
				else
				if(stkSnap > lDactV and stkSnap < hDactV) then
					system.setControl(1,0,0,0)
					snapStatus = "Off"
				end
			end
			else
		end
	end
end
--------------------------------------------------------------------------------
local function init()
	system.registerForm(1,MENU_APPS, trans5.appName,initForm,nil,printForm)
	uStick = system.pLoad("uStick")
	lAct = system.pLoad("lAct",0)
	hAct = system.pLoad("hAct",0)
	lDact = system.pLoad("lDact",0)
	hDact = system.pLoad("hDact",0)
	hActV = (hAct*0.01)
	lActV = (lAct*0.01)
	hDactV = (hDact*0.01)
	lDactV = (lDact*0.01)
	snapStatus = "Off"
	system.unregisterControl(1)
	system.registerControl(1,trans5.ctrlName,trans5.ctrlNameSh)
	system.setControl(1,0,0,0)
end
--------------------------------------------------------------------------------
snapVersion = "1.1"
setLanguage()
return {init=init,loop=loop,author="RC-Thoughts",version=snapVersion,name=trans5.appName} 	