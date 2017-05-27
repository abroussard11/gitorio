require 'stdlib/log/logger'
require 'stdlib/time'

--require 'os' -- we don't have access to the lua libraries, it seems

-- log function sends to stdout (or to factorio-current.log)
log('GITORIO: loading gitorio control')

-- GIT_LOGGER writes to script-output/logs/gitorio/main.log
-- This uses game.write_file() under the hood. I haven't found a way to read yet
local log_debug_mode = true
local log_options = {log_ticks = true, force_append = true}
local GIT_LOGGER = Logger.new('gitorio', 'main', log_debug_mode, log_options)
GIT_LOGGER.log('module level initialization')

function _git(data)
  -- aliases
  local clog = game.player.print -- text goes to the in-game console
  local main_inv = game.player.get_inventory(defines.inventory.player_main)
  local quickbar_inv = game.player.get_inventory(defines.inventory.player_quickbar)

  -- input sanitization
  if not data.parameter then
    data.parameter = ''
  end

  clog('GITORIO: minute = ' .. Time.MINUTE)
  for k,v in pairs(data) do
    clog('k: ' .. k .. ' v: ' .. v)
  end

  clog('GITORIO:      command = ' .. data.name)
  clog('GITORIO:         tick = ' .. data.tick)
  clog('GITORIO: player_index = ' .. data.player_index)
  clog('GITORIO:   parameters = ' .. data.parameter)
  GIT_LOGGER.log('     command = ' .. data.name)
  GIT_LOGGER.log('        tick = ' .. data.tick)
  GIT_LOGGER.log('player_index = ' .. data.player_index)
  GIT_LOGGER.log('  parameters = ' .. data.parameter)

end

commands.add_command('git', 'a useful help message', _git)
