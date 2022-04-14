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

baseline_get_IBFT_block_gas = []
baseline_set_IBFT_block_gas = []
verify_IBFT_block_gas = []
request_IBFT_block_gas = []

baseline_get_QBFT_block_gas = []
baseline_set_QBFT_block_gas = []
verify_QBFT_block_gas = []
request_QBFT_block_gas = []

baseline_get_RAFT_block_gas = []
baseline_set_RAFT_block_gas = []
verify_RAFT_block_gas = []
request_RAFT_block_gas = []
size_tmp = 0

## IBFT, QBFT and RAFT
for i in range(1,12):
    i = str(i)
    for key in baseline_get_IBFT[i]["blocks"].keys():
        baseline_get_IBFT_block_gas.append(baseline_get_IBFT[i]["blocks"][key]["gasUsed"])
    for key in baseline_get_QBFT[i]["blocks"].keys():
        baseline_get_QBFT_block_gas.append(baseline_get_QBFT[i]["blocks"][key]["gasUsed"])
    for key in baseline_get_RAFT[i]["blocks"].keys():
        baseline_get_RAFT_block_gas.append(baseline_get_RAFT[i]["blocks"][key]["gasUsed"])

for i in range(1,12):
    i = str(i)
    for key in baseline_set_IBFT[i]["blocks"].keys():
        baseline_set_IBFT_block_gas.append(baseline_set_IBFT[i]["blocks"][key]["gasUsed"])
    for key in baseline_set_QBFT[i]["blocks"].keys():
        baseline_set_QBFT_block_gas.append(baseline_set_QBFT[i]["blocks"][key]["gasUsed"])
    for key in baseline_set_RAFT[i]["blocks"].keys():
        baseline_set_RAFT_block_gas.append(baseline_set_RAFT[i]["blocks"][key]["gasUsed"])

for i in range(1,12):
    i = str(i)
    for key in verify_IBFT[i]["blocks"].keys():
        verify_IBFT_block_gas.append(verify_IBFT[i]["blocks"][key]["gasUsed"])
    for key in verify_QBFT[i]["blocks"].keys():
        verify_QBFT_block_gas.append(verify_QBFT[i]["blocks"][key]["gasUsed"])
    for key in verify_RAFT[i]["blocks"].keys():
        verify_RAFT_block_gas.append(verify_RAFT[i]["blocks"][key]["gasUsed"])

for i in range(1,12):
    i = str(i)
    for key in request_IBFT[i]["blocks"].keys():
        request_IBFT_block_gas.append(request_IBFT[i]["blocks"][key]["gasUsed"])
    for key in request_QBFT[i]["blocks"].keys():
        request_QBFT_block_gas.append(request_QBFT[i]["blocks"][key]["gasUsed"])
    for key in request_RAFT[i]["blocks"].keys():
        request_RAFT_block_gas.append(request_RAFT[i]["blocks"][key]["gasUsed"])


print("\n\nBaseline | GET")
print(stats.mean(baseline_get_IBFT_block_gas))
print(stats.stdev(baseline_get_IBFT_block_gas))

print(stats.mean(baseline_get_QBFT_block_gas))
print(stats.stdev(baseline_get_QBFT_block_gas))

print(stats.mean(baseline_get_RAFT_block_gas))
print(stats.stdev(baseline_get_RAFT_block_gas))

print("\n\nBaseline | SET")
print(stats.mean(baseline_set_IBFT_block_gas))
print(stats.stdev(baseline_set_IBFT_block_gas))

print(stats.mean(baseline_set_QBFT_block_gas))
print(stats.stdev(baseline_set_QBFT_block_gas))

print(stats.mean(baseline_set_RAFT_block_gas))
print(stats.stdev(baseline_set_RAFT_block_gas))

print("\n\nVerify Access")
print(stats.mean(verify_IBFT_block_gas))
print(stats.stdev(verify_IBFT_block_gas))

print(stats.mean(verify_QBFT_block_gas))
print(stats.stdev(verify_QBFT_block_gas))

print(stats.mean(verify_RAFT_block_gas))
print(stats.stdev(verify_RAFT_block_gas))

print("\n\nRequest Access")
print(stats.mean(request_IBFT_block_gas))
print(stats.stdev(request_IBFT_block_gas))

print(stats.mean(request_QBFT_block_gas))
print(stats.stdev(request_QBFT_block_gas))

print(stats.mean(request_RAFT_block_gas))
print(stats.stdev(request_RAFT_block_gas))