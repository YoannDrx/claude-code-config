
# Session Title
_A short and distinctive 5-10 word descriptive title for the session. Super info dense, no filler_

Refonte templates emails avec design système et logo EggscuseMe

# Current State
_What is actively being worked on right now? Pending tasks not yet completed. Immediate next steps._

**TÂCHE ENTIÈREMENT TERMINÉE - Tous les emails sont bilingues FR/EN**

L'utilisateur a demandé que TOUS les emails contiennent les deux langues (section française + section anglaise) dans le MÊME email. Cette demande a été entièrement satisfaite.

**Résumé final:**
- 7 templates emails convertis en bilingue (5 auth + 2 métier)
- 1 nouveau composant `EmailLanguageSeparator` créé
- TypeScript compile sans erreur (`pnpm ts` OK)
- Prêt pour prévisualisation avec `pnpm email`

**Structure bilingue appliquée à chaque email:**
1. Section FR complète (titre, texte, boutons, InfoBox en français)
2. `<EmailLanguageSeparator />` - séparateur visuel "ENGLISH VERSION BELOW"
3. Section EN complète (titre, texte, boutons, InfoBox en anglais)
4. Preview bilingue (ex: "Votre code / Your code")

**Aucune action en attente - projet emails terminé**

# Task specification
_What did the user ask to build? Any design decisions or other explanatory context_

Créer des templates d'emails professionnels pour EggscuseMe avec:
1. **Design système cohérent** - utiliser les couleurs et tokens CSS de l'app (couleurs fraîcheur: vert/jaune/orange/rouge)
2. **Logo visible** - afficher le logo/mascotte dans tous les emails
3. **URL publique pour images** - site déployé sur https://eggscuseme.app/ (images accessibles)
4. **Page test admin** - ajouter les 5 nouveaux templates auth dans l'admin (actuellement 3 templates)
5. **Emails bilingues** - TOUS les emails doivent contenir une section française ET une section anglaise dans le MÊME email

**Décisions de design prises:**
- Templates dédiés (pas modifier MarkdownEmail) pour personnalisation maximale
- Moods Eggy automatiques: happy=OTP, chef=reset, waving=change/verify, sad=delete
- Code OTP: affichage en grand, fond doré, police monospace 36px, lettres espacées 8px
- Delete account: bouton rouge (couleur `expired` #EF4444) au lieu du doré standard
- **Structure bilingue implémentée:**
  1. Section française complète (titre FR, texte FR, boutons FR)
  2. Séparateur visuel `EmailLanguageSeparator` avec texte "ENGLISH VERSION BELOW"
  3. Section anglaise complète (titre EN, texte EN, boutons EN)
  - Preview email aussi bilingue (ex: "Votre code / Your code")
  - Éléments dynamiques (OTP, URLs) répétés dans les deux sections

# Files and Functions
_What are the important files? In short, what do they contain and why are they relevant?_

**Config auth avec emails (src/lib/auth.ts) - COMPLET:**
- Ligne 8-12: imports (ChangeEmailEmail, DeleteAccountEmail, EmailVerificationEmail, OtpSigninEmail, ResetPasswordEmail)
- Ligne 131-137: `sendResetPassword` → `ResetPasswordEmail({ user, url })` - Sujet: "Reinitialisation de votre mot de passe"
- Ligne 142-148: `sendChangeEmailVerification` → `ChangeEmailEmail({ newEmail, url })` - Sujet: "Confirmez votre nouvelle adresse email"
- Ligne 152-159: `sendDeleteAccountVerification` → `DeleteAccountEmail({ user, url })` - Sujet: "Confirmation de suppression de compte"
- Ligne 163-169: `sendVerificationEmail` → `EmailVerificationEmail({ user, url })` - Sujet: "Bienvenue sur EggscuseMe ! Verifiez votre email"
- Ligne 173-183: `sendVerificationOTP` → `OtpSigninEmail({ email, otp, autoLoginUrl })` - Sujet: "{otp} - Votre code de connexion"

**NOUVEAUX Templates emails créés (TOUS BILINGUES FR/EN):**
- `emails/otp-signin.email.tsx` - Code OTP 6 chiffres en grand (fond doré, monospace 36px). Preview: "{otp} - Votre code de connexion / Your sign-in code"
- `emails/reset-password.email.tsx` - Réinit mot de passe avec EmailInfoBox sécurité FR+EN. Preview: "Reinitialisation de mot de passe / Password reset"
- `emails/change-email.email.tsx` - Confirmation nouvel email (affiche newEmail dans EmailInfoBox). Preview: "Confirmez votre nouvelle adresse email / Confirm your new email"
- `emails/delete-account.email.tsx` - Suppression compte avec bouton ROUGE #EF4444, liste conséquences FR+EN. Preview: "Confirmation de suppression de compte / Account deletion confirmation"
- `emails/email-verification.email.tsx` - Bienvenue avec liste avantages FR (benefitsFr) + EN (benefitsEn) dans tableaux séparés. Preview: "Bienvenue sur EggscuseMe ! / Welcome to EggscuseMe!"

**Templates emails métier (MAINTENANT BILINGUES):**
- `emails/fridge-invitation.email.tsx` - Invitation frigo (Eggy mood: waving)
  - benefitsFr/benefitsEn: 2 tableaux d'avantages séparés
  - expiresFormattedFr/En: dates formatées avec Intl.DateTimeFormat
  - Preview: "{inviterName} vous invite... / {inviterName} invites you..."
- `emails/expiration-warning.email.tsx` - Alertes fraîcheur (Eggy mood: chef)
  - getDaysLeftTextFr()/getDaysLeftTextEn(): fonctions séparées pour texte jours restants
  - Liste oeufs dupliquée avec keys `fr-${index}` et `en-${index}`
  - Preview: "{totalEggs} oeufs vont expirer / eggs expiring soon"
- `emails/markdown.email.tsx` - Emails génériques, utilise `EmailLayout` (sans branding, PAS bilingue)

**Composants partagés (`emails/utils/`):**
- `eggscuseme-email-layout.tsx` - Layout brandé: logo, Eggy, bordure dorée, footer
  - Ligne 71-75: fallback baseUrl vers prodUrl si localhost
  - Exporte: `EmailButton`, `EmailInfoBox`, `EmailLanguageSeparator`, `EMAIL_COLORS`
  - `EmailLanguageSeparator` (lignes 245-288): séparateur visuel bilingue avec texte "ENGLISH VERSION BELOW"
    - Structure: table avec 3 colonnes (bordure | texte | bordure)
    - Style: bordures `borderLight`, texte 12px bold textMuted, margin 32px 0
- `email-eggy.tsx` - Mascotte avec 5 moods: happy, sad, chef, waving, celebrating
- `email-layout.tsx` - Layout générique simple (utilisé par MarkdownEmail)

**EMAIL_COLORS (dans eggscuseme-email-layout.tsx):**
```typescript
background: "#FDFBF7", primary: "#FFC800", text: "#2D2D2D",
freshExtra: "#22C55E", fresh: "#EAB308", cookThoroughly: "#F97316", expired: "#EF4444"
```

**Images:**
- `/public/images/logo.svg` - Logo principal (32x32 dans emails)
- `/public/images/eggy/eggy-{mood}.svg` - SVGs mascotte (5 fichiers)
- URL en prod: `https://eggscuseme.app/images/logo.svg`

**Envoi emails:**
- `src/lib/mail/send-email.ts` - Fonction principale sendEmail()
- `src/lib/mail/resend.ts` - Config Resend avec proxy dev

**Admin test:**
- `/app/admin/emails/page.tsx` - Page de test
- `/app/admin/emails/_components/email-templates-list.tsx` - COMPLET:
  - Imports (lignes 30-37): 5 nouvelles actions sendTest*
  - Schémas Zod (lignes 59-83): OtpSigninSchema, ResetPasswordSchema, ChangeEmailSchema, DeleteAccountSchema, EmailVerificationSchema
  - 5 composants formulaires (lignes 356-693): OtpSigninForm, ResetPasswordForm, ChangeEmailForm, DeleteAccountForm, EmailVerificationForm
  - Tableau templates (lignes 702-753): 8 templates total (3 métier + 5 auth)
  - Conditions JSX (lignes 785-799): rendu des 5 nouveaux formulaires
- `/app/admin/_actions/admin-emails.action.ts` - COMPLET:
  - Existantes: `sendTestFridgeInvitationAction`, `sendTestExpirationWarningAction`, `sendTestMarkdownAction`
  - Nouvelles ajoutées (lignes 147-324): `sendTestOtpSigninAction`, `sendTestResetPasswordAction`, `sendTestChangeEmailAction`, `sendTestDeleteAccountAction`, `sendTestEmailVerificationAction`

**Traductions:**
- `/messages/fr.json` - ✅ COMPLET - Ajouté lignes 100-129 dans `admin.emails.templates.*`
- `/messages/en.json` - ✅ COMPLET - Ajouté lignes 100-129 dans `admin.emails.templates.*`

**Traductions EN ajoutées:**
```json
"otpSignin": { "name": "OTP Sign-in Code", "description": "Email with 6-digit code for passwordless sign-in", "email": "Recipient email", "success": "OTP email sent!" },
"resetPassword": { "name": "Reset Password", "userName": "User name", "success": "Reset email sent!" },
"changeEmail": { "name": "Change Email", "newEmail": "New email address", "success": "Verification email sent!" },
"deleteAccount": { "name": "Delete Account", "userName": "User name", "success": "Confirmation email sent!" },
"emailVerification": { "name": "Email Verification", "userName": "User name", "success": "Verification email sent!" }
```

# Workflow
_What bash commands are usually run and in what order? How to interpret their output if not obvious?_

- `pnpm email` - serveur de développement pour prévisualiser les emails React Email

# Errors & Corrections
_Errors encountered and how they were fixed. What did the user correct? What approaches failed and should not be tried again?_

**Erreurs TS auth.ts - TOUTES CORRIGÉES:**
- 5 erreurs "Cannot find name 'MarkdownEmail'" → Toutes résolues en remplaçant par les nouveaux templates
- 5 warnings ESLint "unused imports" → Tous résolus, les imports sont maintenant utilisés

**Ordre de correction effectué:**
1. Ajout imports des 5 nouveaux templates
2. Edit `sendResetPassword` → ResetPasswordEmail
3. Edit `sendChangeEmailVerification` → ChangeEmailEmail
4. Edit `sendDeleteAccountVerification` → DeleteAccountEmail
5. Edit `sendVerificationEmail` → EmailVerificationEmail
6. Edit `sendVerificationOTP` → OtpSigninEmail (avec création variable `autoLoginUrl`)

**Erreur TS expiration-warning.email.tsx - CORRIGÉE:**
- Erreur ligne 62: `Type 'number' is not assignable to type 'ReactNode & string'`
- Dans le composant Preview: `{totalEggs} oeufs vont expirer / {totalEggs} eggs expiring soon`
- Solution appliquée: Utiliser template literal complet `{\`${totalEggs} oeufs vont expirer / ${totalEggs} eggs expiring soon - ${fridgeName}\`}`

# Codebase and System Documentation
_What are the important system components? How do they work/fit together?_

**Architecture emails:**
```
sendEmail() → resendMailAdapter.send() → Resend API
                                      → Mock en dev si pas de RESEND_API_KEY
```

**Composants EmailButton et EmailInfoBox:**
- Button: fond doré #FFC800, texte #2D2D2D, padding 12px 24px, radius 8px
- InfoBox: fond rgba(255, 200, 0, 0.1), padding 16px, radius 8px

**EmailEggy tailles:** sm (48x58), md (80x96), lg (120x144)

**Gestion URL images emails:**
Les templates utilisent `baseUrl` (env.NEXT_PUBLIC_BASE_URL ou SiteConfig.prodUrl) + chemin image.
En prod: https://eggscuseme.app/images/logo.svg
En dev: fallback sur prodUrl pour que les images fonctionnent

# Learnings
_What has worked well? What has not? What to avoid? Do not duplicate items from other sections_

**Bon:**
- Le design système emails est déjà bien structuré avec EMAIL_COLORS centralisés
- Les SVG Eggy avec différents moods ajoutent de la personnalité
- Layout EggscuseMeEmailLayout réutilisable avec props eggyMood, showEggy, footerText
- Le fallback URL (localhost → prodUrl) est déjà implémenté dans EggscuseMeEmailLayout
- Site déjà déployé sur https://eggscuseme.app avec images accessibles

**Architecture découverte:**
- `MarkdownEmail` → `EmailLayout` (générique, pas de branding)
- `FridgeInvitationEmail` / `ExpirationWarningEmail` → `EggscuseMeEmailLayout` (brandé)
- Tous les emails Better Auth passent par MarkdownEmail = pas de branding

**À noter:**
- Pour les images dans emails: besoin d'URL absolue publique (pas de chemin relatif)
- Emails dev marqués [DEV] automatiquement dans le sujet
- Le MarkdownEmail utilise liens en couleur indigo #6366f1 (pas les couleurs EggscuseMe)
- Prévisualisation locale: `pnpm email` lance serveur React Email sur localhost:3000

**Ordre d'exécution recommandé par l'agent Plan:**
1. Templates emails (5 fichiers, peuvent être créés en parallèle)
2. Actions admin (dépend des templates)
3. Traductions (parallèle avec actions)
4. Page admin (dépend actions + traductions)
5. Modification auth.ts (en dernier pour basculer vers nouveaux templates)

# Key results
_If the user asked a specific output such as an answer to a question, a table, or other document, repeat the exact result here_

**7 templates d'emails BILINGUES (FR+EN dans chaque email):**

| Template | Fichier | Mood Eggy | Preview bilingue |
|----------|---------|-----------|------------------|
| Code OTP | `emails/otp-signin.email.tsx` | happy | "{otp} - Votre code / Your sign-in code" |
| Reset Password | `emails/reset-password.email.tsx` | chef | "Reinitialisation / Password reset" |
| Change Email | `emails/change-email.email.tsx` | waving | "Confirmez / Confirm your new email" |
| Delete Account | `emails/delete-account.email.tsx` | sad | "Suppression / Account deletion" |
| Email Verification | `emails/email-verification.email.tsx` | waving | "Bienvenue / Welcome to EggscuseMe!" |
| Fridge Invitation | `emails/fridge-invitation.email.tsx` | waving | "{name} vous invite / invites you" |
| Expiration Warning | `emails/expiration-warning.email.tsx` | chef | "{n} oeufs / eggs expiring soon" |

**Structure bilingue de chaque email:**
1. Section FR complète (titre, texte, boutons en français)
2. `<EmailLanguageSeparator />` avec "ENGLISH VERSION BELOW"
3. Section EN complète (titre, texte, boutons en anglais)

**Fichiers modifiés:**
- `src/lib/auth.ts` - Emails auth utilisent nouveaux templates
- `emails/utils/eggscuseme-email-layout.tsx` - Ajout `EmailLanguageSeparator`
- `app/admin/_actions/admin-emails.action.ts` - 5 nouvelles actions test
- `app/admin/emails/_components/email-templates-list.tsx` - 5 nouveaux formulaires
- `messages/fr.json` et `messages/en.json` - Traductions FR/EN

**Design appliqué:** Fond beige #FDFBF7, accent doré #FFC800, bordures dorées, mascotte Eggy contextuelle, boutons CTA dorés (rouge pour suppression), logo depuis https://eggscuseme.app

# Worklog
_Step by step, what was attempted, done? Very terse summary for each step_

**PHASE 3 - MODIFICATION BILINGUE (étapes 48-63):**
48. Demande utilisateur: "Tous les mails avec section anglais et française"
49. Créé todo list pour 7 templates bilingues (5 auth + 2 métier)
50. Lu eggscuseme-email-layout.tsx pour ajouter séparateur
51. Ajouté `EmailLanguageSeparator` (lignes 245-288) - table 3 colonnes avec texte "ENGLISH VERSION BELOW"
52. Réécrit `otp-signin.email.tsx` bilingue (FR + séparateur + EN, code OTP affiché 2x)
53. Réécrit `reset-password.email.tsx` bilingue (EmailInfoBox sécurité FR+EN)
54. Réécrit `change-email.email.tsx` bilingue (newEmail dans 2 EmailInfoBox séparées)
55. Réécrit `delete-account.email.tsx` bilingue (bouton rouge #EF4444 2x, liste conséquences FR+EN)
56. Réécrit `email-verification.email.tsx` bilingue (benefitsFr + benefitsEn = 2 arrays séparés)
57. Réécrit `fridge-invitation.email.tsx` bilingue (expiresFormattedFr/En avec Intl.DateTimeFormat fr-FR/en-US)
58. Réécrit `expiration-warning.email.tsx` bilingue (getDaysLeftTextFr/En fonctions, keys `fr-${index}` et `en-${index}`)
59. Erreur TS détectée ligne 62: totalEggs (number) dans composant Preview - incompatible avec ReactNode & string
60. Fix appliqué: template literal complet `{\`${totalEggs} oeufs vont expirer / ${totalEggs} eggs expiring soon - ${fridgeName}\`}`
61. Exécuté `pnpm ts` - compilation réussie, 0 erreur
62. MAJ todo list finale - 8/8 tâches completed
63. Résumé final présenté à l'utilisateur avec tableau récapitulatif des 7 templates bilingues

**PHASE 2 - CRÉATION 5 TEMPLATES AUTH + ADMIN (étapes 14-47):**
- 14-16: Créé 5 templates auth (otp, reset, change, delete, verify) basés sur fridge-invitation
- 17-25: Modifié auth.ts pour utiliser nouveaux templates (5 remplacements MarkdownEmail)
- 26-29: Ajouté 5 actions test dans admin-emails.action.ts (lignes 138-324)
- 30-36: Ajouté 5 formulaires + schémas dans email-templates-list.tsx
- 37-42: Ajouté traductions FR+EN dans messages/*.json
- 43-47: Vérification TS/ESLint OK, résumé final

**PHASE 1 - EXPLORATION + PLAN (étapes 1-13):**
- 1-8: Exploration codebase (3 agents), identifié 3 templates existants, MarkdownEmail sans branding
- 9-13: Questions clarification, agent Plan, fichier plan approuvé
