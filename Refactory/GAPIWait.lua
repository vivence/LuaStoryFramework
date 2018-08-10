
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

function GAPIWait:ctor()
	GAPIWait.super.ctor(self)
	self.story_infos = {}
end

------ override function ----->
function GAPIWait:call( story, ... )
	local info = self:_register(story, ...)
	return story:sleepThread(info.thread_name, ...)
end
------ override function -----<

function GAPIWait:signal( name, ... )
	local story_infos = self.story_infos
	self.story_infos = _poolPop()

	for i=#story_infos, 1, -1 do
		local info = story_infos[i]
		story_infos[i] = nil

		local story = info.story
		if story:isModeNormal() then
			if self:_checkSignal(info, ...) then
				story:recordSignal(name, ...)
				story:awakeThread(info.thread_name, ...)
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

function GAPIWait:_register( story, ... )
	local info = _poolPop()
	info.story = story
	info.thread_name = story:getCurrentThreadName()
	self:_setArgs(info, ...)
	_arrayPush(self.story_infos, info)
	return info
end

------ virtual function ----->
function GAPIWait:_setArgs( info, ... )
	if nil ~= ... then
		info.args = {...}
	end
end

function GAPIWait:_checkSignal( info, ... )
	return true
end

------ virtual function -----<

