# Camiloo module class
# Copyright (c) 2009 Julien Peeters <contact@julienpeeters.fr>
#                    Nicolas Zermati <nicolas.zermati@gmail.com>
#
# This file is part of the Camiloo project.
#
# Camiloo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# Camiloo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Camiloo.  If not, see <http://www.gnu.org/licenses/>.
#
# Authors:
#   Julien Peeters <contact@julienpeeters.fr>
#   Nicolas Zermati <nicolas.zermati@gmail.com>


require 'rack'

module Rack
  class URLMap
   attr_accessor :matching_app

   def call env
     path = env["PATH_INFO"].to_s.squeeze("/")
     script_name = env['SCRIPT_NAME']
     hHost, sName, sPort = env.values_at('HTTP_HOST','SERVER_NAME','SERVER_PORT')
     @mapping.each { |host, location, app|
       next unless (hHost == host || sName == host \
                    || (host.nil? && (hHost == sName || hHost == sName+':'+sPort)))
       next unless location == path[0, location.size]
       next unless path[location.size] == nil || path[location.size] == ?/
       
       @matching_app = app
       #TODO : change this code to add this line into the original sourcecode
       #       by introspection
       
       return app.call(
         env.merge(
           'SCRIPT_NAME' => (script_name + location),
           'PATH_INFO'   => path[location.size..-1]))
     }
     [404, {"Content-Type" => "text/plain"}, ["Not Found: #{path}"]]
   end
  end # URLMap
end # Rack
