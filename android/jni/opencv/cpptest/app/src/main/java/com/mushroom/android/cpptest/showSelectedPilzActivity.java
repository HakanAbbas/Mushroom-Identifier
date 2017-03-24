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

public class showSelectedPilzActivity extends AppCompatActivity {

    private TextView name ;

    private TextView giftigkeit;

    private TextView rund;

    private TextView lamellen;

    private TextView knolle;

    private TextView stiel;

    private TextView wiki;

    private ImageView image;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_show_selected_pilz);

        SpannableStringBuilder builder = new SpannableStringBuilder();

        SpannableString str1;
        SpannableString str2;

        name = (TextView) findViewById(R.id.name);
        giftigkeit = (TextView) findViewById(R.id.giftigkeit);
        rund = (TextView) findViewById(R.id.rund);
        lamellen = (TextView) findViewById(R.id.lamellen);
        knolle = (TextView) findViewById(R.id.knolle);
        stiel  = (TextView) findViewById(R.id.stiel);
        wiki = (TextView) findViewById(R.id.wiki);
        image = (ImageView) findViewById(R.id.imageViewPilz);

        Intent i = getIntent();

        String help = i.getStringExtra("name");
        this.name.append(help+"\n");


        str1 = new SpannableString("Ist der Mushroom giftig? \n");
        builder.append(str1);
        help = i.getStringExtra("giftigkeit");
        str2 = new SpannableString(help.toString());
        if(help.equalsIgnoreCase("Ja")){
            str2.setSpan(new ForegroundColorSpan(Color.RED), 0, str2.length(),0);
        }else{
            str2.setSpan(new ForegroundColorSpan(Color.GREEN), 0, str2.length(),0);
        }
        builder.append(str2);
        this.giftigkeit.setText(builder, TextView.BufferType.SPANNABLE);
        builder.clear();

        //this.giftigkeit.append(help+"\n");

        help = i.getStringExtra("rund");
        this.rund.append(help+"\n");

        help = i.getStringExtra("lamellen");
        this.lamellen.append(help+"\n");

        help = i.getStringExtra("knolle");
        this.knolle.append(help+"\n");

        help = i.getStringExtra("stiel");
        this.stiel.append(help+"\n");




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
