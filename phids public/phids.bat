@echo off
title PHIDS - Gestion HTML & Sécurité
chcp 65001 >nul

set "projetPath=RENPLACER PAR VOTRE CHEMIN D'ACCES AU FICHIER"

REM Vérifier si le dossier existe
echo Vérification du dossier: %projetPath%
if not exist "%projetPath%" (
    echo Le dossier %projetPath% n'existe pas !
    pause
    exit
)

:menu_principal
cls
echo.
echo.
echo [91m██████╗ ██╗  ██╗██╗██████╗ ███████╗
echo ██╔══██╗██║  ██║██║██╔══██╗██╔════╝
echo ██████╔╝███████║██║██║  ██║███████╗
echo ██╔═══╝ ██╔══██║██║██║  ██║╚════██║
echo ██║     ██║  ██║██║██████╔╝███████║
echo ╚═╝     ╚═╝  ╚═╝╚═╝╚═════╝ ╚══════╝
echo [0m
echo.

echo 1 - Créer un raccourci HTML
echo 2 - Utiliser le raccourci et gérer les IPs
echo 3 - Quitter
echo.
set /p choix="Choisissez une option (1/2/3) : "

if "%choix%"=="1" goto creer_raccourci
if "%choix%"=="2" goto utiliser_raccourci
if "%choix%"=="3" exit

echo Option invalide.
pause
goto menu_principal

:creer_raccourci
cls
echo Création du fichier HTML...

REM Vérifier si le fichier existe déjà
set "fichier=%projetPath%\phids_page.html"
echo Chemin du fichier : %fichier%

if exist "%fichier%" (
    echo Le fichier HTML existe déjà à : %fichier%
    pause
    goto menu_principal
)

REM Création du fichier HTML
echo Tentative de création du fichier HTML...
echo ^<html^> > "%fichier%"
echo ^<head^> >> "%fichier%"
echo     ^<title^>PHIDS Page^</title^> >> "%fichier%"
echo ^</head^> >> "%fichier%"
echo ^<body^> >> "%fichier%"
echo     ^<h1^>Bienvenue sur la page PHIDS^</h1^> >> "%fichier%"
echo     ^<p^>Liste des IPs autorisées :^</p^> >> "%fichier%"
echo     ^<ul id="ipList"^>^</ul^> >> "%fichier%"
echo     ^<script^> >> "%fichier%"
echo         function ajouterIP(ip) { >> "%fichier%"
echo             var ul = document.getElementById('ipList'); >> "%fichier%"
echo             var li = document.createElement('li'); >> "%fichier%"
echo             li.textContent = ip; >> "%fichier%"
echo             ul.appendChild(li); >> "%fichier%"
echo         } >> "%fichier%"
echo     ^</script^> >> "%fichier%"
echo ^</body^> >> "%fichier%"
echo ^</html^> >> "%fichier%"

REM Vérifier si le fichier a bien été créé
if exist "%fichier%" (
    echo Le fichier HTML a bien été créé à : %fichier%
) else (
    echo ERREUR: Le fichier n'a pas été créé !
)

pause
goto menu_principal

:utiliser_raccourci
cls
if not exist "%projetPath%\phids_page.html" (
    echo Le fichier phids_page.html n'existe pas dans "%projetPath%" !
    pause
    goto menu_principal
)

echo Le fichier existe. Tentative d'ouverture de la page HTML...
start "" "%projetPath%\phids_page.html"
echo Page HTML ouverte.
echo.

:menu_ips
echo Gestion des IPs
echo 1 - Ajouter une IP
echo 2 - Afficher les IPs actuelles dans le terminal
echo 3 - Retirer toutes les IPs
echo 4 - Retour au menu principal
set /p choixIP="Choisissez une option (1/2/3/4) : "

if "%choixIP%"=="1" goto ajouter_ip
if "%choixIP%"=="2" goto afficher_ips
if "%choixIP%"=="3" goto retirer_ips
if "%choixIP%"=="4" goto menu_principal

echo Option invalide.
pause
goto menu_ips

:ajouter_ip
set /p newIP="Entrez l'adresse IP à ajouter : "

REM Ajouter l'IP au fichier HTML
(
echo     ajouterIP("%newIP%");
) >> "%projetPath%\phids_page.html"

REM Afficher l'IP dans le terminal
echo IP %newIP% ajoutée à la page et affichée dans le terminal.
pause
goto menu_ips

:afficher_ips
echo Liste des IPs actuellement dans phids_page.html :
findstr "ajouterIP" "%projetPath%\phids_page.html"
pause
goto menu_ips

:retirer_ips
echo Suppression de toutes les IPs...
powershell -command "(Get-Content '%projetPath%\phids_page.html') | Where-Object {$_ -notmatch 'ajouterIP'} | Set-Content '%projetPath%\phids_page.html'"
echo Toutes les IPs ont été retirées.
pause
goto menu_ips

