package supplychain

import (
	"gno.land/p/demo/ownable"
)

type Product struct {
	*ownable.Ownable
	ID          uint64
	Name        string
	Description string
	RMSids      []uint64 // RawMaterialSuppliers IDs
	MANid       uint64   // Manufacturer ID
	DISid       uint64   // Distributor ID
	RETid       uint64   // Retailer ID
	Stage       STAGE
}

func NewProduct(id uint64, name, description string) *Product {
	return &Product{
		Ownable:     ownable.New(),
		ID:          id,
		Name:        name,
		Description: description,
		Stage:       Init,
	}
}

func (p *Product) ShowStage() string {
	switch p.Stage {
	case Init:
		return "Product is in initial stage"
	case RawMaterialSupply:
		return "Raw Material Supply Stage"
	case Manufacture:
		return "Manufacturing Stage"
	case Distribution:
		return "Distribution Stage"
	case Retail:
		return "Retail Stage"
	case Sold:
		return "Product Sold"
	default:
		return "Unknown Stage"
	}
}

func (p *Product) NextStage() {
	switch p.Stage {
	case Init:
		p.Stage = RawMaterialSupply
	case RawMaterialSupply:
		p.Stage = Manufacture
	case Manufacture:
		p.Stage = Distribution
	case Distribution:
		p.Stage = Retail
	case Retail:
		p.Stage = Sold
	}
}

func (p *Product) ResetStage() {
	p.Stage = Init
}
