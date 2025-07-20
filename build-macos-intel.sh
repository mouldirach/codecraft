#!/bin/bash

# Script de build pour CodeStudio - macOS Intel
# Ce script compile CodeStudio et crée un package pour macOS Intel

set -e

echo "🍎 Début du build de CodeStudio pour macOS Intel..."

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "package.json" ]; then
    echo "❌ Erreur: Ce script doit être exécuté depuis la racine du projet VS Code"
    exit 1
fi

# Variables d'environnement pour macOS Intel
export VSCODE_ARCH="x64"
export npm_config_target_arch="x64"
export npm_config_target_platform="darwin"
export npm_config_cache="/tmp/.npm"
export npm_config_build_from_source="true"

echo "📦 Configuration pour macOS Intel (x64)..."
echo "   - Architecture: $VSCODE_ARCH"
echo "   - Platform: $npm_config_target_platform"

# Nettoyer les builds précédents
echo "🧹 Nettoyage des builds précédents..."
rm -rf out-build
rm -rf .build/electron
rm -rf .build/node

# Installer les dépendances si nécessaire
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm install
fi

# Compiler le projet
echo "🔨 Compilation du code source..."
npm run compile

# Vérifier si la compilation a réussi
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la compilation"
    exit 1
fi

# Compiler les extensions
echo "🔌 Compilation des extensions..."
npm run compile-extensions-build

# Télécharger Electron pour macOS Intel si nécessaire
echo "⚡ Téléchargement d'Electron pour macOS Intel..."
node build/lib/electron.js

# Créer le build de production
echo "🏗️  Création du build de production..."
npm run compile-build

# Créer le package pour macOS Intel
echo "📦 Création du package macOS Intel (.app)..."
npm run gulp -- vscode-darwin-x64

# Vérifier si le build a réussi
if [ -d ".build/darwin" ]; then
    echo "✅ CodeStudio pour macOS Intel compilé avec succès!"
    echo ""
    echo "🍎 Application macOS créée:"
    ls -la .build/darwin/
    echo ""
    
    # Créer une archive .zip pour distribution
    echo "📦 Création de l'archive de distribution..."
    cd .build/darwin
    
    # Trouver le nom de l'app
    APP_NAME=$(ls *.app | head -n 1)
    if [ -n "$APP_NAME" ]; then
        # Créer l'archive
        zip -r "CodeStudio-macOS-Intel-$(date +%Y%m%d).zip" "$APP_NAME"
        echo "✅ Archive créée: CodeStudio-macOS-Intel-$(date +%Y%m%d).zip"
        echo ""
        echo "📊 Taille de l'archive:"
        ls -lh *.zip
        echo ""
        echo "🎉 Build terminé avec succès!"
        echo ""
        echo "📁 Fichiers disponibles:"
        echo "   - Application: .build/darwin/$APP_NAME"
        echo "   - Archive: .build/darwin/CodeStudio-macOS-Intel-$(date +%Y%m%d).zip"
        echo ""
        echo "💡 Pour installer sur macOS:"
        echo "   1. Décompressez l'archive .zip"
        echo "   2. Glissez CodeStudio.app vers le dossier Applications"
        echo "   3. Lancez CodeStudio depuis le Launchpad ou Applications"
    else
        echo "❌ Aucune application .app trouvée"
        exit 1
    fi
else
    echo "❌ Erreur lors de la création du build"
    exit 1
fi