require_relative './db'

class Result < ActiveRecord::Base
  self.table_name = 'resultados'
  self.primary_key = 'id'
end
