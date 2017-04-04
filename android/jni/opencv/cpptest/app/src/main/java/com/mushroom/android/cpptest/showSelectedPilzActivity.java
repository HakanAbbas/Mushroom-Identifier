package com.mushroom.android.cpptest;

import android.content.Intent;
import android.graphics.Color;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Html;
import android.text.SpannableString;
import android.text.SpannableStringBuilder;
import android.text.method.LinkMovementMethod;
import android.text.style.ForegroundColorSpan;
import android.widget.ImageView;
import android.widget.TextView;


//Die Klasse für das Anzeigen einzelner Details eines Pilze
public class showSelectedPilzActivity extends AppCompatActivity {

    //Deklaration einzelner Variablen für die Kommunikation zwischen dem layout und dieser Klasse
    private TextView name ;

    private TextView poisonous;

    private TextView round;

    private TextView lamella;

    private TextView nodule;

    private TextView stalk;

    private TextView wiki;

    private ImageView image;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_show_selected_pilz);

        //Mit dieser Klasse ist es möglich, einen Textausschnitt in bestimmter Formatierung anzuzeigen
        SpannableStringBuilder builder = new SpannableStringBuilder();

        SpannableString str1;
        SpannableString str2;

        name = (TextView) findViewById(R.id.name);
        poisonous = (TextView) findViewById(R.id.poisonous);
        round = (TextView) findViewById(R.id.round);
        lamella = (TextView) findViewById(R.id.lamella);
        nodule = (TextView) findViewById(R.id.nodule);
        stalk = (TextView) findViewById(R.id.stalk);
        wiki = (TextView) findViewById(R.id.wiki);
        image = (ImageView) findViewById(R.id.imageViewPilz);

        Intent i = getIntent();

        String help = i.getStringExtra("name");
        this.name.append(help+"\n");


        str1 = new SpannableString("Ist der Mushroom giftig? \n");
        builder.append(str1);
        help = i.getStringExtra("poisonous");
        str2 = new SpannableString(help.toString());
        if(help.equalsIgnoreCase("Ja")){
            str2.setSpan(new ForegroundColorSpan(Color.RED), 0, str2.length(),0);
        }else{
            str2.setSpan(new ForegroundColorSpan(Color.GREEN), 0, str2.length(),0);
        }
        builder.append(str2);
        this.poisonous.setText(builder, TextView.BufferType.SPANNABLE);
        builder.clear();

        //this.poisonous.append(help+"\n");

        help = i.getStringExtra("round");
        this.round.append(help+"\n");

        help = i.getStringExtra("lamella");
        this.lamella.append(help+"\n");

        help = i.getStringExtra("nodule");
        this.nodule.append(help+"\n");

        help = i.getStringExtra("stalk");
        this.stalk.append(help+"\n");




        str1 = new SpannableString("Führ mehr Informationen klicken Sie bitte diesen Link an: \n");
        builder.append(str1);

        help = i.getStringExtra("wiki");
        str2 = new SpannableString(help.toString());
        str2.setSpan(new ForegroundColorSpan(Color.BLUE), 0, str2.length(), 0);
        builder.append(str2);

        this.wiki.setClickable(true);
        this.wiki.setMovementMethod(LinkMovementMethod.getInstance());
        String link = "<a href='"+help+"'>"+help+"</a>";
        this.wiki.append(Html.fromHtml(link));

        String drawIm = i.getStringExtra("name");

        if(i.getStringExtra("name").equalsIgnoreCase("eierschwammerl")){
            this.image.setImageResource(R.drawable.eierschwammerl);
        }else if(i.getStringExtra("name").equalsIgnoreCase("fliegenpilz")){
            this.image.setImageResource(R.drawable.fliegenpilz);
        }else if(i.getStringExtra("name").equalsIgnoreCase("steinpilz")){
            this.image.setImageResource(R.drawable.steinpilz);
        }else
            this.image.setImageResource(0);

        //this.wiki.setText( builder, TextView.BufferType.SPANNABLE);

    }
}
