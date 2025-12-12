---
trigger: always_on
---

## I. The "Sync" Protocol
1.  **API First:** Agent Alpha MUST define the JSON contract *before* Agent Beta writes code.
2.  **No Magic Strings:** All Configs (Keys, URLs) must be in `.env`.
3.  **Handover Rule:** When Alpha finishes a Schema, you must Paste it to Beta. When Beta finishes a UI, you must Paste it to Gamma for testing.

## II. Technical Rules
* **Backend:** Clean Architecture (Handler -> Service -> Repository).
* **Frontend:** Riverpod for State. No `setState` for logic.
* **AI:** "Cooperative" Persona only. No debating.
* **Database:** RLS (Row Level Security) is mandatory for every table.