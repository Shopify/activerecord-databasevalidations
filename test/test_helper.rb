# coding: utf-8
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "minitest/autorun"
require "minitest/pride"

require "yaml"

require "active_record/database_validations"

module DataLossAssertions
  def assert_data_loss(record)
    attributes = record.changed
    provided_values = record.attributes.slice(*attributes)

    record.save!(validate: false)

    persisted_values = record.reload.attributes.slice(*attributes)
    refute_equal provided_values, persisted_values
  rescue ActiveRecord::RangeError, ActiveRecord::StatementInvalid, ActiveModel::RangeError
    pass
  end

  def refute_data_loss(record)
    attributes = record.changed
    provided_values = record.attributes.slice(*attributes)

    record.save!(validate: false)

    persisted_values = record.reload.attributes.slice(*attributes)
    assert_equal provided_values, persisted_values
  end
end

mysql_host = ENV.fetch("MYSQL_HOST") { "localhost" }
mysql_port = ENV.fetch("MYSQL_PORT") { 3306 }
connection_config = {
  adapter: "mysql2",
  database: "database_validations",
  username: "root",
  encoding: "utf8mb4",
  strict: false,
  host: mysql_host,
  port: mysql_port,
}

ActiveRecord::Base.establish_connection(connection_config)
I18n.enforce_available_locales = false
