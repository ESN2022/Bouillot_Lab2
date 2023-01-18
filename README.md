# Lab2: “Let’s count stuff”

Sommaire :

a. Introduction

b. System architecture with QSYS components and their interaction, HW blocks, design choices

c. Conclusion, progress and result


## Introduction

Dans ce second lab je vais venir me perfectionner en co-design. Je vais venir génerer un compteur via différentes méthodes et ce sur plusieurs afficheurs sept segments. Les difficultés vont alors venir de la gestion des unité, dizaines et centaines, mais surtout de l'ajout de timer pour la génération du compteur. La cible de ce lab est toujours une carte DE10-Lite configurée à l'aide du logiciel Quartus 18.1 et de son environnement.


## System Architecture
La configuration est la même que celle du lab 1 (cf répertoire Bouillot_lab1).
Ce qui vient changer est la configuration sous Platforme Designer. Je vient donc choisir :
  - Nios 2
  - Clock (permettant de cadencer tous les sytèmes)
  - Onchip memory
  - Jtag (permettant la communication PC - Carte)
  - Un ou lusieurs PIO pour la gestion de l'affichage sur les afficheurs 7 segments
  - Un timer

![image](https://user-images.githubusercontent.com/121939768/211839128-b968aa95-0d9a-463a-9e29-a9bac28bca73.png)


Chaque bloc (ou IP) possède une fonctionnalité spécifique sur notre cible. La Clock va venir définir la cadence de communication entre chaque bloc et au sein d'un même bloc. Le Nios2 est le softcore que l'on va programmer sur le FPGA et qui va venir éxecuter notre script en C. Le Onchip Memory va venir sauvegarder notre soft avec toutes ses variables et bibliothèques. Enfin les PIO sont créés pour raccorder les périphériques  avec le Nios.

### 1-- Comptage sur un seul afficheur

J'ai commencé par essayer d'afficher le compteur sur un seul afficheur 7 segment. Pour cela j'ai utilisé un seul PIO pour la gestion de l'afficheur. J'ai créé les connexions sous Platforme Designer et affecter les broches via la datasheet de la carte. J'ai également ajouté un bouton poussoir permettant le reset du système.

Une fois fait, j'ai écrit le programme en langage C qui me permet d'afficher les chiffre sur le 7-segments. Pour ma compréhension personnelle j'ai décidé de faire uniquement en software et de créer une boucle for qui va venir prendre les valeurs dans un tableau (tableau contenant les bits permettant l'allumage ou non du segment).

Le fonctionnement du compteur est correct, bien qu'il ne soit pas optimisé. Cela m'a permis de voir que l'afficheur peut être considéré comme une suite de 8 Leds, chose qui m'était familier grâce au Lab1.

https://user-images.githubusercontent.com/121939768/211831465-e3de6cf1-bbee-4d18-a8e8-36ef06764374.MOV

### 2-- Comptage sur un seul afficheur avec la conversion binary to 7 segments

L'étape suivante est donc l'introduction d'un nouveau composant VHDL permettant de convertir la valeur du compteur en valeur permettant l'affichage sur le 7-segments. Pour cela je choisit de l'implanter sous la forme d'un process qui me permettra de choisir quelle valeur renvoyer en fonction de la valeur reçue. (voir codes)
Cette étape ne fut pas très compliquée car il a suffit d'intégrer le composant dans le design précédent puis d'ajouter un signal permettant de gérer la transcription entre la fonction de conversion et la définition du système. Petite subtilité, les afficheurs sont actif à l'état bas, c'est à dire que si l'on veut allumer un segment, il va falloir lui appliquer un 0 et un 1 si l'on veut l'éteindre ; d'où la présence du "not" (dans bin_to_7seg.vhd) devant le mot binaire correspondant au chiffre à afficher.

![image](https://user-images.githubusercontent.com/121939768/211834409-be854441-e3fa-42b7-b855-48063a7e1ba6.png)

### 3-- Comptage sur 3 afficheurs 7 segments

![image](https://user-images.githubusercontent.com/121939768/211843257-08bda20b-7b61-4c15-bf57-8d075d8cc7dd.png)

Avant dernière étape : compter avec des dizaines et des centaines. Pour cela j'ai décidé d'explorer 2 méthodes pour voir laquelle était la plus intéressante. La première consiste en l'ajout de 2 autres PIO (3 PIO au total). Cela me permettra d'ajuster indépendemment chaque afficheur et de limiter les erreurs d'affichages.

https://user-images.githubusercontent.com/121939768/211840239-b547f3ef-0f88-4709-8103-36bfd2aa84a8.mov

Une fois compris j'ai pus effectuer la manipulation mais cette fois ci avec un seul PIO. Il a donc fallu tripler le nombre de bit du PIO, et le nombre de bits du signal dans le code VHDL. 

![image](https://user-images.githubusercontent.com/121939768/211843631-8f3bdaaf-d0f3-46b4-a9c5-c9553ad88959.png)

Il faut également faire attention, puisque l'on utilise qu'un PIO et un seul signal, à l'emplacement que l'on va réserver au bits d'unité, ceux des dizaines et enfin ceux des centaines. J'ai donc tout de suite vu l'importance d'avoir effectué mon composant permettant la conversion puisqu'un simple appel est nécessaire. (voir codes) Il me suffit alors d'effectuer quelques décallages binaires pour ajuster la valeur à l'emplacement des dizaines et des centaines.

Le fonctionnement est identique au précédent. Ici le piège est donc d'arriver à ne pas mélanger les bits d'unité, de dizaine et de centaine et de les afficher sur le bon segment.

### 4-- Gestion du comptage par timer
Désormais il serait intéressant de gérer le comptage via les interruption déclenchées par timer. L'architecture du système devra donc être la suivante :

![image](https://user-images.githubusercontent.com/121939768/211844068-05c1ffc0-cf0a-456c-ac55-8876ae35a2c9.png)

J'ai alors rajouté un timer sur Platform Designer et ajuster la période pour que celle-ci soit précisemment de 1 seconde.
Ensuite j'ai juste repris les lignes correspondant aux interruptions dans mon Lab1 et adapté aux noms des variables du Timer. Enfin j'ai ajouté une ligne correspondant au démarrage du timer.

https://user-images.githubusercontent.com/121939768/212272467-6f90263b-e119-41fc-a46e-d199be797388.mov


## Conclusion, progress and result

Ma progression pour ce second lab est la suivante :

  - Affichage du compteur sur un seul afficheur
  - Implémentation de la fonction de conversion
  - Affichage d'un compteur sur 3 afficheurs avec 1 ou plusieurs PIO
  - Gestion du compteur par timer

Les pièges à éviter sont donc de voir que l'afficheur est actif à l'état bas, les registres permettant de concaténer les unités, dizaines et centaines, et enfin les interruptions générer par le timer (qui doit être lancé dans un main.c).
Mes résultats ont été présentés tout au long de la partie architecture, mais j'ai réussi à implémenter un compteur sur des afficheurs 7 segments en partant de l'affichage sur un seul puis sur 3 afficheurs me permettant de compter jusqu'à 999. Enfin l'utilisation d'un timer est une vraie optimisation puisqu'avec une interruption le compteur est beaucoup plus précis, et on est sûr d'avoir un compteur avec une période fixe.

En résumé, ce lab m'aura permis de me perfectionner dans le co-design ainsi que de me familiariser avec l'utilisation de timer pour génerer des interruptions.








