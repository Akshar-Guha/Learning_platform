package eventbus

import (
	"log"
	"time"

	"github.com/nats-io/nats-server/v2/server"
)

// EmbeddedNATSServer wraps an embedded NATS server for development
type EmbeddedNATSServer struct {
	server *server.Server
}

// StartEmbeddedNATS starts an embedded NATS server with JetStream enabled
// Use this for local development only. In production, use Synadia Cloud or dedicated NATS cluster.
func StartEmbeddedNATS() (*EmbeddedNATSServer, error) {
	opts := &server.Options{
		Host:           "127.0.0.1",
		Port:           4222,
		NoLog:          false,
		NoSigs:         true,
		MaxControlLine: 4096,
		JetStream:      true,
		StoreDir:       "./nats-data", // Persist JetStream data locally
	}

	ns, err := server.NewServer(opts)
	if err != nil {
		return nil, err
	}

	// Start the server in a goroutine
	go ns.Start()

	// Wait for server to be ready
	if !ns.ReadyForConnections(5 * time.Second) {
		return nil, err
	}

	log.Printf("✅ Embedded NATS server started on %s:%d (JetStream enabled)", opts.Host, opts.Port)

	return &EmbeddedNATSServer{server: ns}, nil
}

// Shutdown gracefully stops the embedded NATS server
func (e *EmbeddedNATSServer) Shutdown() {
	if e.server != nil {
		e.server.Shutdown()
		log.Println("🛑 Embedded NATS server stopped")
	}
}

// WaitForShutdown blocks until the server is shutdown
func (e *EmbeddedNATSServer) WaitForShutdown() {
	if e.server != nil {
		e.server.WaitForShutdown()
	}
}
