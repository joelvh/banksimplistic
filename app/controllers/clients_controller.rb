class ClientsController < ApplicationController
  def index
    @clients = ClientReport.all
  end
  
  def show
    @client = ClientDetailsReport.find(:uid => params[:id]).first
  end

  def edit
    @client = ClientDetailsReport.find(:uid => params[:id]).first
  end
  
  def store_memento
    DomainRepository.begin
    client = Client.find(params[:id])
    client.store_memento
    DomainRepository.commit
  end
  
  def create
    execute_command_in_collection :client_commands, :create_client, params[:client]
    redirect_to clients_path
  end

  def name
    execute_command_in_collection :client_commands, :change_client_name, params[:id], params[:client]
    redirect_to client_path(params[:id])
  end
end
