-- This is to skip over the task.wait if the time is less than or equal to 0.
-- Tries to prevent a very small amount of delay when time is 0

-- Usage:
-- Await(time: number, finished: (...any) -> any?)
-- Await(1, function() print('Finished') end)

return function (time: number, finished: ((...any) -> any)?)
  if time > 0 then task.wait(time) end
  finished = finished or function() end; finished()
end