LiveScoreUpdater is a class for getting updates from the live score metadata xml files.

Setup:

1. Add the LiveScoreUpdater source code to your project

2. Download the TFHpple utility classes and add them to your project:

https://github.com/topfunky/hpple

3. Add the libxml2.2 library to your linked libraries in your Xcode project
Add "/usr/include/libxml2" to your header search paths in your project build settings

To use the class:

1. Create an instance and initialize it with a livescore xml file

2. Periodically call getNextUpdate to retrieve the next live score update

3. The getNextUpdate method returns a LiveScoreUpdate object which is basically just a collection of properties containing the update metadata

4. Some metadata fields in the LiveScoreUpdate object might be nil if they are not applicable (e.g. error info when a team is batting)

5. The runs, hits, and errors values are only for that inning.  The app will need to track any cumulative values across multiple innings

6. The inningHalf property is an int – 1 = top of the inning, 2 = bottom of the inning


Example code:
// This just calls get next update in a tight loop
// If you wanted to simulate real time you'd need to add some delay between calls
while (updater.completed == NO) {
    LiveScoreUpdate *update = [updater getNextUpdate];
}
