require_relative './db'

class Product < ActiveRecord::Base
  self.table_name = 'produtos'
  self.primary_key = 'id'
end
