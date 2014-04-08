package com.citronium.zbarcdvplugin.core;

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

public class ViewFinderView extends View {
    private static final String TAG = "ViewFinderView";
    private String PACKAGE_NAME;

    private Rect mFramingRect;

    private static final int[] SCANNER_ALPHA = {0, 64, 128, 192, 255, 192, 128, 64};
    private int scannerAlpha;
    private static final long ANIMATION_DELAY = 80l;

    private void init(Context context) {
        PACKAGE_NAME = context.getPackageName();
    }

    public ViewFinderView(Context context) {
        super(context);
        init(context);

    }

    public ViewFinderView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public void setupViewFinder() {
        initFramingRect();
        invalidate();
    }

    public Rect getFramingRect() {
        return mFramingRect;
    }

    @Override
    public void onDraw(Canvas canvas) {
        if(mFramingRect == null) {
            return;
        }

        drawViewFinderMask(canvas);
        drawLaser(canvas);
    }

    public void drawViewFinderMask(Canvas canvas) {
        Paint paint = new Paint();
        Resources resources = getResources();
        paint.setColor(resources.getColor(resources.getIdentifier("viewfinder_mask", "color", PACKAGE_NAME)));

        canvas.drawRect(mFramingRect.left, mFramingRect.top, mFramingRect.right, mFramingRect.bottom, paint);
    }

    public void drawLaser(Canvas canvas) {
        Paint paint = new Paint();
        Resources resources = getResources();
        // Draw a red "laser scanner" line through the middle to show decoding is active
        paint.setColor(resources.getColor(resources.getIdentifier("viewfinder_laser", "color", PACKAGE_NAME)));
        paint.setAlpha(SCANNER_ALPHA[scannerAlpha]);
        paint.setStyle(Paint.Style.FILL);
        scannerAlpha = (scannerAlpha + 1) % SCANNER_ALPHA.length;

        int middle = mFramingRect.top + mFramingRect.height() / 2;
        canvas.drawRect(mFramingRect.left, middle - 1, mFramingRect.right, middle + 2, paint);

        postInvalidateDelayed(ANIMATION_DELAY, mFramingRect.left, mFramingRect.top, mFramingRect.right, mFramingRect.bottom);
    }

    public synchronized void initFramingRect() {
        Point screenResolution = DisplayUtils.getScreenResolution(getContext());
        if (screenResolution == null) {
            return;
        }

        int width = ViewFinderView.getScanAreaWidth(getContext(), screenResolution);
        int height = ViewFinderView.getScanAreaHeight(getContext(), screenResolution);
        int xOffset = (screenResolution.x - width) / 2;
        int yOffset = (screenResolution.y - height) / 2;

        mFramingRect = new Rect(xOffset, yOffset, width + xOffset, yOffset + height);
    }

    private static int findDesiredDimensionInRange(float ratio, int resolution, int hardMin, int hardMax) {
        int dim = (int) (ratio * resolution);
        if (dim < hardMin) {
            return hardMin;
        }
        if (dim > hardMax) {
            return hardMax;
        }
        return dim;
    }

    static public int getScanAreaWidth(Context context, Point screenSize) {
        int orientation = DisplayUtils.getScreenOrientation(context);
        double width = screenSize.x;

        if (orientation != Configuration.ORIENTATION_PORTRAIT) {
            width = screenSize.x * 2 / 3;
        }

        return (int)width;
    }

    static public int getScanAreaHeight(Context context, Point screenSize) {
        int orientation = DisplayUtils.getScreenOrientation(context);
        double height = 0.2;

        if (orientation != Configuration.ORIENTATION_PORTRAIT) {
            height *= screenSize.y;
        } else {
            height *= screenSize.x;
        }

        return (int) height;
    }

}
