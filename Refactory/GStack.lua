
GStack = Ghost.class("GStack")

function GStack:ctor()
	self.array = {}
end

function GStack:getCount()
	return #self.array
end

function GStack:isEmpty()
	return 0 == #self.array
end

function GStack:push(v)
	local array = self.array
	array[#array+1] = v
end

function GStack:peek()
	local array = self.array
	if 0 < #array then
		return array[#array]
	else
		return nil
	end
end

function GStack:pop()
	local array = self.array
	if 0 < #array then
		local v = array[#array]
		array[#array] = nil
		return v
	else
		return nil
	end
end