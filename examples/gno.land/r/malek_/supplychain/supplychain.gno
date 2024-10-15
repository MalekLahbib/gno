package supplychain

import (
	"bytes"
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ufmt"
	scp "gno.land/p/malek_/supplychain"
)

const (
	Owner std.Address = "g10ahumypepd2qcrau7kahv8q78f7jcdns5tn54a"
)

var (
	ProducersCtr uint64 = 0 // counter for producers
	ProductCtr   uint64 = 0 // counter for products
	RmsCtr       uint64 = 0 // counter for raw material suppliers
	ManCtr       uint64 = 0 // counter for manufacturers
	DisCtr       uint64 = 0 // counter for distributors
	RetCtr       uint64 = 0 // counter for retailers
	Producers    *avl.Tree
	RMS          map[uint64]*scp.RawMaterialSupplier
	MAN          map[uint64]*scp.Manufacturer
	DIS          map[uint64]*scp.Distributor
	RET          map[uint64]*scp.Retailer
)

func init() {
	Producers = avl.NewTree()
	RMS = make(map[uint64]*scp.RawMaterialSupplier, 0)
	MAN = make(map[uint64]*scp.Manufacturer, 0)
	DIS = make(map[uint64]*scp.Distributor, 0)
	RET = make(map[uint64]*scp.Retailer, 0)
}

func NewProducer(name, postaladdress string) {
	caller := std.PrevRealm().Addr().String()
	Producers.Set(caller, scp.NewProducer(ProducersCtr, name, postaladdress))
	ProducersCtr++
}

func AddProduct(name, description string) {
	caller := std.PrevRealm().Addr().String()
	producer, ok := Producers.Get(caller)
	if !ok {
		panic("Producer not found")
	}
	producer.(*scp.Producer).AddProduct(name, description)
}

// func NewRMS(name, postaladdress string) {
// 	RMS[RmsCtr] = &scp.RawMaterialSupplier{RmsCtr, name, postaladdress}
// 	RmsCtr++
// }

// func NewManufacturer(name, postaladdress string) {
// 	MAN[ManCtr] = &scp.Manufacturer{ManCtr, name, postaladdress}
// 	ManCtr++
// }

// func NewDistributor(name, postaladdress string) {
// 	DIS[DisCtr] = &scp.Distributor{DisCtr, name, postaladdress}
// 	DisCtr++
// }

//	func NewRetailer(name, postaladdress string) {
//		RET[RetCtr] = &scp.Retailer{RetCtr, name, postaladdress}
//		RetCtr++
//	}
func Render(path string) string {
	if path == "" {
		return renderHomepage()
	}

	return "unknown page"
}

func renderHomepage() string {
	var b bytes.Buffer

	b.WriteString("# Welcome to SupplyChain\n\n")

	if Producers.Size() == 0 {
		b.WriteString("### No Producers to display!")
		return b.String()
	}
	ctr := 0
	// Iterate through AVL tree
	Producers.Iterate("", "", func(key string, value interface{}) bool {
		pr := value.(*scp.Producer)

		b.WriteString(
			ufmt.Sprintf(
				"## Producer #%d: %s\n",
				ctr,
				pr.Name,
			),
		)

		b.WriteString(
			ufmt.Sprintf(
				"#### Postal address : %s\n",
				pr.PostalAddress,
			),
		)

		for i, p := range pr.Products {
			b.WriteString(
				ufmt.Sprintf(
					"#### Product #%d name: %s\n",
					i,
					p.Name,
				),
			)
			b.WriteString(
				ufmt.Sprintf(
					"#### description: %s\n",
					p.Description,
				),
			)
		}

		b.WriteString("\n")
		ctr++
		return false
	})

	return b.String()
}
