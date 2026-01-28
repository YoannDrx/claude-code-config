# Instructions Globales Claude Code

## Langue

- Parle-moi en français

---

## mgrep - Recherche Sémantique de Code

**mgrep est l'outil principal pour explorer n'importe quel codebase.** Il retourne une réponse en langage naturel + les sources pertinentes.

### Store

Le nom du store = **le nom du dossier du projet**. Par exemple, pour `/Users/yoannandrieux/Projets/moodday`, le store s'appelle `moodday`.

### Lancer le watch (indexation)

Avant d'utiliser mgrep sur un projet, lance le watcher dans un terminal séparé :

```bash
cd ~/Projets/<nom-projet>
mgrep watch --store "<nom-projet>"
```

### Commande de recherche

```bash
mgrep "ta question en langage naturel" --store "<nom-projet>" -a -m 20
```

### Paramètres

| Paramètre              | Description                                   |
| ---------------------- | --------------------------------------------- |
| `--store "<nom>"`      | **Obligatoire** - nom du store (= dossier)    |
| `-a`                   | Réponse en langage naturel                    |
| `-m <n>`               | Nombre de résultats (10-50 selon complexité)  |

### Ajuster `-m` selon la complexité

| Type de requête                         | `-m` recommandé |
| --------------------------------------- | --------------- |
| Question simple (1-2 fichiers)          | 10              |
| Question moyenne (flow, feature)        | 20-30           |
| Question complexe (debug, architecture) | 30-50           |

### Règles

- **OBLIGATOIRE** : Utilise mgrep pour TOUTE recherche de code
- **Langage naturel** : Parle à mgrep comme à un collègue
  - ❌ `"auth token session"` (mots-clés)
  - ✅ `"Comment fonctionne l'authentification et la gestion des sessions ?"` (question naturelle)
- Pour les questions complexes, lance **plusieurs mgrep en parallèle**

---

## Recherche Web (Exa)

Utilise les outils Exa MCP pour :
- **Recherche web générale** : `web_search_exa`
- **Recherche de code/docs** : `get_code_context_exa`
- **Recherche d'entreprises** : `company_research_exa`

---

## Subagents

**Les subagents n'héritent PAS de ces instructions.**

Quand tu lances un subagent, copie-colle les instructions pertinentes (notamment mgrep) dans le prompt du subagent.
