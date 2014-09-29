$LOAD_PATH.unshift(File.join(File.dirname(File.expand_path(__FILE__)), "lib"))
require './lib/cedek'

run Cedek::App
