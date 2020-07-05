# Rango Livre - MegaHack 3a edição - Time 30 - Backend

O time participou do desafio do Mercado Livre. Nossa proposta foi de utilizar toda a estrutura já disponível da empresa, assim como as maquininhas, para oferecer a opção de vale-refeição pelo Mercado Livre com o lançamento de uma plataforma de pedidos que permita esta utilização.

Todos os endpoints do back-end estão documentados no Swagger:

https://app.swaggerhub.com/apis-docs/joaofernandes/MegaHack/0.0.1

O desenvolvimento foi feito com Ruby On Rails. A aplicação está hospedada no Heroku e o banco de dados está hospedado na Amazon. Pode acessar pelo link:

https://rango-livre.herokuapp.com/

A cada nova transação, há uma integração com a API da Zenvia para enviar WhatsApp informando de crédito/débito em conta do usuário, especificando se foi no Vale ou no Mercado Pago. Para utilizá-la, basta configurar as variáveis de ambiente ZENVIA_TOKEN e ZENVIA_NAME na sua máquina. 

As fotos dos produtos são carregadas para o S3 e devolvidas como uma URL para o front-end poder exibir.
