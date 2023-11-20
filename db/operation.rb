require_relative './db'

class Operation < ActiveRecord::Base
  self.table_name = 'operacoes'
  self.primary_key = 'id'
end
