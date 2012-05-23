class Report < Ohm::Model
  extend ::EventHandler

  class << self


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
