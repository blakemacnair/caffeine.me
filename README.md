# caffeine.me
Find new local coffee shops!

# Installation
To imstall on your local machine, simply: 
1. clone this repo 
  - `git clone git@github.com:blakemacnair/caffeine.me.git` for ssh
  - `git clone https://github.com/blakemacnair/caffeine.me.git` for https
2. Install Carthage if you don't yet have it 
  - `brew install carthage`
3. Run the following command from the terminal in the project's root directory 
  - `carthage bootstrap --platform iOS`

# Notes for improvement
- Need to add test coverage for:
  - CMFourSquareLayer
    - Add OHHttpStubs to mock the network
    - Add coverage for `CMFourSquareRelay`
  - CMViewLayer
    - Add coverage for `MapInteractor`
    - Add coverage for `MapViewModel`
    - Add coverage for `VenueDetailInteractor`
    - Add coverage for `VenueDetailViewModel`
- Need to add warning/error views:
  - When user has not yet authorized location services
  - When the device cannot update location
