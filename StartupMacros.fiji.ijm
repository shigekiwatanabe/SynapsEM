// "StartupMacros"
// The macros and macro tools in this file ("StartupMacros.txt") are
// automatically installed in the Plugins>Macros submenu and
//  in the tool bar when ImageJ starts up.

//  About the drawing tools.
//
//  This is a set of drawing tools similar to the pencil, paintbrush,
//  eraser and flood fill (paint bucket) tools in NIH Image. The
//  pencil and paintbrush draw in the current foreground color
//  and the eraser draws in the current background color. The
//  flood fill tool fills the selected area using the foreground color.
//  Hold down the alt key to have the pencil and paintbrush draw
//  using the background color or to have the flood fill tool fill
//  using the background color. Set the foreground and background
//  colors by double-clicking on the flood fill tool or on the eye
//  dropper tool.  Double-click on the pencil, paintbrush or eraser
//  tool  to set the drawing width for that tool.
//
// Icons contributed by Tony Collins.

// Global variables
var pencilWidth=1,  eraserWidth=10, leftClick=16, alt=8;
var brushWidth = 10; //call("ij.Prefs.get", "startup.brush", "10");
var floodType =  "8-connected"; //call("ij.Prefs.get", "startup.flood", "8-connected");

// The macro named "AutoRunAndHide" runs when ImageJ starts
// and the file containing it is not displayed when ImageJ opens it.

// macro "AutoRunAndHide" {}

function UseHEFT {
	requires("1.38f");
	state = call("ij.io.Opener.getOpenUsingPlugins");
	if (state=="false") {
		setOption("OpenUsingPlugins", true);
		showStatus("TRUE (images opened by HandleExtraFileTypes)");
	} else {
		setOption("OpenUsingPlugins", false);
		showStatus("FALSE (images opened by ImageJ)");
	}
}

UseHEFT();

// The macro named "AutoRun" runs when ImageJ starts.

macro "AutoRun" {
	// run all the .ijm scripts provided in macros/AutoRun/
	autoRunDirectory = getDirectory("imagej") + "/macros/AutoRun/";
	if (File.isDirectory(autoRunDirectory)) {
		list = getFileList(autoRunDirectory);
		// make sure startup order is consistent
		Array.sort(list);
		for (i = 0; i < list.length; i++) {
			if (endsWith(list[i], ".ijm")) {
				runMacro(autoRunDirectory + list[i]);
			}
		}
	}
}

var pmCmds = newMenu("Popup Menu",
	newArray("Help...", "Rename...", "Duplicate...", "Original Scale",
	"Paste Control...", "-", "Record...", "Capture Screen ", "Monitor Memory...",
	"Find Commands...", "Control Panel...", "Startup Macros...", "Search..."));

macro "Popup Menu" {
	cmd = getArgument();
	if (cmd=="Help...")
		showMessage("About Popup Menu",
			"To customize this menu, edit the line that starts with\n\"var pmCmds\" in ImageJ/macros/StartupMacros.txt.");
	else
		run(cmd);
}

macro "Abort Macro or Plugin (or press Esc key) Action Tool - CbooP51b1f5fbbf5f1b15510T5c10X" {
	setKeyDown("Esc");
}

var xx = requires138b(); // check version at install
function requires138b() {requires("1.38b"); return 0; }

var dCmds = newMenu("Developer Menu Tool",
newArray("ImageJ Website","News", "Documentation", "ImageJ Wiki", "Resources", "Macro Language", "Macros",
	"Macro Functions", "Startup Macros...", "Plugins", "Source Code", "Mailing List Archives", "-", "Record...",
	"Capture Screen ", "Monitor Memory...", "List Commands...", "Control Panel...", "Search...", "Debug Mode"));

macro "Developer Menu Tool - C037T0b11DT7b09eTcb09v" {
	cmd = getArgument();
	if (cmd=="ImageJ Website")
		run("URL...", "url=http://rsbweb.nih.gov/ij/");
	else if (cmd=="News")
		run("URL...", "url=http://rsbweb.nih.gov/ij/notes.html");
	else if (cmd=="Documentation")
		run("URL...", "url=http://rsbweb.nih.gov/ij/docs/");
	else if (cmd=="ImageJ Wiki")
		run("URL...", "url=http://imagejdocu.tudor.lu/imagej-documentation-wiki/");
	else if (cmd=="Resources")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/");
	else if (cmd=="Macro Language")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/macro/macros.html");
	else if (cmd=="Macros")
		run("URL...", "url=http://rsbweb.nih.gov/ij/macros/");
	else if (cmd=="Macro Functions")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/macro/functions.html");
	else if (cmd=="Plugins")
		run("URL...", "url=http://rsbweb.nih.gov/ij/plugins/");
	else if (cmd=="Source Code")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/source/");
	else if (cmd=="Mailing List Archives")
		run("URL...", "url=https://list.nih.gov/archives/imagej.html");
	else if (cmd=="Debug Mode")
		setOption("DebugMode", true);
	else if (cmd!="-")
		run(cmd);
}

var sCmds = newMenu("Stacks Menu Tool",
	newArray("Add Slice", "Delete Slice", "Next Slice [>]", "Previous Slice [<]", "Set Slice...", "-",
		"Convert Images to Stack", "Convert Stack to Images", "Make Montage...", "Reslice [/]...", "Z Project...",
		"3D Project...", "Plot Z-axis Profile", "-", "Start Animation", "Stop Animation", "Animation Options...",
		"-", "MRI Stack (528K)"));
macro "Stacks Menu Tool - C037T0b11ST8b09tTcb09k" {
	cmd = getArgument();
	if (cmd!="-") run(cmd);
}

var luts = getLutMenu();
var lCmds = newMenu("LUT Menu Tool", luts);
macro "LUT Menu Tool - C037T0b11LT6b09UTcb09T" {
	cmd = getArgument();
	if (cmd!="-") run(cmd);
}
function getLutMenu() {
	list = getLutList();
	menu = newArray(16+list.length);
	menu[0] = "Invert LUT"; menu[1] = "Apply LUT"; menu[2] = "-";
	menu[3] = "Fire"; menu[4] = "Grays"; menu[5] = "Ice";
	menu[6] = "Spectrum"; menu[7] = "3-3-2 RGB"; menu[8] = "Red";
	menu[9] = "Green"; menu[10] = "Blue"; menu[11] = "Cyan";
	menu[12] = "Magenta"; menu[13] = "Yellow"; menu[14] = "Red/Green";
	menu[15] = "-";
	for (i=0; i<list.length; i++)
		menu[i+16] = list[i];
	return menu;
}

function getLutList() {
	lutdir = getDirectory("luts");
	list = newArray("No LUTs in /ImageJ/luts");
	if (!File.exists(lutdir))
		return list;
	rawlist = getFileList(lutdir);
	if (rawlist.length==0)
		return list;
	count = 0;
	for (i=0; i< rawlist.length; i++)
		if (endsWith(rawlist[i], ".lut")) count++;
	if (count==0)
		return list;
	list = newArray(count);
	index = 0;
	for (i=0; i< rawlist.length; i++) {
		if (endsWith(rawlist[i], ".lut"))
			list[index++] = substring(rawlist[i], 0, lengthOf(rawlist[i])-4);
	}
	return list;
}

macro "Pencil Tool - C037L494fL4990L90b0Lc1c3L82a4Lb58bL7c4fDb4L5a5dL6b6cD7b" {
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0)
		setColorToBackgound();
	draw(pencilWidth);
}

macro "Paintbrush Tool - C037La077Ld098L6859L4a2fL2f4fL3f99L5e9bL9b98L6888L5e8dL888c" {
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0)
		setColorToBackgound();
	draw(brushWidth);
}

macro "Flood Fill Tool -C037B21P085373b75d0L4d1aL3135L4050L6166D57D77D68La5adLb6bcD09D94" {
	requires("1.34j");
	setupUndo();
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0) setColorToBackgound();
	floodFill(x, y, floodType);
}

function draw(width) {
	requires("1.32g");
	setupUndo();
	getCursorLoc(x, y, z, flags);
	setLineWidth(width);
	moveTo(x,y);
	x2=-1; y2=-1;
	while (true) {
		getCursorLoc(x, y, z, flags);
		if (flags&leftClick==0) exit();
		if (x!=x2 || y!=y2)
			lineTo(x,y);
		x2=x; y2 =y;
		wait(10);
	}
}

function setColorToBackgound() {
	savep = getPixel(0, 0);
	makeRectangle(0, 0, 1, 1);
	run("Clear");
	background = getPixel(0, 0);
	run("Select None");
	setPixel(0, 0, savep);
	setColor(background);
}

// Runs when the user double-clicks on the pencil tool icon
macro 'Pencil Tool Options...' {
	pencilWidth = getNumber("Pencil Width (pixels):", pencilWidth);
}

// Runs when the user double-clicks on the paint brush tool icon
macro 'Paintbrush Tool Options...' {
	brushWidth = getNumber("Brush Width (pixels):", brushWidth);
	call("ij.Prefs.set", "startup.brush", brushWidth);
}

// Runs when the user double-clicks on the flood fill tool icon
macro 'Flood Fill Tool Options...' {
	Dialog.create("Flood Fill Tool");
	Dialog.addChoice("Flood Type:", newArray("4-connected", "8-connected"), floodType);
	Dialog.show();
	floodType = Dialog.getChoice();
	call("ij.Prefs.set", "startup.flood", floodType);
}

macro "Set Drawing Color..."{
	run("Color Picker...");
}

macro "-" {} //menu divider

macro "About Startup Macros..." {
	title = "About Startup Macros";
	text = "Macros, such as this one, contained in a file named\n"
		+ "'StartupMacros.txt', located in the 'macros' folder inside the\n"
		+ "Fiji folder, are automatically installed in the Plugins>Macros\n"
		+ "menu when Fiji starts.\n"
		+ "\n"
		+ "More information is available at:\n"
		+ "<http://imagej.nih.gov/ij/developer/macro/macros.html>";
	dummy = call("fiji.FijiTools.openEditor", title, text);
}

macro "Save As JPEG... [j]" {
	quality = call("ij.plugin.JpegWriter.getQuality");
	quality = getNumber("JPEG quality (0-100):", quality);
	run("Input/Output...", "jpeg="+quality);
	saveAs("Jpeg");
}

macro "Save Inverted FITS" {
	run("Flip Vertically");
	run("FITS...", "");
	run("Flip Vertically");
}

macro 'Freehand [f4]' {setTool(3)}
macro 'Straight Line [f5]' {setTool(4)}
macro 'Freeline [f6]' {setTool(6)}
macro 'Wand [f10]' {setTool(8)}

macro "Add Active Zone [9]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==7) {
    getSelectionCoordinates(xq, yq);
    List.setMeasurements;
    a = List.getValue("Length");
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    roiManager("Rename","Active_zone-"+toString(xq[0])+","+toString(yq[0])+","+toString(a));
    roiManager("Set Color", "8bd908");
    roiManager("Set Line Width", line_width);
    roiManager("Show All");
    run("Straight Line [f5]");
  } else {
   print("no freehand line");
   beep;
  }
}

macro "Add Ribbon [r]" {
  type = selectionType();
  if (type ==7) {
    getSelectionCoordinates(xq, yq);
    List.setMeasurements;
    a = List.getValue("Length");
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    roiManager("Rename","Ribbon-"+toString(xq[0])+","+toString(yq[0])+","+toString(a));
  } else {
   print("no freehand line");
   beep;
  }
}

macro "Add Dense Projection [d]" {
  type = selectionType();
  if (type ==7) {
    getSelectionCoordinates(xq, yq);
    List.setMeasurements;
    a = List.getValue("Length");
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    roiManager("Rename","Dense_projection-"+toString(xq[0])+","+toString(yq[0])+","+toString(a));
  } else {
   print("no freehand line");
   beep;
  }
}


macro "Add Plasma membrane [0]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==7) {
    getSelectionCoordinates(xq, yq);
    List.setMeasurements;
    a = List.getValue("Length");
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    roiManager("Rename","Plasma_membrane-"+toString(xq[0])+","+toString(yq[0])+","+toString(a));
    roiManager("Set Color", "#e68171");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand line");
   beep;
  }
}

macro "Add Endosome [n0]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==3 || type==2) {
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);
    getStatistics(area);  
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","Endosome-"+toString(area)+","+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#fe61aa");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand");
   beep;
  }
}

macro "Add SV [1]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","SV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#fac856");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add fSV [n1]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","fSV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#fac856");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add tethered SV  [2]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","tethered_SV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#00d300");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add tethered fSV  [n2]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","tethered_fSV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#00d300");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add docked SV [3]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","docked_SV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#0f6851");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add docked fSV [n3]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","docked_fSV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#0f6851");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add DCV [4]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","DCV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#1c0f27");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add docked DCV [5]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","docked_DCV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#1c0f27");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add LV [6]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","LV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#954ad5");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add fLV [n4]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","fLV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#954ad5");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add clathrin-coated vesicles [8]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","CCV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#2C6271");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add fCCV [n5]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","fCCV-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#2C6271");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add Pits [u]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==7) {
    getSelectionCoordinates(xq, yq);
    List.setMeasurements;
    a = List.getValue("Length");
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    roiManager("Rename","pits-"+toString(xq[0])+","+toString(yq[0])+","+toString(a));
    roiManager("Set Color", "#d84b23");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand line");
   beep;
  }
}

macro "Add fPits [n6]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==7) {
    getSelectionCoordinates(xq, yq);
    List.setMeasurements;
    a = List.getValue("Length");
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    roiManager("Rename","fpits-"+toString(xq[0])+","+toString(yq[0])+","+toString(a));
    roiManager("Set Color", "#d84b23");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand line");
   beep;
  }
}

macro "Add clathrin-coated_pits [7]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==7) {
    getSelectionCoordinates(xq, yq);
    List.setMeasurements;
    a = List.getValue("Length");
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    roiManager("Rename","coated_pits-"+toString(xq[0])+","+toString(yq[0])+","+toString(a));
    roiManager("Set Color", "cyan");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand line");
   beep;
  }
}

macro "Add particle [p]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==5) {
    getLine(x1, y1, x2, y2, lineWidth);
    xc=(x2+x1)/2;
    yc=(y2+y1)/2;
print(xc+" , "+yc);
    r=sqrt(pow((x2-x1),2)+pow((y2-y1),2))/2;
    makeOval(xc-r,yc-r,r*2,r*2);
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","particle-"+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#1c0f27");
    roiManager("Set Line Width", line_width);
  } else {
   print("no line");
   beep;
  }
}

macro "Add fEndosome [n8]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==3 || type==2) {
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);
    getStatistics(area);  
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","fEndosome-"+toString(area)+","+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#fe61aa");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand");
   beep;
  }
}

macro "Add fMVB [n7]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==3 || type==2) {
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);
    getStatistics(area);  
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","fMVB-"+toString(area)+","+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#f75c00");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand");
   beep;
  }
}

macro "Add MVB [m]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==3 || type==2) {
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);
    getStatistics(area);  
    getSelectionBounds(x, y, width, height);
    roiManager("Rename","MVB-"+toString(area)+","+toString(x+width/2)+","+toString(y+height/2));
    roiManager("Set Color", "#f75c00");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand");
   beep;
  }
}


macro "Add Buds [j]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==7) {
    getSelectionCoordinates(xq, yq);
    List.setMeasurements;
    a = List.getValue("Length");
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    roiManager("Rename","buds-"+toString(xq[0])+","+toString(yq[0])+","+toString(a));
    roiManager("Set Color", "#bd7898");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand line");
   beep;
  }
}

macro "Add fBuds [n9]" {
  type = selectionType();
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  if (type ==7) {
    getSelectionCoordinates(xq, yq);
    List.setMeasurements;
    a = List.getValue("Length");
    roiManager("Add");
    roiManager("Select",roiManager("Count")-1);    
    roiManager("Rename","fbuds-"+toString(xq[0])+","+toString(yq[0])+","+toString(a));
    roiManager("Set Color", "#bd7898");
    roiManager("Set Line Width", line_width);
  } else {
   print("no freehand line");
   beep;
  }
}

macro "Export ROI[e]" {
  n = roiManager("count");
  id = getInfo("slice.label");
  dir = getDirectory("image");
  file = File.open(dir+id+".txt");
  for (j=0; j<n; j++) {
    roiManager("select", j);
    type = selectionType();
    fullname = call("ij.plugin.frame.RoiManager.getName", j);
    name=substring(fullname,0,indexOf(fullname,"-"));
    if (type ==5 || type==3) {
      getStatistics(area);
      getSelectionCoordinates(xl, yl);
      area=toString(area);
      xvals=toString(xl[0]);
      yvals=toString(yl[0]);
      for (i=1; i< lengthOf(xl); i++) {
        xvals=toString(xvals+","+xl[i]);
        yvals=toString(yvals+","+yl[i]);
      }  
      print(file,type+"\t"+name+"\t"+area+"\t"+xvals+"\t"+ yvals);
    }  else if (type==1) {
      getBoundingRect(x, y, w, h);
      print (file,type+"\t"+name+"\t"+x+w/2+"\t"+y+h/2+"\t"+w/2);
    }  else if (type==10) {
      getSelectionCoordinates(xm, ym);   
      print (file,type+"\t"+name+"\t"+xm[0]+"\t"+ym[0]);
    } else if (type==7) {
      getSelectionCoordinates(xn, yn);
      List.setMeasurements;
      perimeter=List.getValue("Length");
      xcords=toString(xn[0]);   
      ycords=toString(yn[0]); 
      for (k=1;k< lengthOf(xn); k++) {
        xcords=toString(xcords+","+xn[k]);
        ycords=toString(ycords+","+yn[k]);
      }
      print (file,type+"\t"+name+"\t"+perimeter+"\t"+xcords+"\t"+ycords);
    } else {
      print("unknown type"+type);
    }
  }
  roiManager("reset");
  run("Next Slice [>]");
  run('Freeline [f6]');
}


macro "Import ROI[i]" {
  roiManager("reset")
  roiManager("Show All")
  dir = getDirectory("image");
  id = getInfo("slice.label");
  path = dir+id+".txt";
  if (File.exists(path)==1) {
  file=File.openAsString(path);
  record=split(file,"\n");
  width = getWidth;
  height = getHeight;
  if (width >= height) {
  	line_width = height*0.001;
  } else { line_width = width*0.001; };
  for (i=0; i<lengthOf(record); i++) {
    field=split(record[i],"\t");
    type=field[0];
    if (type == 1) {
      xc=field[2];
      yc=field[3];
      r=field[4];
      name=field[1]+"-"+xc+","+yc;
      makeOval(xc-r,yc-r,r*2,r*2);
      roiManager("Add");
      roiManager("Select",roiManager("Count")-1);    
      roiManager("Rename",name);
      roiManager("Set Line Width", 3);
      if (matches(name, ".*docked_SV.*")) {
      	roiManager("Set Color", "#0f6851")}
      	else if (matches(name, ".*docked_fSV.*")) {
      	roiManager("Set Color", "#0f6851")}
      	else if (matches(name, ".*DCV.*")) {
      	roiManager("Set Color", "#1c0f27")}
      	else if (matches(name, ".*LV.*")) {
      	roiManager("Set Color", "#954ad5")}
      	else if (matches(name, ".*CCV.*")) {
      	roiManager("Set Color", "#2C6271")}
      	else if (matches(name, ".*SV.*")) {
      	roiManager("Set Color", "#fac856")}
    } else if (type == 3) {
      area=field[2];
      xl=split(field[3],",");
      yl=split(field[4],",");
      makeSelection("freehand",xl,yl);
      roiManager("Add");
      roiManager("Select",roiManager("Count")-1);
      getStatistics(area); 
      getSelectionBounds(x, y, width, height);
      roiManager("Rename",toString(field[1])+"-"+toString(area)+","+toString(x+width/2)+","+toString(y+height/2));
      roiManager("Set Color", "#fe61aa"); 
      roiManager("Set Line Width", line_width);
    } else if (type==7) {
      xn=split(field[3],",");
      yn=split(field[4],",");
      a=field[2];
      makeSelection("freeline",xn,yn);
      roiManager("Add");
      roiManager("Select",roiManager("Count")-1);
      getSelectionCoordinates(xn, yn);
      roiManager("Rename",toString(field[1])+"-"+toString(xn[0])+","+toString(yn[0])+","+toString(a));
      roiManager("Set Line Width", line_width);
      name=Roi.getName();
      if (matches(name, ".*coated_pits.*")) {
      	roiManager("Set Color", "cyan")}
      	else if (matches(name, ".*pits.*")) {
      	roiManager("Set Color", "#d84b23")}
      	else if (matches(name, ".*buds.*")) {
      	roiManager("Set Color", "#bd7898")}
      	else if (matches(name, ".*Plasma_membrane.*")) {
      	roiManager("Set Color", "#e68171")}
      	else if (matches(name, ".*Active_zone.*")) {
      	roiManager("Set Color", "#8bd908")}
    } else if (type == 10) {
      xm=split(field[2],",");
      ym=split(field[3],",");
      makeSelection("point",xm,ym);
      roiManager("Add");
      roiManager("Select",roiManager("Count")-1);
      getSelectionCoordinates(xp,yp);
      roiManager("Rename",toString(field[1])+"-"+toString(xp[0])+","+toString(yp[0]));
      roiManager("Set Color", "red"); 
      roiManager("Set Line Width", line_width);     
    }
  }
} else {
   print(id + " has no segmentation");}
}

macro "Set scale [f2]"{
       run("Set Scale...", "distance=1 known=1 pixel=1 unit=[ ] global");
}

macro "Open image sequence[f1]"{
       run("Image Sequence...");
       run("Set Scale...", "distance=1 known=1 pixel=1 unit=[ ] global");
       run("Brightness/Contrast...");
}

macro "Open image sequence contrast enhanced[f9]"{
run("Image Sequence...", "sort");
run("Enhance Contrast...", "saturated=0.4 process_all");
}

macro 'Show_all [f7]' {roiManager("Show All")}

macro 'Show_none [f8]' {roiManager("Show None")}

macro "SVG[f3]" {
  n = roiManager("count");
  id = getInfo("slice.label");
  dir = getDirectory("image");
  file = File.open(dir+id+".svg");
  n = roiManager("count");
  w = getWidth;
  h = getHeight;
  print(file, '<svg id="svgbox" width='+w+'px" height="'+h+'px" xmlns="http://www.w3.org/2000/svg"');
  print(file, 'version="1.1" preserveAspectRatio="xMidYMid meet" viewBox="437 -3 '+w+' '+h+'">');
 for (j = 0; j < n; j++){

roiManager("select", j);
getSelectionCoordinates(x, y);
text = '<polyline points="';
x2 = y2 = 0;
for (i = 0; i < x.length; i++) {
    text = text + " " + (x[i] - x2) + "," + (y[i] - y2);
    x2 = x[i];
    y2 = y[i];}

text = text + " z' />";
print(file,text); 
 }
print(file,'</svg>');