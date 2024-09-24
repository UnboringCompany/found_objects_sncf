# SNCF FoundIt

SNCF FoundIt is a mobile application that allows users to search for lost objects found on SNCF trains and stations. The app provides a user-friendly interface to search for objects based on various filters such as date, station, and object type. The app also displays the last visit date for the search of found objects.

## Getting Started

SNCF FoundIt is a mobile application that helps users find their lost objects on SNCF trains and stations. With this app, users can search for lost objects based on various filters such as date, station, and object type. The app also displays the last visit date for the search of found objects.

## Implementation

To create this app, we used a **HomePage** widget that displays the main screen of the app. The HomePage widget includes a search button that navigates to the SearchPage widget. The SearchPage widget allows users to search for lost objects based on various filters such as date, station, and object type. The app also uses a **SharedPreferences** class to store the last visit date for the search of found objects.

The app uses a **Provider** package to manage the state of the app. The app has two providers: **StationProvider** and **ObjectsProvider**. The StationProvider fetches the list of stations from the SNCF API, while the ObjectsProvider fetches the list of found objects based on the search filters.

The app also uses a **FoundObject** class to represent a found object. The FoundObject class has properties such as nature, type, station name, date, and an icon corresponding to the type.

We also used an enumeration name **SortOrder** to choose to order the results by ascending or descending date.

## Features

### Objects Found Since Last Visit

On the landing page, the objects found since the last visit are displayed. The app uses the **SharedPreferences** class to store the last visit date for the search of found objects. On the first visit, the app displays the objects found in the last month. Next, the app displays the objects found since the last visit.

The date is loaded at the start of the app, and updated when the API call is done. This ensures that we don't update the last visit date before calling the API.

If no objects are found since the last visit, the app displays a message saying "No objects found since your last visit."

### Search for Objects

The app allows users to search for lost objects based on various filters such as date, station, and object type. The search results are displayed in a list view with the object's nature, type, station name, and date.

If the user doesn't select any filter, the app displays all the found objects. Additionally, if one of the filters is empty, the app displays all the found objects that match the other filters.

The app also displays a message if no objects are found based on the search filters.

## Documentation
We added doxygen to acces the whole documentation easyly. To generate the documentation, you need to install doxygen and the you can run the following command in the terminal:
```bash
doxygen Doxyfile
```
Then, you can open the index.html by entering the following command in the terminal:
```bash
start docs/html/index.html
```

## Date

The app was last updated on 24/09/2024.

## Team
[Léo Wadin](https://github.com/ArKc0s)<br>
[Elena Beylat](https://github.com/PetitCheveu)<br>