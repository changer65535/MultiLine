using Toybox.Application;

class MultiLineApp extends Application.AppBase 
{
	var multiView = null;
    function initialize() 
    {
        AppBase.initialize();
        multiView = new MultiLineView();
    }

    // onStart() is called on application start up
    function onStart(state) 
    {
    	 WatchUi.requestUpdate();
    }

    // onStop() is called when your application is exiting
    function onStop(state) 
    {
    	 WatchUi.requestUpdate();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ multiView ];
    }
    function onSettingsChanged() 
	{ 
	    multiView.getSettings();
	    WatchUi.requestUpdate();   // update the view to reflect changes
	}

}