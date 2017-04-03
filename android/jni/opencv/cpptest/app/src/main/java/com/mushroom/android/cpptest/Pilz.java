package com.mushroom.android.cpptest;

public class Pilz {

    private String[] color;
    private String[] hsv_v;
    private String[] hsv_b;
    private String[] hsv_v2;
    private String[] hsv_b2;
    private String name;
    private String wiki;
    private Boolean poisonous;
    private Boolean round;
    private Boolean lamella;
    private Boolean nodule;
    private String stalk;




    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getWiki() {
        return wiki;
    }

    public void setWiki(String wiki) {
        this.wiki = wiki;
    }

    public Boolean getPoisonous() {
        return poisonous;
    }

    public void setPoisonous(Boolean poisonous) {
        this.poisonous = poisonous;
    }

    public Boolean getRound() {
        return round;
    }

    public void setRound(Boolean round) {
        this.round = round;
    }

    public Boolean getLamella() {
        return lamella;
    }

    public void setLamella(Boolean lamella) {
        this.lamella = lamella;
    }

    public Boolean getNodule() {
        return nodule;
    }

    public void setNodule(Boolean nodule) {
        this.nodule = nodule;
    }

    public String getStalk() {
        return stalk;
    }

    public void setStalk(String stalk) {
        this.stalk = stalk;
    }

    @Override
    public String toString() {
        return name;
    }

    public String[] getColor() {
        return color;
    }

    public void setColor(String[] color) {
        this.color = color;
    }

    public String[] getHsv_v() {
        return hsv_v;
    }

    public void setHsv_v(String[] hsv_v) {
        this.hsv_v = hsv_v;
    }

    public String[] getHsv_b() {
        return hsv_b;
    }

    public void setHsv_b(String[] hsv_b) {
        this.hsv_b = hsv_b;
    }

    public String[] getHsv_v2() {
        return hsv_v2;
    }

    public void setHsv_v2(String[] hsv_v2) {
        this.hsv_v2 = hsv_v2;
    }

    public String[] getHsv_b2() {
        return hsv_b2;
    }

    public void setHsv_b2(String[] hsv_b2) {
        this.hsv_b2 = hsv_b2;
    }
}
