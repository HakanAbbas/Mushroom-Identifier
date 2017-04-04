//
// Created by Hakan Abbas on 23.03.2017.
//

#include "Mushroom.h"

//Klasse von Pilzen für C++
Mushroom::Mushroom()
{
}
Mushroom::Mushroom(const Mushroom& other) {
    *this = other;
}
Mushroom& Mushroom::operator=(const Mushroom& other) {
    bgr = other.bgr;
    hsv_v = other.hsv_v;
    hsv_b = other.hsv_b;
    hsv_v2 = other.hsv_v2;
    hsv_b2 = other.hsv_b2;
    wiki = other.wiki;
    lamell = other.lamell;
    poisonous = other.poisonous;
    nodule = other.nodule;
    round = other.round;
    name = other.name;
    return *this;
}
