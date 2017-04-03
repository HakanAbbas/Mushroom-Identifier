package com.mushroom.android.cpptest;

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
                Mushroom shroom = (Mushroom) listView.getItemAtPosition(position);
                String poisonous;
                String round;
                String nodule;
                String lamella;

                if(shroom.getPoisonous()){
                    poisonous = "Ja";
                }else
                    poisonous = "Nein";

                if(shroom.getRound()){
                    round = "Ja";
                }else
                    round = "Nein";

                if(shroom.getNodule()){
                    nodule = "Ja";
                }else
                    nodule = "Nein";

                if(shroom.getLamella()){
                    lamella = "Ja";
                }else
                    lamella = "Nein";


                Intent intent = new Intent(getApplicationContext(), showSelectedPilzActivity.class);

                intent.putExtra("name", shroom.getName());
                intent.putExtra("poisonous", poisonous);
                intent.putExtra("round", round);
                intent.putExtra("nodule", nodule);
                intent.putExtra("lamella", lamella);
                intent.putExtra("stalk", shroom.getStalk());
                intent.putExtra("wiki", shroom.getWiki());
                startActivity(intent);
            }
        });
    }
}
