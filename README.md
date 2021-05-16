# Montgomery County Food Delivery App
A mobile app to streamline the process of connecting local volunteers to people in need who are unable to leave their homes to receive food due to COVID-19.

## Contributors
* [Rohan Mehta](https://github.com/rnmehta726)
* [Roshan Mehta](https://github.com/roshanmehta)
* [Shreyas Vatts](https://github.com/VattsShreyas)
* [Palash Pawar](https://github.com/pawarpp)

## How it Works
### App (Frontend)
The app is the interface with which volunteers can view clients and choose which clients to deliver to
___
The app itself is very easy to use. Volunteers can first log in using their credentials. Once successfully logged in, volunteers are presented with a list of available clients who need food delivered. Volunteers can add specific clients to their personal list of deliveries. This personal list can be accessed on the "My Clients" page. On this page, volunteers can click on their clients to find out the exact delivery specifications, remove clients from their delivery list, and record deliveries.

### Backend
The backend uses Google Scripts and Firebase to retrive and store client data.
#### Google Scripts
* A Google Form is used to get client data
* The data from a completed form is then sent to our Firestore database in Firebase using Google Scripts

#### Firebase
* A Cloud Firestore database is used to store the client data and volunteer data
* The database is accessed by the app to display a list of clients for volunteers in the app
