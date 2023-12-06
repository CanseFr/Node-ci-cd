# Node-ci-cd

Ici nous allons creer une application tres simple qui effectu un test, puis trigger les actions github pour lancer les test puis build une image qui va etre push sur notre repository DockerHub.

On va eglament creer deux repository secret pour y stocker notre toekn d'accée docker ainsi que ntore nom de user pour pouvoir push sur docker hub grace a l'action

Test
Dockerfile
Action


```
docker image build -t app_ci .  
docker run --name=app_ci -d -p=3001:3000 app_ci   // Tester avant de push     
```


Action Git 

- Integration continuous : Node.js > COnfigure

```yaml
# This workflow will do a clean installation of node dependencies, cache/restore them, build the source code and run tests across different versions of node
# For more information see: https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-nodejs

name: Node.js CI // Nom

on:            // Declanche a chaque pull request sur la branch main, les jobs ci dessous
  push:
    branches: [ "main" ]  
  pull_request:
    branches: [ "main" ]

jobs:                 
  build:

    runs-on: debian-latest          // Va lancer les l'app sur ubuntu

    strategy:
      matrix:
        node-version: [20.10]      // selectionner version souhaité
        # See supported Node.js release schedule at https://nodejs.org/en/about/releases/

    steps:                                      // script pré ecrit -> https://github.com/actions/checkout
    - uses: actions/checkout@v3
    - name: Use Node.js ${{ matrix.node-version }} // version precisé au dessous
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    - run: npm ci
    - run: npm run build --if-present
    - run: npm test

```

Git > Valider et commit 


Git > Repo > Setting > Secret and variable  > Actions > New repo secret > name : DOCKERHUB_USERNAME > ajouter nom user dockerHub



Dcoker hub > setting > security > add access token lecture ecrite 
Generer
Copier clé   

Git > Repo > Setting > Secret and variable  > Actions > New repo secret > name : DOCKERHUB_HUB > ass secret
Coller la clé copié de docker hub acces name : DOCKERHUB_TOKEN  secret : clé  du git hub 


Aller dans notre app, dans le fichier node.js.yaml du workflow. Puis rajouter un nouveau job (step) :

```node.js.yaml
name: Node.js CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:

    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [20.10]
        # See supported Node.js release schedule at https://nodejs.org/en/about/releases/

    steps:
    - uses: actions/checkout@v3
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    - run: npm ci
    - run: npm run build --if-present
    - run: npm test

# ICI 

    - name: Login to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}

    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        push: true
        tags: cansefr/test-node:latest
```

Git action > new workflow > Docker image 



Nous allons retourner dans la racine du projet pour creer un nouveau ficher dans le repertoir github/workflow *push-docker.yml*

Cela va permettre de creer un fichier pour le lancement de test au moment d'un push et d'un pull request par contre le nouveau fichier lui va build une image et push sur le hub 





Nous allons ajouter les reglees sur les branche pour que les parametre palcé dans le fichier dudessus concernant les branches soit appliqué. Un pull request et review et necessaire pour merge, et donc build image + docker push

Github du projet > Sttings > branche > add rules > 

Branche name pattern : main 
Require pull request before merging
Require approvals


