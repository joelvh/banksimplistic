module CommandCollection
  module DSL
    def command(name, &block)  
      klass = Class.new(Object) do
      
        define_method :execute, block do |*args|
          block.call(*args)
        end
      end

      const_set("#{name.to_s.camelize}CommandHandler",klass)
    end
  end
end
