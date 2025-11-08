#!/bin/bash
set -e

IMAGE_NAME="jpg2png"
INSTALL_DIR="$HOME/.jpg2png_docker"
MARKER="# >>> JPG2PNG ALIAS >>>"

clean_alias() {
    local shell_rc="$1"
    if [ -f "$shell_rc" ]; then
        if grep -Fq "$MARKER" "$shell_rc"; then
            echo "[+] Nettoyage de l'alias dans $shell_rc"
            sed -i "/$MARKER/,/# <<< JPG2PNG ALIAS <</d" "$shell_rc"
        fi
    fi
}

echo "[+] Suppression de l'image Docker '$IMAGE_NAME'"
docker rmi -f "$IMAGE_NAME" >/dev/null 2>&1 || echo "[!] Image absente ou déjà supprimée"

echo "[+] Nettoyage des fichiers installés"
rm -rf "$INSTALL_DIR"

echo "[+] Nettoyage des alias dans shells..."
clean_alias "$HOME/.bashrc"
clean_alias "$HOME/.zshrc"

echo "[✓] Désinstallation complète. Recharge ton shell si besoin."
