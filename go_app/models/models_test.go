package model

import (
	"fmt"
	"testing"
)

// TestFindPhysicianBy test the function FindPhysicianBy()
func TestFindPhysicianBy(t *testing.T) {
	p, err := FindPhysicianBy("name", "TuoHua")
	if err != nil {
		t.Error(err)
	}
	if p.Name != "TuoHua" {
		t.Error("FindPhysicianBy error!")
	}
}

// TestFindPhysician test the function FindPhysician()
func TestFindPhysician(t *testing.T) {
	p, err := FindPhysicianBy("name", "TuoHua")
	if err != nil {
		t.Error(err)
	}
	pp, err := FindPhysician(p.Id)
	if err != nil {
		t.Error(err)
	}
	if p.Name != pp.Name {
		t.Error("FindPhysician error!")
	}
}

// TestPhysicianGetPatients test the method GetPatients()
func TestPhysicianGetPatients(t *testing.T) {
	p, err := FindPhysicianBy("name", "TuoHua")
	if err != nil {
		t.Error(err)
	}
	err = p.GetPatients()
	if err != nil {
		t.Error(err)
	}
	if len(p.Patients) != 4 {
		t.Error("Physician's GetPatients error!")
	}
}

// TestPhysicianIncludesWhere test the function PhysicianIncludesWhere()
func TestPhysicianIncludesWhere(t *testing.T) {
	ps, err := PhysicianIncludesWhere([]string{"patients"}, "name = ?", "TuoHua")
	if err != nil {
		t.Error(err)
	}
	if len(ps[0].Patients) != 4 {
		t.Error("PhysicianIncludesWhere error!")
	}
}

// TestPhysicianCreateValidationFail will fail:
// The name "Jack" can't pass string length restrict validation: 4 is not range in 6..15
func TestPhysicianCreateValidationFail(t *testing.T) {
	p := &Physician{Name: "Jack", Introduction: "Jack is a new Doctor."}
	_, err := p.Create()
	if err != nil {
		fmt.Printf("Create Physician Failure: %v\n", err)
	} else {
		t.Error("String length validation failed")
	}
	_, err = FindPhysicianBy("name", "Jack")
	if err != nil {
		fmt.Println("No New Physician is created")
	}
}

// TestPhysicianCreateValidationPass will pass:
// The name "New Doctor" can pass string length restrict validation: 10 is in range 6..15
func TestPhysicianCreateValidationPass(t *testing.T) {
	p := &Physician{Name: "New Doctor", Introduction: "A new doctor is welcomed!"}
	id, err := p.Create()
	if err != nil {
		t.Error(err)
	}
	p, err = FindPhysician(id)
	if err != nil {
		t.Error("Create physician failure")
	}
}

// TestPhysicianDestroy test the function PhysicianDestroyBy()
func TestDestroyPhysician(t *testing.T) {
	p, err := FindPhysicianBy("name", "New Doctor")
	if err != nil {
		t.Error("Create physician failure")
	}
	fmt.Printf("New Physician is: %v\n", p.Name)
	err = DestroyPhysician(p.Id)
	if err != nil {
		t.Error("Delete physician failure")
	}
	fmt.Printf("A physician %v is deleted\n", p.Name)
}

// TestFirstPhysician test the function FirstPhysician()
func TestFirstPhysician(t *testing.T) {
	p, err := FirstPhysician()
	if err != nil {
		t.Error("Find first physician failure")
	}
	if p.Name == "ShizhenLi" {
		fmt.Printf("The First Physician is: %v\n", p.Name)
	} else {
		t.Error("The First Physician record is not right")
	}
}

// TestFirstPhysicians test the function FirstPhysician()
func TestFirstPhysicians(t *testing.T) {
	ps, err := FirstPhysicians(3)
	if err != nil {
		t.Error("Get the First 3 Physicians failed")
	}
	if len(ps) == 3 {
		fmt.Println("Get the First 3 Physicians success")
	} else {
		t.Error("Get the First 3 Physicians failed")
	}
}

// TestLastPhysician test the function LastPhysician()
func TestLastPhysician(t *testing.T) {
	p, err := LastPhysician()
	if err != nil {
		t.Error("Find Last physician failure")
	}
	if p.Name == "TuoHua" {
		fmt.Printf("The Last Physician is: %v\n", p.Name)
	} else {
		t.Error("The Last Physician record is not right")
	}
}

// TestLastPhysicians test the function LastPhysician()
func TestLastPhysicians(t *testing.T) {
	ps, err := LastPhysicians(3)
	if err != nil {
		t.Error("Get the Last 3 Physicians failed")
	}
	if len(ps) == 3 {
		fmt.Println("Get the Last 3 Physicians success")
	} else {
		t.Error("Get the Last 3 Physicians failed")
	}
}

// TestPhysicianCount test the function PhysicianCount
func TestPhysicianCount(t *testing.T) {
	c, err := PhysicianCount()
	if err != nil {
		t.Error("Phsicians count error")
	}
	if c == 4 {
		fmt.Println("Get Physician count success")
	} else {
		t.Error("Get Physician count failed")
	}
}

// TestPhysicianCountWhere test the function PhysicianCountWhere
func TestPhysicianCountWhere(t *testing.T) {
	c, err := PhysicianCountWhere("name = ?", "TuoHua")
	if err != nil {
		t.Error("Phsicians count error")
	}
	if c == 1 {
		fmt.Println("Test PhysicianCountWhere success")
	} else {
		t.Error("Test PhysicianCountWhere success failed")
	}
}
