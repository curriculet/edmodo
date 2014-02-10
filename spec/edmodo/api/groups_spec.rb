require 'spec_helper'

describe Edmodo::API::Groups do

  before(:each){
    set_testing_configuration
  }

  context "find_by_id" do
    it "should throw a 404 when bad id" do
      VCR.use_cassette("groups") do
        expect{ Edmodo.groups.find_by_id("BOGUS", edmodo_access_token ) }.to raise_error Edmodo::NotFound
      end
    end

    it "should return a group when calling find_by_id with valid id" do
      VCR.use_cassette("groups") do
            group = Edmodo.groups.find_by_id( testing_group_id, edmodo_access_token )
            group.should_not be_nil
            group.should be_an_instance_of( Edmodo::Group )
            group.should respond_to( :group_id )
            group.should respond_to( :title )
            group.should respond_to( :member_count  )
            group.should respond_to( :owners  )
      end
    end
  end

  context "find_all_by_ids" do
    it "should throw a 404 when bad args" do
      VCR.use_cassette("groups") do
        expect{ Edmodo.groups.find_all_by_ids("BOGUS", edmodo_access_token ) }.to raise_error Edmodo::NotFound
      end
    end

    it "should return an Array of users when calling find_all_by_user_tokens with valid args" do
      VCR.use_cassette("groups") do
        group = Edmodo.groups.find_all_by_ids( [testing_group_id,testing_group_id_2], edmodo_access_token )
        group.should_not be_nil
        group.should be_an_instance_of( Array )
        group.length.should > 0
        group[0].should respond_to( :group_id )
        group[0].should respond_to( :title )
        group[0].should respond_to( :member_count  )
        group[0].should respond_to( :owners  )
      end
    end
  end
end