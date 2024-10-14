package supplychain

import "testing"

func TestNewProduct(t *testing.T) {
	id := uint64(1)
	pr := NewProduct(id, "name", "description")
	println(pr.ID, pr.Name, pr.Description, pr.Stage, pr.ShowStage())
	pr.NextStage()
	println(pr.ID, pr.Name, pr.Description, pr.ShowStage())
	pr.NextStage()
	println(pr.ID, pr.Name, pr.Description, pr.ShowStage())
	pr.NextStage()
	println(pr.ID, pr.Name, pr.Description, pr.ShowStage())
	pr.NextStage()
	println(pr.ID, pr.Name, pr.Description, pr.ShowStage())
	pr.ResetStage()
	println(pr.ID, pr.Name, pr.Description, pr.ShowStage())
}
