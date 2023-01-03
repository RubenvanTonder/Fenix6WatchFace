import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.Time.Gregorian;
import Toybox.Activity;


class Fenix6WatchFaceView extends WatchUi.WatchFace {
    var hrValue;
    var rectLength = 2;
    var rectWidth = 53;
    var x = 185;
    var y = 102;
    var batteryX = 198;
    var batteryY = 104;                  
    var verticalBatteryLines = 20;
    var horizontalBatteryLines = 40;
    var batteryState;
    var batteryDecrease = 6;
    var steps;
    var cals;
    var stepDisplay;
    var hrRecX = 0;
    var hrRecY = 190;
    var hrRecWidth = 35;
    var herRectheight = 5;
    var goatBitmap;

    function initialize() {
        WatchFace.initialize();
        hrValue=0.0f;
        goatBitmap = WatchUi.loadResource( Rez.Drawables.theGoat ) as BitmapResource;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MOWatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);
        
        //Get the date of today
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dayString = today.day.format("%d");
        var dayView = View.findDrawableById("DayOfMonth") as Text;
        dayView.setText(dayString);

        // Get the current battery percentage and format it correctly
        var systemStat = System.getSystemStats();
        var batteryString = systemStat.battery.format("%d") + "%";
        batteryState = systemStat.battery;

        // Get the total steps for today and format it correctly
        steps = ActivityMonitor.getInfo().steps;
        var stepDisplay = View.findDrawableById("Steps") as Text;
        var stepsString = "Steps: " + steps.format("%d");
        stepDisplay.setText(stepsString);

        // Get the total Calories for today and format it correctly
        cals = ActivityMonitor.getInfo().calories;
        var calsDisplay = View.findDrawableById("Cals") as Text;
        var calsString = "Cals: " + cals.format("%d");
        calsDisplay.setText(calsString);

        // Get HeartRate value and format it correctly
        hrValue = Activity.getActivityInfo().currentHeartRate;
        var hrDisplay = View.findDrawableById("hrValue") as Text;
        var hrString = "HR: " + hrValue.format("%d");
        hrDisplay.setText(hrString);
        
        //Get Day of the week
        var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayOfWeek = View.findDrawableById("DayOfWeek") as Text;
        dayOfWeek.setText(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][date.day_of_week - 1]);


        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        // Draw Rect
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.fillRectangle(x, y, rectLength, rectWidth);   

        // Draw a battery to present battery Status
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawRectangle(batteryX, batteryY, horizontalBatteryLines, verticalBatteryLines);
        // Determine batttery color
        if (batteryState>70){
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        }else if (batteryState > 30){
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        }else {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        }
        dc.fillRectangle(batteryX + 2,  batteryY + 2, (horizontalBatteryLines-4)*batteryState/100, verticalBatteryLines-4);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth , hrRecY, hrRecWidth, herRectheight);

        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth*2 + 5, hrRecY, hrRecWidth, herRectheight);

        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth*3 + 10, hrRecY, hrRecWidth, herRectheight);

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth*4 + 15, hrRecY, hrRecWidth, herRectheight);

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth*5 + 20, hrRecY, hrRecWidth, herRectheight);
       
       if(hrValue != null){
        if (hrValue.toNumber() >=154){
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
                dc.fillRectangle(hrRecX + hrRecWidth*5 + 20, hrRecY-2, hrRecWidth, herRectheight+4);             
        }else if (hrValue.toNumber() >=128){
                dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
                dc.fillRectangle(hrRecX + hrRecWidth*4 + 15, hrRecY-2, hrRecWidth, herRectheight+4);                
        }else if (hrValue.toNumber() >=102){
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
                dc.fillRectangle(hrRecX + hrRecWidth*3 + 10, hrRecY-2, hrRecWidth, herRectheight+4);
        }else if (hrValue.toNumber() >=76){
                dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
                dc.fillRectangle(hrRecX + hrRecWidth*2 + 5, hrRecY-2, hrRecWidth, herRectheight+4);
        }else if (hrValue.toNumber() >=50){
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
                dc.fillRectangle(hrRecX + hrRecWidth , hrRecY-2, hrRecWidth, herRectheight+4);
        }

        dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_WHITE);
        //dc.drawScaledBitmap(60, 20, 70, 70, goatBitmap);
        dc.drawBitmap(94, 30, goatBitmap);

    }

    }
    
 
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
