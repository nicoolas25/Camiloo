# Camiloo authentication module (helpers)
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
#
# You should have received a copy of the GNU General Public License
# along with Camiloo.  If not, see <http://www.gnu.org/licenses/>.
#
# Authors:
#   Julien Peeters <contact@julienpeeters.fr>
#   Nicolas Zermati <nicolas.zermati@gmail.com>

require 'camiloo/modules/auth/models'

module Camiloo
  module Auth
    module Helpers
      def authorized?(symb)
        begin
          user = Auth::User.by_user_name(session[:auth_user])
          !user.roles.first(:name => symb.to_s).nil?
        rescue Exception => ex
          false
        end
      end

      def authorize!(symb)
        login! unless authorized?(symb)
      end

      def login!
        redirect_outside '/auth/login' if respond_to?(:redirect_outside)
        redirect '/auth/login'
      end

      def logout!
        redirect_outside '/auth/logout' if respond_to?(:redirect_outside)
        redirect '/auth/logout'
      end
    end # Helpers
  end # Auth
end # Camiloo
