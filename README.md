# bhasha_ai

Minimal Flutter app with **Supabase email OTP** authentication, a deep indigo and soft white UI, and **Bengali-first** typography ([Noto Sans Bengali](https://fonts.google.com/noto/specimen/Noto+Sans+Bengali) via `google_fonts`).

Repository: [https://github.com/Swakhar/bhasha_ai](https://github.com/Swakhar/bhasha_ai)

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (stable channel)
- A [Supabase](https://supabase.com/) project with **Authentication → Providers → Email** enabled and **OTP / magic link** style sign-in configured for your use case

## Clone and run

```bash
git clone https://github.com/Swakhar/bhasha_ai.git
cd bhasha_ai
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Replace `YOUR_PROJECT` and `YOUR_ANON_KEY` with values from **Supabase → Project Settings → API**.

The app reads configuration only from these `dart-define` values (see `lib/config/supabase_config.dart`). **Do not commit** keys or `.env` files containing secrets.

## Supabase (email OTP)

1. In the Supabase dashboard, enable the **Email** provider for auth.
2. Ensure your project allows the OTP / email sign-in flow you expect (check auth email templates and rate limits in the dashboard).
3. Run the app with the `dart-define` flags above so `Supabase.initialize` succeeds.

## Project structure

| Path | Purpose |
|------|---------|
| `lib/config/` | App configuration (Supabase URL / anon key from build flags) |
| `lib/services/` | Auth and future data services |
| `lib/models/` | Data models |
| `lib/views/` | Screens (login, home) |
| `lib/widgets/` | Reusable UI |
| `lib/theme/` | Colors and `ThemeData` |

## Tests

```bash
flutter test
```

## License

Specify your license in this repository when you are ready (for example MIT or Apache-2.0).
