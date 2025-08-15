<div align="center">

# Bataille Navale – Jeu en Swift (Terminal)

Un jeu de **bataille navale à deux joueurs**, développé en **Swift** et jouable directement dans le terminal.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">
  <img alt="Creative Commons License" style="border-width:0"
       src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" />
</a><br />
Ce projet est sous licence
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">
  Creative Commons Attribution – NonCommercial – NoDerivatives 4.0 International
</a>.

---

**Décembre 2022**  

</div>

## 📋 Sommaire

- [Présentation](#présentation)
- [Règles du Jeu](#règles-du-jeu)
- [Installation & Lancement](#installation--lancement)
- [Contributeurs](#contributeurs)

---

## 📝 Présentation

Le projet **Bataille Navale** est un jeu à deux joueurs codé en **Swift** et jouable directement dans le terminal.  

👉 Actuellement, le jeu ne permet pas encore de jouer sur deux machines ou terminaux distants.  

L’objectif est simple : **couler la flotte ennemie** en tirant stratégiquement sur ses positions.

---

## ⚔️ Règles du Jeu

- Chaque joueur dispose de **3 océans** : Atlantique, Pacifique et Indien.  
- Ils placent une **île** sur chacun d’eux, occupant **au moins 4 cases consécutives** (ligne ou colonne).  
  - Représentée par `⛰` dans la grille.  

- Ensuite, les joueurs placent **5 bateaux** :
  - Tailles de 1 à 4 cases  
  - Deux bateaux de taille 3  
  - Représentés par `⛴`  

- Les joueurs jouent **à tour de rôle** et effectuent un tir :  

  - **Touché** : la case contient un bateau non encore touché → `✘`  
  - **Coulé** : le tir détruit la dernière partie d’un bateau → `☠`  
  - **En vue** : tir raté, mais un bateau est présent sur la même ligne/colonne non encore touché → `👁`  
  - **À l’eau** : aucun bateau en vue → `▓`  

🎯 La partie est gagnée lorsqu’un joueur coule le **dernier bateau** de son adversaire.

---

## 🚀 Installation & Lancement

1. Installer **Swift** sur votre machine.  
2. Télécharger le dossier **`src`** contenant les fichiers du jeu.  
3. Ouvrir un terminal et compiler le projet :  

   ```bash
   swiftc *.swift
   ```

4. Lancer le jeu avec :  

   ```bash
   ./main
   ```

5. Pour exécuter un scénario de test :  

   ```bash
   ./main < [nomScenario].txt
   ```

---

## 🤝 Contributeurs

- [**Jiayi He**](https://github.com/JiayiHE95)
- [**Ines Amzert**](https://github.com/Inesamzr)  
