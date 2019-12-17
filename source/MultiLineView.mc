using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application.Properties as Properties;

class MultiLineView extends WatchUi.DataField {

    
    var sec = 0;
    var secTotal = 0;
    var hr = 0;
    var min = 0;
    var mainText = "Use semicolons ; to seperate lines!";
	function replaceSemi(inStr)
	{
		var tempText2 = inStr;
	    var semiIndex = tempText2.find(";");
	    while (semiIndex != null)
	    {
	    	tempText2 = tempText2.substring(0,semiIndex) + "\n" + tempText2.substring(semiIndex+1,tempText2.length());
	    	semiIndex = tempText2.find(";");
	    }
	    return tempText2;
	}
	function getSettings()
	{
		var tempText = Properties.getValue("multiLine1");
        mainText = replaceSemi(tempText);
        System.println(mainText);
	}
    function initialize() 
    {
    	
        DataField.initialize();
        getSettings();
        
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) 
    {
        
        
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function sec2deg (s)
	{
		if (s == null) {s = 0;}
		var lambda = (s.toFloat() - 0) / (60 - 0);
		if (lambda < 0) {lambda = 0;}
		if (lambda > 1) {lambda = 1;}
		var temp = 0 - lambda * (360f);
		temp +=90;
		if (temp < 0) {temp +=360f;}
		if (temp > 360) {temp -=360f;}
		return temp;
	}
	function sec2xy (offsetx,offsety,radius,sec)
	{
	
		var ret = new [2];
		var deg = sec2deg (sec);
		ret[0] = offsetx + Math.cos(-deg * 3.141592653589f / 180.0f) * radius;
		ret[1] = offsety + Math.sin(-deg * 3.141592653589f / 180.0f) * radius;
		return ret;
	}
	
    function compute(info) 
    {
        if ((info.timerTime != null) && (info.timerState != null)) 
		{
			if (info.timerState == Activity.TIMER_STATE_ON)
			{
				secTotal = (info.timerTime / 1000).toLong();
				sec = secTotal % 60;
				min = (secTotal / 60).toLong();
				hr = (secTotal / 3600).toLong();
			}
			//timeStr = min.format("%02d")+ ":" + sec.format("%02d");
		} 
    }
    

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) 
    {
    	//View.onUpdate(dc);
    	var thickness = 12;
    	var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var radius1 = dc.getHeight()/2 - thickness/2;
        var radius2 = radius1-thickness;
        var radius3 = radius1 + thickness / 2;
       
        //backgrounds first
        dc.setColor(0xffffff,0xffffff);
    	dc.clear();
    	dc.setColor( 0xa0a0a0, Graphics.COLOR_BLACK );
	    dc.fillRectangle(0,0,dc.getWidth(),30);
    	dc.setPenWidth(3);
    	dc.drawLine(0,30,dc.getWidth(),30);
	    
    	
    	
    	//Arcs second
    	
    	dc.setPenWidth(thickness);
        dc.setColor( 0xff0000, Graphics.COLOR_WHITE );
	    if (sec > 0) {dc.drawArc(centerX,centerY,radius1,dc.ARC_COUNTER_CLOCKWISE,sec2deg(sec),sec2deg(0));}
	    dc.setColor( 0x4040ff, Graphics.COLOR_WHITE );
	    if (min > 0) {dc.drawArc(centerX,centerY,radius2,dc.ARC_COUNTER_CLOCKWISE,sec2deg(min),sec2deg(0));}
    	
    	
    	
	    //Dots Third
	    var xy = sec2xy(centerX,centerY,radius3,0);
	    dc.setColor( 0x000000, Graphics.COLOR_BLACK );
	    dc.fillCircle(xy[0],xy[1],5);
	    
	    xy = sec2xy(centerX,centerY,radius3,15);
	    dc.setColor( 0x000000, Graphics.COLOR_BLACK );
	    dc.fillCircle(xy[0],xy[1],5);
	    
	    xy = sec2xy(centerX,centerY,radius3,30);
	    dc.setColor( 0x000000, Graphics.COLOR_BLACK );
	    dc.fillCircle(xy[0],xy[1],5);
	    
	    xy = sec2xy(centerX,centerY,radius3,45);
	    dc.setColor( 0x000000, Graphics.COLOR_BLACK );
	    dc.fillCircle(xy[0],xy[1],5);
    	
    	//Text Last
    	dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
    	dc.drawText(centerX,15,Graphics.FONT_SMALL,min.format("%02d")+":"+sec.format("%02d"),Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    	
    	var indent = 30;
    	
    	var myTextArea = new WatchUi.TextArea({
            :text=>mainText,
            :color=>Graphics.COLOR_BLACK,
            :font=>[Graphics.FONT_LARGE,Graphics.FONT_MEDIUM,Graphics.FONT_SMALL,Graphics.FONT_TINY,Graphics.FONT_XTINY],
            :locX =>indent,
            :locY=>indent,
            :width=>dc.getWidth()-indent*2,
            :height=>dc.getHeight()-indent*2
        });
        
        myTextArea.draw(dc);
        
        
        return;
        
	        
    	
    	
    	
        

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}
