#!/bin/bash

# Fonction d'affichage de l'aide
display_help() {
    echo "Usage: $0 [<nginx_config_file>]"
    echo "Configure NGINX and start Docker containers for Odoo web service."
    echo "Parameters:"
    echo "  <nginx_config_file> (optional): Path to the NGINX configuration file."
    echo "                                 If not provided, NGINX will not be configured."
    echo "Example:"
    echo "  $0 /path/to/nginx.conf"
}

# Vérification du nombre d'arguments
if [ $# -gt 1 ]; then
    echo "Error: Incorrect number of arguments!"
    display_help
    exit 1
fi

# Vérification si l'option --help ou -h est fournie
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    display_help
    exit 0
fi

# Si un fichier de configuration NGINX est fourni, le configurer
if [ $# -eq 1 ]; then
    # Vérification si le fichier NGINX existe
    if [ ! -f "$1" ]; then
        echo "Error: NGINX configuration file '$1' not found!"
        display_help
        exit 1
    fi

    # Configuration de NGINX
    echo "Enabling config"
    sudo cp "$1" /etc/nginx/sites-available/
    sudo ln -s /etc/nginx/sites-available/"$1" /etc/nginx/sites-enabled/
fi

# Modification des autorisations
chmod -R 777 odoo-web-data

# Arrêt des conteneurs Docker
docker-compose down -v

# Démarrage des conteneurs Docker
echo "Docker Up"
docker-compose up -d

# Attente du démarrage des services
echo "Waiting for service starting"
sleep 10
