package main

import (
	"flag"

	c "./controllers"
	"github.com/gin-gonic/gin"
)

func main() {
	// The app will run on port 4000 by default, you can custom it with the flag -port
	servePort := flag.String("port", "4000", "Http Server Port")
	flag.Parse()

	// Here we are instantiating the router
	r := gin.Default()
	// Switch to "release" mode in production
	// gin.SetMode(gin.ReleaseMode)
	r.LoadHTMLGlob("views/*")
	// Create a static assets router
	// r.Static("/assets", "./public/assets")
	r.StaticFile("/favicon.ico", "./public/favicon.ico")
	// Then we bind some route to some handler(controller action)
	r.GET("/", c.HomeHandler)
	// Let's start the server
	r.Run(":" + *servePort)
}
