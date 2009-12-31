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

require 'sinatra/base'
require 'camiloo/urlmap'

module Camiloo
  class Module < Sinatra::Base
    def initialize *args
      super
      @@instances ||= []
      @@instances << self
    end

    def base_uri
      env['SCRIPT_NAME']
    end

    def redirect uri, *args
      base = ''
      if uri !~ /https?:\/\//
        base += base_uri
      end
      super(base + uri, *args)
    end

    def redirect_outside uri, *args
      status 302
      response['Location'] = uri
      halt(*args)
    end
  end # Module

  class ModuleMixer
    def initialize app
      super()
      xml = Builder::XmlMarkup.new
      @app = app
    end

    def call env
      code, headers, response = @app.call env
      app = (@app.respond_to? 'matching_app') ? @app.matching_app : @app
      response = case headers['Content-Type']
      when "text/html"
        response.insert 0, "<!doctype html public \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n<html>\n<head>\n<title>"
        response.insert 1, app.options.title
        response.insert 2, "</title>\n</head>\n<body>\n<div class='content'>"
        response << "</div>\n</body>\n</html>"
      else
        response
      end
      [code, headers, response]
    end
  end # ModuleMixer
end # Camiloo
