require "sequel"

require "./db"
require "./contact"

module Main
  class ContactQuery
    attr_reader :limit,
                :offset,
                :collection,
                :conn

    def initialize(params)
      page = get(:page, from: params, default: 1)
      per_page = get(:per_page, from: params, default: 100)

      @limit = per_page
      @offset = per_page * (page - 1)
      @collection = []
    end

    def all
      @conn = Sequel.connect(DB_PARAMS)
      fill_users
      conn.disconnect
      collection
    end

    private

    def fill_users
      return if conn.nil?

      @collection = conn[:users].select(
        :id,
        :email,
        :first_name,
        :last_name,
        :middle_name,
        :date_of_birth,
        :sex
      ).order(:id)
      .limit(limit)
      .offset(offset).map do |rec|
        Contact.new(rec)
      end
    end

    def get(key, from:, default:)
      value = from[key].to_i
      value > 0 ? value : default
    end
  end
end