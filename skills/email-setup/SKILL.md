---
name: email-setup
description: Setup and harmonize email configuration for a project (Resend, OVH, DNS, Vercel). Use when configuring email sending, DNS records, domain management, or email redirections for any project.
disable-model-invocation: false
user-invocable: true
allowed-tools: Bash, Read, Edit, Write, Grep, Glob, Task, WebSearch
argument-hint: <project-name-or-action>
---

# Email Setup & Domain Management Skill

Setup and harmonize email configuration and DNS for any project using Resend + OVH + Vercel infrastructure.

## Architecture email standard

| Element | Valeur | Description |
|---|---|---|
| **EMAIL_FROM** | `NomProjet <nomprojet@yodev.fr>` | Expediteur via domaine Resend verifie partage |
| **NEXT_PUBLIC_EMAIL_CONTACT** | `hello@domaine-du-projet` | Email de contact public (redirection OVH → gmail) |
| **replyTo** | `params.replyTo ?? env.NEXT_PUBLIC_EMAIL_CONTACT` | Toujours le contact du projet |
| **Domaine expediteur** | `yodev.fr` | Verifie sur Resend, partage par TOUS les projets (migration aout 2026, `do-not-reply.app` resilie au 09/12/2026) |

## Fichiers a configurer dans chaque projet

### 1. `.env-template` / `.env.example`

```env
EMAIL_FROM="NomProjet <nomprojet@yodev.fr>"
NEXT_PUBLIC_EMAIL_CONTACT=hello@domaine-du-projet
```

### 2. `src/lib/mail/send-email.ts`

Pattern standard :

```typescript
from: params.from ?? env.EMAIL_FROM,
replyTo: params.replyTo ?? env.NEXT_PUBLIC_EMAIL_CONTACT,
```

Le `from` utilise toujours `yodev.fr` (domaine Resend verifie). Le `replyTo` pointe vers le contact du projet.

### 3. `src/site-config.ts`

```typescript
email: {
  contact: "hello@domaine-du-projet",
}
```

### 4. `.github/workflows/*.yml`

```yaml
env:
  EMAIL_FROM: "NomProjet <nomprojet@yodev.fr>"
  NEXT_PUBLIC_EMAIL_CONTACT: hello@domaine-du-projet
```

### 5. Pages contact / about / legal

Utiliser `hello@domaine-du-projet` ou la variable `NEXT_PUBLIC_EMAIL_CONTACT` dans les pages publiques.

---

## Infrastructure

### DNS & Domaines — Inventaire complet

**Cloudflare n'est PLUS utilise.** Toutes les zones ont ete supprimees (fevrier 2026). Tous les domaines sont geres par OVH ou Vercel DNS.

| Domaine | Registrar | DNS (NS) | Vercel Project | Email redirect | Notes |
|---|---|---|---|---|---|
| `caroline-senyk.fr` | OVH | OVH anycast (`dns200/ns200.anycast.me`) | Aucun | — | **Resilie** (suppression le 18/11/2026) |
| `do-not-reply.app` | OVH | OVH hosting (`dns16/ns16.ovh.net`) | Aucun | — | **Resilie** (suppression a l'expiration le 09/12/2026) — ne plus utiliser |
| `loic-ghanem.com` | OVH | OVH anycast | portfolio-loic → www | Aucun | Portfolio |
| `mycryptopilot.app` | OVH | OVH anycast | mycryptopilot → www | hello@ → gmail | — |
| `yoann-andrieux.fr` | OVH | OVH anycast | portfolio-yoann → www | Aucun | Portfolio |
| `yodev.fr` | OVH | OVH anycast | yodev → www | yo@ → gmail | — |
| `eggscuseme.app` | **Vercel** | **Vercel DNS** (`ns1/ns2.vercel-dns.com`) | eggscuse-me → www | Aucun (a configurer) | Seul domaine non-OVH |
| `jobio.fr` | Third Party | Third Party | jobio | A configurer | Projet principal |
| `homego.app` | Third Party | Third Party | homego | A configurer | — |
| `moodday.app` | Third Party | Third Party | moodday | A configurer | — |
| `hyrun.app` | Third Party | Third Party | hyrun | A configurer | — |

**IPs Vercel standard** : `76.76.21.21` et `216.198.79.1`
**CNAME www Vercel** : `cname.vercel-dns.com` ou project-specific

### Resend

- **Cle API** : variable `RESEND_API_KEY` dans le `.env` de chaque projet
- **Domaine verifie** : `yodev.fr` (`do-not-reply.app` est obsolete et resilie)
- **API** :
  ```bash
  # Lister les domaines
  curl -H "Authorization: Bearer $RESEND_API_KEY" https://api.resend.com/domains

  # Envoyer un email test
  curl -X POST https://api.resend.com/emails \
    -H "Authorization: Bearer $RESEND_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"from":"Test <test@yodev.fr>","to":"test@example.com","subject":"Test","text":"Hello"}'
  ```
- **Records DNS critiques sur `yodev.fr` (zone OVH)** :
  - DKIM : TXT `resend._domainkey` → cle publique RSA
  - SPF/bounce : TXT `send` → `v=spf1 include:amazonses.com ~all` + MX `send` → `feedback-smtp.eu-west-1.amazonses.com`

### OVH (Python API)

**Credentials** : `~/.ovh.conf` (endpoint `ovh-eu`)
**Package** : `pip install ovh` (installe)

```python
import ovh
client = ovh.Client()  # lit ~/.ovh.conf automatiquement

# Creer une redirection email
client.post(f'/email/domain/{domain}/redirection',
    _from=f'hello@{domain}',
    to=OWNER_EMAIL,  # adresse perso du proprietaire (non versionnee)
    localCopy=False
)

# Lister les redirections
ids = client.get(f'/email/domain/{domain}/redirection')
for rid in ids:
    details = client.get(f'/email/domain/{domain}/redirection/{rid}')
    print(details)

# Creer un record DNS
client.post(f'/domain/zone/{domain}/record',
    fieldType='TXT',
    subDomain='resend._domainkey',
    target='...',
    ttl=3600
)

# Refresh de zone OBLIGATOIRE apres toute modification DNS
client.post(f'/domain/zone/{domain}/refresh')
```

**Script de redirections en batch** : `scripts/ovh-create-redirections.py` (dans jobio)

### Vercel (CLI + API)

```bash
# Lister les domaines
vercel domains ls

# Inspecter un domaine (NS, projet, SSL)
vercel domains inspect <domain>

# Gerer les DNS d'un domaine Vercel
vercel dns ls <domain>
vercel dns add <domain> <subdomain> <type> <value>
vercel dns remove <id>
```

**API REST Vercel** (pour les operations avancees) :

```bash
# Token CLI stocke dans ~/Library/Application Support/com.vercel.cli/auth.json
VERCEL_TOKEN="..."
TEAM_ID="$VERCEL_TEAM_ID"  # id de la team, via GET /v2/teams

# Inspecter un domaine
curl -s -H "Authorization: Bearer $VERCEL_TOKEN" \
  "https://api.vercel.com/v5/domains/<domain>?teamId=$TEAM_ID"

# Changer les NS d'un domaine enregistre chez Vercel
# (supprimer les customNameservers pour revenir aux NS Vercel par defaut)
curl -s -X PATCH -H "Authorization: Bearer $VERCEL_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"customNameservers":[]}' \
  "https://api.vercel.com/v5/domains/<domain>?teamId=$TEAM_ID"

# Lister toutes les teams
curl -s -H "Authorization: Bearer $VERCEL_TOKEN" "https://api.vercel.com/v2/teams"
```

### Cloudflare (ARCHIVE — plus utilise)

**Statut** : Toutes les zones supprimees (fevrier 2026). Compte vide.

**Credentials** : variables d'environnement locales `CLOUDFLARE_EMAIL` et `CLOUDFLARE_GLOBAL_API_KEY` (jamais versionnees).

```bash
# Verifier qu'il n'y a plus de zones
curl -s -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
  -H "X-Auth-Key: $CLOUDFLARE_GLOBAL_API_KEY" \
  "https://api.cloudflare.com/client/v4/zones?per_page=50"
```

---

## Workflow du skill

### Etape 1 — Audit

Verifier l'etat actuel du projet :

```bash
# Verifier les fichiers de config
cat .env-template || cat .env.example
grep -r "EMAIL_FROM\|NEXT_PUBLIC_EMAIL_CONTACT" .env* src/site-config.ts
grep -r "from:\|replyTo:" src/lib/mail/send-email.ts
grep -r "email\|contact" .github/workflows/*.yml
```

### Etape 2 — Configure (code)

Appliquer le pattern standard sur tous les fichiers listes ci-dessus.

### Etape 3 — OVH redirections

Creer la redirection `hello@domaine` → adresse perso du proprietaire (`OWNER_EMAIL`) via l'API OVH Python.

### Etape 4 — DNS

Verifier les records DNS du domaine :

```bash
dig NS domaine.com @8.8.8.8
dig TXT domaine.com @8.8.8.8
dig MX domaine.com @8.8.8.8
dig TXT resend._domainkey.domaine.com @8.8.8.8
```

Si le domaine est sur OVH, creer les records manquants via l'API Python.
Si le domaine est sur Vercel DNS, utiliser `vercel dns add`.

### Etape 5 — Verify

```bash
pnpm ts                          # TypeScript compile
dig NS domaine.com @8.8.8.8     # NS corrects (OVH ou Vercel)
dig TXT resend._domainkey.yodev.fr  # DKIM present
# Envoyer un email test via Resend API
```

---

## Checklist de verification

- [ ] `pnpm ts` passe sans erreur
- [ ] `EMAIL_FROM` utilise `yodev.fr` comme domaine expediteur (jamais `do-not-reply.app`)
- [ ] `NEXT_PUBLIC_EMAIL_CONTACT` = `hello@domaine-du-projet`
- [ ] `send-email.ts` a `replyTo` avec fallback vers `NEXT_PUBLIC_EMAIL_CONTACT`
- [ ] Redirection OVH `hello@domaine` → adresse perso du proprietaire existe
- [ ] Workflows CI ont les variables `EMAIL_FROM` et `NEXT_PUBLIC_EMAIL_CONTACT`
- [ ] Pages publiques (contact, about, legal) utilisent le bon email de contact
- [ ] Records DNS verifies (SPF, DKIM sur `yodev.fr`)
- [ ] Vercel : une seule entree `EMAIL_FROM` par environnement (pas de doublon `development`/`preview` herite)
- [ ] NS du domaine verifies (`dig NS @8.8.8.8` → OVH ou Vercel)

---

## Projets deja configures (reference)

| Projet | Domaine | EMAIL_FROM | Contact |
|---|---|---|---|
| Jobio | jobio.fr | `Jobio <jobio@yodev.fr>` | hello@jobio.fr |
| EggscuseMe | eggscuseme.app | `EggscuseMe <eggscuseme@yodev.fr>` | hello@eggscuseme.app |
| Moodday | moodday.app | `Moodday <moodday@yodev.fr>` | hello@moodday.app |
| MyCryptoPilot | mycryptopilot.app | `MyCryptoPilot <mycryptopilot@yodev.fr>` | hello@mycryptopilot.app |

HomeGo et Hyrun sont abandonnes (domaines resilies, fin fevrier 2027).

---

## Migration DNS — Notes historiques (fevrier 2026)

### Cloudflare → OVH (termine)

6 domaines migres de Cloudflare vers OVH DNS :
- `caroline-senyk.fr`, `do-not-reply.app`, `loic-ghanem.com`, `mycryptopilot.app`, `yoann-andrieux.fr`, `yodev.fr`

Toutes les zones Cloudflare ont ete supprimees. Le compte Cloudflare est vide.

### eggscuseme.app → Vercel DNS (termine)

`eggscuseme.app` est enregistre chez Vercel (pas OVH). La migration s'est faite en supprimant les `customNameservers` (Cloudflare) via l'API Vercel PATCH, ce qui a reactive les NS Vercel par defaut (`ns1/ns2.vercel-dns.com`).

### Records perdus (sans impact)

Les records suivants existaient sur Cloudflare et n'ont PAS ete recrees (inutiles) :
- DKIM `cf2024-1._domainkey.*` → CF Email Routing (desactive)
- SPF `include:_spf.mx.cloudflare.net` → remplace par OVH
- MX `route*.mx.cloudflare.net` → remplace par OVH
- `resend._domainkey.mycryptopilot.app` → obsolete, on utilise `yodev.fr`
- CAA `letsencrypt.org` → Vercel gere ses propres certs

### Ameliorations optionnelles (non faites)

- DMARC : Aucun domaine n'a de record `_dmarc TXT "v=DMARC1; p=none;"` (bonne pratique)
- SPF : Certaines zones OVH ont `SPF -all` (hard fail), passer a `~all` (soft fail) serait plus tolerant
- TXT Vercel : Quelques domaines OVH n'ont pas les TXT `_vercel` verification (sites fonctionnent via A records)
