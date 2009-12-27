require 'sinatra/base'
require 'models'

module Camiloo
  module Auth
    module Helpers
      def authorized?(symb)
        if session.key?(:auth_user)
          user = Auth::User.by_user_name(session[:auth_user])
          return false if user.nil? # someone try to hack
          user.is_logged? and user.roles.first(:name => symb.to_s).nil?
        else
          return false
        end
      end
      
      def authorize!(symb, uri='')
        login!(uri) unless authorized?(symb)
      end
      
      def login!(after='')
        if respond_to?(:redirect_to)
          redirect_to "/login&redirect=#{after}"
        else
          redirect '/login'
        end
      end
      
      def logout!
        if session.key?(:auth_user)
          user = Auth::User.by_user_name(session[:auth_user])
          user.logout! unless user.nil?
        end
      end
    end
  end
end
