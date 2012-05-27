class Report < Ohm::Model
  extend ::EventHandler

  class << self
    # If no reports exist, for instance we have a new reporting class, we can build 
    # all reports.  Raises an error if a report already exist.
    def build_all
      if !(self.all.empty?)
        raise CQRSReportError, "Trying to build all reports but a report already exists"
      end
      all_events  =  DomainRepository.find_all_events.to_a
      handler_events = all_events.select{|e| event_handlers.keys.include?(e.name.to_sym)}   

      for event in handler_events
        block = event_handlers[event.name.to_sym]
        block.call(event)
      end
    end

    # If report has been deleted and you do not know its respective uid
    # then you cannot rebuild it with rebuild_all.  This command rebuilds missing reports
    # by iterating over the entire eventstore.  
    def rebuild_missing_reports

      all_events  =  DomainRepository.find_all_events.to_a
      missing_events = all_events.select{ |e| !self.exists?(event.uid)}

      handler_events = missing_events.select{|e| event_handlers.keys.include?(e.name.to_sym)} 

      for event in handler_events
        block = event_handlers[event.name.to_sym]
        block.call(event)
      end
    end

    # Rebuilds all existing reports

    def rebuild_all
      #delete all existing reports
      for report in self.all
        rebuild(report.uid)
      end  
    end

    def rebuild(uid)
      report = find(:uid => uid).first
      report.delete if report

      # We need to grab all events related to this report...

      aggregate_events = DomainRepository.find_events(uid).to_a
      handler_events = aggregate_events.select{|e| event_handlers.keys.include?(e.name.to_sym)}

      # There may be a problem if a new event gets notified whilst rebuilding, 
      # This should be fixed

      # And then run the handlers...

      for event in handler_events
        block = event_handlers[event.name.to_sym]
        block.call(event)
      end    
    end
  end

  # If for whatever reason you need to delete a report, for instance 
  # if you are rebuilding.  Then override this method and do clean up.
  def teardown

  end

  def delete
    teardown
    super
  end
end

class CQRSReportError < StandardError
end
