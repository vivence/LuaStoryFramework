GAPIWaitCondition = Ghost.class("GAPIWaitCondition", GAPIWait)

function GAPIWaitCondition:ctor()
	GAPIWaitCondition.super.ctor(self)
end

------ override function ----->
function GAPIWaitCondition:_setArgs( info, condition )
	gassert(nil ~= condition, 'condition is nil')
	info.condition = condition
end

function GAPIWaitCondition:_checkSignal( info, ... )
	return info.condition(...)
end
------ override function ----->