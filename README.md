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

```

```