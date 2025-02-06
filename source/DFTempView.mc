import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.System;

class DFTempView extends WatchUi.DataField {

    hidden var tempValue as Numeric;

    function initialize() {
        DataField.initialize();
        tempValue = -99.0f;
     }

    function onLayout(dc as Dc) as Void {
        View.setLayout(Rez.Layouts.L1(dc));
        (View.findDrawableById("lablTemp") as Text).setText(getTempLabl());
    }

    function compute(info as Activity.Info) as Void {
        tempValue = Application.Storage.getValue("temp");
        if (tempValue == null){
            tempValue = -299.0;
        }
        System.println(Lang.format("tempValue from Storage: $1$",[tempValue.format("%.2f")]));
    }

    function getTempLabl() as String{
        var devSettings = System.getDeviceSettings();
        if(devSettings.temperatureUnits == System.UNIT_STATUTE){
            return Lang.format("$1$[°F]", [loadResource(Rez.Strings.lablTemp)]);
        } else {
            return Lang.format("$1$[°C]", [loadResource(Rez.Strings.lablTemp)]);
        }
    }

    function getTempValue() as Float{
        var devSettings = System.getDeviceSettings();
        if(devSettings.temperatureUnits == System.UNIT_STATUTE){
            return tempValue*1.8+32;
        } else {
            return tempValue;
        }
    }

    function onUpdate(dc as Dc) as Void {
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        var valTemp = View.findDrawableById("valTemp") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            valTemp.setColor(Graphics.COLOR_WHITE);
            (View.findDrawableById("lablTemp") as Text).setColor(Graphics.COLOR_WHITE);
        } else {
            valTemp.setColor(Graphics.COLOR_BLACK);
            (View.findDrawableById("lablTemp") as Text).setColor(Graphics.COLOR_BLACK);
        }
        valTemp.setText(getTempValue().format("%.1f"));

        View.onUpdate(dc); // Call parent's onUpdate(dc) to redraw the layout
    }
}
