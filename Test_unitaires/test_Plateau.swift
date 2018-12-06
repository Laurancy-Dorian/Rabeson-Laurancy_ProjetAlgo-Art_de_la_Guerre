// === Tests Unitaires d'un Plateau ===

// Le test passe si init n'est pas nil.
// Renvoie 1 si le test passe, 0 sinon

var portee: [(Int, Int)] = [(1, 2), (0, 1)];
var porteeVide = [];
do {
    try var carte = Carte("Soldat", 3, 4, 3, portee);
} catch {}

func test_ajouter_plateau() -> Int{
    var p1 = Plateau()

    do {
        try r1.ajouter_royaume(carte, -1, 0)
        print("KO : La position X est mauvaise")
        return 0
    } catch {
        print("OK")
    }

    do {
        try r1.ajouter_royaume(carte, 0, -1)
        print("KO : La position Y est mauvaise")
        return 0
    } catch {
        print("OK")
    }

    do {
        try r1.ajouter_royaume(carte, 3, 0)
        print("KO : La position X est mauvaise")
        return 0
    } catch {
        print("OK")
    }

    do {
        try r1.ajouter_royaume(carte, 0, 2)
        print("KO : La position Y est mauvaise")
        return 0
    } catch {
        print("OK")
    }

    do {
        try r1.ajouter_royaume(carte, 0, 0)
        print("OK")
    } catch {
        print("KO : La carte ne s'est pas ajoutee correctement")
        return 0
    }
}

func test_retirer_plateau() -> Int{

}

func test_position_carte() -> Int{

}

func test_carte_en_position() -> Int{

}

func test_est_occupee() -> Int{

}

func test_reorganiser_plateau() -> Int{

}

func test_plateau_vide() -> Int{

}

func test_tuer() -> Int{

}

func test_count_cartes_qui_peuvent_attaquer() -> Int{

}

// ==== Tests ====
var nb_test_ok: Int = 0;
var nb_test_tot: Int = 0;

nb_test_tot += 1;
nb_test_ok += test_ajouter_royaume();

nb_test_tot += 1;
nb_test_ok += test_retirer_plateau();

nb_test_tot += 1;
nb_test_ok += test_position_carte();

nb_test_tot += 1;
nb_test_ok += test_carte_en_position();

nb_test_tot += 1;
nb_test_ok += test_est_occupee();

nb_test_tot += 1;
nb_test_ok += test_reorganiser_plateau();

nb_test_tot += 1;
nb_test_ok += test_plateau_vide();

nb_test_tot += 1;
nb_test_ok += test_tuer();

nb_test_tot += 1;
nb_test_ok += test_count_cartes_qui_peuvent_attaquer();

print("=== FIN DES TESTS ===")
print("\(nb_test_ok) fonctions ont passe les tests sur \(nb_test_tot)")