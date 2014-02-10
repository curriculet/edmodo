require 'spec_helper'

describe Edmodo::API::Users do

  before(:each){
    set_testing_configuration
  }

  context "find_by_launch_key" do
    it "should throw a 404 when bad args" do
      VCR.use_cassette("launchrequest") do
        expect{ Edmodo.users.find_by_launch_key("BOGUS", edmodo_access_token ) }.to raise_error Edmodo::ServerError
      end
    end

    it "should return a user when calling find_by_launch_key with valid args" do
      VCR.use_cassette("launchrequest") do
        user = Edmodo.users.find_by_launch_key( testing_launch_key, edmodo_access_token )
        user.should_not be_nil
        user.should respond_to( :user_token )
        user.should respond_to( :first_name )
        user.should respond_to( :last_name  )
        user.should respond_to( :user_type  )
      end
    end
  end

  context "find_all_by_user_tokens" do
    it "should throw a 404 when bad args" do
      VCR.use_cassette("users") do
        expect{ Edmodo.users.find_all_by_user_tokens(["BOGUS"], edmodo_access_token ) }.to raise_error Edmodo::NotFound
      end
    end

    it "should return an Array of users when calling find_all_by_user_tokens with valid args" do
      VCR.use_cassette("users") do
        users = Edmodo.users.find_all_by_user_tokens([testing_user_token], edmodo_access_token )
        users.should_not be_nil
        users.should be_an_instance_of( Array )
        users.length.should > 0
        users[0].should respond_to( :user_token )
        users[0].should respond_to( :first_name )
        users[0].should respond_to( :last_name  )
        users[0].should respond_to( :user_type  )
      end
    end
  end

  #find_all_by_group_ids
  context "find_all_by_group_ids" do
    it "should throw a 404 when bad args" do
      VCR.use_cassette("groups") do
         expect{ Edmodo.users.find_all_by_group_ids(["BOGUS"], edmodo_access_token ) }.to raise_error Edmodo::NotFound
      end
    end
    it "should return an Array of the users belonging to the groups in the  group_id array" do
      VCR.use_cassette("groups") do
            users = Edmodo.users.find_all_by_group_ids([testing_group_id], edmodo_access_token )
            users.should_not be_nil
            users.should be_an_instance_of( Array )
            users.length.should > 0
            users[0].should respond_to( :user_token )
            users[0].should respond_to( :first_name )
            users[0].should respond_to( :last_name  )
            users[0].should respond_to( :user_type  )
          end
    end
  end

end