package com.mushroom.android.cpptest;
public class Mushroom {

    private byte[] color = new byte[3];
    private byte[] hsv_v = new byte[3];
    private byte[] hsv_b = new byte[3];
    private byte[] hsv_v2 = new byte[3];
    private byte[] hsv_b2 = new byte[3];
    private String name;
    private String wiki;
    private boolean poisonous;
    private boolean round;
    private boolean lamella;
    private boolean nodule;
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

    public boolean getPoisonous() {
        return poisonous;
    }

    public void setPoisonous(boolean poisonous) {
        this.poisonous = poisonous;
    }

    public boolean getRound() {
        return round;
    }

    public void setRound(boolean round) {
        this.round = round;
    }

    public boolean getLamella() {
        return lamella;
    }

    public void setLamella(boolean lamella) {
        this.lamella = lamella;
    }

    public boolean getNodule() {
        return nodule;
    }

    public void setNodule(boolean nodule) {
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


    /** find the Schwammerl with native Mushroom C++ Code that uses OpenCV
     */
    public byte[] getColor() {
        return color;
    }

    public void setColor(byte[] color) {
        this.color = color;
    }

    public byte[] getHsv_v() {
        return hsv_v;
    }

    public void setHsv_v(byte[] hsv_v) {
        this.hsv_v = hsv_v;
    }

    public byte[] getHsv_b() {
        return hsv_b;
    }

    public void setHsv_b(byte[] hsv_b) {
        this.hsv_b = hsv_b;
    }

    public byte[] getHsv_v2() {
        return hsv_v2;
    }

    public void setHsv_v2(byte[] hsv_v2) {
        this.hsv_v2 = hsv_v2;
    }

    public byte[] getHsv_b2() {
        return hsv_b2;
    }

    public void setHsv_b2(byte[] hsv_b2) {
        this.hsv_b2 = hsv_b2;
    }
}
