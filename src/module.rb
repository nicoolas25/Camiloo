require 'sinatra/base'

module Camiloo
  class Module < Sinatra::Base
    def base_uri
      env['SCRIPT_NAME']
    end

    def redirect(uri, *args)
      base = base_uri
      base += '/' unless uri[0] == '/' or base[-1] == '/'
      redirect_outside(base + uri, *args)
    end

    # redirect_outside acts from the global path (like Sinatra::Base#redirect)
    # when redirect acts from the current app path.
    alias redirect_outside redirect
  end
end
