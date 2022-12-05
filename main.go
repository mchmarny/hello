package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

const (
	PORT_KEY         = "PORT"
	ADDRESS_DEFAULT  = ":8080"
	SHUTDOWN_TIMEOUT = 3
)

var (
	version = "v0.0.1-default"
)

func main() {
	fmt.Printf("Starting server %s...\n", version)
	address := ADDRESS_DEFAULT
	if val, ok := os.LookupEnv(PORT_KEY); ok {
		address = fmt.Sprintf(":%s", val)
	}

	r := makeRouter()

	srv := &http.Server{
		Addr:    address,
		Handler: r,
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("Listen: %s\n", err)
		}
	}()

	// Wait for interrupt signal to gracefully shutdown the server.
	quit := make(chan os.Signal, 1)

	// kill (no param) default send syscall.SIGTERM
	// kill -2 is syscall.SIGINT
	// kill -9 is syscall.SIGKILL but can't be caught, so don't need add it
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	fmt.Println("\nShutting down server...")

	// The context is used to inform the server it has n seconds to finish
	// the request it is currently handling.
	ctx, cancel := context.WithTimeout(context.Background(), SHUTDOWN_TIMEOUT*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		log.Fatal("Server forced to shutdown:", err)
	}

	fmt.Println("Server exiting")
}
