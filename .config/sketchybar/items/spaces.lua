local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

-- Define aerospace workspaces based on your config
local aerospace_workspaces = {"1", "2", "3", "4", "5", "6", "7", "C", "B", "M", "WHO", "AD"}

-- Get current workspace to set initial state
local current_workspace = ""

-- Initialize all workspace items
for i, workspace_name in ipairs(aerospace_workspaces) do
  local space = sbar.add("item", "space." .. workspace_name, {
    icon = {
      font = { family = settings.font.numbers },
      string = workspace_name,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
      string = " —",
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.black,
    },
    popup = { background = { border_width = 5, border_color = colors.black } },
    drawing = true,  -- Ensure all spaces are drawn
  })

  spaces[workspace_name] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2
    }
  })

  -- Handle aerospace workspace changes
  space:subscribe("aerospace_workspace_change", function(env)
    local selected = env.FOCUSED_WORKSPACE == workspace_name
    space:set({
      icon = { highlight = selected, },
      label = { highlight = selected },
      background = { border_color = selected and colors.black or colors.bg2 }
    })
    space_bracket:set({
      background = { border_color = selected and colors.grey or colors.bg2 }
    })
  end)

  -- Handle mouse clicks for workspace switching
  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      -- Right click - show popup (optional feature)
      space:set({ popup = { drawing = "toggle" } })
    else
      -- Left click - switch to workspace using aerospace
      sbar.exec("aerospace workspace " .. workspace_name)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

-- Get current workspace on startup and set initial state
sbar.exec("aerospace list-workspaces --focused", function(result)
  local focused_workspace = result:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
  if focused_workspace and spaces[focused_workspace] then
    spaces[focused_workspace]:set({
      icon = { highlight = true },
      label = { highlight = true },
      background = { border_color = colors.black }
    })
  end
end)

-- Observer for window changes in aerospace workspaces
local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- Handle aerospace workspace window changes
space_window_observer:subscribe("aerospace_workspace_change", function(env)
  -- Update labels for all workspaces
  for _, workspace_name in ipairs(aerospace_workspaces) do
    sbar.exec("aerospace list-windows --workspace " .. workspace_name .. " --format %{app-name}", function(apps_output)
      local icon_line = ""
      local no_app = true
      
      -- Parse the output and count apps
      local app_counts = {}
      for app_name in apps_output:gmatch("[^\r\n]+") do
        if app_name and app_name ~= "" then
          no_app = false
          app_counts[app_name] = (app_counts[app_name] or 0) + 1
        end
      end
      
      -- Build icon line
      for app, count in pairs(app_counts) do
        local lookup = app_icons[app]
        local icon = ((lookup == nil) and app_icons["Default"] or lookup)
        icon_line = icon_line .. icon
      end

      if no_app then
        icon_line = " —"
      end
      
      -- Update the workspace label
      if spaces[workspace_name] then
        sbar.animate("tanh", 10, function()
          spaces[workspace_name]:set({ label = icon_line })
        end)
      end
    end)
  end
end)

-- Spaces indicator
local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)

-- Initialize workspace icons on startup
sbar.exec("~/.config/sketchybar/plugins/update_workspace_icons.sh")