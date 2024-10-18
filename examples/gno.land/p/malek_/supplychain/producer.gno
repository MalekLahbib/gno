package supplychain

import (
	"gno.land/p/demo/ownable"
)

type Producer struct {
	*ownable.Ownable
	ID            uint64
	Name          string
	PostalAddress string

	Products      []*Product
	RMSs          []*RawMaterialSupplier
	Manufacturers []*Manufacturer
	Distributors  []*Distributor
	Retailers     []*Retailer
}

func NewProducer(id uint64, name, postalAddress string) *Producer {
	return &Producer{
		Ownable:       ownable.New(),
		ID:            id,
		Name:          name,
		PostalAddress: postalAddress,
		Products:      make([]*Product, 0),
	}
}

func (p *Producer) AddProduct(name, description string) {
	if err := p.CallerIsOwner(); err != nil {
		panic(err)
	}

	p.Products = append(p.Products, NewProduct(uint64(len(p.Products)), name, description))
}

func (p *Producer) AddSupplier(name, postalAddress string) {
	if err := p.CallerIsOwner(); err != nil {
		panic(err)
	}

	p.RMSs = append(p.RMSs, &RawMaterialSupplier{
		ID:            uint64(len(p.RMSs)),
		Name:          name,
		PostalAddress: postalAddress,
	})
}

func (p *Producer) AddManufacturer(name, postalAddress string) {
	if err := p.CallerIsOwner(); err != nil {
		panic(err)
	}

	p.Manufacturers = append(p.Manufacturers, &Manufacturer{
		ID:            uint64(len(p.Manufacturers)),
		Name:          name,
		PostalAddress: postalAddress,
	})
}

func (p *Producer) AddDistributor(name, postalAddress string) {
	if err := p.CallerIsOwner(); err != nil {
		panic(err)
	}

	p.Distributors = append(p.Distributors, &Distributor{
		ID:            uint64(len(p.Distributors)),
		Name:          name,
		PostalAddress: postalAddress,
	})
}

func (p *Producer) AddRetailer(name, postalAddress string) {
	if err := p.CallerIsOwner(); err != nil {
		panic(err)
	}

	p.Retailers = append(p.Retailers, &Retailer{
		ID:            uint64(len(p.Retailers)),
		Name:          name,
		PostalAddress: postalAddress,
	})
}
