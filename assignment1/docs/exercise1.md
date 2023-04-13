# Exercise 1

## Bayesian network

![](plantuml/exercise1_bn.svg)

## Conditional probability tables

### Cheater

P(Cheater) = 
| Cheater=true | Cheater=false |
| - | - |
| 1/5 | 4/5 |

### Draw1

P(Draw1) = 
| Draw1=jack | Draw1=queen | Draw1=king | Draw1=ace |
| - | - | - | - |
| 1/4 | 1/4 | 1/4 | 1/4 |

### Draw2

P(Draw2 | Cheater) =
| Cheater | Draw2=jack | Draw2=queen | Draw2=king | Draw2=ace |
| - | - | - | - | - |
| false | 1/4 | 1/4 | 1/4 | 1/4 |
| true | 0 | 1/4 | 1/4 | 2/4 |

### Highest

P(Highest | Draw1, Draw2) = 
| Draw1 | Draw2 | Highest=player1 | Highest=player2 | Highest=none |
| - | - | - | - | - |
| jack | jack | 0 | 0 | 1 |
| jack | queen/king/ace | 0 | 1 | 0 |
| queen | jack | 1 | 0 | 0 |
| queen | queen | 0 | 0 | 1 |
| queen | king/ace | 0 | 1 | 0 |
| king | jack/queen | 1 | 0 | 0 |
| king | king | 0 | 0 | 1 |
| king | ace | 0 | 1 | 0 |

### Coin

P(Coin | Cheater) = 
| Cheater | Coin=heads | Coin=tails |
| - | - | - |
| false | 1/2 | 1/2 |
| true | 0 | 1 |

### Winner

P(Winner | Highest, Coin) =
| Highest | Coin | Winner=player1 | Winner=player2 |
| - | - | - | - |
| player1 | heads/tails | 1 | 0 |
| player2 | heads/tails | 0 | 1 |
| none | heads | 1 | 0 |
| none | heads | 0 | 1 |
