# Functional Requirements
## General
1. Display a "welcome" widget when the application starts and there are no journal entries.
2. Provide the user, via a button in the right of the AppBar, with a toggle-able configuration option, presented in a Drawer, to change the theme from light to dark.
3. Changing the configuration should immediately change the visual theme of the app.
4. The configuration preference should persist between application restarts, and be honored when the user starts the application.
5. When no prior saved preference exists, use the light theme.
6. When the application starts, load the saved theme configuration, and immediately use it when creating the MaterialApp.

## Journal
1. Model a journal consisting of journal entries. A JournalEntry object has an id (an integer), title (a string), body (a string), rating (an integer), and date (a DateTime).
2. Display a list of existing journal entries, by displaying the title and date of the journal entry.
3. Display the details of the journal entry, including its title, body, date and numeric rating, when tapped on in the list.
4. Enable the user to go "back" to the list when viewing the details of a journal entry full-screen.
5. Adapt the interface to display the list of journal entries on the left, and the details of the entry on the right (in a "master-detail" layout convention) when the device has at least 800* pixels of horizontal space. (* If your simulator/device screen isn't large enough, just pick a width that makes sense, eg 500 or 700.)
6. Display a FloatingActionButton that, when tapped, displays a form for entering attributes of a new journal entry.
7. Validate the values in the form, ensuring that the title and body are not blank, and that the rating is an integer between 1 and 4.
8. Create a new journal entry when the form's "Save" button is tapped, and return to the previous screen
9. Ensure that new journal entries appear in the list after the form's "Save" button is tapped.
10. Ensure that previously-created journal entries appear in the list when the application first starts.

# Technical Requirements
## General
1. Do not use a state management library, such as provider or scoped_model. Rely on manual state management and/or APIs in the Flutter SDK.
2. Use the "shared preferences" concept of mobile applications to load and save the theme configuration option, so that the chosen option persists between application restarts.
3. Use a sqlite database file to store, retrieve and update the journal entries, so that the data persists between application restarts. Do not "pre-create" the database file - have your app code do it on the device. Name the database file journal.sqlite3.db.Use the following queries or create your own:
```
SELECT * FROM journal_entries;
INSERT INTO journal_entries(title, body, rating, date) VALUES(?, ?, ?, ?);
```
4. Do not hard-code the database schema as a String in your code. Use the "assets" or "file i/o" concept of mobile applications to load the text of the initial SQL statement that creates the schema of the sqlite database.
