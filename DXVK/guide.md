Voici un tutoriel pour la mise en oeuvre de l'utilisation de DXVK pour windows.  

---
Il présente une marche à suivre pas à pas pour l'utiliser en prenant comme exemple la série des Farming simulators afin de créer le système de rendu via DXVK <-> VULKAN qu'il ne peuvent pas faire par défaut.  
La listes des jeux n'est pas limité mais pourra ne pas fonctionner, ça va dépendre des titres utilisés où de conflits de mods qui peuvent exister.

Le tutoriel sera basé sur Fs15 / 17 / 19 / 22, mais pourra être similaire pour d'autres jeux qui peuvent être pris en charge (vous l'avez compris).  

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
Pour FS22/FS19/FS17 (DX11) (et DX9 pour ****FS15 voir détail important***), vous aurez besoin des deux DLL à placer a côté du .exe principal `x64/FarmingSimulator20XXGame.exe` :
-    d3d11.dll
-    dxgi.dll
-    et dxvk.conf  <- optionnel

Explication, ces DLL vont intercepter les appels DX11 et les traduire en Vulkan.  

---
3️⃣ Copier les DLL dans le dossier du jeu, (l'exemple de la version ci-dessous est un TRÈS mauvais exemple) via <ins>**Epic...(mais il fallait en parler).**</ins>
- [EpicStoreManager] Auth: login failed - error code: 2147483647 car il ne se connecte plus à " l'authentification EPIC " depuis plus de 1 mois au 12/2025 [comme ici](https://forum.giants-software.com/viewtopic.php?t=216475) ou [ici](https://www.reddit.com/r/farmingsimulator/comments/1pv46yb/why_is_fs22_doing_this/?tl=fr), vraisemblablement les <ins>**supports n'en ont cure...**</ins>  
Donc vous pourriez avoir envie/vouloir fuire Epic, ailleurs sa semble fonctionner !  
Ok alors ouvrez votre dossier de jeu, par exemple :
Epic Games\FarmingSimulator22\x64\
Et copier `d3d11.dll`, `dxgi.dll` dans ce dossier (même endroit que FarmingSimulator2022Game.exe)  
:warning:Important : ne pas toucher aux DLL originales du jeu, DXVK crée son propre wrapper.
---	
4️⃣ Modifier le <ins>game.xml (faire une copie)</ins>, dans My Games\Mes documents\FarmingSimulatorXX, car nécéssaire au moins pour Fs22 / Fs15.  
Il doit être sur `D3D_11` pour Fs22.  
À savoir que (par défaut), VULKAN est sencé être pris en charge par Fs22 mais ne fonctionne 
pas comme beaucoup de choses chez Giant !... (mensonge commercial).  
Il crash, il est donc nécéssaire de faire cette modification pour une 2è raison, c'est que dxvk ne peut pas "encore" fonctionner pour intercepter les dll dx12.  
Donc mettre comme ceci :  
*        <renderer>D3D_11</renderer>		<- FS17/FS19/FS22  
Et une particularité pour FS15
*        <renderer>D3D_90</renderer>		<- FS15 (*détail important*), supporte dx9 (donc utiliser d3d9.dll)
Il existe donc d'autre rendus possible qu'OGL par défaut pour FS15.  
Cette ligne est (non présente par défaut) mais prise en charge, à ajouter sous la balise `</scalability>`
		
Explications, dxvk n'est pas suporté par Dx12 donc ont ne peut pas laisser `D3D_12` pour Fs22 (et ultérieures) ils crashent aussi.  
D'autant que les Devices Dx12 ne sont pas crée par GE ce sont donc des menteurs (encore !).  
C'est juste du faux dx12 qui repose sur du 11 ! Go vérifier si vous voulez la véritée.  
  
Alors, le HUD permet de voir si Vulkan est bien utilisé, FPS, GPU, etc, mais aussi via les logs qui seront crées et placés 
dans la racine du jeu, si vous n'avez pas mis le HUD ou encore si, le HUD veut pas fonctionner chez vous.  
-    Créer un fichier [dxvk.conf](DXVK/dxvk.conf) dans le même dossier que le jeu /x64/FarmingSimulator20XXGame.exe, voir [fichier joint](DXVK/dxvk.conf).
-    Alternativement, vous pouvez définir la variable d’environnement windows au lieu du fichier, exemples :
- `DXVK_HUD valeur : full , ou encore nom de variable : DXVK_HUD valeur : fps,frametimes,gpuload,scale=0.7`  
mais le fichier dxvk.conf est plus simple pour Windows, il permet donc de préciser pour chaque jeux.

Pour éviter d'éventuels "petits souchis", ou si vous voulez revenir en arrière plus tard (ce dont je doute :p), backer votre dossier :  
`My Games\Mes documents\FarmingSimulatorXX\shader_cache` car chaque système de rendu OGL, DX, crée ses propres shaders (entre autres...).  
Ce qui se passe avec dxvk s'est qu'il contourne dx11 et donc créer ses propres shaders les (vulkain), sont plus petit et plus efficaces :broom:.  
Les votres ne seront donc plus utilisé à moins que vous ne fassiez machine arrière, les conserver vous évitera que le jeu ne les recrée,
vous évitant ainsi d'éventuels nouveau lags, suttering...s'ils vous resservent.

---
5️⃣ Après, vous lancez votre jeu
    FS22 (ou FS19/FS17/FS15) normalement vous devriez voir le HUD en haut à gauche :
-   “Vulkan” → confirme que DXVK est actif, FPS, VRAM utilisée, etc.
-   Si votre HUD n'est pas présent vous pouvez vérifier votre racine du jeu, il aura crée des logs :
   
`*_d3d11.log`  
`*_dxgi.log`  
Ceci confirme aussi qu'il est fonctionnel.

---
6️⃣ Points importants à savoir :bulb:  

Pas garanti stable à 100% : Pour les autres titres, crash possibles selon les mods (ex GTAV il faut choisir), ou certaines cartes GPU.  
DXVK ne change pas les fichiers du jeu, juste le rendu en vous évitant d'être "forcé" d'utiliser un rendu propriétaire, où non ajourné pour FS
**(Meilleur traitement de rendu.)**  
Si le jeu crash, (vous avez mal fait le tuto) → supprimer les DLL DXVK vous reviendrez à DX11 natif, rechanger votre game.xml ex :`D3D_12` comme avant et les shader_cache si vous avez backé.
	
Crédit : Anonymous, Oncl'Bil

(images à ajouter)...
