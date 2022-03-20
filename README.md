# Babbel assignment 

## Invested time(~8 hours):
    1. Concept and design: 30 mins
    2. Loading data and models: 30 mins
    3. Game mechanics with MVVM: 4 hours
    4. UI 1.5 hours
    5. Unit testing: 1 hour

## Decisions made to solve certain aspects of the game:
    1. In this project my focus was on architecture to achieve a maintainable, testable and scalable code(MVVM & Combine architecture is chosen)
    2. Strategy pattern is implemented for getting data from json file (In future we can add new strategy for loading data without any change in current codes).
    3. Keep small data set for the game instead of all words(After loading the data, fetch n random element from the source and then fetch a answer for each word from random list and make a question viewModel and define correct asnwer for each question)
    4. End game logic: Considering 3 buttons in first page for define number of questions that user should answer in the game(end game logic)
    5. Simple UI is consider for answer by two buttons in bottom of page
    
    
## what would be the first thing to improve or add if there had been more time:
    1. Implement Coordinator pattern for navigation and pass it as a dependency to viewModels
    2. Add game state to GameViewModel(loading, readyToPlay, finished, paused...)
    3. Add pause and quit functionality.
    4. Write unit tests for all functionalities and states
    5. Better questions selection mechanism.
    6. Improve the UI/UX
    7. Disable actions while game is loading
    8. Handle errors instead print them in console  

    Also I put some TODO in the code for enhancement or implementation in future

### Developer
Amin Heidari
amin.hd66@gmail.com

Good luck!
