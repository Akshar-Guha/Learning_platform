#!/bin/bash
# Vercel Build Script for Flutter Web
# This script installs Flutter, generates .env, and builds the app

set -e  # Exit on error

echo "🔧 Installing Flutter SDK..."

# Install Flutter - use specific version for stability
git clone https://github.com/flutter/flutter.git -b 3.24.0 --depth 1 /tmp/flutter
export PATH="/tmp/flutter/bin:$PATH"

echo "📦 Flutter version:"
flutter --version

echo "🔧 Generating .env from Vercel environment variables..."

# Create .env file from Vercel environment variables
cat > .env <<EOF
SUPABASE_URL=${SUPABASE_URL}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
API_BASE_URL=${API_BASE_URL}
EOF

echo "✅ .env file created with:"
echo "   SUPABASE_URL: ${SUPABASE_URL:0:30}..."
echo "   SUPABASE_ANON_KEY: [SET]"
echo "   API_BASE_URL: ${API_BASE_URL}"

echo "📦 Installing Flutter dependencies..."
flutter pub get

echo "🏗️ Building Flutter web app (verbose mode)..."
flutter build web --release --verbose \
  --dart-define=SUPABASE_URL=${SUPABASE_URL} \
  --dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY} \
  --dart-define=API_BASE_URL=${API_BASE_URL} \
  2>&1 | tee /tmp/build_output.log || {
    echo "❌ Build failed. Last 100 lines of output:"
    tail -100 /tmp/build_output.log
    echo ""
    echo "Running analyze for additional diagnostics..."
    flutter analyze --no-fatal-infos 2>&1 || true
    exit 1
}

echo "✅ Build complete!"
