///////////////////////////////
////// ART OF WAR - MAIN //////
///////////////////////////////


// ===== FONCTIONS DU MAIN ===== //


// -- Fonctions d'interface -- //

/*
  lire_input :  -> String?
  Lis la ligne courante et la renvoie sous forme de chaine de caractere
  Return : La ligne ecrite si la lecture a fonctionne, nil sinon
*/

func lire_input() -> String? {
    if let input = readLine() {
        return input;
    }
    return nil
}

/*
  input : String x [String] -> String

  Demande a l'utilisateur de saisir une expression dans le terminal
  Affiche un message et attend une reponse specifiqie. Continue a demandee tant qu'une reponse
  satisfaisante n'a pas ete saisie
  Parameters :
    - msg   Le message a afficher a l'utilsateur (Une question, une demande de saisie)
    - rep_possibles   Un tableau de String contenant l'ensemble des reponses attendues
  Return : La reponse selectionnee par l'utilisateur
*/
func input(_ msg: String = "Selectionnez votre reponse", _ rep_possibles: [String] = ["Y", "N"]) -> String {
    // Formate le message de demande sous la forme : Message (rep_attendue1, rep_attendue2 ...)
    let message_a_afficher: String
    var choix_reponse: String = ""
    if (!rep_possibles.isEmpty) {
        var virgule: String = ""

        for rep in rep_possibles {
            choix_reponse += virgule + rep
            virgule = ", "
        }

        message_a_afficher = msg + " (" + choix_reponse + ")"
    } else {
        message_a_afficher = msg
    }

    var reponse: String = ""
    // On recommence la boucle jusqu'a obtenir une reponse satisfaisante
    while (reponse == "") {
        // Affiche le message
        print(message_a_afficher)

        // Lit la reponse
        if let lecture_reponse = lire_input() {
            reponse = lecture_reponse

            // Verifie si la reponse est correcte
            var rep_correcte: Bool = false

            if (!rep_possibles.isEmpty) {
                for rep_attendue in rep_possibles {
                    if (reponse.lowercased() == rep_attendue.lowercased()) {
                        rep_correcte = true
                        reponse = rep_attendue
                    }
                }
            } else {
                rep_correcte = true
            }

            // Si la reponse n'est pas correcte, on affiche un message et on reinitialise la
            if (!rep_correcte) {
                print("Erreur dans votre reponse")
                print("Veuillez taper l'une des reponses attendues : " + choix_reponse)
                reponse = ""
            }
        } else {
            // S'il y a eu une erreur lors de la saisie, affiche ce message et redemande de saisir la reponse
            print("Erreur lors de la lecture, veuillez reessayer")
        }
    }

    return reponse;
}

// -- Fonctions d'affichage -- //

/*
    Renvoie les donnees de la carte passee en parametre sous la forme d'une chaine de caracteres
    Parameters :
        - c     La carte a afficher
*/
func str_carte_stats(_ c: Carte) -> String {
    var str: String = "";
    str += c.type_carte();
    str += "\t Attaque : " + c.puissance_attaque()
    if (c.statut() == 1) {
        str += "\t Statut : Offensif"
    } else {
        str += "\t Statut : Defensif"
    }
    str += "\t PV en statut Defensif : " + c.pv_defensif()
    str += "\t PV en statut Offensif : " + c.pv_offensif()

    str += "\t PV restants : " + c.pv_restants()

    return str;
}

/*
    Renvoie les donnes de la carte passee en parametre de facon reduite sous la forme d'une chaine de caracteres
    Forme : Type (Attaque, statut, PV_restants)
    Parameters :
        - c     La carte a afficher
*/
func str_carte_red(_ c: Carte) -> String {
    var str: String = "";
    str += c.type_carte()
    str += " (" + c.puissance_attaque()
    if (c.statut() == 1) {
        str += ", Off"
    } else {
        str += ", Def"
    }
    str += ", " + c.pv_restants() + ")"
    return str;
}

/*
    Renvoie les donnees du plateau sous forme de chaine de caractere
    Parameters :
        - plateau   Le plateau a afficher
*/
func str_plateau(_ plateau: Plateau) -> String {
    var str: String = ""
    for i in (0...1) {
        for j in (0...2) {
            if let c = plateau.carte_en_position(i, j) {
                str += str_carte_red(c) + "\t"
            } else {
                str += "VIDE \t"
            }

        }
        str+= "\n"
    }
    return str
}

/*
    Renvoie les donnees du champ de bataille sur la forme de chaine de caracteres selon le point de vue du joueur actif
    Ses troupes seront affichees en bas, les troupes enemies en haut
    Parameters :
        - p_joueur_actif    Le plateau du joueur actif
        - p_joueur_inactif  Le plateau du joueur inactif
*/
func str_champ_bataille(_ p_joueur_actif: Plateau, _ p_joueur_inactif: Plateau) -> String {
    var str: String = ""
    let empty: String = "VIDE"

    var tab = align_champ_bataille(p_joueur_actif, p_joueur_inactif)

    for ligne in tab.reverse() {
        for carte in ligne {
            str += str_carte_red(carte)
            str += "\t"
        }
        str += "\n"
    }

    return str;
}

/*
    Renvoie les stats de toutes les cartes presentes dans la main du joueur sous la forme de chaine de caractere
    Parameters :
        - main  La main a afficher
*/
func str_main(_ main: Main) -> String {
    var str: String = ""
    for c in main {
        str += str_carte_stats(c) + "\n"
    }
    return str
}

/*
    Renvoie les donnees du royaume sous la forme de chaine de caractere
    Parameters :
        - roy   Le Royaume a afficher
*/
func str_royaume(_ roy: Royaume) -> String {
    var str: String = ""
    str += "Royaume (Du plus ancien au plus recent) : \n"
    for carte in roy {
        str += str_carte_red(carte) + "\n"
    }
    return str
}


// -- Fonctions de calculs -- //

/*
    Assigne les differentes cartes des plateaux passees en parametre dans un tableau.
    La ligne 0 est l'arriere du plateau du j1
    La ligne 1 est le front du plateau du j1
    La ligne 2 est le front du plateau du j2
    La ligne 3 est l'arriere du plateau du j2

    Les deux plateau etant face a face, on aura donc la case (0,0) du J1 qui fera face a la case (0, 0) du j1, fera face
    a la case (2,0) du J2

    S'il n'y a pas de cartes a une position, la case du tableau contiendra nil

    Le tableau[4][3] de Carte resultant sera sous cette forme, ou (x,y) represente la carte aux coordonnees x,y
    3   (2,1)   (1,1)   (0,1)   |   Arriere J2
    2   (2,0)   (1,0)   (0,0)   |   Front J2
    1   (0,0)   (1,0)   (2,0)   |   Front J1
    0   (0,1)   (1,1)   (2,1)   |   Arriere J1
          0       1       2

    ==> par exemple : tab[2][1] renvoie la carte en position (1,0) du plateau du J2
*/
func align_champ_bataille(_ p_joueur_actif: PlateauProtocol, _ p_joueur_inactif: PlateauProtocol) -> [[Carte?]] {
    var tab = [[Carte?]]();

    // Ligne numero 1
    var ligne1 = [Carte?]();
    if let c = p_joueur_actif.carte_en_position(0, 1) {
        ligne1.insert(c, at: 0)
    } else {
        ligne1.insert(nil, at: 0)
    }
    if let c = p_joueur_actif.carte_en_position(1, 1) {
        ligne1.insert(c, at: 1)
    } else {
        ligne1.insert(nil, at: 1)
    }
    if let c = p_joueur_actif.carte_en_position(2, 1) {
        ligne1.insert(c, at: 2)
    } else {
        ligne1.insert(nil, at: 2)
    }

    // Ligne 2
    var ligne2 = [Carte?]();
    if let c = p_joueur_actif.carte_en_position(0, 0) {
        ligne2.insert(c, at: 0)
    } else {
        ligne2.insert(nil, at: 0)
    }
    var ligne2 = [Carte?]();
    if let c = p_joueur_actif.carte_en_position(1, 0) {
        ligne2.insert(c, at: 1)
    } else {
        ligne2.insert(nil, at: 1)
    }
    var ligne2 = [Carte?]();
    if let c = p_joueur_actif.carte_en_position(1, 0) {
        ligne2.insert(c, at: 2)
    } else {
        ligne2.insert(nil, at: 2)
    }

    // Ligne 3
    var ligne3 = [Carte?]();
    if let c = p_joueur_inactif.carte_en_position(2, 0) {
        ligne3.insert(c, at: 0)
    } else {
        ligne3.insert(nil, at: 0)
    }
    if let c = p_joueur_inactif.carte_en_position(1, 0) {
        ligne3.insert(c, at: 1)
    } else {
        ligne3.insert(nil, at: 1)
    }
    if let c = p_joueur_inactif.carte_en_position(0, 0) {
        ligne3.insert(c, at: 2)
    } else {
        ligne3.insert(nil, at: 2)
    }

    // Ligne 4
    var ligne4 = [Carte?]();
    if let c = p_joueur_inactif.carte_en_position(2, 1) {
        ligne4.insert(c, at: 0)
    } else {
        ligne4.insert(nil, at: 0)
    }
    if let c = p_joueur_inactif.carte_en_position(1, 1) {
        ligne4.insert(c, at: 1)
    } else {
        ligne4.insert(nil, at: 1)
    }
    if let c = p_joueur_inactif.carte_en_position(0, 1) {
        ligne4.insert(c, at: 2)
    } else {
        ligne4.insert(nil, at: 2)
    }

    // Insertion dans le tableau de chacune des lignes
    tab.insert(ligne1, at: 0)
    tab.insert(ligne2, at: 1)
    tab.insert(ligne3, at: 2)
    tab.insert(ligne4, at: 3)

    return tab

}

/*
    Renvoie le tableau de cartes dans la main
*/
func tab_main(_ main: Main) -> [Main] {
    var tab = [Carte]();

    var i = 0
    for c in main {
        tab.insert(c, at: i)
        i += 1
    }

    return tab
}

/*
    Propose au joueur de deployer une unite et de la placer sur son plateau
    Si la position renseignee est deja occupee, propose d'echanger les deux cartes. Si le joueur refuse
*/
func deployer_carte(_ main: Main, _ plateau: Plateau) {
    // Affichage de la main du J1
    print(str_main(main))

    // On reccupere un tableau de cartes de la main
    var tab_main_j1 = tab_main(main_j1)

    // Cree un tableau des reponses admissibles
    var rep_admissibles = [String]()
    for i in (0..<count(tab_main_j1)) {
        rep_admissibles.append(str(i))
    }

    // Demande au joueur
    var rep = Int(input("Choisir une carte de votre main a placer sur le Royaume", rep_admissibles))

    // Identifie la carte choisie en fonction de la reponse
    var carte_choisie = tab_main_j1[rep]

    var placee: Bool = false
    while !placee {
        // Affiche le plateau
        print(str_plateau(plateau))

        // Cree un tableau des reponses admissibles
        var posX = Int(input("Choisir la position x (verticale) ou assigner cette carte", ["0", "1", "2"]))
        var posY = Int(input("Choisir la position y (horizontale) ou assigner cette carte", ["0", "1"]))

        var echanger: Bool = false
        // Ajoute la carte au plateau
        do {
            try plateau.ajouter_plateau(carte_choisie, posX, posY)
            placee = true
        } catch {
            var reponse: String = ""
            reponse = print("Cette position est deja occupee, voulez vous echanger ces deux cartes ?", ["Y", "N"])
            if reponse == "Y" {
                echanger = true
            }
        }
        if (echanger) {
            if let c2 = plateau.carte_en_position(posX, posY) {
                do {
                    try plateau.retirer_plateau(c2)
                    try plateau.ajouter_plateau(carte_choisie, posX, posY)
                    main.ajouter_main(c2)
                    try main.retirer_main(carte_choisie)
                    placee = true
                } catch {
                    print("erreur : Veuillez reessayer")
                }
            }
        }
    }


}

// -- Fonctions d'initialisations -- //

/*
    Initialise une pioches en y ajoutant 9 Cartes de type "soldat", 6 de type "garde" et 5 de type "archer"
    retourne la pioche creee
*/
func init_pioche() -> Pioche {
    var pioche = new Pioche()

    let portee_soldat = [(0, 1)]
    let portee_archers = [(1, 2), (-1, 2), (2, 1), (-2, 1)]

    // Cree les 9 soldats
    for i in (0...8) {
        do {
            try var c = Carte("Soldat", 1, 2, 1, portee_soldat)
        } catch {
            fatalError("Erreur creation cartes soldats")
        }
        pioche.ajouter_pioche(c)
    }

    // Cree les 6 gardes
    for i in (0...5) {
        do {
            try var c = Carte("Garde", 1, 3, 2, portee_soldat)
        } catch {
            fatalError("Erreur creation cartes soldats")
        }
        pioche.ajouter_pioche(c)
    }

    // Cree les 5 archers
    for i in (0...4) {
        do {
            try var c = Carte("Archer", 1, 2, 1, portee_archers)
        } catch {
            fatalError("Erreur creation cartes soldats")
        }
        pioche.ajouter_pioche(c)
    }

    return pioche
}


// ===== MAIN ===== //


// === INITIALISATION DE LA PARTIE ===

// Instanciation des Mains
var main_j1: Main = Main()
var main_j2 = Main()

// Instanciation des Royaumes
var royaume_j1 = Royaume()
var royaume_j2 = Royaume()

// Instanciation des Plateaux
var plateau_j1 = Plateau()
var plateau_j2 = Plateau()


// -- Remplis les pioches des 2 joueurs de 9 soldats, 6 gardes et 5 archers -- //

// Instanciation des Pioches
var pioche_j1 = init_pioche()
var pioche_j2 = init_pioche()


// --  Met dans les mains des 2 joueurs 1 roi (random) et les 3 premières cartes de la pioche (= piocher 3x) -- //

// Instanciation des Rois
do {
    try var roi1 = Carte("Roi", 1, 4, 4, [(0, 1), (0, 2), (-1, 1), (1, 1)])
    try var roi2 = Carte("Roi", 1, 5, 4, [(0, 1), (-1, 1), (1, 1)])
} catch {
    fatalError("Erreur creation cartes soldats")
}

// Ajout des Rois dans les Mains
main_j1.ajouter_main(roi1)
main_j2.ajouter_main(roi2)

// Piocher + Ajout main
for i in (1...3) {
    if let c = pioche_j1.piocher() {
        main_j1.ajouter_main(c)
    }
}
for i in (1...3) {
    if let c = pioche_j2.piocher() {
        main_j2.ajouter_main(c)
    }
}

// -- Piocher une carte dans la pioche et la placer dans le Royaume (pour les 2 joueurs) -- //
if let c = pioche_j1.piocher() {
    royaume_j1.ajouter_royaume(c)
}
if let c = pioche_j2.piocher() {
    royaume_j2.ajouter_royaume(c)
}

// -- J1 : Choisir n’importe quelle carte de sa main et la placer sur le Front


// Demande au J1 de choisir une carte de sa main
print("Joueur 1")
deployer_carte(main_j1, plateau_j1)

// Demande au J2 de choisir une carte de sa main
print("Joueur 2")
deployer_carte(main_j2, plateau_j2)


