#  OpenEating
Emily Cohen, Lainie Esralew, Olivia Schotz, Danielle Sharabi, Laurel Wanger
CSE 438 Final Project - OpenEating

Notes about our API:

    The free version of our API, https://spoonacular.com/food-api, has a small number of calls we can make each day. We have provided a few API keys below, in case the maximum is reached. You may notice this if the home page is continuously loading, or if certain things are not appearing. Please change api_key in WineViewController, RecipeDetailsViewController, SimilarViewController, HomeViewController, and FavoritesViewController if this is the case. 
        API Key 1: “7b2c5999d4f940a999efad739e883d3c”
        API Key 2: “61de2798dcdc47c88f2279d7c23dad64”
        API Key 3: “6865dbd27d23411597e8adb40994b60b”
        API Key 4: “174a30c36e1e448a85cdee1d897b0632”
        
    Also, please note that the API does not always fetch accurate results. Even if a user is vegetarian or vegan, the API sometimes fetches recipe results with meat; we looked into this and did not see any errors with our URL or the way we fetched the information. Also, there are not wine pairings for every type of cuisine. We attempted to fix certain cuisines as we tested our application, but wanted to provide a warning in case no wine results appear.

Running OpenEating: To run OpenEating, please select OpenEating and the iPhone11 Pro options for the simulator. It may take a while to build the first time, as we used cloud firestore.

To provide some information on our data storage, we chose to use Cloud Firestore. We also utilized Google Sign-In functionality to ensure the users have a seamless experience on OpenEating, and they do not have to worry about remembering an additional password. We also use the database to store information about the user, their food preferences, and favorites. 

As for the functionality of OpenEating, we have provided a written explanation below:

    Login: If an account is created, sign in using Google and your account will appear with your preferences already set. Also, you can log out via the “Profile” page if you would like. 

    Sign Up: To make an account, you can sign up using a Google email account. After you sign up, you can click “Continue” to set your dietary preferences.

    Search: To search for a recipe, type into the search bar and hit the “return” button on your keyboard. You can search for different types of food, such as salad, pasta, and more.

    Clicking a Cuisine: The buttons at the top of the search page allow you to get recipes of different cuisines, such as American, Japanese, Italian, etc.

    Wine Pairings: From the recipe’s detailed view controller, you can click on the wine glass icon to view recommended wine pairings for the recipe’s corresponding cuisine type. Note that as mentioned above, not all cuisines have recommended wine pairings.

    Share: From the recipe’s detailed view controller, you can click on the share button to send the recipe via text.

    See Similar Recipes:  From the recipe’s detailed view controller, clicking on the “See Similar Recipes” button redirects you to a similar recipes screen which displays a collection view of recipes that are similar to the one you are viewing.

    Switching User Preferences: From the profile tab, users can modify their dietary restrictions and/or allergies. Be sure to click the save button at the bottom of the page. 

    Favorites: From the favorites tab, users can view their favorite recipes from OpenEating, go directly to their detailed recipe page, or delete them from their favorites.

