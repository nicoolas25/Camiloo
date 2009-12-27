require 'dm-core'

module Camiloo
  module Auth
    class User
      include DataMapper::Resource
      
      property :username, String,  :key => true
      property :password, String,  :required => true
      property :fname,    String,  :required => true
      property :lname,    String,  :required => true
      
      has n, :roles, :through => Resource # many_to_many
      has 1, :session
      
      def initialize(username, passwd)
        attribute_set (:username, username)
        attribute_set (:password, Digest::SHA1.hexdigest(passwd))
        save
      end

      def is_logged?
        diff_time = Time.now - session.log_time
        session.logged_in and diff_time < Session.expired_time
      end

      def login!(passwd)
        hash = Digest::SHA1.hexdigest(passwd)
        match = hash == password
        session.logged_in, session.log_time = true, Time.now if match
      end
      
      def logout!
        session.logged_in = false
      end

      def password=(passwd)
        attribute_set(:password, Digest::SHA1.hexdigest(passwd))
      end

      def change_password!(new_passwd)
        password = new_passwd if is_logged?
        save
      end

      def self.by_user_name(username)
        r = get(username)
        raise ArgumentError, username if r.nil?
        r
      end
    end
    
    class Session
      include DataMapper::Resource

      property :sid,       Integer,  :key => true
      property :logged_in, Boolean,  :required => true, :default => false
      property :log_time,  DateTime, :requires => true

      def expired_time
        3600
      end

      belongs_to :user
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
        throw ArgumentError, name if r.nil?
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
  end
end
