# Instructions Globales Claude Code

## Langue

- Parle-moi en français

---

## grepai - Recherche Sémantique de Code (Gratuit & Local)

**grepai est l'outil principal pour explorer n'importe quel codebase.** Il utilise des embeddings locaux (Ollama) - 100% gratuit et privé.

### Prérequis

- Ollama doit tourner : `brew services start ollama`
- Modèle d'embedding installé : `ollama pull nomic-embed-text`

### Initialiser un projet (une seule fois)

```bash
cd ~/Projets/<nom-projet>
~/.local/bin/grepai init
```

### Lancer le watch (indexation)

Avant d'utiliser grepai sur un projet, lance le watcher :

```bash
cd ~/Projets/<nom-projet>
~/.local/bin/grepai watch
```

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

- **OBLIGATOIRE** : Utilise grepai pour TOUTE recherche de code
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
