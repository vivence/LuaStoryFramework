-- print('require GSample')

------ private function ----->

local _apiPost = Ghost.apiPost
local _apiWait = Ghost.apiWait

GSampleXXXX = {}

local function _step1( context )
	_apiPost('PRINT', context, 'sample.step1')
	-- create a new story
	-- _apiPost('NEW_STORY', context, GSampleXXXX)

	-- do nothing and goto step 2
	context.step = 2
end

local function _step2( context )
	_apiPost('PRINT', context, 'sample.step2')

	local n = 5
	context.test_count = 0
	for i=1, n do
		_apiWait('ONE_FRAME', context) -- important!!!

		_apiPost('PRINT', context, 
			string.format('rest test: %d', n-context.test_count))

		_apiWait('TEST', context)

		context.test_count = context.test_count+1
	end

	-- end story
	context.step = 0
end

GSampleXXXX[1] = _step1
GSampleXXXX[2] = _step2

------ private function -----<
