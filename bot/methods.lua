function send_msg(chat_id, text, use_markdown, reply_to_message_id)

	local url = send_api .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. url.escape(text)

	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

	if use_markdown then
		url = url .. '&parse_mode=Markdown'
	end

	return send_req(url)

end

function send_document(chat_id, name)
	local send = send_api.."/sendDocument"
	local curl_command = 'curl -s "'..send..'" -F "chat_id='..chat_id..'" -F "document=@'..name..'"'
	return io.popen(curl_command):read("*all")
end

function forwardMessage(chat_id, from_chat_id, message_id)

	local url = send_api .. '/forwardMessage?chat_id=' .. chat_id .. '&from_chat_id=' .. from_chat_id .. '&message_id=' .. message_id

	return send_req(url)

end

function send_key(chat_id, text, keyboard, resize, mark)
	local response = {}
	response.keyboard = keyboard
	response.resize_keyboard = resize
	response.one_time_keyboard = false
	response.selective = false
	local responseString = JSON.encode(response)
	if mark then
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	else
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	end
	return send_req(sended)
end

function string:input()
	if not self:find(' ') then
		return false
	end
	return self:sub(self:find(' ')+1)
end

function serialize_to_file(data, file, uglify)
  file = io.open(file, 'w+')
  local serialized
  if not uglify then
    serialized = serpent.block(data, {
        comment = false,
        name = '_'
      })
  else
    serialized = serpent.dump(data)
  end
  file:write(serialized)
  file:close()
end

function is_sudo(msg)
  local var = false
  -- Check users id in config
  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
      var = true
    end
  end
  return var
end

function check_markdown(text) --markdown escape ( when you need to escape markdown , use it like : check_markdown('your text')
		str = text
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
	return output
end

function getChatMember(chat_id, user_id)
 local url = send_api .. '/getChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id
   return send_req(url)
end

function LeaveGroup(chat_id)
  local url = send_api .. '/leaveChat?chat_id=' .. chat_id
  return send_req(url)
end


local function send_inline(chat_id, text, keyboard, markdown)
	
	local url = BASE_URL .. '/sendMessage?chat_id=' .. chat_id
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url..'&text='..URL.escape(text)
	
	url = url..'&disable_web_page_preview=false'
	
	url = url..'&reply_markup='..JSON.encode(keyboard)
	
	return send_req(url)

end

local function editMessageText(chat_id, message_id, text, keyboard, markdown)
	
	local url = BASE_URL .. '/editMessageText?chat_id=' .. chat_id .. '&message_id='..message_id..'&text=' .. URL.escape(text)
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url .. '&disable_web_page_preview=true'
	
	if keyboard then
		url = url..'&reply_markup='..JSON.encode(keyboard)
	end
	
	return send_req(url)

end

local function answerCallbackQuery(callback_query_id, text, show_alert)
	
	local url = BASE_URL .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	
	if show_alert then
		url = url..'&show_alert=true'
	end
	
	return send_req(url)
	
end