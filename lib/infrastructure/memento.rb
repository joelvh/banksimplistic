class Memento < Ohm::Model
  attribute :aggregate_root_class
  attribute :aggregate_version
  attribute :aggregate_uid
  attribute :serialized_data

  def data
    @data ||= begin
      value = get(:serialized_data)
    end
  end

  def aggregate_root=(value)
    @aggregate_root = value
  end

  # Can only call set when model has been saved and therefore has an ID.
  def serialize_aggregate_root
    @data = @aggregate_root.to_yaml
    update_attributes(:serialized_data => @data)
  end

  index :aggregate_uid
  # index :aggregate_version
end
