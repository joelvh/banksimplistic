class DeveloperController < ApplicationController
  def index

    all_events_struct = Event.all
    @events = all_events_struct.map {|e| e }
    
    all_mementos = Memento.all
    @mementos = all_mementos.map {|e| e }  
   
  
    all_client_reports = ClientDetailsReport.all
    @client_reports = all_client_reports.map {|e| e }  
    
  end
end
