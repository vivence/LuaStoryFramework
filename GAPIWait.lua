
------ private function ----->

local function _tableClear( t )
	for k,_ in pairs(t) do
		t[k] = nil
	end
end

local function _arrayPush(a, t)
	a[#a+1] = t
end

local function _arrayPop(a)
	local len = #a
	if 0 < len then
		local t = a[len]
		a[len] = nil
		return t
	end
	return nil
end

local table_pool = {}

local function _poolPush(t)
	_arrayPush(table_pool, t)
end

local function _poolPop()
	return _arrayPop(table_pool) or {}
end

------ private function -----<

GAPIWait = Ghost.class("GAPIWait", GAPI)

function GAPIWait:ctor( name )
	GAPIWait.super.ctor(self)
	self.name = name or 'no_name'
	self.story_infos = {}
end

------ override function ----->
function GAPIWait:call( context, ... )
	self:_register(context, ...)
	return Ghost.sleepStory(context)
end
------ override function -----<

function GAPIWait:signal( ... )
	local story_infos = self.story_infos
	self.story_infos = _poolPop()

	local loged = false

	for i=#story_infos, 1, -1 do
		local info = story_infos[i]
		story_infos[i] = nil
		if not info.context:isClosed() then
			if self:_checkSignal(info, ...) then
				if not loged then
					loged = true
					self:_log(nil, string.format('[%s]signal', self.name), ...)
				end
				Ghost.awakeStory(info.context, info.co_name, ...)
				_tableClear(info)
				_poolPush(info)
			else
				-- put back
				_arrayPush(self.story_infos, info)
			end
		end
	end

	_poolPush(story_infos)
end

function GAPIWait:_register( context, ... )
	self:_log(context, string.format('[%s]signal', self.name), ...)

	local info = _poolPop()
	info.context = context
	info.co_name = context:getCoName()
	self:_setArgs(info, ...)
	_arrayPush(self.story_infos, info)
end

------ virtual function ----->

function GAPIWait:_log( context, tag, ... )
	if nil ~= context then
		-- register
		context:debugLog(tag)
	else
		-- signal
		gprint(tag)
	end
end

function GAPIWait:_setArgs( info, ... )
	if nil ~= ... then
		info.args = {...}
	end
end

function GAPIWait:_checkSignal( info, ... )
	return true
end

------ virtual function -----<

