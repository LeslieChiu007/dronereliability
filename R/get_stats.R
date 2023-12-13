#' @name get_stats
#' @title GET STATS AND PLOT
#' @author Hengtao Zhao & Andres Garcia
#' @param mot1_MTTF This is the mean time to failure for the motors used in the original drone (control group).
#' @param mot2_MTTF This is the mean time to failure for the motors in the new system that we are observing.
#' @param prop1_MTTF This is the mean time to failure for the propellers used in the original drone (control group).
#' @param prop2_MTTF This is the mean time to failure for the propellers used in the new system that we are observing.
#' @param bat1_t This is the average lifetime of one cycle of the battery system in the control group.
#' @param bat1_lc This is the expected cycles until failure for the battery system in the control group.
#' @param bat2_t This is the average lifetime of one cycle of the battery system in the new system we observe.
#' @param bat2_lc This is the expected cycles until failure for the battery system in the new system that we are observing.
#' @param lambda_gc The failure rate for the Ground Control System of a commercial drone.
#' @param lambda_main The failure rate for the Mainframe System of a commercial drone.
#' @param lambda_nav The failure rate for the Navigation System of a commercial drone.
#' @param lambda_es The failure rate for the Electrical System of a commercial drone.
#' @param lambda_pay The failure rate for the Payload System of a commercial drone.
#' @description
#' 
#' This function will calculate the reliability of a commercial drone system.
#' It splits a commercial drone into six different systems: Ground Control,
#' Mainframe, Power System, Payload, Electronics System, and Navigation Systems.
#' We further broke down the Power System into 3 main components, the battery,
#' motors, and propellers. The failure rates for the 6 systems were derived from
#' literary research and the mean time to failure of the batteries, motors, and
#' propellers were found by using the most common commercial options.
#'
#' The MTTF for the original motor and propellers (mot1 and mot2) are the lower ends
#' of the ranges that we found online for drone motors and propellers. The MTTF for
#' the improved motors and propellers, (mot2 and prop2) are the higher ends of the 
#' ranges that we found online. Using these values, we are comparing the reliability
#' as a result of using higher quality components. In this function you are free to
#' enter your own MTTF for intitial and final motor/battery components and observe
#' how this affects a drone's reliability.
#'
#' For the batteries, our initial battery component (bat1) is a lithium ion battery
#' system. We found its MTTF by multiplying the average lifetime of one cycle (bat1_t)
#' by the expected cycles until failure for the system. For our second battery system,
#' we used NiMH batteries as they were observed to be more reliable. We used th same approach
#' as above with the average lifetime and expected cycles to find it's MTTF. You are free to
#' input any values to compare the effects that battery systems have in the reliabiliy of commercial
#' drones.
#' 
#' The failure rates (lambda) for the remaining 5 components were identified through
#' literary research and their values set as the default. Once again, you can input different
#' values in order to see how these components affect the reliability of a commercial drone system.
#' 
#' The function uses these inputs to find the reliability of each component, and then
#' uses these values to run a binomial simulation at each time interval. The function
#' then finds the average, standard deviation, and standard error at each interval. It then plots
#' the average values as well as an upper and lower bound with a 95% confidence interval. The four
#' plots are the reliability of the original system, using a new motor, using a new battery system,
#' using a new propeller, and using a new motor, battery, and propeller at the same time.
#' 
#' It then outputs the estimated reliability for each observed scenario at 1 year.
#' 
#' 
#' @export

get_stats = function(mot1_MTTF = 8000, mot2_MTTF = 12000, prop1_MTTF = 300, 
                             prop2_MTTF=500, bat1_t = 800, bat1_lc = 400,
                             bat2_t=1090, bat2_lc=1000,
                             lambda_gc = 2.00*10^-6, lambda_main = 2.77*10^-6,
                             lambda_nav = 9.41*10^-6, lambda_es = 5.01*10^-6,
                             lambda_pay = 1.10*10^-6){
  
  # Load packages
  library(dplyr)
  library(ggplot2)

  # Failure rate for the a drone's ground control, this value was found
  # through literary research
  #lambda_gc = 2.00 * 10^-6
  
  # Failure rate for the a drone's mainframe, this value was found
  # through literary research
  #lambda_main = 2.77 * 10^-6
  
  # Failure rate for the a drone's navigation system, this value was found
  # through literary research
  #lambda_nav = 9.41 * 10^-6
  
  # Failure rate for the a drone's electronic system, this value was found
  # through literary research
  #lambda_es = 5.01 * 10^-6
  
  # Failure rate for the a drone's payload, this value was found
  # through literary research
  #lambda_pay = 1.10 * 10^-6
  
  # Failure rate for the a drone's power plant, this value was found
  # through literary research, however we are using other values to calculate
  # this
  #lambda_pwr = 9.94 * 10^-6
  
  # Failure rate for the motor. The Mean Time To Failure was found through 
  # researching different drones. The failure rate is the inverse of the 
  # Mean Time To Failure
  lambda_mot = 1/mot1_MTTF 
  
  # Failure rate for the new propeller. This is derived by taking the
  # inverse of the Mean Time To Failure that was inputted to this function
  lambda_mot2= 1/mot2_MTTF
  
  # Failure rate for the propeller. The Mean Time To Failure was
  # found through researching different drones. The failure rate is the 
  # inverse of the Mean Time To Failure
  lambda_prop = 1/prop1_MTTF
  
  # Failure rate for the new propeller. This is derived by taking the
  # inverse of the Mean Time To Failure that was inputted to this function
  lambda_prop2 = 1/prop2_MTTF
  
  # Failure rate for a lithium ion battery. The Mean Time To Failure was
  # derived by multiplying the average life of one cycle by the expected
  # life cycles of the battery system. the failure rate is the inverse of
  # the Mean Time To Failure
  lambda_bat = 1/(bat1_t*bat1_lc)
  
  # Failure rate for the new battery system. This is derived by taking the
  # inverse of the Mean Time To Failure that was inputted to this function
  lambda_bat2 = 1/(bat2_t*bat2_lc)
  
  # Failure Rate for controls, this is derived by working backwards from the
  # original power plant failure rate. Since we assume that components are
  # independent, this stays constant even when we use the updated components
  #ambda_cnt = lambda_pwr - (lambda_bat + (lambda_mot+lambda_prop)^2)
  
  # Creates a data frame for the reliability of each component at 6 intervals
  myingredients = tibble(
    t = seq(from = 0, to = 1000, by = 50),
    prob_gc = 1-pexp(t, rate = lambda_gc),
    prob_main = 1-pexp(t, rate = lambda_main),
    prob_bat = pexp(t, rate = lambda_bat),
    prob_mot = pexp(t, rate = lambda_mot),
    prob_prop = pexp(t, rate = lambda_prop),
    prob_nav = 1-pexp(t, rate = lambda_nav),
    prob_es = 1-pexp(t, rate = lambda_es),
    prob_pay = 1-pexp(t, rate = lambda_pay),
    prob_mot2 = pexp(t, rate = lambda_mot2),
    prob_prop2 = pexp(t, rate = lambda_prop2),
    prob_bat2 = pexp(t, rate = lambda_bat2),
    prob_pwr = 1-(prob_bat + (prob_mot + prob_prop)^2),
    prob_pwr_newm = 1-(prob_bat + (prob_mot2 + prob_prop)^2),
    prob_pwr_newb = 1-(prob_bat2 + (prob_mot + prob_prop)^2),
    prob_pwr_newp = 1-(prob_bat + (prob_mot + prob_prop2)^2),
    prob_pwr_newe = 1-(prob_bat2 + (prob_mot2 + prob_prop2)^2),
    
    # In order to fix any potential errors in our breakdown of the power system,
    # we will 
    prob_pwr_fixed = ifelse(prob_pwr < 0, 0, prob_pwr),
    prob_pwrm_fixed = ifelse(prob_pwr_newm < 0, 0, prob_pwr_newm),
    prob_pwrb_fixed = ifelse(prob_pwr_newb < 0, 0, prob_pwr_newb),
    prob_pwrp_fixed = ifelse(prob_pwr_newp < 0, 0, prob_pwr_newp),
    prob_pwre_fixed = ifelse(prob_pwr_newe < 0, 0, prob_pwr_newe)
  )
  
  # Using the reliability calculated in myingredients, a binomial simulation
  # is run 1000 times at each time interval. This allows us to collect more
  # data using the expected probability and we can then find the average, 
  # standard deviation, and standard error. With the standard error we are able
  # to find confidence intervals which tell us whether there is a statistical
  # significance in our results.
  prob1 = myingredients %>%
    group_by(t) %>% # organizes the data frame
    reframe(
      n = 1000, #number of simulations
      reps = 1:n, 
      gc = rbinom(n = n, size = 1, prob = prob_gc),
      main = rbinom(n = n, size = 1, prob = prob_main),
      pay = rbinom(n = n, size = 1, prob = prob_pay),
      nav = rbinom(n = n, size = 1, prob = prob_nav),
      es = rbinom(n = n, size = 1, prob = prob_es),
      mot = rbinom(n = n, size = 1, prob = prob_mot),
      prop = rbinom(n = n, size = 1, prob = prob_prop),
      bat = rbinom(n = n, size = 1, prob = prob_bat),
      pwr = rbinom(n = n, size = 1, prob = prob_pwr_fixed),
      mot2 = rbinom(n = n, size = 1, prob = prob_mot2),
      prop2 = rbinom(n = n, size = 1, prob = prob_prop2),
      bat2 = rbinom(n = n, size = 1, prob = prob_bat2),
      
      pwr_newe = rbinom(n = n, size = 1, prob = prob_pwre_fixed),
      pwr_newm = rbinom(n = n, size = 1, prob = prob_pwrm_fixed),
      pwr_newb = rbinom(n = n, size = 1, prob = prob_pwrb_fixed),
      pwr_newp = rbinom(n = n, size = 1, prob = prob_pwrp_fixed),
      
      # Calculates 
      prob_T0 = gc*main*pwr*nav*es*pay,
      prob_T1 = gc*main*pwr_newm*nav*es*pay,
      prob_T2 = gc*main*pwr_newb*nav*es*pay,
      prob_T3 = gc*main*pwr_newp*nav*es*pay,
      prob_T4 = gc*main*pwr_newe*nav*es*pay
    ) 
  
  
  prob2 <- prob1 %>% #Main plot
    group_by(t) %>%
    summarize(
      # Mean and Standard Deviation for the Reliability of each 
      # system being tested
      mean0 = mean(prob_T0),
      sd0 = sd(prob_T0),
      
      mean1 = mean(prob_T1),
      sd1 = sd(prob_T1),
      
      mean2 = mean(prob_T2),
      sd2 = sd(prob_T2),
      
      mean3 = mean(prob_T3),
      sd3 = sd(prob_T3),
      
      mean4 = mean(prob_T4),
      sd4 = sd(prob_T4),
      
      # Number of simulations at each time period
      n = n(),
      
      # Standard error for each system being analyzed
      se0 = sd0/sqrt(n),
      se1 = sd1/sqrt(n),
      se2 = sd2/sqrt(n),
      se3 = sd3/sqrt(n),
      se4 = sd4/sqrt(n),
      
      # Approximated lower and upper 95% confidence intervals for each system
      lower_approx0 = mean0 + qnorm(0.025) * se0,
      upper_approx0 = mean0 + qnorm(0.975) * se0,
      
      lower_approx1 = mean1 + qnorm(0.025) * se1,
      upper_approx1 = mean1 + qnorm(0.975) * se1,
      
      lower_approx2 = mean2 + qnorm(0.025) * se2,
      upper_approx2 = mean2 + qnorm(0.975) * se2,
      
      lower_approx3 = mean3 + qnorm(0.025) * se3,
      upper_approx3 = mean3 + qnorm(0.975) * se3,
      
      lower_approx4 = mean4 + qnorm(0.025) * se4,
      upper_approx4 = mean4 + qnorm(0.975) * se4)
  
  
  # Plots the reliability for each system. The meean is plotted as a black line
  # and the 95% confidence interval is plotted as a ribbon
  plot1 = ggplot() +
    geom_line(data = prob2, mapping = aes(x = t, y = mean0)) +
    geom_line(data = prob2, mapping = aes(x = t, y = mean1)) +
    geom_line(data = prob2, mapping = aes(x = t, y = mean2)) +
    geom_line(data = prob2, mapping = aes(x = t, y = mean3)) +
    geom_line(data = prob2, mapping = aes(x = t, y = mean4)) +
    
    geom_ribbon(data = prob2, mapping = aes(x = t, ymin = lower_approx0, ymax = upper_approx0, fill = "Original"), alpha = 0.8) +
    geom_ribbon(data = prob2, mapping = aes(x = t, ymin = lower_approx1, ymax = upper_approx1, fill = "New Motor"), alpha = 0.8) +
    geom_ribbon(data = prob2, mapping = aes(x = t, ymin = lower_approx2, ymax = upper_approx2, fill = "New Battery"), alpha = 0.8) +
    geom_ribbon(data = prob2, mapping = aes(x = t, ymin = lower_approx3, ymax = upper_approx3, fill = "New Propeller"), alpha = 0.8) +
    geom_ribbon(data = prob2, mapping = aes(x = t, ymin = lower_approx4, ymax = upper_approx4, fill = "New Everything"), alpha = 0.8) +
    
    theme_classic(base_size = 14) +
    labs(x = "Time (Hours)", y = "Reliability (%)",
         title = "System Reliability of Commercial Drones for 1 year") + 
    theme_minimal()
  plot1
  # Finds the reliability for each improved system and converts it into a percentage
  new_m = prob2[21,4] * 100
  new_p = prob2[21,8] * 100
  new_b = prob2[21,6] * 100
  new_e = prob2[21,10]* 100
  
  nm_lb = round(prob2[21,19],3)    
  nm_ub = round(prob2[21,20],3)  
  nb_lb = round(prob2[21,21],3)
  nb_ub = round(prob2[21,22],3)  
  np_lb = round(prob2[21,23],3) 
  np_ub = round(prob2[21,24],3)  
  ne_lb = round(prob2[21,25],3)  
  ne_ub = round(prob2[21,26],3)  
  
  tab = tibble(
    id = 1:4,
    statement = c(
      paste0("The expected reliability at 1 year for a drone with a new motor is ", new_m, "%, with an expected range of ", nm_lb," to ",nm_ub," (95% CI)"),
      paste0("The expected reliability at 1 year for a drone with a new propeller is ", new_p, "%, with an expected range of ", np_lb," to ",np_ub," (95% CI)"),
      paste0("The expected reliability at 1 year for a drone with a new battery is ", new_b, "%, with an expected range of ", nb_lb," to ",nb_ub," (95% CI)"),
      paste0("The expected reliability at 1 year for a drone with a new motor, propeller, and battery is ", new_e, "%, with an expected range of ", ne_lb," to ",ne_ub," (95% CI)")
    )
  )  
  
  output = list(plot = plot1,
                tab = tab)
  
  return(output)
  
}


# d = drone_reliability(mot1_MTTF = 8000, mot2_MTTF = 12000, prop1_MTTF = 300, 
#                       prop2_MTTF=500, bat1_t = 800, bat1_lc = 400,
#                       bat2_t=1090, bat2_lc=1000,
#                       lambda_gc = 2.00*10^-6, lambda_main = 2.77*10^-6,
#                       lambda_nav = 9.41*10^-6, lambda_es = 5.01*10^-6,
#                       lambda_pay = 1.10*10^-6)
# d$plot
# d$tab

