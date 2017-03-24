package com.mushroom.android.cpptest;
public class Mushroom {
    private byte[] farbe = new byte[3];
    private byte[] hsvVon = new byte[3];
    private byte[] hsvBis = new byte[3];
    private byte[] hsvVS = new byte[3];
    private byte[] hsvBS = new byte[3];
    private String name;
    private String wiki;
    private boolean giftigkeit;
    private boolean rund;
    private boolean lamellen;
    private boolean knollen;
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

    public boolean getGiftigkeit() {
        return giftigkeit;
    }

    public void setGiftigkeit(boolean giftigkeit) {
        this.giftigkeit = giftigkeit;
    }

    public boolean getRund() {
        return rund;
    }

    public void setRund(boolean rund) {
        this.rund = rund;
    }

    public boolean getLamellen() {
        return lamellen;
    }

    public void setLamellen(boolean lamellen) {
        this.lamellen = lamellen;
    }

    public boolean getKnollen() {
        return knollen;
    }

    public void setKnollen(boolean knollen) {
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


    /** find the Schwammerl with native Mushroom C++ Code that uses OpenCV
     */
    public byte[] getFarbe() {
        return farbe;
    }

    public void setFarbe(byte[] farbe) {
        this.farbe = farbe;
    }

    public byte[] getHsvVon() {
        return hsvVon;
    }

    public void setHsvVon(byte[] hsvVon) {
        this.hsvVon = hsvVon;
    }

    public byte[] getHsvBis() {
        return hsvBis;
    }

    public void setHsvBis(byte[] hsvBis) {
        this.hsvBis = hsvBis;
    }

    public byte[] getHsvVS() {
        return hsvVS;
    }

    public void setHsvVS(byte[] hsvVS) {
        this.hsvVS = hsvVS;
    }

    public byte[] getHsvBS() {
        return hsvBS;
    }

    public void setHsvBS(byte[] hsvBS) {
        this.hsvBS = hsvBS;
    }
}
