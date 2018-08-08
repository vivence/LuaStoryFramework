
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
	setmetatable(proxy, mt)

	return proxy
end
-------------- private interface --------------<

GData = Ghost.class("GData")

function GData:ctor()
	self._history = {}
	self._snapshot = {}

	self._data = {}
	self._allow_recording = false

	self.proxy = _createProxy(self, self._data)
end

function GData:setStory(story)
	self.story = story
end

function GData:getProxy()
	return self.proxy
end

function GData:historyBegin()
	local story = self.story

	if story:isModeNormal() then
		local snapshot = self._snapshot
		for k,v in pairs(snapshot) do
			snapshot[k] = nil
		end

		local data = self._data
		for k,v in pairs(data) do
			snapshot[k] = v
		end

		self._allow_recording = true
	elseif story:isModeRestore() then
		-- TODO
	elseif story:isModeClose() then
		self._allow_recording = false
		-- TODO
	end
end

function GData:historyEnd()
	local story = self.story

	if story:isModeNormal() then
		local new_node = {}

		local snapshot = self._snapshot
		local data = self._data
		for k,v in pairs(data) do
			if snapshot[k] ~= v then
				-- new or changed
				new_node[k] = v
			end
		end

		_arrayPushBack(self._history, new_node)

		self._allow_recording = false
	elseif story:isModeRestore() then
		-- TODO
	elseif story:isModeClose() then
		self._allow_recording = false
		-- TODO
	end
end

function GData:historyPrint()
	local history = self._history
	gprint('----history---->')
	for i=1, #history do
		local node = history[i]
		for k,v in pairs(node) do
			gprint(string.format('%s = %s', tostring(k), tostring(v)))
		end
		if i ~= #history then
			gprint('----')
		end
	end
	gprint('----history----<')
end

-------------- private interface -------------->
function GData:_set(k, v)
	local story = self.story

	if story:isModeNormal() then
		gassert(self._allow_recording, 'recording is not allowed, you must call data:historyBegin()')
		rawset(self._data, k, v)
	elseif story:isModeRestore() then
		-- TODO
	elseif story:isModeClose() then
		-- TODO
	end
end
-------------- private interface --------------<













