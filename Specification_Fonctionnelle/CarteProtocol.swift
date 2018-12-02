
protocol CarteProtocol {

	init()

	init(type_carte : String, puissance_attaque : Int, pv_defensif : Int, pv_offensif : Int, statut : Int, portee : (Int,Int)[])

	func puissance_attaque() -> Int
	func puissance_attaque(p_att : Int)

	func pv_defensif() -> Int
	func pv_defensif(p_def : Int)

	func pv_offensif() -> Int
	func pv_offensif(p_off : Int)

	func statut() -> Int
	func statut(statut : Int)

	func portee() -> (Int,Int)[]
	func portee(p : (Int,Int)[])

	func type_carte() -> String
	func type_carte(type : String)


	func degats_subis() -> Int
	// degats_subis Ou bien ResetDegats ???
	func degats_subis(degats : Int)

	func attaque(carte_attaqee : CarteProtocol) -> Int


}
