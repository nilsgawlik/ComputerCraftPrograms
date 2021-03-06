ores = {}

maxdepth = 128
cw = 4
delta = 3

time = os.clock()

function save(string)
  local file = fs.open("automine_save","w")
  file.write(string)
  file.close()
end
function load()
  local file = fs.open("automine_save", "r")
  local cont = file.readAll()
  file.close()
  return cont
end

function carefulDig()
    repeat until not turtle.dig()
end
function carefulDigUp()
    repeat until not turtle.digUp()
end
function carefulDigDown()
    turtle.digDown()
end

function addOre(blockname)
  ores[blockname] = true
end

function isOre(blockname)
  if blockname == nil then 
    return false
  end
  if ores[blockname] ~= nil then
    return true
  end
  if string.find(blockname, "ore") ~= nil or string.find(blockname, "Ore") ~= nil then
    return true
  end
  return false
end

--addOre("minecraft:iron_ore")
--addOre("minecraft:coal_ore")
--addOre("minecraft:lapis_ore")
--addOre("minecraft:diamond_ore")
--addOre("minecraft:gold_ore")
--addOre("minecraft:redstone_ore")
--addOre("minecraft:emerald_ore")

addOre("denseores:block0")
addOre("TConstruct:SearedBrick")
addOre("ProjRed|Exploration:projectred.exploration.ore")
addOre("BiomesOPlenty:gemOre")
addOre("Forestry:resources")
addOre("IC2:blockOreCopper")
addOre("IC2:blockOreTin")
addOre("IC2:blockOreUran")
addOre("IC2:blockOreLead")
addOre("DraconicEvolution:draconiumOre")
addOre("ImmersiveEngineering:ore")
addOre("rftools:dimensionalShardBlock")
addOre("ImmersiveEngineering:ore")
addOre("BiomesOPlenty:gemOre")
addOre("BigReactors:YelloriteOre")
addOre("Forestry:resources")
addOre("minecraft:redstone_ore")
addOre("ProjRed|Exploration:projectred.exploration.ore")
addOre("Railcraft:ore")
addOre("TConstruct:SearedBrick")
addOre("TConstruct:GravelOre")
addOre("Thaumcraft:blockCustomOre")
addOre("ThermalFoundation:Ore")
addOre("aobd:oreSteel")
addOre("aobd:oreIridium")
addOre("appliedenergistics2:tile.OreQuartzCharged")
addOre("appliedenergistics2:tile.OreQuartz")
addOre("denseores:block0")
addOre("harvestcraft:salt")
addOre("minecraft:emerald_ore")
addOre("minecraft:quartz_ore")
addOre("BiomesOPlenty:biomeBlock")
addOre("minecraft:gold_ore")
addOre("minecraft:coal_ore")
addOre("minecraft:lapis_ore")
addOre("minecraft:diamond_ore")
addOre("BiomesOPlenty:gemOre")
addOre("minecraft:iron_ore")
addOre("BiomesOPlenty:gemOre")
addOre("IC2:blockOreLead")
addOre("NetherOres:tile.netherores.ore.1")
addOre("DraconicEvolution:draconiumOre")
addOre("lipVulpes:lipVulpesore0")


function oreFront()
  print("checking front")
  local success, data = turtle.inspect()
  return isOre(data.name)
end
function oreUp()
  print("checking up")
  local success, data = turtle.inspectUp()
  return isOre(data.name)
end
function oreDown()
  print("checking down")
  local success, data = turtle.inspectDown()
  return isOre(data.name)
end
function bedrockDown()
  print("checking br")
  local success, data = turtle.inspectDown()
  return data.name == "minecraft:bedrock"
end

function gox(len)
  for i=1,len do
    while turtle.detect() do
      turtle.dig()
    end
    turtle.forward()
  end
end


function recMine()
  for i=1,4 do 
    if oreFront() then
      carefulDig()
      turtle.forward()
      recMine()
      turtle.back()
    end
    turtle.turnLeft() 
  end
  if oreUp() then
    carefulDigUp()
    turtle.up()
    recMine()
    turtle.down()
  end
  if oreDown() then
    carefulDigDown()
    turtle.down()
    recMine()
    turtle.up()
  end
end


function dump()
  for i=2,16 do 
    turtle.select(i)
    turtle.drop()
  end
end

function refuel()
  turtle.select(1)
  local item = turtle.getItemDetail()
  turtle.refuel(item.count - 1)
end

function printTime()
  print("seconds: " .. (os.clock()-time))
  time = os.clock()
end

function cleanInv()
  --for i=2,16 do
  --  if turtle.getItemCount(i) > 0 then
  --    local item = turtle.getItemDetail(i)
   --   if not isOre(item.name) then
   --     turtle.select(i)
   --     turtle.dropDown()
   --     print("not ore: " .. item.name)
  --    end
 --   end
--  end
 -- turtle.select(1)
end

function shaft()
  depth = 0
  
  while not (bedrockDown() or depth > maxdepth) do
    if turtle.getFuelLevel() < 100 then
      refuel()
    end
    carefulDigDown()
    turtle.down()
    depth = depth + 1
    recMine()
    cleanInv()
  end
  
  while depth > 0 do
    depth = depth - 1
    turtle.up()
  end
end


for line = 0,(cw-1) do
  for x = 0,(cw-1) do
    gox(line*delta)
    turtle.turnLeft()
    
    gox(x*delta)
    shaft()    
    turtle.turnRight()
    turtle.turnRight()
    gox(x*delta)
    
    turtle.turnRight()
    gox(line*delta)
    dump()
    turtle.turnLeft()
    turtle.turnLeft()
  end
end
