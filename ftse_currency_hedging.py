# -*- coding: utf-8 -*-
"""
Created on Tue Oct 04 14:42:54 2016

@author: Zhou Qiao
"""


import numpy as np
import pandas as pd

in_dir =" C:\\dev\\quant_research\\data\\"
in_file = "Ps2Data.xls"
df = pd.read_excel(in_file,sheetname="Sheet1",header = 0, index_col=0,skiprows=2)
df = df.iloc[:,0:3]
# Columns: 
# FTSE_100:Index in £	
# Spot_Rates: $/£	
# Forward_Rates: 1 month, $/£
df.columns = ["FTSE_100","Spot_Rates","Forward_Rates"]


#initial welath in dollar
W = 1000000;

df["Ret_Unhedged"] = df["FTSE_100"]*df["Spot_Rates"]/df["FTSE_100"].shift(1)/df["Spot_Rates"].shift(1)-1
df["Ret_Hedged"] = df["Ret_Unhedged"] + (df["Forward_Rates"].shift(1) - df["Spot_Rates"])/df["Spot_Rates"].shift(1)
df.dropna(axis=0,inplace=True)

df_summary = pd.DataFrame(index = ["Unhedged","Hedged"])
df_summary["Monthly_Ret"] = [np.mean(df["Ret_Unhedged"]),np.mean(df["Ret_Hedged"])]
df_summary["Monthly_Std"]= [np.std(df["Ret_Unhedged"]),np.std(df["Ret_Hedged"])]
df_summary["Annual_Ret"] = (1+df_summary["Monthly_Ret"]) ** 12 - 1
df_summary["Annual_Std"] = df_summary["Monthly_Std"] * np.sqrt(12)
df_summary["Sharpe"] = df_summary["Annual_Ret"]/df_summary["Annual_Std"]


(W * (1+df[["Ret_Unhedged","Ret_Hedged"]]).cumprod()).plot(figsize=(8,5))
