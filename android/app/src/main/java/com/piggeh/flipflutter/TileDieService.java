package com.piggeh.flipflutter;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Dialog;
import android.app.Service;
import android.content.Intent;
import android.graphics.drawable.Icon;
import android.os.IBinder;
import android.service.quicksettings.Tile;
import android.service.quicksettings.TileService;
import android.util.Log;

import com.piggeh.flipflutter.R;

import java.lang.annotation.ElementType;
import java.util.concurrent.ThreadLocalRandom;

@TargetApi(24)
public class TileDieService extends TileService {
    private static final String TAG = "TileDieService";
    public TileDieService() {
    }

    @Override
    public void onTileAdded(){
        Log.d(TAG, "onTileAdded");
    }

    @Override
    public void onTileRemoved(){
        Log.d(TAG, "onTileRemoved");
    }

    /*
    Called when the tile is brought into the listening state. Update it
    with your icon and title here, using getQsTile to get the tile
     */
    @Override
    public void onStartListening(){
        Log.d(TAG, "onStartListening");
        getQsTile().setState(Tile.STATE_INACTIVE);
        getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_dice_5));
        getQsTile().setLabel("Roll a die");
        getQsTile().updateTile();
        Log.d(TAG, "Set up Die tile");
    }

    /*
    Called when the tile is brought out of the listening state. This
    represents when getQsTile will now return null.
     */
    @Override
    public void onStopListening(){
        Log.d(TAG, "onStopListening");
        getQsTile().setState(Tile.STATE_INACTIVE);
        //getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_dice_5));
        //getQsTile().setLabel(getString(R.string.tile_die_title));
        getQsTile().updateTile();
        Log.d(TAG, "Reset Die tile");
    }

    /*
    Callec when the tile is clicked. Can be called multiple times in short
    succession, so double click (and beyond) is possible
     */
    @Override
    public void onClick(){
        Log.d(TAG, "onClick");
        int diceNumber = ThreadLocalRandom.current().nextInt(1, 6 + 1);
        getQsTile().setLabel(String.format("You rolled a %d",
                diceNumber));
        switch (diceNumber){
            case 1:
                getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_dice_1));
                break;
            case 2:
                getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_dice_2));
                break;
            case 3:
                getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_dice_3));
                break;
            case 4:
                getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_dice_4));
                break;
            case 5:
                getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_dice_5));
                break;
            case 6:
                getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_dice_6));
                break;
        }
        getQsTile().setState(Tile.STATE_ACTIVE);
        getQsTile().updateTile();
    }
}
