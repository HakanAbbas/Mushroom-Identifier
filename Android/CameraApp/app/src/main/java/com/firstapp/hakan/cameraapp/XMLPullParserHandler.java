package com.firstapp.hakan.cameraapp;

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

    private Pilz pilz;
    private String text;

    public XMLPullParserHandler() {
        pilze = new ArrayList<Pilz>();
    }


    public List<Pilz> getPilze() {
        return pilze;
    }


    public List<Pilz> parse(InputStream is) {
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
                        }
                        break;

                    case XmlPullParser.TEXT:

                        text = parser.getText();
                        break;

                    case XmlPullParser.END_TAG:

                        if(tagname.equalsIgnoreCase("Pilz")) {
                            pilze.add(pilz);
                        }else if(tagname.equalsIgnoreCase("name")) {
                            pilz.setName(text);
                        }else if(tagname.equalsIgnoreCase("wiki")) {
                            pilz.setWiki(text);
                        }else if(tagname.equalsIgnoreCase("giftigkeit")){
                            if(text.equals("0")){
                                pilz.setGiftigkeit(false);
                            }else{
                                pilz.setGiftigkeit(true);
                            }
                        }else if(tagname.equalsIgnoreCase("rund")){
                            if(text.equals("0")){
                                pilz.setRund(false);
                            }else{
                                pilz.setRund(true);
                            }
                        }else if(tagname.equalsIgnoreCase("lamellen")){
                            if(text.equals("0")){
                                pilz.setLamellen(false);
                            }else{
                                pilz.setLamellen(true);
                            }
                        }else if(tagname.equalsIgnoreCase("knolle")){
                            if(text.equals("0")){
                                pilz.setKnollen(false);
                            }else{
                                pilz.setKnollen(true);
                            }
                        }else if(tagname.equalsIgnoreCase("stiel")){
                            pilz.setStiel(text);
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
        return pilze;
    }
}
