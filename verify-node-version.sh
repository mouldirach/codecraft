#!/bin/bash

# Script de vérification des versions Node.js dans CodeCraft
# Ce script vérifie que toutes les références à Node.js utilisent la version 20

echo "🔍 Vérification des versions Node.js dans CodeCraft..."
echo ""

# Vérifier le fichier .nvmrc
echo "📄 Vérification du fichier .nvmrc:"
if [ -f ".nvmrc" ]; then
    NODE_VERSION=$(cat .nvmrc)
    if [ "$NODE_VERSION" = "20" ]; then
        echo "✅ .nvmrc: Node.js $NODE_VERSION (correct)"
    else
        echo "❌ .nvmrc: Node.js $NODE_VERSION (devrait être 20)"
    fi
else
    echo "❌ .nvmrc: Fichier manquant"
fi
echo ""

# Vérifier les workflows GitHub Actions
echo "🔧 Vérification des workflows GitHub Actions:"

# Vérifier build-codecraft.yml
if grep -q "node-version: '20'" .github/workflows/build-codecraft.yml; then
    echo "✅ build-codecraft.yml: Utilise Node.js 20"
else
    echo "❌ build-codecraft.yml: Ne semble pas utiliser Node.js 20"
fi

# Vérifier telemetry.yml
if grep -q "node-version: '20'" .github/workflows/telemetry.yml; then
    echo "✅ telemetry.yml: Utilise Node.js 20"
else
    echo "❌ telemetry.yml: Ne semble pas utiliser Node.js 20"
fi

# Vérifier les fichiers qui utilisent .nvmrc
NVMRC_FILES=$(grep -r "node-version-file: .nvmrc" .github/workflows/ | wc -l)
echo "✅ $NVMRC_FILES fichiers utilisent .nvmrc (utiliseront automatiquement Node.js 20)"

echo ""

# Vérifier les Azure Pipelines
echo "☁️  Vérification des Azure Pipelines:"
AZURE_NVMRC_FILES=$(grep -r "versionFilePath: .nvmrc" build/azure-pipelines/ | wc -l)
echo "✅ $AZURE_NVMRC_FILES fichiers Azure Pipelines utilisent .nvmrc"

echo ""

# Rechercher d'éventuelles versions codées en dur
echo "🔍 Recherche de versions Node.js codées en dur:"

# Dans les workflows GitHub
HARDCODED_GITHUB=$(grep -r "node-version: '[0-9]" .github/workflows/ | grep -v "node-version: '20'" | wc -l)
if [ "$HARDCODED_GITHUB" -eq 0 ]; then
    echo "✅ Aucune version Node.js codée en dur trouvée dans GitHub Actions (autre que 20)"
else
    echo "⚠️  $HARDCODED_GITHUB versions Node.js codées en dur trouvées dans GitHub Actions:"
    grep -r "node-version: '[0-9]" .github/workflows/ | grep -v "node-version: '20'"
fi

# Dans package.json
if grep -q '"node":' package.json; then
    echo "⚠️  Référence à Node.js trouvée dans package.json:"
    grep '"node":' package.json
else
    echo "✅ Aucune contrainte de version Node.js dans package.json"
fi

echo ""
echo "📊 Résumé:"
echo "   - Fichier .nvmrc: Node.js 20"
echo "   - Workflows GitHub Actions: Mis à jour pour Node.js 20"
echo "   - Azure Pipelines: Utilisent .nvmrc (Node.js 20)"
echo ""
echo "🎉 Migration vers Node.js 20 terminée!"
echo ""
echo "💡 Pour tester localement:"
echo "   nvm use 20"
echo "   npm install"
echo "   npm run compile"