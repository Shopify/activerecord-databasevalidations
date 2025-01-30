module ActiveRecord
  module DatabaseValidations
    module Adapters
      class MissingAdapterError < StandardError; end

      @registry = {}

      def self.for(column)
        name = column.class.name.delete_prefix("ActiveRecord::ConnectionAdapters::")
        name.delete_suffix!("::Column")

        registry.fetch(name).call
      rescue LoadError, KeyError
        raise MissingAdapterError, "no adapter found for #{name}"
      end

      def self.register(name, &loader)
        @registry[name] = loader
      end

      class << self
        attr_reader :registry
      end
    end

    Adapters.register("MySQL") do
      require "active_record/database_validations/adapters/mysql"
      ActiveRecord::DatabaseValidations::Adapters::MySQL
    end
  end
end
