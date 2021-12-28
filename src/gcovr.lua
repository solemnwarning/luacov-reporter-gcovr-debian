local reporter = require'luacov.reporter'

local json
for _,j in ipairs({'cjson','dkjson'}) do
  local ok, mod = pcall(require,j)
  if ok then
    json = mod
    break
  end
end

if not json then
  return error('no json module available')
end

local gcovr = setmetatable({},reporter.ReporterBase)
gcovr.__index = gcovr

function gcovr:on_start()
  self._gcovr_data = {
    files = {},
    ['gcovr/format_version'] = '0.2',
  }
end

function gcovr:on_new_file(filename)
  self._gcovr_data.files[filename] = {
    file = filename,
    lines = {},
  }
end

function gcovr:on_empty_line(filename, lineno)
  table.insert(self._gcovr_data.files[filename].lines,{
    branches = {},
    count = 0,
    ['gcovr/noncode'] = true,
    line_number = lineno,
  })
end

function gcovr:on_mis_line(filename, lineno, _)
  table.insert(self._gcovr_data.files[filename].lines,{
    branches = {},
    count = 0,
    ['gcovr/noncode'] = false,
    line_number = lineno,
  })
end

function gcovr:on_hit_line(filename, lineno, _, hits)
  table.insert(self._gcovr_data.files[filename].lines,{
    branches = {},
    count = hits,
    ['gcovr/noncode'] = false,
    line_number = lineno,
  })
end

function gcovr:on_end()
  local newfiles = {}
  for _,v in pairs(self._gcovr_data.files) do
    table.insert(newfiles,v)
  end
  self._gcovr_data.files = newfiles
  self:write(json.encode(self._gcovr_data))
  self._gcovr_data = nil
end

return {
  GcovrReporter = gcovr,
  report = function()
    return reporter.report(gcovr)
  end,
}
