# Instructions Globales Claude Code

## Langue

- Parle-moi en français

---

## grepai - Recherche Sémantique de Code (via CLI)

### RÈGLE OBLIGATOIRE

**Tu DOIS utiliser les commandes CLI grepai pour TOUTE recherche de code.** C'est NON-NÉGOCIABLE.

- ❌ **INTERDIT** : `Grep`, `Glob`, `grep`, `find`, `rg`, ou outils MCP grepai
- ✅ **OBLIGATOIRE** : Commandes `grepai` via Bash

### Commandes disponibles

| Commande | Usage |
|----------|-------|
| `grepai search "query" --limit 10` | Recherche sémantique |
| `grepai trace-callers "FunctionName"` | Qui appelle cette fonction |
| `grepai trace-callees "FunctionName"` | Ce que cette fonction appelle |
| `grepai trace-graph "FunctionName"` | Graphe d'appels complet |
| `grepai status` | Status de l'index |

### Comment chercher

**Langage naturel** - décris l'intention :
- ❌ `grepai search "auth token"` (mots-clés)
- ✅ `grepai search "Comment fonctionne l'authentification ?"` (question)

Pour les questions complexes, lance **plusieurs recherches en parallèle**.

### Options utiles

```bash
# Limiter les résultats
grepai search "query" --limit 5

# Format JSON (pour parsing)
grepai search "query" --json

# Mode compact
grepai search "query" --compact
```

### Auto-start

Le watch grepai se lance automatiquement via le hook `UserPromptSubmit`.

### Prérequis (pour l'utilisateur)

- Ollama : `brew services start ollama`
- Modèle : `ollama pull nomic-embed-text`
- Init projet : `grepai init && grepai watch` (une fois par projet)

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
