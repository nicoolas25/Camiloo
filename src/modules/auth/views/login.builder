xml.declare! :doctype, :html, :public, "-//W3C//DTD HTML 4.01 Transitional//EN"
xml.html do
  xml.head do
    xml.title "Camiloo::AuthApp.login"
  end
  xml.span @msg, :class => 'message'
  xml.br
  xml.body do
    xml.form :action => '', :method => 'POST' do
      xml.input :size => 10, :type => 'text', :value => '', :name => 'user'
      xml.input :size => 10, :type => 'text', :value => '', :name => 'pass'
      xml.input :type => 'hidden', :name => 'redirect', :value => @ref
      xml.input :type => 'submit', :value => 'connect'
    end
    xml.form :action => base_uri + '/logout', :method => 'GET' do
      xml.input :type => 'submit', :value => 'logout'
    end
  end
end
