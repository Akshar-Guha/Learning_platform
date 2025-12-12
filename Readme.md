# Project Antigravity: Atomic Accountability Squads

## 1. Project Goal
To solve "Learning in Isolation" for college students by creating cooperative "Squads" that track habits and streaks. The core value is **proven discipline** (Consistency Score) which can be monetized via a "Recruiter Dashboard."

## 2. Tech Stack (The "Free Cloud" Standard)
* **Mobile App:** Flutter (Dart) - *Targeting 60fps/Impeller Engine*.
* **Backend:** Go (Golang) - *Hosted on Render (Free)*.
* **Database:** Supabase (PostgreSQL + Auth + Realtime).
* **Event Bus:** NATS JetStream - *For "Exactly-Once" messaging*.
* **AI Brain:** Groq API (Llama 3) - *Free Tier High-Speed Inference*.
* **Payments:** Stripe - *For "Commitment Stakes" & Recruiter Access*.|

## 3. Deployment Strategy
* **Web:** `flutter build web` -> Vercel (Production URL).
* **Mobile:** APK (Optional for later phases).|

## 4. Revenue Model
1.  **Commitment Stakes:** Users pledge money; get it back if they keep the streak.
2.  **Verified Talent:** Recruiters pay to access students with high "Consistency Scores."