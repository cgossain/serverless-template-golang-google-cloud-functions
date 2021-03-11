package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/my-gcp-project-name/templateservice"
)

func main() {
	// Add paths to your functions
	router := http.NewServeMux()
	router.HandleFunc("/hello", templateservice.Hello)

	// Start the server
	fmt.Printf("Starting service on port 5000...\n")
	if err := http.ListenAndServe(":5000", router); err != nil {
		log.Fatal(err)
	}
}
