# Teddy-Digital
Repositorio Criado para descrever o processo de criação de infraestrutura para a Teddy Digital

# Fase 1
Suponha que você esteja trabalhando em um servidor
Linux e precisa executar um contêiner Docker de uma
imagem específica. Descreva os passos necessários para
realizar essa tarefa, incluindo a instalação do Docker, a
obtenção da imagem desejada e a execução do
contêiner. Certifique-se de mencionar comandos
relevantes e considerar qualquer configuração adicional
necessária.
## Definindo estrutura do projeto
![estrutura do projeto 1](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/Captura+de+tela+de+2023-07-30+22-55-22.png)
## Criando imagens
É possível obter imagens docker a partir do Docker Hub, repositórios privados e tambem é possível criar imagens personalizadas utilizando Dockerfiles.
### Criando imagem Nginx
![Imagem Docker Nginx](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/Captura+de+tela+de+2023-07-30+23-00-24.png)
### Criando imagem Node
![Imagem Docker Node](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/Captura+de+tela+de+2023-07-30+23-02-47.png)
### Criando imagem Mysql
![Imagem Docker Mysql](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/Captura+de+tela+de+2023-07-30+23-03-51.png)
### Build e start service
```
    mysql: “docker build -t mysql -f Dockerfile-mysql  . 
    docker build -t node . 
    docker build -t nginx -f Dcokerfile-mysql .
```
```
    docker network create fase-one-network
    docker run -d --name frontend-container -p 8080:80 --network minha-rede nginx
    docker run -d --name node-container -p 3000:3000 --network minha-rede node-image
    docker run -d --name mysql-container -p 3306:3306 --network minha-rede -e MYSQL_ROOT_PASSWORD="QfDGe1m&37B3" -e MYSQL_USER=admin -e MYSQL_PASSWORD="l0e6#@zwEH0c" -e MYSQL_DATABASE=db_fase mysql
```
![Serviço rodando](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/Captura+de+tela+de+2023-07-30+23-12-50.png)

# Fase 2
Baseado no cenário acima precisa usar o Terraform
para provisionar o servidor Linux com o Docker em
um provedor de nuvem (AWS é um diferencial).
Descreva os passos necessários para realizar essa
tarefa, incluindo a definição do provedor, a
configuração da infraestrutura de redes, permissão e
identidades. Certifique-se de mencionar os arquivos
e recursos relevantes.
## Definindo estrutura do projeto
![](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/Captura+de+tela+de+2023-07-30+22-38-38.png)
## Defininfo estrutura de Redes
![](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/projeto-tech.drawio.png)
## Iniciando projeto
Será necessario iniciar o projeto em ordem, sendo. Networking, EC2 e LoadBalancer.
Dentro da pasta raiz do modulo terraform
```
terraform init
terraform plan
terraform apply
```
## Acesse o serviço:
[fase2.fairness.tech](http://fase2.fairness.tech)
## inicialização do serviço
```
git clone https://github.com/Robert-J-Barros/{repository}
docker-compose up -d --build
```
# Fase 3
Baseado em um cenário ao qual temos uma
necessidade de ser realizado um CI/CD para uma
aplicação. Essa aplicação é um simples MVP ao qual
roda em um servidor WEB Apache2 ou Ngnix.
Portanto, é necessário que seja feito um CI/CD que
envolva a aplicação em Apache2 ou Ngnix sendo
feito o deploy em um custer em ECS
Fargate. Certifique-se de mencionar os arquivos e
recursos relevantes.
## Inicie o modulo ECS
Ao iniciar o modulo ECS será criado os seguintes recuros; ECS Cluster, ECR, Application Load Balancer e Registro de DNS.
```
terraform init
terraform plan
terraform apply
```
## Build e Envio para ECR
No repositorio Fairness-frontend faça o build do Dockerfile:
```
Docker build -t fairness:{tag} .
```
Resgate suar credencias do ECR:
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 479254302146.dkr.ecr.us-east-1.amazonaws.com
```
Marque a imagem:
```
docker tag my-app:latest 479254302146.dkr.ecr.us-east-1.amazonaws.com/my-app:latest
```
Faça o push para o repositorio
```
docker push 479254302146.dkr.ecr.us-east-1.amazonaws.com/my-app:latest
```
## criação da Task definition e Criação de serviço:
Criando Task:

![](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/ecs-1.jpg)
![](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/ecs-2.jpg)

Criando Serviço:

![](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/ecs-s-1.jpg)
![](https://bk-projeto-fairness-imov.s3.amazonaws.com/imagens/Captura+de+tela+de+2023-07-31+02-24-36.png)

## Registre o IP no target group Application load balancer

![image](https://github.com/Robert-J-Barros/Teddy-Digital/assets/105607298/3c7c483c-0b42-49e8-bf06-8bf06457305e)

# Etapa 4
## Monitoramento
O monitoramento foi feito utilizando o CloudWatch metricas, no qual será analizado o consumo de CPU e RAM. As metricas irão se atualizar a cada 5 minutos.
![image](https://github.com/Robert-J-Barros/Teddy-Digital/assets/105607298/9d40c106-c1c8-4958-9e30-4bd7d86ebb25)

