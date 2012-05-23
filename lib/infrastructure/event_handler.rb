module EventHandler
  include Eventwire::Subscriber::DSL
    @@event_handlers = {}
  
  def event_handlers
    @@event_handlers
  end

  def add_event_handler(event_name, &handler)
    @@event_handlers[event_name] = handler
  end

  def on(*events, &block)
    events.each do |event_name|

      # update list of event handlers
      self.add_event_handler(event_name, &block)

      # this passes the event and handler to eventwire for registration of a queue
      super(event_name) do |event|
        event.data = event.data.to_hash.symbolize_keys
        block.call(event)
      end
    end
  end
  
end
