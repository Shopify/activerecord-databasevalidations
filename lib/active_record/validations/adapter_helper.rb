module ActiveRecord
  module Validations
    module AdapterHelper
      def mysql_adapter?(connection)
        connection.is_a?(ConnectionAdapters::AbstractMysqlAdapter)
      end

      def postgresql_adapter?(connection)
        connection.is_a?(ConnectionAdapters::PostgreSQLAdapter)
      end
    end
  end
end
