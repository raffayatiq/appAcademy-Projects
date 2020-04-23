# app_academy_memory_puzzle
Implementation of a simple command-line version of the classic [Match 2 memory card game](http://mypuzzle.org/find-the-pair) with dynamic board size, AI (ComputerPlayer), and unlimited multiplayer.

### ComputerPlayer Class AI Implementation
* On its first guess, if it knows where 2 matching cards are, guess one of them, otherwise guess randomly among cards it has not yet seen.
* On its second guess, if its first guess revealed a card whose value matches a known location, guess that location, otherwise guess randomly among cards it has not yet seen.
