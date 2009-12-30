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
# Foobar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
#
# Authors:
#   Nicolas Zermati <nicolas.zermati@gmail.com>

require 'sinatra/base'

module Camiloo
  class Module < Sinatra::Base
    def base_uri
      env['SCRIPT_NAME']
    end

    def redirect(uri, *args)
      base = ''
      if uri !~ /.+:\/\//
        base += base_uri
      end
      super(base + uri, *args)
    end

    def redirect_outside(uri, *args)
      status 302
      response['Location'] = uri
      halt(*args)
    end
  end # Module
end # Camiloo
