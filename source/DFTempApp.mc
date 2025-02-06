import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.System;
import Toybox.Background;

class DFTempApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //retrieve Data from ServiceDelegate
    function onBackgroundData(data as Application.PersistableType) {
		System.println("onBackgroundData: "+ data);
		Application.Storage.setValue("temp", data);
    }

    //! Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        if(Toybox.System has :ServiceDelegate) {
            System.println("register ServiceDelegate");
    		Background.registerForTemporalEvent(new Time.Duration(5*60));
   		}
        return [ new DFTempView() ];
    }

}

function getApp() as DFTempApp {
    return Application.getApp() as DFTempApp;
}

(:background)
class BackgroundServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        System.println("BackgroundServiceDelegate: initialize");
        ServiceDelegate.initialize();
        
    }
    function onTemporalEvent() as Void {
        System.println("BackgroundServiceDelegate: onTemporalEvent");
        var sinfo=Sensor.getInfo();
        var temp=sinfo.temperature;
        if(temp==null) {
            temp=-199.0;
        }
        Background.exit(temp);
    }
}