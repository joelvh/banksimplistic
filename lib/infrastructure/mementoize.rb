module Mementoize

  def self.included(base)
    # base.instance_eval do
    #   extend DSL
    # end
    base.class_eval do
      include InstanceMethods
      attr_accessor :applied_memento
    end
  end
  # module DSL
  # end

  module InstanceMethods
    def to_yaml_properties
      instance_variables - [:@aggregate_version, :@applied_events, :@applied_memento]
    end
    
    def store_memento

      memento = Memento.new(:aggregate_root_class => self.class.name, :aggregate_root => self)

      memento.serialize_aggregate_root
      
      memento.update_attributes(:aggregate_version => self.aggregate_version, :aggregate_uid => uid) 
      applied_memento = memento
      memento.save      
    end
  end
end

