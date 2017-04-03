package com.mushroom.android.cpptest;



import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserFactory;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Hakan on 11.03.2017.
 */

public class XMLPullParserHandler {


    private List<Pilz> pilze;

    private List<Mushroom> mushroom;

    private Pilz pilz;
    private String text;

    private Mushroom mushrooms;




    public XMLPullParserHandler() {
        setMushroom(new ArrayList<Mushroom>());
    }


    public List<Pilz> getPilze() {
        return pilze;
    }




    public List<Mushroom> parse(InputStream is) {
        XmlPullParserFactory factory = null;
        XmlPullParser parser = null;
        try{
            factory = XmlPullParserFactory.newInstance();
            factory.setNamespaceAware(true);


            parser = factory.newPullParser();
            parser.setInput(is, null);

            int eventType = parser.getEventType();
            while(eventType != XmlPullParser.END_DOCUMENT) {
                String tagname = parser.getName();
                switch(eventType) {
                    case XmlPullParser.START_TAG:

                        if(tagname.equalsIgnoreCase("Pilz")) {
                            pilz = new Pilz();
                            mushrooms = new Mushroom();
                        }
                        break;

                    case XmlPullParser.TEXT:

                        text = parser.getText();
                        break;

                    case XmlPullParser.END_TAG:

                        if(tagname.equalsIgnoreCase("Pilz")) {
                            mushroom.add(mushrooms);
                        }else if(tagname.equalsIgnoreCase("Farbe")) {
                            byte[] bytes = new byte[3];
                            String[] temp = new String[3];
                            String blue = parser.getAttributeValue("", "blue");
                            String green = parser.getAttributeValue("", "green");
                            String red = parser.getAttributeValue("", "red");
                            temp[0]=blue;
                            temp[1]=green;
                            temp[2]=red;
                            bytes[0] = (byte)Integer.parseInt(blue);
                            bytes[1] = (byte)Integer.parseInt(green);
                            bytes[2] = (byte)Integer.parseInt(red);
                            mushrooms.setColor(bytes);
                        } else if(tagname.equalsIgnoreCase("HSV-von")) {
                            byte[] bytes = new byte[3];
                            String[] temp = new String[3];
                            String hue = parser.getAttributeValue("", "hue");
                            String saturation = parser.getAttributeValue("", "saturation");
                            String value = parser.getAttributeValue("", "value");
                            temp[0]=hue;
                            temp[1]=saturation;
                            temp[2]=value;
                            bytes[0] = (byte)Integer.parseInt(hue);
                            bytes[1] = (byte)Integer.parseInt(saturation);
                            bytes[2] = (byte)Integer.parseInt(value);
                            mushrooms.setHsv_v(bytes);
                        }else if(tagname.equalsIgnoreCase("HSV-bis")) {
                            byte[] bytes = new byte[3];
                            String[] temp = new String[3];
                            String hue = parser.getAttributeValue("", "hue");
                            String saturation = parser.getAttributeValue("", "saturation");
                            String value = parser.getAttributeValue("", "value");
                            temp[0]=hue;
                            temp[1]=saturation;
                            temp[2]=value;
                            bytes[0] = (byte)Integer.parseInt(hue);
                            bytes[1] = (byte)Integer.parseInt(saturation);
                            bytes[2] = (byte)Integer.parseInt(value);
                            mushrooms.setHsv_b(bytes);
                        }else if(tagname.equalsIgnoreCase("HSV-von2")) {
                            byte[] bytes = new byte[3];
                            String[] temp = new String[3];
                            String hue = parser.getAttributeValue("", "hue");
                            String saturation = parser.getAttributeValue("", "saturation");
                            String value = parser.getAttributeValue("", "value");
                            temp[0]=hue;
                            temp[1]=saturation;
                            temp[2]=value;
                            bytes[0] = (byte)Integer.parseInt(hue);
                            bytes[1] = (byte)Integer.parseInt(saturation);
                            bytes[2] = (byte)Integer.parseInt(value);
                            mushrooms.setHsv_v2(bytes);
                        }
                        else if(tagname.equalsIgnoreCase("HSV-bis2")) {
                            byte[] bytes = new byte[3];
                            String[] temp = new String[3];
                            String hue = parser.getAttributeValue("", "hue");
                            String saturation = parser.getAttributeValue("", "saturation");
                            String value = parser.getAttributeValue("", "value");
                            temp[0]=hue;
                            temp[1]=saturation;
                            temp[2]=value;
                            bytes[0] = (byte)Integer.parseInt(hue);
                            bytes[1] = (byte)Integer.parseInt(saturation);
                            bytes[2] = (byte)Integer.parseInt(value);
                            mushrooms.setHsv_b2(bytes);
                        }else if(tagname.equalsIgnoreCase("name")) {
                            mushrooms.setName(text);
                        }else if(tagname.equalsIgnoreCase("wiki")) {
                            mushrooms.setWiki(text);
                        }else if(tagname.equalsIgnoreCase("giftigkeit")){
                            if(text.equals("0")){
                                mushrooms.setPoisonous(false);
                            }else{
                                mushrooms.setPoisonous(true);
                            }
                        }else if(tagname.equalsIgnoreCase("rund")){
                            if(text.equals("0")){
                                mushrooms.setRound(false);
                            }else{
                                mushrooms.setRound(true);
                            }
                        }else if(tagname.equalsIgnoreCase("lamellen")){
                            if(text.equals("0")){
                                mushrooms.setLamella(false);
                            }else{
                                mushrooms.setLamella(true);
                            }
                        }else if(tagname.equalsIgnoreCase("knolle")){
                            if(text.equals("0")){
                                mushrooms.setNodule(false);
                            }else{
                                mushrooms.setNodule(true);
                            }
                        }else if(tagname.equalsIgnoreCase("stiel")){
                            mushrooms.setStalk(text);
                        }
                        break;
                    default:
                        break;
                }
                eventType = parser.next();
            }
        }catch ( Exception e) {
            e.printStackTrace();
        }
        return mushroom;
    }

    public List<Mushroom> getMushroom() {
        return mushroom;
    }

    public void setMushroom(List<Mushroom> mushroom) {
        this.mushroom = mushroom;
    }

    public Mushroom getMushrooms() {
        return mushrooms;
    }

    public void setMushrooms(Mushroom mushrooms) {
        this.mushrooms = mushrooms;
    }
}
