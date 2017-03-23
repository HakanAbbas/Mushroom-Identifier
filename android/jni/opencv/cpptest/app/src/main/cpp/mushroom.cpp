//
// Created by Christian Aberger on 21.03.2017.
//

#include "Mushroom.h"

Mushroom::Mushroom()
{
}
Mushroom::Mushroom(const Mushroom& other) {
    *this = other;
}
Mushroom& Mushroom::operator=(const Mushroom& other) {
    color = other.color;
    hsvV = other.hsvV;
    hsvB = other.hsvB;
    hsvVS = other.hsvVS;
    hsvBS = other.hsvBS;
    wiki = other.wiki;
    lamell = other.lamell;
    poisonous = other.poisonous;
    nodule = other.nodule;
    round = other.round;
    mushRoomName = other.mushRoomName;
    return *this;
}
