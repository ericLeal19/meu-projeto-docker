# Atividade Docker + CI - Eric Gabriel Silva Leal

Preencha todos os campos marcados com [...] e substitua os prints de exemplo pelos seus.
Salve as imagens em docs/imagens/ e mantenha os nomes de arquivo indicados.

**Aluno(a):** Eric Gabriel Silva Leal
**Turma:** Vespertino
**Data:** 27/07/2026
**Aplicação usada:** docker/getting-started-app To-Do em Node.js

## 1. Como executar este projeto
git clone [https://github.com/ericLeal19/meu-projeto-docker.git](https://github.com/ericLeal19/meu-projeto-docker.git)
cd meu-projeto-docker
cp .env.example .env
docker compose up -d --build

Acesse: http://localhost:3000
Para derrubar: docker compose down (mantém dados) ou docker compose down -v (apaga dados).

## 2. Imagem e Dockerfile multi-stage

* **Estágios utilizados:** builder (instala dependências) e estágio final (runtime enxuto).
* **Imagem base:** node:20-alpine.
* **Usuário de execução:** node (não-root).
* **Tamanho final da imagem:** todo-app:v1  a95d8d022dee   161MB   0B .
* **Por que o multi-stage ajuda?** O build de dependências pesadas fica no primeiro estágio, copiando apenas o necessário para a imagem final, tornando-a mais leve e segura.

![Print 1 - build + docker images](<docs/image/01 - Docker-image.png>)
![Print 2 - aplicação rodando com tarefas cadastradas](<docs/image/02 - app-rodando.png>)

## 3. Volumes e persistência

* **Volume usado:** `todo-mysql-data` → montado em `/var/lib/mysql`.
* **Diferença entre docker compose down e docker compose down -v:** O normal apenas apaga os containers, enquanto o `-v` deleta também os volumes, apagando os dados permanentemente.

![Print 3 - SEM volume: dados perdidos ao recriar o container](<docs/image/03 - antes-de-sumir.png>)
![alt text](<docs/image/04 - Sumiu.png>)
![Print 4 - COM volume: dados preservados](<docs/image/05 - Antes-de-não-sumir.png>)
![alt text](<docs/image/06 - Não-sumiu.png>)
![alt text](<docs/image/07 - Docker-Volume-ls.png>)

## 4. Rede

* **Rede criada:** `todo-net`.
* **Serviços conectados:** app e db.
* **A porta do banco está exposta ao host?** Não. O acesso ao banco (porta 3306) ocorre apenas internamente pela rede Docker para garantir segurança.
* **Por que o app consegue chamar o host mysql/db sem saber o IP?** Devido ao DNS interno do Docker, que resolve o nome do serviço para o IP do container correspondente.

![Print 5 - docker network inspect](<docs/image/08 - Network-1.png>)
![Print 6 - dados dentro do MySQL (`select * from todo_items;`)](<docs/image/09 - Network-2.png>)

## 5. Docker Compose

* **Serviços:** app, db.
* **Rede:** todo-net.
* **Volume:** todo-mysql-data.
* **Healthcheck em:** db.
* **depends_on com:** condition: service_healthy.
* **Variáveis sensíveis:** Carregadas via .env (ignorado no git). Arquivo `.env.example` versionado como modelo.

![Print 7 - docker compose ps](<docs/image/07 - Docker-Volume-ls.png>)
![alt text](<docs/image/10 - Pesistindo-com-Compose.png>)
![alt text](<docs/image/11 - Apagando-volume-Compose.png>)

## 6. Integração Contínua (GitHub Actions)

* **Arquivo do workflow:** `.github/workflows/ci.yml`
* **Gatilhos:** push e pull_request.
* **O que o pipeline faz:**
1. Valida o compose (`docker compose config`).
2. Faz o build da imagem do app.
3. Sobe a stack de containers.
4. Aguarda a aplicação responder e testa criar uma tarefa via API (Smoke test).
5. Derruba a stack (`docker compose down -v`).



![Print 8 - execução verde](<docs/image/12 - Commit-inicial-check.png>)


## 7. Quebra proposital do CI

* **O que eu quebrei:** Comentei a linha build dentro de "app" para quebrar o compose.
* **Erro que apareceu no log:** "service "app" has neither an image nor a build context specified: invalid compose project; Error: Process completed with exit code 1."
* **Como o CI reagiu:** O step validar compose falhou pois não conseguiu completar a requisição.
* **Como eu corrigi:** Reverti a alteração no arquivo.
* **Link do Pull Request:** [Pull Request](https://github.com/ericLeal19/meu-projeto-docker/pull/1)

![Print 9 - execução vermelha + log do erro](<docs/image/14 - Erro-no-teste-2.png>)
![alt text](<docs/image/14 - Correção-da-quebra-do-teste.png>)

## 8. Dificuldades e aprendizados

Durante a atividade, enfrentei problemas de permissão (`EACCES`) para criar o banco, resolvidos ajustando as permissões da pasta antes de aplicar o `USER node`. Também lidei com conflitos de nome de containers antigos travados e divergências de branch no Git (`master` vs `main`). Aprendi como o Docker isola processos e redes e como a automação via CI previne erros humanos em produção.

## 9. Checklist de autoavaliação

* [x] Dockerfile multi-stage funcionando
* [x] .dockerignore presente
* [x] Container não roda como root
* [x] Volume nomeado + persistência demonstrada
* [x] Rede nomeada + banco não exposto ao host
* [x] compose.yaml sobe tudo com um comando
* [x] .env no .gitignore e .env.example versionado
* [x] CI verde
* [x] PR com CI vermelho documentado
* [x] Todos os 9 prints no README


## CD — Publicação no Docker Hub
Aluno(a): Eric Gabriel Silva Leal   Turma: Vespertino
Usuário do Docker Hub: ericgsleal
Imagem publicada: ericgsleal/meu-projeto-docker:latest
Link da imagem no Docker Hub: https://hub.docker.com/r/ericgsleal/meu-projeto-docker
Dispara quando: push na branch main
Arquivo do workflow: .github/workflows/cd.yml


Print 1 — token criado no Docker Hub ![alt text](<docs/image/15 - Criando o token.png>)
Print 2 — Secrets cadastrados no GitHub (DOCKERHUB_USERNAME e
DOCKERHUB_TOKEN) ![alt text](<docs/image/16 - Token e variáveis.png>)
Print 3 — workflow de CD verde na aba Actions ![alt text](<docs/image/17 - Github CD.png>)
Print 4 — imagem publicada no Docker Hub ![alt text](<docs/image/18 - Imagem-DockerHub.png>)
Print 5 — docker pull baixando a imagem publicada ![alt text](<docs/image/19 - Baixando-Imagem-DockerHub.png>)
Respostas
1. O que é o Docker Hub? 
É quase, na prática, um GitHub do Docker. Trata-se de um ambiente para guardar/publicar imagens que foram
criadas por mim.

2. Diferença entre CI e CD: 
CI trata-se de um mecanismo de integração/automação para executar determinados passo/testes antes de 
juntar (dar merge) no github, facilitando o processo de publicação e atualização do projeto.

O CD é um mecanismo para publicação de projetos em outros ambientes como o DockerHub através de tokens 
e APIs.

Definição da IA:
CI (Integração Contínua): É o seu controle de qualidade automático. Ele roda builds e testes para garantir que o código novo não quebre o sistema quando você der o merge (seja no GitHub, GitLab, Bitbucket, etc.).

CD (Entrega ou Implantação Contínua): Enviar a imagem pronta para o Docker Hub usando tokens é o que chamamos de Entrega (Delivery) — o pacote está finalizado e disponível. O passo além disso é a Implantação (Deployment), que seria automatizar a etapa de pegar essa imagem do Docker Hub e colocá-la para rodar diretamente em um servidor de produção para o usuário final.

3. Por que usar token e Secrets em vez de escrever usuário e senha no cd.yml ? 
Trata-se de um procedimento de segurança básico no desenvolvimento, pois o usuário, senha e tokens
são dados sensíveis que podem ser extremamente explorados por atacantes/pessoas maliciosas.

4. O que significa a tag latest ?
A tag "latest" é um padrão usado no ambiente de versionamento para se tratar da última versão 
disponível de alguma imagem/sistema. Nem sempre o mais atual é o mais seguro ou mais estável.



```

```