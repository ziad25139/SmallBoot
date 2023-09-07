local g = component.proxy(component.list("gpu")())
local s = component.list("screen")()

local r, e = g.bind(s, true)
if not r then
  error("Failed To Bind Gpu With Screen: "..e)
end

for a,c in pairs(component.list("filesystem")) do
  local f = component.proxy(a)
  if f.exists("/init.lua") then
    i = true
    local h = f.open("/init.lua", "rb")
    local p = f.read(h, f.size("/init.lua"))
    f.close(h)

    ep = component.proxy(component.list("eeprom")())
    computer.getBootAddress = function()
      return ep.getData()
    end
    computer.setBootAddress = function(ad)
      return ep.setData(ad)
    end

    computer.setBootAddress(a)
    computer.beep(1000)
    load(p)()
  end
end

if not i then
  error("No Bootable Medium Was Found")
end