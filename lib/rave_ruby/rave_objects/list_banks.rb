require_relative "base.rb"

class ListBanks < Base

    attr_reader :rave_object

    def initialize(rave_object)
        @rave_object = rave_object
    end
    # print rave_object.production
    def fetch_banks
        base_url = rave_object.base_url
        print base_url
        return get_request("#{base_url}#{BASE_ENDPOINTS::BANKS_ENDPOINT}", {:json => 1})
    end
end
