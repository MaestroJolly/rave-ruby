require_relative "base/sub_account_base.rb"
require 'json'

class SubAccount < SubAccountBase

    # method to create subaccount 
    def create_subaccount(data)
        base_url = rave_object.base_url

        data.merge!({"seckey" => rave_object.secret_key.dup})

        required_parameters = ["account_bank", "account_number", "business_name", "business_email", "business_contact", "business_contact_mobile", "business_mobile", "split_type", "split_value"]
        check_passed_parameters(required_parameters, data)

        payload = data.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::SUBACCOUNT_ENDPOINT}/create", payload) 

        return handle_create_response(response)
    end

    # method to list all subaccounts
    def list_subaccounts
        base_url = rave_object.base_url

        response = get_request("#{base_url}#{BASE_ENDPOINTS::SUBACCOUNT_ENDPOINT}", {"seckey" => rave_object.secret_key.dup}) 

        return handle_subaccount_response(response)
    end
    
    # method to fetch a subaccount
    def fetch_subaccount(subaccount_id)
        base_url = rave_object.base_url

        response = get_request("#{base_url}#{BASE_ENDPOINTS::SUBACCOUNT_ENDPOINT}/get/#{subaccount_id}", {"seckey" => rave_object.secret_key.dup}) 

        return handle_subaccount_response(response)
    end


    # method to delete a subaccount
    def delete_subaccount(subaccount_id)
        base_url = rave_object.base_url

        payload = {
            "seckey" => rave_object.secret_key.dup,
            "id" => subaccount_id
        }

        payload = payload.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::SUBACCOUNT_ENDPOINT}/delete", payload)
        return handle_subaccount_response(response)
    end
end