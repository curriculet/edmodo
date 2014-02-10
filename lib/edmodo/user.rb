module Edmodo
class User < Hashie::Mash
    include Edmodo::Model

    api_path '/users'

    def student?
      self.user_type == 'STUDENT'
    end

    def teacher?
      self.user_type == 'TEACHER'
    end
  end
end