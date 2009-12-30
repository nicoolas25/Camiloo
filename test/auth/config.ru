# update the load path - EDIT ONLY IF YOU KNOW WHAT YOU DO!
$LOAD_PATH << 'lib' unless $LOAD_PATH.include? 'lib'

#
# Rackup file to be completed
#

# Example:
#
# require 'camiloo/modules/auth'
#
# use Rack::ShowExceptions
#
# map '/auth' do
#   use Rack::Session::Pool
#   run Camiloo::AuthApp.new
# end
#
# map '/myapp' do
#   run MyApp.new
# end
#
# ...
# 

require 'dm-core'
require 'camiloo/modules/auth'

use Rack::ShowExceptions

DataMapper.setup(:default, 'sqlite3::memory:')
DataMapper.auto_migrate!

Camiloo::Auth::User.new('admin', 'admin', 'Administrator')

map '/auth' do
  use Rack::Session::Pool
  run Camiloo::AuthApp.new
end
