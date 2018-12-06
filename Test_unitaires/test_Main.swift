// === Tests Unitaires d'une Main ===

// Le test passe si init n'est pas nil.
// Renvoie 1 si le test passe, 0 sinon

var portee: [(Int, Int)] = [(1, 2), (0, 1)];
var porteeVide = [];
do {
    try var c1 = Carte("Soldat", 3, 4, 3, portee);
} catch {}

func test_ajouter_main() -> Int{
    var m1 = Main()
    var m2 = m1
    ajouter_main()
    //
    if count_main(m1) != 0 {
        print("")
        return 1
    } else {
        print("")
        return 0
    }

    

}

func test_retirer_main() -> Int{

}

func test_cartes_en_main() -> Int{

}

func test_count_main() -> Int{

}

func test_est_vide() -> Int{

}

// ==== Tests ====
var nb_test_ok: Int = 0;
var nb_test_tot: Int = 0;

nb_test_tot += 1;
nb_test_ok += test_init();

nb_test_tot += 1;
nb_test_ok += test_puissance_attaque();

nb_test_tot += 1;
nb_test_ok += test_pv_defensif();

nb_test_tot += 1;
nb_test_ok += test_pv_offensif();

nb_test_tot += 1;
nb_test_ok += test_statut();

nb_test_tot += 1;
nb_test_ok += test_portee();

nb_test_tot += 1;
nb_test_ok += test_type_carte();

nb_test_tot += 1;
nb_test_ok += test_degats_subis();

nb_test_tot += 1;
nb_test_ok += test_attaque();

print("=== FIN DES TESTS ===")
print("\(nb_test_ok) fonctions ont passe les tests sur \(nb_test_tot)")