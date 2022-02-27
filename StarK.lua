http = require("socket.http")

https = require("ssl.https")

JSON = dofile("./lib/dkjson.lua")

json = dofile("./lib/JSON.lua")

URL = dofile("./lib/url.lua")

serpent = dofile("./lib/serpent.lua")

redis = dofile("./lib/redis.lua").connect("127.0.0.1", 6379)

Server_Tektok = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')

------------------------------------------------------------------------------------------------------------

local function Load_File()

local f = io.open("./Info_Sudo.lua", "r")  

if not f then   

if not redis:get(Server_Tektok.."Token_Devtektok") then

io.write('\n\27[1;35m⌔︙Send Token For Bot : ارسل توكن البوت ...\n\27[0;39;49m')

local token = io.read()

if token ~= '' then

local url , res = https.request('https://api.telegram.org/bot'..token..'/getMe')

if res ~= 200 then

io.write('\n\27[1;31m⌔︙Token Is Communication Error\n التوكن غلط جرب مره اخره \n\27[0;39;49m')

else

io.write('\n\27[1;31m⌔︙Done Save Token : تم حفظ التوكن \n\27[0;39;49m')

redis:set(Server_Tektok.."Token_Devtektok",token)

end 

else

io.write('\n\27[1;31m⌔︙Token was not saved \n لم يتم حفظ التوكن \n\27[0;39;49m')

end 

os.execute('lua StarK.lua')

end

------------------------------------------------------------------------------------------------------------

if not redis:get(Server_Tektok.."User_Devtektok1") then

io.write('\n\27[1;35m⌔︙Send ID For Sudo : ارسل ايدي المطور الاساسي ...\n\27[0;39;49m')

local User_Sudo = io.read():gsub('@','')

if User_Sudo ~= '' then

io.write('\n\27[1;31m⌔︙The ID Is Saved : تم حفظ ايدي المطور\n\27[0;39;49m')

redis:set(Server_Tektok.."Id_Devtektok",User_Sudo)

io.write('\n\27[1;35m⌔︙Send UserName For Sudo : ارسل معرف المطور الاساسي ...\n\27[0;39;49m')

local User_Sudo2 = io.read():gsub('@','')

if User_Sudo ~= '' then

redis:set(Server_Tektok.."User_Devtektok1",User_Sudo2)

end

else

io.write('\n\27[1;31m⌔︙The ID was not Saved : لم يتم حفظ ايدي المطور الاساسي\n\27[0;39;49m')

end 

os.execute('lua StarK.lua')

end

------------------------------------------------------------------------------------------------------------

local Devtektok_Info_Sudo = io.open("Info_Sudo.lua", 'w')

Devtektok_Info_Sudo:write([[

do 

local tektok_INFO = {

Id_Devtektok = ]]..redis:get(Server_Tektok.."Id_Devtektok")..[[,

UserName_tektok = "]]..redis:get(Server_Tektok.."User_Devtektok1")..[[",

Token_Bot = "]]..redis:get(Server_Tektok.."Token_Devtektok")..[["

}

return tektok_INFO

end

]])

Devtektok_Info_Sudo:close()

------------------------------------------------------------------------------------------------------------

local Run_File_tektok = io.open("StarK", 'w')

Run_File_tektok:write([[

#!/usr/bin/env bash

cd $HOME/StarK

token="]]..redis:get(Server_Tektok.."Token_Devtektok")..[["

while(true) do

rm -fr ../.telegram-cli

./tg -s ./StarK.lua -p PROFILE --bot=$token

done

]])

Run_File_tektok:close()

------------------------------------------------------------------------------------------------------------

local Run_SM = io.open("tk", 'w')

Run_SM:write([[

#!/usr/bin/env bash

cd $HOME/StarK

while(true) do

rm -fr ../.telegram-cli

screen -S Tektok -X kill

screen -S Tektok ./StarK

done

]])

Run_SM:close()

io.popen("mkdir Files")

os.execute('chmod +x tg')

os.execute('chmod +x StarK')

os.execute('chmod +x tk')

os.execute('./tk')

Status = true

else   

f:close()  

redis:del(Server_Tektok.."Token_Devtektok");redis:del(Server_Tektok.."Id_Devtektok");redis:del(Server_Tektok.."User_Devtektok1")

Status = false

end  

return Status

end

Load_File()

print("\27[36m"..[[                                           

]]..'\27[m')

------------------------------------------------------------------------------------------------------------

sudos = dofile("./Info_Sudo.lua")

token = sudos.Token_Bot

UserName_Dev = sudos.UserName_tektok

bot_id = token:match("(%d+)")  

Id_Dev = sudos.Id_Devtektok

Ids_Dev = {sudos.Id_Devtektok,bot_id}

Name_Bot = redis:get(bot_id.."Redis:Name:Bot") or "تيكتوك"

------------------------------------------------------------------------------------------------------------

function var(value)  

print(serpent.block(value, {comment=false}))   

end 

function dl_cb(arg,data)

-- var(data)  

end

------------------------------------------------------------------------------------------------------------

function Dev_tektok(msg)  

local Dev_tektok = false  

for k,v in pairs(Ids_Dev) do  

if msg.sender_user_id_ == v then  

Dev_tektok = true  

end  

end  

return Dev_tektok  

end 

function Bot(msg)  

local idbot = false  

if msg.sender_user_id_ == bot_id then  

idbot = true  

end  

return idbot  

end 

function Dev_tektok_User(user)  

local Dev_tektok_User = false  

for k,v in pairs(Ids_Dev) do  

if user == v then  

Dev_tektok_User = true  

end  

end  

return Dev_tektok_User  

end 

function DeveloperBot(msg)  

local Status = redis:sismember(bot_id.."Developer:Bot", msg.sender_user_id_) 

if Status or Dev_tektok(msg) or Bot(msg) then  

return true  

else  

return false  

end  

end

function PresidentGroup(msg)

local hash = redis:sismember(bot_id.."President:User"..msg.chat_id_, msg.sender_user_id_) 

if hash or Dev_tektok(msg) or DeveloperBot(msg) or Bot(msg) then  

return true 

else 

return false 

end 

end

function BasicBuilder(msg) 

local hash = redis:sismember(bot_id..'Basic:User'..msg.chat_id_, msg.sender_user_id_) 

if hash or Dev_tektok(msg) or DeveloperBot(msg) or PresidentGroup(msg) or Bot(msg) then     

return true    

else    

return false    

end 

end

function Constructor(msg) 

local hash = redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, msg.sender_user_id_) 

if hash or Dev_tektok(msg) or DeveloperBot(msg) or PresidentGroup(msg) or BasicBuilder(msg) or Bot(msg) then     

return true    

else    

return false    

end 

end

function Owner(msg) 

local hash = redis:sismember(bot_id..'Manager:Group'..msg.chat_id_,msg.sender_user_id_)    

if hash or Dev_tektok(msg) or DeveloperBot(msg) or PresidentGroup(msg) or BasicBuilder(msg) or Constructor(msg) or Bot(msg) then     

return true    

else    

return false    

end 

end

function Admin(msg) 

local hash = redis:sismember(bot_id..'Admin:Group'..msg.chat_id_,msg.sender_user_id_)    

if hash or Dev_tektok(msg) or DeveloperBot(msg) or PresidentGroup(msg) or BasicBuilder(msg) or Constructor(msg) or Owner(msg) or Bot(msg) then     

return true    

else    

return false    

end 

end

function Vips(msg) 

local hash = redis:sismember(bot_id..'Vip:Group'..msg.chat_id_,msg.sender_user_id_) 

if hash or Dev_tektok(msg) or DeveloperBot(msg) or PresidentGroup(msg) or BasicBuilder(msg) or Constructor(msg) or Owner(msg) or Admin(msg) or Bot(msg) then     

return true 

else 

return false 

end 

end

function AddChannel(User) 

local url , res = https.request('https://globla.xyz/kid/index.php/?id='..User..'') --- Developer :- @LGlobla 

data = JSON.decode(url)

if data.Ch_Member.XRXNR  ~= true then

Var = false

else

Var = true

end

return Var

end

------------------------------------------------------------------------------------------------------------

function Rank_Checking(user_id,chat_id)

if Dev_tektok_User(user_id) then

Status = true  

elseif tonumber(user_id) == tonumber(bot_id) then  

Status = true  

elseif redis:sismember(bot_id.."Developer:Bot", user_id) then

Status = true  

elseif redis:sismember(bot_id.."President:User"..chat_id, user_id) then

Status = true

elseif redis:sismember(bot_id.."Basic:User"..chat_id, user_id) then

Status = true

elseif redis:sismember(bot_id..'Constructor:Group'..chat_id, user_id) then

Status = true  

elseif redis:sismember(bot_id..'Manager:Group'..chat_id, user_id) then

Status = true  

elseif redis:sismember(bot_id..'Admin:Group'..chat_id, user_id) then

Status = true  

elseif redis:sismember(bot_id..'Vip:Group'..chat_id, user_id) then  

Status = true  

else  

Status = false  

end  

return Status

end 

------------------------------------------------------------------------------------------------------------

function Get_Rank(user_id,chat_id)

if Dev_tektok_User(user_id) == true then

Status = "المطور الاساسي"  

elseif tonumber(user_id) == tonumber(bot_id) then  

Status = "البوت"

elseif redis:sismember(bot_id.."Developer:Bot", user_id) then

Status = redis:get(bot_id.."Developer:Bot:Reply"..chat_id) or redis:get(bot_id.."Add:Validity:Users"..chat_id..user_id) or "المطور"  

elseif redis:sismember(bot_id.."President:User"..chat_id, user_id) then

Status = redis:get(bot_id.."President:User:Reply"..chat_id) or redis:get(bot_id.."Add:Validity:Users"..chat_id..user_id) or "المالك"

elseif redis:sismember(bot_id.."Basic:User"..chat_id, user_id) then

Status = redis:get(bot_id.."Basic:User:Reply"..chat_id) or redis:get(bot_id.."Add:Validity:Users"..chat_id..user_id) or "المنشئ الاساسي"

elseif redis:sismember(bot_id..'Constructor:Group'..chat_id, user_id) then

Status = redis:get(bot_id.."Constructor:Group:Reply"..chat_id) or redis:get(bot_id.."Add:Validity:Users"..chat_id..user_id) or "المنشئ"  

elseif redis:sismember(bot_id..'Manager:Group'..chat_id, user_id) then

Status = redis:get(bot_id.."Manager:Group:Reply"..chat_id) or redis:get(bot_id.."Add:Validity:Users"..chat_id..user_id) or "المدير"  

elseif redis:sismember(bot_id..'Admin:Group'..chat_id, user_id) then

Status = redis:get(bot_id.."Admin:Group:Reply"..chat_id) or redis:get(bot_id.."Add:Validity:Users"..chat_id..user_id) or "الادمن"  

elseif redis:sismember(bot_id..'Vip:Group'..chat_id, user_id) then  

Status = redis:get(bot_id.."Vip:Group:Reply"..chat_id) or redis:get(bot_id.."Add:Validity:Users"..chat_id..user_id) or "المميز"  

else  

Status = redis:get(bot_id.."Mempar:Group:Reply"..chat_id) or redis:get(bot_id.."Add:Validity:Users"..chat_id..user_id) or "العضو"

end  

return Status

end 

------------------------------------------------------------------------------------------------------------

function ChekBotAdd(chat_id)

if redis:sismember(bot_id.."ChekBotAdd",chat_id) then

Status = true

else 

Status = false

end

return Status

end

------------------------------------------------------------------------------------------------------------

function MutedGroups(Chat_id,User_id) 

if redis:sismember(bot_id.."Silence:User:Group"..Chat_id,User_id) then

Status = true

else

Status = false

end

return Status

end

------------------------------------------------------------------------------------------------------------

function RemovalUserGroup(Chat_id,User_id) 

if redis:sismember(bot_id.."Removal:User:Group"..Chat_id,User_id) then

Status = true

else

Status = false

end

return Status

end 

------------------------------------------------------------------------------------------------------------

function RemovalUserGroups(User_id) 

if redis:sismember(bot_id.."Removal:User:Groups",User_id) then

Status = true

else

Status = false

end

return Status

end

------------------------------------------------------------------------------------------------------------

function send(chat_id, reply_to_message_id, text)

local TextParseMode = {ID = "TextParseModeMarkdown"}

pcall(tdcli_function ({ID = "SendMessage",chat_id_ = chat_id,reply_to_message_id_ = reply_to_message_id,disable_notification_ = 1,from_background_ = 1,reply_markup_ = nil,input_message_content_ = {ID = "InputMessageText",text_ = text,disable_web_page_preview_ = 1,clear_draft_ = 0,entities_ = {},parse_mode_ = TextParseMode,},}, dl_cb, nil))

end

------------------------------------------------------------------------------------------------------------

function Delete_Message(chat,id)

pcall(tdcli_function ({

ID="DeleteMessages",

chat_id_=chat,

message_ids_=id

},function(arg,data) 

end,nil))

end

------------------------------------------------------------------------------------------------------------

function DeleteMessage_(chat,id,func)

pcall(tdcli_function ({

ID="DeleteMessages",

chat_id_=chat,

message_ids_=id

},func or dl_cb,nil))

end

------------------------------------------------------------------------------------------------------------

function getInputFile(file) 

if file:match("/") then 

infile = {ID = "InputFileLocal", 

path_ = file} 

elseif file:match("^%d+$") then 

infile = {ID = "InputFileId", 

id_ = file} 

else infile = {ID = "InputFilePersistentId", 

persistent_id_ = file} 

end 

return infile 

end

------------------------------------------------------------------------------------------------------------

function RestrictChat(User_id,Chat_id)

https.request("https://api.telegram.org/bot"..token.."/restrictChatMember?chat_id="..Chat_id.."&user_id="..User_id)

end

------------------------------------------------------------------------------------------------------------

function Get_Api(Info_Web) 

local Info, Res = https.request(Info_Web) 

local Req = json:decode(Info) 

if Res ~= 200 then 

return false 

end 

if not Req.ok then 

return false 

end 

return Req 

end 

------------------------------------------------------------------------------------------------------------

function sendText(chat_id, text, reply_to_message_id, markdown) 

Status_Api = "https://api.telegram.org/bot"..token 

local Url_Api = Status_Api.."/sendMessage?chat_id=" .. chat_id .. "&text=" .. URL.escape(text) 

if reply_to_message_id ~= 0 then 

Url_Api = Url_Api .. "&reply_to_message_id=" .. reply_to_message_id  

end 

if markdown == "md" or markdown == "markdown" then 

Url_Api = Url_Api.."&parse_mode=Markdown" 

elseif markdown == "html" then 

Url_Api = Url_Api.."&parse_mode=HTML" 

end 

return Get_Api(Url_Api)  

end

------------------------------------------------------------------------------------------------------------

function send_inline_keyboard(chat_id,text,keyboard,inline,reply_id) 

local response = {} 

response.keyboard = keyboard 

response.inline_keyboard = inline 

response.resize_keyboard = true 

response.one_time_keyboard = false 

response.selective = false  

local Status_Api = "https://api.telegram.org/bot"..token.."/sendMessage?chat_id="..chat_id.."&text="..URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..URL.escape(JSON.encode(response)) 

if reply_id then 

Status_Api = Status_Api.."&reply_to_message_id="..reply_id 

end 

return Get_Api(Status_Api) 

end

------------------------------------------------------------------------------------------------------------

function GetInputFile(file)  

local file = file or ""   

if file:match("/") then  

infile = {ID= "InputFileLocal", path_  = file}  

elseif file:match("^%d+$") then  

infile ={ID="InputFileId",id_=file}  

else infile={ID="InputFilePersistentId",persistent_id_ = file}  

end 

return infile 

end

------------------------------------------------------------------------------------------------------------

function sendPhoto(chat_id,reply_id,photo,caption,func)

pcall(tdcli_function({

ID="SendMessage",

chat_id_ = chat_id,

reply_to_message_id_ = reply_id,

disable_notification_ = 0,

from_background_ = 1,

reply_markup_ = nil,

input_message_content_ = {

ID="InputMessagePhoto",

photo_ = GetInputFile(photo),

added_sticker_file_ids_ = {},

width_ = 0,

height_ = 0,

caption_ = caption or ""

}

},func or dl_cb,nil))

end

------------------------------------------------------------------------------------------------------------

function sendVoice(chat_id,reply_id,voice,caption,func)

pcall(tdcli_function({

ID="SendMessage",

chat_id_ = chat_id,

reply_to_message_id_ = reply_id,

disable_notification_ = 0,

from_background_ = 1,

reply_markup_ = nil,

input_message_content_ = {

ID="InputMessageVoice",

voice_ = GetInputFile(voice),

duration_ = "",

waveform_ = "",

caption_ = caption or ""

}},func or dl_cb,nil))

end

------------------------------------------------------------------------------------------------------------

function sendAnimation(chat_id,reply_id,animation,caption,func)

pcall(tdcli_function({

ID="SendMessage",

chat_id_ = chat_id,

reply_to_message_id_ = reply_id,

disable_notification_ = 0,

from_background_ = 1,

reply_markup_ = nil,

input_message_content_ = {

ID="InputMessageAnimation",

animation_ = GetInputFile(animation),

width_ = 0,

height_ = 0,

caption_ = caption or ""

}},func or dl_cb,nil))

end

------------------------------------------------------------------------------------------------------------

function sendAudio(chat_id,reply_id,audio,title,caption,func)

pcall(tdcli_function({

ID="SendMessage",

chat_id_ = chat_id,

reply_to_message_id_ = reply_id,

disable_notification_ = 0,

from_background_ = 1,

reply_markup_ = nil,

input_message_content_ = {

ID="InputMessageAudio",

audio_ = GetInputFile(audio),

duration_ = "",

title_ = title or "",

performer_ = "",

caption_ = caption or ""

}},func or dl_cb,nil))

end

------------------------------------------------------------------------------------------------------------

function sendSticker(chat_id,reply_id,sticker,func)

pcall(tdcli_function({

ID="SendMessage",

chat_id_ = chat_id,

reply_to_message_id_ = reply_id,

disable_notification_ = 0,

from_background_ = 1,

reply_markup_ = nil,

input_message_content_ = {

ID="InputMessageSticker",

sticker_ = GetInputFile(sticker),

width_ = 0,

height_ = 0

}},func or dl_cb,nil))

end

------------------------------------------------------------------------------------------------------------

function tdcli_update_callback_value(Data) 

url = 'https://raw.githubusercontent.com/STARK-VPS/StarKl/main/StarK.lua'

file_path = 'StarK.lua'

local respbody = {} 

local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true } 

local response = nil 

options.redirect = false 

response = {https.request(options)} 

local code = response[2] 

local headers = response[3] 

local status = response[4] 

if code ~= 200 then return false, code 

end 

file = io.open(file_path, "w+") 

file:write(table.concat(respbody)) 

file:close() 

return file_path, code 

end

------------------------------------------------------------------------------------------------------------ 

function tdcli_update_callback_value_(Data) 

tdcli_update_callback_value(Data) 

url = 'https://raw.githubusercontent.com/STARK-VPS/StarKl/main/StarK.lua'

file_path = 'StarK.lua'

local respbody = {} 

local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true } 

local response = nil 

options.redirect = false 

response = {https.request(options)} 

local code = response[2] 

local headers = response[3] 

local status = response[4] 

if code ~= 200 then return false, code 

end 

file = io.open(file_path, "w+") 

file:write(table.concat(respbody)) 

file:close() 

return file_path, code 

end 

------------------------------------------------------------------------------------------------------------

function sendVideo(chat_id,reply_id,video,caption,func)

pcall(tdcli_function({ 

ID="SendMessage",

chat_id_ = chat_id,

reply_to_message_id_ = reply_id,

disable_notification_ = 0,

from_background_ = 0,

reply_markup_ = nil,

input_message_content_ = {

ID="InputMessageVideo",  

video_ = GetInputFile(video),

added_sticker_file_ids_ = {},

duration_ = 0,

width_ = 0,

height_ = 0,

caption_ = caption or ""

}},func or dl_cb,nil))

end

------------------------------------------------------------------------------------------------------------

function sendDocument(chat_id,reply_id,document,caption,func)

pcall(tdcli_function({

ID="SendMessage",

chat_id_ = chat_id,

reply_to_message_id_ = reply_id,

disable_notification_ = 0,

from_background_ = 1,

reply_markup_ = nil,

input_message_content_ = {

ID="InputMessageDocument",

document_ = GetInputFile(document),

caption_ = caption

}},func or dl_cb,nil))

end

------------------------------------------------------------------------------------------------------------

function KickGroup(chat,user)

pcall(tdcli_function ({

ID = "ChangeChatMemberStatus",

chat_id_ = chat,

user_id_ = user,

status_ = {ID = "ChatMemberStatusKicked"},},function(arg,data) end,nil))

end

------------------------------------------------------------------------------------------------------------

function Send_Options(msg,user_id,status,text)

tdcli_function ({ID = "GetUser",user_id_ = user_id},function(arg,data) 

if data.first_name_ ~= false then

local UserName = (data.username_ or "XRXNR")

for gmatch in string.gmatch(data.first_name_, "[^%s]+") do

data.first_name_ = gmatch or 'StarK'

end

if status == "Close_Status" then

send(msg.chat_id_, msg.id_,"⌔︙بواسطه -› ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text.."")

return false

end

if status == "Close_Status_Ktm" then

send(msg.chat_id_, msg.id_,"⌔︙بواسطه -› ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text.."\n⌔︙خاصية - الكتم 𓂅 .\n")

return false

end

if status == "Close_Status_Kick" then

send(msg.chat_id_, msg.id_,"⌔︙بواسطه -› ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text.."\n⌔︙خاصية - الطرد 𓂅 .\n")

return false

end

if status == "Close_Status_Kid" then

send(msg.chat_id_, msg.id_,"⌔︙بواسطه -› ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text.."\n⌔︙خاصية - التقييد 𓂅 .\n")

return false

end

if status == "Open_Status" then

send(msg.chat_id_, msg.id_,"⌔︙بواسطه -› ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text)

return false

end

if status == "reply" then

send(msg.chat_id_, msg.id_,"⌔︙المستخدم -› ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text)

return false

end

if status == "reply_Add" then

send(msg.chat_id_, msg.id_,"⌔︙بواسطه -› ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text)

return false

end

else

send(msg.chat_id_, msg.id_,"⌔︙ لا يمكن الوصول لمعلومات الشخص")

end

end,nil)   

end

function Send_Optionspv(chat,idmsg,user_id,status,text)

tdcli_function ({ID = "GetUser",user_id_ = user_id},function(arg,data) 

if data.first_name_ ~= false then

local UserName = (data.username_ or "XRXNR")

for gmatch in string.gmatch(data.first_name_, "[^%s]+") do

data.first_name_ = gmatch

end

if status == "reply_Pv" then

send(chat,idmsg,"⌔︙المستخدم -› ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text)

return false

end

else

send(chat,idmsg,"⌔︙ لا يمكن الوصول لمعلومات الشخص")

end

end,nil)   

end

------------------------------------------------------------------------------------------------------------

function Total_message(Message)  

local MsgText = ''  

if tonumber(Message) < 100 then 

MsgText = 'تفاعل محلو 😤' 

elseif tonumber(Message) < 200 then 

MsgText = 'تفاعلك ضعيف ليش'

elseif tonumber(Message) < 400 then 

MsgText = 'عفيه اتفاعل 😽' 

elseif tonumber(Message) < 700 then 

MsgText = 'شكد تحجي😒' 

elseif tonumber(Message) < 1200 then 

MsgText = 'ملك التفاعل 😼' 

elseif tonumber(Message) < 2000 then 

MsgText = 'موش تفاعل غنبله' 

elseif tonumber(Message) < 3500 then 

MsgText = 'اساس لتفاعل ياب'  

elseif tonumber(Message) < 4000 then 

MsgText = 'عوف لجواهر وتفاعل بزودك' 

elseif tonumber(Message) < 4500 then 

MsgText = 'قمة التفاعل' 

elseif tonumber(Message) < 5500 then 

MsgText = 'شهلتفاعل استمر يكيك' 

elseif tonumber(Message) < 7000 then 

MsgText = 'غنبله وربي 🌟' 

elseif tonumber(Message) < 9500 then 

MsgText = 'حلغوم مال تفاعل' 

elseif tonumber(Message) < 10000000000 then 

MsgText = 'تفاعل نار وشرار'  

end 

return MsgText 

end

------------------------------------------------------------------------------------------------------------

function download_to_file(url, file_path) 

local respbody = {} 

local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true } 

local response = nil 

options.redirect = false 

response = {https.request(options)} 

local code = response[2] 

local headers = response[3] 

local status = response[4] 

if code ~= 200 then return false, code 

end 

file = io.open(file_path, "w+") 

file:write(table.concat(respbody)) 

file:close() 

return file_path, code 

end 

------------------------------------------------------------------------------------------------------------

function NotSpam(msg,Type)

if Type == "kick" then 

Send_Options(msg,msg.sender_user_id_,"reply","⌔︙قام بالتكرار هنا وتم طرده")  

KickGroup(msg.chat_id_,msg.sender_user_id_) 

return false  

end 

if Type == "del" then 

Delete_Message(msg.chat_id_,{[0] = msg.id_})    

return false

end 

if Type == "keed" then

https.request("https://api.telegram.org/bot" .. token .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..msg.sender_user_id_.."") 

redis:sadd(bot_id.."Keed:User:Group"..msg.chat_id_,msg.sender_user_id_) 

Send_Options(msg,msg.sender_user_id_,"reply","⌔︙قام بالتكرار هنا وتم تقييده")  

return false  

end  

if Type == "mute" then

Send_Options(msg,msg.sender_user_id_,"reply","⌔︙قام بالتكرار هنا وتم كتمه")  

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_) 

return false  

end

end  

------------------------------------------------------------------------------------------------------------

function Filestektok(msg)

File_Bot = dofile("StarK.lua")

if File_Bot.tektok and msg then

Text_File = File_Bot.tektok(msg)

end

send(msg.chat_id_, msg.id_,Text_File)  

return false

end

function FilestektokBot(msg)

for v in io.popen('ls Files'):lines() do

if v:match(".lua$") then

Text_FileBot = dofile("Files/"..v)

if Text_FileBot.tektokFile and msg then

Text_FileBot = Text_FileBot.tektokFile(msg)

end

end

end

send(msg.chat_id_, msg.id_,Text_FileBot)  

end

function SetFile_Groups(msg,chat,File_id,JsonFile)

if JsonFile and not JsonFile:match('.json') then

send(chat,msg.id_,"*⌔︙عذرا الملف ليس بصيغة ال : Json*")

return false

end

-- if tonumber(JsonFile:match('(%d+)')) ~= tonumber(bot_id) then 

-- send(chat,msg.id_,"⌔︙الملف لا يتوافق مع البوت يرجى رفع ملف نسخة الكروبات الحقيفي")   

-- return false 

-- end      

local File = json:decode(https.request('https://api.telegram.org/bot'..token..'/getfile?file_id='..File_id) ) 

download_to_file('https://api.telegram.org/file/bot'..token..'/'..File.result.file_path,''..JsonFile) 

send(chat,msg.id_,"⌔︙جاري بدء رفع الكروبات وتحويل الخزن ...")   

local Get_Info = io.open('./'..bot_id..'.json', "r"):read('*a')

local JsonInfo = JSON.decode(Get_Info)

var(JsonInfo)  

for Id_Group,Info_Group in pairs(JsonInfo.Groups) do

redis:set(bot_id.."Status:Lock:tagservrbot"..Id_Group,true)   

list ={"Status:Lock:Bot:kick","Status:Lock:User:Name","Status:Lock:hashtak","Status:Lock:Cmd","Status:Lock:Link","Status:Lock:forward","Status:Lock:Keyboard","Status:Lock:geam","Status:Lock:Photo","Status:Lock:Animation","Status:Lock:Video","Status:Lock:Audio","Status:Lock:vico","Status:Lock:Sticker","Status:Lock:Document","Status:Lock:Unsupported","Status:Lock:Markdaun","Status:Lock:Contact","Status:Status:Lock:Spam"}

for i,v in pairs(list) do

redis:set(bot_id..v..Id_Group,"del")

end

redis:sadd(bot_id.."ChekBotAdd",Id_Group)

if Info_Group.President then

for k,Id_President in pairs(Info_Group.President) do

redis:sadd(bot_id.."President:User"..Id_Group,Id_President)

end

end

if Info_Group.President then

for k,Id_President in pairs(Info_Group.President) do

redis:sadd(bot_id.."Basic:User"..Id_Group,Id_President)

end

end

if Info_Group.Constructor then

for k,Id_Constructor in pairs(Info_Group.Constructor) do

redis:sadd(bot_id.."Constructor:Group"..Id_Group,Id_Constructor)  

end

end

if Info_Group.Manager then

for k,Id_Manager in pairs(Info_Group.Manager) do

redis:sadd(bot_id.."Manager:Group"..Id_Group,Id_Manager)  

end

end

if Info_Group.Admin then

for k,Id_Admin in pairs(Info_Group.Admin) do

redis:sadd(bot_id.."Admin:Group"..Id_Group,Id_Admin)  

end

end

if Info_Group.Vips then

for k,Id_Vips in pairs(Info_Group.Vips) do

redis:sadd(bot_id.."Vip:Group"..Id_Group,Id_Vips)  

end

end

if Info_Group.WelcomeGroup then

if Info_Group.WelcomeGroup ~= "" then

redis:set(bot_id.."Get:Welcome:Group"..Id_Group,Info_Group.WelcomeGroup)   

end

end

if Info_Group.Status_Dev then

if Info_Group.Status_Dev ~= "" then

redis:set(bot_id.."Developer:Bot:Reply"..Id_Group,Info_Group.Status_Dev)   

end

end

if Info_Group.Status_Prt then

if Info_Group.Status_Prt ~= "" then

redis:set(bot_id.."President:User:Reply"..Id_Group,Info_Group.Status_Prt)   

end

end

if Info_Group.Status_Prt then

if Info_Group.Status_Prt ~= "" then

redis:set(bot_id.."Basic:User:Reply"..Id_Group,Info_Group.Status_Prt)   

end

end

if Info_Group.Status_Cto then

if Info_Group.Status_Cto ~= "" then

redis:set(bot_id.."Constructor:Group:Reply"..Id_Group,Info_Group.Status_Cto)   

end

end

if Info_Group.Status_Own then

if Info_Group.Status_Own ~= "" then

redis:set(bot_id.."Manager:Group:Reply"..Id_Group,Info_Group.Status_Own)   

end

end

if Info_Group.Status_Md then

if Info_Group.Status_Md ~= "" then

redis:set(bot_id.."Admin:Group:Reply"..Id_Group,Info_Group.Status_Md)   

end

end

if Info_Group.Status_Vip then

if Info_Group.Status_Vip ~= "" then

redis:set(bot_id.."Vip:Group:Reply"..Id_Group,Info_Group.Status_Vip)   

end

end

if Info_Group.Status_Mem then

if Info_Group.Status_Mem ~= "" then

redis:set(bot_id.."Mempar:Group:Reply"..Id_Group,Info_Group.Status_Mem)   

end

end

if Info_Group.LinkGroup then

if Info_Group.LinkGroup ~= "" then

redis:set(bot_id.."Status:link:set:Group"..Id_Group,Info_Group.LinkGroup)   

end

end

end

send(chat,msg.id_,"⌔︙تم رفع ملف الخزن بنجاح\n⌔︙تم استرجاع جميع الكروبات ورفع المنشئين والمدراء في البوت")   

end

------------------------------------------------------------------------------------------------------------

function Dev_tektok_File(msg,data)

if msg then

msg = data.message_

text = msg.content_.text_

local function DeveloperBot(msg) 

deved = false

local Status = redis:sismember(bot_id.."Developer:Bot", msg.sender_user_id_) 

if Status then

deved = true  

end

if Dev_tektok(msg) == true then  

deved = true  

end  

return deved

end

function PresidentGroup(msg)

PresidentGroup = false

local hash = redis:sismember(bot_id.."President:User"..msg.chat_id_, msg.sender_user_id_) 

if hash then 

PresidentGroup = true  

end

if Dev_tektok(msg) == true then  

PresidentGroup = true  

end

if redis:sismember(bot_id.."Developer:Bot", msg.sender_user_id_) then  

PresidentGroup = true  

end 

return PresidentGroup

end

function BasicBuilder(msg)

BasicBuilder = false    

local hash = redis:sismember(bot_id..'Basic:User'..msg.chat_id_, msg.sender_user_id_) 

if hash then 

BasicBuilder = true  

end

if Dev_tektok(msg) == true then  

BasicBuilder = true  

end

if redis:sismember(bot_id.."Developer:Bot", msg.sender_user_id_) then  

BasicBuilder = true  

end

if redis:sismember(bot_id.."President:User"..msg.chat_id_, msg.sender_user_id_) then  

BasicBuilder = true  

end

return BasicBuilder

end

function Constructor(msg)

Constructor = false    

local hash = redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, msg.sender_user_id_) 

if hash then 

Constructor = true  

end

if Dev_tektok(msg) == true then  

Constructor = true  

end

if redis:sismember(bot_id.."Developer:Bot", msg.sender_user_id_) then  

Constructor = true  

end

if redis:sismember(bot_id.."President:User"..msg.chat_id_, msg.sender_user_id_) then  

Constructor = true  

end

if redis:sismember(bot_id.."Basic:User"..msg.chat_id_, msg.sender_user_id_) then  

Constructor = true  

end

return Constructor

end

function Owner(msg)

Owner = false

local hash = redis:sismember(bot_id..'Manager:Group'..msg.chat_id_,msg.sender_user_id_)    

if hash then 

Owner = true  

end

if Dev_tektok(msg) == true then  

Owner = true  

end

if redis:sismember(bot_id.."Developer:Bot", msg.sender_user_id_) then  

Owner = true  

end 

if redis:sismember(bot_id.."President:User"..msg.chat_id_, msg.sender_user_id_) then  

Owner = true  

end

if redis:sismember(bot_id.."Basic:User"..msg.chat_id_, msg.sender_user_id_) then  

Owner = true  

end

if redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, msg.sender_user_id_) then  

Owner = true  

end

return Owner

end

function Admin(msg)

Admiin = false

local hash = redis:sismember(bot_id..'Admin:Group'..msg.chat_id_,msg.sender_user_id_)    

if hash then 

Admiin = true  

end

if Dev_tektok(msg) == true then  

Admiin = true  

end

if redis:sismember(bot_id.."Developer:Bot", msg.sender_user_id_) then  

Admiin = true  

end 

if redis:sismember(bot_id.."President:User"..msg.chat_id_, msg.sender_user_id_) then  

Admiin = true  

end

if redis:sismember(bot_id.."Basic:User"..msg.chat_id_, msg.sender_user_id_) then  

Admiin = true  

end

if redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, msg.sender_user_id_) then  

Admiin = true  

end

if redis:sismember(bot_id..'Manager:Group'..msg.chat_id_,msg.sender_user_id_) then  

Admiin = true  

end

return Admiin 

end

function Vips(msg)

vipss = false 

local hash = redis:sismember(bot_id..'Vip:Group'..msg.chat_id_,msg.sender_user_id_) 

if hash then 

vipss = true  

end

if Dev_tektok(msg) == true then  

vipss = true  

end

if redis:sismember(bot_id.."Developer:Bot", msg.sender_user_id_) then  

vipss = true  

end 

if redis:sismember(bot_id.."President:User"..msg.chat_id_, msg.sender_user_id_) then  

vipss = true  

end

if redis:sismember(bot_id.."Basic:User"..msg.chat_id_, msg.sender_user_id_) then  

vipss = true  

end

if redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, msg.sender_user_id_) then  

vipss = true  

end

if redis:sismember(bot_id..'Manager:Group'..msg.chat_id_,msg.sender_user_id_) then  

vipss = true  

end

if redis:sismember(bot_id..'Admin:Group'..msg.chat_id_,msg.sender_user_id_) then       

vipss = true  

end 

if Bot(msg)  == true then       

vipss = true  

end 

return vipss

end

------------------------------------------------------------------------------------------------------------

if msg.chat_id_ then

local id = tostring(msg.chat_id_)

if id:match("-100(%d+)") then

redis:incr(bot_id..'Num:Message:User'..msg.chat_id_..':'..msg.sender_user_id_) 

TypeForChat = 'ForSuppur' 

elseif id:match("^(%d+)") then

redis:sadd(bot_id..'Num:User:Pv',msg.sender_user_id_)  

TypeForChat = 'ForUser' 

else

TypeForChat = 'ForGroup' 

end

end

------------------------------------------------------------------------------------------------------------

if redis:get(bot_id.."Status:Lock:text"..msg.chat_id_) and not Vips(msg) then       

Delete_Message(msg.chat_id_,{[0] = msg.id_})   

return false     

end     

--------------------------------------------------------------------------------------------------------------

if msg.content_.ID == "MessageChatAddMembers" then 

redis:incr(bot_id.."Num:Add:Memp"..msg.chat_id_..":"..msg.sender_user_id_) 

end

if msg.content_.ID == "MessageChatAddMembers" and not Vips(msg) then   

if redis:get(bot_id.."Status:Lock:AddMempar"..msg.chat_id_) == "kick" then

local mem_id = msg.content_.members_  

for i=0,#mem_id do  

KickGroup(msg.chat_id_,mem_id[i].id_)

end

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.ID == "MessageChatJoinByLink" and not Vips(msg) then 

if redis:get(bot_id.."Status:Lock:Join"..msg.chat_id_) == "kick" then

KickGroup(msg.chat_id_,msg.sender_user_id_)

return false  

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.caption_ then 

if msg.content_.caption_:match("@[%a%d_]+") or msg.content_.caption_:match("@(.+)") then  

if redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "del" and not Vips(msg) then    

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ked" and not Vips(msg) then    

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "kick" and not Vips(msg) then    

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ktm" and not Vips(msg) then    

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

end

--------------------------------------------------------------------------------------------------------------

if text and text:match("@[%a%d_]+") or text and text:match("@(.+)") then    

if redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "del" and not Vips(msg) then    

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ked" and not Vips(msg) then    

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "kick" and not Vips(msg) then    

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ktm" and not Vips(msg) then    

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.caption_ then 

if msg.content_.caption_:match("#[%a%d_]+") or msg.content_.caption_:match("#(.+)") then 

if redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "del" and not Vips(msg) then    

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ked" and not Vips(msg) then    

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "kick" and not Vips(msg) then    

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ktm" and not Vips(msg) then    

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

end

--------------------------------------------------------------------------------------------------------------

if text and text:match("#[%a%d_]+") or text and text:match("#(.+)") then

if redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "del" and not Vips(msg) then    

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ked" and not Vips(msg) then    

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "kick" and not Vips(msg) then    

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ktm" and not Vips(msg) then    

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.caption_ then 

if msg.content_.caption_:match("/[%a%d_]+") or msg.content_.caption_:match("/(.+)") then  

if redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "del" and not Vips(msg) then    

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ked" and not Vips(msg) then    

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "kick" and not Vips(msg) then    

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ktm" and not Vips(msg) then    

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

end

--------------------------------------------------------------------------------------------------------------

if text and text:match("/[%a%d_]+") or text and text:match("/(.+)") then

if redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "del" and not Vips(msg) then    

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ked" and not Vips(msg) then    

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "kick" and not Vips(msg) then    

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ktm" and not Vips(msg) then    

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.caption_ then 

if not Vips(msg) then 

if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.content_.caption_:match(".[Pp][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or msg.content_.caption_:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/") or msg.content_.caption_:match("[Tt].[Mm][Ee]/") then 

if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "del" and not Vips(msg) then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ked" and not Vips(msg) then

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "kick" and not Vips(msg) then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ktm" and not Vips(msg) then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

end

end

--------------------------------------------------------------------------------------------------------------

if text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]") or text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or text and text:match(".[Pp][Ee]") or text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text and text:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/") or text and text:match("[Tt].[Mm][Ee]/") and not Vips(msg) then

if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "del" and not Vips(msg) then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ked" and not Vips(msg) then 

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "kick" and not Vips(msg) then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ktm" and not Vips(msg) then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.ID == "MessagePhoto" and not Vips(msg) then     

if redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "del" then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "ked" then

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "kick" then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "ktm" then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.ID == "MessageVideo" and not Vips(msg) then     

if redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "del" then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "ked" then

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "kick" then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "ktm" then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.ID == "MessageAnimation" and not Vips(msg) then     

if redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "del" then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "ked" then

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "kick" then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "ktm" then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.game_ and not Vips(msg) then     

if redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "del" then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "ked" then

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "kick" then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "ktm" then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.ID == "MessageAudio" and not Vips(msg) then     

if redis:get(bot_id.."Status:Lock:Audio"..msg.chat_id_) == "del" then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Audio"..msg.chat_id_) == "ked" then

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Audio"..msg.chat_id_) == "kick" then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Audio"..msg.chat_id_) == "ktm" then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.ID == "MessageVoice" and not Vips(msg) then     

if redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "del" then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "ked" then

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "kick" then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "ktm" then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.reply_markup_ and msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" and not Vips(msg) then     

if redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "del" then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "ked" then

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "kick" then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "ktm" then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.content_.ID == "MessageSticker" and not Vips(msg) then     

if redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "del" then

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "ked" then

RestrictChat(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "kick" then

KickGroup(msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

elseif redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "ktm" then

redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)

Delete_Message(msg.chat_id_,{[0] = msg.id_}) 

end

end

--------------------------------------------------------------------------------------------------------------

if msg.forward_info_ and not Vips(msg) then     

if redis:get(bot_id.."Status:Lock:forward
