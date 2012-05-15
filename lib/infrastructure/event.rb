class Event < Ohm::Model
  attribute :name
  attribute :aggregate_uid
  attribute :serialized_data
  
  def data
    @data ||= begin
      value = get(:serialized_data)
      value && YAML.load(value).with_indifferent_access
    end
  end
  
  def data=(value)
    @data = value
  end
  
  # Can only call set when model has been saved and therefore has an ID.
  def set_data
    set(:serialized_data, @data.to_yaml)
  end
  
  index :aggregate_uid
end