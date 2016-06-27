require 'sequel'
require 'sequel/adapters/shared/mysql'
require 'logger'

module DB
  def self.connection
    @connection ||= setup
  end

  private

  def self.setup
    host     = ENV['DB_HOST']
    db       = ENV['DB_NAME']
    user     = ENV['DB_USER']
    password = ENV['DB_PASS']
    Sequel::MySQL.convert_tinyint_to_bool = false
    Sequel.mysql2(
      {
        host: host,
        database: db,
        user: user,
        password: password,
        encoding: 'utf8'
      }.tap do |v|
        v[:logger] = Logger.new($stdout) unless ENV['RACK_ENV'] == 'production'
      end
    )
  end
end
