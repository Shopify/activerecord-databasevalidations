module ActiveRecord
  module Validations
    module AdapterHelper
      def mysql_adapter?(connection)
        connection.is_a?(ConnectionAdapters::AbstractMysqlAdapter)
      end
    end
  end
end
