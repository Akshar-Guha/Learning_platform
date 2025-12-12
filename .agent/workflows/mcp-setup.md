---
description: How to configure MCP servers for the Antigravity project
---

# MCP Server Setup Workflow

This workflow guides you through setting up all required MCP (Model Context Protocol) servers for the Antigravity Learning Platform.

## Prerequisites

1. **Node.js** installed (for running MCP servers via npx)
2. **API Keys/Tokens** from each service (obtained during setup)

---

## Step 1: Get Your API Keys

### 1.1 Supabase Access Token
1. Go to https://supabase.com/dashboard/account/tokens
2. Click "Generate new token"
3. Name it "Antigravity MCP"
4. Copy the token (you won't see it again!)

### 1.2 Stripe API Key
1. Go to https://dashboard.stripe.com/apikeys
2. Copy your **Secret key** (test mode for development)
3. For production, create a restricted key with only needed permissions

### 1.3 GitHub Personal Access Token
1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes: `repo`, `read:org`, `read:user`
4. Copy the token

### 1.4 Database URL (Optional)
1. Go to your Supabase project → Settings → Database
2. Copy the "Connection string" (URI format)
3. Replace `[YOUR-PASSWORD]` with your database password

---

## Step 2: Configure Your IDE

### For VS Code / Cursor

Open your **User Settings JSON** (Ctrl+Shift+P → "Preferences: Open User Settings (JSON)") and add:

```json
{
  "mcp": {
    "servers": {
      "supabase": {
        "command": "npx",
        "args": ["-y", "@supabase/mcp-server-supabase@latest", "--access-token", "YOUR_TOKEN"]
      },
      "stripe": {
        "command": "npx",
        "args": ["-y", "@stripe/mcp-server-stripe"],
        "env": {
          "STRIPE_API_KEY": "YOUR_STRIPE_SECRET_KEY"
        }
      },
      "github": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-github"],
        "env": {
          "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_YOUR_TOKEN"
        }
      },
      "fetch": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-fetch"]
      }
    }
  }
}
```

### For Claude Desktop App

Edit `%APPDATA%\Claude\claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server-supabase@latest", "--access-token", "YOUR_TOKEN"]
    },
    "stripe": {
      "command": "npx",
      "args": ["-y", "@stripe/mcp-server-stripe"],
      "env": {
        "STRIPE_API_KEY": "YOUR_STRIPE_SECRET_KEY"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_YOUR_TOKEN"
      }
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
```

---

## Step 3: Verify Setup

After configuring, restart your IDE and check that MCP servers are running:

1. **Supabase**: Should be able to query tables, run SQL
2. **Stripe**: Should be able to list products, create test payments
3. **GitHub**: Should be able to search repos, create issues
4. **Fetch**: Should be able to make HTTP requests

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "npx not found" | Install Node.js and restart terminal |
| "Permission denied" | Run terminal as administrator |
| "Invalid token" | Regenerate the API key |
| "Server failed to start" | Check if port is in use |

---

## Reference Files

- **Config Template**: `.agent/mcp-config.json`
- **Env Template**: `.agent/.env.mcp.template`
