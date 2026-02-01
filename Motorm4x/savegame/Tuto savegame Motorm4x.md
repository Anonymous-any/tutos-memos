👉 🧾 MÉMO — Procédure exacte, pour réparer une ancienne sauvegarde Motorm4x (carrière) qui crash au lancement...
Où, si votre savegame à été altéré / modifiée par vous, comme par exemple sur les conseils de différents tutos pour 'tricher' l'argent ou d'autres raisons, import de savegame d'autres joueurs internet...
---

<br>

Procédure exacte à suivre
### 1️⃣ Modifier / editer votre `PLAYER.XML`
* Supprimer **le contenu** des balises vidéo
* **Conserver la balise vide**, comme ceci :
```xml
<options_category>
</options_category>
```
---
### 2️⃣ Préparer les fichiers
* **Supprimer `PLAYER.HSX`**
  (inutile de le sauvegarder, il est recréé automatiquement, il est la cause du crash...) de l'état persisté via HSX et il doit être syncronisé avec `PLAYER.XML` donc si on le supprime, alors le jeu se lance...  
Sinon ça ne peut fonctionner qu'en lecture seule comme les (tutos qui vont avec :grimacing:), et donc votre savegame ne peut plus progresser, ou être mise a jour sans perdre son contenu (réinitialisation de la sauvegarde).
* Mettre `PLAYER.XML` en **lecture seule**, taille approximativement 30Ko [déblocage complet](Motorm4x.rar).
---
### 3️⃣ Les prochaines étapes, lancer le jeu
* Lancer le jeu
* Se positionner **obligatoirement sur carrière**, faire un ALT+TAB puis
* **Supprimer `PLAYER.HSX`** à nouveau, et **enlever cette fois la lecture seule de `PLAYER.XML` AVANT :grey_exclamation: de charger la carrière**,
ALT+TAB encore puis **charger la carrière.**  
* (ne pas lancer partie rapide ou autre mode)
* Quand la carrière est chargée vous pouvez aussi faire une petite modif comme par exemple acheter du carburant,
mais normalement c'est déjà suffisant pour ajourner la syncronisation `.xml, .hsx` -> 4 octets.

👉 À ce moment :
* la progression est conservée
* le moteur à rajouté au .XML votre CG (si la save provient d'ailleurs, render, résolution) etc...
* enfin un nouveau `.HSX` cohérent syncronisé est généré. :boom:
---

### 4️⃣ Finaliser
* Quitter le jeu normalement

⚠️ Point important : Si la lecture seule est laissée après ce stade, le moteur ne pourra pas finaliser correctement l’état.

---

### 5️⃣ Reconfiguration
* Relancer le jeu qui doit maintenant fonctionner avec la nouvelle savegame ajournée, et sans devoir forcer la lecture seule :grey_exclamation:  
* Aller ensuite dans vos paramètres :  
* réglages vidéo  
* Reconfigurer normalement à votre sauce,  
* Quitter / relancer pour validation  
---

## Résultat
* Plus de crash 👍
* Sauvegarde carrière fonctionnelle et débloquée :grey_exclamation:
* Réglages contrôles conservés
* Vidéo / audio fonctionnels 👍

👉 Au préalable, vous pouvez aussi modifier votre "money" .xml selon votre choix afin de ne pas devoir recommencer la procédure juste pour ça. :innocent:  

---
### :point_up: EXPLICATION TECHNIQUE  
* Les réglages vidéo du `XML` **ne décrivent pas complètement** l’état graphique.  
* Le moteur utilise un **état interne dérivé**, partiellement persisté via `HSX`.  
* Avec une ancienne sauvegarde :  
  * cet état interne devient incompatible si du matériel à changé (renderer, résolution, GPU), OÙ :warning: si vous avez modifié votre `.xml` manuellement...(corruption).  
* Si les lignes vidéo existent :  
  * le moteur ne tente pas...(extrapolation) de **mettre à jour** les modifications vidéos résultat, un état invalide → crash.
* Si les lignes vidéo sont **vides** :  
  * le moteur est forcé de **reconstruire l’état graphique depuis zéro**.  
* `HSX` :
  * fait toujours 4 octets
  * change à chaque écriture
  * sert de **marqueur de cohérence interne**, pas de checksum bloquant.

## 🧩 Conclusion
* Problème est corrigé avec cette procédure.
* Le `.HSX` est vraiment à jour, et permet alors de lancer la savegame sans être obligé de laisser la lecture seule du `.xml`.
* Corrige là **désynchronisation persistante** entre les 2 fichiers `.xml <-> .hsx`.
* La seule solution est une **reconstruction contrôlée** du sous-système vidéo.

---
### Alternative,

Une autre solution "triche" (sans progression savegame stock), est d'utiliser [MotorM4X.CT sur un github](https://github.com/grasmanek94/cheat-tables) (merci à l'auteur).  
On créez la save neuve sans progression on charge la table dans CheatEngine, on débloque toutes les lignes des véhicules à
`(0 - locked, 1 - available, 2 - purchased)` de tous les véhicules sur la colonne `valeurs 2`.  
On peut ensuite cheat l'argent en vendant le / les véhicules que l'on veut dans le jeu et le compte money va grossir. :moneybag:  
On peut répéter l'opération par exemple avec `Car11Ptr` qui est vendu le plus cher 60k puis remettre `valeur 2` dans CE, puis revendre encore ingame `status 1` puis remettre 2 puis renvendre etc :face_with_peeking_eye: :relaxed:  
Mais ce cas là ne débloquera jamais une save avec progression dans le jeu évidement.  
C'est juste une alternative pour ceux qui ne parviennent pas à faire la procédure qui est décrite plus haut, mais pourront progresser plus facilement (avec regrets éventuels) d'avoir suivi des tutos de merde qui "peuvent" faire perdre une savegame fonctionnelle.  

---
Ce mémo est maintenant **concis et réutilisable tel quel**.  
Vous pouvez le garder à côté de votre sauvegarde 👍

<br>

Crédit : Anonymous, Oncl'Bil
