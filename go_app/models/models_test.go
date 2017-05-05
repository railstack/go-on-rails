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
	err := p.Create()
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
	err := p.Create()
	if err != nil {
		t.Error(err)
	}
	p, err = FindPhysicianBy("name", "New Doctor")
	if err != nil {
		t.Error("Create Physician Failure")
	}
}

// TestPhysicianDestroy test the function PhysicianDestroyBy()
func TestDestroyPhysician(t *testing.T) {
	p, err := FindPhysicianBy("name", "New Doctor")
	if err != nil {
		t.Error("Create Physician Failure")
	}
	fmt.Printf("New Physician is: %v\n", p.Name)
	err = DestroyPhysician(p.Id)
	if err != nil {
		t.Error("Delete Physician Failure")
	}
	fmt.Printf("A physician %v is deleted\n", p.Name)
}
