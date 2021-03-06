class Event < Ohm::Model
  attribute :name
  attribute :aggregate_uid
  attribute :serialized_data
  attribute :aggregate_version
  
  def data
    @data ||= begin
      value = get(:serialized_data)
      value && YAML.load(value).with_indifferent_access
    end
  end
  
  def data=(value)
    @data = value
  end
  
  def serialize_data
    update_attributes(:serialized_data => @data.to_yaml)
  end
  
  index :aggregate_uid
end