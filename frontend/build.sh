#!/bin/bash
# Vercel Build Script for Flutter Web
# This script generates the .env file from Vercel environment variables
# and then builds the Flutter web app

echo "🔧 Generating .env from Vercel environment variables..."

# Create .env file from Vercel environment variables
cat > .env << EOF
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

echo "🏗️ Building Flutter web app..."
flutter build web --release

echo "✅ Build complete!"
