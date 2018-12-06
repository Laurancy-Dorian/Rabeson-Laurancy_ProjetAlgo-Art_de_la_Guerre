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

    var tab = align_champ_bataille(p_joueur_actif, p_joueur_inactif)

    for ligne in tab.reverse() {
        for carte in ligne {
            if carte != nil {
                str += str_carte_red(carte)
                str += "\t"
            } else {
                str += "VIDE"
                str += "\t"
            }
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
    Effectue un tour de jeu :
        - Remet les cartes du plateau par defaut
        - Pioche
        - Choix de l'action (Attaque, deploiement, Rien)
        - Effectue l'action
        - Phase de developpement

    Parameters :
        - main              La main du joueur actif
        - pioche            La pioche du joueur actif
        - plateau           Le plateau du joueur actif
        - royaume           Le royaume du joueur actif
        - plateau_enemi     Le Plateau du joueur passif

    Return : Un entier caracterisant l'etat de la partie
        - 0     Si la partie n'est pas terminee
        - 1     Si le joueur passif a subi des attaques et ne peut plus placer de troupes sur son plateau
        - 2     Si le ROI du joueur passif est mort
        - 3     Si la pioche est vide au moment de piocher
*/
func tour_de_jeu(_ main: Main, _ pioche: Pioche, _ plateau: Plateau, _ royaume: Royaume, _ plateau_ennemi: Plateau, _ main_ennemi: Main) -> Int {
    // ==== PHASE DE PREPARATION ==== //

    // -- Passez les cartes sur le champ de bataille du joueurs actif en position défensive -- //
    // -- Reinitialiser les dégâts subits -- //
    for c in (plateau) {
        c.status(0)
        c.degats_subis(0)
    }

    // -- Pioche s'il reste des cartes et ajoute a la main -- //
    if (pioche.count_pioche() > 0) {
        if var c = pioche.piocher() {
            main.ajouter_main(c)
        }
    }
    // -- FIN DE LA GUERRE Si la pioche est vide -- //
    else {
        return 3
    }


    // === PHASE D'ACTION ===

    // Affiche les donnees du joueur
    print(str_plateau(plateau))
    print(str_main(main))
    print(str_royaume(royaume))

    // -- Choisir entre “Rien”, “Deployer”, “Attaquer” -- //
    var action = Int(input("Que voulez vous faire ? \n - 1 : Rien\n - 2 : Deployer\n - 3 : Attaquer\n", ["1", "2", "3"]))

    // -- Traitement de l'action "deployer" -- //
    if (action == 2) {
        deployer_carte(main, plateau)
    }

    // -- Traitement de l'action "Attaquer" -- //
    else if (action == 3) {
        var res = phase_attaque(plateau, plateau_ennemi, royaume, main_ennemi)
        if res == 1 || res == 2 {
            return res
        }
    }

    // === PHASE DE DEVELOPPEMENT

    while (main.count_main() > 6 || input("Attribuer carte de la main au Royaume", ["Y", "N"]) == "Y") && main.count_main > 0 {
        print(str_royaume(royaume))

        var carte = choisir_main(main)
        do {
            try main.retirer_main(carte)
            royaume.ajouter_royaume(carte)
        }
    }

    return 0
}


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
    Parameters :
        - main  La main a traiter
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
    Demande au joueur de chosir une carte dans sa main et retourne la carte choisie
*/
func choisir_main(_ main: Main) -> Carte {
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

    return carte_choisie
}

/*
    Propose au joueur de deployer une unite et de la placer sur son plateau
    Si la position renseignee est deja occupee, propose d'echanger les deux cartes. Si le joueur refuse
    alors redemande de nouvelles positions ou placer la carte
*/
func deployer_carte(_ main: Main, _ plateau: Plateau) {
    var carte_choisie = choisir_main(main)

    var placee: Bool = false
    while !placee {
        // Affiche le plateau
        print(str_plateau(plateau))

        // Cree un tableau des reponses admissibles
        var posX = Int(input("Choisir la position x (verticale) ou assigner cette carte", ["0", "1", "2"]))
        var posY = Int(input("Choisir la position y (horizontale) ou assigner cette carte", ["0", "1"]))

        // Ajoute la carte au plateau
        if (plateau.est_occupe(posX, posY)) {
            reponse = input("Cette position est deja occupee, voulez vous echanger ces deux cartes ?", ["Y", "N"])
            if reponse == "Y" {
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
        } else {
            do {
                try plateau.ajouter_plateau(carte_choisie, posX, posY)
                placee = true
            } catch {
                print("Erreur : Veuillez reessayer")
            }
        }
    }
}

/*
    Phase d'attaque
*/
func phase_attaque(_ plateau_att: Plateau, _ plateau_def: Plateau, _ royaume_att: Royaume, _ main_def: Main) -> Int {

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

// Affichage de debut de partie
print("==== ART OF WAR ====")


// === INITIALISATION DE LA PARTIE === //

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

// -- Choisir n’importe quelle carte de sa main et la placer sur le Front -- //

// Demande au J1 de choisir une carte de sa main
print("Joueur 1")
deployer_carte(main_j1, plateau_j1)

// Demande au J2 de choisir une carte de sa main
print("Joueur 2")
deployer_carte(main_j2, plateau_j2)


// === JEU === //

// -- Initialise un int qui defini la fin de la partie (si > 0, la partie est terminee, et la condition de faim de
// partie est determinee en fonction de sa valeur -- //
var partieTerminee: Int = 0

// Joueur courant = 1
var j_courant: Int = 1

// Boucle principale des tours
while (partieTerminee == 0) {

    // Tour du J1
    if j_courant == 1 {
        // Affiche le champ de bataille
        print(str_champ_bataille(plateau_j1, plateau_j2))

        partieTerminee = tour_de_jeu(main_j1, pioche_j1, plateau_j1, royaume_j1, plateau_j2, main_j2)

        // Si la partie n'est pas terminee, le joueur courant devient le J2
        if (partieTerminee == 0) {
            j_courant = 2
        }

        // Tour du J2
    } else {
        partieTerminee = tour_de_jeu(main_j2, pioche_j2, plateau_j2, royaume_j2, plateau_j1, main_j1)

        // Si la partie n'est pas terminee, le joueur courant devient le J1
        if (partieTerminee == 0) {
            j_courant = 1
        }
    }
}


// === FIN DE PARTIE === //

// Affichage du message de fin de partie

// Effondrement
if (partieTerminee == 1) {
    if (j_courant == 1) {
        print("Effondrement du joueur 2 : Victoire du joueur 1")
    } else {
        print("Effondrement du joueur 1 : Victoire du joueur 2")
    }

// Execution
} else if (partieTerminee == 2) {
    if (j_courant == 1) {
        print("Le roi du joueur 2 est mort : Victoire du joueur 1")
    } else {
        print("Le roi du joueur 1 est mort : Victoire du joueur 2")
    }

// Fin de la guerre
} else {
    print("Fin de la guerre : Egalite")
}

// Affichage du game over
print("==== GAME OVER ====")