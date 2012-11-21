module CommandBus
private

  def execute_command_in_collection(*args)
    collection_name = args.shift
    command_name = args.shift

    DomainRepository.begin
    lookup_handler_in_collection(collection_name, command_name).execute(*args)
    DomainRepository.commit
  end

  def execute_command(*args)
    DomainRepository.begin
    lookup_handler(args.shift).execute(*args)
    DomainRepository.commit
  end

  def lookup_handler(command_name)
    "#{command_name.to_s.camelize}CommandHandler".constantize.new
  end
  
  def lookup_handler_in_collection(collection_name, command_name)
    "#{collection_name.to_s.camelize}::#{command_name.to_s.camelize}CommandHandler".constantize.new
  end
  
end
