-- print('require GSample')

------ private function ----->

local _apiPost = Ghost.apiPost
local _apiWait = Ghost.apiWait

--<--natitive search--<--(-n is try reverse search the nth)
-- [1, 2, 3, 4, ...] -- steps line
-->--positive search-->--(n is try search the nth)

GSampleXXXX = {
	VERSION = '1.0',
	INVALID_STEPS = {
		[2] = {rollback_step=1, rollback_search=-1}
	}
}

-- return next_step(nil is 0), rollback_search(nil is 0)
local function _step1_nothing( context )
	_apiPost('PRINT', context, 'sample.step1')
	-- create a new story
	-- _apiPost('NEW_STORY', context, GSampleXXXX)

	-- do nothing and goto step 2
	return 2,0
end

-- return next_step(nil is 0), rollback_search(nil is 0)
local function _step2_test5( context )
	_apiPost('PRINT', context, 'sample.step2')

	local n = 5

	context:init('test_count', 0)

	while context.test_count < n do
		_apiWait('ONE_FRAME', context) -- important!!!

		_apiPost('PRINT', context, 
			string.format('rest test: %d', n-context.test_count))

		_apiWait('TEST', context)

		context.test_count = context.test_count+1
	end

	-- end story
	return 0,0
end

GSampleXXXX[1] = _step1_nothing -- command list MD5
GSampleXXXX[2] = _step2_test5   -- command list MD5

------ private function -----<
