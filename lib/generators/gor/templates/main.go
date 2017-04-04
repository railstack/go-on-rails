package main

import (
	"flag"
	"log"
	"net/http"
	"os"

	c "./controllers"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
)

func main() {
	// The app will run on port 3000 by default, you can custom it with the flag -port
	servePort := flag.String("port", "3000", "Http Server Port")
	flag.Parse()
	log.Printf("The application starting on the port: [%v]\n", *servePort)

	// Here we are instantiating the gorilla/mux router
	r := mux.NewRouter()
	// Then we bind some route to some handler(controller action)
	r.HandleFunc("/", c.HomeHandler)
	// Create a static assets router
	r.PathPrefix("/public/").Handler(http.StripPrefix("/public/", http.FileServer(http.Dir("./public/"))))

	// Let's start the server
	http.ListenAndServe(":"+*servePort, handlers.LoggingHandler(os.Stdout, r))
}
