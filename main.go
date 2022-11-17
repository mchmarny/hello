package main

import (
	"fmt"
	"log"
	"os"
)

const (
	PORT_KEY        = "PORT"
	ADDRESS_DEFAULT = ":8080"
)

var (
	version = "v0.0.1-default"
)

func main() {
	fmt.Printf("starting server %s", version)
	address := ADDRESS_DEFAULT
	if val, ok := os.LookupEnv(PORT_KEY); ok {
		address = fmt.Sprintf(":%s", val)
	}

	r := makeRouter()

	if err := r.Run(address); err != nil {
		log.Fatalf("error starting server: %v", err)
	}
}
