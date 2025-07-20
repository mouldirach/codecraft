#!/bin/bash

# Script pour créer un fichier .dmg à partir de l'application CodeStudio
# Ce script doit être exécuté APRÈS build-macos-intel.sh

set -e

echo "💿 Création d'un fichier .dmg pour CodeStudio..."

# Vérifier que l'application existe
if [ ! -d ".build/darwin" ]; then
    echo "❌ Erreur: Aucun build macOS trouvé. Exécutez d'abord ./build-macos-intel.sh"
    exit 1
fi

cd .build/darwin

# Trouver l'application
APP_NAME=$(ls *.app | head -n 1)
if [ -z "$APP_NAME" ]; then
    echo "❌ Erreur: Aucune application .app trouvée"
    exit 1
fi

echo "📱 Application trouvée: $APP_NAME"

# Nom du DMG
DMG_NAME="CodeStudio-macOS-Intel-$(date +%Y%m%d).dmg"
TEMP_DMG="temp-$DMG_NAME"

# Créer un dossier temporaire pour le DMG
TEMP_DIR="dmg_temp"
rm -rf "$TEMP_DIR"
mkdir "$TEMP_DIR"

# Copier l'application dans le dossier temporaire
echo "📋 Copie de l'application..."
cp -R "$APP_NAME" "$TEMP_DIR/"

# Créer un lien vers Applications
echo "🔗 Création du lien vers Applications..."
ln -s /Applications "$TEMP_DIR/Applications"

# Calculer la taille nécessaire
echo "📏 Calcul de la taille du DMG..."
SIZE=$(du -sm "$TEMP_DIR" | cut -f1)
SIZE=$((SIZE + 50))  # Ajouter 50MB de marge

echo "💿 Création du fichier DMG (${SIZE}MB)..."

# Créer le DMG temporaire
hdiutil create -srcfolder "$TEMP_DIR" -volname "CodeStudio" -fs HFS+ -fsargs "-c c=64,a=16,e=16" -format UDRW -size ${SIZE}m "$TEMP_DMG"

# Monter le DMG pour personnalisation
echo "🔧 Personnalisation du DMG..."
DEVICE=$(hdiutil attach -readwrite -noverify -noautoopen "$TEMP_DMG" | egrep '^/dev/' | sed 1q | awk '{print $1}')

# Attendre que le volume soit monté
sleep 2

# Personnaliser l'apparence (optionnel)
VOLUME_PATH="/Volumes/CodeStudio"
if [ -d "$VOLUME_PATH" ]; then
    # Définir la position des icônes et la taille de la fenêtre
    echo '
    tell application "Finder"
        tell disk "CodeStudio"
            open
            set current view of container window to icon view
            set toolbar visible of container window to false
            set statusbar visible of container window to false
            set the bounds of container window to {400, 100, 900, 400}
            set theViewOptions to the icon view options of container window
            set arrangement of theViewOptions to not arranged
            set icon size of theViewOptions to 128
            set position of item "'$APP_NAME'" of container window to {150, 200}
            set position of item "Applications" of container window to {350, 200}
            update without registering applications
            delay 5
            close
        end tell
    end tell
    ' | osascript || echo "⚠️  Impossible de personnaliser l'apparence (normal sur Linux)"
fi

# Démonter le DMG
hdiutil detach "$DEVICE"

# Convertir en DMG final (compressé)
echo "🗜️  Compression du DMG..."
hdiutil convert "$TEMP_DMG" -format UDZO -imagekey zlib-level=9 -o "$DMG_NAME"

# Nettoyer
rm -f "$TEMP_DMG"
rm -rf "$TEMP_DIR"

if [ -f "$DMG_NAME" ]; then
    echo "✅ DMG créé avec succès!"
    echo ""
    echo "📊 Informations du fichier:"
    ls -lh "$DMG_NAME"
    echo ""
    echo "🎉 Fichier DMG prêt: $DMG_NAME"
    echo ""
    echo "💡 Pour distribuer:"
    echo "   - Partagez le fichier $DMG_NAME"
    echo "   - Les utilisateurs peuvent double-cliquer pour monter le DMG"
    echo "   - Puis glisser CodeStudio vers Applications"
else
    echo "❌ Erreur lors de la création du DMG"
    exit 1
fi