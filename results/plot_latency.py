import pandas as pd
import json
import matplotlib.pyplot as plt
import matplotlib 
import numpy as np
import statistics as stats

baseline_get_IBFT = json.load(open("processed-results/baseline-get-IBFT.json"))
baseline_set_IBFT = json.load(open("processed-results/baseline-set-IBFT.json"))
request_IBFT = json.load(open("processed-results/request-IBFT.json"))
verify_IBFT = json.load(open("processed-results/verify-IBFT.json"))

baseline_get_QBFT = json.load(open("processed-results/baseline-get-QBFT.json"))
baseline_set_QBFT = json.load(open("processed-results/baseline-set-QBFT.json"))
request_QBFT = json.load(open("processed-results/request-QBFT.json"))
verify_QBFT = json.load(open("processed-results/verify-QBFT.json"))

baseline_get_RAFT = json.load(open("processed-results/baseline-get-RAFT.json"))
baseline_set_RAFT = json.load(open("processed-results/baseline-set-RAFT.json"))
request_RAFT = json.load(open("processed-results/request-RAFT.json"))
verify_RAFT = json.load(open("processed-results/verify-RAFT.json"))

baseline_get_IBFT_latency = []
baseline_set_IBFT_latency = []
verify_IBFT_latency = []
request_IBFT_latency = []

baseline_get_QBFT_latency = []
baseline_set_QBFT_latency = []
verify_QBFT_latency = []
request_QBFT_latency = []

baseline_get_RAFT_latency = []
baseline_set_RAFT_latency = []
verify_RAFT_latency = []
request_RAFT_latency = []
size_tmp = 0

## IBFT, QBFT and RAFT
for i in range(1,12):
    i = str(i)
    for value in baseline_get_IBFT[i]["latency"]:
        baseline_get_IBFT_latency.append(value)
    for value in baseline_get_QBFT[i]["latency"]:
        baseline_get_QBFT_latency.append(value)
    for value in baseline_get_RAFT[i]["latency"]:
        baseline_get_RAFT_latency.append(value)

for i in range(1,12):
    i = str(i)
    for value in baseline_set_IBFT[i]["latency"]:
        baseline_set_IBFT_latency.append(value)
    for value in baseline_set_QBFT[i]["latency"]:
        baseline_set_QBFT_latency.append(value)
    for value in baseline_set_RAFT[i]["latency"]:
        baseline_set_RAFT_latency.append(value)

for i in range(1,12):
    i = str(i)
    for value in verify_IBFT[i]["latency"]:
        verify_IBFT_latency.append(value)
    for value in verify_QBFT[i]["latency"]:
        verify_QBFT_latency.append(value)
    for value in verify_RAFT[i]["latency"]:
        verify_RAFT_latency.append(value)

for i in range(1,12):
    i = str(i)
    for value in request_IBFT[i]["latency"]:
        request_IBFT_latency.append(value)        
    for value in request_QBFT[i]["latency"]:
        request_QBFT_latency.append(value)        
    for value in request_RAFT[i]["latency"]:
        request_RAFT_latency.append(value)        


print("\n\nBaseline | SET")
print(stats.mean(baseline_set_IBFT_latency))
print(stats.stdev(baseline_set_IBFT_latency))

print(stats.mean(baseline_set_QBFT_latency))
print(stats.stdev(baseline_set_QBFT_latency))

print(stats.mean(baseline_set_RAFT_latency))
print(stats.stdev(baseline_set_RAFT_latency))

print("\n\nBaseline | GET")
print(stats.mean(baseline_get_IBFT_latency))
print(stats.stdev(baseline_get_IBFT_latency))

print(stats.mean(baseline_get_QBFT_latency))
print(stats.stdev(baseline_get_QBFT_latency))

print(stats.mean(baseline_get_RAFT_latency))
print(stats.stdev(baseline_get_RAFT_latency))

print("\n\nVerifyAccess")
print(stats.mean(verify_IBFT_latency))
print(stats.stdev(verify_IBFT_latency))

print(stats.mean(verify_QBFT_latency))
print(stats.stdev(verify_QBFT_latency))

print(stats.mean(verify_RAFT_latency))
print(stats.stdev(verify_RAFT_latency))

print("\n\nRequestAccess")
print(stats.mean(request_IBFT_latency))
print(stats.stdev(request_IBFT_latency))

print(stats.mean(request_QBFT_latency))
print(stats.stdev(request_QBFT_latency))

print(stats.mean(request_RAFT_latency))
print(stats.stdev(request_RAFT_latency))