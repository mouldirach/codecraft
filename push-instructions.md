# Instructions pour pousser les modifications vers GitHub

## Modifications effectuées ✅

Les fichiers suivants ont été mis à jour pour utiliser Node.js 20 :

1. **`.nvmrc`** : `22.15.1` → `20`
2. **`.github/workflows/build-codecraft.yml`** : Tous les jobs utilisent maintenant `node-version: '20'`
3. **`.github/workflows/telemetry.yml`** : `node-version: 'lts/*'` → `node-version: '20'`
4. **`verify-node-version.sh`** : Script de vérification ajouté

## Commandes pour pousser vers GitHub

### Option 1: Avec un nouveau token GitHub

```bash
cd /root/projects/codecraft

# Configurer un nouveau token (remplacez YOUR_NEW_TOKEN par votre token)
git remote set-url origin https://mouldirach:YOUR_NEW_TOKEN@github.com/mouldirach/codecraft.git

# Pousser les modifications
git push origin main
```

### Option 2: Avec SSH (si configuré)

```bash
cd /root/projects/codecraft

# Changer l'URL vers SSH
git remote set-url origin git@github.com:mouldirach/codecraft.git

# Pousser les modifications
git push origin main
```

### Option 3: Manuellement

1. Téléchargez les fichiers modifiés depuis ce serveur
2. Copiez-les dans votre repository local
3. Faites un commit et push depuis votre machine locale

## Fichiers modifiés à récupérer

- `.nvmrc`
- `.github/workflows/build-codecraft.yml`
- `.github/workflows/telemetry.yml`
- `verify-node-version.sh` (nouveau fichier)

## Vérification

Une fois poussé, vous pouvez vérifier que tout fonctionne en :

1. Allant sur GitHub Actions dans votre repository
2. Déclenchant un nouveau build
3. Vérifiant que les workflows utilisent Node.js 20

## Message de commit utilisé

```
🔧 Update Node.js version to 20 in all workflows

- Update .nvmrc from 22.15.1 to 20
- Update GitHub Actions workflows to use Node.js 20:
  - build-codecraft.yml: Update all three jobs (macOS, Linux, Windows)
  - telemetry.yml: Update from 'lts/*' to '20'
- Azure Pipelines already use .nvmrc so will automatically use Node.js 20
- Add verification script to check Node.js versions across the project

All workflows now consistently use Node.js 20 for better compatibility and stability.
```