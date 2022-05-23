table.contains = function(t, element)
  for _, val in ipairs(t) do
    if val == element then
      return true
    end
  end
  return false
end
