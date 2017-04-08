require 'rest-client'
require 'json'

class Starling
	def self.balance(fbid)
		u = Conversation.find_by(:fbid => fbid)
		access_token = u.starling_access
		logger.warn('access_token in starling: '+access_token)
		response = RestClient.get('https://api-sandbox.starlingbank.com/api/v1/accounts/balance', headers={Accept: 'application/json', Authorization: 'Bearer '+access_token})
		logger.warn('balance response: '+response.inspect)
		return response['availableToSpend']
	end

	def self.transfer(fbid, amount, contact_uuid)
		u = Conversation.find_by(:fbid => fbid)
		access_token = u.starling_access
		#TODO: actually do transfer
	end

	def self.check_contact(fbid, contact_name)
		u = Conversation.find_by(:fbid => fbid)
		access_token = u.starling_access
		response = RestClient.get('https://api-sandbox.starlingbank.com/api/v1/contacts', headers={Accept: 'application/json', Authorization: 'Bearer '+access_token})
		contacts = JSON.parse(response.body)

		id = nil
		j['_embedded']['contacts'].each do |contact|
			if contact['name'] == contact_name
				id = contact['id']
			end
		end

		return id
	end

	def self.spending(fbid, simple_date)
		u = Conversation.find_by(:fbid => fbid)
		access_token = u.starling_access
		response = RestClient.get('https://api-sandbox.starlingbank.com/api/v1/transactions?'+simple_date, headers={Accept: 'application/json', Authorization: 'Bearer '+access_token})
		return response
	end
end
