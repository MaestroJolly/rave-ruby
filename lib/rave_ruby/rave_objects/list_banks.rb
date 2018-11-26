require_relative "base/base.rb"

class ListBanks < Base

    attr_reader :rave_object

    # method to initialize the object
    def initialize(rave_object)
        @rave_object = rave_object
    end

    # method to fetch the list of banks using the list bank endpoint
    def fetch_banks
        base_url = rave_object.base_url
        response = get_request("#{base_url}#{BASE_ENDPOINTS::BANKS_ENDPOINT}", {:json => 1})
        return handle_list_bank(response)
    end
end
