# Gitlab-CI | Automate deploying a Dockerized basic web application with Gitlab CI and AWS

<p align="center">
Please find the specifications by clicking
  <a href="https://github.com/eazytraining/gitlab-ci-training/tree/2ea9e36e03909e19ceb2fae2d9d950b3dc8546e8/TPs%20Heroku/TP6%20-%20Test%20de%20validation" alt="Crédit : eazytraining.fr" >
  </a>
</p>

------------

Firstname : Carlin

Surname : FONGANG

Email : fongangcarlin@gmail.com


<img src="https://media.licdn.com/dms/image/C4E03AQEUnPkOFFTrWQ/profile-displayphoto-shrink_400_400/0/1618084678051?e=1710979200&v=beta&t=sMjRKoI0WFlbqYYgN0TWVobs9k31DBeSiOffAOM8HAo" width="50" height="50" alt="Carlin Fongang"> 

LinkedIn : https://www.linkedin.com/in/carlinfongang/

_______
# Documenting my experiments with Gitlab CI to deploy a Dockerized html application.
![Alt text](image-3.png)

## Architecture
![Alt text](image-2.png)

## Overview
Dans cet projet, je vais déployer un projet via une chaine CI/CD sur Gitlab, en utilisant leur suite complète d'outils pour enfin placer mon application groupée sur le serveur de production basé sur une instance EC2 de AWS.

## The Project
Un petit commentaire sur la configuration du projet. L'intention étant de mettre en exergue le déploiement en environnement de production en usant des outils tels que  Gitlab ainsi que  la configuration de docker/nginx via l'application Web static-website-example.

1. Application Web  basic qui affiche un page web static avec du contenu texte et des couleurs.
2. Serveur Web fonctionnant sur nginx.
3. Un seul conteneur Docker sans aucune couche de persistance.
4. Le serveur de production sera sur AWS, Ubuntu 22.04.
5. Gitlab pour héberger le contrôle de source, les pipelines CI et le référentiel de conteneurs.

## Intended Workflow
Lorsqu'un développeur pousse vers une branche principale ou des balises,

1. Le build de l'image du docker sera déclenchée.
2. Une nouvelle image Docker est créée et balisée.
3. Ensuite on effectura un test d'acceptance pour s'assurer du la fiabilité de l'image Docker buildé
4. L'image Docker est ensuite transférée vers le registre de conteneurs Gitlab comme release.
5. L'exécuteur de pipeline va lancer le déploiement de l'image sur l'environnement de review lors de nouvelle merge request.
6. Une fois la version en review validé, et la merge sur la branche main validé, l'étape de stop review pour la suppression de l'environnement de review sera lancée
7. Après le stop review effectué dans le pipeline, le déploiement en environnemnet de staging sera exécuté dnas le pipeline
8. Une test du staging sera ensuite exécuté pour vérifié la disponibilité de l'application en staging
9. Une fois l'étape 8. validé dans le pipeline (test staging), le deploiement en production sera exécuté
10. Enfin, un test du déploiment constituant la dernière étape du pipeline sera effectué pour validé la disponibilité de l'application en production

## 1. Dockerfile content
Déclaration du Dockerfile qui va servir au futur build du projet dans la première étape du pipeline 
>![Alt text](image-5.png)

Ce Dockerfile définit les étapes nécessaires pour créer une image Docker basée sur Ubuntu 18.04, avec Nginx installé et un dépôt Git cloné pour servir un site web statique. Voici une explication point par point :

1. Utilise l'image de base Ubuntu version 18.04.
2. Ajoute une étiquette (label) "maintainer" avec l'adresse e-mail de l'auteur.
3. Définit le répertoire de travail actuel à /var/www/html/.
4. Met à jour les paquets, installe `Curl, Nginx et Git`, puis supprime le contenu existant dans `/var/www/html/`.
5. Clone le dépôt Git `https://github.com/CarlinFongang/static-website-example.git` dans /var/www/html.
6. Expose le port 80 pour les connexions externes.
7. Configure l'entrée principale pour démarrer Nginx en mode démon (daemon).


## Mise en place du projet Gitlab
>![Alt Page du projet Gitlab](image-6.png)
### 1. Créez un nouveau projet
Créez un nouveau projet et notez les instructions sur la façon de transmettre votre code au projet. Avant cela, assurez-vous d'avoir déjà configuré vos clés SSH pour la connextion à Gitlab depuis votre pc.

### 2. Poussez votre projet sur gitlab


````
cd projet-web-cicd
git remote add origin git@gitlab.com:user_name_on_gitlab/projet-web-cicd.git 
git add . 
git commit -m "Initial Commit" 
git push -u origin main
````

### 3. Créez un fichier .gitlab-ci.yml
Créez un fichier caché .gitlab-ci.yml et placez-le dans la repertoire racine du projet. Ceci est nécessaire pour que gitlab récupère et configure le pipeline. Une fois que gitlab aura détecté ce fichier, il attribuera des runners pour exécuter votre pipeline. Le contenu du gitlab-ci.yml est le suivant.
````
$PWD\projet-web-cicd\.gitlab-ci.yml
````
>![Alt text](image-7.png)

Il y a un total de 9 étapes dans notre processus de fabrication de pipeline. Défini en haut du fichier .gitlab-ci.yml
1. Build: Construction de l'image docker qui sera utilisé pour les futur déploiements.
2. Test acceptation: Exécution de tests pour valider la fiabilité de l'image builder.
3. Release image: Publication de l'image dans le registre gitlab pour une utilisation ultérieure.
4. Deploy review: Déploiement d'un environnement de review pour tester les fonctionnalités de nouvelle branche.
5. Stop review: Suppression de l'environnement de review après validation des fonctionnalités.
6. Deploy staging: Déploiement en environnement de staging pour des tests plus larges.
7. Test staging: Exécution de tests pour valider le déploiement en staging.
8. Deploy prod: Déploiement en production après validation en staging.
9. Test prod: Exécution de tests pour valider le déploiement en production.


## Setting of build stage 
dans cette étape, je fait appel directement au code depuis le repo distance 
dans le stage  docker-build, nous utilisons une image Docker pour créer une autre image Docker, vous pouvez donc voir que nous avons utilisé l'image docker:latest et comme service docker:dind.
Une fois l'image buildé, nous allons gardé le produit de cette phase sous forme d'artifact pour un usage ultérieur 
![Alt text](image-8.png)
>![Alt text Réalisation du build dans le pipeline CI/CD](image.png)




## Launc "test d'acceptation"
>![Alt text](image-1.png)

