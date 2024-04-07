local colors_name = "zenbones-latte"
vim.g.colors_name = colors_name -- Required when defining a colorscheme

local lush = require "lush"
local hsluv = lush.hsluv -- Human-friendly hsl
local util = require "zenbones.util"

local bg = vim.o.background

-- Define a palette. Use `palette_extend` to fill unspecified colors
local palette
if bg == "light" then
	palette = util.palette_extend({
    --bg = hsluv "#e1e1e1",
    --fg = hsluv("#616161").da(12),
    --rose = hsluv("#e17899").da(12),
    --leaf = hsluv("#719872").da(12),
    --wood = hsluv("#e19972").da(12),
    --water = hsluv("#0099bd").da(12),
    --blossom = hsluv("#9a7599").da(12),
    --sky = hsluv("#009799").da(12),
    --orange = hsluv("#9a7200").da(12),
	}, bg)
end

-- Generate the lush specs using the generator util
local generator = require "zenbones.specs"
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function(injected_functions)
  local sym = injected_functions.sym

	return {
    Constant { gui = "normal" }, -- Disable italic
    Identifier { fg = hsluv("#0099bd").da(55) },
    Function { fg = hsluv("#e17899").da(35) },
    Type { fg = hsluv("#e1e1e1").sa(20).da(55) },

    sym "@function.call.ruby" { Function },
    sym "@variable.ruby" { Type },
	}
end)

-- Pass the specs to lush to apply
lush(specs)

-- Optionally set term colors
require("zenbones.term").apply_colors(palette)
