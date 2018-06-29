
------ private function ----->

local GWaitEnum = {
	ONE_FRAME = Ghost.regSignalNextFrame,
	TEST = Ghost.regSignalTest,
}

------ private function -----<

-------------- public interface -------------->

function Ghost.class(cname, super)
	local cls
	if super then
		cls = {}
		setmetatable(cls, {__index = super})
		cls.super = super
	else
		cls = {ctor = function() end}
	end
	cls.__index = cls -- as a metatable
	cls.__tostring = function(self)
		return string.format('<%s> instance', self._cname)
	end
	cls._cname = cname

	function cls.new(...)
		local instance = setmetatable({}, cls)
		instance.class = cls
		instance:ctor(...)
		return instance
	end
	return cls
end 

-------------- public interface --------------<