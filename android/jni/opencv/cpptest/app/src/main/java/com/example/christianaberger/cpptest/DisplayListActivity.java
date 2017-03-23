package com.example.christianaberger.cpptest;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.io.IOException;
import java.util.List;

public class DisplayListActivity extends AppCompatActivity {


    ListView listView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_list);


        listView = (ListView) findViewById(R.id.list);

        List<Pilz> pilze = null;
        List<Mushroom> mushrooms = null;

        try{
            XMLPullParserHandler parser = new XMLPullParserHandler();
            //pilze = parser.parse(getAssets().open("schwammerl.xml"));
            mushrooms = parser.parse(getAssets().open("schwammerl.xml"));
            ArrayAdapter<Mushroom> adapter=
                    new ArrayAdapter<Mushroom>(this, R.layout.list_item, mushrooms);

            listView.setAdapter(adapter);
        }catch (IOException e){
            e.printStackTrace();
        }

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Mushroom pilz = (Mushroom) listView.getItemAtPosition(position);
                String giftigkeit;
                String rund;
                String knolle;
                String lamellen;

                if(pilz.getGiftigkeit()){
                    giftigkeit = "Ja";
                }else
                    giftigkeit = "Nein";

                if(pilz.getRund()){
                    rund = "Ja";
                }else
                    rund = "Nein";

                if(pilz.getKnollen()){
                    knolle = "Ja";
                }else
                    knolle = "Nein";

                if(pilz.getLamellen()){
                    lamellen = "Ja";
                }else
                    lamellen = "Nein";


                Intent intent = new Intent(getApplicationContext(), showSelectedPilzActivity.class);

                intent.putExtra("name", pilz.getName());
                intent.putExtra("wiki", pilz.getWiki());
                intent.putExtra("giftigkeit", giftigkeit);
                intent.putExtra("rund", rund);
                intent.putExtra("knolle", knolle);
                intent.putExtra("lamellen", lamellen);
                intent.putExtra("stiel", pilz.getStiel());
                intent.putExtra("wiki", pilz.getWiki());
                startActivity(intent);
            }
        });
    }
}
