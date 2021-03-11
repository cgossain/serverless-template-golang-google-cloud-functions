package templateservice

import (
	"fmt"
	"log"
	"net/http"

	"github.com/joho/godotenv"
)

func init() {
	// Load environment variables as early as possible (for local development).
	//
	// This is useful for local development.
	//
	// Just put you environment variables in the `.env` file.
	err := godotenv.Load()
	if err != nil {
		log.Print(err.Error())
	}
}

func Hello(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	if name == "" {
		name = "someone"
	}
	fmt.Fprintf(w, "Hello, %s!", name)
}
