package controller

import (
	"html/template"
	"net/http"
	// you can import models
	//m "../models"
)

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	// you can use model functions to do CRUD
	//
	// user, _ := m.FindUser(1)
	// u, err := json.Marshal(user)
	// if err != nil {
	// 	log.Printf("JSON encoding error: %v\n", err)
	// 	u = []byte("Get data error!")
	// }

	type Greeting struct {
		Name  string
		Words string
	}
	greeting := Greeting{Name: "Rubyist", Words: "Welcome to GoOnRails!"}
	t, _ := template.ParseFiles("views/index.tmpl")
	t.Execute(w, greeting)
}
