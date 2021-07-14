local conf = require('telescope.config').values
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local entry_display = require('telescope.pickers.entry_display')
local list = function(opts)
  local handle = io.popen("makelist")
  local result = handle:read("*a")
  handle.close()
  local items = {}
  for s in result:gmatch("[^\r\n]+") do
    items[#items+1] = {
      text = s,
    }
  end
  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 50 },
    }
  }
  local make_display = function(entry)
    return displayer {
      entry.text,
    }
  end
  pickers.new(opts, {
    prompt_title = 'Make List',
    finder = finders.new_table{
      results = items,
      entry_maker = function(entry)
        return {
          valid = true,
          ordinal = entry.text,
          display = make_display,
          text = entry.text,
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end
return require('telescope').register_extension{
  exports = {
    list = list,
  }
}
