protocol TBateau {

    //init : {(col: Int, lig: Int)} x Int x Direction x CodeOcean -> TBateau
    //Crée un Bateau qu'il place à une certaine position avec toutes ses positions comprises dans 
    //le tableau positions_restantes et aucune dans positions_touchees
    //Un Bateau occupe des positions consécutives et uniques, sur la même ligne/colonne du plateau de jeu 
    //est_coule(b) = False
    //nb_pos_touche(b) = 0
    //taille = taille_init
    //direction = N|S|E|W (direction du bateau)
    //o = Code de l'océan (o1|o2|o3)
    init (positions_init:[(Int,Int)], taille_init : Int, direction: Direction, o:CodeOcean)

    //taille : TBateau -> Int 
    //Int : indique la taille du bateau
    //1<=taille(b)<=4 
    var taille : Int {get}

    //nb_pos_touche : TBateau -> Int 
    //Int: indique le nombre de positions occupées par un bateau qui ont été touchées 
    //0<=nb_pos_touche<=taille
    var nb_pos_touche : Int {get}

    //potisions : TBateau -> {(col: Int, lig: Int)}
    //Renvoie un tableau indiquant les positions d'un bateau
    //b = creer (Ens) => Pos(b) == Ens
    var positions : [(Int, Int)] {get}

    //posotions_touchees : TBateau -> {(col: Int, lig: Int)|Vide}
    //Renvoie un tableau de toutes les positions déjà touchées d'un bateau 
    //si une position appartient au tableau positions_restantes <=> elle n'appartient pas à posotions_touchees
    var positions_touchees : [(Int, Int)?] {get}

    //positions_restantes : TBateau -> {(col: Int, lig: Int)|Vide}
    //Renvoie un tableau de toutes les positions d'un bateau qui n'ont pas encore été touchées 
    var positions_restantes : [(Int, Int)?] {get}

    //est_coule : TBateau -> Bool
    //Bool : True si le bateau est coulé, false s'il reste des positons qui ne sont pas touchées 
    //est_coule(b) == True <=> nb_pos_touchees(b) == taille(b)
    var est_coule : Bool {get}

    //ocean : TBateau -> CodeOcean
    //Indique à quel océan le bateau appartient
    //CodeOcean : Code de l'océan (o1|o2|o3)
    var ocean : CodeOcean {get}

    //toucher: TBateau x (col: Int, lig: Int) -> TBateau 
    //fonction de modification qui va permettre de marquée une position occupée par un bateau comme étant 
    //une position touchée 
    //Pre : (c,l) n'appartient pas à positions_touchees(b)
    //Post : toucher(b,(c,l)) => (c,l) appartient à posotions_touchees(b)
    //                        => (c,l) n'appartient pas à positions_restantes(b)
    //                        => nb_pos_touchées += 1
    mutating func toucher (col:Int, lig:Int)
}

enum Direction {
    case E
    case N
    case S
    case O
}

struct Bateau : TBateau {

    //taille : TBateau -> Int 
    //Int : indique la taille du bateau
    //1<=taille(b)<=4 
    public private (set) var taille : Int 

    //potisions : TBateau -> {(col: Int, lig: Int)}
    //Renvoie un tableau indiquant les positions d'un bateau
    //b = creer (Ens) => Pos(b) == Ens
    public private (set) var positions : [(Int, Int)]

    //posotions_touchees : TBateau -> {(col: Int, lig: Int)|Vide}
    //Renvoie un tableau de toutes les positions déjà touchées d'un bateau 
    //si une position appartient au tableau positions_restantes <=> elle n'appartient pas à posotions_touchees
    public private (set) var positions_touchees : [(Int, Int)?]

    //positions_restantes : TBateau -> {(col: Int, lig: Int)|Vide}
    //Renvoie un tableau de toutes les positions d'un bateau qui n'ont pas encore été touchées
    public private (set) var positions_restantes : [(Int, Int)?]

    //nb_pos_touche : TBateau -> Int 
    //Int: indique le nombre de positions occupées par un bateau qui ont été touchées 
    //0<=nb_pos_touche<=taille
    public private (set) var nb_pos_touche : Int 

    //est_coule : TBateau -> Bool
    //Bool : True si le bateau est coulé, false s'il reste des positons qui ne sont pas touchées 
    //est_coule(b) == True <=> nb_pos_touchees(b) == taille(b)
    public var est_coule : Bool {
        return self.taille == self.nb_pos_touche
    }

    
    //ocean : TBateau -> CodeOcean
    //Indique à quel océan le bateau appartient
    //CodeOcean : Code de l'océan (o1|o2|o3)
    public private (set) var ocean : CodeOcean

    //init : {(col: Int, lig: Int)} x Int x Direction x CodeOcean -> TBateau
    //Crée un Bateau qu'il place à une certaine position avec toutes ses positions comprises dans
    //le tableau positions_restantes et aucune dans positions_touchees
    //Un Bateau occupe des positions consécutives et uniques, sur la même ligne/colonne du plateau de jeu 
    //est_coule(b) = False
    //nb_pos_touche(b) = 0
    //taille = taille_init
    //direction = N|S|E|W (direction du bateau)
    //o = Code de l'océan (o1|o2|o3)
    init (positions_init:[(Int,Int)], taille_init : Int, direction: Direction, o:CodeOcean){
        self.taille=taille_init
        self.nb_pos_touche=0
        self.ocean=o
        self.positions_restantes=positions_init
        self.positions = positions_init
        self.positions_touchees=[(Int, Int)?](repeating:nil,count:self.taille)
    }


    //toucher: TBateau x (col: Int, lig: Int) -> TBateau 
    //fonction de modification qui va permettre de marquée une position occupée par un bateau comme étant 
    //une position touchée 
    //Pre : (c,l) n'appartient pas à positions_touchees(b)
    //Post : toucher(b,(c,l)) => (c,l) appartient à posotions_touchees(b)
    //                        => (c,l) n'appartient pas à positions_restantes(b)
    //                        => nb_pos_touchées += 1
    public mutating func toucher (col:Int, lig:Int){
        self.positions_touchees[self.nb_pos_touche] = (col,lig)
        for i in 0..<self.taille{
            if let nv = self.positions_restantes[i]{
                if nv==(col,lig){
                    self.positions_touchees[i]=self.positions_restantes[i]
                    self.positions_restantes[i]=nil
               }
            }
        }
        self.nb_pos_touche+=1
    }
}
