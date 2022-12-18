import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.Time.Gregorian;
import Toybox.Activity;
import Toybox.Graphics;

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

    function initialize() {
        WatchFace.initialize();
        hrValue=0.0f;

    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
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

        // Get the current battery percentage and format it correctly
        var systemStat = System.getSystemStats();
        var batteryString = systemStat.battery.format("%d") + "%";
        batteryState = systemStat.battery;

        // Get HeartRate value and format it correctly
        hrValue = Activity.getActivityInfo().currentHeartRate;
        var value = View.findDrawableById("heartRate") as Text;
        if(hrValue == null){
            value.setText("HR " + "--");
        }else{
            value.setText("HR " + hrValue.format("%.f"));
        }
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
