
local api_map = {}

-------------- private interface -------------->
local function _packParams( ... )
	if nil ~= ... then
		return {...}
	else
		return nil
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
		local params = _packParams(...)
		local returns = _packParams(api:call(story, ...))
		
		story:recordAPICall(name, params, returns)
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