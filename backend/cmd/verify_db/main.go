package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/lib/pq"
)

// Config - Hardcoded for verification
const (
	ProjectRef = "txwiedhokoujvvnxqaua"
	Region     = "ap-south-1"
	DBUser     = "postgres"
	DBPass     = "SuperSimplePass2025"
	DBName     = "postgres"
)

func main() {
	log.SetFlags(0)
	fmt.Println("\n🔍 DIAGNOSTIC DATABASE CONNECTION TEST")
	fmt.Println("========================================")

	// Config
	// user := DBUser                                          // "antigravity_api"
	userWithRef := fmt.Sprintf("%s.%s", DBUser, ProjectRef) // "antigravity_api.txw..."

	// 1. SKIP DIRECT (IPv6 issues locally usually)
	/*
		fmt.Printf("\n[1] DIRECT Connection (db.%s.supabase.co:5432)\n", ProjectRef)
		directHost := fmt.Sprintf("db.%s.supabase.co", ProjectRef)

		fmt.Printf("    -> Attempting user '%s'...\n", user)
		url1 := fmt.Sprintf("postgres://%s:%s@%s:5432/%s?sslmode=require", user, DBPass, directHost, DBName)
		if err := testConnection(url1); err != nil {
			fmt.Printf("       ❌ FAIL: %v\n", err)
		} else {
			fmt.Printf("       ✅ SUCCESS!\n")
		}

		// Try user.ref format on Direct too (sometimes works/required)
		fmt.Printf("    -> Attempting user '%s'...\n", userWithRef)
		url1b := fmt.Sprintf("postgres://%s:%s@%s:5432/%s?sslmode=require", userWithRef, DBPass, directHost, DBName)
		if err := testConnection(url1b); err != nil {
			fmt.Printf("       ❌ FAIL: %v\n", err)
		} else {
			fmt.Printf("       ✅ SUCCESS!\n")
		}
	*/

	// 2. TEST POOLER SESSION (IPv4)
	fmt.Printf("\n[2] POOLER SESSION (aws-0-%s.pooler...:5432)\n", Region)
	poolerHost := fmt.Sprintf("aws-0-%s.pooler.supabase.com", Region)

	// Must use user.ref
	fmt.Printf("    -> Attempting user '%s'...\n", userWithRef)
	url2 := fmt.Sprintf("postgres://%s:%s@%s:5432/%s?sslmode=require", userWithRef, DBPass, poolerHost, DBName)
	if err := testConnection(url2); err != nil {
		fmt.Printf("       ❌ FAIL: %v\n", err)
	} else {
		fmt.Printf("       ✅ SUCCESS! (Use this for Render)\n")
	}

	// Try PLAIN user on Pooler (Special case for postgres user?)
	fmt.Printf("    -> Attempting plain user '%s'...\n", DBUser)
	url2b := fmt.Sprintf("postgres://%s:%s@%s:5432/%s?sslmode=require", DBUser, DBPass, poolerHost, DBName)
	if err := testConnection(url2b); err != nil {
		fmt.Printf("       ❌ FAIL: %v\n", err)
	} else {
		fmt.Printf("       ✅ SUCCESS! (PLAIN USER WORKS!)\n")
	}

	// 3. TEST POOLER TRANSACTION (IPv4)
	fmt.Printf("\n[3] POOLER TRANSACTION (aws-0-%s.pooler...:6543)\n", Region)

	fmt.Printf("    -> Attempting user '%s'...\n", userWithRef)
	url3 := fmt.Sprintf("postgres://%s:%s@%s:6543/%s?sslmode=require", userWithRef, DBPass, poolerHost, DBName)
	if err := testConnection(url3); err != nil {
		fmt.Printf("       ❌ FAIL: %v\n", err)
	} else {
		fmt.Printf("       ✅ SUCCESS! (Alternate for Render)\n")
	}

	fmt.Println("\n========================================")
}

func testConnection(connStr string) error {
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return fmt.Errorf("open: %v", err)
	}
	defer db.Close()

	// Short timeout
	// db.SetConnMaxLifetime(5 * time.Second)

	if err := db.Ping(); err != nil {
		return fmt.Errorf("%v", err)
	}
	return nil
}
