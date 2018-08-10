package com.piggeh.flipflutter;

import android.annotation.TargetApi;
import android.app.Service;
import android.content.Intent;
import android.graphics.drawable.Icon;
import android.os.IBinder;
import android.service.quicksettings.Tile;
import android.service.quicksettings.TileService;
import android.util.Log;

import com.piggeh.flipflutter.R;

import java.util.concurrent.ThreadLocalRandom;

@TargetApi(24)
public class TileCoinService extends TileService {
    private static final String TAG = "TileCoinService";
    public TileCoinService() {
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
        getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_coin_head));
        getQsTile().setLabel("Flip a coin");
        getQsTile().updateTile();
        Log.d(TAG, "Set up Coin tile");
    }

    /*
    Called when the tile is brought out of the listening state. This
    represents when getQsTile will now return null.
     */
    @Override
    public void onStopListening(){
        Log.d(TAG, "onStopListening");
        getQsTile().setState(Tile.STATE_INACTIVE);
        //getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_coin_head));
        //getQsTile().setLabel(getString(R.string.tile_coin_title));
        getQsTile().updateTile();
        Log.d(TAG, "Reset Coin tile");
    }

    /*
    Callec when the tile is clicked. Can be called multiple times in short
    succession, so double click (and beyond) is possible
     */
    @Override
    public void onClick(){
        Log.d(TAG, "onClick");
        int diceNumber = ThreadLocalRandom.current().nextInt(1, 2 + 1);
        switch (diceNumber){
            case 1:
                getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_coin_head));
                getQsTile().setLabel("You flipped Heads");
                break;
            case 2:
                getQsTile().setIcon(Icon.createWithResource(this, R.drawable.ic_coin_tail));
                getQsTile().setLabel("You flipped Tails");
                break;
        }
        getQsTile().setState(Tile.STATE_ACTIVE);
        getQsTile().updateTile();
    }
}
