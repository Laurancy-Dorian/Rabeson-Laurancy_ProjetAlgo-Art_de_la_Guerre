/*
  PlateauProtocol (ou Plateau) est une collection qui contiendra des CarteProtocol (ou Cartes)
  Un Plateau represente le champ de bataille de chaque joueur, on aura donc un plateau par joueur
  Regles du Plateau :
  Le Plateau compte deux lignes et trois colonnes
  Les deux lignes representent le Front et l'Arriere du Plateau
  Quand on ajoute des cartes au Plateau, elles doivent etre placees sur le Front
  Si le Front est occupe, on les place sur l'Arriere, sauf si le joueur
  souhaite remplacer une carte au Front par une autre carte

  Representation du Plateau :
  Dans ce programme, on considere le Plateau par rapport a des axes orthonormes x et y
  l'axe des x represente les colonnes, l'axe des y represente les lignes
  L'origine du repere se trouve a la premiere colonne du Front : la ligne de Front est a 0, la ligne Arriere est a 1
  La premiere colonne est a 0, la derniere est a 2

  Schema du Plateau pour un joueur :
  1   (0,0)   (1,0)   (2,0)   |   Front J
  0   (0,1)   (1,1)   (2,1)   |   Arriere J
        0       1       2

  Sur un Plateau d'un meme joueur on doit pouvoir :
    - y ajouter une carte
    - y retirer une carte
    - savoir les cartes presentes sur le Plateau
    - connaitre la position d'une carte
    - savoir quelle carte se trouve a une certaine position
    - savoir si une case du plateau est occupee par une carte
    - reorganiser les cartes du plateau par rapport aux regles du jeu
    - savoir si le Plateau est vide
    - tuer une carte 
    - savoir le nombre de carte qui peuvent encore attaquer lors d'un tour
    - savoir quelles sont les cartes qui peuvent encore attaquer lors d'un tour
*/
public protocol PlateauProtocol: Sequence {
    /*
      init : -> PlateauProtocol
      Creee un plateau vide
    */
    public init()
    /*
      ajouter_plateau : PlateauProtocol x CarteProtocol -> PlateauProtocol
      Ajoute une carte au Front
      Param : Carte a ajouter au plateau
      Pre : la case du plateau doit etre vide
      Post : la carte est ajoutee au plateau
    */
    public mutating func ajouter_plateau(carte: CarteProtocol) throws

    /*
      retirer_plateau : PlateauProtocol x CarteProtocol -> PlateauProtocol x CarteProtocol
      Retire une carte du plateau
      Param : carte a retirer
      Pre : la carte a retirer doit etre sur le plateau
      Post : la carte est retiree du plateau
    */
    public mutating func retirer_plateau(carte: CarteProtocol) -> CarteProtocol

    /*
      position_carte : PlateauProtocol x CarteProtocol -> PlateauProtocol x (Int, Int)
      Donne la position d'une carte sur le plateau
      Param : carte dont on veut savoir la position
      Pre : la carte doit etre sur le plateau
      Post : retourne un tuple d'entier representant la position de la carte
    */
    public func position_carte(carte: CarteProtocol) -> (Int, Int)

    /*
      carte_en_position : PlateauProtocol x Int x Int -> PlateauProtocol x CarteProtocol
      Donne la carte a une position du plateau
      Param : position x et position y en entiers
      Pre : x doit etre compris entre 0 et 2
      Pre : y doit etre compris entre 0 et 1
      Post : retourne la carte a la position donnee au parametre
    */
    public func carte_en_position(x: Int, y: Int) -> CarteProtocol?

    /*
      est_occupee : PlateauProtocol x Int x Int -> PlateauProtocol x Bool
      Verifie si une case est occupee par une carte
      Pre : x doit etre compris entre 0 et 2
      Pre : y doit etre compris entre 0 et 1
      Post : retourne true si la case est vide, false sinon
    */
    public func est_occupee(x: Int, y: Int) -> Bool // TODO utile ? On a carte en position qui renvoie nil si y'en a pas

    /*
      reorganiser_plateau : PlateauProtocol -> PlateauProtocol
      Reorganise les cartes sur le plateau
      On utilisera cette fonction lors des combats
      Si une carte sur le Front est retiree du plateau (mort ou capture) et qu'elle a une carte derriere elle sur l'Arriere
      la carte derriere est avancee

      Pre :
      Post : modifie le placement des cartes sur le plateau
    */
    public mutating func reorganiser_plateau()

    /*
      plateau_vide : PlateauProtocol -> PlateauProtocol x Bool
      Verifie si le tableau est vide
      Pre :
      Post : retourne true si le tableau est vide, false sinon
    */
    public func plateau_vide() -> Bool

    /*
      tuer : PlateauProtocol x CarteProtocol -> PlateauProtocol
      Supprime une carte du plateau
      Pre : la carte doit etre sur le plateau
      Post : supprime la carte du plateau si elle meurt
    */
    public mutating func tuer(carte: CarteProtocol)

    /*
      count_cartes_qui_peuvent_attaquer : PlateauProtocol -> PlateauProtocol x Int
      Compte les cartes qui peuvent encore attaquer sur le plateau
      Les cartes qui peuvent encore attaquer pendant un tour sont les cartes en
      position defensive (les cartes qui ont deja attaque sont en position offensive)

      Pre :
      Post : retourne le nombre entier de carte qui peuvent encore attaquer
    */
    public func count_cartes_qui_peuvent_attaquer() -> Int

    /*
      TODO
    */
    public func makeIterator() -> ItPlateauProtocol
}


/*
  ItPlateauProtocol est le protocol iterateur de PlateauProtocol, qui va donc parcourir la collection 
  de CarteProtocol du PlateauProtocol

  (rappel) Schema du Plateau :
     F1(0,0)   F2(1,0)   F3(2,0)   |   Front J
     A1(0,1)   A2(1,1)   A3(2,1)   |   Arriere J
    
  
  On veut parcourir le Plateau en partant de la Carte en position (0,0) jusqu'en position (3,1)
*/
public protocol ItPlateauProtocol : IteratorProtocol {

  /*
    next : ItPlateauProtocol -> ItPlateauProtocol x CarteProtocol?
    renvoie la prochaine carte dans la collection du Plateau
    Pre :
    Post : retourne la carte suivante dans la collection du Plateau, ou nil si on a atteint le fin de la collection
  */
  public func next() -> CarteProtocol?
}
