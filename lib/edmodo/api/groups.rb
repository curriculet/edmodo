module Edmodo
  module API
    class Groups < Resource
      api_model Edmodo::Group

      # find_by_id
      #
      # Finds a specific group by id (a convenience wrapper for find_all_by_id)
      # @see find_all_by_id
      #
      # @param id [String] The id of the group you want to retrieve
      # @param access_token [String] Your current access_token
      # @return An Edmodo::Group or nil if not found
      # @raise [Edmodo::HTTPError] if Authentication or communication errors occurred
      #
      def find_by_id(id, access_token = nil)
        raise "id is required" unless id
        results = self.find_all_by_ids([id],access_token)
        if (results.is_a? Array )&& (results.length > 0 )
          return results[0]
        else
          return nil
        end
      end

      # find_all_by_id
      #
      # Returns group information for all group_ids in the query. Uses the /groups API call
      #
      #  GET /groups?api_key=<API_KEY>&access_token=<ACCESS_TOKEN>&group_ids=[379557,379562]
      #
      #  Example Response
      #  [
      #   {
      #      "group_id":379557,
      #      "title":"Period 1",
      #      "member_count":20,
      #      "owners":[
      #         "b020c42d1",
      #         "693d5c765"
      #      ],
      #      "subject":"Math",
      #      "sub-subject":"Algebra"
      #      "start_level":"9th",
      #      "end_level":"9th"
      #   },
      #   {
      #      "group_id":379562,
      #      "title":"Period 4",
      #      "member_count":28,
      #      "owners":[
      #         "b020c42d1"
      #      ],
      #      "subject":"Math",
      #      "sub-subject":"Geometry"
      #      "start_level":"3rd",
      #      "end_level":"3rd"
      #   }
      #  ]
      # Details
      #   start_level / end_level
      #   The response fields 'start_level' and 'end_level' may be an empty string if the grade level is not set for a particular group
      #   The start_level/end_level fields will be the same if a single grade level is set for the group and will be different if a grade level range is set for the group.
      #   The start_level/end_level fields will be different if a grade level range is set for the group.
      #   List of levels include: prekindergarten, kindergarten, 1st, 2nd, 3rd, 4th, 5th, 6th, 7th, 8th, 9th, 10th, 11th, 12th, higher-education
      #
      # @param ids [Array of Strings] the group_ids for which you want to retrieve information
      # @param access_token [String] the access token you received from find_by_launch_key or from an installation request
      # @param parse [Boolean] optional. If you want to retrieve the raw query results as a JSON string set it to false. Default is true
      # @return [Array of Edmodo::Group] It maybe empty of no groups were found
      # @raise [Edmodo::HTTPError] if authentication fails or if any HTTP communication errors are found
      #
      def find_all_by_ids(ids, access_token = nil, parse = true)
        raise "group_ids is a required argument" unless ids
        ids = ids.split(',') if ids && ids.is_a?(String)
        params = {}
        params[:group_ids] = to_json_array( ids ) if ids
        params[:access_token] = access_token unless access_token.nil?
        response = @client.get( api_model.api_path, params )
        if parse
          return api_model.parse(response.body)
        else
          return response.body
        end
      end
    end
  end
end