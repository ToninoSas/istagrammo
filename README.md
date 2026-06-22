# Istagrammo — un clone di Instagram

**Istagrammo** è un'app social multipiattaforma in stile Instagram, sviluppata con
**Flutter** e **Firebase**. Supporta post con immagini e "tweet" testuali, un grafo
sociale (follow / follower), like, commenti, profili e tema chiaro/scuro.

> Il branch predefinito è [`main_firebase`](https://github.com/ToninoSas/istagrammo/tree/main_firebase),
> l'implementazione completa basata su Firebase. Vedi [Branch](#branch) per le altre varianti.

## Funzionalità

- **Autenticazione** — registrazione e accesso con email e password (Firebase Auth)
- **Post con immagini** — carica una foto con una descrizione; modifica la descrizione o elimina il post
- **Tweet** — post di solo testo (senza immagine)
- **Like** — metti/togli like a post e commenti
- **Commenti** — aggiungi, metti like ed elimina i commenti di un post
- **Grafo sociale** — segui / smetti di seguire gli utenti; sfoglia i follower di un utente e le persone che segue
- **Ricerca** — trova utenti per username su tutta la base utenti
- **Profili** — visualizza post e tweet di un utente; modifica il tuo username, la bio e l'immagine del profilo (con ritaglio)
- **Tema** — passa tra modalità chiara e scura; la scelta viene salvata con `shared_preferences`

## Struttura dell'app

L'app è organizzata intorno a tre pagine principali, navigabili tramite una barra di navigazione in basso:

- **Home** — feed di post e tweet
- **Ricerca** — cerca altri utenti (riusata anche per elencare follower / seguiti)
- **Profilo** — i tuoi post, i tuoi tweet e la gestione del profilo

Lo stato è condiviso tramite due `ChangeNotifier` di `provider`:

- `user_provider` — i dati dell'utente attualmente loggato
- `theme_provider` — toggle del tema chiaro / scuro

## Stack tecnologico

- **Flutter** (Dart SDK `>=3.1.0 <4.0.0`)
- **Firebase**: `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_core`
- **Gestione dello stato**: `provider`
- **Media**: `image_picker`, `image_cropper`, `file_picker`
- **Varie**: `shared_preferences`, `uuid`, `intl`, `font_awesome_flutter`, `cupertino_icons`

Piattaforme configurate per Firebase: Android, iOS, macOS, Windows e Web.

## Struttura del progetto

```
lib/
├── main.dart                 # entry point + routing in base allo stato di autenticazione
├── app_layout.dart           # barra di navigazione + le tre pagine principali
├── firebase_options.dart     # configurazione Firebase generata
├── models/                   # modelli dati User, Post, Comment
├── providers/                # user_provider, theme_provider
├── resources/                # metodi auth / firestore / storage
├── screens/                  # login, register, home, search, profile, upload, edit, comments
├── widgets/                  # post_card, twitt_card, comment_card, post_thumb, ...
└── utils/                    # stili e helper
```

## Come iniziare

### Prerequisiti

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `>=3.1.0`)
- Un progetto [Firebase](https://console.firebase.google.com/) con **Authentication**
  (Email/Password), **Cloud Firestore** e **Storage** abilitati

### Configurazione

```bash
# 1. Clona il repository
git clone https://github.com/ToninoSas/istagrammo.git
cd istagrammo

# 2. Installa le dipendenze
flutter pub get

# 3. Configura Firebase per il tuo progetto
#    (rigenera lib/firebase_options.dart e i file di configurazione delle piattaforme)
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Avvia l'app
flutter run
```

> `lib/firebase_options.dart` e i file Firebase specifici delle piattaforme sono legati a
> uno specifico progetto Firebase — esegui `flutterfire configure` per puntare l'app al tuo.

## Branch

| Branch | Descrizione |
|---|---|
| [`main_firebase`](https://github.com/ToninoSas/istagrammo/tree/main_firebase) | App completa basata su Firebase (predefinito) |
| [`custom-api-version`](https://github.com/ToninoSas/istagrammo/tree/custom-api-version) | Usa una API Flask personalizzata come backend |
| [`old_firebase_version`](https://github.com/ToninoSas/istagrammo/tree/old_firebase_version) | Implementazione Firebase precedente |
| [`supabase_version`](https://github.com/ToninoSas/istagrammo/tree/supabase_version) | Migrazione da Firebase a Supabase in corso (incompleta) |
