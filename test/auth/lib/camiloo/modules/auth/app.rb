# Camiloo authentication module (application)
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

require 'camiloo/module'
require 'camiloo/modules/auth/models'
require 'camiloo/modules/auth/helpers'

module Camiloo
  class AuthApp < Camiloo::Module
    helpers Camiloo::Auth::Helpers
    
    get '/login' do
      ref = request.referer
      ref = base_uri+"/login" if ref == '/'
      if user = session[:auth_user]
        msg = user.username
      else
        msg = "Unknown user"
      end
      msg + "<br/>" +
        "<form method='POST' action='#{base_uri}/login'>" +
        "<input type='text' name='user'>" +
        "<input type='text' name='pass'>" +
        "<input type='hidden' name='redirect' value='#{ref}'>" +
        "<input type='submit' value='connect'>" +
        "</form>"
    end
    
    get '/logout' do
      session.delete :auth_user
      "Logout page must be here !"
    end
    
    post '/login' do
      begin
        user = Auth::User.by_user_name(params[:user])
        if user.password_match?(params[:pass]) 
          session[:auth_user] = user
          redirect_outside params[:redirect]
        else
          redirect '/login'
        end
      rescue ArgumentError => unknown_username
        redirect '/login'
      end
    end
  end
end # Camiloo
