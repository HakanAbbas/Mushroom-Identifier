package com.example.christianaberger.cpptest;

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
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
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

    private List<Mushroom> mushrooms = null;

    private static final String TAG = "MainActivity" ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        /*
        AssetUtilities assetUtilities = new AssetUtilities(this);
        TextView tv = (TextView) findViewById(R.id.sample_text);
        ImageView originalImageView = (ImageView)findViewById(R.id.image);
        ImageView grayedView = (ImageView)findViewById(R.id.gray);
        AssetManager assetManager = getAssets();
        MushroomDetector mushRoom = new MushroomDetector();
        File[] files = fetchImages();
        for (File file: files) {
            Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());
            originalImageView.setImageBitmap(bitmap);
            Mushroom mushroom = new Mushroom();
            mushroom.color = new byte[] {(byte)0x01, (byte)0x02, (byte)0x03};
            mushroom.mushroomName = "a name";
            Mushroom[] templates = new Mushroom[] {mushroom};
            Mushroom[] mushrooms = mushRoom.computeSchwammerlType(templates, file.getAbsolutePath());
            Log.d(TAG, "found file " + file +  " type " + mushrooms);
            bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());
            grayedView.setImageBitmap(bitmap);
        }
    }
    private File[] fetchImages() {
        File cacheDir = getCacheDir();
        File destinationFolder = new File(cacheDir, "mushroomimages");
        AssetUtilities assetUtilities = new AssetUtilities(this);
        File[] files = new File[0];
        try {
            files = assetUtilities.copyAssetToCacheFolder("mushroomimages", destinationFolder);
        } catch (IOException e) {
            Log.e(TAG, "failed to fetch images from assets", e);
        }
        return files;
    }
    */

        MushroomDetector mushRoom = new MushroomDetector();
        Pilz pilz = new Pilz();


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
            //pilze = parser.parse(getAssets().open("schwammerl.xml"));
            mushrooms = parser.parse(getAssets().open("schwammerl.xml"));

        }catch ( IOException e){
            e.printStackTrace();
        }/*
        Mushroom[] mushrooms1 = new Mushroom[mushrooms.size()];
        for(int i = 0; i < mushrooms.size()-1; i++){
            mushrooms1[i] = mushrooms.get(i);
        }
        Mushroom[] erkenntePilze = mushRoom.computeSchwammerlType(mushrooms1, "somePathtoPicture");
        */







        if(mushrooms.size()> 1){
            fragen.setText("Hat ihr Pilz Lamellen?");
            jaButton.setVisibility(View.VISIBLE);
            neinButton.setVisibility(View.VISIBLE);
        }
        else if(mushrooms.size() == 1){
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
        List<Mushroom> pilze2 = new ArrayList<Mushroom>();
        int size = mushrooms.size()-1;

        if(fragen.getText().equals("Hat ihr Pilz Lamellen?")){
            for(int i = 0; i <= size; i++ ){
                if(mushrooms.get(i).getLamellen()){
                    pilze2.add(mushrooms.get(i));
                }
            }

            mushrooms = pilze2;

            if(mushrooms.size() > 1 ){
                fragen.setText("Hat ihr Pilz eine Knolle");
            }
            else if(mushrooms.size() == 1){
                fragen.setText(mushrooms.get(0).getName());
                jaButton.setVisibility(View.INVISIBLE);
                neinButton.setVisibility(View.INVISIBLE);
            }
            else{
                fragen.setText("Leider keine Übereinstimmung");
            }
        }

        else if(fragen.getText().equals("Hat ihr Pilz eine Knolle?")){
            for(int i = 0; i <= size; i++ ){
                if(mushrooms.get(i).getKnollen()){
                    pilze2.add(mushrooms.get(i));
                }
            }

            mushrooms = pilze2;

            if(mushrooms.size() > 1 ){
                fragen.setText("Hat ihr Pilz einen Stiel der " + mushrooms.get(0).getStiel());
            }
            else if(mushrooms.size() == 1){
                fragen.setText(mushrooms.get(0).getName());
                jaButton.setVisibility(View.INVISIBLE);
                neinButton.setVisibility(View.INVISIBLE);
            }
            else{
                fragen.setText("Leider keine Übereinstimmung");
            }
        }
        else{
            fragen.setText(mushrooms.get(0).getName());
            jaButton.setVisibility(View.INVISIBLE);
            neinButton.setVisibility(View.INVISIBLE);
        }

    }

    public void clickedNein(View button){
        List<Mushroom> pilze2 = new ArrayList<Mushroom>();
        int size = mushrooms.size()-1;

        if(fragen.getText().equals("Hat ihr Pilz Lamellen?")){
            for(int i = 0; i <= size; i++ ){
                if(!mushrooms.get(i).getLamellen()){
                    pilze2.add(mushrooms.get(i));
                }
            }

            mushrooms = pilze2;

            if(mushrooms.size() > 1 ){
                fragen.setText("Hat ihr Pilz eine Knolle");
            }
            else if(mushrooms.size() == 1){
                fragen.setText(mushrooms.get(0).getName());
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
                if(!mushrooms.get(i).getKnollen()){
                    pilze2.add(mushrooms.get(i));
                }
            }

            mushrooms = pilze2;

            if(mushrooms.size() > 1 ){
                fragen.setText("Hat ihr Pilz einen Stiel der " + mushrooms.get(0).getStiel());
            }
            else if(mushrooms.size() == 1){
                fragen.setText(mushrooms.get(0).getName());
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
            if(mushrooms.size() > 1 ){
                for(int i = 0; i <= size; i++){
                    pilze2.add(mushrooms.get(i));
                }

                mushrooms = pilze2;


                fragen.setText("Hat ihr Pilz einen Stiel der " + mushrooms.get(0).getStiel());
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
/*
        AssetUtilities assetUtilities = new AssetUtilities(this);
        TextView tv = (TextView) findViewById(R.id.sample_text);
        ImageView originalImageView = (ImageView)findViewById(R.id.image);
        ImageView grayedView = (ImageView)findViewById(R.id.gray);
        AssetManager assetManager = getAssets();
        MushroomDetector mushRoom = new MushroomDetector();
        File[] files = fetchImages();
        for (File file: files) {
            Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());
            originalImageView.setImageBitmap(bitmap);
            Mushroom mushroom = new Mushroom();
            mushroom.color = new byte[] {(byte)0x01, (byte)0x02, (byte)0x03};
            mushroom.mushroomName = "a name";
            Mushroom[] templates = new Mushroom[] {mushroom};
            Mushroom[] mushrooms = mushRoom.computeSchwammerlType(templates, file.getAbsolutePath());
            Log.d(TAG, "found file " + file +  " type " + mushrooms);
            bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());
            grayedView.setImageBitmap(bitmap);
        }
    }
    private File[] fetchImages() {
        File cacheDir = getCacheDir();
        File destinationFolder = new File(cacheDir, "mushroomimages");
        AssetUtilities assetUtilities = new AssetUtilities(this);
        File[] files = new File[0];
        try {
            files = assetUtilities.copyAssetToCacheFolder("mushroomimages", destinationFolder);
        } catch (IOException e) {
            Log.e(TAG, "failed to fetch images from assets", e);
        }
        return files;
    }
    */