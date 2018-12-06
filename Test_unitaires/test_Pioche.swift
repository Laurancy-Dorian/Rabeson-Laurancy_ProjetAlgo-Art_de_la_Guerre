// === Tests Unitaires d'une Pioche ===

// Le test passe si init n'est pas nil.
// Renvoie 1 si le test passe, 0 sinon

func test_piocher() -> Int{

}

func test_ajouter_pioche() -> Int{

}

func test_ajouter_pioche() -> Int{
    
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