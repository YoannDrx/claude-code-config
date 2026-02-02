# Instructions Globales Claude Code

## Langue

- Parle-moi en français

---

## grepai - Recherche Sémantique de Code (via MCP)

### RÈGLE OBLIGATOIRE

**Tu DOIS utiliser grepai (via MCP) pour TOUTE recherche de code.** C'est NON-NÉGOCIABLE.

- ❌ **INTERDIT** : `Grep`, `Glob`, `grep`, `find`, `rg`, ou toute autre méthode de recherche
- ✅ **OBLIGATOIRE** : `mcp__grepai__grepai_search` pour toutes les recherches

### Outils MCP disponibles

| Outil MCP | Usage |
|-----------|-------|
| `mcp__grepai__grepai_search` | Recherche sémantique (TOUJOURS utiliser) |
| `mcp__grepai__grepai_trace_callers` | Qui appelle une fonction |
| `mcp__grepai__grepai_trace_callees` | Ce qu'une fonction appelle |
| `mcp__grepai__grepai_trace_graph` | Graphe d'appels complet |
| `mcp__grepai__grepai_index_status` | Status de l'index |

### Comment chercher

**Langage naturel uniquement** - parle à grepai comme à un collègue :
- ❌ `"auth token session"` (mots-clés)
- ✅ `"Comment fonctionne l'authentification et la gestion des sessions ?"` (question naturelle)

Pour les questions complexes, lance **plusieurs recherches en parallèle**.

### Auto-start

Le watch grepai se lance automatiquement via le hook `UserPromptSubmit`.

### Prérequis (pour l'utilisateur)

- Ollama : `brew services start ollama`
- Modèle : `ollama pull nomic-embed-text`
- Init projet : `~/.local/bin/grepai init` (une fois par projet, dans un terminal)

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
