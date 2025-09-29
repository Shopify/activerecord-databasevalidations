module ActiveRecord
  module DatabaseValidations
    module PostgreSQL
      TYPE_LIMITS = {
        varchar:               { type: :characters },
        'character varying' => { type: :characters },
        character_varying:     { type: :characters },  # Add underscore version
        char:                  { type: :characters },
        character:             { type: :characters },
        text:                  { type: :characters },
        bytea:                 { type: :bytes },
      }

      def self.column_size_limit(column)
        # Handle "character varying(255)" -> "character_varying"
        column_type = column.sql_type.sub(/\(.*\z/, '').strip.gsub(/\s+/, '_').downcase.to_sym
        type_limit = TYPE_LIMITS.fetch(column_type, {})

        [
          column.limit,  # PostgreSQL stores limit in column.limit
          type_limit[:type],
          determine_encoding(column),
        ]
      end

      def self.determine_encoding(column)
        column = ActiveRecord::Validations::TypedColumn.new(column)
        return nil unless column.text?
        Encoding::UTF_8  # PostgreSQL text is UTF-8 by default
      end
    end
  end
end