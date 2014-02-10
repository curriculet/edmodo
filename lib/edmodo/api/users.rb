module Edmodo
  module API
    class Users < Resource
      api_model Edmodo::User

      # find_all_by_user_tokens
      #
      #
      #  GET /users?api_key=<API_KEY>&access_token=<ACCESS_TOKEN>&user_tokens=["b020c42d1","jd3i1c0pl"]
      #  Example Response
      #  [
      #    {
      #      "user_token":"b020c42d1",
      #      "first_name":"Bob",
      #      "last_name":"Smith"
      #      "user_type":"TEACHER",
      #      "avatar_url":"https://edmodoimages.s3.amazonaws.com/default_avatar.png",
      #      "thumb_url":"https://edmodoimages.s3.amazonaws.com/default_avatar_t.png"
      #      "time_zone": "America/Los_Angeles"
      #    },
      #    {
      #      "user_token":"jd3i1c0pl",
      #      "first_name":"Jane",
      #      "last_name":"Student"
      #      "user_type":"STUDENT",
      #      "avatar_url":"https://edmodoimages.s3.amazonaws.com/default_avatar.png",
      #      "thumb_url":"https://edmodoimages.s3.amazonaws.com/default_avatar_t.png"
      #      "time_zone": "America/Los_Angeles"
      #    }
      #  ]
      #
      # @raise [Edmodo::HTTPError] Will raise an error if authentication fails
      # @param user_tokens [Array of Strings] The array of user_tokens for which you want to retrieve users
      # @param access_token [String] Your current access token (you get one via found_by_launch_key or when you receive an app installation request)
      # @return [Array] an array of Edmodo::User. It maybe empty if no users were found
      def find_all_by_user_tokens( user_tokens, access_token = nil, parse = true)
        raise "user_tokens Array is a required argument" unless user_tokens
        params= { user_tokens: to_json_array( user_tokens ) }
        params[:access_token] = access_token unless access_token.nil?
        response = @client.get( api_model.api_path, params )
        if parse
          return api_model.parse(response.body)
        else
          return response.body
        end
      end

      # find_all_by_group_id
      #
      #  GET /members?api_key=<API_KEY>&access_token=<ACCESS_TOKEN>&group_id=379557,456322
      #  Example Response
      #  [
      #    {
      #      "user_type":"TEACHER",
      #      "user_token":"b020c42d1",
      #      "first_name":"Bob",
      #      "last_name":"Smith",
      #      "group_id": 379557,
      #      "avatar_url":"https://edmodoimages.s3.amazonaws.com/default_avatar.png",
      #      "thumb_url":"https://edmodoimages.s3.amazonaws.com/default_avatar_t.png"
      #   },
      #   {
      #      "user_type":"TEACHER",
      #      "user_token":"693d5c765",
      #      "first_name":"Tom",
      #      "last_name":"Jefferson",
      #      "group_id": 379557,
      #      "avatar_url":"https://edmodoimages.s3.amazonaws.com/default_avatar.png",
      #      "thumb_url":"https://edmodoimages.s3.amazonaws.com/default_avatar_t.png"
      #   }
      #  ]
      #
      # @raise [Edmodo::HTTPError] Will raise an error if authentication fails
      # @param ids [Array of Strings] The array of group_ids for which you want to retrieve members
      # @param access_token [String] Your current access token (you get one via found_by_launch_key or when you receive an app installation request)
      # @return [Array of Edmodo::User] It maybe empty if no members were found

      def find_all_by_group_ids(ids, access_token = nil)
        raise "group ids Array is a required argument" unless ids
        ids = ids.split(',') if ids && ids.is_a?(String)
        params = {}
        params[:group_id] = to_comma_separated_list( ids ) if ids
        params[:access_token] = access_token unless access_token.nil?
        response = @client.get( "/members", params )
        api_model.parse(response.body)
      end

      # find_by_launch_key
      #
      #  GET /launchRequests?api_key=<API_KEY>&launch_key=5c18c7
      #  Example Response
      #  {
      #      "user_type":"TEACHER",
      #      "access_token": “atok_abbd3e01”,
      #      "user_token":"b020c42d1",
      #      "first_name":"Bob",
      #      "last_name":"Smith"
      #      "avatar_url":"https://edmodoimages.s3.amazonaws.com/default_avatar.png",
      #      "thumb_url":"https://edmodoimages.s3.amazonaws.com/default_avatar_t.png",
      #      "groups":[
      #          {
      #              "group_id":379557,
      #              "is_owner":1
      #          },
      #          {
      #              "group_id":379562,
      #              "is_owner":1
      #          }
      #      ]
      #  }
      #
      # @raise [Edmodo::HTTPError] Will raise an error if authentication fails or the launch key has expired or is invalid
      # @param launch_key [String] The launch key you just received and want to authenticate
      # @return [Edmodo::User] The user that issued the launch key


      def find_by_launch_key( launch_key, access_token ="NotRequiredByEdmodo" )
        raise "launch_key is a required argument" unless launch_key
        params = {launch_key: launch_key }
        params[:access_token] = access_token unless access_token.nil?
        response = @client.get( "/launchRequests", params )
        api_model.parse(response.body)
      end

    end
  end
end