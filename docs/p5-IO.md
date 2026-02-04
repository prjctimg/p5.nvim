📄 *p5.IO*📄
IO module functions and properties

==============================================================================
Tags p5.IO IO module functions and properties
==============================================================================



CONTENTS                                                           *${this.getCurrentModuleName()}-contents*

🔍 NAVIGATION:~
   Use | to jump to sections, :help p5-[symbol] to jump to symbols~

🏛️ CLASSES:
  |Anonymous                |
  |PrintWriter              |
  |Table                    |
  |TableRow                 |
  |XML                      |

⚡ FUNCTIONS:
  |anonymous                |
  |clear                    |
  |close                    |
  |createWriter             |
  |day                      |
  |destroyClickedElement    |
  |downloadFile             |
  |hour                     |
  |httpDo                   |
  |httpGet                  |
  |httpPost                 |
  |loadBytes                |
  |loadJSON                 |
  |loadStrings              |
  |loadTable                |
  |loadXML                  |
  |millis                   |
  |minute                   |
  |month                    |
  |print                    |
  |save                     |
  |saveJSON                 |
  |saveStrings              |
  |saveTable                |
  |second                   |
  |table                    |
  |write                    |
  |year                     |

🔧 PROPERTIES:
  |columns                  |
  |rows                     |
  |writeFile                |

📌 VARIABLES:
  |arr                      |
  |content                  |
  |cString                  |
  |escape                   |
  |floatVal                 |
  |fx                       |
  |ind                      |
  |newPW                    |
  |obj                      |
  |regex                    |
  |ret                      |
  |self                     |
  |str                      |
  |stringVal                |
  |t                        |
  |tableArray               |
  |tableObject              |
  |type                     |
  |xmlSerializer            |



🔗 RELATED SYMBOLS:~
   See |p5| for complete p5.js API reference~



⚡ QUICK REFERENCE:~
   :help p5-[symbolname] - Jump directly to any function~



CLASSES                                                   *p5-IO-classes*

p5-IO_Anonymous() 📄 🏛️
|Anonymous|() 🏛️ Class

A class to describe an XML object.
Each `p5.XML` object provides an easy way to interact with XML data.
Extensible Markup Language (<a href="https://developer.mozilla.org/en-US/docs/Web/XML/XML_introduction" target="_blank">XML</a>) is a standard format for sending data between applications.
Like HTML, the XML format is based on tags and attributes, as in `&lt;time units="s"&gt;1234&lt;/time&gt;`.
Note: Use <a href="#/p5/loadXML">loadXML()</a> to load external XML files.

Examples: >
>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get an array with all mammal tags.
> let mammals = myXML.getChildren('mammal');
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Iterate over the mammals array.
> for (let i = 0; i < mammals.length; i += 1) {
>
> // Calculate the y-coordinate.
> let y = (i + 1) * 25;
>
> // Get the mammal's common name.
> let name = mammals[i].getContent();
>
> // Display the mammal's name.
> text(name, 20, y);
> }
>
> describe(
> 'The words "Goat", "Leopard", and "Zebra" written on three separate lines. The text is black on a gray background.'
> );
> }
> </code>
>
<

See also: ~
   |help p5-Anonymous| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.XML.js:67
~


p5-IO_PrintWriter() 📄 🏛️
|PrintWriter|() 🏛️ Class

A class to describe a `print` stream.
Each `p5.PrintWriter` object provides a way to `save` a sequence of `text` data, called the *`print` stream*, to the user's computer.
It's a low-level object that enables precise control of `text` output.
Functions such as <a href="#/p5/saveStrings">saveStrings()</a> and <a href="#/p5/saveJSON">saveJSON()</a> are easier to use for simple file saving.
Note: <a href="#/p5/createWriter">createWriter()</a> is the recommended way to make an instance of this class.

Parameters: ~
                📝 `filename` (String) - name of the file to create.
                🔢 `{String} [extension] format to use for the file.` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> // Create a p5.PrintWriter object.
> let myWriter = createWriter('xo.txt');
>
> // Add some lines to the print stream.
> myWriter.print('XOO');
> myWriter.print('OXO');
> myWriter.print('OOX');
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> </code>
>
<

See also: ~
   |help p5-PrintWriter| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1617
~


p5-IO_Table() 📄 🏛️
|Table|() 🏛️ Class

<a href="#/p5.Table">Table</a> objects store data with multiple rows and columns, much like in a traditional spreadsheet.
Tables can be generated from scratch, dynamically, or using data from an existing file.

Parameters: ~
                🔢 `{p5.TableRow[]}     [rows] An array of p5.TableRow objects` (unknown)
~

See also: ~
   |help p5-Table| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:42
~


p5-IO_TableRow() 📄 🏛️
|TableRow|() 🏛️ Class

A TableRow object represents a single row of data values, stored in columns, from a table.
A Table Row contains both an ordered array, and an unordered JSON object.

Parameters: ~
                🔢 `{String} [str]       optional: populate the row with a` (unknown)
                🔢 `{String} [separator] comma separated values (csv) by default` (unknown)
~

See also: ~
   |help p5-TableRow| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.TableRow.js:23
~


p5-IO_XML() 📄 🏛️
|XML|() 🏛️ Class

A class to describe an XML object.
Each `p5.XML` object provides an easy way to interact with XML data.
Extensible Markup Language (<a href="https://developer.mozilla.org/en-US/docs/Web/XML/XML_introduction" target="_blank">XML</a>) is a standard format for sending data between applications.
Like HTML, the XML format is based on tags and attributes, as in `&lt;time units="s"&gt;1234&lt;/time&gt;`.
Note: Use <a href="#/p5/loadXML">loadXML()</a> to load external XML files.

Examples: >
>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get an array with all mammal tags.
> let mammals = myXML.getChildren('mammal');
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Iterate over the mammals array.
> for (let i = 0; i < mammals.length; i += 1) {
>
> // Calculate the y-coordinate.
> let y = (i + 1) * 25;
>
> // Get the mammal's common name.
> let name = mammals[i].getContent();
>
> // Display the mammal's name.
> text(name, 20, y);
> }
>
> describe(
> 'The words "Goat", "Leopard", and "Zebra" written on three separate lines. The text is black on a gray background.'
> );
> }
> </code>
>
<

See also: ~
   |help p5-XML| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.XML.js:67
~


FUNCTIONS                                                   *p5-IO-functions*

p5-IO_anonymous() 📄 ⚡
|anonymous|(chars, {String|Integer} [column] Column ID (number)) ⚡ Function

Removes any of the specified characters (or "tokens").
If no column is specified, then the values in all columns and rows are processed.
A specific column may be referenced by either its ID or title.

Parameters: ~
                📝 `chars` (String) - String listing characters to be removed
                🔢 `{String|Integer} [column] Column ID (number)` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> let table = new p5.Table();
>
> table.addColumn('name');
> table.addColumn('type');
>
> let newRow = table.addRow();
> newRow.setString('name', '   $Lion  ,');
> newRow.setString('type', ',,,Mammal');
>
> newRow = table.addRow();
> newRow.setString('name', '$Snake  ');
> newRow.setString('type', ',,,Reptile');
>
> table.removeTokens(',$ ');
> print(table.getArray());
> }
>
> // prints:
> //  0  "Lion"   "Mamal"
> //  1  "Snake"  "Reptile"
> </code>
<

See also: ~
   |help p5-anonymous| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:790
~


p5-IO_clear() 📄 ⚡
|clear|() ⚡ Function

Clears all data from the `print` stream.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> // Create a p5.PrintWriter object.
> let myWriter = createWriter('numbers.txt');
>
> // Add some data to the print stream.
> myWriter.print('Hello p5*js!');
>
> // Clear the print stream.
> myWriter.clear();
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> </code>
>
<

See also: ~
   |help p5-clear| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1763
~


p5-IO_close() 📄 ⚡
|close|() ⚡ Function

Saves the file and closes the `print` stream.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> // Create a p5.PrintWriter object.
> let myWriter = createWriter('cat.txt');
>
> // Add some data to the print stream.
> // ASCII art courtesy Wikipedia:
> // https://en.wikipedia.org/wiki/ASCII_art
> myWriter.print(' (\\_/) ');
> myWriter.print("(='.'=)");
> myWriter.print('(")_(")');
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> </code>
>
<

See also: ~
   |help p5-close| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1809
~


p5-IO_createWriter() 📄 ⚡
|createWriter|(name, {String} [extension] format to use for the file.) ⚡ Function

Creates a new <a href="#/p5.PrintWriter">p5.PrintWriter</a> object.
<a href="#/p5.PrintWriter">p5.PrintWriter</a> objects provide a way to `save` a sequence of `text` data, called the *`print` stream*, to the user's computer.
They're low-level objects that enable precise control of `text` output.
Functions such as <a href="#/p5/saveStrings">saveStrings()</a> and <a href="#/p5/saveJSON">saveJSON()</a> are easier to use for simple file saving.
The first parameter, `filename`, is the name of the file to be written.
If a string is passed, as in `createWriter('words.txt')`, a new <a href="#/p5.PrintWriter">p5.PrintWriter</a> object will be created that writes to a file named `words.txt`.
The second parameter, `extension`, is optional.
If a string is passed, as in `createWriter('words', 'csv')`, the first parameter will be interpreted as the file name and the second parameter as the extension.

Parameters: ~
                📝 `name` (String) - name of the file to create.
                🔢 `{String} [extension] format to use for the file.` (unknown)
~

Returns: ~
                🔢 Returns p5.PrintWriter: stream for writing data.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create a p5.PrintWriter object.
> let myWriter = createWriter('xo.txt');
>
> // Add some lines to the print stream.
> myWriter.print('XOO');
> myWriter.print('OXO');
> myWriter.print('OOX');
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create a p5.PrintWriter object.
> // Use the file format .csv.
> let myWriter = createWriter('mauna_loa_co2', 'csv');
>
> // Add some lines to the print stream.
> myWriter.print('date,ppm_co2');
> myWriter.print('1960-01-01,316.43');
> myWriter.print('1970-01-01,325.06');
> myWriter.print('1980-01-01,337.9');
> myWriter.print('1990-01-01,353.86');
> myWriter.print('2000-01-01,369.45');
> myWriter.print('2020-01-01,413.61');
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> }
> </code>
>
<

See also: ~
   |help p5-createWriter| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1547
~


p5-IO_day() 📄 ⚡
|day|() ⚡ Function

Returns the current day as a number from 1–31.

Returns: ~
                🔢 Returns Integer: current day between 1 and 31.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the current day.
> let d = day();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textSize(12);
> textFont('Courier New');
>
> // Display the day.
> text(`Current day: ${d}`, 20, 50, 60);
>
> describe(`The text 'Current day: ${d}' written in black on a gray background.`);
> }
> </code>
>
<

See also: ~
   |help p5-day| for detailed help on this symbol~

Source: ~
                ../temp/src/utilities/time_date.js:40
~


p5-IO_destroyClickedElement() 📄 ⚡
|destroyClickedElement|() ⚡ Function

Helper function, a callback for download that deletes an invisible anchor element from the DOM once the file has been automatically downloaded.

See also: ~
   |help p5-destroyClickedElement| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:2526
~


p5-IO_downloadFile() 📄 ⚡
|downloadFile|(data, {String} [filename], {String} [extension]) ⚡ Function

Forces download.
Accepts a url to filedata/blob, a filename, and an extension (optional).
This is a private function because it does not do any formatting, but it is used by <a href="#/p5/saveStrings">saveStrings</a>, <a href="#/p5/saveJSON">saveJSON</a>, <a href="#/p5/saveTable">saveTable</a> etc.

Parameters: ~
                🔢 `data` (String|Blob) - either an href generated by createObjectURL,
                🔢 `{String} [filename]` (unknown)
                🔢 `{String} [extension]` (unknown)
~

See also: ~
   |help p5-downloadFile| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:2442
~


p5-IO_hour() 📄 ⚡
|hour|() ⚡ Function

Returns the current hour as a number from 0–23.

Returns: ~
                🔢 Returns Integer: current hour between 0 and 23.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the current hour.
> let h = hour();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textSize(12);
> textFont('Courier New');
>
> // Display the hour.
> text(`Current hour: ${h}`, 20, 50, 60);
>
> describe(`The text 'Current hour: ${h}' written in black on a gray background.`);
> }
> </code>
>
<

See also: ~
   |help p5-hour| for detailed help on this symbol~

Source: ~
                ../temp/src/utilities/time_date.js:74
~


p5-IO_httpDo() 📄 ⚡
|httpDo|(path, options, {function}      [callback], {function}      [errorCallback]) ⚡ Function

Parameters: ~
                📝 `path` (String)
                📦 `options` (Object) - Request object options as documented in the
                🔢 `{function}      [callback]` (unknown)
                🔢 `{function}      [errorCallback]` (unknown)
~

Returns: ~
                🔢 Returns Promise
~

See also: ~
   |help p5-httpDo| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1289
~


p5-IO_httpGet() 📄 ⚡
|httpGet|(path, callback, {function}      [errorCallback]) ⚡ Function

Parameters: ~
                📝 `path` (String)
                🔢 `callback` (function)
                🔢 `{function}      [errorCallback]` (unknown)
~

Returns: ~
                🔢 Returns Promise
~

See also: ~
   |help p5-httpGet| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1112
~


p5-IO_httpPost() 📄 ⚡
|httpPost|(path, callback, {function}      [errorCallback]) ⚡ Function

Parameters: ~
                📝 `path` (String)
                🔢 `callback` (function)
                🔢 `{function}      [errorCallback]` (unknown)
~

Returns: ~
                🔢 Returns Promise
~

See also: ~
   |help p5-httpPost| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1201
~


p5-IO_loadBytes() 📄 ⚡
|loadBytes|(file, {function} [callback]      function to be executed after <a href="#/p5/loadBytes">loadBytes()</a>, {function} [errorCallback] function to be executed if there) ⚡ Function

This method is suitable for fetching files up to size of 64MB.

Parameters: ~
                🔢 `file` (string) - name of the file or URL to load
                🔢 `{function} [callback]      function to be executed after <a href="#/p5/loadBytes">loadBytes()</a>` (unknown)
                🔢 `{function} [errorCallback] function to be executed if there` (unknown)
~

Returns: ~
                🔢 Returns undefined
~

Examples: >
>
> <code>
> let data;
>
> function preload() {
> data = loadBytes('assets/mammals.xml');
> }
>
> function setup() {
> for (let i = 0; i < 5; i++) {
> console.log(data.bytes[i].toString(16));
> }
> describe('no image displayed');
> }
> </code>
<

See also: ~
   |help p5-loadBytes| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1012
~


p5-IO_loadJSON() 📄 ⚡
|loadJSON|(path, {function} [successCallback] function to call once the data is loaded. Will be passed the object., {function} [errorCallback] function to call if the data fails to load. Will be passed an `Error` event object.) ⚡ Function

Loads a JSON file to create an `Object`.
JavaScript Object Notation (<a href="https://developer.mozilla.org/en-US/docs/Glossary/JSON" target="_blank">JSON</a>) is a standard format for sending data between applications.
The format is based on JavaScript objects which have keys and values.
JSON files store data in an object with strings as keys.
Values can be strings, numbers, Booleans, arrays, `null`, or other objects.
The first parameter, `path`, is always a string with the path to the file.
Paths to local files should be relative, as in `loadJSON('assets/data.json')`.
URLs such as `'https://example.com/data.json'` may be blocked due to browser security.
The second parameter, `successCallback`, is optional.
If a function is passed, as in `loadJSON('assets/data.json', handleData)`, then the `handleData()` function will be called once the data loads.
The object created from the JSON data will be passed to `handleData()` as its only argument.
The third parameter, `failureCallback`, is also optional.
If a function is passed, as in `loadJSON('assets/data.json', handleData, handleFailure)`, then the `handleFailure()` function will be called if an error occurs while loading.
The `Error` object will be passed to `handleFailure()` as its only argument.
Note: Data can take time to load.
Calling `loadJSON()` within <a href="#/p5/preload">preload()</a> ensures data loads before it's used in <a href="#/p5/`setup`">`setup`()</a> or <a href="#/p5/`draw`">`draw`()</a>.

Parameters: ~
                📝 `path` (String) - path of the JSON file to be loaded.
                🔢 `{function} [successCallback] function to call once the data is loaded. Will be passed the object.` (unknown)
                🔢 `{function} [errorCallback] function to call if the data fails to load. Will be passed an `Error` event object.` (unknown)
~

Returns: ~
                📦 Returns Object: object containing the loaded data.
~

Examples: >
>
> <code>
> let myData;
>
> // Load the JSON and create an object.
> function preload() {
> myData = loadJSON('assets/data.json');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the circle.
> fill(myData.color);
> noStroke();
>
> // Draw the circle.
> circle(myData.x, myData.y, myData.d);
>
> describe('A pink circle on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> let myData;
>
> // Load the JSON and create an object.
> function preload() {
> myData = loadJSON('assets/data.json');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Create a p5.Color object and make it transparent.
> let c = color(myData.color);
> c.setAlpha(80);
>
> // Style the circles.
> fill(c);
> noStroke();
>
> // Iterate over the myData.bubbles array.
> for (let b of myData.bubbles) {
> // Draw a circle for each bubble.
> circle(b.x, b.y, b.d);
> }
>
> describe('Several pink bubbles floating in a blue sky.');
> }
> </code>
> </div>
>
> <div>
> <code>
> let myData;
>
> // Load the GeoJSON and create an object.
> function preload() {
> myData = loadJSON('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get data about the most recent earthquake.
> let quake = myData.features[0].properties;
>
> // Draw a circle based on the earthquake's magnitude.
> circle(50, 50, quake.mag * 10);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(11);
>
> // Display the earthquake's location.
> text(quake.place, 5, 80, 100);
>
> describe(`A white circle on a gray background. The text "${quake.place}" is written beneath the circle.`);
> }
> </code>
> </div>
>
> <div>
> <code>
> let bigQuake;
>
> // Load the GeoJSON and preprocess it.
> function preload() {
> loadJSON(
> 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson',
> handleData
> );
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Draw a circle based on the earthquake's magnitude.
> circle(50, 50, bigQuake.mag * 10);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(11);
>
> // Display the earthquake's location.
> text(bigQuake.place, 5, 80, 100);
>
> describe(`A white circle on a gray background. The text "${bigQuake.place}" is written beneath the circle.`);
> }
>
> // Find the biggest recent earthquake.
> function handleData(data) {
> let maxMag = 0;
> // Iterate over the earthquakes array.
> for (let quake of data.features) {
> // Reassign bigQuake if a larger
> // magnitude quake is found.
> if (quake.properties.mag > maxMag) {
> bigQuake = quake.properties;
> }
> }
> }
> </code>
> </div>
>
> <div>
> <code>
> let bigQuake;
>
> // Load the GeoJSON and preprocess it.
> function preload() {
> loadJSON(
> 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson',
> handleData,
> handleError
> );
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Draw a circle based on the earthquake's magnitude.
> circle(50, 50, bigQuake.mag * 10);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(11);
>
> // Display the earthquake's location.
> text(bigQuake.place, 5, 80, 100);
>
> describe(`A white circle on a gray background. The text "${bigQuake.place}" is written beneath the circle.`);
> }
>
> // Find the biggest recent earthquake.
> function handleData(data) {
> let maxMag = 0;
> // Iterate over the earthquakes array.
> for (let quake of data.features) {
> // Reassign bigQuake if a larger
> // magnitude quake is found.
> if (quake.properties.mag > maxMag) {
> bigQuake = quake.properties;
> }
> }
> }
>
> // Log any errors to the console.
> function handleError(error) {
> console.log('Oops!', error);
> }
> </code>
>
<

See also: ~
   |help p5-loadJSON| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:245
~


p5-IO_loadStrings() 📄 ⚡
|loadStrings|(path, {function} [successCallback] function to call once the data is, {function} [errorCallback] function to call if the data fails to) ⚡ Function

Loads a `text` file to create an `Array`.
The first parameter, `path`, is always a string with the path to the file.
Paths to local files should be relative, as in `loadStrings('assets/data.txt')`.
URLs such as `'https://example.com/data.txt'` may be blocked due to browser security.
The second parameter, `successCallback`, is optional.
If a function is passed, as in `loadStrings('assets/data.txt', handleData)`, then the `handleData()` function will be called once the data loads.
The array created from the `text` data will be passed to `handleData()` as its only argument.
The third parameter, `failureCallback`, is also optional.
If a function is passed, as in `loadStrings('assets/data.txt', handleData, handleFailure)`, then the `handleFailure()` function will be called if an error occurs while loading.
The `Error` object will be passed to `handleFailure()` as its only argument.
Note: Data can take time to load.
Calling `loadStrings()` within <a href="#/p5/preload">preload()</a> ensures data loads before it's used in <a href="#/p5/`setup`">`setup`()</a> or <a href="#/p5/`draw`">`draw`()</a>.

Parameters: ~
                📝 `path` (String) - path of the text file to be loaded.
                🔢 `{function} [successCallback] function to call once the data is` (unknown)
                🔢 `{function} [errorCallback] function to call if the data fails to` (unknown)
~

Returns: ~
                🔢 Returns String[]: new array containing the loaded text.
~

Examples: >
>
> <code>
> let myData;
>
> // Load the text and create an array.
> function preload() {
> myData = loadStrings('assets/test.txt');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Select a random line from the text.
> let phrase = random(myData);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display the text.
> text(phrase, 10, 50, 90);
>
> describe(`The text "${phrase}" written in black on a gray background.`);
> }
> </code>
> </div>
>
> <div>
> <code>
> let lastLine;
>
> // Load the text and preprocess it.
> function preload() {
> loadStrings('assets/test.txt', handleData);
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display the text.
> text(lastLine, 10, 50, 90);
>
> describe('The text "I talk like an orange" written in black on a gray background.');
> }
>
> // Select the last line from the text.
> function handleData(data) {
> lastLine = data[data.length - 1];
> }
> </code>
> </div>
>
> <div>
> <code>
> let lastLine;
>
> // Load the text and preprocess it.
> function preload() {
> loadStrings('assets/test.txt', handleData, handleError);
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display the text.
> text(lastLine, 10, 50, 90);
>
> describe('The text "I talk like an orange" written in black on a gray background.');
> }
>
> // Select the last line from the text.
> function handleData(data) {
> lastLine = data[data.length - 1];
> }
>
> // Log any errors to the console.
> function handleError(error) {
> console.error('Oops!', error);
> }
> </code>
>
<

See also: ~
   |help p5-loadStrings| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:443
~


p5-IO_loadTable() 📄 ⚡
|loadTable|(filename, {String}         [extension] parse the table by comma-separated values "csv", semicolon-separated, {String}         [header]    "header" to indicate table has header row, {function}       [callback]  function to be executed after, {function}  [errorCallback]  function to be executed if) ⚡ Function

Reads the contents of a file or URL and creates a <a href="#/p5.Table">p5.Table</a> object with its values.
If a file is specified, it must be located in the sketch's "data" folder.
The filename parameter can also be a URL to a file found online.
By default, the file is assumed to be comma-separated (in CSV format).
Table only looks for a header row if the 'header' option is included.
This method is asynchronous, meaning it may not finish before the next `line` in your sketch is executed.
Calling <a href="#/p5/loadTable">loadTable()</a> inside <a href="#/p5/preload">preload()</a> guarantees to complete the operation before <a href="#/p5/`setup`">`setup`()</a> and <a href="#/p5/`draw`">`draw`()</a> are called.
Outside of <a href="#/p5/preload">preload()</a>, you may supply a callback function to handle the object: All files loaded and saved use UTF-8 encoding.
This method is suitable for fetching files up to size of 64MB.

Parameters: ~
                📝 `filename` (String) - name of the file or URL to load
                🔢 `{String}         [extension] parse the table by comma-separated values "csv", semicolon-separated` (unknown)
                🔢 `{String}         [header]    "header" to indicate table has header row` (unknown)
                🔢 `{function}       [callback]  function to be executed after` (unknown)
                🔢 `{function}  [errorCallback]  function to be executed if` (unknown)
~

Returns: ~
                📦 Returns Object: <a href="#/p5.Table">Table</a> object containing data
~

Examples: >
>
> <code>
> // Given the following CSV file called "mammals.csv"
> // located in the project's "assets" folder:
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leopard
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> //my table is comma separated value "csv"
> //and has a header specifying the columns labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> //the file can be remote
> //table = loadTable("https://p5js.org/reference/assets/mammals.csv",
> //                  "csv", "header");
> }
>
> function setup() {
> //count the columns
> print(table.getRowCount() + ' total rows in table');
> print(table.getColumnCount() + ' total columns in table');
>
> print(table.getColumn('name'));
> //["Goat", "Leopard", "Zebra"]
>
> //cycle through the table
> for (let r = 0; r < table.getRowCount(); r++)
> for (let c = 0; c < table.getColumnCount(); c++) {
> print(table.getString(r, c));
> }
> describe(`randomly generated text from a file,
> for example "i smell like butter"`);
> }
> </code>
>
<

See also: ~
   |help p5-loadTable| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:575
~


p5-IO_loadXML() 📄 ⚡
|loadXML|(path, {function} [successCallback] function to call once the data is, {function} [errorCallback] function to call if the data fails to) ⚡ Function

Loads an XML file to create a <a href="#/p5.XML">p5.XML</a> object.
Extensible Markup Language (<a href="https://developer.mozilla.org/en-US/docs/Web/XML/XML_introduction" target="_blank">XML</a>) is a standard format for sending data between applications.
Like HTML, the XML format is based on tags and attributes, as in `&lt;time units="s"&gt;1234&lt;/time&gt;`.
The first parameter, `path`, is always a string with the path to the file.
Paths to local files should be relative, as in `loadXML('assets/data.xml')`.
URLs such as `'https://example.com/data.xml'` may be blocked due to browser security.
The second parameter, `successCallback`, is optional.
If a function is passed, as in `loadXML('assets/data.xml', handleData)`, then the `handleData()` function will be called once the data loads.
The <a href="#/p5.XML">p5.XML</a> object created from the data will be passed to `handleData()` as its only argument.
The third parameter, `failureCallback`, is also optional.
If a function is passed, as in `loadXML('assets/data.xml', handleData, handleFailure)`, then the `handleFailure()` function will be called if an error occurs while loading.
The `Error` object will be passed to `handleFailure()` as its only argument.
Note: Data can take time to load.
Calling `loadXML()` within <a href="#/p5/preload">preload()</a> ensures data loads before it's used in <a href="#/p5/`setup`">`setup`()</a> or <a href="#/p5/`draw`">`draw`()</a>.

Parameters: ~
                📝 `path` (String) - path of the XML file to be loaded.
                🔢 `{function} [successCallback] function to call once the data is` (unknown)
                🔢 `{function} [errorCallback] function to call if the data fails to` (unknown)
~

Returns: ~
                🔢 Returns p5.XML: XML data loaded into a <a href="#/p5.XML">p5.XML</a>
~

Examples: >
>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get an array with all mammal tags.
> let mammals = myXML.getChildren('mammal');
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Iterate over the mammals array.
> for (let i = 0; i < mammals.length; i += 1) {
>
> // Calculate the y-coordinate.
> let y = (i + 1) * 25;
>
> // Get the mammal's common name.
> let name = mammals[i].getContent();
>
> // Display the mammal's name.
> text(name, 20, y);
> }
>
> describe(
> 'The words "Goat", "Leopard", and "Zebra" written on three separate lines. The text is black on a gray background.'
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> let lastMammal;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> loadXML('assets/animals.xml', handleData);
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(CENTER, CENTER);
> textFont('Courier New');
> textSize(16);
>
> // Display the content of the last mammal element.
> text(lastMammal, 50, 50);
>
> describe('The word "Zebra" written in black on a gray background.');
> }
>
> // Get the content of the last mammal element.
> function handleData(data) {
> // Get an array with all mammal elements.
> let mammals = data.getChildren('mammal');
>
> // Get the content of the last mammal.
> lastMammal = mammals[mammals.length - 1].getContent();
> }
> </code>
> </div>
>
> <div>
> <code>
> let lastMammal;
>
> // Load the XML and preprocess it.
> function preload() {
> loadXML('assets/animals.xml', handleData, handleError);
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(CENTER, CENTER);
> textFont('Courier New');
> textSize(16);
>
> // Display the content of the last mammal element.
> text(lastMammal, 50, 50);
>
> describe('The word "Zebra" written in black on a gray background.');
> }
>
> // Get the content of the last mammal element.
> function handleData(data) {
> // Get an array with all mammal elements.
> let mammals = data.getChildren('mammal');
>
> // Get the content of the last mammal.
> lastMammal = mammals[mammals.length - 1].getContent();
> }
>
> // Log any errors to the console.
> function handleError(error) {
> console.error('Oops!', error);
> }
> </code>
>
<

See also: ~
   |help p5-loadXML| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:941
~


p5-IO_millis() 📄 ⚡
|millis|() ⚡ Function

Returns the number of milliseconds since a sketch started running.
`millis()` keeps track of how long a sketch has been running in milliseconds (thousandths of a second).
This information is often helpful for timing events and animations.
If a sketch has a <a href="#/p5/`setup`">`setup`()</a> function, then `millis()` begins tracking time before the code in <a href="#/p5/`setup`">`setup`()</a> runs.
If a sketch includes a <a href="#/p5/preload">preload()</a> function, then `millis()` begins tracking time as soon as the code in <a href="#/p5/preload">preload()</a> starts running.

Returns: ~
                🔢 Returns Number: number of milliseconds since starting the sketch.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the number of milliseconds the sketch has run.
> let ms = millis();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textSize(10);
> textFont('Courier New');
>
> // Display how long it took setup() to be called.
> text(`Startup time: ${round(ms, 2)} ms`, 5, 50, 90);
>
> describe(
> `The text 'Startup time: ${round(ms, 2)} ms' written in black on a gray background.`
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> describe('The text "Running time: S sec" written in black on a gray background. The number S increases as the sketch runs.');
> }
>
> function draw() {
> background(200);
>
> // Get the number of seconds the sketch has run.
> let s = millis() / 1000;
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textSize(10);
> textFont('Courier New');
>
> // Display how long the sketch has run.
> text(`Running time: ${nf(s, 1, 1)} sec`, 5, 50, 90);
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> describe('A white circle oscillates left and right on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Get the number of seconds the sketch has run.
> let s = millis() / 1000;
>
> // Calculate an x-coordinate.
> let x = 30 * sin(s) + 50;
>
> // Draw the circle.
> circle(x, 50, 30);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Load the GeoJSON.
> function preload() {
> loadJSON('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the number of milliseconds the sketch has run.
> let ms = millis();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(11);
>
> // Display how long it took to load the data.
> text(`It took ${round(ms, 2)} ms to load the data`, 5, 50, 100);
>
> describe(
> `The text "It took ${round(ms, 2)} ms to load the data" written in black on a gray background.`
> );
> }
> </code>
>
<

See also: ~
   |help p5-millis| for detailed help on this symbol~

Source: ~
                ../temp/src/utilities/time_date.js:233
~


p5-IO_minute() 📄 ⚡
|minute|() ⚡ Function

Returns the current minute as a number from 0–59.

Returns: ~
                🔢 Returns Integer: current minute between 0 and 59.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the current minute.
> let m = minute();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textSize(12);
> textFont('Courier New');
>
> // Display the minute.
> text(`Current minute: ${m}`, 10, 50, 80);
>
> describe(`The text 'Current minute: ${m}' written in black on a gray background.`);
> }
> </code>
>
<

See also: ~
   |help p5-minute| for detailed help on this symbol~

Source: ~
                ../temp/src/utilities/time_date.js:108
~


p5-IO_month() 📄 ⚡
|month|() ⚡ Function

Returns the current month as a number from 1–12.

Returns: ~
                🔢 Returns Integer: current month between 1 and 12.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the current month.
> let m = month();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textSize(12);
> textFont('Courier New');
>
> // Display the month.
> text(`Current month: ${m}`, 10, 50, 80);
>
> describe(`The text 'Current month: ${m}' written in black on a gray background.`);
> }
> </code>
>
<

See also: ~
   |help p5-month| for detailed help on this symbol~

Source: ~
                ../temp/src/utilities/time_date.js:272
~


p5-IO_print() 📄 ⚡
|print|(data) ⚡ Function

Writes data to the `print` stream with new lines added.
The parameter, `data`, is the data to write.
`data` can be a number or string, as in `myWriter.`print`('hi')`, or an array of numbers and strings, as in `myWriter.`print`([1, 2, 3])`.
A comma will be inserted between array array elements when they're added to the `print` stream.

Parameters: ~
                🔢 `data` (String|Number|Array) - data to be written as a string, number,
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> // Create a p5.PrintWriter object.
> let myWriter = createWriter('numbers.txt');
>
> // Add some data to the print stream.
> myWriter.print('1,2,3,');
> myWriter.print(['4', '5', '6']);
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> </code>
>
<

See also: ~
   |help p5-print| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1718
~


p5-IO_save() 📄 ⚡
|save|({Object|String} [objectOrFilename]  If filename is provided, will, {String} [filename] If an object is provided as the first, {Boolean|String} [options]  Additional options depend on) ⚡ Function

Saves a given element(`image`, `text`, json, csv, wav, or html) to the client's computer.
The first parameter can be a pointer to element we want to `save`.
The element can be one of <a href="#/p5.Element">p5.Element</a>,an Array of Strings, an Array of JSON, a JSON object, a <a href="#/p5.Table">p5.Table </a>, a <a href="#/p5.Image">p5.Image</a>, or a p5.SoundFile (requires p5.sound).
The second parameter is a filename (including extension).The third parameter is for options specific to this type of object.
This method will `save` a file that fits the given parameters.
If it is called without specifying an element, by default it will `save` the whole canvas as an `image` file.
You can optionally specify a filename as the first parameter in such a case.
**Note that it is not recommended to call this method within `draw`, as it will open a new `save` dialog on every render.**

Parameters: ~
                🔢 `{Object|String} [objectOrFilename]  If filename is provided, will` (unknown)
                🔢 `{String} [filename] If an object is provided as the first` (unknown)
                🔢 `{Boolean|String} [options]  Additional options depend on` (unknown)
~

Examples: >
>
> <code>
> // Saves the canvas as an image
> cnv = createCanvas(300, 300);
> save(cnv, 'myCanvas.jpg');
>
> // Saves the canvas as an image by default
> save('myCanvas.jpg');
> describe('An example for saving a canvas as an image.');
> </code></div>
>
> <div class="norender"><code>
> // Saves p5.Image as an image
> img = createImage(10, 10);
> save(img, 'myImage.png');
> describe('An example for saving a p5.Image element as an image.');
> </code></div>
>
> <div class="norender"><code>
> // Saves p5.Renderer object as an image
> obj = createGraphics(100, 100);
> save(obj, 'myObject.png');
> describe('An example for saving a p5.Renderer element.');
> </code></div>
>
> <div class="norender"><code>
> let myTable = new p5.Table();
> // Saves table as html file
> save(myTable, 'myTable.html');
>
> // Comma Separated Values
> save(myTable, 'myTable.csv');
>
> // Tab Separated Values
> save(myTable, 'myTable.tsv');
>
> describe(`An example showing how to save a table in formats of
> HTML, CSV and TSV.`);
> </code></div>
>
> <div class="norender"><code>
> let myJSON = { a: 1, b: true };
>
> // Saves pretty JSON
> save(myJSON, 'my.json');
>
> // Optimizes JSON filesize
> save(myJSON, 'my.json', true);
>
> describe('An example for saving JSON to a txt file with some extra arguments.');
> </code></div>
>
> <div class="norender"><code>
> // Saves array of strings to text file with line breaks after each item
> let arrayOfStrings = ['a', 'b'];
> save(arrayOfStrings, 'my.txt');
> describe(`An example for saving an array of strings to text file
> with line breaks.`);
> </code>
<

See also: ~
   |help p5-save| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1932
~


p5-IO_saveJSON() 📄 ⚡
|saveJSON|(json, filename, {Boolean} [optimize] whether to trim unneeded whitespace. Defaults) ⚡ Function

Saves an `Object` or `Array` to a JSON file.
JavaScript Object Notation (<a href="https://developer.mozilla.org/en-US/docs/Glossary/JSON" target="_blank">JSON</a>) is a standard format for sending data between applications.
The format is based on JavaScript objects which have keys and values.
JSON files store data in an object with strings as keys.
Values can be strings, numbers, Booleans, arrays, `null`, or other objects.
The first parameter, `json`, is the data to `save`.
The data can be an array, as in `[1, 2, 3]`, or an object, as in `{ x: 50, y: 50, `color`: 'deeppink' }`.
The second parameter, `filename`, is a string that sets the file's name.
For example, calling `saveJSON([1, 2, 3], 'data.json')` saves the array `[1, 2, 3]` to a file called `data.json` on the user's computer.
The third parameter, `optimize`, is optional.
If `true` is passed, as in `saveJSON([1, 2, 3], 'data.json', true)`, then all unneeded whitespace will be removed to reduce the file size.
Note: The browser will either `save` the file immediately or prompt the user with a dialogue window.

Parameters: ~
                🔢 `json` (Array|Object) - data to save.
                📝 `filename` (String) - name of the file to be saved.
                🔢 `{Boolean} [optimize] whether to trim unneeded whitespace. Defaults` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create an array.
> let data = [1, 2, 3];
>
> // Save the JSON file.
> saveJSON(data, 'numbers.json');
> }
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create an object.
> let data = { x: mouseX, y: mouseY };
>
> // Save the JSON file.
> saveJSON(data, 'state.json');
> }
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create an object.
> let data = { x: mouseX, y: mouseY };
>
> // Save the JSON file and reduce its size.
> saveJSON(data, 'state.json', true);
> }
> }
> </code>
>
<

See also: ~
   |help p5-saveJSON| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:2104
~


p5-IO_saveStrings() 📄 ⚡
|saveStrings|(list, filename, {String} [extension] format to use for the file., {Boolean} [isCRLF] whether to add `\r\n` to the end of each) ⚡ Function

Saves an `Array` of `String`s to a file, one per `line`.
The first parameter, `list`, is an array with the strings to `save`.
The second parameter, `filename`, is a string that sets the file's name.
For example, calling `saveStrings(['0', '01', '011'], 'data.txt')` saves the array `['0', '01', '011']` to a file called `data.txt` on the user's computer.
The third parameter, `extension`, is optional.
If a string is passed, as in `saveStrings(['0', '01', '0`1'], 'data', 'txt')`, the second parameter will be interpreted as the file name and the third parameter as the extension.
The fourth parameter, `isCRLF`, is also optional, If `true` is passed, as in `saveStrings(['0', '01', '011'], 'data', 'txt', true)`, then two characters, `\r\n` , will be added to the end of each string to create new lines in the saved file.
`\r` is a carriage return (CR) and `\n` is a `line` feed (LF).
By default, only `\n` (`line` feed) is added to each string in order to create new lines.
Note: The browser will either `save` the file immediately or prompt the user with a dialogue window.

Parameters: ~
                🔢 `list` (String[]) - data to save.
                📝 `filename` (String) - name of file to be saved.
                🔢 `{String} [extension] format to use for the file.` (unknown)
                🔢 `{Boolean} [isCRLF] whether to add `\r\n` to the end of each` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create an array.
> let data = ['0', '01', '011'];
>
> // Save the text file.
> saveStrings(data, 'data.txt');
> }
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create an array.
> // ASCII art courtesy Wikipedia:
> // https://en.wikipedia.org/wiki/ASCII_art
> let data = [' (\\_/) ', "(='.'=)", '(")_(")'];
>
> // Save the text file.
> saveStrings(data, 'cat', 'txt');
> }
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create an array.
> //   +--+
> //  /  /|
> // +--+ +
> // |  |/
> // +--+
> let data = ['  +--+', ' /  /|', '+--+ +', '|  |/', '+--+'];
>
> // Save the text file.
> // Use CRLF for line endings.
> saveStrings(data, 'box', 'txt', true);
> }
> }
> </code>
>
<

See also: ~
   |help p5-saveStrings| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:2251
~


p5-IO_saveTable() 📄 ⚡
|saveTable|(Table, filename, {String} [options]  can be one of "tsv", "csv", or "html") ⚡ Function

Writes the contents of a <a href="#/p5.Table">Table</a> object to a file.
Defaults to a `text` file with comma-separated-values ('csv') but can also use tab separation ('tsv'), or generate an HTML table ('html').
The file saving process and location of the saved file will vary between web browsers.

Parameters: ~
                🔢 `Table` (p5.Table) - the <a href="#/p5.Table">Table</a> object to save to a file
                📝 `filename` (String) - the filename to which the Table should be saved
                🔢 `{String} [options]  can be one of "tsv", "csv", or "html"` (unknown)
~

Examples: >
>
> <code>
> let table;
>
> function setup() {
> table = new p5.Table();
>
> table.addColumn('id');
> table.addColumn('species');
> table.addColumn('name');
>
> let newRow = table.addRow();
> newRow.setNum('id', table.getRowCount() - 1);
> newRow.setString('species', 'Panthera leo');
> newRow.setString('name', 'Lion');
>
> // To save, un-comment next line then click 'run'
> // saveTable(table, 'new.csv');
>
> describe('no image displayed');
> }
>
> // Saves the following to a file called 'new.csv':
> // id,species,name
> // 0,Panthera leo,Lion
> </code>
<

See also: ~
   |help p5-saveTable| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:2313
~


p5-IO_second() 📄 ⚡
|second|() ⚡ Function

Returns the current second as a number from 0–59.

Returns: ~
                🔢 Returns Integer: current second between 0 and 59.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the current second.
> let s = second();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textSize(12);
> textFont('Courier New');
>
> // Display the second.
> text(`Current second: ${s}`, 10, 50, 80);
>
> describe(`The text 'Current second: ${s}' written in black on a gray background.`);
> }
> </code>
>
<

See also: ~
   |help p5-second| for detailed help on this symbol~

Source: ~
                ../temp/src/utilities/time_date.js:307
~


p5-IO_table() 📄 ⚡
|table|(id) ⚡ Function

Removes a row from the table object.

Parameters: ~
                🔢 `id` (Integer) - ID number of the row to remove
~

Examples: >
>
> <code>
> // Given the CSV file "mammals.csv"
> // in the project's "assets" folder:
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leopard
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> //my table is comma separated value "csv"
> //and has a header specifying the columns labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> }
>
> function setup() {
> //remove the first row
> table.removeRow(0);
>
> //print the results
> for (let r = 0; r < table.getRowCount(); r++)
> for (let c = 0; c < table.getColumnCount(); c++)
> print(table.getString(r, c));
>
> describe('no image displayed');
> }
> </code>
>
<

See also: ~
   |help p5-table| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:192
~


p5-IO_write() 📄 ⚡
|write|(data) ⚡ Function

Writes data to the `print` stream without adding new lines.
The parameter, `data`, is the data to write.
`data` can be a number or string, as in `myWriter.write('hi')`, or an array of numbers and strings, as in `myWriter.write([1, 2, 3])`.
A comma will be inserted between array array elements when they're added to the `print` stream.

Parameters: ~
                🔢 `data` (String|Number|Array) - data to be written as a string, number,
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> // Create a p5.PrintWriter object.
> let myWriter = createWriter('numbers.txt');
>
> // Add some data to the print stream.
> myWriter.write('1,2,3,');
> myWriter.write(['4', '5', '6']);
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> </code>
>
<

See also: ~
   |help p5-write| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1668
~


p5-IO_year() 📄 ⚡
|year|() ⚡ Function

Returns the current year as a number such as 1999.

Returns: ~
                🔢 Returns Integer: current year.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the current year.
> let y = year();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textSize(12);
> textFont('Courier New');
>
> // Display the year.
> text(`Current year: ${y}`, 10, 50, 80);
>
> describe(`The text 'Current year: ${y}' written in black on a gray background.`);
> }
> </code>
>
<

See also: ~
   |help p5-year| for detailed help on this symbol~

Source: ~
                ../temp/src/utilities/time_date.js:341
~


PROPERTIES                                                   *p5-IO-properties*

p5-IO_columns() 📄 🔧
|columns| ⚡ Function

An array containing the names of the columns in the table, if the "header" the table is loaded with the "header" parameter.

Examples: >
>
> <code>
> // Given the CSV file "mammals.csv"
> // in the project's "assets" folder:
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leopard
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> //my table is comma separated value "csv"
> //and has a header specifying the columns labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> }
>
> function setup() {
> //print the column names
> for (let c = 0; c < table.getColumnCount(); c++) {
> print('column ' + c + ' is named ' + table.columns[c]);
> }
> }
> </code>
>
<

See also: ~
   |help p5-columns| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:78
~


p5-IO_rows() 📄 🔧
|rows| ⚡ Function

An array containing the <a href="#/p5.Table">p5.TableRow</a> objects that make up the rows of the table.
The same result as calling <a href="#/p5/getRows">getRows()</a>

See also: ~
   |help p5-rows| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:87
~


p5-IO_writeFile() 📄 🔧
|writeFile| ⚡ Function

Generate a blob of file data as a url to prepare for download.
Accepts an array of data, a filename, and an extension (optional).
This is a private function because it does not do any formatting, but it is used by <a href="#/p5/saveStrings">saveStrings</a>, <a href="#/p5/saveJSON">saveJSON</a>, <a href="#/p5/saveTable">saveTable</a> etc.

Parameters: ~
                📚 `dataToDownload` (Array)
                📝 `filename` (String)
                🔢 `{String} [extension]` (unknown)
~

See also: ~
   |help p5-writeFile| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:2418
~


VARIABLES                                                   *p5-IO-variables*

p5-IO_arr() 📄 📌
|arr| ⚡ Function

Returns an `Array` with the names of the element's attributes.
Note: Use <a href="#/p5.XML/getString">myXML.getString()</a> or <a href="#/p5.XML/getNum">myXML.getNum()</a> to return an attribute's value.

Examples: >
>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the first child element.
> let first = myXML.getChild(0);
>
> // Get the number of attributes.
> let attributes = first.listAttributes();
>
> // Style the text.
> textAlign(CENTER, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Display the element's attributes.
> text(attributes, 50, 50);
>
> describe('The text "id,species" written in black on a gray background.');
> }
> </code>
>
<

See also: ~
   |help p5-arr| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.XML.js:812
~


p5-IO_content() 📄 📌
|content| ⚡ Function

Sets the element's tag name.
An XML element's name is given by its tag.
For example, the element `&lt;language&gt;JavaScript&lt;/language&gt;` has the name `language`.
The parameter, `name`, is the element's new name as a string.
For example, calling `myXML.setName('planet')` will make the element's new tag name `&lt;planet&gt;&lt;/planet&gt;`.

Examples: >
>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the element's original name.
> let oldName = myXML.getName();
>
> // Set the element's name.
> myXML.setName('monsters');
>
> // Get the element's new name.
> let newName = myXML.getName();
>
> // Style the text.
> textAlign(CENTER, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Display the element's names.
> text(oldName, 50, 33);
> text(newName, 50, 67);
>
> describe(
> 'The words "animals" and "monsters" written on separate lines. The text is black on a gray background.'
> );
> }
> </code>
<

See also: ~
   |help p5-content| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.XML.js:231
~


p5-IO_cString() 📄 📌
|cString| ⚡ Function

Use <a href="#/p5/removeColumn">removeColumn()</a> to remove an existing column from a Table object.
The column to be removed may be identified by either its title (a String) or its index value (an int).
removeColumn(0) would remove the first column, removeColumn(1) would remove the second column, and so on.

Examples: >
>
> <code>
> // Given the CSV file "mammals.csv"
> // in the project's "assets" folder:
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leopard
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> //my table is comma separated value "csv"
> //and has a header specifying the columns labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> }
>
> function setup() {
> table.removeColumn('id');
> print(table.getColumnCount());
> describe('no image displayed');
> }
> </code>
>
<

See also: ~
   |help p5-cString| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:926
~


p5-IO_escape() 📄 📌
|escape| ⚡ Function

Removes any of the specified characters (or "tokens").
If no column is specified, then the values in all columns and rows are processed.
A specific column may be referenced by either its ID or title.

Examples: >
>
> <code>
> function setup() {
> let table = new p5.Table();
>
> table.addColumn('name');
> table.addColumn('type');
>
> let newRow = table.addRow();
> newRow.setString('name', '   $Lion  ,');
> newRow.setString('type', ',,,Mammal');
>
> newRow = table.addRow();
> newRow.setString('name', '$Snake  ');
> newRow.setString('type', ',,,Reptile');
>
> table.removeTokens(',$ ');
> print(table.getArray());
> }
>
> // prints:
> //  0  "Lion"   "Mamal"
> //  1  "Snake"  "Reptile"
> </code>
<

See also: ~
   |help p5-escape| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:790
~


p5-IO_floatVal() 📄 📌
|floatVal| ⚡ Function

Stores a Float value in the TableRow's specified column.
The column may be specified by either its ID or title.

Examples: >
>
> <code>
> // Given the CSV file "mammals.csv" in the project's "assets" folder:
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leopard
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> //my table is comma separated value "csv"
> //and has a header specifying the columns labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> }
>
> function setup() {
> let rows = table.getRows();
> for (let r = 0; r < rows.length; r++) {
> rows[r].setNum('id', r + 10);
> }
>
> print(table.getArray());
>
> describe('no image displayed');
> }
> </code>
<

See also: ~
   |help p5-floatVal| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.TableRow.js:136
~


p5-IO_fx() 📄 📌
|fx| ⚡ Function

Forces download.
Accepts a url to filedata/blob, a filename, and an extension (optional).
This is a private function because it does not do any formatting, but it is used by <a href="#/p5/saveStrings">saveStrings</a>, <a href="#/p5/saveJSON">saveJSON</a>, <a href="#/p5/saveTable">saveTable</a> etc.

See also: ~
   |help p5-fx| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:2443
~


p5-IO_ind() 📄 📌
|ind| ⚡ Function

Removes the first matching child element.
The parameter, `name`, is the child element to remove.
If a string is passed, as in `myXML.removeChild('cat')`, then the first child element with the tag `&lt;cat&gt;` will be removed.
If a number is passed, as in `myXML.removeChild(1)`, then the child element at that index will be removed.

Examples: >
>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Remove the first mammal element.
> myXML.removeChild('mammal');
>
> // Get an array of child elements.
> let children = myXML.getChildren();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Iterate over the array.
> for (let i = 0; i < children.length; i += 1) {
>
> // Calculate the y-coordinate.
> let y = (i + 1) * 25;
>
> // Get the child element's content.
> let content = children[i].getContent();
>
> // Display the child element's content.
> text(content, 10, y);
> }
>
> describe(
> 'The words "Leopard", "Zebra", and "Turtle" written on separate lines. The text is black on a gray background.'
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Remove the element at index 2.
> myXML.removeChild(2);
>
> // Get an array of child elements.
> let children = myXML.getChildren();
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Iterate over the array.
> for (let i = 0; i < children.length; i += 1) {
>
> // Calculate the y-coordinate.
> let y = (i + 1) * 25;
>
> // Get the child element's content.
> let content = children[i].getContent();
>
> // Display the child element's content.
> text(content, 10, y);
> }
>
> describe(
> 'The words "Goat", "Leopard", and "Turtle" written on separate lines. The text is black on a gray background.'
> );
> }
> </code>
>
<

See also: ~
   |help p5-ind| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.XML.js:707
~


p5-IO_newPW() 📄 📌
|newPW| ⚡ Function

Creates a new <a href="#/p5.PrintWriter">p5.PrintWriter</a> object.
<a href="#/p5.PrintWriter">p5.PrintWriter</a> objects provide a way to `save` a sequence of `text` data, called the *`print` stream*, to the user's computer.
They're low-level objects that enable precise control of `text` output.
Functions such as <a href="#/p5/saveStrings">saveStrings()</a> and <a href="#/p5/saveJSON">saveJSON()</a> are easier to use for simple file saving.
The first parameter, `filename`, is the name of the file to be written.
If a string is passed, as in `createWriter('words.txt')`, a new <a href="#/p5.PrintWriter">p5.PrintWriter</a> object will be created that writes to a file named `words.txt`.
The second parameter, `extension`, is optional.
If a string is passed, as in `createWriter('words', 'csv')`, the first parameter will be interpreted as the file name and the second parameter as the extension.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create a p5.PrintWriter object.
> let myWriter = createWriter('xo.txt');
>
> // Add some lines to the print stream.
> myWriter.print('XOO');
> myWriter.print('OXO');
> myWriter.print('OOX');
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100) {
> // Create a p5.PrintWriter object.
> // Use the file format .csv.
> let myWriter = createWriter('mauna_loa_co2', 'csv');
>
> // Add some lines to the print stream.
> myWriter.print('date,ppm_co2');
> myWriter.print('1960-01-01,316.43');
> myWriter.print('1970-01-01,325.06');
> myWriter.print('1980-01-01,337.9');
> myWriter.print('1990-01-01,353.86');
> myWriter.print('2000-01-01,369.45');
> myWriter.print('2020-01-01,413.61');
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> }
> </code>
>
<

See also: ~
   |help p5-newPW| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1548
~


p5-IO_obj() 📄 📌
|obj| ⚡ Function

Return an attribute's value as a string.
The first parameter, `name`, is a string with the name of the attribute being checked.
For example, calling `myXML.getString('`color`')` returns the element's `id` attribute as a string.
The second parameter, `defaultValue`, is optional.
If a string is passed, as in `myXML.getString('`color`', 'deeppink')`, it will be returned if the attribute doesn't exist.
Note: Use <a href="#/p5.XML/getString">myXML.getString()</a> or <a href="#/p5.XML/getNum">myXML.getNum()</a> to return an attribute's value.

Examples: >
>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the first reptile child element.
> let reptile = myXML.getChild('reptile');
>
> // Get the reptile's content.
> let content = reptile.getContent();
>
> // Get the reptile's species.
> let species = reptile.getString('species');
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Display the species attribute.
> text(`${content}: ${species}`, 5, 50, 90);
>
> describe(`The text "${content}: ${species}" written in black on a gray background.`);
> }
> </code>
> </div>
>
> <div>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the first reptile child element.
> let reptile = myXML.getChild('reptile');
>
> // Get the reptile's content.
> let content = reptile.getContent();
>
> // Get the reptile's color.
> let attribute = reptile.getString('color', 'green');
>
> // Style the text.
> textAlign(CENTER, CENTER);
> textFont('Courier New');
> textSize(14);
> fill(attribute);
>
> // Display the element's content.
> text(content, 50, 50);
>
> describe(`The text "${content}" written in green on a gray background.`);
> }
> </code>
>
<

See also: ~
   |help p5-obj| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.XML.js:1084
~


p5-IO_regex() 📄 📌
|regex| ⚡ Function

Trims leading and trailing whitespace, such as spaces and tabs, from String table values.
If no column is specified, then the values in all columns and rows are trimmed.
A specific column may be referenced by either its ID or title.

Examples: >
>
> <code>
> function setup() {
> let table = new p5.Table();
>
> table.addColumn('name');
> table.addColumn('type');
>
> let newRow = table.addRow();
> newRow.setString('name', '   Lion  ,');
> newRow.setString('type', ' Mammal  ');
>
> newRow = table.addRow();
> newRow.setString('name', '  Snake  ');
> newRow.setString('type', '  Reptile  ');
>
> table.trim();
> print(table.getArray());
> }
>
> // prints:
> //  0  "Lion"   "Mamal"
> //  1  "Snake"  "Reptile"
> </code>
<

See also: ~
   |help p5-regex| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:859
~


p5-IO_ret() 📄 📌
|ret| ⚡ Function

Retrieves a Float value from the TableRow's specified column.
The column may be specified by either its ID or title.

Examples: >
>
> <code>
> // Given the CSV file "mammals.csv" in the project's "assets" folder:
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leopard
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> //my table is comma separated value "csv"
> //and has a header specifying the columns labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> }
>
> function setup() {
> let rows = table.getRows();
> let minId = Infinity;
> let maxId = -Infinity;
> for (let r = 0; r < rows.length; r++) {
> let id = rows[r].getNum('id');
> minId = min(minId, id);
> maxId = min(maxId, id);
> }
> print('minimum id = ' + minId + ', maximum id = ' + maxId);
> describe('no image displayed');
> }
> </code>
<

See also: ~
   |help p5-ret| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.TableRow.js:272
~


p5-IO_self() 📄 📌
|self| ⚡ Function

A class to describe a `print` stream.
Each `p5.PrintWriter` object provides a way to `save` a sequence of `text` data, called the *`print` stream*, to the user's computer.
It's a low-level object that enables precise control of `text` output.
Functions such as <a href="#/p5/saveStrings">saveStrings()</a> and <a href="#/p5/saveJSON">saveJSON()</a> are easier to use for simple file saving.
Note: <a href="#/p5/createWriter">createWriter()</a> is the recommended way to make an instance of this class.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> // Create a p5.PrintWriter object.
> let myWriter = createWriter('xo.txt');
>
> // Add some lines to the print stream.
> myWriter.print('XOO');
> myWriter.print('OXO');
> myWriter.print('OOX');
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> </code>
>
<

See also: ~
   |help p5-self| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:1618
~


p5-IO_str() 📄 📌
|str| ⚡ Function

Returns the element's content as a `String`.
The parameter, `defaultValue`, is optional.
If a string is passed, as in `myXML.getContent('???')`, it will be returned if the element has no content.

Examples: >
>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Get the first reptile child element.
> let reptile = myXML.getChild('reptile');
>
> // Get the reptile's content.
> let content = reptile.getContent();
>
> // Style the text.
> textAlign(CENTER, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Display the element's content.
> text(content, 5, 50, 90);
>
> describe(`The text "${content}" written in green on a gray background.`);
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Create a p5.XML object.
> let blankSpace = new p5.XML();
>
> // Get the element's content and use a default value.
> let content = blankSpace.getContent('Your name');
>
> // Style the text.
> textAlign(CENTER, CENTER);
> textFont('Courier New');
> textSize(14);
>
> // Display the element's content.
> text(content, 5, 50, 90);
>
> describe(`The text "${content}" written in green on a gray background.`);
> }
> </code>
>
<

See also: ~
   |help p5-str| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.XML.js:1226
~


p5-IO_stringVal() 📄 📌
|stringVal| ⚡ Function

Stores a String value in the TableRow's specified column.
The column may be specified by either its ID or title.

Examples: >
>
> <code>
> // Given the CSV file "mammals.csv" in the project's "assets" folder:
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leopard
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> //my table is comma separated value "csv"
> //and has a header specifying the columns labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> }
>
> function setup() {
> let rows = table.getRows();
> for (let r = 0; r < rows.length; r++) {
> let name = rows[r].getString('name');
> rows[r].setString('name', 'A ' + name + ' named George');
> }
>
> print(table.getArray());
>
> describe('no image displayed');
> }
> </code>
<

See also: ~
   |help p5-stringVal| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.TableRow.js:180
~


p5-IO_t() 📄 📌
|t| ⚡ Function

Use <a href="#/p5/addColumn">addColumn()</a> to add a new column to a <a href="#/p5.Table">Table</a> object.
Typically, you will want to specify a title, so the column may be easily referenced later by name.
(If no title is specified, the new column's title will be null.)

Examples: >
>
> <code>
> // Given the CSV file "mammals.csv"
> // in the project's "assets" folder:
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leopard
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> //my table is comma separated value "csv"
> //and has a header specifying the columns labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> }
>
> function setup() {
> table.addColumn('carnivore');
> table.set(0, 'carnivore', 'no');
> table.set(1, 'carnivore', 'yes');
> table.set(2, 'carnivore', 'no');
>
> //print the results
> for (let r = 0; r < table.getRowCount(); r++)
> for (let c = 0; c < table.getColumnCount(); c++)
> print(table.getString(r, c));
>
> describe('no image displayed');
> }
> </code>
>
<

See also: ~
   |help p5-t| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:676
~


p5-IO_tableArray() 📄 📌
|tableArray| ⚡ Function

Retrieves all table data and returns it as a multidimensional array.

Examples: >
>
> <code>
> // Given the CSV file "mammals.csv"
> // in the project's "assets" folder
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leoperd
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> // table is comma separated value "CSV"
> // and has specifying header for column labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> }
>
> function setup() {
> let tableArray = table.getArray();
> for (let i = 0; i < tableArray.length; i++) {
> print(tableArray[i]);
> }
> describe('no image displayed');
> }
> </code>
>
<

See also: ~
   |help p5-tableArray| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:1321
~


p5-IO_tableObject() 📄 📌
|tableObject| ⚡ Function

Retrieves all table data and returns as an object.
If a column name is passed in, each row object will be stored with that attribute as its title.

Examples: >
>
> <code>
> // Given the CSV file "mammals.csv"
> // in the project's "assets" folder:
> //
> // id,species,name
> // 0,Capra hircus,Goat
> // 1,Panthera pardus,Leopard
> // 2,Equus zebra,Zebra
>
> let table;
>
> function preload() {
> //my table is comma separated value "csv"
> //and has a header specifying the columns labels
> table = loadTable('assets/mammals.csv', 'csv', 'header');
> }
>
> function setup() {
> let tableObject = table.getObject();
>
> print(tableObject);
> //outputs an object
>
> describe('no image displayed');
> }
> </code>
>
<

See also: ~
   |help p5-tableObject| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.Table.js:1264
~


p5-IO_type() 📄 📌
|type| ⚡ Function

Generate a blob of file data as a url to prepare for download.
Accepts an array of data, a filename, and an extension (optional).
This is a private function because it does not do any formatting, but it is used by <a href="#/p5/saveStrings">saveStrings</a>, <a href="#/p5/saveJSON">saveJSON</a>, <a href="#/p5/saveTable">saveTable</a> etc.

See also: ~
   |help p5-type| for detailed help on this symbol~

Source: ~
                ../temp/src/io/files.js:2419
~


p5-IO_xmlSerializer() 📄 📌
|xmlSerializer| ⚡ Function

Returns the element as a `String`.
`myXML.serialize()` is useful for sending the element over the network or saving it to a file.

Examples: >
>
> <code>
> let myXML;
>
> // Load the XML and create a p5.XML object.
> function preload() {
> myXML = loadXML('assets/animals.xml');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the text.
> textAlign(LEFT, CENTER);
> textFont('Courier New');
> textSize(12);
>
> // Display instructions.
> text('Double-click to save', 5, 50, 90);
>
> describe('The text "Double-click to save" written in black on a gray background.');
> }
>
> // Save the file when the user double-clicks.
> function doubleClicked() {
> // Create a p5.PrintWriter object.
> // Use the file format .xml.
> let myWriter = createWriter('animals', 'xml');
>
> // Serialize the XML data to a string.
> let data = myXML.serialize();
>
> // Write the data to the print stream.
> myWriter.write(data);
>
> // Save the file and close the print stream.
> myWriter.close();
> }
> </code>
>
<

See also: ~
   |help p5-xmlSerializer| for detailed help on this symbol~

Source: ~
                ../temp/src/io/p5.XML.js:1345
~




==============================================================================
Generated by p5.js Documentation Automation
See: https://github.com/prjctimg/automata
Last updated: 2026-02-03
📄 End of IO documentation 📄
==============================================================================