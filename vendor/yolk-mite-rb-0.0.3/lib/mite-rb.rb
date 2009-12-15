$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'active_support'
require 'active_resource'

# The official ruby library for interacting with the RESTful API of mite,
# a sleek time tracking webapp.

module Mite
  
  class << self
    attr_accessor :email, :password, :host_format, :domain_format, :protocol, :port
    attr_reader :account, :key

    # Sets the account name, and updates all resources with the new domain.
    def account=(name)
      resources.each do |klass|
        klass.site = klass.site_format % (host_format % [protocol, domain_format % name, ":#{port}"])
      end
      @account = name
    end

    # Sets up basic authentication credentials for all resources.
    def authenticate(user, password)
      resources.each do |klass|
        klass.user = user
        klass.password = password
      end
      @user     = user
      @password = password
      true
    end

    # Sets the mite.api key for all resources.
    def key=(value)
      resources.each do |klass|
        klass.headers['X-MiteApiKey'] = value
      end
      @key = value
    end

    def resources
      @resources ||= []
    end
  end
  
  self.host_format   = '%s://%s%s'
  self.domain_format = '%s.mite.yo.lk'
  self.protocol      = 'http'
  self.port          = ''

  class Base < ActiveResource::Base
    class << self
      
      def inherited(base)
        Mite.resources << base
        class << base
          attr_accessor :site_format
        end
        base.site_format = '%s'
        base.timeout = 20
        super
      end
      
      # Common shortcuts known from ActiveRecord
      def all(options={})
        find_every(options)
      end

      def first(options={})
        find_every(options).first
      end

      def last(options={})
        find_every(options).last
      end
      
      # Undo destroy action on the resource with the ID in the +id+ parameter.
      def undo_destroy(id)
        returning(self.new(:id => id)) { |res| res.undo_destroy }
      end
    end
    
    # Undo destroy action.
    def undo_destroy
      path = element_path(prefix_options).sub(/\.([\w]+)/, '/undo_delete.\1')
      
      returning connection.post(path, "", self.class.headers) do |response|
        load_attributes_from_response(response)
      end
    end
  
  end
  
  class Error < StandardError; end
end

require 'mite/customer'
require 'mite/project'
require 'mite/service'
require 'mite/time_entry'
require 'mite/time_entry_group'
require 'mite/tracker'
require 'mite/user'