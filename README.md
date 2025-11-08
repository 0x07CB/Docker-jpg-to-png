# Docker-jpg-to-png

Convertisseur simple et reproductible pour transformer toutes les images `.jpg` d’un dossier en `.png`, encapsulé dans un conteneur Docker (ImageMagick à l’intérieur).

## 🚀 TL;DR
- Prérequis: Docker installé et fonctionnel
- Conversion rapide dans le dossier courant:
```bash
# Sans installation (depuis ce repo)
docker build -t jpg2png .
docker run --rm -v "$PWD":/data jpg2png
```
- Avec alias pratique (installation locale):
```bash
cd install-scripts
chmod +x install_jpg2png.sh
./install_jpg2png.sh
# Puis, dans n'importe quel dossier contenant des .jpg
jpg2png
```

## Pourquoi Docker ?
- Zéro dépendance système: pas besoin d’installer ImageMagick localement
- Reproductible: même version, mêmes résultats
- Jetable: pas de "pollution" de votre machine

## Prérequis
- Docker installé et actif (Linux, macOS, Windows/WSL)
- Droits d’écriture dans le dossier à convertir (les `.png` sont créés à côté des `.jpg`)

## Installation
Deux options au choix.

### Option A — Via les scripts fournis (alias inclus)
Les scripts se trouvent dans `install-scripts/`.

1) Installer
```bash
cd install-scripts
chmod +x install_jpg2png.sh uninstall_jpg2png.sh
./install_jpg2png.sh
```
Ce script:
- construit l’image Docker `jpg2png`
- ajoute un alias `jpg2png` à `~/.bashrc` et `~/.zshrc`

2) Désinstaller (si besoin)
```bash
cd install-scripts
./uninstall_jpg2png.sh
```
Supprime l’image, l’alias et nettoie les fichiers d’installation.

### Option B — Manuel (sans alias)
Depuis la racine du repo:
```bash
docker build -t jpg2png .
```
Ensuite, pour convertir le dossier courant:
```bash
docker run --rm -v "$PWD":/data jpg2png
```

## Utilisation
Le conteneur traite toutes les images avec l’extension exacte `.jpg` dans le dossier monté et produit des `.png` correspondants (ex: `photo.jpg` -> `photo.png`).

- Avec alias (si installé via scripts):
```bash
# Dans le dossier contenant les .jpg
jpg2png
```

- Sans alias:
```bash
docker run --rm -v "$PWD":/data jpg2png
```

- Sur un dossier spécifique:
```bash
docker run --rm -v "/chemin/vers/mon/dossier":/data jpg2png
```

- Conversion récursive (tous sous-dossiers) depuis le dossier racine à traiter:
```bash
# Parcourt chaque sous-dossier et lance le conteneur dessus
find "$PWD" -type d -print0 | while IFS= read -r -d '' d; do
  docker run --rm -v "$d":/data jpg2png
done
```

## Comportement et limites
- Non récursif par défaut: seul le dossier monté `/data` est traité.
- Extensions prises en charge: uniquement `*.jpg` (minuscule, pas `.jpeg` ni `.JPG`).
- Écrasement: si un `.png` du même nom existe, ImageMagick peut l’écraser.
- Métadonnées: selon la configuration ImageMagick, certaines métadonnées EXIF peuvent être altérées ou perdues.
- Performance: dépend du nombre de fichiers et des I/O disques; CPU unique par défaut.

Astuce pour `.jpeg` et `.JPG`:
- Variante simple: renommer vos fichiers en `.jpg` avant conversion ou adapter le script Docker (non inclus par défaut).
- Exemple de renommage (optionnel):
```bash
# Renommer .jpeg -> .jpg dans le dossier courant
for f in *.jpeg; do mv -- "$f" "${f%.jpeg}.jpg"; done 2>/dev/null || true
# Renommer .JPG -> .jpg
for f in *.JPG;  do mv -- "$f" "${f%.JPG}.jpg";  done 2>/dev/null || true
```

## Dépannage
- "permission denied while trying to connect to the Docker daemon":
  - Lancez Docker et/ou ajoutez votre utilisateur au groupe docker puis reconnectez-vous.
- Aucun fichier converti:
  - Assurez-vous qu’il existe des fichiers `*.jpg` (minuscule) dans le dossier monté.
- SELinux (Fedora/RHEL):
  - Ajoutez le flag `:Z` au volume si nécessaire: `-v "$PWD":/data:Z`.
- Droits d’accès:
  - Le dossier monté doit être accessible en lecture/écriture par Docker (bind mount).

## Détails techniques
- Base image: `debian:bullseye-slim`
- Outil: ImageMagick (`convert`)
- Entrypoint: `/usr/local/bin/convert-jpgs`
- Script de conversion: `convert.sh`

Schéma d’exécution:
- Montage du dossier hôte sur `/data`
- Boucle sur `*.jpg`
- `convert "$f" "${f%.jpg}.png"`

## Développement
Structure principale:
- `Dockerfile`: image minimale avec ImageMagick + script
- `convert.sh`: logique de conversion
- `install-scripts/`: installation/désinstallation avec alias shell

Pour itérer localement sur le Dockerfile et le script:
```bash
docker build -t jpg2png .
docker run --rm -v "$PWD":/data jpg2png
```

## Licence
Ce projet est sous licence MIT. Voir `LICENSE`.

## Remerciements
- ImageMagick pour l’outillage de conversion
- Docker pour l’encapsulation et la portabilité
