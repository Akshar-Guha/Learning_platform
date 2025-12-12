# ANTIGRAVITY PROJECT STATE
**Date:** 2025-12-12
**Phase:** 2 (Logic Engine)
**Status:** ACTIVE
**Next Agent:** ALPHA

---

## 0. PROJECT MANIFESTO (The "Why")
**Goal:** To solve "Learning in Isolation" for college students. We are not building a generic to-do list; we are building a **Digital Campus** based on "Atomic Habits" and "Social Facilitation."
**Core Philosophy:**
1.  **Squads over Solo:** Students join fixed groups of 4. Success is collective.
2.  **Proven Discipline:** We generate a "Consistency Score" (0-100) based on verified streaks, which becomes a hireable metric for recruiters.
3.  **Body Doubling:** Real-time presence ("I see Akshar studying") reduces procrastination without the high bandwidth of video calls.

## 1. TECH STACK (The "Free Cloud" Standard)
* **Frontend:** Flutter Web (Deployed on **Vercel**). *Must use `canvaskit` for 60fps performance.*
* **Backend:** Go (Golang) Microservices (Deployed on **Render** Free Tier).
* **Database:** Supabase (PostgreSQL + Auth + Realtime). *RLS Policies Mandatory.*
* **Event Bus:** NATS JetStream (Deployed on **Fly.io** or Managed Free Tier). *Handles async communication between Go and AI.*
* **AI Brain:** Groq API (Llama 3 70B). *Low-latency inference for "Nudge" logic.*
* **Payments:** Stripe. *Uses "Auth & Capture" for holding user stakes.*

## 2. DETAILED FEATURE SPECIFICATIONS (The "Truth")

### A. The Squad Engine
* **Mechanic:** Users form squads of exactly **4 members**.
* **Logic:** A squad exists as long as members maintain a collective streak.
* **Interaction:** No debating. Chat is for support and "check-ins" only.
* **Invite System:** Deep links (`antigravity.app/join/xyz`) to fill empty slots.

### B. Body Doubling (The "Work" Mode)
* **UI:** A "Focus Room" dashboard.
* **Function:** When a user clicks "Start Session", their avatar glows green for squadmates.
* **Protocol:** Uses Supabase Realtime (WebSockets) to broadcast status. No video streaming (too expensive). Just "Presence".

### C. The AI NudgeBot (Agent Gamma's Domain)
* **Trigger:** Listens to NATS stream `log.created` and `squad.chat`.
* **Persona:** "Cooperative Gym Buddy." Never argumentative.
* **Logic:**
    * If streak broken: *Empathetic encouragement.*
    * If 3 AM login: *"Go to sleep, retention happens during REM."* (Health focus).

### D. The Revenue Model (The Economy)
* **1. Commitment Stakes (B2C):** Users pledge ₹500. Stripe holds the fund.
    * *Success:* Funds released back.
    * *Failure:* Funds captured. (Logic handled by Go Backend).
* **2. Recruiter Dashboard (B2B):**
    * Companies pay to query the `consistency_score` table.
    * *Metric:* `(Days Active / Total Days) * Streak Multiplier`.

## 3. MASTER ROADMAP (The Backlog)
*(Omega must pick from here)*

### Phase 1: Foundation ✅ COMPLETE
1.  **[DONE] Core Foundation:** Supabase Auth, User Profile DB, Basic Vercel Deployment.
2.  **[DONE] Squad Architecture:** `squads` and `squad_members` tables. Create/Join/Leave logic API.
3.  **[DONE] Real-time Presence:** "Who is online" using Supabase Realtime.
4.  **[DONE] The Streak Engine:** Go Service to calculate daily streaks.
5.  **[DONE] Nudge System Scaffold:** DB + API ready, but NATS/Groq not wired.

### Phase 2: Logic Engine ✅ COMPLETE
6.  **[DONE] NATS Event Bus:** Embedded JetStream with event-driven architecture.
7.  **[DONE] Groq AI Integration:** Nudge Subscriber wired to Groq for AI message generation.

### Phase 3: Economy (Deferred)
8.  **Stripe Escrow:** Backend logic for Commitment Stakes.
9.  **The Verified Resume:** Public profile page with Consistency Score graph.

---

## 4. CURRENT TASK (Managed by Omega)

**Feature:** Phase 2 - NATS Event Bus + Groq AI Integration
**Goal:** Build a proper event-driven architecture using NATS JetStream for async communication, and wire the Groq API to generate AI-powered nudge messages.

---

### A. NATS JetStream Infrastructure (For Gamma)

**1. Deployment Options:**
| Option | Pros | Cons |
|--------|------|------|
| **Fly.io** | Free tier, persistent | Requires setup |
| **Synadia Cloud** | Managed NATS | Limited free tier |
| **Embedded NATS** | No external dep | Loses messages on restart |

**Recommended:** Use **Synadia Cloud** free tier (10K msgs/month) OR embed NATS in Go binary for dev.

**2. Stream Configuration:**
```
Stream Name: ANTIGRAVITY
Subjects:
  - events.activity.logged     # User checked in or completed focus
  - events.streak.risk         # Streak is at risk (triggered by cron)
  - events.streak.broken       # Streak was broken
  - events.squad.joined        # User joined a squad
  - events.squad.left          # User left a squad
Retention: WorkQueue (consumed once)
Max Age: 24h
```

**3. Environment Variables:**
```
NATS_URL=nats://your-nats-server:4222
NATS_CREDS_FILE=/path/to/creds.creds  # For Synadia
```

---

### B. Go Backend Changes (For Alpha)

**1. Event Publisher (`internal/eventbus/publisher.go`):**
```go
type Event struct {
    Type      string          `json:"type"`
    UserID    string          `json:"user_id"`
    Payload   json.RawMessage `json:"payload"`
    Timestamp time.Time       `json:"timestamp"`
}

func (p *Publisher) Publish(ctx context.Context, subject string, event Event) error
```

**2. Event Subscribers (`internal/eventbus/subscribers/`):**
| Subscriber | Listens To | Action |
|------------|------------|--------|
| `NudgeSubscriber` | `events.streak.risk` | Calls Groq → Creates notification |
| `ActivitySubscriber` | `events.activity.logged` | Updates streak cache |

**3. Integration Points (Where to Publish Events):**
| Location | Event |
|----------|-------|
| `streak_service.go` (cron job) | `events.streak.risk` when `missed_days >= 1` |
| `streak_service.go` (log activity) | `events.activity.logged` |
| `squad_service.go` (join) | `events.squad.joined` |
| `focus_service.go` (stop session) | `events.activity.logged` |

---

### C. Groq AI Integration (For Alpha)

**1. Groq Client (`internal/ai/groq_client.go`):**
```go
type GroqClient struct {
    apiKey  string
    baseURL string
    model   string // "llama3-70b-8192"
}

func (c *GroqClient) GenerateNudge(ctx context.Context, prompt string) (string, error)
```

**2. Prompt Engineering:**
```
System: You are a supportive gym buddy for a study app. 
Rules:
- Be brief (under 50 words)
- Use lowercase
- No lectures
- Be empathetic, not pushy

User Context:
- Name: {display_name}
- Current Streak: {current_streak} days
- Last Active: {last_active_date}
- Missed Days: {missed_days}

Generate a personalized nudge message.
```

**3. Environment Variables:**
```
GROQ_API_KEY=your-groq-api-key-here
GROQ_MODEL=llama3-70b-8192
```

---

### D. Event Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        EVENT FLOW                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [Streak Cron Job]                                              │
│        │                                                        │
│        ▼                                                        │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │  Detect At   │────▶│    NATS      │────▶│    Nudge     │    │
│  │  Risk Users  │     │  JetStream   │     │  Subscriber  │    │
│  └──────────────┘     └──────────────┘     └──────────────┘    │
│                              │                    │             │
│                              │                    ▼             │
│                              │            ┌──────────────┐      │
│                              │            │  Groq API    │      │
│                              │            │  (Llama 3)   │      │
│                              │            └──────────────┘      │
│                              │                    │             │
│                              │                    ▼             │
│                              │            ┌──────────────┐      │
│                              │            │ notifications │      │
│                              │            │    table     │      │
│                              │            └──────────────┘      │
│                              │                    │             │
│                              │                    ▼             │
│                              │            ┌──────────────┐      │
│                              │            │  Supabase    │      │
│                              │            │  Realtime    │      │
│                              │            └──────────────┘      │
│                              │                    │             │
│                              │                    ▼             │
│                              │            ┌──────────────┐      │
│                              │            │  Flutter UI  │      │
│                              │            │  (Toast)     │      │
│                              └───────────▶└──────────────┘      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

### ✅ ACCEPTANCE CRITERIA
1.  NATS JetStream is running (locally or cloud).
2.  Go backend connects to NATS on startup (graceful fallback if unavailable).
3.  Streak cron publishes `events.streak.risk` for at-risk users.
4.  `NudgeSubscriber` consumes events and calls Groq API.
5.  AI-generated message is saved to `notifications` table.
6.  User receives nudge via Supabase Realtime within 5 seconds.
7.  Nudge messages vary (non-deterministic) and match persona.

---

### 🚦 DELEGATION
* **GAMMA:** (NEXT) Set up NATS (Synadia Cloud or Fly.io). Provision `NATS_URL`.
* **ALPHA:** (After Gamma) Implement publisher, subscribers, Groq client, wire events.
* **BETA:** (No changes) - Notification UI already built.

---

## 5. ARCHITECT REGISTRY (Managed by Alpha)

### ✅ SQL Schema (Supabase)

**1. Profiles (`001_create_profiles.sql`)**
```sql
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    is_edu_verified BOOLEAN DEFAULT FALSE,
    timezone TEXT DEFAULT 'UTC',
    consistency_score INTEGER DEFAULT 0 CHECK (consistency_score >= 0 AND consistency_score <= 100),
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- Trigger: on_auth_user_created (Auto-syncs Auth -> Public Profile)
```

**2. Squads (`002_create_squads.sql`)**
```sql
CREATE TABLE public.squads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    invite_code TEXT NOT NULL UNIQUE, -- 8 char alphanumeric
    owner_id UUID REFERENCES profiles(id),
    max_members INTEGER DEFAULT 4,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.squad_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    squad_id UUID REFERENCES squads(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    role TEXT CHECK (role IN ('owner', 'member')),
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(squad_id, user_id)
);
```

### ✅ API Contracts (Go Backend)

**Feature 1: Profiles**
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `GET` | `/api/v1/profile/me` | JWT | Get my full profile |
| `PATCH` | `/api/v1/profile/me` | JWT | Update display_name/timezone |
| `GET` | `/api/v1/profile/{id}` | JWT | Get public profile of another user |

**Feature 2: Squads**
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `GET` | `/api/v1/squads` | JWT | List my squads |
| `POST` | `/api/v1/squads` | JWT | Create new squad |
| `POST` | `/api/v1/squads/join` | JWT | Join via `{invite_code}` |
| `GET` | `/api/v1/squads/{id}` | JWT | Get squad details + members |
| `DELETE` | `/api/v1/squads/{id}/members/{uid}` | JWT | Kick/Leave squad |
| `POST` | `/api/v1/squads/{id}/regenerate-code` | JWT | Rotate invite code |

**Feature 3: Focus Sessions (Body Doubling)**
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/api/v1/focus/start` | JWT | Start focus session |
| `POST` | `/api/v1/focus/stop` | JWT | End current session |
| `GET` | `/api/v1/focus/active/{squad_id}` | JWT | Get active focusers |
| `GET` | `/api/v1/focus/history/{squad_id}` | JWT | Last 7 days history |

**SQL Schema: Focus Sessions (`003_create_focus_sessions.sql`)**
```sql
CREATE TABLE public.focus_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id),
    squad_id UUID REFERENCES squads(id),
    started_at TIMESTAMPTZ DEFAULT NOW(),
    ended_at TIMESTAMPTZ, -- NULL = active
    duration_minutes INTEGER GENERATED ALWAYS AS (...) STORED
);
-- RLS: Squad members SELECT, own INSERT/UPDATE, no DELETE
-- Realtime: Enable for INSERT/UPDATE events
```

**Feature 4: The Streak Engine (`005_create_activity_logs.sql`)**
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/api/v1/streaks/log` | JWT | Log manual check-in activity |
| `GET` | `/api/v1/streaks/me` | JWT | Get my full streak data + 30 day history |
| `GET` | `/api/v1/streaks/{user_id}` | JWT | Get another user's public streak (no history) |
| `GET` | `/api/v1/streaks/leaderboard` | JWT | Top 50 users by current streak |
| `POST` | `/api/v1/streaks/calculate` | Service Role | Trigger recalculation (cron only) |

**SQL Schema: Activity Logs (`005_create_activity_logs.sql`)**
```sql
CREATE TABLE public.activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    activity_type TEXT CHECK (activity_type IN ('focus_session', 'squad_join', 'manual_checkin')),
    activity_date DATE NOT NULL, -- Timezone-aware from profiles.timezone
    logged_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB DEFAULT '{}'::jsonb,
    UNIQUE(user_id, activity_date) -- One activity per day
);

-- Functions:
-- log_daily_activity(user_id, activity_type, metadata) -> Smart insert (idempotent)
-- calculate_streak(user_id) -> {current_streak, longest_streak, last_active_date}
-- get_consistency_score(user_id, days) -> INTEGER (0-100)

-- Trigger: on_activity_logged -> Auto-updates profiles.current_streak/consistency_score
-- RLS: Users SELECT/INSERT own logs, service role INSERT any, no UPDATE/DELETE
```

**Feature 5: The Nudge System (`006_create_notifications.sql`)**
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `GET` | `/api/v1/notifications` | JWT | List recent notifications |
| `PATCH` | `/api/v1/notifications/{id}/read` | JWT | Mark as read |

**SQL Schema: Notifications**
```sql
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES profiles,
    type TEXT, -- nudge, streak_alert
    title TEXT,
    message TEXT,
    is_read BOOLEAN,
    created_at TIMESTAMPTZ,
    metadata JSONB
);
-- RLS: User SELECT/UPDATE own, Service Role INSERT only.
-- Realtime: Enabled for INSERT events.
```

## 6. FRONTEND REGISTRY (Managed by Beta)

### ✅ Flutter Web Structure
* **Core:** Riverpod (`ProviderScope`), GoRouter (`ShellRoute`), Supabase Auth (`AuthState`).
* **Theme:** Premium Dark Mode (CanvasKit/Impeller optimized).
* **Screens Built:**
    * `Splash` (Auth check + timeout)
    * `Login` / `Signup` (Email + .edu badge)
    * `Home` (Dashboard + Bottom Nav)
    * `Profile` (Editable details + Stats)
    * `Squads` (List, Create, Join, Detail)

### ✅ UI Components
* **SquadCard:** Stacked avatars, member count, gradient backgrounds.
* **MemberTile:** Role badges (Owner/Member), kick actions.
* **InviteCodeWidget:** Copy-to-clipboard functionality.
* **Animations:** `flutter_animate` used for route transitions and list entry.

## 7. OPS REGISTRY (Managed by Gamma)
### ✅ Phase 1 Foundation - COMPLETE
* **Env Variables:** `.env` files configured with valid Supabase credentials (220-char anon key)
* **Migrations:** Applied `001` (profiles), `002` (squads), `003` (focus_sessions), `004` (RLS fix)
* **Backend:** Go server running on `localhost:8080` with all API endpoints
* **Frontend:** Flutter app running with Supabase + Realtime initialized
* **Realtime:** `focus_sessions` table added to `supabase_realtime` publication
* **Docker:** Multi-stage `Dockerfile` & `docker-compose.yml` ready
* **Vercel:** `vercel.json` configured for SPA routing
* **Cron:** GitHub Action `.github/workflows/daily_streak_cron.yml` created for daily recalc
* **NATS JetStream:** Embedded server in `eventbus/embedded_nats.go` (no external deployment needed for dev)

---

### 🐛 BUG-001: Splash Screen Infinite Loading & UI Overflow
**Date:** 2025-12-11 | **Status:** ✅ FIXED | **Severity:** Critical

**Symptoms:**
- App stuck on splash screen
- Login Screen bottom content (Button) was overflowed/hidden

**Root Cause:**
1. Race condition in `AuthNotifier` (Fixed with flag)
2. GoRouter redirect logic incorrect (Fixed)
3. `LoginScreen` used fixed height `SizedBox`, causing overflow (Fixed with `CustomScrollView`)

**Fix Applied:**
- Verified Login Screen is accessible and scrollable.

---

### 🐛 BUG-002: Login Failure / Startup Crash
*   **Status:** 🔴 BLOCKED (Environment Failure)
*   **Priority:** Critical
*   **Description:** Application fails to render on the web, freezing on the native "Loading Antigravity..." splash screen. This persists even after fixing previous logic bugs.
*   **Investigation Findings:**
    *   **Startup Freeze:** The app gets stuck on `index.html` loader.
    *   **Renderer Failure:** Both `canvaskit` and `html` renderers fail to paint the first frame.
    *   **Isolation Test:** A minimal "Hello World" `MaterialApp` also FAILED to render (resulted in a blank white screen after manually removing splash).
    *   **Logs:** Console logs show Flutter framework exceptions during widget mounting/building, but lack specific error messages.
    *   **Environment:** `flutter clean` and process restarts did not resolve the issue. Setup appears fundamentally corrupted on the local machine for Web.
*   **Action Required:** Manual environment reset (delete build folders, restart host, verify Flutter SDK).

**Responsible Agent:** ANTIGRAVITY (Delta)
```