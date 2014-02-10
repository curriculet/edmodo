module Edmodo
  module API
    #@private
    module Endpoints

      # groups
      #
      # @example
      #  Edmodo.groups.find(100) # Returns the group with id = 100
      #  Edmodo.groups.find([100,200,300]) # Returns the an array with groups with ids = 100,200,300
      #
      # @return [Edmodo::API::Groups] A properly initialized groups api client ready for calls

      def groups
        @groups ||= Edmodo::API::Groups.new( client )
      end

      # users
      #
      # @example
      #   Edmodo.users.find_by_launch_key( launch_key ) returns the user who submitted the launch request
      #
      # @return [Edmodo::API::Users] A properly initialized users api client ready for calls

      def users
        @users ||= Edmodo::API::Users.new( client )
      end
    end
  end
end