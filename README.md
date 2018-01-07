Hitori Puzzle Solver
============

This Hitori Puzzle Solver is one of the projects that I developed for the Knowledge Representation and Automatic Reasoning course in the junior year of my undergrad in computer science at UDC (Spain). It transforms a simplified version of the Hitori puzzle into a set of CNF boolean clauses based on the rules of the game, calls a propositional satisfiability (SAT) solver and creates the solution.


## Hitori puzzle

Hitori is played with a grid of squares or cells, with each cell initially containing a number. The objective is to eliminate numbers by blacking out some of the squares until no row or column has more than one occurrence of a given number. Additionally, black cells cannot be adjacent, although they can be diagonal to one another. The remaining numbered cells must be all connected to each other (we ignored this last restriction as per the assignment requirements).


## Contact

Contact [Daniel Ruiz Perez](mailto:druiz072@fiu.edu) for requests, bug reports and good jokes.


## License

The software in this repository is available under the GNU General Public License, version 3. See the [LICENSE](https://github.com/DaniRuizPerez/AutomaticReasoning/blob/master/LICENSE) file for more information.
