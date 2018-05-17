package com.piggeh.flip;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Vibrator;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.animation.FastOutSlowInInterpolator;
import android.support.wearable.activity.WearableActivity;
import android.support.wearable.view.drawer.WearableDrawerLayout;
import android.support.wearable.view.drawer.WearableNavigationDrawer;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.DecelerateInterpolator;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

public class WearDrawerActivity extends WearableActivity {

    private static final String TAG = "WearDrawerActivity";

    //drawer stuff
    private WearableDrawerLayout mWearableDrawerLayout;
    private WearableNavigationDrawer mWearableNavigationDrawer;

    /*private RelativeLayout dieRollView;
    private RelativeLayout coinFlipView;*/
    private ImageView icon;
    //private ImageView iconCoin;

    public int appMode = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_drawer);
        Log.d(TAG, "WearDrawerActivity launched");

        //Main Wearable Drawer Layout that wraps all content
        mWearableDrawerLayout = (WearableDrawerLayout) findViewById(R.id.drawer_layout);

        //Titles
        ArrayList<String> dataSetTitles = new ArrayList<>();
        dataSetTitles.add(getString(R.string.drawer_dieroll));
        dataSetTitles.add(getString(R.string.drawer_coinflip));
        //Icons
        ArrayList<Drawable> dataSetIcons = new ArrayList<>();
        dataSetIcons.add(ContextCompat.getDrawable(this, R.drawable.ic_dice_5));
        dataSetIcons.add(ContextCompat.getDrawable(this, R.drawable.ic_drawer_coinflip));

        //Top Navigation Drawer
        mWearableNavigationDrawer = (WearableNavigationDrawer) findViewById(R.id.top_navigation_drawer);
        mWearableNavigationDrawer.setAdapter(new NavigationDrawerAdapter(dataSetTitles, dataSetIcons));


        //set up stuff for actual content
        /*dieRollView = (RelativeLayout) findViewById(R.id.container_dieroll);
        coinFlipView = (RelativeLayout) findViewById(R.id.container_coinflip);*/
        icon = (ImageView) findViewById(R.id.icon);
        //iconCoin = (ImageView) findViewById(R.id.icon_coin);
    }

    @Override
    public void onResume(){
        mWearableDrawerLayout.peekDrawer(Gravity.TOP);
        super.onResume();
    }

    public int diceNumber;
    public ObjectAnimator objectAnimator;

    public void onButtonClick(View view){
        switch (appMode){
            case 0:
                doDieRoll();
                break;
            case 1:
                doCoinFlip();
                break;
        }
    }

    public void doDieRoll(){
        Log.i(TAG, "Doing DieRoll");
        //Change ImageButton icon
        diceNumber = ThreadLocalRandom.current().nextInt(1, 6 + 1);
                        /*if (imageView_icon.getAnimation() != null){
                            imageView_icon.getAnimation().setAnimationListener(null);
                        }*/
        if (objectAnimator != null){
            objectAnimator.removeAllListeners();
        }
        icon.clearAnimation();
        objectAnimator = ObjectAnimator.ofFloat(icon, View.ROTATION, 180f);
        objectAnimator.setDuration(500);
        objectAnimator.setInterpolator(new FastOutSlowInInterpolator());
        objectAnimator.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                // Vibrate for 100 milliseconds
                Vibrator v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
                v.vibrate(100);
                icon.setRotation(0f);
            }
        });
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                //set button icon
                switch (diceNumber){
                    case 1:
                        icon.setImageResource(R.drawable.ic_dice_1);
                        break;
                    case 2:
                        icon.setImageResource(R.drawable.ic_dice_2);
                        break;
                    case 3:
                        icon.setImageResource(R.drawable.ic_dice_3);
                        break;
                    case 4:
                        icon.setImageResource(R.drawable.ic_dice_4);
                        break;
                    case 5:
                        icon.setImageResource(R.drawable.ic_dice_5);
                        break;
                    case 6:
                        icon.setImageResource(R.drawable.ic_dice_6);
                }
            }
        }, 250);
        objectAnimator.start();
    }
    public void doCoinFlip(){
        Log.i(TAG, "Doing CoinFlip");
        //Change ImageButton icon
        diceNumber = ThreadLocalRandom.current().nextInt(1, 2 + 1);
                        /*if (imageView_icon.getAnimation() != null){
                            imageView_icon.getAnimation().setAnimationListener(null);
                        }*/
        if (objectAnimator != null){
            objectAnimator.removeAllListeners();
        }
        icon.clearAnimation();
        objectAnimator = ObjectAnimator.ofFloat(icon, View.ROTATION, 360f);
        objectAnimator.setDuration(500);
        objectAnimator.setInterpolator(new FastOutSlowInInterpolator());
        objectAnimator.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                // Vibrate for 100 milliseconds
                Vibrator v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
                v.vibrate(100);
                icon.setRotation(0f);
            }
        });

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                //set button icon
                switch (diceNumber){
                    case 1:
                        icon.setImageResource(R.drawable.ic_coin_head);
                        break;
                    case 2:
                        icon.setImageResource(R.drawable.ic_coin_tail);
                        break;
                }
            }
        }, 250);
        objectAnimator.start();
    }

    class NavigationDrawerAdapter extends WearableNavigationDrawer.WearableNavigationDrawerAdapter {
        private static final String TAG = "NavDrawerAdapter";
        private ArrayList<String> dataSetText;
        private ArrayList<Drawable> dataSetDrawables;

        public NavigationDrawerAdapter(ArrayList<String> setText, ArrayList<Drawable> setDrawables){
            dataSetText = setText;
            dataSetDrawables = setDrawables;
        }

        @Override
        public String getItemText(int i) {
            return dataSetText.get(i);
        }

        @Override
        public Drawable getItemDrawable(int i) {
            return dataSetDrawables.get(i);
        }

        @Override
        public void onItemSelected(int i) {
            Log.d(TAG, "Drawer item " + String.valueOf(i) + " selected");
            //super.onItemSelected(i);
            if (objectAnimator != null){
                objectAnimator.removeAllListeners();
            }
            icon.clearAnimation();
            icon.setRotation(0);


            switch (i){
                case 1:
                    appMode = 1;
                    icon.setImageResource(R.drawable.ic_coin_head);
                    break;
                case 0:
                    appMode = 0;
                    icon.setImageResource(R.drawable.ic_dice_5);
                    break;
            }
        }

        @Override
        public int getCount() {
            return Math.min(dataSetText.size(), dataSetDrawables.size());
        }
    }
}
