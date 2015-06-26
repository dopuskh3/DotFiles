
local utils = {} 

function utils.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end


utils.HOME_DIR= os.getenv("HOME")
utils.CONF_DIR= utils.HOME_DIR .. ".config/awesome/"

return utils

