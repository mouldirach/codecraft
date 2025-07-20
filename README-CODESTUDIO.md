# CodeStudio

**CodeStudio** est un fork personnalisé de Visual Studio Code, conçu pour permettre l'exécution de plusieurs instances avec une identité distincte.

## 🎯 Objectif

Ce fork a été créé pour :
- Avoir un éditeur de code avec une identité visuelle différente de VS Code
- Permettre l'exécution simultanée de plusieurs instances d'éditeurs de code
- Utiliser des dossiers de configuration séparés (`.codestudio` au lieu de `.vscode`)

## 🚀 Installation et Build

### Prérequis
- Node.js (version 18 ou supérieure)
- npm ou yarn
- Python 3.x
- Git

### Build du projet

1. **Cloner le repository** (si pas déjà fait)
```bash
git clone <votre-repo-url>
cd vscode
```

2. **Installer les dépendances**
```bash
npm install
```

3. **Compiler CodeStudio**
```bash
./build-codestudio.sh
```

Ou manuellement :
```bash
npm run compile
```

4. **Lancer CodeStudio**
```bash
./scripts/code.sh
```

## 🎨 Différences avec VS Code

### Branding
- **Nom**: CodeStudio (au lieu de "Code - OSS")
- **Dossier de configuration**: `.codestudio` (au lieu de `.vscode-oss`)
- **Protocole URL**: `codestudio://` (au lieu de `code-oss://`)
- **Icônes**: Icônes personnalisées (actuellement copies des originales)

### Identifiants système
- **Linux**: `codestudio` 
- **Windows**: `CodeStudio.CodeStudio`
- **macOS**: `com.codestudio.codestudio`

## 📁 Structure des fichiers modifiés

- `product.json` - Configuration principale du produit
- `package.json` - Métadonnées du package
- `resources/linux/code.desktop` - Fichier desktop Linux
- `resources/linux/code.appdata.xml` - Métadonnées d'application
- Icônes dans `resources/` - Copies des icônes originales

## 🔧 Développement

### Scripts disponibles
- `npm run compile` - Compile le projet
- `npm run watch` - Mode watch pour le développement
- `./scripts/code.sh` - Lance CodeStudio en mode desktop
- `./scripts/code-web.sh` - Lance CodeStudio en mode web

### Personnalisation supplémentaire

Pour personnaliser davantage votre fork :

1. **Changer les icônes** : Remplacez les fichiers dans `resources/`
2. **Modifier les couleurs** : Éditez les fichiers CSS dans `src/vs/workbench/`
3. **Ajouter des fonctionnalités** : Développez dans `src/vs/`

## 📝 Notes importantes

- Ce fork maintient la compatibilité avec les extensions VS Code
- Les paramètres sont stockés séparément de VS Code
- Peut fonctionner en parallèle avec VS Code sans conflit

## 🤝 Contribution

Ce fork est basé sur VS Code OSS. Pour contribuer :
1. Fork ce repository
2. Créez une branche pour votre fonctionnalité
3. Committez vos changements
4. Poussez vers la branche
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet hérite de la licence MIT de VS Code.

---

**CodeStudio** - Votre éditeur de code personnalisé ! 🎉