# Installation des scripts
> Ceci est un installateur avec rollback intégré + une désinstallation propre.

On a :
- `install_jpg2png.sh` : installe l’image Docker + l’alias, avec point de rollback.

- `uninstall_jpg2png.sh` : désinstalle l’image Docker, l’alias et supprime les fichiers.

---

## Prérequis
- Docker doit être installé et fonctionnel sur ta machine.
- Avoir les droits d’exécution sur les scripts : `chmod +x install_jpg2png.sh uninstall_jpg2png.sh`

---

## Installation

Lance le script d’installation :
```bash
# Installation
chmod +x install_jpg2png.sh
./install_jpg2png.sh
```

## Désinstallation

Lance le script de désinstallation :
```bash
# Désinstallation
chmod +x uninstall_jpg2png.sh
./uninstall_jpg2png.sh
```

---

Ce setup est hermétique, réversible, sans déchet. Si tu veux une version .deb ou .pkg, je peux enchaîner.