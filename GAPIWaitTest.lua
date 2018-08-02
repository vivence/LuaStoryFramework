GAPIWaitTest = Ghost.class("GAPIWaitTest", GAPIWait)

function GAPIWaitTest:ctor( name )
	GAPIWaitTest.super.ctor(self, name)
end

------ override function ----->

function GAPIWaitTest:_log( context, tag, num )
	if nil ~= context then
		-- register
		context:debugLog(tag..': '..num)
	else
		-- signal
		gprint(tag..': '..num)
	end
end

function GAPIWaitTest:_setArgs( info, num )
	info.num = num
end

function GAPIWaitTest:_checkSignal( info, num )
	return info.num == num
end

------ override function ----->