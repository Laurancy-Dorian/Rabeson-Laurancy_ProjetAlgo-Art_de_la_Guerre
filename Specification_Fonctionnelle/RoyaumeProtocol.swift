protocol RoyaumeProtocol {
  init()

  mutating func ajouter_royaume(carte : CarteProtocol)
  mutating func retirer_royaume(carte : CarteProtocol) -> CarteProtocol // TODO On renvoie ?

  func est_vide() -> Bool

  func count_royaume() -> Int
}
