module FactoryGirl
  class SeedGenerator
    @ids = {}
    @classes = {}

    def self.create(factory_name, attributes = nil)
      raise "attributes must be a hash" if attributes && !attributes.is_a?(Hash)

      model = FactoryGirl.create(factory_name, attributes)
      @ids[factory_name] = model.id
      @classes[factory_name] = model.class

      model
    end

    def self.[](factory_name)
      seed_id = @ids[factory_name]

      if seed_id
        seed_class = @classes[factory_name]
        seed_class.find_by_id(seed_id) || create(factory_name)
      else
        create(factory_name)
      end
    end
  end
end

module FactoryGirl
  module Syntax
    module SeedMethods
      def seed(factory_name)
        if Rails.env.test?
          FactoryGirl::SeedGenerator[factory_name]
        else
          FactoryGirl.create(factory_name)
        end
      end
    end
  end
end

FactoryGirl::Syntax::Methods.send(:include, FactoryGirl::Syntax::SeedMethods)
FactoryGirl::SyntaxRunner.send(:include, FactoryGirl::Syntax::SeedMethods)
FactoryGirl.send(:include, FactoryGirl::Syntax::SeedMethods)
