
// TODO bien definir ce qu'est x et y. Le front est 0, larriere est 1
protocol PlateauProtocol {
  init()

  mutating func ajouter_plateau(carte : CarteProtocol)
  mutating func retirer_plateau(carte : CarteProtocol) -> CarteProtocol // TODO verif si necessaire de return CarteProtocol

  func cartes_sur_plateau() -> CarteProtocol[]

  func position_carte(carte : CarteProtocol) -> (Int,Int)
  func carte_en_position(x : Int, y : Int) -> CarteProtocol?

  func est_occupee(x : Int, y : Int) -> Bool // TODO utile ? On a carte en position qui renvoie nil si y'en a pas

  mutating func reorganiser_plateau()

  func plateau_vide() -> Bool

  mutating func tuer(carte : CarteProtocol)

  func count_cartes_qui_peuvent_attaquer() -> Int

  func cartes_qui_peuvent_attaquer() -> CarteProtocol[]
}
