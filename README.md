# AEM 7130 Syllabus
**Time**: Monday 4:30-7:00

**Location**: Warren 113

**Office Hours**: Tuesday 1:30-3:00

**Prerequisites**: ECON 6090 and ECON 6170

**Programs**: You will need to install the following programs on your computer

- [Git](https://git-scm.com/downloads)
- [Julia or JuliaPro](https://julialang.org/downloads/)
- [Jupyter/Anaconda](https://www.anaconda.com/download/)


## Course Objective

The objective of this course is to familiarize you with computational methods for economics. In this course you should learn why we need computational methods for certain types of problems, the theory behind the methods, and most importantly, how to use them in practice. The first part of the course covers general basics of computing and doing computational research. The second part covers optimization and function approximation. The third part covers basic dynamic theory and then goes over a selection of methods for solving dynamic models either numerically or empirically. The fourth part covers prediction and machine learning. The course concludes with how to use high performance computing resources like computing clusters. The beginning of the course is heavy on theory to understand what is happening inside your machine when solving numerical models. As we begin studying techniques to solve economic problems you will also apply them in practice.

I will be teaching the class in Julia. Julia is becoming widely used in computational economics because it's open source, it has many packages to employ the methods we will learn and practice, and it's fast and intuitive. **Please set up a GitHub (https://github.com) account before class starts.** Much of what we do can be easily ported to R, Python, MATLAB, and C.

## Readings

Some theory on dynamics will draw from Karp and Traeger (2013). Nocedal and Wright (2006) is highly useful as a detailed reference for optimization. Judd (1998) and Miranda and Fackler (2002) take a more detailed look at the fundamental numerical methods in economics. Judd (1998), Miranda and Fackler (2002), and Nocedal and Wright (2006) are available as eBooks in the library and Karp and Traeger (2013) will be available on Canvas or from the authors' websites. Please look at 
[Learning Julia](https://julialang.org/learning/) or go over the first few [QuantEcon Julia lectures](https://quantecon.org) for a brief introduction to coding in Julia. The remainder of the required readings will be from journal articles or excerpts from texts which will be accessible online and posted on GitHub a week before class.

Judd, Kenneth L. (1998) Numerical Methods in Economics, Cambridge, MA: MIT Press.

Karp, Larry and Christian Traeger (2013) Dynamic Methods in Environmental and Resource Economics.

Miranda, Mario J. and Paul L. Fackler (2002) Applied Computational Economics and Finance, Cambridge, MA: MIT Press.

Nocedal, J. and S. J. Wright (2006) Numerical Optimization, New York: Springer, 2nd edition.

## Grading 

- Class participation: 10%
- Presentation of a numerical paper: 10%
- Final project proposal: 15%
- Final project: 25%
- Problem sets: 40%

## Important dates

- Final project proposals due: March 13
- Final project presentations: April 29
- Final project paper due: April 30

## Assignments

### Problem sets
There will be four problem sets. You must submit your code on [GitHub](https://github.com) to your group's repository. We will learn how to use Git during class and will be using GitHub Classroom for submissions. You may work in a group of **three or fewer people**. Each group should turn in one assignment with all members' names at the top of the file. Your grade will be a function of how well your answer the questions and how reproducible you make your code.

In addition to submitting problem sets you will be required to do a reproduction exercise on your classmates' code. You will be randomly assigned to another classmate's submitted problem set and tasked with seeing whether it reproduces and offer suggestions for reproducibility.

- Problem set 1: TBD
- Problem set 2: TBD
- Problem set 3: TBD
- Problem set 4: TBD

### Final project

There is a final project for the course, due at the end of the semester, where each student will submit the beginning of a numerically-driven research paper. A proposal of the final project is due at about the halfway point of the course. During the final week of class, each student will present their completed work which should have a first-take at a numerical/empirical model and preliminary results. The paper is due the day after the final class. It should be at least 10 pages including tables and graphs and should:

1. Have an introduction that clearly states the economic question you are answering, frames your research in the context of the existing literature, and tells the reader what you are doing to advance economic knowledge.
2. Analytically develop the model, provide proofs for theoretical results if there are any.
3. Describe how you solve the model.
4. Have preliminary results.

### Numerical paper presentations
Starting near the middle of the course, one student a week will present either a paper that either applies methods we have learned in a previous week, or extends methods we have previously learned. More information will come later in the course.


## Course Schedule

### January 22: Intro to computing

**Theory**: floats, ints, read/write, memory, truncation, rounding, error propagation, matrix inversion, differentiation, integration

Judd (1998, Chapters 2, 3 and 7)

Miranda and Fackler (2002, Chapters 1, 2, and 5)

### January 29: Coding, reproducibility, and the shell

**Applications**: shell scripts, generic coding, reproducible coding, speed in julia

[Software Carpentry: The Unix Shell](https://swcarpentry.github.io/shell-novice/)

[AEA Reproducibility Guidance](https://aeadataeditor.github.io/aea-de-guidance/)

[Learning Julia](https://julialang.org/learning/)

[QuantEcon Lectures](https://quantecon.org/)

### February 5: Version control

**Applications**: git, github, issues, pull requests

[Software Carpentry: Version Control with Git](https://swcarpentry.github.io/git-novice/)

[SEERE Lab wiki](https://github.com/cornell-seere/lab-information/wiki)

### February 12: Rootfinding and optimization

**Theory**: iterative methods, newton methods, gaussian methods, global solvers

Judd (1998, Chapter 4 and 5)

Miranda and Fackler (2002, Chapters 3 and 4)

Nocedal and Wright (2006, Chapters 2-6)

### February 19: Discrete time dynamic programming

**Theory**: markov chains, principle of optimality

Adda, Jerome and Russell W Cooper (2003) Dynamic Economics: Quantitative Methods and Ap- plications: MIT press.

Ljungqvist, Lars and Thomas J Sargent (2004) Recursive Macroeconomic Theory: MIT press.

### February 26: Function approximation

**Theory**: discretization, pseudospectral methods, finite element methods

Fernandez-Villaverde, Jesus, Juan Francisco Rubio-Ramirez, and Frank Schorfheide (2016) “Solution and estimation methods for DSGE models,” Handbook of Macroeconomics, Vol. 2, pp. 527–724.

### March 4: Solving discrete time dynamic models

**Theory**: value function iteration, policy iteration, time iteration

Aruoba, S Boragan, Jesus Fernandez-Villaverde, and Juan F Rubio-Ramirez (2006) “Comparing solution methods for dynamic equilibrium economies,” Journal of Economic Dynamics and Control, Vol. 30, No. 12, pp. 2477–2508.

Cai, Yongyang and Kenneth L Judd (2014) Advances in Numerical Dynamic Programming and New Applications, Vol. 3: Elsevier B.V. pp.479–516.

Fernandez-Villaverde, Jesus, Juan Francisco Rubio-Ramirez, and Frank Schorfheide (2016) “Solution and estimation methods for DSGE models,” Handbook of Macroeconomics, Vol. 2, pp. 527–724.

**Applications**: climate change, bioeconomics

Lemoine, Derek and Christian Traeger (2014) “Watch Your Step: Optimal policy in a tipping climate,” American Economic Journal: Economic Policy, Vol. 6, No. 1.

Springborn, Michael and James N. Sanchirico (2013) “A density projection approach for non-trivial information dynamics: Adaptive management of stochastic natural resources,” Journal of Envi- ronmental Economics and Management, Vol. 66, No. 3, pp. 609–624.

### March 11: Continuous time optimal control

**Theory**: maximum principle, hamiltonians

Caputo, Michael Ralph (2005) Foundations of dynamic economic analysis: optimal control theory and applications: Cambridge University Press.

**Applications**: oil extraction

Anderson, Soren T, Ryan Kellogg, and Stephen W Salant (2018) “Hotelling under pressure,” Journal of Political Economy, Vol. 126, No. 3, pp. 984–1026.

### March 18: Solving continuous time dynamic models

**Theory**: shooting, backwards shooting

Brunner, Martin and Holger Strulik (2002) “Solution of perfect foresight saddlepoint problems: A simple method and applications,” Journal of Economic Dynamics and Control, Vol. 26, No. 5, pp. 737–753.

Judd (1998, Chapter 10)

Trimborn, Timo, Karl-Josef Koch, and Thomas M. Steger (2008) “Multidimensional Transitional Dynamics: a Simple Numerical Procedure,” Macroeconomic Dynamics, Vol. 12, No. 03, pp. 301– 319.

**Applications**: climate change, shallow lakes

Lemoine, Derek and Ivan Rudik (2017) “Steering the climate system: using inertia to lower the cost of policy,” American Economic Review, Vol. 107, No. 10, pp. 2947–57.

Maler, Karl Goran, Anastasios Xepapadeas, and Aart De Zeeuw (2003) “The Economics of Shallow Lakes,” Environmental and Resource Economics, Vol. 26, No. 4, pp. 603–624.

### March 25: Efficient methods for expectations in high dimensions

**Theory**: monte carlo, markov chain monte carlo, hamiltonian monte carlo

Betancourt, Michael (2017) “A conceptual introduction to Hamiltonian Monte Carlo,” arXiv preprint arXiv:1701.02434.

Chib, Siddhartha and Edward Greenberg (1995) “Understanding the Metropolis-Hastings Algorithm,” The American Statistician, Vol. 49, No. 4, pp. 327–335.

Chib, Siddhartha and Edward Greenberg (1996) “Markov Chain Monte Carlo Simulation Methods in Econometrics,” Econometric Theory, Vol. 12, No. 3, pp. 409–431.

**Applications**: uncertainty shocks

Orlik, Anna and Laura Veldkamp (2014) “Understanding uncertainty shocks and the role of the black swan.”

### April 8: Regularization and prediction

**Theory**: lasso, elastic net, crossvalidation, unsupervised learning

[Friedman, Jerome, Trevor Hastie, and Robert Tibshirani (2001) The elements of statistical learning, Vol. 1: Springer series in statistics New York. Chapters 3, 4 and 7.](https://web.stanford.edu/~hastie/ElemStatLearn/)

**Applications**: LASSO counterfactual, 

Burlig, Fiona, Christopher Knittel, David Rapson, Mar Reguant, and Catherine Wolfram (2017) Machine learning from schools about energy efficiency. No. w23908. National Bureau of Economic Research.

### April 15: Regularization and prediction

**Theory**: trees, bagging and boosting, neural networks

[Friedman, Jerome, Trevor Hastie, and Robert Tibshirani (2001) The elements of statistical learning, Vol. 1: Springer series in statistics New York. Chapters 8, 9, 10, and 15.](https://web.stanford.edu/~hastie/ElemStatLearn/)

### April 22: Cloud computing

**Applications**: google compute engine, amazon elastic compute cloud

### April 29: Final project presentations
