👉 🧾 MÉMO FINAL — Voici un tutoriel pour la mise en oeuvre de l'utilisation de DXVK pour windows.  
(DXVK est un système de rendu alternatif vulkan), Dx vers → vulkan.  

---
Il présente une marche à suivre pas à pas pour l'utiliser en prenant comme exemple la "série des Farming simulators" afin de créer le système de rendu via DXVK <-> VULKAN qu'il ne peuvent pas faire par défaut.  
La listes des jeux pris en charge n'est pas limité mais pourra ne pas fonctionner, ça va dépendre des titres utilisés où de conflits de mods qui peuvent exister.

Le tutoriel est basé sur Fs15 / 17 / 19 / 22, et pour des cartes graphiques Nvidia (c'est mon choix).  

:warning:Par ailleurs si vous n'avez pas dans votre système `c:\Windows\System32\vulkan-1.dll` et `c:\Windows\SysWOW64\vulkan-1.dll` il est préférable d'installer [Runtime - Runtime Installer](https://vulkan.lunarg.com/sdk/home) car c'est nécéssaire pour vulkan bien sûr.  

Explication : Par défaut les pilotes nvidia sont censés les installer, mais comme je trifouille pas mal, j'ai eu modifications qui m'ont montré que je ne les avaient pas. J'ai donc dû installer juste ce Runtime et il fait parfaitement le boulot :innocent:  
Pour les autres possesseurs n'ayant pas de carte ATI/AMD, je ne pourrait donc pas vous indiquer les dépendances vulkan pour elles mais sa doit surement exister, [peut être quelque chose comme ici 'pour linux'](https://github.com/GPUOpen-Drivers/AMDVLK), à vous de tester je ne pourrais jamais faire ces tests...

---
Marche à suivre pour FS22 ou même FS19/FS17/****FS15 (voir détail important)***, y compris l’overlay HUD pour Vulkan.

1️⃣ Récupérer DXVK
    Sur le site officiel : [DXVK Releases GitHub](https://github.com/doitsujin/dxvk/releases)  
Télécharger la dernière version stable (dxvk-x.x.x.tar.gz)  
Évidement, les versions 32/64 sont à adapter en conséquence...  
Donc vérifier avec le `gestionnaire de taches` le processus concerné x86-x64, ou avec d'autres outils tels que `SystemInformer`.
-    Décompresser le fichier où vous voulez (ex. dans Bureau\dxvk)
---
2️⃣ Identifier les DLL à copier
Pour FS22/FS19/FS17 (DX11) (et DX9 pour ****FS15 voir détail important***), vous aurez besoin des deux DLL à placer à côté de l'exe principal dans l'installation du jeu `x64/FarmingSimulator20XXGame.exe` :
-    d3d11.dll
-    dxgi.dll
-    et dxvk.conf  <- optionnel

Explication, ces DLL vont intercepter les appels DX11 et les traduire en Vulkan.  

---
3️⃣ Copier les DLL dans le dossier du jeu, (l'exemple de la version ci-dessous est un TRÈS mauvais exemple) via <ins>**Epic...(mais il fallait en parler).**</ins>
- [EpicStoreManager] Auth: login failed - error code: 2147483647 car il ne se connecte plus à " l'authentification EPIC " depuis plus de 1 mois au 12/2025 [comme ici](https://forum.giants-software.com/viewtopic.php?t=216475) ou [ici](https://www.reddit.com/r/farmingsimulator/comments/1pv46yb/why_is_fs22_doing_this/?tl=fr), vraisemblablement les <ins>**supports n'en ont cure...Ils puent.**</ins>  
Donc vous pourriez avoir envie/vouloir fuire Epic, ailleurs sa semble fonctionner !  
Ok, alors ouvrez votre dossier de jeu, par exemple :
`Epic Games\FarmingSimulator22\x64\` et copier `d3d11.dll`, `dxgi.dll` dans ce dossier (au même endroit que FarmingSimulator2022Game.exe)  
:warning:Important : ne pas toucher aux DLL originales du jeu, DXVK crée son propre wrapper.
---	
4️⃣ Modifier le <ins>game.xml (faire une copie)</ins>, situé dans `Mes documents\My Games\FarmingSimulator20XX`, car nécéssaire au moins pour Fs22 / Fs15.  
Il doit être sur `D3D_11` pour Fs22.  
À savoir que (par défaut), VULKAN est censé être pris en charge par Fs22 mais ne fonctionne 
pas comme beaucoup de choses chez Giant !... (mensonge commercial).  
Il crash, il est donc nécéssaire de faire cette modification pour une 2è raison, c'est que dxvk ne peut pas "encore" fonctionner pour intercepter les dll dx12.  
Donc mettre comme ceci :  
*        <renderer>D3D_11</renderer>		<!-- FS17/FS19/FS22 -->  
Et deux particularité pour FS15
*       <vsync adaptive="false">true</vsync>
        <!-- adaptive="true">true crée un écran noir avec dxvk en mode fenêtre -->
        <!-- adaptive="false">true pour éviter écran noir avec dxvk en mode fenêtre -->
        <renderer>D3D_90</renderer>		<!--  FS15 (*détail important*), supporte dx9 (donc utiliser d3d9.dll) -->  
Il existe donc d'autre rendus possible qu'OGL par défaut pour FS15. On aurait jamais pu imaginer Vulkan pour Fs15 en ce temps là :smiley:.  
Cette ligne `<renderer` est (non présente par défaut) mais prise en charge, à ajouter donc sous la balise `</scalability>`
		
Explications, dxvk n'est pas suporté par Dx12 donc ont ne peut pas laisser `D3D_12` pour Fs22 (et ultérieures) ils crashent aussi.  
D'autant que les Devices Dx12 ne sont pas crée par GE ce sont donc des menteurs (encore !).  
C'est juste du faux dx12 qui repose sur du 11 ! Go vérifier si vous voulez la véritée.  
  
Alors, le HUD permet de voir si Vulkan est bien utilisé, FPS, GPU, etc, mais aussi via les logs qui seront crées et placés 
dans la racine du jeu, même si vous n'avez pas mis le HUD ou encore si, le HUD veut pas fonctionner chez vous.  
-    Créer un fichier [dxvk.conf](dxvk.conf) dans le même dossier que le jeu /x64/FarmingSimulator20XXGame.exe, voir [fichier joint](dxvk.conf).
-    Alternativement, vous pouvez définir la variable d’environnement windows au lieu du fichier, exemples :
- `DXVK_HUD valeur : full , ou encore nom de variable : DXVK_HUD valeur : fps,frametimes,gpuload,scale=0.7`  
mais le fichier dxvk.conf est plus simple pour Windows, il permet donc de préciser pour chaque jeux.

Pour éviter d'éventuels "petits souchis", ou si vous voulez revenir en arrière plus tard (ce dont je doute :expressionless: c'est votre choix), backer votre dossier :  
`My Games\Mes documents\FarmingSimulatorXX\shader_cache` car chaque système de rendu OGL, DX, crée ses propres shaders (entre autres...).  
Ce qui se passe avec dxvk s'est qu'il contourne dx11 et donc crée ses propres shaders les (vulkain), sont plus petit et plus efficaces :broom:.  
Les votres ne seront donc plus utilisés à moins que vous ne fassiez machine arrière, les conserver vous évitera que le jeu ne les recrée
vous évitant ainsi d'éventuels nouveau lags, suttering...s'ils vous resservent.

---
5️⃣ Après, vous lancez votre jeu
    FS22 (ou FS19/FS17/FS15) normalement vous devriez voir le HUD en haut à gauche :
-   “Vulkan” → confirme que DXVK est actif, FPS, VRAM utilisée, etc.
-   Si votre HUD n'est pas présent vous pouvez vérifier votre racine du jeu, il aura crée des logs :
   
`*_d3d11.log`  
`*_dxgi.log`  
Ceci confirme aussi qu'il est fonctionnel, (ou s'ils contiennent des erreurs comme par exemple un `NOT FOUND`), la vulkan.dll ce à quoi j'ai fait allusion au début pour mon cas.

---
6️⃣ Points importants à savoir :bulb:  

Pas garanti stable à 100% : Pour les autres titres, crash possibles selon les mods (ex GTAV il faut choisir entre mods ou rendu), où encore certains GPU.  
DXVK ne change pas les fichiers du jeu, juste le rendu en vous évitant d'être "forcé" d'utiliser un rendu propriétaire, où non ajourné pour FS
**(Meilleur traitement de rendu.)**  
Si le jeu crash, (vous avez mal fait le tuto) → supprimer les DLL DXVK vous reviendrez à DX11 natif, bakez votre game.xml exemple :`D3D_12` (si vous l'aviez modifié) pour le remettre comme avant et les shader_cache si vous aviez backé.  

**Le résultat ci-dessous :**
Avec DVXK HUD Fs19 | Sans DXVK Dx11 Fs19
--- | ---
![](https://github.com/Anonymous-any/tutos-memos/blob/branche-temp/Firefox/images/1.jpg) | ![](https://github.com/Anonymous-any/tutos-memos/blob/branche-temp/Firefox/images/2.jpg)  

Crédit : Anonymous, Oncl'Bil
