module DomainRepository

  class << self
    
    include Eventwire::Publisher
  
    def aggregates
      Thread.current[:"DomainRepositoryCurrentStore"]
    end
  
    def begin
      Thread.current[:"DomainRepositoryCurrentStore"] = Set.new
    end
  
    def add(aggregate)
      self.aggregates << aggregate
      aggregate
    end
  
    def commit
      aggregates.each do |aggregate|
        while event = aggregate.applied_events.shift
          save event
          publish_commit event
        end
      end
    end
    
    def method_missing(meth, *args, &blk)
      if meth.to_s =~ /^find_(.+)/
        find($1, args.first)
      else
        super
      end
    end
    
    def find_events(uid)
      events = Event.find(:aggregate_uid => uid)
    end
    
    def find(type, uid)
      events = Event.find(:aggregate_uid => uid )

      # We could detect here that an aggregate doesn't exist (it has no events) 
      # instead of inside the aggregate itself

      memento = Memento.find(:aggregate_uid => uid).sort(:by => :aggregate_version).last
      if memento
          filtered_events = events.to_a.select do |e| 
          aggregate_version =  e.aggregate_version || 0
          aggregate_version > memento.aggregate_version
        end
        add type.camelize.constantize.build_from_memento_and_events(memento, filtered_events)
      else
        add type.camelize.constantize.build_from(events)
      end
    end

    private
    
    def save(event)
      event.save
    end

    def publish_commit(event)
      publish_event(event.name, {:data => event.data})
    end
    
    def publish_mement(memento)
       publish_memento(:memento_saved, {data => memento.data})
    end
    
  end
  
end
