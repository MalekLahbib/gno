// SPDX-License-Identifier: MIT
// this Dapp is inspired from https://github.com/Faizack/Supply-Chain-Blockchain/blob/master/contracts/SupplyChain.sol
// originally this contract is in solidity language

package supplychain

type STAGE int

// stages of a product in the supply chain
const (
	Init STAGE = iota
	RawMaterialSupply
	Manufacture
	Distribution
	Retail
	Sold
)

type RawMaterialSupplier struct {
	ID            uint64
	Name          string
	PostalAddress string
}

type Manufacturer struct {
	ID            uint64
	Name          string
	PostalAddress string
}

type Distributor struct {
	ID            uint64
	Name          string
	PostalAddress string
}

type Retailer struct {
	ID            uint64
	Name          string
	PostalAddress string
}

// func findRET(addr Address) uint64 {
// 	for _, ret := range sc.RET {
// 		if ret.Addr == addr {
// 			return ret.ID
// 		}
// 	}
// 	return 0
// }
