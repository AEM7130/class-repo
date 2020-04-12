# AEM 7130 Syllabus
**Time**: Wednesday 4:30-7:00

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
- Presentation of a numerical paper: 15%
- Final project: 35%
- Problem sets: 40%

## Important dates

- [Final project proposals due: March 13](https://rawcdn.githack.com/AEM7130/spring-2020/d000f13df86fd714351820c2af9a511a32404395/final_project/project_proposal.html)
- Final project due: May 7

## Assignments

### Problem sets
There will be four problem sets. You must submit your code on [GitHub](https://github.com). We will learn how to use Git during class and will be using GitHub Classroom for submissions. You may work in a group of **three or fewer people**. Each group should turn in one assignment with all members' names at the top of the file. Your grade will be a function of how well your answer the questions, and how reproducible you make your code for a peer code reviewer.

In addition to submitting problem sets you will be required to do a reproduction exercise on your classmates' code. You will be randomly assigned to another classmate's submitted problem set and tasked with seeing whether it reproduces and offer suggestions for reproducibility.

- [Problem set 1](https://github.com/AEM7130/spring-2020/blob/master/problem_sets/1_ps/1_ps.ipynb): Due Feb 17
- [Problem set 2](https://github.com/AEM7130/spring-2020/blob/master/problem_sets/2_ps/2_ps.ipynb): Due March 1
- [Problem set 3](https://github.com/AEM7130/spring-2020/blob/master/problem_sets/3_ps/3_ps.ipynb): Due March 22
- [Problem set 4](https://github.com/AEM7130/spring-2020/blob/master/problem_sets/4_ps/4_ps.ipynb): Due May 1

### Final project ([proposal link here (no longer required)](https://rawcdn.githack.com/AEM7130/spring-2020/d000f13df86fd714351820c2af9a511a32404395/final_project/project_proposal.html))

There is a final project for the course, due at the end of the semester. For the project you may either write a paper of up to 7 pages, or record a presentation of up to 20 minutes. You may select one of two options:

1. Begin a new computationally-driven research project. The project should
    1. Have an introduction that clearly states the economic question you are answering, frames your research in the context of the existing literature, and tells the reader what you are doing to advance economic knowledge.
    2. Analytically develop the model, provide proofs for theoretical results if there are any.
    3. Describe how you solve or estimate the model.
    4. If possible, have preliminary results.
2. Expand an existing paper by bringing in machine learning techniques, advanced numerical techniques, or a remotely sensed geospatial dataset. This can be your own paper (e.g. your current second year paper in progress), or an existing published paper where reproduction data and code are available online. The paper should
    1. Briefly summarize the existing paper.
    2. Describe the new techniques or data your are bringing to the table in detail.
    3. Have preliminary results.
    4. If using alternative techniques, compare outcomes or performance against the original methodology in the paper.


### [Computational paper presentations](https://rawcdn.githack.com/AEM7130/spring-2020/fb175a76affc956dd0cf1fe681dc1dc0c979eb71/paper_presentation/paper_presentation.html)
Starting near the middle of the course, one student a week will present either a paper that either applies methods we have learned in a previous week, or extends methods we have previously learned. You may present the paper in class or record a video and submit it on Canvas.

## Course Schedule

### [January 22: Intro to computing](https://rawcdn.githack.com/AEM7130/spring-2020/623a189abe90d1ec9fcd81644852d4123ceb1bd1/lecture_notes/lecture_1/1_intro_to_computing.html)

**Theory**: floats, ints, read/write, memory, truncation, rounding, error propagation, matrix inversion, differentiation, integration

Judd (1998, Chapters 2, 3 and 7)

Miranda and Fackler (2002, Chapters 1, 2, and 5)

### January 29: [Coding, reproducibility, and the shell](https://rawcdn.githack.com/AEM7130/spring-2020/8a2fbf6e67e90bc64f4abd23800c7d46fa512240/lecture_notes/lecture_2/2a_coding.html)

**Applications**: shell scripts, generic coding, reproducible coding, speed in julia, workflow

[Software Carpentry: The Unix Shell](https://swcarpentry.github.io/shell-novice/)

[AEA Reproducibility Guidance](https://aeadataeditor.github.io/aea-de-guidance/)

[Learning Julia](https://julialang.org/learning/)

[QuantEcon Lectures](https://quantecon.org/)

### February 5: [Version control](https://rawcdn.githack.com/AEM7130/spring-2020/93def05f54a61f2d5c871ec48503d39e5a4ae293/lecture_notes/lecture_3/3_git.html)

**Applications**: git, github, issues, pull requests

[Software Carpentry: Version Control with Git](https://swcarpentry.github.io/git-novice/)

[SEERE Lab wiki](https://github.com/cornell-seere/lab-information/wiki)

### February 12: [Rootfinding and optimization](https://rawcdn.githack.com/AEM7130/spring-2020/cd4786fa16d1820620fc6d1d3f86c7e8aa41167b/lecture_notes/lecture_4/4_optimization.html)

**Theory**: iterative methods, newton methods, gaussian methods, global solvers

Judd (1998, Chapter 4 and 5)

Miranda and Fackler (2002, Chapters 3 and 4)

Nocedal and Wright (2006, Chapters 2-6)

### February 19: [Discrete time dynamic programming](https://rawcdn.githack.com/AEM7130/spring-2020/3fceafa72b63d046aad7d456b694cb45f8ea1ab4/lecture_notes/lecture_5/5_dynamics.html)

**Theory**: markov chains, principle of optimality

Adda, Jerome and Russell W Cooper (2003) Dynamic Economics: Quantitative Methods and Applications: MIT press.

Ljungqvist, Lars and Thomas J Sargent (2004) Recursive Macroeconomic Theory: MIT press.

### February 26: [Function approximation](https://rawcdn.githack.com/AEM7130/spring-2020/c4d0cfecbe312575ef356857a0bd63722d36e506/lecture_notes/lecture_6/6_projection.html)

**Theory**: discretization, pseudospectral methods, finite element methods

Fernandez-Villaverde, Jesus, Juan Francisco Rubio-Ramirez, and Frank Schorfheide (2016) “Solution and estimation methods for DSGE models,” Handbook of Macroeconomics, Vol. 2, pp. 527–724.

### April 8, 15: [Solving discrete time dynamic models](https://rawcdn.githack.com/AEM7130/spring-2020/e84319aafa0ccf0b882dd802973d1cd494fb2af5/lecture_notes/lecture_7/7_solution_methods.html)

**Theory**: value function iteration, policy iteration, time iteration, VFI + discretization

Aruoba, S Boragan, Jesus Fernandez-Villaverde, and Juan F Rubio-Ramirez (2006) “Comparing solution methods for dynamic equilibrium economies,” Journal of Economic Dynamics and Control, Vol. 30, No. 12, pp. 2477–2508.

Cai, Yongyang and Kenneth L Judd (2014) Advances in Numerical Dynamic Programming and New Applications, Vol. 3: Elsevier B.V. pp.479–516.

Fernandez-Villaverde, Jesus, Juan Francisco Rubio-Ramirez, and Frank Schorfheide (2016) “Solution and estimation methods for DSGE models,” Handbook of Macroeconomics, Vol. 2, pp. 527–724.

**Applications**: climate change, bioeconomics, 

Lemoine, Derek and Christian Traeger (2014) “Watch Your Step: Optimal policy in a tipping climate,” American Economic Journal: Economic Policy, Vol. 6, No. 1.

Springborn, Michael and James N. Sanchirico (2013) “A density projection approach for non-trivial information dynamics: Adaptive management of stochastic natural resources,” Journal of Environmental Economics and Management, Vol. 66, No. 3, pp. 609–624.

### April 22: [Continuous time optimal control](https://rawcdn.githack.com/AEM7130/spring-2020/a3e23dae6d910b41729a05358685e2265a6d5409/lecture_notes/lecture_8/8_optimal_control.html)

**Theory**: maximum principle, hamiltonians, shooting, backwards shooting

Caputo, Michael Ralph (2005) Foundations of dynamic economic analysis: optimal control theory and applications: Cambridge University Press.

Brunner, Martin and Holger Strulik (2002) “Solution of perfect foresight saddlepoint problems: A simple method and applications,” Journal of Economic Dynamics and Control, Vol. 26, No. 5, pp. 737–753.

Judd (1998, Chapter 10)

Trimborn, Timo, Karl-Josef Koch, and Thomas M. Steger (2008) “Multidimensional Transitional Dynamics: a Simple Numerical Procedure,” Macroeconomic Dynamics, Vol. 12, No. 03, pp. 301– 319.

**Applications**: oil extraction, climate change, shallow lakes

Lemoine, Derek and Ivan Rudik (2017) “Steering the climate system: using inertia to lower the cost of policy,” American Economic Review, Vol. 107, No. 10, pp. 2947–57.

Maler, Karl Goran, Anastasios Xepapadeas, and Aart De Zeeuw (2003) “The Economics of Shallow Lakes,” Environmental and Resource Economics, Vol. 26, No. 4, pp. 603–624.

Anderson, Soren T, Ryan Kellogg, and Stephen W Salant (2018) “Hotelling under pressure,” Journal of Political Economy, Vol. 126, No. 3, pp. 984–1026.

### April 29: [Advanced methods for discrete time models](https://rawcdn.githack.com/AEM7130/spring-2020/2bc4cf4b4329fad81bc1d9408c951877af1dfb70/lecture_notes/lecture_9/9_advanced_methods.html)

**Theory**: regression, endogenous grids, envelope condition method, modified policy iteration

Carroll, Christopher D. (2006) “The method of endogenous gridpoints for solving dynamic stochastic optimization problems,” Economics Letters, Vol. 91, No. 3, pp. 312–320.

Maliar, Lilia and Serguei Maliar (2014) Numerical Methods for Large-Scale Dynamic Economic
Models, Vol. 3: Elsevier B.V. pp.325–477.

Puterman, Martin L. and Moon Chirl Shin (1978) “Modified Policy Iteration Algorithms for Dis- counted Markov Decision Problems,” Management Science, Vol. 24, No. 11, pp. pp. 1127–1137.


### May 6: [Machine learning](https://rawcdn.githack.com/AEM7130/spring-2020/c9b3ba72b1d4472a3f4dccce04d22d61eaf49ea7/lecture_notes/lecture_10/10_machine_learning.html)

**Theory**: linear models, non-parametric models, regularization, cross-validation, boosting, bagging

[Friedman, Jerome, Trevor Hastie, and Robert Tibshirani (2001) The elements of statistical learning, Vol. 1: Springer series in statistics New York. Chapters 8, 9, 10, and 15.](https://web.stanford.edu/~hastie/ElemStatLearn/)

Athey, Susan, and Guido Imbens (2016) "Recursive partitioning for heterogeneous causal effects." Proceedings of the National Academy of Sciences 113, no. 27, pp. 7353-7360.

[Mullainathan, Sendhil, and Jann Spiess (2017) "Machine learning: an applied econometric approach." Journal of Economic Perspectives 31, No. 2, 87-106.](https://pubs.aeaweb.org/doi/pdfplus/10.1257/jep.31.2.87)

[Athey, S., & Imbens, G. W. (2019) Machine Learning Methods Economists Should Know About.](https://www.gsb.stanford.edu/gsb-cmis/gsb-cmis-download-auth/476281)

**Applications**: LASSO for counterfactuals, causal trees for heterogeneous treatment effects

Burlig, Fiona, Christopher Knittel, David Rapson, Mar Reguant, and Catherine Wolfram (2017) "Machine learning from schools about energy efficiency." No. w23908. National Bureau of Economic Research.

Prest, Brian (2020) "Peaking interest: How awareness drives the effectiveness of time-of-use electricity pricing." Journal of the Association of Environmental and Resource Economists 7, no. 1, pp. 103-143.
