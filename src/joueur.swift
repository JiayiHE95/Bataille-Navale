protocol TJoueur {

    //init : {TBateau} x {TOcean} x {TOcean} x String -> TJoueur 
    //Crée un joueur
    //nb_coule_adversaire=0
    //est_gagne = False
    //list_bat_adversaire = bateaux_adversaire
    //list_ocean_adversaire = oceans_adversaire
    //list_ocean_joueur = oceans_joueur
    //nom = nom_joueur
    //bateaux_adversaire: liste d'éléments de type TBateau dont les positions sont uniques 
    //(on ne peut pas avoir deux TBateau sur la même position)
    init(bateaux_adversaire:[TBateau], nom_joueur: String, oceans_joueur : [TOcean], oceans_adversaire: [TOcean])

    //list_ocean_joueur : TJoueur -> {TOcean}
    //Renvoie le tableau des océans du joueur
    //[TOcean] : oceans_joueur
    //list_ocean_joueur != list_ocean_adversaire
    var list_ocean_joueur:[TOcean] {get}
    
    //list_ocean_adversaire : TJoueur -> {TOcean}
    //Renvoie le tableau des océans de l'adversaire
    //[TOcean] : oceans_adversaire
    //list_ocean_joueur != list_ocean_adversaire
    var list_ocean_adversaire:[TOcean] {get}

    //nom : TJoueur -> String
    //nom du joueur 
    //nom = nom_joueur 
    var nom:String {get}

    //est_gagne : TJoueur -> Bool
    //Indique si la partie est gagnée 
    //True => la partie est gagnée 
    var est_gagne:Bool {get}

    //list_bat_adversaire : TJoueur -> {TBateau}
    //Renvoie un tableau des Bateaux de l'adversaire
    //list_bat_adversaire = bateaux_adversaire
    var list_bat_adversaire:[TBateau] {get}

    //nb_coule_adversaire : TJoueur -> Int
    //Renvoie le nombre de bateaux coulés de l'adversaire
    //Int : nombre de Bateaux coulés de l'adversaire
    //est_gagne <=> nb_coule_adversaire == 5
    //0<=nb_coule_adversaire<=5
    var nb_coule_adversaire: Int {get}
     
    //tirer : TJoueur x CodeOcean x (col: Int, lig: Int) -> TJoueur x Restir 
    //Tire sur une position et un océan donnés en paramètre et renvoi le résultat 
    //Restir : touché|en Vue|à l'eau|coulé 
    //tirer (j,o,(c,l)) => il existe un b tel que (c,l) appartient à positions_restantes(b) sur ocean(o)
    //                   => toucher(b,(c,l)) est : Restir = touché <=> !coulé(b) || Restir = coulé <=> coulé(b)
    //                   => il n'existe pas de b
    //                   => toucher(b,(c,l)) est : Restir = à l'eau <=> !coulé(b) || Restir = en vue <=> !coulé(b)
    mutating func tirer(o:CodeOcean, col:Int, lig:Int)-> ResTir
 
    //en_vue : TJoueur x CodeOcean x (col: Int, lig: Int) -> Bool
    //Indique si un bateau est en vue d'une position et un océan placés en paramètre 
    //Pre : ocean = o1|o2|o3
    //Pre : (col: Int, lig: Int) compris dans la taille de l'océan
    //Bool : True => il y a un bateau en vue (False => aucun bateau en vue)
    func en_vue(o:CodeOcean, col:Int, lig:Int)-> Bool

    //gestion_affichage_resTir : CodeOcean x (col: Int, lig: Int) x ResTir x TJoueur -> TJoueur
    //fonction qui permet de marquer le résultat du tir dans l'océan du joueur et de l'adversaire 
    //Pre : ocean = o1|o2|o3
    //Pre : (col: Int, lig: Int) compris dans la taille de l'océan 
    //Pre : res = touche|en_vue|a_leau|coule
    //Pre : joueurEnCours == self.nom <=> le joueur en cours est le joueur lui meme
    //Pre : joueurEnCours != self.nom <=> le joueur en cours est son adversaire
    mutating func gestion_affichage_resTir(ocean:CodeOcean, col:Int, lig:Int, res:ResTir, joueurEnCours:TJoueur)
  
    //gestion_affichage_bateaux : {TBateau} -> TJoueur
    //fonction qui permet de marquer la position des bateaux sur les océans du joueur
    //Pre : bat_joueur : tableau de TBateau, un Bateau occupe des positions consécutives et uniques,
    //sur la même ligne/colonne du plateau de l'océan et compris dans la taille de l'océan 
    mutating func gestion_affichage_bateaux(bat_joueur:[TBateau])
}

enum ResTir {
    case touche
    case en_vue
    case a_leau
    case coule
}

struct Joueur : TJoueur {

    //nom : TJoueur -> Bool
    //nom du joueur 
    //nom = nom_joueur 
    public private (set) var nom:String 

    //est_gagne : TJoueur -> Bool
    //Indique si la partie est gagnée 
    //True => la partie est gagnée 
    public var est_gagne:Bool{
        return self.nb_coule_adversaire==self.taille_jeu
    }

    //list_bat_adversaire : TJoueur -> {TBateau}
    //Renvoie un tableau des Bateaux
    //list_bat_adversaire = bateaux_adversaire
    public private (set) var list_bat_adversaire:[TBateau]

    //list_ocean_joueur : TJoueur -> {TOcean}
    //Renvoie le tableau des océans du joueur
    //[TOcean] : oceans_joueur
    //list_ocean_joueur != list_ocean_adversaire
    public private (set) var list_ocean_joueur:[TOcean]

    //list_ocean_adversaire : TJoueur -> {TOcean}
    //Renvoie le tableau des océans de l'adversaire
    //[TOcean] : oceans_adversaire
    //list_ocean_joueur != list_ocean_adversaire
    public private (set) var list_ocean_adversaire:[TOcean]

    //nb_coule_adversaire : TJoueur -> Int
    //Renvoie le nombre de bateaux coulés de l'adversaire
    //Int : nombre de Bateaux coulés
    //est_gagne(j) <=> nb_coule_adversaire(j) == 5
    //0<=nb_coule_adversaire<=5
    public private (set) var nb_coule_adversaire: Int

    //taille_jeu : TJoueur -> Int
    //taille fixée 
    //nb_coule_adversaire(j) == taille_jeu(j) => est_gagne(j)
    private var taille_jeu:Int
    

    //init : {TBateau} x {TOcean} x {TOcean} x String -> TJoueur  
    //Crée une partie 
    //nb_coule_adversaire(j)=0
    //est_gagne(j) = False
    //list_bat_adversaire = bateaux_adversaire
    //list_ocean_adversaire = oceans_adversaire
    //list_ocean_joueur = oceans_joueur
    //nom = nom_joueur
    //bateaux_adversaire: liste d'éléments de type TBateau dont les positions sont uniques 
    //(on ne peut pas avoir deux TBateau sur la même position)
    init(bateaux_adversaire:[TBateau], nom_joueur: String, oceans_joueur : [TOcean], oceans_adversaire: [TOcean]){
        self.list_bat_adversaire=bateaux_adversaire
        self.taille_jeu=bateaux_adversaire.count
        self.nb_coule_adversaire=0
        self.nom = nom_joueur
        self.list_ocean_joueur=oceans_joueur
        self.list_ocean_adversaire=oceans_adversaire
    }


    //tirer : TJoueur x Ocean x (col: Int, lig: Int) -> TJoueur x Restir 
    //Tire sur une position et un océan donnés en paramètre et renvoi le résultat 
    //Restir : touché|en Vue|à l'eau|coulé 
    //tirer (j,o,(c,l)) => il existe un b tel que (c,l) appartient à positions_restantes(b) sur ocean(o)
    //                   => toucher(b,(c,l)) est : Restir = touché <=> !coulé(b) || Restir = coulé <=> coulé(b)
    //                => il n'existe pas de b
    //                   => toucher(b,(c,l)) est : Restir = à l'eau <=> !coulé(b) || Restir = en vue <=> !coulé(b)
    public mutating func tirer(o:CodeOcean, col:Int, lig:Int)->ResTir{
        if let nv=check_position(o:o, col:col, lig:lig){//si (c,l) correspondent à une des positions_restantes de b
            self.list_bat_adversaire[nv].toucher(col:col, lig:lig)//on les met dans le tableau positions_touchees
            if self.list_bat_adversaire[nv].est_coule{//si nb_pos_touchées=taille, bateau coulé, sinon juste touché
                nb_coule_adversaire+=1
                print("Vous avez fait coulé un bateau")
                return ResTir.coule
            }else { 
                print("Vous avez touché un bateau")
                return ResTir.touche
            }
        }
        if en_vue(o:o, col:col, lig:lig){
            print("Il y a un bateau en vue")
            return ResTir.en_vue
        }
        print("A l'eau, il y a pas de bateau au tour")
        return ResTir.a_leau
    }
 
    //check_pos : TJoueur x Ocean x (col: Int, lig: Int) -> Int|Vide
    //verifier si une position donnée est parmi les positions restantes de tous les bateaux de l'océan donnée
    //Int : indice du b dans la liste bateaux adversiaire si (c,l) correspond à une des positions_restantes(b), 
    //      sinon null
    private func check_position(o :CodeOcean, col:Int, lig:Int)->Int?{
        var i:Int = 0 
        while i<self.list_bat_adversaire.count{
            let bat=self.list_bat_adversaire[i]
            if bat.ocean==o{
                var j:Int = 0
                while j<bat.taille{
                    if let nv=bat.positions_restantes[j]{
                        if nv==(col, lig) { //une position restante dans l'un des bateaux 
                            return i
                        }
                    }
                    j+=1
                }
            }
            i+=1
        }
        return nil 
    }

    //indice_ocean: CodeOcean -> Int
    //fonction qui prend un ocean en paramètre et retourne l'indice de l'ocean dans list_ocean_joueur et list_ocean_adversaire
    //Pre: CodeOcean = o1|o2|o3
    //Post : Int = 0|1|2
    //o == o1 <=> indice_ocean(o) == 0 (cf.o2,o3)
    private func indice_ocean(o:CodeOcean)->Int{
      var indice:Int=0
      switch o{
        case .o1:
          indice=0
        case .o2:
          indice=1
        case .o3:
          indice=2
      }
      return indice
    }
  

    //en_vue : TJoueur x CodeOcean x (col: Int, lig: Int) -> Bool
    //Indique si un bateau est en vue d'une position et un océan placés en paramètre 
    //Pre : ocean = o1|o2|o3
    //Pre : (col: Int, lig: Int) compris dans la taille de l'océan
    //Bool : True => il y a un bateau en vue (False => aucun bateau en vue)
    public func en_vue(o:CodeOcean, col:Int, lig:Int)->Bool{
        var i:Int = 0 
        //pour chaque bateau de l'adversaire
        while i<self.list_bat_adversaire.count{
            let bat=self.list_bat_adversaire[i]
            //si bateau se trouve à l'ocean saisi par le joueur
            if bat.ocean==o{
                let indice:Int=indice_ocean(o:o)
                var j:Int = 0
                while j<bat.taille{ 
                    if let nv=bat.positions_restantes[j]{
                        //si la ligne ou la colonne de tir correspond à une des positions restantes du bateau
                        //verifie si sur cette ligne ou cette colonne il y a une ile (4 cas)
                        if nv.0==col || nv.1==lig {
                            var k:Int=0
                            var nb_enVue:Int=0 
                            while k<self.list_ocean_joueur[indice].ile.count{
                                let ile_case=self.list_ocean_joueur[indice].ile[k]
                                //cas 1.1: bateau est sur la même colone que l'ile, en dessus de l'ile
                                if ile_case.0==nv.0 && ile_case.1>nv.1 && lig<ile_case.1{
                                    //print("cas1")
                                    nb_enVue+=1
                                }
                                //cas 1.2: bateau est sur la même colone que l'ile, en dessous de l'ile
                                if ile_case.0==nv.0 && ile_case.1<nv.1 && lig>ile_case.1{
                                    //print("cas2")
                                    nb_enVue+=1
                                }
                                //cas 2.1: bateau est sur la même ligne que l'ile, à gauche de l'ile
                                if ile_case.1==nv.1 && ile_case.0>nv.0 && col<ile_case.0{
                                    //print("cas3")
                                    nb_enVue+=1
                                }
                                //cas 2.2: bateau est sur la même ligne que l'ile, à droite de l'ile
                                if ile_case.1==nv.1 && ile_case.0<nv.0 && col>ile_case.0{
                                    //print("cas4")
                                    nb_enVue+=1  
                                }
                                //cas3: bateau n'est ni sur la même ligne ni sur la même colonne que l'ile
                                if ile_case.0 != nv.0 && ile_case.1 != nv.1 {
                                    //print("cas5")
                                    nb_enVue+=1  
                                }
                                k+=1  
                            }
                            //si c'est en vue pour toutes les cases de l'ile ou où on tire il y a pas d'ile au tour
                            if nb_enVue == self.list_ocean_joueur[indice].ile.count {
                              return true
                            }
                        }
                    } 
                    j+=1
                }
            }
            i+=1
        }
        return false
    }

    //gestion_affichage_resTir : CodeOcean x (col: Int, lig: Int) x ResTir x TJoueur -> TJoueur
    //fonction qui permet de marquer le résultat du tir dans l'océan du joueur et de l'adversaire 
    //Pre : ocean = o1|o2|o3
    //Pre : (col: Int, lig: Int) compris dans la taille de l'océan 
    //Pre : res = touche|en_vue|a_leau|coule
    //Pre : joueurEnCours == self.nom <=> le joueur en cours est le joueur lui meme
    //Pre : joueurEnCours != self.nom <=> le joueur en cours est son adversaire
    public mutating func gestion_affichage_resTir(ocean:CodeOcean, col:Int, lig:Int, res:ResTir, joueurEnCours:TJoueur){
      //trouver l'indice de l'océan dans la liste
      let indiceO:Int=indice_ocean(o:ocean)
     
      switch res { 
        case .touche:
          if joueurEnCours.nom == self.nom{
            self.list_ocean_adversaire[indiceO].resultat_tir(col:col, lig:lig, resultat:res) 
          }else{
            self.list_ocean_joueur[indiceO].resultat_tir(col:col, lig:lig, resultat:res)
          }
        case .en_vue:
          if joueurEnCours.nom == self.nom{
            self.list_ocean_adversaire[indiceO].resultat_tir(col:col, lig:lig, resultat:res)
          }
        case .a_leau:
          if joueurEnCours.nom == self.nom{
            self.list_ocean_adversaire[indiceO].resultat_tir(col:col, lig:lig, resultat:res)  
          }
        //si le résultat est coulé, on va marquer tous les cases de ce bateau en C
        case .coule:
          var i:Int=0
          while i < self.list_bat_adversaire.count{
            var bat:TBateau=self.list_bat_adversaire[i]
            if joueurEnCours.nom != self.nom{
              bat=joueurEnCours.list_bat_adversaire[i]
            }
            //parmi tous les bateaux de l'adversaire, si un bateau est bien sur l'ocean tiré
            if bat.ocean==ocean{
              var j:Int = 0
              while j<bat.taille{
                //Quand on trouve le bateau coulé
                if col==bat.positions[j].0 && lig==bat.positions[j].1 {
                  for pos in bat.positions{
                    if joueurEnCours.nom == self.nom{
                      self.list_ocean_adversaire[indiceO].resultat_tir(col:pos.0, lig:pos.1, resultat:res) 
                    }else{
                      self.list_ocean_joueur[indiceO].resultat_tir(col:pos.0, lig:pos.1, resultat:res)
                    }
                  }
                }
                j+=1
              }
            }
            i+=1
          }
      }
    }
  
    //gestion_affichage_bateaux : {TBateau} -> TJoueur
    //fonction qui permet de marquer la position des bateaux sur les océans du joueur
    //Pre : bat_joueur : tableau de TBateau, un Bateau occupe des positions consécutives et uniques,
    //sur la même ligne/colonne du plateau de l'océan et compris dans la taille de l'océan  
    public mutating func gestion_affichage_bateaux(bat_joueur:[TBateau]){
      for bat in bat_joueur{
        let indiceO:Int=indice_ocean(o:bat.ocean)
        self.list_ocean_joueur[indiceO].mettre_bateau_dans_case(bateau:bat)
      }
    }
}



