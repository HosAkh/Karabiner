hs.ipc.cliInstall()

stackline = require "stackline"
stackline:init({
  paths = {
    yabai = os.getenv("HOME") .. "/.local/bin/yabai",
  },
})

stackBadges = {}
local yabaiPath = os.getenv("HOME") .. "/.local/bin/yabai"
local lastStackFrames = {}
local syncingStackFrames = false

local function clearStackBadges()
  for _, badge in ipairs(stackBadges) do
    badge:delete()
  end
  stackBadges = {}
end

local function appIcon(appName)
  local app = hs.appfinder.appFromName(appName)
  if app and app:bundleID() then
    return hs.image.imageFromAppBundle(app:bundleID())
  end
  return nil
end

local function stackKey(win)
  local frame = win.frame or {}
  return table.concat({
    tostring(win.display or ""),
    tostring(win.space or ""),
    tostring(math.floor(frame.x or 0)),
    tostring(math.floor(frame.y or 0)),
  }, "|")
end

local function screenFrameForPoint(x, y)
  for _, screen in ipairs(hs.screen.allScreens()) do
    local frame = screen:fullFrame()
    if x >= frame.x and x <= frame.x + frame.w and y >= frame.y and y <= frame.y + frame.h then
      return frame
    end
  end
  return hs.screen.mainScreen():fullFrame()
end

local function focusYabaiWindow(windowId)
  hs.task.new(yabaiPath, nil, { "-m", "window", "--focus", tostring(windowId) }):start()
end

local function frameSignature(frame)
  return table.concat({
    tostring(math.floor(frame.x or 0)),
    tostring(math.floor(frame.y or 0)),
    tostring(math.floor(frame.w or 0)),
    tostring(math.floor(frame.h or 0)),
  }, "|")
end

local function frameMatches(a, b)
  return math.abs((a.x or 0) - (b.x or 0)) <= 2
    and math.abs((a.y or 0) - (b.y or 0)) <= 2
    and math.abs((a.w or 0) - (b.w or 0)) <= 2
    and math.abs((a.h or 0) - (b.h or 0)) <= 2
end

local function hammerspoonWindowById(windowId)
  for _, win in ipairs(hs.window.allWindows()) do
    if win:id() == windowId then
      return win
    end
  end
  return nil
end

local function setWindowFrame(windowId, frame)
  local win = hammerspoonWindowById(windowId)
  if win then
    win:setFrame(frame, 0)
  end
end

local function syncStackFrames(stacks)
  if syncingStackFrames then
    return
  end

  syncingStackFrames = true
  local nextStackFrames = {}

  for _, wins in pairs(stacks) do
    if #wins > 1 then
      table.sort(wins, function(a, b)
        return (a["stack-index"] or 0) < (b["stack-index"] or 0)
      end)

      local leader = nil
      for _, win in ipairs(wins) do
        local previous = lastStackFrames[tostring(win.id)]
        if previous and previous ~= frameSignature(win.frame) then
          leader = win
          break
        end
      end

      if not leader then
        for _, win in ipairs(wins) do
          if win["has-focus"] then
            leader = win
            break
          end
        end
      end

      leader = leader or wins[1]
      local leaderFrame = leader.frame

      for _, win in ipairs(wins) do
        if win.id ~= leader.id and not frameMatches(win.frame, leaderFrame) then
          setWindowFrame(win.id, leaderFrame)
        end
        nextStackFrames[tostring(win.id)] = frameSignature(leaderFrame)
      end
    end
  end

  lastStackFrames = nextStackFrames
  syncingStackFrames = false
end

function refreshYabaiStackBadges()
  hs.task.new(yabaiPath, function(_, stdout)
    local ok, windows = pcall(hs.json.decode, stdout)
    if not ok or type(windows) ~= "table" then
      clearStackBadges()
      return
    end

    local stacks = {}
    for _, win in ipairs(windows) do
      if (win["stack-index"] or 0) > 0 and win.frame then
        local key = stackKey(win)
        stacks[key] = stacks[key] or {}
        table.insert(stacks[key], win)
      end
    end

    clearStackBadges()
    syncStackFrames(stacks)

    for _, wins in pairs(stacks) do
      if #wins > 1 then
        table.sort(wins, function(a, b)
          return (a["stack-index"] or 0) < (b["stack-index"] or 0)
        end)

        local frame = wins[1].frame
        local size = 30
        local gap = 4
        local offset = 8
        local screenFrame = screenFrameForPoint(frame.x, frame.y)
        local x = frame.x + frame.w + offset
        if x + size > screenFrame.x + screenFrame.w then
          x = frame.x - size - offset
        end
        x = math.max(screenFrame.x, math.min(x, screenFrame.x + screenFrame.w - size))
        local y = frame.y + 8

        for index, win in ipairs(wins) do
          local windowId = win.id
          local badge = hs.canvas.new({
            x = x,
            y = y + ((index - 1) * (size + gap)),
            w = size,
            h = size,
          })

          badge:appendElements({
            type = "rectangle",
            action = "fill",
            fillColor = { white = 0.02, alpha = 0.86 },
            roundedRectRadii = { xRadius = 7, yRadius = 7 },
            frame = { x = 0, y = 0, w = size, h = size },
            withShadow = true,
            trackMouseDown = true,
          })

          local icon = appIcon(win.app or "")
          if icon then
            badge:appendElements({
              type = "image",
              image = icon,
              frame = { x = 5, y = 5, w = size - 10, h = size - 10 },
            })
          else
            badge:appendElements({
              type = "text",
              text = string.sub(win.app or "?", 1, 1),
              textColor = { white = 1, alpha = 1 },
              textSize = 16,
              textAlignment = "center",
              frame = { x = 0, y = 5, w = size, h = size - 5 },
            })
          end

          badge:level(hs.canvas.windowLevels.overlay)
          badge:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
          badge:clickActivating(false)
          badge:mouseCallback(function(_, message)
            if message == "mouseDown" then
              focusYabaiWindow(windowId)
            end
          end)
          badge:show()
          table.insert(stackBadges, badge)
        end
      end
    end
  end, { "-m", "query", "--windows" }):start()
end

refreshYabaiStackBadges()
stackBadgeTimer = hs.timer.doEvery(1.0, refreshYabaiStackBadges)
