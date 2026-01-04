👉 🧾 MÉMO FINAL — Procédure exacte, pour réparer une ancienne sauvegarde Motorm4x (carrière) qui crash au lancement...  

---
## ✅ Procédure exacte à suivre
### 1️⃣ Modifier `PLAYER.XML`
* Supprimer **le contenu** des balises vidéo
* **Conserver la balise vide**, par exemple :
```xml
<options_category>
</options_category>
```
---
### 2️⃣ Préparer les fichiers
* **Supprimer `PLAYER.HSX`**
  (inutile de le sauvegarder, il est recréé automatiquement, il est la cause du crash...) état persisté via HSX.
* Mettre `PLAYER.XML` en **lecture seule**
---
### 3️⃣ Lancer le jeu
* Lancer le jeu
* Se positionner **obligatoirement sur carrière**, faire un ALT+TAB puis
* **Supprimer `PLAYER.HSX`** à nouveau, et **Enlever la lecture seule du XML AVANT de charger la carrière**
ALT+TAB encore puis, **Charger la carrière.**
  * (ne pas lancer partie rapide ou autre mode)
* Quand la carrière est chargée vous pouvez aussi faire une petite modif comme par exemple acheter du carburant,
mais normalement c'est déjà suffisant pour ajourner la syncronisation .xml, .hsx -> 4 octets.

👉 À ce moment :
* la progression est conservée
* le moteur a rajouté au .XML CG, render, résolution etc...
* enfin un nouveau .HSX cohérent est généré
---

### 4️⃣ Finaliser
* Quitter le jeu normalement
⚠️ Point important :
Si la lecture seule est laissée après ce stade, le moteur ne pourra pas finaliser correctement l’état.
---

### 5️⃣ Reconfiguration
* Relancer le jeu qui doit maintenant fonctionner avec l'ancienne savegame ajournée !
* Aller dans paramètres :
  * réglages vidéo
  * réglages audio
* Reconfigurer normalement
* Quitter / relancer pour validation 
---

## ✅ Résultat
* Plus de crash
* Sauvegarde carrière intacte
* Contrôles conservés
* Vidéo / audio fonctionnels

👉 Au préalable, vous pouvez aussi modifier votre "money" .xml selon votre choix afin de ne pas devoir recommencer la 
procédure juste pour ça. 👍

---

### 🧠 EXPLICATION TECHNIQUE
* Les réglages vidéo du XML **ne décrivent pas complètement** l’état graphique.
* Le moteur utilise un **état interne dérivé**, partiellement persisté via HSX.
* Avec une ancienne sauvegarde :
  * cet état interne devient incompatible si du matériel à changé (renderer, résolution, GPU), OÙ :warning: si vous avez modifié votre .xml manuellement...(corruption).
* Si les lignes vidéo existent :
  * le moteur ne tente pas...(extrapolation) de **mettre à jour** les modifications vidéos résultat, un état invalide → crash.
* Si les lignes vidéo sont **vides** :
  * le moteur est forcé de **reconstruire l’état graphique depuis zéro**.
* HSX :
  * fait toujours 4 octets
  * change à chaque écriture
  * sert de **marqueur de cohérence interne**, pas de checksum bloquant.

## 🧩 Conclusion
* Le problème est corrigé avec cette procédure.
* Le .HSX est vraiment à jour, et permet alors de lancer la savegame sans être obligé de laisser la lecture seule du .xml.
* Corrige là **désynchronisation persistante** entre les 2 fichiers .xml <-> .hsx.
* La seule solution est une **reconstruction contrôlée** du sous-système vidéo.

---
### Alternative,

Une autre solution cheat (sans progression savegame stock), est d'utiliser [MotorM4X.CT sur un github](https://github.com/grasmanek94/cheat-tables) (merci à l'auteur).  
Tu crée ta save neuve sans progression tu charges la table dans CheatEngine, et tu débloque toutes les lignes des véhicules à
`(0 - locked, 1 - available, 2 - purchased)` de tous les véhicules sur la colonne `valeurs 2`.  
Tu peut ensuite cheat ton argent en vendant le/les véhicules que tu veut dans le jeu et ton compte money va grossir.  
Tu peut répéter l'opération par exemple avec Car11Ptr qui est vendu le plus cher 60k puis remettre valeur 2 dans CE,
puis revendre encore ingame (status 1) puis remettre 2 puis renvendre etc :face_with_peeking_eye: :relaxed:
Mais tout ceci ne débloquera jamais une progression dans le jeu.  
C'est juste une alternative pour ceux qui ne parviennent pas à faire l'autre procédure qui est décrite plus haut.  

---
Ce mémo est maintenant **concis et réutilisable tel quel**.  
Tu peux le garder à côté de ta sauvegarde 👍

Crédit : Anonymous, Oncl'Bil
