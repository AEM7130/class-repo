# Problem 1

using QuantEcon # for integration routine
using Distributions 

function profit_max_q(a, c, mu, sigma, method="mc", n)
    b = LogNormal(mu, sigma)

    # define functions
    P(q) = a - b*q  
    C(q) = c*q
    Π(q) = P(q)*q - C(q) 

    # 


end


# Problem 2
# First define a funciton that check the distance of points to 
# the "center" of the square_points

function distance_to_center(point)
    distance = sqrt((point[1] - 0.5)^2 + (point[2] - 0.5)^2)
    return distance
end


function estimate_pi(n)
    square_points = [rand(2) for i in 1:n]
    
    # return the distances from the points to the center 
    distances = distance_to_center.(square_points)

    # count number of points inside the circle
    inside_ratio = count(i->(i <= 0.5), distances) / n

    # return pi
    pi = inside_ratio / (0.5^2)
    return pi
end

estimate_pi(1000000)

