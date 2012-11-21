class ClientCommands
  extend CommandCollection::DSL
  
  command :create_client do |attributes|
    Client.create(attributes)
  end 
  
  command :change_client_name do |client_id, attrs|
    client = Client.find(client_id)
    client.change_name(attrs[:name])
  end
  
end

