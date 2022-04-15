-- Configuration:
local cartridge_stem = "where-is-my-belt"

-- in PICO-8, itests can be run entirely on either cartridge
-- to reproduce this behavior, we set the cartridge suffix as env variable
--  and require the right bustedhelper, app and itest folder based on this
local cartridge_suffix = os.getenv('ITEST_CARTRIDGE_SUFFIX')
if cartridge_suffix == 'ignore' then
  -- All: test are running all the utests excluding the headless itests first
  --  then engine utests, then the headless itests for both cartridges,
  --  so for the first pass, passing 'ignore' is useful as test_scripts.sh
  --  doesn't have a parameter to exclude roots
  return
end

assert(cartridge_suffix, "env variable ITEST_CARTRIDGE_SUFFIX not set")

-- #cartridge
-- Configuration: define initial gamestate based on cartridge
local initial_gamestate
if cartridge_suffix == 'core' then
  initial_gamestate = ':ingame'
else
  assert(false, "unknown cartridge_suffix "..cartridge_suffix)
end

-- Make sure to create a bustedhelper_[cartridge] for each cartridge
require("test/bustedhelper_"..cartridge_suffix)

require("engine/test/headless_itest")
local itest_manager = require("engine/test/itest_manager")

local logging = require("engine/debug/logging")

local app_cartridge = require("application/app_"..cartridge_suffix)

local app = app_cartridge()
app.initial_gamestate = initial_gamestate

logging.logger:register_stream(logging.console_log_stream)
logging.logger:register_stream(logging.file_log_stream)
-- with busted, logs are always in log/
logging.file_log_stream.file_prefix = cartridge_stem.."_headless_itests"

-- clear log file on new itest session
logging.file_log_stream:clear()

logging.logger.active_categories = {
  -- engine
  ['default'] = true,
  -- ['codetuner'] = true,
  -- ['flow'] = true,
  ['itest'] = true,
  -- ['log'] = true,
  -- ['ui'] = true,
  -- ['frame'] = true,
  -- ['trace'] = true,
  -- ['trace2'] = true,

  -- game
  -- ['...'] = true,
}

-- set app immediately so during itest registration by require,
--   time_trigger can access app fps
itest_manager.itest_run.app = app

-- require *_itest.lua files to automatically register them in the integration test manager
require_all_scripts_in('src', 'itests/'..cartridge_suffix)

local should_render = check_env_should_render()
if should_render then
  print("[headless itest] enabling rendering")
end

-- uncomment below to randomize seed
-- (busted needs that to give different results each time,
--   while PICO-8 will automatically randomize the seed on start)
-- ! since itests won't give the same results every time, if you want a specific result,
--   you need to force setup some variables (like the next opponent) in your specific itest
-- local random_seed = os.time()
-- print("[headless itest] setting random seed to: "..random_seed)
-- srand(random_seed)

create_describe_headless_itests_callback(app, should_render, describe, setup, teardown, before_each, after_each, it, assert)
