package handler

import (
	"encoding/json"
	"log"
	"net/http"
)

// respondJSON writes a JSON response with the given status code and data
func respondJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		log.Printf("Error encoding response: %v", err)
	}
}

// respondError writes a JSON error response and logs the error to stdout
func respondError(w http.ResponseWriter, status int, code, message string) {
	// Log the error for backend debugging (visible in Render logs)
	log.Printf("[API ERROR] Status: %d, Code: %s, Message: %s", status, code, message)

	respondJSON(w, status, map[string]string{
		"error": message,
		"code":  code,
	})
}
