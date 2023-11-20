require 'csv'
require_relative './db/operation'
require_relative './db/product'
require_relative './db/result'

data = CSV.parse(File.read("./bases/Dados 2022-2023.csv"), headers: true)
map_operations = {
  "Código Filial" => 'codigo_filial',
  "Sequência" => 'sequencia',
  "Tipo Operação" => 'tipo',
  "Data Gravação" => 'data_gravacao',
  "Data Efetivação" => 'data_efetivacao',
  "Data Aut. Doc. Fiscal" => 'data_aut_doc_fiscal',
  "Mês Efetivação" => 'mes_efetivacao',
  "Código Vendedor 1" => 'codigo_vendedor',
  "Nome Vendedor 1" => 'nome_vendedor',
  "Código Cliente" => 'codigo_cliente',
  "Nome Cliente" => 'nome_cliente',
  "Código Produto" => 'codigo_produto',
  "EAN" => 'ean',
  "Nome Produto" => 'nome_produto',
  "Fornecedor 1" => 'fornecedor_1',
  "Fornecedor 2" => 'fornecedor_2',
  "Fornecedor 3" => 'fornecedor_3',
  "Fornecedor 4" => 'fornecedor_4',
  "Fornecedor 5" => 'fornecedor_5',
  "Fabricante" => 'fabricante',
  "Código Classe" => 'codigo_classe',
  "Nome Classe" => 'nome_classe',
  "Código Família" => 'codigo_familia',
  "Nome Família" => 'familia',
  "Quantidade" => 'quantidade',
  "Tabela de Venda" => 'tabela_venda',
  "Tabela Comparativa 1" => 'tabela_comparativa_1',
  "Tabela Comparativa 2" => 'tabela_comparativa_2',
  "Preço Unitário" => 'preco_unitario',
  "Valor Desconto" => 'valor_desconto',
  "Percentual Desconto" => 'percentual_desconto',
  "Valor Item Final Venda" => 'valor_item_final',
  "Valor Total Final Venda" => 'valor_total_final',
  "Custo Item" => 'custo_item',
  "Custo Total Venda" => 'custo_total',
  "MKP Prod" => 'markup_produto',
  "MKP Venda" => 'markup_venda',
  "Margem Contribuição Produto" => 'margem_contribuicao_produto',
  "Margem Contribuição Venda" => 'margem_contribuicao_venda',
  "Forma de Recebimento" => 'forma_recebimento',
  "Qtq Parcelas" => 'quantidade_parcelas'
}

data.each do |line|
  info = {}
  map_operations.each do |name, col|
    info[col.to_sym] = line[name] unless line[name].blank?
  end
  Operation.create(info)
end


# Lentes de Contato
data = CSV.parse(File.read("./bases/Base Lentes de Contato.csv"), headers: true)
map_table_lc = {
  "Código Produto" => 'codigo',
  "Nome Produto" => 'nome',
  "Marca" => 'marca',
  "Modelo" => 'modelo',
  "Esférico" => 'esferico',
  "Cilíndrico" => 'cilindrico',
  "Eixo" => 'eixo'
}

data.each do |line|
  info = { classe: 'LENTES CNT' }
  map_table_lc.each do |name, col|
    info[col.to_sym] = line[name] unless line[name].blank?
  end
  Product.create(info)
end
# ------------------------------------------------------------------------

# Lentes Oftálmicas
data = CSV.parse(File.read("./bases/Base Lentes Oftalmicas.csv"), headers: true)
map_table_lo = {
  "Código Produto" => 'codigo',
  "Nome Produto" => 'nome',
  "Marca" => 'marca',
  "Modelo" => 'modelo',
  "Classe" => 'classe',
  "Tipo" => 'tipo_lente',
  "Indice" => 'indice',
  "Tratamento" => 'tratamento_foto',
  "Antireflexo" => 'tratamento_ar',
  "Variação Antireflexo" => 'variacao_ar'
}

data.each do |line|
  info = { classe: 'LENTES OFT' }
  map_table_lo.each do |name, col|
    info[col.to_sym] = line[name] unless line[name].blank?
  end
  Product.create(info)
end
# ------------------------------------------------------------------------

# Óculos
data = CSV.parse(File.read("./bases/Base Oculos.csv"), headers: true)
map_table_oc = {
  "Código Produto" => 'codigo',
  "Nome Produto" => 'nome',
  "Marca" => 'marca',
  "Modelo" => 'modelo',
  "Classe" => 'classe'
}

data.each do |line|
  info = {}
  map_table_oc.each do |name, col|
    info[col.to_sym] = line[name] unless line[name].blank?
  end
  Product.create(info)
end
# ------------------------------------------------------------------------

# - Clear Data -----------------------------------------------------------
Operation.all.each do |operation|
  info = {}
  operation.attributes.keys.each { |column|
    info[column] = operation[column]
  }
  info[:ano] = operation.data_efetivacao.year
  info[:mes] = operation.data_efetivacao.month
  info[:dia] = operation.data_efetivacao.day
  info[:margem] = operation.valor_item_final.zero? ? 0.0 : (operation.margem_contribuicao_produto.to_f / operation.valor_item_final.to_f)

  if operation.forma_recebimento.present?
    valor_carne = operation.forma_recebimento.match(/Carnê: R\$ (\d+),(\d+)/)
    valor_dinheiro = operation.forma_recebimento.match(/Dinheiro: R\$ (\d+),(\d+)/)
    valor_cartao_credito = operation.forma_recebimento.match(/Cartão Crédito: R\$ (\d+),(\d+)/)
    valor_cartao_debito = operation.forma_recebimento.match(/Cartão Débito: R\$ (\d+),(\d+)/)
    valor_troca = operation.forma_recebimento.match(/Troca: R\$ (\d+),(\d+)/)
    valor_cartao_convenio = operation.forma_recebimento.match(/Cartão Convênio: R\$ (\d+),(\d+)/)
    valor_carteira = operation.forma_recebimento.match(/Carteira: R\$ (\d+),(\d+)/)
    valor_credito = operation.forma_recebimento.match(/^Crédito: R\$ (\d+),(\d+)/)
    valor_credito = operation.forma_recebimento.match(/\| Crédito: R\$ (\d+),(\d+)/) unless valor_credito.present?
    
    info[:valor_carne]           = "#{valor_carne[1]}.#{valor_carne[2]}".to_f                     if valor_carne
    info[:valor_dinheiro]        = "#{valor_dinheiro[1]}.#{valor_dinheiro[2]}".to_f               if valor_dinheiro
    info[:valor_cartao_credito]  = "#{valor_cartao_credito[1]}.#{valor_cartao_credito[2]}".to_f   if valor_cartao_credito
    info[:valor_cartao_debito]   = "#{valor_cartao_debito[1]}.#{valor_cartao_debito[2]}".to_f     if valor_cartao_debito
    info[:valor_troca]           = "#{valor_troca[1]}.#{valor_troca[2]}".to_f                     if valor_troca
    info[:valor_cartao_convenio] = "#{valor_cartao_convenio[1]}.#{valor_cartao_convenio[2]}".to_f if valor_cartao_convenio
    info[:valor_carteira]        = "#{valor_carteira[1]}.#{valor_carteira[2]}".to_f               if valor_carteira
    info[:valor_credito]         = "#{valor_credito[1]}.#{valor_credito[2]}".to_f                 if valor_credito
  end

  product = Product.find_by(codigo: operation.codigo_produto)
  if product
    info[:marca]  = product.marca
    info[:modelo] = product.modelo

    if product.classe == 'LENTE CNT'
      info[:esferico]   = product.esferico
      info[:cilindrico] = product.cilindrico
      info[:eixo]       = product.eixo
    end

    if product.classe == 'LENTE OFT'
      info[:tipo_lente]      = product.tipo_lente
      info[:indice]          = product.indice
      info[:tratamento_foto] = product.tratamento_foto
      info[:tratamento_ar]   = product.tratamento_ar
      info[:variacao_ar]     = product.variacao_ar
    end
  end

  begin
    Result.create(info)
  rescue ActiveRecord::StatementInvalid
    puts info.inspect
  end
end

