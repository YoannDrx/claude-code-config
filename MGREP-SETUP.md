# Configuration mgrep - Récapitulatif Complet

Ce document récapitule toute la configuration mgrep pour les projets.

---

## Installation (une seule fois)

```bash
# 1. Installer mgrep globalement
npm i -g @mixedbread/mgrep

# 2. Se connecter
mgrep login
```

---

## Configuration Globale

### Fichier de config mgrep
**Chemin** : `~/.config/mgrep/config.yaml`

```yaml
# Taille maximale des fichiers à indexer (10MB)
maxFileSize: 10485760

# Nombre maximum de fichiers à indexer
maxFileCount: 10000

# Activer le reranking (améliore la pertinence)
rerank: true
```

### Instructions Claude Code globales
**Chemin** : `~/.claude/CLAUDE.md`

Contient les instructions générales pour mgrep, Exa, et les subagents.

---

## Projets Configurés

Chaque projet a :
- `.claude/CLAUDE.md` avec instructions mgrep + auto-start
- `.mgreprc.yaml` (config optionnelle par projet)

### Tableau des Stores

| Projet | Store mgrep | Chemin |
|--------|-------------|--------|
| **choosewisely** | `choosewisely` | `~/Projets/choosewisely` |
| **EggscuseMe** | `EggscuseMe` | `~/Projets/EggscuseMe` |
| **impulsion** | `impulsion` | `~/Projets/impulsion` |
| **leboncoin** | `leboncoin` | `~/Projets/leboncoin` |
| **lights** | `lights` | `~/Projets/lights` |
| **moodday** | `moodday` | `~/Projets/moodday` |
| **moodtrace** | `moodtrace` | `~/Projets/moodtrace` |
| **mycryptopilot** | `mycryptopilot` | `~/Projets/mycryptopilot` |
| **parigo** | `parigo` | `~/Projets/parigo` |
| **portfolio-caro** | `portfolio-caro` | `~/Projets/portfolio-caro` |
| **portfolio-loic** | `portfolio-loic` | `~/Projets/portfolio-loic` |
| **portfolio-yoann** | `portfolio-yoann` | `~/Projets/portfolio-yoann` |
| **raycast** | `raycast` | `~/Projets/raycast` |
| **weekend-checker** | `weekend-checker` | `~/Projets/weekend-checker` |
| **whisper** | `whisper` | `~/Projets/whisper` |
| **yodev** | `yodev` | `~/Projets/yodev` |

### Projets Exclus (pas de config mgrep)

- `mail-certificate`
- `prodem`
- `weil-associes`

---

## Comment ça fonctionne

### Quand tu ouvres Claude Code sur un projet

1. Claude lit le fichier `.claude/CLAUDE.md` du projet
2. Il voit l'instruction **AUTO-START** et lance automatiquement :
   ```bash
   mgrep watch --store "<nom-projet>" &
   ```
3. mgrep indexe le projet en background
4. Tu peux poser tes questions, mgrep est prêt

### Commande de recherche

```bash
mgrep "ta question en langage naturel" --store "<nom-projet>" -a -m <nombre>
```

**Paramètres :**
| Paramètre | Description |
|-----------|-------------|
| `--store` | Nom du store (= nom du dossier) |
| `-a` | Réponse en langage naturel |
| `-m <n>` | Nombre de résultats (10-50) |

**Ajuster `-m` selon la complexité :**
| Type de requête | `-m` |
|-----------------|------|
| Simple (1-2 fichiers) | 10 |
| Moyenne (flow, feature) | 20-30 |
| Complexe (debug, archi) | 30-50 |

---

## Workflow Recommandé

### Option 1 : Automatique (via CLAUDE.md)

Ouvre simplement Claude Code dans le projet :
```bash
cd ~/Projets/moodday
claude
```
Claude lancera automatiquement `mgrep watch` en background.

### Option 2 : Manuel

```bash
# Terminal 1 : lancer mgrep watch
cd ~/Projets/moodday
mgrep watch --store "moodday"

# Terminal 2 : ouvrir Claude Code
cd ~/Projets/moodday
claude
```

---

## Bonnes Pratiques

### 1. Langage naturel

mgrep est un agent IA. Parle-lui comme à un collègue :

❌ **Mauvais** : `"auth token session middleware"`
✅ **Bon** : `"Comment fonctionne l'authentification et où sont gérées les sessions ?"`

### 2. Requêtes complexes = plusieurs mgrep en parallèle

```bash
mgrep "comment fonctionne l'auth côté frontend" --store "moodday" -a -m 20
mgrep "comment les tokens sont gérés côté serveur" --store "moodday" -a -m 20
mgrep "comment les sessions sont persistées" --store "moodday" -a -m 20
```

### 3. Toujours un .gitignore propre

Avant d'indexer un projet, assure-toi d'avoir un `.gitignore` pour éviter d'indexer `node_modules/`, `.next/`, etc.

---

## Troubleshooting

### mgrep ne trouve rien

1. Vérifie que le watch tourne : `ps aux | grep mgrep`
2. Relance le watch : `mgrep watch --store "<nom>" &`
3. Vérifie le nom du store (= nom du dossier)

### Trop de résultats non pertinents

- Augmente `-m` pour plus de contexte
- Reformule en langage naturel plus précis

### mgrep indexe trop de fichiers

- Vérifie ton `.gitignore`
- Ajoute un `.mgrepignore` si besoin

---

## Structure des Fichiers

```
~/.claude/
├── CLAUDE.md           # Instructions globales
├── MGREP-SETUP.md      # Ce fichier
└── config.json         # Config Claude Code

~/.config/mgrep/
└── config.yaml         # Config globale mgrep

~/Projets/<projet>/
├── .claude/
│   └── CLAUDE.md       # Instructions projet + auto-start
└── .mgreprc.yaml       # Config mgrep projet (optionnel)
```

---

*Dernière mise à jour : Janvier 2026*
