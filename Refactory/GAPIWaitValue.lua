GAPIWaitValue = Ghost.class("GAPIWaitValue", GAPIWait)

function GAPIWaitValue:ctor()
	GAPIWaitValue.super.ctor(self)
end

------ override function ----->
function GAPIWaitValue:_setArgs( info, value )
	info.value = value
end

function GAPIWaitValue:_checkSignal( info, value )
	return info.value == value
end
------ override function ----->