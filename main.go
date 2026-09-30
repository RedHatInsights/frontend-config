package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "ok")
	})

	log.Println("frontend-config listening on :8000")
	log.Fatal(http.ListenAndServe(":8000", nil))
}
