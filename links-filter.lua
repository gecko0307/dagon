function Link(el)
  local target = el.target
  if target:match("%.md$") or target:match("%.md#") then
    return el.content
  end
  return el
end
