FROM debian:bullseye-slim

# Installer ImageMagick et nettoyer les caches
RUN apt-get update && \
    apt-get install -y imagemagick && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copier le script de conversion
COPY convert.sh /usr/local/bin/convert-jpgs
RUN chmod +x /usr/local/bin/convert-jpgs

# Définir le répertoire de travail par défaut
WORKDIR /data

# Commande par défaut quand le conteneur tourne
ENTRYPOINT ["/usr/local/bin/convert-jpgs"]


