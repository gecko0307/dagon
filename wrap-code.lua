function Code(el)
  local text = el.text:gsub("\\", "\\backslash{}")
                      :gsub("_", "\\_")
                      :gsub("&", "\\&")
                      :gsub("{", "\\{")
                      :gsub("}", "\\}")
                      :gsub("%$", "\\$")
                      :gsub("#", "\\#")
                      :gsub("%%", "\\%%")
                      :gsub("%^", "\\^{}") 

  text = text:gsub("%.", ".\\allowbreak{}")
             :gsub("%-", "-\\allowbreak{}")
             :gsub("/", "/\\allowbreak{}")
             :gsub("\\%_", "\\_\\allowbreak{}")

  return pandoc.RawInline('tex', '\\texttt{' .. text .. '}')
end
