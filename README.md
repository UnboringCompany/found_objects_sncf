# SNCF FoundIt

SNCF FoundIt is a mobile application that allows users to search for lost objects found on SNCF trains and stations. The app provides a user-friendly interface to search for objects based on various filters such as date, station, and object type. The app also displays the last visit date for the search of found objects.

## Getting Started

SNCF FoundIt is a mobile application that helps users find their lost objects on SNCF trains and stations. With this app, users can search for lost objects based on various filters such as date, station, and object type. The app also displays the last visit date for the search of found objects.

## Implementation

To create this app, we used a **HomePage** widget that displays the main screen of the app. The HomePage widget includes a search button that navigates to the SearchPage widget. The SearchPage widget allows users to search for lost objects based on various filters such as date, station, and object type. The app also uses a **SharedPreferences** class to store the last visit date for the search of found objects.

The app uses a **Provider** package to manage the state of the app. The app has two providers: **StationProvider** and **ObjectsProvider**. The StationProvider fetches the list of stations from the SNCF API, while the ObjectsProvider fetches the list of found objects based on the search filters.

The app also uses a **FoundObject** class to represent a found object. The FoundObject class has properties such as nature, type, station name, date, and an icon corresponding to the type.

## Date

The app was last updated on 24/09/2024.

## Team
[Léo Wadin](https://github.com/ArKc0s)<br>
[Elena Beylat](https://github.com/PetitCheveu)<br>