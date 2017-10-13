local help_text = [[*Tweet Sender Bot V 0.1 :*

*/reload* 
_Reload Bot_

*/blocklist*
_show Blocked Users List_

*/sudolist*
_Sudo(s) list_

*/clean blocklist*
_Clean Block List_

*/users*
_Number Of Users_

*/setstart* `[text]`
_Set Start Message_

*/setsent* `[text]`
_Set Send Message_

*/setprofiletext* `[text]`
_Set Your Profile Text_

*/block* `[reply|id]`
_Add User To Block List_

*/unblock* `[reply|id]`
_Remove User From Block List_

*/setsudo* `[reply|id]`
_Add User To Sudo Users_

*/remsudo* `[reply|id]`
_Remove User From Sudo Users_

*/setrealm*
_Set A New Realm_

*/antiflood on*
_Enable Flood Protection_

*/antiflood off*
_Disable Flood Protection_

*/autoleave on*
_Enable Auto Leave_

*/autoleave off*
_Disable Auto Leave_

*/setpvflood*
_Set The Maximun Messages In A FloodTime To Be Considered As flood_

*/setpvfloodtime*
_Set The Time That Bot Uses To Check flood_

*/tw*
_Show About Bot_

*/sendtoall* `[text]`
_Send A Message To All User_

*/fwdtoall* `[reply]`
_Forward A Message To All User_
]]

local mem_help = [[*Tweet Sender Bot V 0.1*

_راهنمای استفاده از ربات توییت سندر_

1. در هنگام استارت ربات مشخصات شما دریافت و هشتگ مخصوص شما ساخته می شود و شما نیازی به درج هشتگ و تگ کانال زیر توییت نمی باشید. 

2. نحوه ارسال توییت به اینگونه باید باشد که شما زیر متن توییت تنها هشتگ نام سریال را درج می کنید و هشتگ مخصوص شما و تگ کانال یه صورت خورکار به توییت شما اضافه شده و به کانال فرعی برای بررسی ارسال می شود.

3. با هر توییت یک کد پیگیری در اختیار شما قرار میگیرد که در صورت فرستاده نشدن توییت شما میتوانید با ارسال کد پیگیری به [ربات ارتباط مستقیم با مدیریت تیم](https://telegram.me/isperrobot) فرستاده و درخواست بررسی مجدد دهید.
`در صورت وجود مشکل در توییت شما به شما برای اصلاح توییت های بعدی اطلاع داده می شود.`

4. در ورژن شماره 1 ربات به دلیل یک سری مشکلات ارسال تمامی رسانه ها ممنوع بوده و تنها ارسال پیام های متنی مجاز است.
 
5. در ارسال توییت میتوانید از قابلیت مارکدون استفاده کنید که شامل بولد کردن متون انگلیسی ، ایتالیک کردن متون انگلیسی و فارسی است که در ادامه به نمونه های آن می پردازیم:

الف: بولد (برای متون انگلیسی)`
با قرار دادن ستاره ( * )  در دو طرف متن آن را بولد کنید.
مثال :`
Input : \*Text\*
Output : *Text*
ب: ایتالیک (برای متون انگلیسی و فارسی)`
با قرار دادن آندرلاین ( _ ) در دوطرف متن آن را ایتالیک کنید.
مثال :`
Input : \_Text\_ 
Output : _Text_
Input : \_متن\_ 
Output : _متن_

نکته : در صورت بروز هرگونه مشکل با پشتیبانی ربات در تماس باشید!

Developer : @OfficialHM
Powered By : @KorenaTeam
Our Channel : @TvShowTweet
Oor Team : @KorenaGroup

]]
local profile_text = [[
:|
]]

local keyboard = {{"🔖راهنما"},{"🚦اطلاعات و هشتگ مخصوص شما"}} 

local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end

local function sudolist(msg)
local sudo_users = _config.sudo_users
local text = "Sudo Users :\n"
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end

function add_user(msg)
  redis:sadd('users',msg.from.id)
end
function blocked_list(msg)
local list = redis:smembers('blocked')
 local text = "*Blocked users list!*\n\n"
 for k,v in pairs(list) do
 local user_info = redis:hgetall('user:'..v)
  if user_info and user_info.print_name then
   local print_name = string.gsub(user_info.print_name, "_", " ")
   local print_name = string.gsub(print_name, "‮", "")
   text = text.."*"..k.." - "..print_name.."* _["..v.."]_\n"
  else
   text = text.."*"..k.." -* _"..v.."_\n"
  end
 end
        return text
end

function user_list()
  local users = '*Tweet Sender Status*\nIn '..os.date("`%F - %H:%M:%S`")..'\n_~> '..redis:scard('users')..' User_'
return users
end

function mem_info(user_id) 
 local send = send_api.."/getChatMember?chat_id=@tvshowtweet&user_id="..user_id 
 return send_req(send) 
end 
-----------------------------------------------------------------------------------

local function run(msg, matches)
local is_blocked =  redis:sismember('blocked',msg.from.id)
      if is_blocked and msg.chat.type == "private" then
    return false
  end
if (matches[1] == "id" or  matches[1] == "🚦اطلاعات و هشتگ مخصوص شما") then
if not msg.reply_to_message then
return "_نام شما :_\n"..check_markdown(msg.from.first_name).."\n_یوزرنیم شما_ :\n[@"..(check_markdown(msg.from.username or "")).."](tg://user?id="..msg.from.id..")\n_هشتگ مخصوص شما زیر توییت های ارسالی :_\n#"..check_markdown(msg.from.first_name).."\n\n⭐️"
elseif msg.reply_to_message then
return "*"..msg.reply_to_message.from.id.."*"
   end
end

--if matches[1] == "setrealm" and is_sudo(msg) then
--   redis:set("realm",msg.chat.id)
--return "*Realm has been add*"
--end

--if matches[1] == "tw" or matches[1] == "🎯اعضای تیم"  then
--return _config.info_text
--end
if matches[1] == "users" and is_sudo(msg) then
return user_list()
end
if matches[1] == "help" and is_sudo(msg) then
return help_text


end
if matches[1] == "help" or matches[1] == "🔖راهنما" then
return mem_help
end
if matches[1] == "📬پروفایل" then
return profile_text
end
if matches[1] == "blocklist" and is_sudo(msg) then
return blocked_list(msg)
end
if matches[1] == "sudolist" and is_sudo(msg) then
return sudolist(msg)
end
if matches[1] == "clean blocklist" and is_sudo(msg) then
redis:del('blocked')
return "*Block list has been cleaned*"
end
if matches[1] == "block" and is_sudo(msg) then
if matches[2] then
redis:sadd('blocked',matches[2])
send_msg(matches[2], "*You Are Blocked By Admin Command*\n_شما به دستور ادمین بلاک شدید_", "markdown")
return "_User_ *"..matches[2].."* _has been blocked_"
end
if msg.reply_to_message and msg.reply_to_message.forward_from then
  local user = msg.reply_to_message.forward_from.id
redis:sadd('blocked',user)
send_msg(user, "*You Are Blocked By Admin Command*\n_شما به دستور ادمین بلاک شدید_", "markdown")
return "_User_ *"..user.."* _has been blocked_"
end
end
if matches[1] == "unblock" and is_sudo(msg) then
if matches[2] then
redis:srem('blocked',matches[2])
send_msg(matches[2], "*You Are Unblocked By Admin Command*\n_شما به دستور ادمین از بلاک خارج شدید_", "markdown")
return "_User_ *"..matches[2].."* _has been unblocked_"
end
if msg.reply_to_message and msg.reply_to_message.forward_from then
  local user = msg.reply_to_message.forward_from.id
redis:srem('blocked',user)
send_msg(user, "*You Are Unblocked By Admin Command*\n_شما به دستور ادمین از بلاک خارج شدید_", "markdown")
return "_User_ *"..user.."* _has been unblocked_"
end
end

if matches[1] == "sendtoall" and matches[2] and is_sudo(msg) then
local list = redis:smembers('users')
    for i = 1, #list do
send_msg(list[i], matches[2], "markdown")
   end
return "*Sent to "..redis:scard('users').." user*"
end
if matches[1] == "fwdtoall" and is_sudo(msg) then
local list = redis:smembers('users')
    for i = 1, #list do
forwardMessage(list[i],msg.chat.id,msg.reply_to_message.message_id)
   end
return "*Sent to "..redis:scard('users').." user*"
end
if matches[1] == "reload" and is_sudo(msg) then
   bot_run()
  reload_plugins(true)
return "*Done*\nTweet Sender Reloaded In "..os.date("`%F - %H:%M:%S`")..""
end
     if matches[1] == 'antiflood' and is_sudo(msg) then
local hash = 'anti-flood'
--Enable Anti-flood
     if matches[2] == 'on' then
  if not redis:get(hash) then
    return '_Private_ *flood protection* _is already_ *enabled*'
    else
    redis:del(hash)
   return '_Private_ *flood protection* _has been_ *enabled*'
      end
--Disable Anti-flood
     elseif matches[2] == 'off' then
  if redis:get(hash) then
    return '_Private_ *flood protection* _is already_ *disabled*'
    else
    redis:set(hash, true)
   return '_Private_ *flood protection* _has been_ *disabled*'
                   end
             end
       end
     if matches[1] == 'autoleave' and is_sudo(msg) then
local hash = 'AutoLeave'
--Enable Auto Leave
     if matches[2] == 'on' then
  if not redis:get(hash) then
    return '*Auto Leave* _is already_ *enabled*'
    else
    redis:del(hash)
   return '*Auto Leave* _has been_ *enabled*'
      end
--Disable Auto Leave
     elseif matches[2] == 'off' then
  if redis:get(hash) then
    return '*Auto Leave* _is already_ *disabled*'
    else
    redis:set(hash, true)
   return '*Auto Leave* _has been_ *disabled*'
                   end
             end
       end
                if matches[1] == 'setpvfloodtime' and is_sudo(msg) then
                    if not matches[2] then
                    else
                        hash = 'flood_time'
                        redis:set(hash, matches[2])
            return '_Private_ *flood check time* _has been set to :_ *'..matches[2]..'*'
                    end
          elseif matches[1] == 'setpvflood' and is_sudo(msg) then
                    if not matches[2] then
                    else
                        hash = 'flood_max'
                        redis:set(hash, matches[2])
            return '_Private_ *flood sensitivity* _has been set to :_ *'..matches[2]..'*'
                    end
                 end
  if tonumber(msg.from.id) == sudo_id then
    if matches[1]:lower() == "setsudo" then
if matches[2] and not msg.reply_to_message then
        local user_id = matches[2]
     if already_sudo(tonumber(user_id)) then
    return 'User '..user_id..' is already sudo users'
         else
          table.insert(_config.sudo_users, tonumber(user_id)) 
      print(user_id..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
      return "User "..user_id.." added to sudo users" 
       end
elseif not matches[2] and msg.reply_to_message then
        local user_id = msg.reply_to_message.from.id
     if already_sudo(tonumber(user_id)) then
    return 'User '..user_id..' is already sudo users'
         else
          table.insert(_config.sudo_users, tonumber(user_id)) 
      print(user_id..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
      return "User "..user_id.." added to sudo users" 
           end
       end
  end
      if matches[1]:lower() == "remsudo" then
if matches[2] and not msg.reply_to_message then
      local user_id = tonumber(matches[2]) 
     if not already_sudo(user_id) then
    return 'User '..user_id..' is not sudo users'
         else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, k)) 
      print(user_id..' removed from sudo users') 
     save_config() 
     reload_plugins(true) 
      return "User "..user_id.." removed from sudo users"
       end
elseif not matches[2] and msg.reply_to_message then
      local user_id = tonumber(msg.reply_to_message.from.id) 
     if not already_sudo(user_id) then
    return 'User '..user_id..' is not sudo users'
         else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, k)) 
      print(user_id..' removed from sudo users') 
     save_config() 
     reload_plugins(true) 
      return "User "..user_id.." removed from sudo users"
               end
           end
       end
   end
end

local function pre_process(msg)
local botcmd = msg.text == "/start" or msg.text == "/reload" or msg.text == "/setrealm" or msg.text == "/setstart (.*)" or msg.text == "/id" or msg.text == "/blocklist" or msg.text == "/users" or msg.text == "/block (%d+)" or msg.text == "/unblock (%d+)" or msg.text == "/clean blocklist" or msg.text == "/setsudo (%d+)" or msg.text == "/remsudo (%d+)" or msg.text == "/antiflood (.*)" or msg.text == "/setpvflood (%d+)" or msg.text == "/setpvfloodtime (%d+)" or msg.text == "/help" or msg.text == "/sudolist" or msg.text == "/sendtoall (.*)" or msg.text == "/tw" or msg.text == "🚦اطلاعات و هشتگ مخصوص شما" or msg.text == "📬پروفایل" or msg.text == "🎯اعضای تیم" or msg.text == "🌟کانال ما" or msg.text == "🔖راهنما" or msg.text == "/block" or msg.text == "/unblock" or msg.text == "/setsudo" or msg.text == "/remsudo" or msg.text == "/autoleave (.*)" or msg.text == "/fwdtoall"

  if msg.new_chat_participant or msg.new_chat_title or msg.new_chat_photo or msg.left_chat_participant then return end
  if msg.date < os.time() - 5 then
    return
    end
if msg.chat.type ~= "private" and not redis:get('AutoLeave') and redis:get("realm") and tonumber(msg.chat.id) ~= tonumber(redis:get("realm")) and not is_sudo(msg) then
  send_msg(msg.chat.id, "_:-)_", "markdown")
   LeaveGroup(msg.chat.id)
end
    if msg.text == "🌟کانال ما"  then
   return send_key(msg.from.id, "[Our Channel]",markdown)
 end
if msg.text == "/start" and msg.chat.type == "private" then
res = mem_info(msg.from.id)
    if not res or (res.result.status == 'left' or res.result.status == 'kicked') then 
        ozvsho = [[سلام دوست عزیز
برای ارسال توییت در ربات باید در کانال ما عضو باشید.
@tvshowtweet
بعد از عضویت در کانال دوباره 
/start 
کنید.🌹]] 
    return send_msg(msg.from.id, ozvsho, true)
	end
    if not redis:get("setstart") then
   startmsg = "دوست عزیز "..check_markdown(msg.from.first_name).."\nسلام به ربات توییت سندر خوش آمدید!\nلطفا قبل از ارسال توییت راهنمای ربات را کامل مطالعه نمایید."
       else
    startmsg = redis:get("setstart")
  end
  add_user(msg)
startmsg = startmsg:gsub("{name}", check_markdown(msg.from.first_name))
startmsg = startmsg:gsub("{username}", check_markdown((msg.from.username or "")))
send_key(msg.from.id, startmsg, keyboard)
end

--if redis:get("realm") then
--    realm = redis:get("realm")
--       else
--    realm = sudo_id
--  end
local is_blocked =  redis:sismember('blocked',msg.from.id)
   if not botcmd then
 if msg.chat.type == "private" then
add_user(msg)
     if not msg.sticker and not msg.forward_from and not msg.photo and not msg.document and not msg.video and not msg.voice and not msg.venue and not msg.video_note and not msg.audio and not msg.location and not msg.game and not msg.contact then
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
  local emoji = {
  "✔️",
  "⚡️",
  "💢",
  "🔴",
  "💎",
  "◽️",
  "💫",
  "⭐️",
  "🌟",
  "🔥",
  "💥",
  "🛡",
  "🔮",
  "💈",
  "🔰",
  "〽️",
  "🔰",
  "♨️",
  "⚪️",
  "⚫️",
  "🔴",
  "🔵",
  "🔺",
  "🔷",
  "🔶",
  "🔹",
  "🔻",
  "🔸",
  "🔳",
  "🔲"
  }
  local emoji2 = {
  "✔️",
  "⚡️",
  "💢",
  "🔴",
  "💎",
  "◽️",
  "💫",
  "⭐️",
  "🌟",
  "🔥",
  "💥",
  "🛡",
  "🔮",
  "💈",
  "🔰",
  "〽️",
  "🔰",
  "♨️",
  "⚪️",
  "⚫️",
  "🔴",
  "🔵",
  "🔺",
  "🔷",
  "🔶",
  "🔹",
  "🔻",
  "🔸",
  "🔳",
  "🔲"
  }
  captin = "\n"..emoji2[math.random(#emoji2)].." #"..check_markdown(msg.from.first_name).."\n"..emoji[math.random(#emoji)].." @TvShowTweet"
  ersal = "یک توییت از سوی @["..msg.from.username.."] در ساعت "..os.date("`%H:%M:%S`").." دریافت شد.\n کد پیگیری توییت : `"..msg.message_id.."`"
  py = "_کد پیگیری :_ `"..msg.message_id.."`\n_ساعت ارسال :_ "..os.date("`%H:%M:%S`").."\n🔻🔻🔻🔻🔻🔻"
  sendmsg = "_توییت ارسالی شما به کانال فرعی ارسال شد پس از بررسی توسط ادمین ها به کانال اصلی انتقال خواهد یافت._\n\nکد پیگیری توییت شما : `"..msg.message_id.."`"
send_msg(channel_ersali, py, "markdown")
send_msg(channel_ersali, msg.text..captin, "markdown")
send_msg(msg.chat.id, sendmsg, "markdown")
--send_inline(gpmod, ersal ,do_keyboard_one(), "markdown")
send_msg(gpmod, ersal, "markdown")
   end
end
if msg.sticker then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال استیکر مجاز نمی باشد!", "markdown")
       end
   end
   
if msg.audio then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال موسیقی مجاز نمی باشد!", "markdown")
       end
   end
   
 if msg.photo then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال تصاویر مجاز نمی باشد!", "markdown")
       end
   end  
   
if msg.contact then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال کانتکت مجاز نمی باشد!", "markdown")
       end
   end     
   
 if msg.venue then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال گیف مجاز نمی باشد!", "markdown")
       end
   end    

   
if msg.game then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال بازی مجاز نمی باشد!", "markdown")
       end
   end    
   
 if msg.video then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال ویدیو مجاز نمی باشد!", "markdown")
       end
   end   
   
 if msg.location then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال موقعیت مکانی مجاز نمی باشد!", "markdown")
       end
   end   
   
if msg.voice then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال ویس مجاز نمی باشد!", "markdown")
       end
   end   
   
if msg.video_note then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال ویدیو نت مجاز نمی باشد!", "markdown")
       end
   end      
   
if msg.document then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "ارسال فایل مجاز نمی باشد!", "markdown")
       end
   end  
   
   
if msg.forward_from then
add_user(msg)
if msg.from.username then
    user_name = '@'..msg.from.username
       else
    user_name = msg.from.first_name
  end
if is_blocked then
if redis:get('user:'..msg.from.id..':flooder') then
return
else
send_msg(msg.chat.id, "*You Are Block...!*\n_شما بلاک شده اید_", "markdown")
end
  else
send_msg(msg.chat.id, "فروارد به ربات مجاز نمی باشد!", "markdown")
         end
      end
   end
end

    local hash = 'flood_max'
    if not redis:get(hash) then
        MSG_NUM_MAX = 5
    else
        MSG_NUM_MAX = tonumber(redis:get(hash))
    end

    local hash = 'flood_time'
    if not redis:get(hash) then
        TIME_CHECK = 2
    else
        TIME_CHECK = tonumber(redis:get(hash))
    end
    if msg.chat.type == 'private' then
        --Checking flood
        local hashse = 'anti-flood'
        if not redis:get(hashse) then
            print('anti-flood enabled')
            -- Check flood
                if not is_sudo(msg) then
                    -- Increase the number of messages from the user on the chat
                    local hash = 'flood:'..msg.from.id..':msg-number'
                    local msgs = tonumber(redis:get(hash) or 0)
                    if msgs > MSG_NUM_MAX then
   if msg.from.username then
    user_name = "@"..msg.from.username
       else
    user_name = msg.from.first_name
   end
if redis:get('user:'..msg.from.id..':flooder') then
return
else
  send_msg(msg.chat.id, "_You are_ *blocked* _because of_ *flooding...!*", "markdown")
    redis:sadd("blocked", msg.from.id)
   send_msg(gpmod, 'User [ '..user_name..' ] '..msg.from.id..' has been blocked because of flooding!')
redis:setex('user:'..msg.from.id..':flooder', 15, true)
                       end
                    end
                    redis:setex(hash, TIME_CHECK, msgs+1)
             end
         end
    end
end
return {
patterns ={
"^(📬پروفایل)$",
"^[/](id)$",
"^[/](userid)$",
"^(🚦اطلاعات و هشتگ مخصوص شما)$",
"^[/](reload)$",
"^[/](help)$",
"^(🔖راهنما)$",
"^(🌟کانال ما)$",
"^[/](blocklist)$",
"^[/](sudolist)$",
"^[/](tw)$",
"^(🎯اعضای تیم)$",
"^[/](clean blocklist)$",
"^[/](users)$",
"^[/](setstart) (.*)$",
"^[/](setprofiletext) (.*)$",
"^[/](sendtoall) (.*)$",
"^[/](fwdtoall)$",
"^[/](antiflood) (.*)$",
"^[/](autoleave) (.*)$",
"^[/](setsent) (.*)$",
"^[/](block) (%d+)$",
"^[/](unblock) (%d+)$",
"^[/](block)$",
"^[/](unblock)$",
"^[/](setsudo)$",
"^[/](remsudo)$",
"^[/](setsudo) (%d+)$",
"^[/](remsudo) (%d+)$",
"^[/](setpvflood) (%d+)$",
"^[/](setpvfloodtime) (%d+)$",
"^[/](setrealm)$"
},
run=run,
pre_process=pre_process
}
