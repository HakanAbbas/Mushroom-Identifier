package com.mushroom.android.cpptest;

public class Pilz {

    private String[] farbe;
    private String[] hsvVon;
    private String[] hsvBis;
    private String[] hsvVon2;
    private String[] hsvBis2 ;
    private String name;
    private String wiki;
    private Boolean giftigkeit;
    private Boolean rund;
    private Boolean lamellen;
    private Boolean knollen;
    private String stiel;




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

    public Boolean getGiftigkeit() {
        return giftigkeit;
    }

    public void setGiftigkeit(Boolean giftigkeit) {
        this.giftigkeit = giftigkeit;
    }

    public Boolean getRund() {
        return rund;
    }

    public void setRund(Boolean rund) {
        this.rund = rund;
    }

    public Boolean getLamellen() {
        return lamellen;
    }

    public void setLamellen(Boolean lamellen) {
        this.lamellen = lamellen;
    }

    public Boolean getKnollen() {
        return knollen;
    }

    public void setKnollen(Boolean knollen) {
        this.knollen = knollen;
    }

    public String getStiel() {
        return stiel;
    }

    public void setStiel(String stiel) {
        this.stiel = stiel;
    }

    @Override
    public String toString() {
        return name;
    }

    public String[] getFarbe() {
        return farbe;
    }

    public void setFarbe(String[] farbe) {
        this.farbe = farbe;
    }

    public String[] getHsvVon() {
        return hsvVon;
    }

    public void setHsvVon(String[] hsvVon) {
        this.hsvVon = hsvVon;
    }

    public String[] getHsvBis() {
        return hsvBis;
    }

    public void setHsvBis(String[] hsvBis) {
        this.hsvBis = hsvBis;
    }

    public String[] getHsvVon2() {
        return hsvVon2;
    }

    public void setHsvVon2(String[] hsvVon2) {
        this.hsvVon2 = hsvVon2;
    }

    public String[] getHsvBis2() {
        return hsvBis2;
    }

    public void setHsvBis2(String[] hsvBis2) {
        this.hsvBis2 = hsvBis2;
    }
}
