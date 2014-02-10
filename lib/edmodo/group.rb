module Edmodo
class Group < Hashie::Mash
    include Edmodo::Model

    api_path '/groups'

    def members
      Edmodo.users.find_all_by_group_ids(self.id)
    end

  end
end