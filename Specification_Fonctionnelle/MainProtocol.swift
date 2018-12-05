/* MainProtocol (ou La Main) represente la collection qui contiendra des CarteProtocol (Cartes)
  Une MainProtocol possede les caracteristiques suivantes :
    On doit pouvoir ajouter des cartes a La Main
    On doit pouvoir retirer des cartes a La Main
    On doit pouvoir savoir le nombre de cartes dans La Main
*/

public protocol MainProtocol: Sequence {

    /*
      init : -> MainProtocol
      Creee une Main vide
    */
    public init()

    public func make_iterator()

    /*
      ajouter_main : MainProtocol x CarteProtocol -> MainProtocol
      Param : la carte a ajouter
      Pre :
      Post : la carte est ajoutee a La Main
    */
    public mutating func ajouter_main(carte: CarteProtocol)

    /*
      retirer_main : MainProtocol x CarteProtocl -> MainProtocol x CarteProtocol
      Param : la carte a retirer
      Pre :
      Post : renvoie la carte retiree si elle est retiree
    */
    public mutating func retirer_main(carte: CarteProtocol) -> CarteProtocol // TODO verif si on renvoie vraiment vu qu'on la passe en parametre


    /*
      cartes_en_main : MainProtocol -> MainProtocol x CarteProtocol[]
      Donne un tableau de Cartes qui sont contenues dans la main
      Pre :
      Post : retourne un tableau de CarteProtocol
    */
    public func cartes_en_main() -> [CarteProtocol]

    /*
      count_main : MainProtocol -> MainProtocol x Int
      Pre :
      Post : retourne le nombre de carte dans la main
    */
    public func count_main() -> Int

    /*
      est_vide : MainProtocol -> MainProtocol x Bool
      Pre :
      Post : retourne vrai si la main est vide
    */
    public func est_vide() -> Bool

}

public protocol MainProtocolIterator: IteratorProtocol {

    /*
      next : MainProtocolIterator -> MainProtocol x CarteProtocol?
    */
    public func next() -> CarteProtocol? 
}