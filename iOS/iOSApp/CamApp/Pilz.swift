class Pilz {

    var Name: String
    var Wiki: String
    var Giftigkeit: Bool
    var Rund: Bool
    var Lamellen: Bool
    var Knolle: Bool
    var Stiel: String

    init(){
        self.Name = ""
        self.Wiki = ""
        self.Giftigkeit = true
        self.Rund = true
        self.Lamellen = true
        self.Knolle = true
        self.Stiel = ""
    }
    
    init(name: String, wiki: String, giftigkeit:Bool, rund:Bool, lamellen:Bool, knolle:Bool, stiel: String) {
        self.Name = name
        self.Wiki = wiki
        self.Giftigkeit = giftigkeit
        self.Rund = rund
        self.Lamellen = lamellen
        self.Knolle = knolle
        self.Stiel = stiel
    }
}
