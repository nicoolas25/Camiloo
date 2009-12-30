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
