require File.join( File.dirname(__FILE__), "..", "spec_helper" )
require 'sequel'

describe "MA Sequel User Model" do
  
  before(:all) do

    Merb.stub!(:orm_generator_scope).and_return("sequel")
    
    adapter_path = File.join( File.dirname(__FILE__), "..", "..", "lib", "merb-auth", "adapters")
    MA.register_adapter :datamapper, "#{adapter_path}/datamapper"
    MA.register_adapter :activerecord, "#{adapter_path}/activerecord"
    MA.register_adapter :sequel, "#{adapter_path}/sequel"
    MA.loaded
    
    sqdb = Sequel.sqlite
    
    sqdb.create_table! :users do
      primary_key :id
      column :login,                      :text
      column :email,                      :text
      column :crypted_password,           :varchar, :size => 40
      column :salt,                       :varchar, :size => 40
      column :created_at,                 :datetime
      column :updated_at,                 :datetime
      column :remember_token,             :text
      column :remember_token_expires_at,  :datetime	
      column :activation_code,            :varchar, :size => 40
      column :activated_at,               :datetime
      column :password_reset_key,         :text
    end
    
    class User < Sequel::Model
      include MerbAuth::Adapter::Sequel
      include MerbAuth::Adapter::Sequel::DefaultModelSetup

      def attributes
        values
      end
    end
    User.raise_on_save_failure = false

    Sequel.datetime_class = DateTime

    MA.activate
  end
  
  it_should_behave_like "A MerbAuth User Model"

end
