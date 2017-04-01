package com.mushroom.android.cpptest;

import android.Manifest;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.res.AssetManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import permissions.dispatcher.NeedsPermission;
import permissions.dispatcher.RuntimePermissions;

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

    private String imagePath;

    private File file;
    private Uri fileUri;

    private List<Pilz> pilze = null;

    private List<Mushroom> mushrooms = null;

    private Mushroom[] mushrooms1 = null;

    private MushroomDetector mushRoom = new MushroomDetector();

    File photo = null;

    private Uri mImageUri;


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
            //pilze = parser.parse(getAssets().open("schwammerl.xml"));
            mushrooms = parser.parse(getAssets().open("schwammerl.xml"));

        }catch ( IOException a){
            a.printStackTrace();
        }
        this.mushrooms1 = new Mushroom[mushrooms.size()];
        for(int i = 0; i < mushrooms.size()-1; i++){
            mushrooms1[i] = mushrooms.get(i);
        }
        //Mushroom[] erkenntePilze = mushRoom.computeSchwammerlType(mushrooms1, "falscher Pfad");







        if(mushrooms.size()> 1){
            fragen.setText("Hat ihr Mushroom Lamellen?");
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


    public void dispatchTakePictureIntent(View view) throws IOException {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE);
        }
    }

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
            if( requestCode == REQUEST_IMAGE_CAPTURE ) {
                Bundle extras = data.getExtras();
                this.bitmap = (Bitmap) extras.get("data");
                String pathname = saveToInternalStorage(this.bitmap);
                result.setImageBitmap(this.bitmap);
                result.setAdjustViewBounds(false);


                mushrooms1 = mushRoom.computeSchwammerlType(this.mushrooms1, pathname + "/profile.jpg");
                System.out.println("asldjasldökj");

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

    public void clickedJa(View button) {
        List<Mushroom> pilze2 = new ArrayList<Mushroom>();
        int size = mushrooms.size()-1;

        if(fragen.getText().equals("Hat ihr Mushroom Lamellen?")){
            for(int i = 0; i <= size; i++ ){
                if(mushrooms.get(i).getLamellen()){
                    pilze2.add(mushrooms.get(i));
                }
            }

            mushrooms = pilze2;

            if(mushrooms.size() > 1 ){
                fragen.setText("Hat ihr Mushroom eine Knolle");
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

        else if(fragen.getText().equals("Hat ihr Mushroom eine Knolle?")){
            for(int i = 0; i <= size; i++ ){
                if(mushrooms.get(i).getKnollen()){
                    pilze2.add(mushrooms.get(i));
                }
            }

            mushrooms = pilze2;

            if(mushrooms.size() > 1 ){
                fragen.setText("Hat ihr Mushroom einen Stiel der " + mushrooms.get(0).getStiel());
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

    public String getOriginalImagePath() {
        String[] projection = { MediaStore.Images.Media.DATA };
        Cursor cursor = this.managedQuery(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                projection, null, null, null);
        int column_index_data = cursor
                .getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        cursor.moveToLast();

        return cursor.getString(column_index_data);
    }

    public void clickedNein(View button){
        List<Mushroom> pilze2 = new ArrayList<Mushroom>();
        int size = mushrooms.size()-1;

        if(fragen.getText().equals("Hat ihr Mushroom Lamellen?")){
            for(int i = 0; i <= size; i++ ){
                if(!mushrooms.get(i).getLamellen()){
                    pilze2.add(mushrooms.get(i));
                }
            }

            mushrooms = pilze2;

            if(mushrooms.size() > 1 ){
                fragen.setText("Hat ihr Mushroom eine Knolle");
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

        else if(fragen.getText().equals("Hat ihr Mushroom eine Knolle?")){
            for(int i = 0; i <= size; i++ ){
                if(!mushrooms.get(i).getKnollen()){
                    pilze2.add(mushrooms.get(i));
                }
            }

            mushrooms = pilze2;

            if(mushrooms.size() > 1 ){
                fragen.setText("Hat ihr Mushroom einen Stiel der " + mushrooms.get(0).getStiel());
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


                fragen.setText("Hat ihr Mushroom einen Stiel der " + mushrooms.get(0).getStiel());
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
