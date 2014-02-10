module Edmodo
  module Model
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :extend, ClassMethods
    end

    module InstanceMethods
      def to_json(*args)
        as_json(*args).to_json(*args)
      end

      def as_json(args = {})
            self.to_hash.stringify_keys
      end

      def to_i; id; end

      def ==(other)
        id == other.id
      end

      def json_root
        self.class.json_root
      end
    end

    module ClassMethods
      # api_path
      # This sets the API path so the API collections can use them in an agnostic way
      # @param path [String] the api path for the current model with a leading slash
      # @return [void]
      def api_path(path = nil)
        @_api_path ||= path
      end


      # parse
      # Parses a request.body response into a Edmodo::Model objects
      def parse(json)
        parsed = String === json ? JSON.parse(json) : json
        if parsed.is_a? Array
          return parsed.map {|attrs|  new(attrs)  }
        else
          return  new(parsed)
        end
      end

    end

  end
end