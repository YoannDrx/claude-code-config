# Instructions Globales Claude Code

## Langue

- Parle-moi en français

---

## grepai - Recherche Sémantique de Code (Gratuit & Local)

**grepai est l'outil principal pour explorer n'importe quel codebase.** Il utilise des embeddings locaux (Ollama) - 100% gratuit et privé.

### ⚡ AUTO-START (à faire automatiquement au début de chaque session)

**Dès que tu commences à travailler sur un projet, lance ce script :**

```bash
# Script auto-start grepai (v2 - détection par projet)
GREPAI_BIN="$HOME/.local/bin/grepai"
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"

if [[ ! -f "$GREPAI_BIN" ]]; then
  echo "⚠️ grepai n'est pas installé"
elif [[ ! -d ".grepai" ]]; then
  echo "⚠️ Projet non initialisé - lance: grepai init"
else
  # Vérifier si un watch tourne POUR CE PROJET spécifiquement
  WATCH_PID=$(lsof -c grepai 2>/dev/null | grep "$PROJECT_DIR" | awk '{print $2}' | head -1)

  if [[ -n "$WATCH_PID" ]]; then
    echo "✅ grepai watch actif pour $PROJECT_NAME (PID: $WATCH_PID)"
  else
    echo "🚀 Lancement grepai watch pour $PROJECT_NAME..."
    "$GREPAI_BIN" watch --background
    sleep 1
    echo "✅ grepai watch lancé"
  fi
fi
```

> Lance ce script UNE SEULE FOIS au début de la session. Il détecte si un watch tourne **pour ce projet spécifiquement** (pas un autre).

### Prérequis

- Ollama doit tourner : `brew services start ollama`
- Modèle d'embedding installé : `ollama pull nomic-embed-text`

### Commande de recherche

```bash
~/.local/bin/grepai search "ta question en langage naturel"
```

### Commandes disponibles

| Commande | Description |
|----------|-------------|
| `grepai search "<query>"` | Recherche sémantique dans le code |
| `grepai trace callers "<function>"` | Voir qui appelle une fonction |
| `grepai trace callees "<function>"` | Voir ce qu'une fonction appelle |
| `grepai watch` | Indexation en temps réel |

### Règles

- **OBLIGATOIRE** : Utilise grepai pour TOUTE recherche de code. N'utilise JAMAIS grep, Grep tool, ou Glob.
- **Langage naturel** : Parle à grepai comme à un collègue
  - ❌ `"auth token session"` (mots-clés)
  - ✅ `"Comment fonctionne l'authentification et la gestion des sessions ?"` (question naturelle)
- Pour les questions complexes, lance **plusieurs grepai en parallèle**

---

## Recherche Web (Exa)

Utilise les outils Exa MCP pour :
- **Recherche web générale** : `web_search_exa`
- **Recherche de code/docs** : `get_code_context_exa`
- **Recherche d'entreprises** : `company_research_exa`

---

## Subagents

**Les subagents n'héritent PAS de ces instructions.**

Quand tu lances un subagent, copie-colle les instructions pertinentes (notamment grepai) dans le prompt du subagent.
