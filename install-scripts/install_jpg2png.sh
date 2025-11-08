#!/bin/bash
set -e

IMAGE_NAME="jpg2png"
INSTALL_DIR="$HOME/.jpg2png_docker"
DOCKERFILE_PATH="$INSTALL_DIR/Dockerfile"
SCRIPT_PATH="$INSTALL_DIR/convert.sh"
ALIAS_CMD="alias jpg2png='docker run --rm -v \"\$PWD\":/data $IMAGE_NAME'"
MARKER="# >>> JPG2PNG ALIAS >>>"

echo "[+] Création du dossier d'installation : $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Dockerfile
cat > "$DOCKERFILE_PATH" <<'EOF'
FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y imagemagick && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY convert.sh /usr/local/bin/convert-jpgs
RUN chmod +x /usr/local/bin/convert-jpgs

WORKDIR /data
ENTRYPOINT ["/usr/local/bin/convert-jpgs"]
EOF

# Script
cat > "$SCRIPT_PATH" <<'EOF'
#!/bin/bash
set -e
shopt -s nullglob

for f in *.jpg; do
    convert "$f" "${f%.jpg}.png"
done
EOF

chmod +x "$SCRIPT_PATH"

echo "[+] Build de l’image Docker '$IMAGE_NAME'"
docker build -t "$IMAGE_NAME" "$INSTALL_DIR"

add_alias() {
    local shell_rc="$1"
    if [ -f "$shell_rc" ]; then
        if ! grep -Fq "$MARKER" "$shell_rc"; then
            echo -e "\n$MARKER\n$ALIAS_CMD\n# <<< JPG2PNG ALIAS <<<" >> "$shell_rc"
            echo "[+] Alias ajouté à $shell_rc"
        else
            echo "[=] Alias déjà présent dans $shell_rc"
        fi
    fi
}

echo "[+] Ajout de l'alias aux shells..."
add_alias "$HOME/.bashrc"
add_alias "$HOME/.zshrc"

echo "[✓] Installation terminée. Recharge ton shell ou exécute :"
echo "    source ~/.bashrc  # ou source ~/.zshrc"
echo "Ensuite utilise simplement : jpg2png"
