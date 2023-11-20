### Instalação

1. Abra o terminal

2. Baixe o código do Projeto com o comando abaixo:

   ```sh
   git clone https://github.com/cleitonfco/mba-final-project.git
   ```

3. Acesse o diretório raiz do projeto.

   ```sh
   cd mba-final-project
   ```

### Pré-requisitos

1. Verifique se você tem o ruby instalado:

   ```sh
   ruby --version
   ```

2. Se você não tem o Ruby instalado, [instale-o](https://www.ruby-lang.org/pt/documentation/installation/).

3. Instale o Bundler:

   ```sh
   gem install bundler
   ```

4. Instale as dependências:

   ```sh
   bundle install
   ```

### Banco de dados

1. Altere as propriedades do arquivo `db/db.rb`, para que fique de acordo com o credenciamento do seu banco de dados:

   ```
   ActiveRecord::Base.establish_connection(
    adapter: 'mysql2',
    host: 'localhost',
    username: 'user',
    password: 'passw',
    database: 'dbname'
  )
   ```

2. Execute o script `setup.rb`. Ele irá criar as tabelas do banco de dados e preparar a estrutura necessária para armazenar os dados:

   ```sh
   ruby setup.rb
   ```

### Importação e Limpeza dos dados

1. Execute o seguinte script:

   ```sh
   ruby import_and_clear.rb
   ```
