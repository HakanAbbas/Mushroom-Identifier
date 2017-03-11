package com.firstapp.hakan.cameraapp;

/**
 * Created by Hakan on 11.03.2017.
 */

public class Pilz {


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
}
