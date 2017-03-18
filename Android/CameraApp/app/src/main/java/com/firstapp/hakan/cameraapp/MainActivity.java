package com.firstapp.hakan.cameraapp;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ExifInterface;
import android.media.Image;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.textservice.TextInfo;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.Authenticator;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    ImageView result;
    static final int REQUEST_IMAGE_CAPTURE = 1;
    public static final int IMAGE_GALLERY_REQUEST = 20;
    Bitmap image;
    Bitmap bitmap;
    Button jaButton;
    Button neinButton;
    private ImageView imageView;
    private TextView fragen;

    private List<Pilz> pilze = null;



    private static final String TAG = "MainActivity" ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        fragen = (TextView) findViewById(R.id.Fragen);

        jaButton = (Button) findViewById(R.id.Ja);

        jaButton.setVisibility(View.INVISIBLE);

        neinButton = (Button) findViewById(R.id.Nein);

        neinButton.setVisibility(View.INVISIBLE);

        // Referenz zur ImageView, wo das Foto angezeigt wird
        imageView = (ImageView) findViewById(R.id.imageView);

        Button click = (Button)findViewById(R.id.cameraButton);
        result = (ImageView) findViewById(R.id.imageView);




        try{
            XMLPullParserHandler parser = new XMLPullParserHandler();
            pilze = parser.parse(getAssets().open("schwammerl.xml"));
        }catch ( IOException e){
            e.printStackTrace();
        }

        if(pilze.size()> 1){
            fragen.setText("Hat ihr Pilz Lamellen?");
            jaButton.setVisibility(View.VISIBLE);
            neinButton.setVisibility(View.VISIBLE);
        }
        else if(pilze.size() == 1){
            fragen.setText(pilze.get(0).getName());
            jaButton.setVisibility(View.INVISIBLE);
            neinButton.setVisibility(View.INVISIBLE);
        }
        else{
            fragen.setText("Leider keine Übereinstimmung");
            jaButton.setVisibility(View.INVISIBLE);
            neinButton.setVisibility(View.INVISIBLE);
        }

    }

    public void onImageGalleryClicked(View v){
        Intent photoPickerIntent = new Intent (Intent.ACTION_PICK);

       File pictureDirectory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        String pictureDirectoryPath = pictureDirectory.getPath();

        Uri data = Uri.parse(pictureDirectoryPath);

        photoPickerIntent.setDataAndType(data, "image/*");

        startActivityForResult(photoPickerIntent, IMAGE_GALLERY_REQUEST);
    }


    public void dispatchTakePictureIntent(View view) {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == RESULT_OK) {
           if( requestCode == REQUEST_IMAGE_CAPTURE ) {
                Bundle extras = data.getExtras();
                this.bitmap = (Bitmap) extras.get("data");
                result.setImageBitmap(this.bitmap);
                result.setAdjustViewBounds(false);
            }else if( requestCode == IMAGE_GALLERY_REQUEST){

               Uri imageUri = data.getData();

               InputStream inputStream;

               try{
                   inputStream = getContentResolver().openInputStream(imageUri);

                   Bitmap bitmap = BitmapFactory.decodeStream(inputStream);

                   imageView.setImageBitmap(bitmap);
                   imageView.setAdjustViewBounds(true);
               }catch(FileNotFoundException e){
                   e.printStackTrace();
                   Toast.makeText(this, "Unable to open image", Toast.LENGTH_LONG).show();
               }
           }
        }//else if(requestCode == IMAGE_GALLERY_REQUEST && resultCode == RESULT_OK)
    }

    public void clickedJa(View button) {
        List<Pilz> pilze2 = new ArrayList<Pilz>();
        int size = pilze.size()-1;

        if(fragen.getText().equals("Hat ihr Pilz Lamellen?")){
            for(int i = 0; i <= size; i++ ){
                if(pilze.get(i).getLamellen()){
                    pilze2.add(pilze.get(i));
                }
            }

            pilze = pilze2;

            if(pilze.size() > 1 ){
                fragen.setText("Hat ihr Pilz eine Knolle");
            }
            else if(pilze.size() == 1){
                fragen.setText(pilze.get(0).getName());
                jaButton.setVisibility(View.INVISIBLE);
                neinButton.setVisibility(View.INVISIBLE);
            }
            else{
                fragen.setText("Leider keine Übereinstimmung");
            }
        }

        else if(fragen.getText().equals("Hat ihr Pilz eine Knolle?")){
            for(int i = 0; i <= size; i++ ){
                if(pilze.get(i).getKnollen()){
                    pilze2.add(pilze.get(i));
                }
            }

            pilze = pilze2;

            if(pilze.size() > 1 ){
                fragen.setText("Hat ihr Pilz einen Stiel der " + pilze.get(0).getStiel());
            }
            else if(pilze.size() == 1){
                fragen.setText(pilze.get(0).getName());
                jaButton.setVisibility(View.INVISIBLE);
                neinButton.setVisibility(View.INVISIBLE);
            }
            else{
                fragen.setText("Leider keine Übereinstimmung");
            }
        }
        else{
            fragen.setText(pilze.get(0).getName());
            jaButton.setVisibility(View.INVISIBLE);
            neinButton.setVisibility(View.INVISIBLE);
        }

    }

    public void clickedNein(View button){
        List<Pilz> pilze2 = new ArrayList<Pilz>();
        int size = pilze.size()-1;

        if(fragen.getText().equals("Hat ihr Pilz Lamellen?")){
            for(int i = 0; i <= size; i++ ){
                if(!pilze.get(i).getLamellen()){
                    pilze2.add(pilze.get(i));
                }
            }

            pilze = pilze2;

            if(pilze.size() > 1 ){
                fragen.setText("Hat ihr Pilz eine Knolle");
            }
            else if(pilze.size() == 1){
                fragen.setText(pilze.get(0).getName());
                jaButton.setVisibility(View.INVISIBLE);
                neinButton.setVisibility(View.INVISIBLE);
            }
            else{
                fragen.setText("Leider keine Übereinstimmung");
                jaButton.setVisibility(View.INVISIBLE);
                neinButton.setVisibility(View.INVISIBLE);
            }
        }

        else if(fragen.getText().equals("Hat ihr Pilz eine Knolle?")){
            for(int i = 0; i <= size; i++ ){
                if(!pilze.get(i).getKnollen()){
                    pilze2.add(pilze.get(i));
                }
            }

            pilze = pilze2;

            if(pilze.size() > 1 ){
                fragen.setText("Hat ihr Pilz einen Stiel der " + pilze.get(0).getStiel());
            }
            else if(pilze.size() == 1){
                fragen.setText(pilze.get(0).getName());
                jaButton.setVisibility(View.INVISIBLE);
                neinButton.setVisibility(View.INVISIBLE);
            }
            else{
                fragen.setText("Leider keine Übereinstimmung");
                jaButton.setVisibility(View.INVISIBLE);
                neinButton.setVisibility(View.INVISIBLE);
            }
        }
        else{
            if(pilze.size() > 1 ){
                for(int i = 0; i <= size; i++){
                    pilze2.add(pilze.get(i));
                }

                pilze = pilze2;


                fragen.setText("Hat ihr Pilz einen Stiel der " + pilze.get(0).getStiel());
            }
            else{
                fragen.setText("Leider keine Übereinstimmung");
                jaButton.setVisibility(View.INVISIBLE);
                neinButton.setVisibility(View.INVISIBLE);
            }
        }
    }


    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        image = savedInstanceState.getParcelable("BitmapImage");
        result.setImageBitmap(image);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putParcelable("BitmapImage", bitmap);
    }

    public void showPilzList (View view) {
        Intent intent = new Intent(this, DisplayListActivity.class);
        startActivity(intent);
    }
}
