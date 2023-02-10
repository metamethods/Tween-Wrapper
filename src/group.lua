local Package = script.Parent
local Tween = require(Package.tween)
local Await = require(Package.await)

local TweenGroup = {}
TweenGroup.__index = TweenGroup

type Settings = {
  staggerTweens: number?,
  delayTweens: number?,

  transition: TweenInfo?
}

function TweenGroup.new(
  tweens: { Tween.Wrapper },
  settings: Settings?
): TweenGroup
  return setmetatable({
    _tweens = tweens,
    _settings = settings or {}
  }, TweenGroup)
end

function TweenGroup.Play(
  self: TweenGroup,
  name: string,
  transition: TweenInfo?
)
  Await(self._settings.delayTweens or 0, function()
    for _, tween: Tween.Wrapper in self._tweens do
      tween:Animate(name, self._settings.transition or transition or nil)
      Await(self._settings.staggerTweens or 0)
    end
  end)
end

function TweenGroup.Reset(
  self: TweenGroup
)
  self:Play('Initial')
end

export type TweenGroup = typeof(TweenGroup.new(table.unpack(...)))

return TweenGroup