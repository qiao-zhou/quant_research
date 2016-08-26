# -*- coding: utf-8 -*-
"""
Created on Sat Aug 27 04:32:31 2016

@author: Zhou Qiao
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np 
import scipy.optimize as spo

#error function 
def error(line, data):
    """
    line: a tuple (c0,c1)
    data: 2D array where each row is (x,y)
    Returns the error (Sum of squard errors) as a single real value.
    """
    c0 = line[0]
    c1 = line[1]
    y = data[:,1]
    yhat = (c0*data[:,0] + c1)
    sse = np.sum((y -yhat)**2 )
    return sse
    
def fit_line(data, error_func):
    """
    Fit a line to a given data, using a supplied error function 
    
    Returns a line that minimizes the error function.
    """
    #Generate initial guess for the line model 
    l = np.float32((0,np.mean(data[:,1])))#slope=0, intercept as the mean of y
    
    # plot the initial guess (optional)
    #x_ends = np.float32([-5,5])
    #plt.plot(x_ends,l[0]*x_ends + l[1],"m--", linewidth=2.0, label="Initial Guess")
    
    # Call optimizer to minimize the error function 
    result = spo.minimize(error_func, l,args=(data,), method="SLSQP",options = {"disp":True})
    return result.x
    
def test_run():
    #Define the original line 
    l_orig = np.float32([4,2])
    X_orig = np.linspace(0,10,21)
    Y_orig = l_orig[0] * X_orig + l_orig[1]
    plt.plot(X_orig,Y_orig,"b--",linewidth = 2.0,label="Original Line")
    
    #Generate noisy data points
    noise_sigma = 3.0
    noise = np.random.normal(0,noise_sigma,Y_orig.shape)
    data = np.asarray([X_orig,Y_orig + noise]).T
    plt.plot(data[:,0],data[:,1],"ko",linewidth = 2.0,label="Data Points")
    
    # Try to fit a line to this data 
    l_fit = fit_line(data,error)
    plt.plot(data[:,0],data[:,0] * l_fit[0] + l_fit[1],"r--",linewidth = 2.0,label="Fitted Line")
    
    
    
    
    
    
    
    
    