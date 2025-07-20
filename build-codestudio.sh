#!/bin/bash

# Script de build pour CodeStudio
# Ce script compile CodeStudio avec le nouveau branding

echo "🚀 Début du build de CodeStudio..."

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "package.json" ]; then
    echo "❌ Erreur: Ce script doit être exécuté depuis la racine du projet VS Code"
    exit 1
fi

# Installer les dépendances si nécessaire
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm install
fi

# Compiler le projet
echo "🔨 Compilation en cours..."
npm run compile

# Vérifier si la compilation a réussi
if [ $? -eq 0 ]; then
    echo "✅ CodeStudio compilé avec succès!"
    echo ""
    echo "🎉 Votre fork CodeStudio est prêt!"
    echo ""
    echo "Pour lancer CodeStudio:"
    echo "  ./scripts/code.sh"
    echo ""
    echo "Ou pour le mode web:"
    echo "  ./scripts/code-web.sh"
else
    echo "❌ Erreur lors de la compilation"
    exit 1
fi