package model

import (
	"testing"
)

func TestFindPhysicianBy(t *testing.T) {
	p, err := FindPhysicianBy("name", "TuoHua")
	if err != nil {
		t.Error(err)
	}
	if p.Name != "TuoHua" {
		t.Error("FindPhysicianBy error!")
	}
}

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

func TestPhysicianIncludesWhere(t *testing.T) {
	ps, err := PhysicianIncludesWhere([]string{"patients"}, "name = ?", "TuoHua")
	if err != nil {
		t.Error(err)
	}
	if len(ps[0].Patients) != 4 {
		t.Error("PhysicianIncludesWhere error!")
	}
}
