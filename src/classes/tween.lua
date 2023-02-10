local TweenService = game:GetService('TweenService')

local Wrapper = {}
Wrapper.__index = Wrapper

type Animatable = number | CFrame | Color3 | ColorSequenceKeypoint | DateTime | NumberRange | NumberSequenceKeypoint | PhysicalProperties | Ray | Rect | Region3 | Region3int16 | UDim | UDim2 | Vector2 | Vector2int16 | Vector3 | Vector3int16
type Changes = { [string]: Animatable }
type Properties = { [string]: any }
type Edits = { changes: Changes?, properties: Properties? }
type Data = { animation: Edits, transition: TweenInfo }

function Wrapper.new(
	object: Instance,
	inital: Edits?,
	transition: TweenInfo?
): Wrapper
	local self = setmetatable({}, Wrapper)

	self._object = object
	self._tweens = {}
	self:Create('Inital', inital or {}, transition):Animate('Inital')

	return self
end

function Wrapper.Create(
	self: Wrapper,
	name: string,
	animation: Edits,
	transition: TweenInfo?
): Wrapper

	self._tweens[name] = {
		animation = { changes = animation.changes or {}, properties = animation.properties or {} },
		transition = transition or TweenInfo.new(1)
	}

	return self
end

function Wrapper.Remove(
	self: Wrapper,
	name: string
): Wrapper
	self._tweens[name] = nil

	return self
end

function Wrapper.Animate(
	self: Wrapper,
	name: string,
	transition: TweenInfo?
): Tween
	local data = self._tweens[name] :: Data; assert(data, `Couldn't find animation named "{name}"`)
	local tween = TweenService:Create(self._object, transition or data.transition, data.animation.changes); tween:Play()

	for propertyName, propertyValue in data.animation.properties do self._object[propertyName] = propertyValue end

	return tween
end

export type Wrapper = typeof(Wrapper.new(table.unpack(...)))

return Wrapper