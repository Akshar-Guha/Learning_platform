package config

import (
	"os"
	"strings"
)

// Config holds all configuration for the application
type Config struct {
	DatabaseURL       string
	SupabaseURL       string
	SupabaseAnonKey   string
	SupabaseJWTSecret string
	AllowedOrigins    []string
	Port              string
	NatsURL           string
	NatsCredsFile     string // For Synadia Cloud authentication
	GroqAPIKey        string
}

// Load reads configuration from environment variables
func Load() *Config {
	allowedOrigins := os.Getenv("ALLOWED_ORIGINS")
	if allowedOrigins == "" {
		allowedOrigins = "http://localhost:3000,http://localhost:5173"
	}

	return &Config{
		DatabaseURL:       getEnvOrPanic("DATABASE_URL"),
		SupabaseURL:       getEnvOrPanic("SUPABASE_URL"),
		SupabaseAnonKey:   getEnvOrPanic("SUPABASE_ANON_KEY"),
		SupabaseJWTSecret: getEnvOrPanic("SUPABASE_JWT_SECRET"),
		AllowedOrigins:    strings.Split(allowedOrigins, ","),
		Port:              getEnvOrDefault("PORT", "8080"),
		NatsURL:           getEnvOrDefault("NATS_URL", "nats://localhost:4222"),
		NatsCredsFile:     getEnvOrDefault("NATS_CREDS_FILE", ""), // For Synadia Cloud
		GroqAPIKey:        getEnvOrDefault("GROQ_API_KEY", ""),
	}
}

func getEnvOrPanic(key string) string {
	value := os.Getenv(key)
	if value == "" {
		panic("Missing required environment variable: " + key)
	}
	return value
}

func getEnvOrDefault(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}
