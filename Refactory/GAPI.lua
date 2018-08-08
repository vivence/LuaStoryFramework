
local api_map = {}

-------------- private interface -------------->
local function _recordAPICall(story, name, ...)
	local data = story:getDataProxy()
	data._thread_name = story:getCurrentThreadName()
	data._api_name = name
	if nil ~= ... then
		data._api_params = {...}
	else
		data._api_params = nil
	end
end
local function _recordAPIReturn(story, ...)
	local data = story:getDataProxy()
	if nil ~= ... then
		data._api_return = {...}
	else
		data._api_return = nil
	end
end
-------------- private interface --------------<

------ static function ----->
function Ghost.registerAPI(name, api)
	gassert(nil ~= name and '' ~= name, 'register api no name')
	api:setName(name)
	api_map[name] = api
end

function Ghost.getAPI(name)
	return api_map[name]
end

function Ghost.callAPI(name, ...)
	local api = api_map[name]
	gassert(nil ~= api, 'no api')

	local story = Ghost.getCurrentStory()
	if story:isModeNormal() then
		-- 1.
		_recordAPICall(story, name, ...)
		-- 2.
		_recordAPIReturn(story, api:call(story, ...))
		-- 3.
		story:recordAPICall()
		-- story.data:historyPrint()
	elseif story:isModeRestore() then
		-- TODO
	elseif story:isModeClose() then
		-- TODO
	end
end
------ static function ----->

GAPI = Ghost.class("GAPI")

function GAPI:ctor()
end

function GAPI:setName(name)
	self.name = name
end

------ virtual function ----->
function GAPI:call( story, ... )
	gassert(false, 'no api-call implementation')
end
------ virtual function -----<