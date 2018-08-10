
-------------- private interface -------------->
local function _arrayPushBack(array, v)
	array[#array+1] = v
end

local function _createProxy(data, _data)
	local proxy = {}

	local mt = {}
	mt.__index = _data
	mt.__newindex = function ( t,k,v )
		data:_set(k, v)
	end
	mt.__pairs = function(t)
		return pairs(_data)
	end
	setmetatable(proxy, mt)

	return proxy
end

local function _arrayToString(array, start_index, end_index)
	start_index = start_index or 1
	end_index = end_index or #array
	local result = {}
	local pos = 1
	for i=start_index, end_index do
		local v = array[i]
		local t = type(v)
		if 'nil' == t then
			result[pos] = '_nil'
		elseif 'boolean' == t then
			if v then
				result[pos] = 'true'
			else
				result[pos] = 'false'
			end
		elseif 'number' == t then
			result[pos] = v
		elseif 'string' == t then
			result[pos] = v
		elseif 'userdata' == t then
			result[pos] = '_userdata'
		elseif 'thread' == t then
			result[pos] = '_thread'
		elseif 'table' == t then
			result[pos] = string.format('{%s}', _arrayToString(v))
		elseif 'function' == t then
			result[pos] = '_function'
		end
		pos = pos+1
	end
	return table.concat(result, ",") or ''
end

local function _historyNodeToString(node)
	return string.format('%s(%s)', node[1], _arrayToString(node, 2))
end
-------------- private interface --------------<

GData = Ghost.class("GData")

GData.Action = {
	SET_DATA = 'setData',
	THREAD_AWAKE = 'threadAwake',
	THREAD_SLEEP = 'threadSleep',
	THREAD_END = 'threadEnd',
	API_CALL = 'apiCall',
	API_RETURN = 'apiReturn',
	SIGNAL = 'signal',
}

function GData:ctor()
	self._history = {}
	self._data = {}

	self.proxy = _createProxy(self, self._data)
end

function GData:setStory(story)
	self.story = story
end

function GData:getProxy()
	return self.proxy
end

function GData:record(action, ...)
	_arrayPushBack(self._history, {action, ...})
end

function GData:historyPrint()
	local history = self._history
	gprint('----history---->')
	local data = {}
	for i=1, #history do
		local node = history[i]
		gprint(string.format('[%d] %s', i, _historyNodeToString(node)))
	end
	gprint('----history----<')
end

-------------- private interface -------------->
function GData:_set(k, v)
	local story = self.story

	if story:isModeNormal() then
		if not story:isCurrentThreadClosing() then
			local t = type(v)
			if 'nil' == t 
				or 'boolean' == t 
				or 'number' == t 
				or 'string' == t 
				or 'table' == t then
				v = v or '_nil'
				rawset(self._data, k, v)
				self:record(GData.Action.SET_DATA, k, v)
			else-- 'userdata','thread','function'
				gassert(false, 'set data invalid type')
			end
		end
	elseif story:isModeRestore() then
		-- TODO
	elseif story:isModeClose() then
		-- TODO
	end
end
-------------- private interface --------------<













