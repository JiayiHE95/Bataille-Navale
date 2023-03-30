## Nom du projet
Jeu Bataille navale

## Description et règles
L'objectif de ce projet est de programmer un jeu de bataille navale à deux joueurs.

Les règles sont les suivantes :


— Les joueurs placent une ile sur chacun de leurs 3 Océans (Atlantique, Pacifique et Indien). Une ile occupe aux minimums 4 cases consécutives sur la même ligne ou la même colonne. (réprésentées par "⛰" dans la grille)


— Les joueurs placent ensuite leurs bateaux : 5 bateaux de tailles 1 à 4, dont deux de taille 3 qui, comme les iles, occupe des cases consécutives sur la même ligne ou même colonne d'un océan. (réprésentés par "⛴" dans la grille)


— Les joueurs jouent à tour de rôle.


— Le joueur actif tire sur une position et le programme doit répondre :

— « touché » si la position est occupé par un bateau et qu’il n’a pas été encore touché à cette
position ; (réprésenté par "✘" dans la grille)

— « coulé » si la position est occupé par un bateau et que c’était la dernière position du bateau
non encore touchée ; (réprésenté par "☠" dans la grille)

— « en vue » si la position n’est pas occupée par un bateau ou qu’elle correspond à une position
déjà touchée, et que sur la ligne ou la colonne (ou les deux) se trouve une position non touchée
occupée par un bateau ; (réprésenté par "👁" dans la grille) 

— « à l’eau » dans les autres cas. (réprésenté par "▓" dans la grille)


La partie est gagnée par le joueur actif si à la suite d’un tir, il coule le dernier bateau de la flotte de son
adversaire.


## Installation

Installez swift


Téléchargez le dossier "src" contenant les fichiers du jeu


Ouvrez un terminal, compilez le jeu avec la commande "swiftc *.swift"


Lancez le jeu avec la commande "./main"


Amusez-vous !


## Support

https://moodle.umontpellier.fr/pluginfile.php/1902078/mod_resource/content/4/TP_Projet_Algo_IG3_2022-2023-BatailleNavale.pdf

https://gitlab.polytech.umontpellier.fr/ines.amzert/projet_algo_bataillenavale

## Contacts

jiayi.he@etu.umontpellier.fr

ines.amzert@etu.umontpellier.fr


## Auteurs
-  Jiayi He

-  Ines Amzert

