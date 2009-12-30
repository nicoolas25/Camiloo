# Camiloo authentication module (models)
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
#   Julien Peeters <contact@julienpeeters.fr>
#   Nicolas Zermati <nicolas.zermati@gmail.com>

require 'dm-core'
require 'digest/sha1'

module Camiloo
  module Auth
    class User
      include DataMapper::Resource
      
      property :username, String,  :key => true
      property :password, String,  :required => true
      property :fname,    String,  :required => true
      property :lname,    String,  :required => true
      
      has n, :roles, :through => Resource # many_to_many
      
      def initialize(username, passwd, fname='unknown', lname='unknown')
        attribute_set(:username, username)
        attribute_set(:password, Digest::SHA1.hexdigest(passwd))
        attribute_set(:fname, fname)
        attribute_set(:lname, lname)
        save
      end

      def password=(passwd)
        attribute_set(:password, Digest::SHA1.hexdigest(passwd))
      end

      def change_password!(new_passwd)
        password = new_passwd
        save
      end

      def password_match?(passwd)
        password == Digest::SHA1.hexdigest(passwd)
      end

      def self.by_user_name(username)
        r = get(username)
        raise ArgumentError, username if r.nil?
        r
      end
    end

    class ContentType
      include DataMapper::Resource
      
      property :name, String, :key => true
      
      has n, :permissions
      
      def add_permission!(symb)
        permissions.first_or_create({ :name => symb.to_s },
                                    { :name => symb.to_s })
        permissions.save
      end

      def remove_permission!(symb)
        permissions.delete_if { |perm| perm.name == symb.to_s }
        permissions.save
      end
      
      def self.by_name(name)
        r = get(name)
        raise ArgumentError, name if r.nil?
        r
      end
    end
    
    class Permission
      include DataMapper::Resource

      property :name, String, :key => true

      belongs_to :content_type
    end

    class Role
      include DataMapper::Resource

      property :name, String, :key => true
      
      has n, :permissions, :through => Resource # many_to_many
      has n, :users, :through => Resource # many_to_many

      def allow!(symb, *args)
        rights = permissions.all(:content_type_name => symb.to_s)
        args.delete_if { |symb| rights.first(:name => symb.to_s).nil? }

        args.each do |symb|
          perm = Permission.get(symb.to_s)
          permissions.push(perm) unless perm.nil?
        end
        permissions.save
      end
      
      def deny!(symb, *args)
        permissions.all(:content_type_name => symb.to_s).delete_if {
          |perm| args.include?(perm.name.to_sym)
        }
        permissions.save
      end

      def self.by_name(name)
        r = get(name)
        raise ArgumentError, name if r.nil?
        r
      end
    end
  end # Auth
end # Camiloo
