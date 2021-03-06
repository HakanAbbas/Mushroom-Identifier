package com.mushroom.android.cpptest;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    //Alle Deklarationen der einzelnen Variablen, die für die Kommunikation zwischen dem layout und der Java Klasse kommunizieren
    ImageView result;
    static final int REQUEST_IMAGE_CAPTURE = 1;
    public static final int IMAGE_GALLERY_REQUEST = 20;
    Bitmap image;
    Bitmap bitmap;
    Button yesButton;
    Button noButton;
    private ImageView imageView;
    private TextView questions;

    private List<Pilz> shrooms = null;

    private List<Mushroom> mushrooms = null;

    private Mushroom[] mushrooms1 = null;

    //Klasse für die JNI-Methode
    private MushroomDetector mushRoom = new MushroomDetector();


    private static final String TAG = "MainActivity" ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        questions = (TextView) findViewById(R.id.Question);

        yesButton = (Button) findViewById(R.id.Ja);

        yesButton.setVisibility(View.INVISIBLE);

        noButton = (Button) findViewById(R.id.Nein);

        noButton.setVisibility(View.INVISIBLE);

        // Referenz zur ImageView, wo das Foto angezeigt wird
        imageView = (ImageView) findViewById(R.id.imageView);

        Button click = (Button)findViewById(R.id.cameraButton);
        result = (ImageView) findViewById(R.id.imageView);

        //Speicherung der geparsten Pilze in eine Liste
        try{
            XMLPullParserHandler parser = new XMLPullParserHandler();
            //shrooms = parser.parse(getAssets().open("schwammerl.xml"));
            mushrooms = parser.parse(getAssets().open("schwammerl.xml"));

        }catch ( IOException a){
            a.printStackTrace();
        }

        //Die Liste wird in ein Array umgespeichert, damit dies dann der JNI-Methode als Parameter übergeben werden kann
        this.mushrooms1 = new Mushroom[mushrooms.size()];
        for(int i = 0; i < mushrooms.size()-1; i++){
            mushrooms1[i] = mushrooms.get(i);
        }






        //Benutzerfragen, falls mehr als ein Pilz erkennt wird
        if(mushrooms.size()> 1){
            questions.setText("Hat ihr Mushroom Lamellen?");
            yesButton.setVisibility(View.VISIBLE);
            noButton.setVisibility(View.VISIBLE);
        }
        else if(mushrooms.size() == 1){
            questions.setText(shrooms.get(0).getName());
            yesButton.setVisibility(View.INVISIBLE);
            noButton.setVisibility(View.INVISIBLE);
        }
        else{
            questions.setText("Leider keine Übereinstimmung");
            yesButton.setVisibility(View.INVISIBLE);
            noButton.setVisibility(View.INVISIBLE);
        }

    }

    //Funktion für Bildaufruf über die Galerie
    public void onImageGalleryClicked(View v){
        Intent photoPickerIntent = new Intent (Intent.ACTION_PICK);

        File pictureDirectory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        String pictureDirectoryPath = pictureDirectory.getPath();

        Uri data = Uri.parse(pictureDirectoryPath);

        photoPickerIntent.setDataAndType(data, "image/*");

        startActivityForResult(photoPickerIntent, IMAGE_GALLERY_REQUEST);
    }

    //Funktion für das schießen eines Bildes über die Kamera
    public void dispatchTakePictureIntent(View view) throws IOException {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE);
        }
    }

    //Das gespeicherte Bild wird in eine temporaere Datei im Smartphone gespeichert
    private String saveToInternalStorage(Bitmap bitmapImage){
        ContextWrapper cw = new ContextWrapper(getApplicationContext());
        // path to /data/data/yourapp/app_data/imageDir
        File directory = cw.getDir("imageDir", Context.MODE_PRIVATE);
        // Create imageDir
        File mypath=new File(directory,"profile.jpg");

        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(mypath);
            // Use the compress method on the BitMap object to write image to the OutputStream
            bitmapImage.compress(Bitmap.CompressFormat.PNG, 100, fos);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return directory.getAbsolutePath();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (resultCode == RESULT_OK) {
            //Wenn ein Bild geschossen wurde
            if( requestCode == REQUEST_IMAGE_CAPTURE ) {
                Bundle extras = data.getExtras();
                this.bitmap = (Bitmap) extras.get("data");
                String pathname = saveToInternalStorage(this.bitmap);
                result.setImageBitmap(this.bitmap);
                result.setAdjustViewBounds(false);


                mushrooms1 = mushRoom.computeSchwammerlType(this.mushrooms1, pathname + "/profile.jpg");
            //Wenn ein Bild über die Galerie geöffnet wurde
            }else if( requestCode == IMAGE_GALLERY_REQUEST){

                Uri imageUri = data.getData();

                InputStream inputStream;

                try{
                    inputStream = getContentResolver().openInputStream(imageUri);

                    Bitmap bitmap = BitmapFactory.decodeStream(inputStream);

                    imageView.setImageBitmap(bitmap);
                    imageView.setAdjustViewBounds(true);

                    String pathname = saveToInternalStorage(this.bitmap);
                    mushrooms1 = mushRoom.computeSchwammerlType(this.mushrooms1, pathname + "/profile.jpg");
                }catch(FileNotFoundException e){
                    e.printStackTrace();
                    Toast.makeText(this, "Unable to open image", Toast.LENGTH_LONG).show();
                }
            }
        }

    }

    //Wenn ein Pilz bei den Fragen eine bestimmte Eigenschaft hat, werden hier die Fragen jeweils angepasst und das gewünschte Pilz gesucht
    public void clickedYes(View button) {
        List<Mushroom> shroomsTemp = new ArrayList<Mushroom>();
        int size = mushrooms.size()-1;

        if(questions.getText().equals("Hat ihr Mushroom Lamellen?")){
            for(int i = 0; i <= size; i++ ){
                if(mushrooms.get(i).getLamella()){
                    shroomsTemp.add(mushrooms.get(i));
                }
            }

            mushrooms = shroomsTemp;

            if(mushrooms.size() > 1 ){
                questions.setText("Hat ihr Mushroom eine Knolle");
            }
            else if(mushrooms.size() == 1){
                questions.setText(mushrooms.get(0).getName());
                yesButton.setVisibility(View.INVISIBLE);
                noButton.setVisibility(View.INVISIBLE);
            }
            else{
                questions.setText("Leider keine Übereinstimmung");
            }
        }

        else if(questions.getText().equals("Hat ihr Mushroom eine Knolle?")){
            for(int i = 0; i <= size; i++ ){
                if(mushrooms.get(i).getNodule()){
                    shroomsTemp.add(mushrooms.get(i));
                }
            }

            mushrooms = shroomsTemp;

            if(mushrooms.size() > 1 ){
                questions.setText("Hat ihr Mushroom einen Stiel der " + mushrooms.get(0).getStalk());
            }
            else if(mushrooms.size() == 1){
                questions.setText(mushrooms.get(0).getName());
                yesButton.setVisibility(View.INVISIBLE);
                noButton.setVisibility(View.INVISIBLE);
            }
            else{
                questions.setText("Leider keine Übereinstimmung");
            }
        }
        else{
            questions.setText(mushrooms.get(0).getName());
            yesButton.setVisibility(View.INVISIBLE);
            noButton.setVisibility(View.INVISIBLE);
        }

    }

    //Wenn ein Pilz bei den Fragen keine bestimmte Eigenschaft hat, werden hier die Fragen jeweils angepasst und das gewünschte Pilz gesucht
    public void clickedNo(View button){
        List<Mushroom> shroomsTemp = new ArrayList<Mushroom>();
        int size = mushrooms.size()-1;

        if(questions.getText().equals("Hat ihr Mushroom Lamellen?")){
            for(int i = 0; i <= size; i++ ){
                if(!mushrooms.get(i).getLamella()){
                    shroomsTemp.add(mushrooms.get(i));
                }
            }

            mushrooms = shroomsTemp;

            if(mushrooms.size() > 1 ){
                questions.setText("Hat ihr Mushroom eine Knolle");
            }
            else if(mushrooms.size() == 1){
                questions.setText(mushrooms.get(0).getName());
                yesButton.setVisibility(View.INVISIBLE);
                noButton.setVisibility(View.INVISIBLE);
            }
            else{
                questions.setText("Leider keine Übereinstimmung");
                yesButton.setVisibility(View.INVISIBLE);
                noButton.setVisibility(View.INVISIBLE);
            }
        }

        else if(questions.getText().equals("Hat ihr Mushroom eine Knolle?")){
            for(int i = 0; i <= size; i++ ){
                if(!mushrooms.get(i).getNodule()){
                    shroomsTemp.add(mushrooms.get(i));
                }
            }

            mushrooms = shroomsTemp;

            if(mushrooms.size() > 1 ){
                questions.setText("Hat ihr Mushroom einen Stiel der " + mushrooms.get(0).getStalk());
            }
            else if(mushrooms.size() == 1){
                questions.setText(mushrooms.get(0).getName());
                yesButton.setVisibility(View.INVISIBLE);
                noButton.setVisibility(View.INVISIBLE);
            }
            else{
                questions.setText("Leider keine Übereinstimmung");
                yesButton.setVisibility(View.INVISIBLE);
                noButton.setVisibility(View.INVISIBLE);
            }
        }
        else{
            if(mushrooms.size() > 1 ){
                for(int i = 0; i <= size; i++){
                    shroomsTemp.add(mushrooms.get(i));
                }

                mushrooms = shroomsTemp;


                questions.setText("Hat ihr Mushroom einen Stiel der " + mushrooms.get(0).getStalk());
            }
            else{
                questions.setText("Leider keine Übereinstimmung");
                yesButton.setVisibility(View.INVISIBLE);
                noButton.setVisibility(View.INVISIBLE);
            }
        }
    }

    //Speichert den Zustand der App, damit Daten zb. bei Rotierungen des Smartphones nicht verloren gehen
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

    //Wenn auf "Pilzliste" Button gedürckt wird, dann wird auf eine neue View mit der Liste von Pilzen weitergeleitet
    public void showPilzList (View view) {
        Intent intent = new Intent(this, DisplayListActivity.class);
        startActivity(intent);
    }
}
