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

func (p *Producer) AddProduct(product *Product) {
	if err := p.CallerIsOwner(); err != nil {
		panic(err)
	}
	p.Products = append(p.Products, product)
}
