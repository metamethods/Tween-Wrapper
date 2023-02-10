return function (time: number, finished: (...any) -> any?)
  if time <= 0 then finished(); return end
  task.wait(time)
  finished()
end