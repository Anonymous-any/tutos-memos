
Voici un tutoriel pour la mise en oeuvre et l'utilisation d'un Ramdisk pour forcer Firefox à l'utiliser pour éviter l'usure majeure sur un disque SSD en particulier. (Certainement possible avec d'autres naviguateurs) mais ici détaillé que pour FF.
---
* Firefox écrit vraiment beaucoup de fois sur les disques quand il est utilisé.
* Le but ici n'est pas vraiment d'expliquer comment faire un Ramdisk les explications existent déjà ailleurs, mais le propos ici contient un script (avec toutes les explications de ce qu'il fait), et 2 lignes de racccourcis pour windows (au choix).
* Afin de lancer le script pour faire qu'un profile FF soit copié vers un Ramdisk, en mode `CMD` minimisé, ou encore invisible (un .VBS non-testé) ! pour lancer Firefox.
L'explication/conséquence est que windows restreint les fenêtres GUI lancé par cmd ou ps.
* Pourquoi choisir de lancer en mode minimisé ou masqué ? c'est simplement pour éviter toutes fermeture non désiré intentionellement.
* Enfin, explication rapide et calcul de gain d'écritures FF vers ram, le calcul du gain est sans appel (IA).


Voici un petit **schéma visuel simple** qui montre l’impact du RAM disk sur les écritures Firefox :
```
Avant RAM disk (profil normal) :
╔══════════════════════════════╗
║ Interval normal : 15s    	   ║  → Écritures fréquentes sur SSD
║ Interval idle : 1h       	   ║  → Écritures supplémentaires sur SSD
╚══════════════════════════════╝
≈ 250 écritures/heure
Après RAM disk + script 5 min :
╔═════════════════════════════════╗
║ Interval normal : 15s    	      ║  → Écritures en RAM uniquement
║ Interval idle : 5min    	      ║  → Synchronisé avec script RAM disk
║ Sauvegarde script : toutes 5min ║  → SSD seulement ici
╚═════════════════════════════════╝
≈ 13 écritures/heure
```
### Calcul du gain approximatif
![Formule Gain](images/gain-formule.png)

✅ Points clés à retenir :
* La **grande majorité des écritures** restent en RAM (C'est aussi plus rapide !)
* Les écritures sur SSD sont **rares et contrôlées**
* Le **risque de collision** n'est pas null 6%~, mais robocopy est plus fiable que xcopy et ne réecrit pas tout seulement les changements.
* donc 100% sùr car si un cas de collision ce produit il est réécrit 5mn plus tard, où bien à la fermeture immédiate de FF (écriture forcée).
* Gain approximatif : **~95 % d’écritures évitées**
* Une sécurité d'autocopie est assuré au moment de la fermeture par exemple si inférieure à <-5mn...

✅ Donc on réduis **environ 95 % des écritures en particulier sur SSD**
---
### Le gain est énorme
* **Firefox écrit très fréquemment** avec interval = 15 s → usure SSD accrue
* Avec RAM disk : toutes ces écritures **restent en RAM**, seules les copies périodiques sont faites et seulement les fichiers modifiées avec l'utilisation du script et robocopy via les paramètres passé à robocopy dans le script. (Voir en bas de page pour les détails robocopy)
* Même avec **sauvegarde périodique toutes les 5 mn**, tu écris **beaucoup moins** que Firefox normalement
En résumé : **le gain de 95 % correspond à l’évitement des écritures fréquentes de sessionstore et prefs**, qui sont la vraie source d’usure SSD quand interval est très court.
---
### Alors vous créez d'abord votre Ramdisk par exemple sur la lettre Y:

## Voilà [le Script](FfversRam.bat) où toutes les étapes sont commentés dedans :)
## Les modifications que vous devez appliquer dans le script sont très simple :
* set RAMDISK=Y:\profileFf        <- A la ligne 7. Il s'agît du nom de dossier qui doit être utilisé/crée. `profileFf`

Exemple, tu met `lenomquetuveut` (il sera crée par le script si pas existant).
* set PROFILE_DISK=%APPDATA%\Mozilla\Firefox\Profiles\xxxxxxx.default  <- A la ligne 8.

Ici à `xxxxxxx.default` doit évidement correspondre au nom du profil chez vous.
(Je n'ai pas cherché l'option pour utiliser plusieurs profils en même temps), mais surement possible...ce n'est pas le sujet.

### Voilà c'est tout pour la modification du script.
---
### Maintenant reste le choix des raccourcis moi j'ai utilisé :
pour cmd  (alternative mais minimisée).
```
cmd.exe /c start "" /min "C:\Program Files\Mozilla Firefox\FfversRam.bat"
```
Enfin l'autre raccourcis fait pour lancer ce .vbs qui lance Le Script qui lance FF. `o-°`

`wscript.exe" "C:\chemin\FfversRam.vbs"`		<- nécéssaire d'activer VBScript ! (ne devrait plus afficher de fenetre cmd ouverte ou minimisée).
Utiliser VBScript (failles de sécurités)...donc non testé
Créer ce fichier .vbs avec le code ci-dessous ou télécharger [ici le .vbs](FfversRam.vbs) :
```
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run """C:\Program Files\Mozilla Firefox\FfversRam.bat""", 0, False
```
---
### Détails des paramètres passés à robocopy :
`/MIR : Copier et synchroniser les dossiers (avec suppression).`

`/R:0 : Pas de tentative de relecture.`

`/W:0 : Pas de délai entre les tentatives.`

`/XD : Exclure certains dossiers (safebrowsing, startupCache).`  <- (non nécéssaires)

`/XF : Exclure certains fichiers (*.sqlite-wal, *.sqlite-shm).`  <- (non nécéssaires)

