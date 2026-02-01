
Voici un tutoriel pour la mise en oeuvre et l'utilisation d'un Ramdisk pour forcer Firefox à l'utiliser, afin d'éviter une usure majeure sur un disque SSD en particulier. (Certainement possible avec d'autres naviguateurs) mais ici détaillé que pour FF.
---
* Firefox écrit vraiment beaucoup de fois sur les disques quand il est utilisé.  
* Le but ici n'est pas vraiment d'expliquer comment faire un Ramdisk les explications existent déjà ailleurs, mais le propos ici est de fournir et d'expliquer comment utiliser le script (ici pour Autoi3 v3.3.18), afin d'éviter le problème des blocages du timeout et / où autres ping méthodes pour windows.  
* Le but du script (convertissable en exécutable de surcroît), est de lancer Firefox et faire qu'un profil FF existant et fonctionnel soit copié vers un Ramdisk, via ce script (ici Autoi3 v3.3.18) afin de s'affranchir des contraintes windows .bat ou .vbs (obsolète) et non je n'aime pas ps, ET, pour ne pas être restreint par les fenêtres GUI lancées avec cmd ou ps.  
* Pourquoi choisir de lancer via Autoi3 ? Plusieurs raisons, éviter les modes minimisés ou masqués ou multi-fenêtrés et le blocage des timers cmd par les MicrochioteS windows actuels.  
* Enfin, explication rapide et calcul de gain d'écritures FF vers ram, le calcul du gain est sans appel.  

<br>

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
<br>

![Formule Gain](images/gain-formule.png)  
<br>

✅ Points clés à retenir :
* La **grande majorité des écritures** restent en RAM (C'est aussi plus rapide !)
* Les écritures sur SSD sont **rares et contrôlées**
* Le **risque de collision** n'est pas null 6%~, mais robocopy est plus fiable que xcopy et ne réecrit pas tout dans le script, seulement les changements.
* Donc finalement 100% sûr car si un cas de collision ce produit il est réécrit 5mn plus tard, où bien à la fermeture immédiate de FF (écriture forcée).
* Sur ce point, une sécurité d'autocopie est assuré au moment de la fermeture par exemple si inférieure à <-5mn... (donc toujours sauvegardé )☺️.
* Gain approximatif : **~95 % d’écritures évitées**

### ✅ Donc on réduis **environ 95 % des écritures en particulier sur SSD**
---
#### Le gain est énorme
* **Firefox écrit très fréquemment** en temps réel, ou avec interval de sauvegarde = 15 s → usure SSD accrue, via `browser.sessionstore.interval = 15000`, `browser.sessionstore.interval.idle` 
* Avec RAM disk : toutes ces écritures **restent en RAM**, seules les copies périodiques sont faites et seulement les fichiers modifiées avec l'utilisation du script et robocopy via les paramètres passé à robocopy dans le script. (Voir en bas de page pour les détails robocopy)
* Même avec **sauvegarde périodique toutes les 5 mn**, on écris **beaucoup moins** que Firefox normalement sur dd / ssd.  
En résumé : **le gain de 95 % correspond à l’évitement des écritures fréquentes de sessionstore et prefs**, qui sont la vraie source d’usure SSD quand interval est très court.

---
#### Alors les étapes, vous créez d'abord votre Ramdisk par exemple sur la lettre Y:

Voilà [le Script](FfversRam.au3) où toutes les étapes sont commentés dedans :)  
Les modifications que vous devez appliquer dans le script sont très simples :  
* (1) set RAMDISK=Y:\profileFf        <- A la ligne 7. Il s'agit du nom de dossier qui doit être utilisé/crée pour copier le profile dans le Ramdisk.  
Exemple, à la place de `profileFf` on met `lenomqu'onveut` (il sera créé par le script si pas existant), ou bien on peut laisser tel quel, ou encore créer un .bat qui va créer ce dossier via la gestion des tâches (plus contraignant).  
* (2) set PROFILE_DISK=%APPDATA%\Mozilla\Firefox\Profiles\xxxxxxx.default  <- A la ligne 8.  

Ici à `xxxxxxx.default` doit évidement correspondre au nom de votre profil chez vous.  
(Je n'ai pas cherché si une option existe pour utiliser plusieurs profils en même temps), mais surement possible...ce n'est pas le sujet.  

<br>

Si, vous souhaitez compiler Autoi3 vers un éxécutable les commandes génériques sont :  
`Aut2Exe.exe /in <infile.au3> [/out <outfile.exe>] [/icon <iconfile.ico>] [/comp 0-4] [/ignoredirectives] [/nopack] [/pack] [/ansi] [/unicode] [/x64] [/console] [/gui] [/execlevel <asinvoker | highestavailable | requireadministrator | none>] [/compatibility <vista | win7 | win8>] [/comments <>] [/companyname <>] [/filedescription <>] [/internalname <>] [/legalcopyright <>] [/legaltrademarks <>] [/originalfilename <>] [/productname <>] [/fileversion <fixednum[,num]>] [/productversion <fixednum[,num]>]`  

Moi j'ai fait exemple : `Aut2Exe.exe  /in "C:\Mon chemin vers\monscript.au3" /out "C:\Mon chemin vers\monexe.exe" /nopack /icon "C:\Mon chemin vers\Aut2Exe\Icons\AutoIt_Main_v10_256x256_RGB-A.ico" /execlevel asinvoker  /filedescription "Mon Lanceur Ff"  /internalname "mon lanceur Ff"  /companyname "On metceequ'onveut Corp"  /fileversion 1.2.3 /productversion 1.2.3 /legalcopyright "© 2026 Anonymous, Oncl'Bil"`  

### Voilà c'est tout pour la modification du script.
---
### Enfin le détails et explications des paramètres passés à robocopy :
`/MIR : Copier et synchroniser les dossiers (avec suppression).`  
`/R:0 : Pas de tentative de relecture.`  
`/W:0 : Pas de délai entre les tentatives.`  
`/XD : Exclure certains dossiers (safebrowsing, startupCache).`  <- (non nécéssaires)  
`/XF : Exclure certains fichiers (*.sqlite-wal, *.sqlite-shm).`  <- (non nécéssaires)  

Et un point particulier pour un fichier `cxxxxx.sqlite` qui s'est créé par Ff car il ne doit pas aimer le déplacement de profils, et que pour survire il se fabrique ce fichier.  
Perso, j'ai ajouté dans mon script pour qu'il soit aussi exclus par robocopy et pour ne pas qu'il soit recopié sur le dd /ssd.  
Je ne met pas cette ligne ici, car je peut imaginer que ce nom de fichier non standard ne correspond pas à tout le monde.  

<br>
Crédit : Anonymous, Oncl'Bil
