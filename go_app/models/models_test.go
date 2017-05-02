package model

import (
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

// TestPhysicianIncludesWhere test the method PhysicianIncludesWhere()
func TestPhysicianIncludesWhere(t *testing.T) {
	ps, err := PhysicianIncludesWhere([]string{"patients"}, "name = ?", "TuoHua")
	if err != nil {
		t.Error(err)
	}
	if len(ps[0].Patients) != 4 {
		t.Error("PhysicianIncludesWhere error!")
	}
}
